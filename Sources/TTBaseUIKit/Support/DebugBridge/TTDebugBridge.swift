//
//  TTDebugBridge.swift
//  TTBaseUIKit
//
//  Created by TuanTruong on 2026-03-27.
//  Main entry point for iOS → macOS debug communication
//

import Foundation
import Network
import UIKit
import os

// MARK: - DebugBridgeLog

/// Unified-logging output for the DebugBridge module, filterable in Console.app by subsystem
/// `com.ttbdebug.bridge` — separate from `TTBaseFunc.printLog` (SDK-wide, plain `print`, used
/// well beyond this module) so integrators can isolate DebugBridge diagnostics from the rest
/// of the app's log noise. Calls through to the existing `TTBaseFunc.printLog` too, so nothing
/// about current Xcode console output changes — this only adds a second, filterable channel.
enum DebugBridgeLog {
    private static let logger = Logger(subsystem: "com.ttbdebug.bridge", category: "connection")

    static func log(_ message: String) {
        TTBaseFunc.shared.printLog(object: message)
        logger.debug("\(message, privacy: .public)")
    }
}

// MARK: - RelayPairingInfo (Phase 8)

/// Parsed contents of a `ttbdebug://pair?type=relay&...` QR code — see
/// `TTDebugBridge.parseRelayPairingQR(_:)` / `applyRelayConfig(_:)`. `environment`/`token`/
/// `useTLS` are reserved for future use (multi-environment relay selection, authenticated
/// relays) — parsed and persisted today even though no behavior reads them yet, so a future
/// SDK version can start acting on them without requiring another QR format change.
public struct RelayPairingInfo: Codable, Equatable {
    public let host: String
    public let port: UInt16
    public let environment: String?
    public let token: String?
    public let useTLS: Bool?
    public let schemaVersion: Int

    public init(
        host: String,
        port: UInt16,
        environment: String? = nil,
        token: String? = nil,
        useTLS: Bool? = nil,
        schemaVersion: Int = 1
    ) {
        self.host = host
        self.port = port
        self.environment = environment
        self.token = token
        self.useTLS = useTLS
        self.schemaVersion = schemaVersion
    }
}

// MARK: - TTDebugBridge
/// Singleton bridge that connects the iOS app to macOS TTBDebugPlus instances.
/// Discovers macOS services via Bonjour, establishes TCP streams, and sends logs.
///
/// Usage:
/// ```swift
/// // In AppDelegate or LogViewHelper configuration
/// #if DEBUG
/// TTDebugBridge.shared.start()
/// #endif
/// ```
public final class TTDebugBridge {
    
    public static let shared = TTDebugBridge()
    
    // MARK: - Configuration
    public struct Config {
        public var serviceType: String = "_ttbdebug._tcp"
        public var serviceDomain: String = "local"
        public var heartbeatInterval: TimeInterval = 5.0
        public var reconnectMaxDelay: TimeInterval = 30.0
        public var maxBufferedMessages: Int = 200
        public var isShowMessageLog: Bool = false
        public var sdkVersion: String = "4.2.0"
        public var isEnabled: Bool = true
        
        /// Show an in-app toast (NoticeView) when the bridge connects or disconnects.
        /// Set to `false` to suppress the popup. Defaults to `true`.
        public var showStateNotice: Bool = true

        /// Optional Relay Server address (Phase 3) — set both to also connect to a relay
        /// alongside normal Bonjour discovery, for testers not on the same LAN as the Mac
        /// (remote/WFH). Get these from TTBDebugPlus → Settings → Relay → Relay Server.
        /// This is mechanically identical to calling `connectManually(host:port:)` yourself;
        /// it's just wired in automatically on `start()` for convenience.
        ///
        /// Instead of hardcoding these, consider `applyRelayConfig(fromQRPayload:)` (Phase 8) —
        /// scanned once from TTBDebugPlus's Settings QR, persisted across launches, changeable
        /// without a rebuild. Explicit values set here always take priority over a persisted
        /// scan (see `applyRelayConfig`'s docs).
        public var relayHost: String?
        public var relayPort: UInt16?

        public init() {}
    }

    public var config = Config()
    
    // MARK: - State
    public enum BridgeState: String, Sendable {
        case idle = "Idle"
        case browsing = "Browsing"
        case connecting = "Connecting"
        case connected = "Connected"
        case disconnected = "Disconnected"
        /// iOS denied (or hasn't yet granted) this app's "Local Network" privacy permission —
        /// Bonjour can never succeed until the user grants it in Settings. Distinct from
        /// `.disconnected` so UI can show a precise message + a direct link to Settings
        /// instead of the usual "check your Wi-Fi" hints.
        case permissionDenied = "Permission Denied"
    }
    
    public private(set) var state: BridgeState = .idle
    /// Single-slot callback — assigning it twice silently discards the first assignment. Fine
    /// for a single observer; if more than one part of your app needs to observe state, use
    /// `addStateObserver(_:)` instead (or `.ttDebugBridgeStateDidChange` via NotificationCenter,
    /// which this already posts alongside this closure).
    public var onStateChange: ((BridgeState) -> Void)?

    /// Independent observers, keyed by the token `addStateObserver` returns — unlike
    /// `onStateChange`, registering a second one doesn't discard the first. ONLY mutated on
    /// `queue`; `_updateState` reads it on `queue` too before hopping to main, so no lock needed.
    private var stateObservers: [UUID: (BridgeState) -> Void] = [:]

    /// Registers an additional state observer, called on the main thread alongside
    /// `onStateChange` on every state change. Returns a token — pass it to
    /// `removeStateObserver(_:)` to unregister.
    @discardableResult
    public func addStateObserver(_ observer: @escaping (BridgeState) -> Void) -> UUID {
        let token = UUID()
        queue.async { [self] in stateObservers[token] = observer }
        return token
    }

    /// Unregisters an observer previously added via `addStateObserver(_:)`. No-op if the token
    /// is unknown (already removed, or never registered).
    public func removeStateObserver(_ token: UUID) {
        queue.async { [self] in stateObservers.removeValue(forKey: token) }
    }

    /// Persisted across launches — true once this app has connected to TTBDebugPlus at least
    /// once. Lets UI (e.g. `DebugBridgeStatusView`'s first-run checklist) distinguish "never
    /// tried" from "used to work, currently disconnected".
    public var hasEverConnected: Bool {
        UserDefaults.standard.bool(forKey: Self.hasEverConnectedKey)
    }
    private static let hasEverConnectedKey = "TTDebugBridge.hasEverConnected"
    
    /// Current reconnect attempt count (exposed for diagnostics)
    public var currentReconnectAttempt: Int { reconnectAttempt }
    
    // MARK: - Private
    private var browser: NWBrowser?
    /// Strong references to active NWConnections keyed by Bonjour endpoint description.
    /// ONLY mutated on `queue`.
    private var connections: [String: NWConnection] = [:]
    private var readyEndpointKeys: Set<String> = []
    private var heartbeatTimer: Timer?
    private var reconnectAttempt: Int = 0
    /// Serial queue. ALL mutable state reads/writes happen here. No exceptions.
    private let queue = DispatchQueue(label: "com.ttbdebug.bridge", qos: .utility)
    private var messageBuffer: [Data] = []
    private let deviceId: String
    /// Monotonically increasing IDs to track connection generations per endpoint.
    private var connectionGenerations: [String: UInt64] = [:]
    /// Pending "still waiting after grace period" escalation, keyed by endpoint.
    /// `.waiting` is Network.framework's own signal that a path may recover on its
    /// own (brief Wi-Fi blip/AP roam) — we only escalate to teardown+reconnect if
    /// it hasn't resolved within `waitingGracePeriod`.
    private var waitingGraceWorkItems: [String: DispatchWorkItem] = [:]
    private static let waitingGracePeriod: TimeInterval = 8.0

    /// Last time a `heartbeat_ack` was received per ready endpoint. Only populated once an
    /// endpoint has proven it supports acks — an endpoint with no entry is either still
    /// waiting for its first ack or talking to a pre-2026-07-13 macOS app that never sends
    /// one, and is deliberately NOT enforced (backward compatibility). Only an endpoint that
    /// WAS acking and then goes silent is treated as stale.
    private var lastAckReceivedAt: [String: Date] = [:]
    /// heartbeat_ack must arrive within this many heartbeat intervals or the endpoint is
    /// dropped and reconnected — several multiples avoid false positives from an ack that's
    /// simply queued behind other traffic.
    private static let ackStaleMultiplier: Double = 3.0

    /// Network path monitor for detecting Wi-Fi / cellular / VPN changes
    private var pathMonitor: NWPathMonitor?
    private var lastPathStatus: NWPath.Status?
    /// Diagnostics timer — fires periodically while NOT connected
    private var diagnosticTimer: Timer?
    /// App foreground/background lifecycle observers (registered while started).
    private var appLifecycleObservers: [NSObjectProtocol] = []
    
    private init() {
        if let savedId = UserDefaults.standard.string(forKey: "TTDebugBridge.deviceId") {
            deviceId = savedId
        } else {
            let newId = UUID().uuidString
            UserDefaults.standard.set(newId, forKey: "TTDebugBridge.deviceId")
            deviceId = newId
        }
    }
    
    // MARK: - Public API
    
    public func start() {
        queue.async { [self] in
            guard config.isEnabled else { return }
            guard state == .idle || state == .disconnected else { return }
            _applyPersistedRelayConfigIfNeeded()
            _validateInfoPlistConfiguration()
            _updateState(.browsing)
            _startBrowsing()
            _startPathMonitor()
            _startDiagnosticTimer()
            _logNetworkInfo()
            DispatchQueue.main.async { [weak self] in
                self?._registerAppLifecycleObservers()
            }
            DebugBridgeLog.log("[TTDebugBridge] 🔍 Started browsing for debug services...")
        }
    }

    public func stop() {
        queue.async { [self] in
            _teardownConnection()
            _stopBrowsing()
            _stopPathMonitor()
            _stopDiagnosticTimer()
            messageBuffer.removeAll()
            reconnectAttempt = 0
            _updateState(.idle)
            DispatchQueue.main.async { [self] in
                heartbeatTimer?.invalidate()
                heartbeatTimer = nil
                _removeAppLifecycleObservers()
            }
            DebugBridgeLog.log("[TTDebugBridge] ⏹ Bridge stopped")
        }
    }

    // MARK: - Public API: Manual Connect (fallback when Bonjour/mDNS is blocked)

    /// Manually connect to a specific macOS instance by host/IP and port, bypassing Bonjour
    /// discovery entirely. Use as a fallback when mDNS is blocked (corporate networks, some
    /// VPNs/client-isolated Wi-Fi) — get the IP:port from TTBDebugPlus's Connection Health
    /// tab, or scan its QR code. Runs alongside normal Bonjour browsing, not instead of it —
    /// if Bonjour later finds a service too, both connections are kept (existing
    /// broadcast-to-all behavior).
    public func connectManually(host: String, port: UInt16) {
        start() // no-op if already browsing/connected; ensures path monitor + lifecycle observers are running
        queue.async { [self] in
            guard let nwPort = NWEndpoint.Port(rawValue: port) else {
                DebugBridgeLog.log("[TTDebugBridge] ⚠️ connectManually: invalid port \(port)")
                return
            }
            let endpoint = NWEndpoint.hostPort(host: NWEndpoint.Host(host), port: nwPort)
            DebugBridgeLog.log("[TTDebugBridge] 🎯 Manual connect requested: \(host):\(port)")
            _connect(to: endpoint)
        }
    }

    /// Parses a `ttbdebug://<host>:<port>` pairing string (as shown in TTBDebugPlus's QR
    /// code / manual-connect UI) and connects. Returns `false` if the string couldn't be parsed.
    @discardableResult
    public func connectManually(pairingString: String) -> Bool {
        guard let url = URL(string: pairingString.trimmingCharacters(in: .whitespacesAndNewlines)),
              url.scheme == "ttbdebug",
              let host = url.host,
              let port = url.port,
              port > 0, port <= Int(UInt16.max) else {
            DebugBridgeLog.log("[TTDebugBridge] ⚠️ connectManually: could not parse pairing string '\(pairingString)'")
            return false
        }
        connectManually(host: host, port: UInt16(port))
        return true
    }

    // MARK: - Public API: Dynamic Relay Configuration (QR)

    /// Parses a `ttbdebug://pair?type=relay&host=...&port=...` QR payload (Phase 8) — a
    /// SEPARATE format from the plain `ttbdebug://<host>:<port>` LAN-pairing QR above (that one
    /// is unchanged, still transient/non-persisted). `host` here is literally `"pair"` — a
    /// marker, not a real hostname — so the two formats never collide, and `type` leaves room
    /// for future non-relay pairing QRs without a new scheme. `env`/`token`/`ssl`/`protocol` are
    /// optional and currently just parsed and stored for forward compatibility — no behavior
    /// reads them yet.
    public static func parseRelayPairingQR(_ payload: String) -> RelayPairingInfo? {
        guard let components = URLComponents(string: payload.trimmingCharacters(in: .whitespacesAndNewlines)),
              components.scheme == "ttbdebug",
              components.host == "pair",
              let items = components.queryItems else { return nil }
        func value(_ name: String) -> String? { items.first(where: { $0.name == name })?.value }
        guard value("type") == "relay",
              let host = value("host"), !host.isEmpty,
              let portString = value("port"), let port = UInt16(portString) else { return nil }
        return RelayPairingInfo(
            host: host,
            port: port,
            environment: value("env"),
            token: value("token"),
            useTLS: value("ssl").map { $0 == "1" || $0.lowercased() == "true" },
            schemaVersion: value("v").flatMap { Int($0) } ?? 1
        )
    }

    /// Parses, applies, and PERSISTS relay config from a scanned QR — unlike
    /// `connectManually(pairingString:)`, this survives app restarts (see
    /// `_applyPersistedRelayConfigIfNeeded`, called from `start()`). Returns `false` if the
    /// payload isn't this format (not an error — callers should fall back to
    /// `connectManually(pairingString:)` for the older LAN-pairing QR format).
    @discardableResult
    public func applyRelayConfig(fromQRPayload payload: String) -> Bool {
        guard let info = Self.parseRelayPairingQR(payload) else { return false }
        applyRelayConfig(info)
        return true
    }

    /// Applies relay config directly (skip QR parsing) — e.g. if you already have a
    /// `RelayPairingInfo` from your own source. Explicit `config.relayHost`/`relayPort` set by
    /// the host app BEFORE this call are NOT overwritten by `_applyPersistedRelayConfigIfNeeded`
    /// on a later `start()`, but a direct call here always applies immediately, same as if the
    /// host app had set `config` itself.
    public func applyRelayConfig(_ info: RelayPairingInfo) {
        queue.async { [self] in
            let oldHost = config.relayHost
            let oldPort = config.relayPort
            config.relayHost = info.host
            config.relayPort = info.port
            _persistRelayPairingInfo(info)
            DebugBridgeLog.log("[TTDebugBridge] 🔀 Relay config updated via QR: \(info.host):\(info.port)")

            // If already running and the relay endpoint actually changed, drop the stale
            // connection explicitly instead of leaving it to linger until its own failure —
            // then reconnect to the new one right away rather than waiting for the next
            // natural re-browse.
            guard state != .idle, oldHost != info.host || oldPort != info.port else { return }
            if let oh = oldHost, let op = oldPort, let nwPort = NWEndpoint.Port(rawValue: op) {
                let oldKey = NWEndpoint.hostPort(host: NWEndpoint.Host(oh), port: nwPort).debugDescription
                _removeConnection(endpointKey: oldKey)
            }
            _connectToRelayIfConfigured()
        }
    }

    private static let relayPairingInfoKey = "TTDebugBridge.relayPairingInfo"

    private func _persistRelayPairingInfo(_ info: RelayPairingInfo) {
        guard let data = try? JSONEncoder().encode(info) else { return }
        UserDefaults.standard.set(data, forKey: Self.relayPairingInfoKey)
    }

    /// Only fills in `config.relayHost`/`relayPort` when the host app left them `nil` — explicit
    /// values the host app set in code always win over a previously-scanned QR. Called from the
    /// top of `start()`.
    private func _applyPersistedRelayConfigIfNeeded() {
        guard config.relayHost == nil || config.relayPort == nil else { return }
        guard let data = UserDefaults.standard.data(forKey: Self.relayPairingInfoKey),
              let info = try? JSONDecoder().decode(RelayPairingInfo.self, from: data) else { return }
        config.relayHost = info.host
        config.relayPort = info.port
        DebugBridgeLog.log("[TTDebugBridge] 🔀 Restored persisted relay config: \(info.host):\(info.port)")
    }

    // MARK: - Public API: Local Network Permission Priming

    /// Best-effort way to trigger iOS's system "Local Network" permission prompt at a moment
    /// YOU control — e.g. right after showing your own explainer screen — instead of it firing
    /// silently the first time `start()` browses in the background, with no context for the
    /// user. There's no direct iOS API to query permission status, so this works by starting a
    /// short-lived, throwaway Bonjour browse (separate from `start()`'s) and watching how it
    /// resolves:
    /// - `.failed` with the same "NoAuth" error `start()` already detects → denied (`false`)
    /// - reaches `.ready` without that error, or `timeout` elapses either way → not blocked
    ///   (`true`) — the browse is torn down either way before `completion` fires.
    /// Does not touch `state`/`onStateChange`. Safe to call before, after, or instead of
    /// `start()` — entirely independent of it.
    public func primeLocalNetworkPermission(timeout: TimeInterval = 5.0, completion: ((Bool) -> Void)? = nil) {
        queue.async { [self] in
            let params = NWParameters()
            params.includePeerToPeer = true
            let primer = NWBrowser(for: .bonjour(type: config.serviceType, domain: config.serviceDomain), using: params)

            var didFinish = false
            func finish(_ granted: Bool) {
                guard !didFinish else { return }
                didFinish = true
                primer.cancel()
                DispatchQueue.main.async { completion?(granted) }
            }

            primer.stateUpdateHandler = { [weak self] s in
                guard let self else { return }
                self.queue.async {
                    switch s {
                    case .ready:
                        finish(true)
                    case .failed(let error):
                        finish(!self._isLocalNetworkPermissionError(error))
                    default:
                        break
                    }
                }
            }
            primer.start(queue: queue)
            queue.asyncAfter(deadline: .now() + timeout) { finish(true) }
        }
    }

    // MARK: - Public Diagnostic API
    
    /// Prints a comprehensive diagnostic report to Xcode console.
    /// Call this manually to get a full connection status snapshot.
    public func printDiagnosticReport() {
        let snapshot = ConnectionDiagnostics.shared.captureSnapshot(from: self)
        let report = ConnectionDiagnostics.formatReport(snapshot)
        print(report)
    }
    
    /// Returns a diagnostic snapshot for programmatic use.
    public func getDiagnosticSnapshot() -> ConnectionDiagnostics.Snapshot {
        return ConnectionDiagnostics.shared.captureSnapshot(from: self)
    }
    
    public func sendAPILog(
        method: String,
        url: String,
        statusCode: Int,
        requestHeaders: [String: String] = [:],
        requestBody: String = "",
        responseHeaders: [String: String] = [:],
        responseBody: String = "",
        durationMs: Double = 0,
        sizeBytes: Int = 0
    ) {
        let payload = APILogPayload(
            id: UUID().uuidString,
            timestamp: Date().timeIntervalSince1970 * 1000,
            method: method, url: url, statusCode: statusCode,
            requestHeaders: requestHeaders, requestBody: requestBody,
            responseHeaders: responseHeaders, responseBody: responseBody,
            durationMs: durationMs, sizeBytes: sizeBytes
        )
        _enqueueMessage(type: .apiLog, payload: payload)
    }
    
    public func sendConsoleLog(
        level: String = "debug",
        subsystem: String = "app",
        message: String,
        sourceFile: String? = nil,
        sourceLine: Int? = nil
    ) {
        let payload = ConsoleLogPayload(
            id: UUID().uuidString,
            timestamp: Date().timeIntervalSince1970 * 1000,
            level: level, subsystem: subsystem, message: message,
            sourceFile: sourceFile, sourceLine: sourceLine,
            threadId: String(format: "0x%x", pthread_mach_thread_np(pthread_self()))
        )
        _enqueueMessage(type: .consoleLog, payload: payload)
    }
    
    public func sendPerformanceMetrics() {
        let cpu = _getCPUUsage()
        let mem = _getMemoryUsage()
        let disk = _getDiskUsage()
        let info = ProcessInfo.processInfo
        let payload = PerformanceMetricsPayload(
            cpuUsage: cpu, memoryUsedMB: mem,
            memoryTotalMB: Double(info.physicalMemory) / 1_048_576.0,
            fps: nil, diskUsedMB: disk,
            networkBytesSent: nil, networkBytesReceived: nil,
            timestamp: Date().timeIntervalSince1970 * 1000
        )
        _enqueueMessage(type: .performanceMetrics, payload: payload)
    }
    
    // MARK: - Private: Browsing (queue)
    
    private func _startBrowsing() {
        _stopBrowsing()
        
        let params = NWParameters()
        params.includePeerToPeer = true
        
        let b = NWBrowser(for: .bonjour(type: config.serviceType, domain: config.serviceDomain), using: params)
        
        b.stateUpdateHandler = { [weak self] s in
            guard let self = self else { return }
            switch s {
            case .ready:
                DebugBridgeLog.log("[TTDebugBridge] Browser ready")
            case .failed(let error):
                DebugBridgeLog.log("[TTDebugBridge] Browser failed: \(error)")
                self.queue.async {
                    if self._isLocalNetworkPermissionError(error) {
                        self._updateState(.permissionDenied)
                    }
                    self._scheduleReconnect()
                }
            default:
                break
            }
        }
        
        b.browseResultsChangedHandler = { [weak self] results, _ in
            guard let self = self else { return }
            self.queue.async {
                guard self.browser === b else { return }
                // Include .connecting — otherwise a stalled first candidate silently
                // blocks any other discovered endpoint from ever being tried.
                guard self.state == .browsing || self.state == .connecting
                        || self.state == .disconnected || self.state == .connected else { return }
                
                // Track browse results for diagnostics
                ConnectionDiagnostics.shared.recordBrowseResults(
                    count: results.count,
                    endpoint: results.first?.endpoint.debugDescription
                )
                
                for result in results {
                    let endpoint = result.endpoint
                    self._connect(to: endpoint)
                }
            }
        }
        
        self.browser = b
        b.start(queue: queue)

        // Every call site that re-browses (start, reconnect backoff, network-restore,
        // foreground-return) should also retry the relay if one is configured — folding it in
        // here means those 4 call sites don't each need their own copy of this. `_connect(to:)`
        // itself no-ops if this endpoint is already connected/connecting, so calling this
        // liberally is safe.
        _connectToRelayIfConfigured()
    }

    /// Must be called on `queue`. If `config.relayHost`/`relayPort` are set, also connects to
    /// the relay alongside normal Bonjour discovery — mechanically identical to a
    /// Bonjour-discovered endpoint from here on (same `_connect(to:)` pipeline, same
    /// broadcast-to-all behavior as any other simultaneously-ready connection).
    private func _connectToRelayIfConfigured() {
        guard let host = config.relayHost, let port = config.relayPort,
              let nwPort = NWEndpoint.Port(rawValue: port), !host.isEmpty else { return }
        let endpoint = NWEndpoint.hostPort(host: NWEndpoint.Host(host), port: nwPort)
        DebugBridgeLog.log("[TTDebugBridge] 🔀 Connecting to configured relay: \(host):\(port)")
        _connect(to: endpoint)
    }

    private func _stopBrowsing() {
        browser?.stateUpdateHandler = nil
        browser?.browseResultsChangedHandler = nil
        browser?.cancel()
        browser = nil
    }
    
    // MARK: - Private: Connection (queue)
    
    /// Tears down all current connections cleanly. Must be called on `queue`.
    private func _teardownConnection() {
        for (_, c) in connections {
            c.stateUpdateHandler = nil
            c.cancel()
        }
        connections.removeAll()
        readyEndpointKeys.removeAll()
        connectionGenerations.removeAll()
        waitingGraceWorkItems.values.forEach { $0.cancel() }
        waitingGraceWorkItems.removeAll()
        lastAckReceivedAt.removeAll()
    }
    
    /// Establishes a new TCP connection. Must be called on `queue`.
    private func _connect(to endpoint: NWEndpoint) {
        let endpointKey = endpoint.debugDescription
        guard connections[endpointKey] == nil else { return }
        
        DebugBridgeLog.log("[TTDebugBridge] 📡 Found service: \(endpoint)")
        
        if readyEndpointKeys.isEmpty {
            _updateState(.connecting)
        }
        
        // Increment generation — used to discard stale callbacks
        let gen = (connectionGenerations[endpointKey] ?? 0) &+ 1
        connectionGenerations[endpointKey] = gen
        
        // Build parameters — raw TCP, no WebSocket (avoids HTTP upgrade crash on Bonjour endpoints)
        let tcp = NWProtocolTCP.Options()
        tcp.noDelay = true
        // Match the macOS listener's keepalive so a half-dead socket (e.g. peer lost
        // power/network without a clean FIN) is detected by the OS within ~20s instead
        // of sitting silently "connected" until app-level heartbeat logic notices.
        tcp.enableKeepalive = true
        tcp.keepaliveIdle = 5
        tcp.keepaliveInterval = 3
        tcp.keepaliveCount = 5
        tcp.connectionTimeout = 10
        let params = NWParameters(tls: nil, tcp: tcp)
        params.includePeerToPeer = true
        
        let c = NWConnection(to: endpoint, using: params)
        connections[endpointKey] = c
        
        c.stateUpdateHandler = { [weak self] nwState in
            // NWConnection delivers this on `queue` (we pass queue to start)
            guard let self = self else { return }
            // Discard if this is a stale connection from a previous generation
            guard self.connectionGenerations[endpointKey] == gen else { return }
            
            switch nwState {
            case .setup:
                // Initial state before start() is called — no action needed
                DebugBridgeLog.log("[TTDebugBridge] 🔧 Connection setup (pre-start)")
                
            case .preparing:
                // Actively resolving endpoint / performing TCP handshake
                DebugBridgeLog.log("[TTDebugBridge] 🔄 Preparing connection (DNS resolve / TCP handshake)...")
                
            case .ready:
                DebugBridgeLog.log("[TTDebugBridge] ✅ Connected: \(endpoint)")
                self.reconnectAttempt = 0
                self.readyEndpointKeys.insert(endpointKey)
                // Recovered before the waiting-grace escalation fired — cancel it.
                self.waitingGraceWorkItems.removeValue(forKey: endpointKey)?.cancel()
                self._updateState(.connected)
                self._stopDiagnosticTimer() // No need for diagnostics while connected
                // Sent synchronously on `queue` first — guarantees device_info is the
                // first byte on the wire, before diagnostics/replay/heartbeat.
                self._sendDeviceInfo(to: endpointKey)
                self._sendConnectionDiagnostics(to: endpointKey) // Send diagnostic info to macOS
                self._startHeartbeat()
                self._replayBuffer(to: endpointKey)
                self._receiveLoop(endpointKey: endpointKey, gen: gen)

            case .waiting(let error):
                // Path is temporarily unsatisfied — Network.framework's own signal that
                // it may resolve on its own (brief Wi-Fi blip / AP roam). Give it a grace
                // period instead of tearing down immediately, which previously defeated
                // this built-in resilience and turned blips into full reconnect cycles.
                DebugBridgeLog.log("[TTDebugBridge] ⏳ Waiting (path not viable): \(error)")
                ConnectionDiagnostics.shared.recordEvent(state: "waiting", detail: "\(error)")
                self.waitingGraceWorkItems[endpointKey]?.cancel()
                let graceWork = DispatchWorkItem { [weak self] in
                    guard let self = self, self.connectionGenerations[endpointKey] == gen else { return }
                    self.waitingGraceWorkItems.removeValue(forKey: endpointKey)
                    DebugBridgeLog.log("[TTDebugBridge] ⏳ Still waiting after \(Int(Self.waitingGracePeriod))s grace — giving up on \(endpointKey)")
                    self._removeConnection(endpointKey: endpointKey)
                    if self.readyEndpointKeys.isEmpty {
                        self._updateState(.disconnected)
                        self._startDiagnosticTimer()
                        self._scheduleReconnect()
                    }
                }
                self.waitingGraceWorkItems[endpointKey] = graceWork
                self.queue.asyncAfter(deadline: .now() + Self.waitingGracePeriod, execute: graceWork)
                
            case .failed(let error):
                DebugBridgeLog.log("[TTDebugBridge] ❌ Failed: \(error)")
                ConnectionDiagnostics.shared.recordEvent(state: "failed", detail: "\(error)")
                self._removeConnection(endpointKey: endpointKey)
                if self.readyEndpointKeys.isEmpty {
                    self._updateState(self._isLocalNetworkPermissionError(error) ? .permissionDenied : .disconnected)
                    self._startDiagnosticTimer()
                    self._scheduleReconnect()
                }
                
            case .cancelled:
                DebugBridgeLog.log("[TTDebugBridge] 🚫 Connection cancelled")
                // Only act if still the current generation
                if self.connectionGenerations[endpointKey] == gen {
                    self._removeConnection(endpointKey: endpointKey)
                    if self.readyEndpointKeys.isEmpty {
                        self._updateState(.disconnected)
                    }
                }
                
            @unknown default:
                // Future-proof: log any new states added by Apple
                DebugBridgeLog.log("[TTDebugBridge] ⚠️ Unknown connection state: \(nwState)")
            }
        }
        
        c.start(queue: queue)
    }
    
    private func _removeConnection(endpointKey: String) {
        connections[endpointKey]?.stateUpdateHandler = nil
        connections[endpointKey]?.cancel()
        connections.removeValue(forKey: endpointKey)
        readyEndpointKeys.remove(endpointKey)
        connectionGenerations.removeValue(forKey: endpointKey)
        waitingGraceWorkItems.removeValue(forKey: endpointKey)?.cancel()
        lastAckReceivedAt.removeValue(forKey: endpointKey)
    }
    
    // MARK: - Private: Length-Prefixed Receive (queue)
    
    private func _receiveLoop(endpointKey: String, gen: UInt64) {
        guard let c = connections[endpointKey],
              connectionGenerations[endpointKey] == gen else { return }

        // Read 4-byte length header
        c.receive(minimumIncompleteLength: 4, maximumLength: 4) { [weak self] header, _, isComplete, error in
            guard let self = self, self.connectionGenerations[endpointKey] == gen else { return }

            if let error = error {
                self._handleReceiveLoopEnded(endpointKey: endpointKey, gen: gen, reason: "header read error: \(error)")
                return
            }

            guard let header = header, header.count == 4 else {
                if isComplete {
                    // Peer closed the socket gracefully — this MUST trigger reconnect,
                    // not just silently stop the loop (that used to leave the bridge
                    // stuck reporting .connected against a dead endpoint indefinitely).
                    self._handleReceiveLoopEnded(endpointKey: endpointKey, gen: gen, reason: "peer closed connection")
                } else {
                    // Transient empty read — keep waiting for the next chunk.
                    self._receiveLoop(endpointKey: endpointKey, gen: gen)
                }
                return
            }

            let length = header.withUnsafeBytes { $0.load(as: UInt32.self).bigEndian }
            guard length > 0, length < 10_000_000 else { // sanity: max 10MB
                self._handleReceiveLoopEnded(endpointKey: endpointKey, gen: gen, reason: "invalid message length \(length)")
                return
            }

            // Read message body
            c.receive(minimumIncompleteLength: Int(length), maximumLength: Int(length)) { [weak self] body, _, isComplete, error in
                guard let self = self, self.connectionGenerations[endpointKey] == gen else { return }

                if let error = error {
                    self._handleReceiveLoopEnded(endpointKey: endpointKey, gen: gen, reason: "body read error: \(error)")
                    return
                }

                guard let data = body, !data.isEmpty else {
                    if isComplete {
                        self._handleReceiveLoopEnded(endpointKey: endpointKey, gen: gen, reason: "peer closed mid-message")
                    } else {
                        self._receiveLoop(endpointKey: endpointKey, gen: gen)
                    }
                    return
                }

                if let msg = DebugMessage.from(data: data) {
                    self._handleIncoming(msg, from: endpointKey)
                } else {
                    DebugBridgeLog.log("[TTDebugBridge] ⚠️ Failed to decode DebugMessage (\(data.count) bytes) from \(endpointKey)")
                }

                // Continue reading next message
                self._receiveLoop(endpointKey: endpointKey, gen: gen)
            }
        }
    }

    /// The receive loop ended (peer closed, read error, or protocol violation).
    /// Must be called on `queue`. This is the fix for "no automatic reconnect" —
    /// previously these paths just stopped recursing with no state change.
    private func _handleReceiveLoopEnded(endpointKey: String, gen: UInt64, reason: String) {
        guard connectionGenerations[endpointKey] == gen else { return }
        DebugBridgeLog.log("[TTDebugBridge] 🔌 Receive loop ended for \(endpointKey): \(reason)")
        ConnectionDiagnostics.shared.recordEvent(state: "receiveLoopEnded", detail: reason)
        _removeConnection(endpointKey: endpointKey)
        if readyEndpointKeys.isEmpty {
            _updateState(.disconnected)
            _startDiagnosticTimer()
            _scheduleReconnect()
        }
    }
    
    /// Must be called on `queue` (delivered from `_receiveLoop`'s NWConnection.receive
    /// completion, which runs on `queue`).
    private func _handleIncoming(_ msg: DebugMessage, from endpointKey: String) {
        switch msg.type {
        case .screenshotRequest:
            _handleScreenshot(msg)
        case .appCommand:
            _handleCommand(msg)
        case .heartbeatAck:
            lastAckReceivedAt[endpointKey] = Date()
        default:
            break
        }
    }
    
    // MARK: - Private: Screenshot (main thread)
    
    private func _handleScreenshot(_ msg: DebugMessage) {
        guard let req = msg.decodePayload(ScreenshotRequestPayload.self) else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard let window = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?.windows.first else { return }
            
            let renderer = UIGraphicsImageRenderer(bounds: window.bounds)
            let image = renderer.image { _ in
                window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
            }
            
            var finalImage = image
            if let maxW = req.maxWidth, image.size.width > CGFloat(maxW) {
                let s = CGFloat(maxW) / image.size.width
                let sz = CGSize(width: image.size.width * s, height: image.size.height * s)
                UIGraphicsBeginImageContextWithOptions(sz, false, 1.0)
                image.draw(in: CGRect(origin: .zero, size: sz))
                finalImage = UIGraphicsGetImageFromCurrentImageContext() ?? image
                UIGraphicsEndImageContext()
            }
            
            if let jpeg = finalImage.jpegData(compressionQuality: req.quality) {
                let resp = ScreenshotResponsePayload(
                    imageData: jpeg.base64EncodedString(),
                    timestamp: Date().timeIntervalSince1970 * 1000,
                    screenWidth: Double(image.size.width),
                    screenHeight: Double(image.size.height),
                    orientation: UIDevice.current.orientation.isLandscape ? "landscape" : "portrait"
                )
                self._enqueueMessage(type: .screenshotResponse, payload: resp)
            }
        }
    }
    
    // MARK: - Private: App Command (main thread)
    
    private func _handleCommand(_ msg: DebugMessage) {
        guard let cmd = msg.decodePayload(AppCommandPayload.self) else { return }
        DispatchQueue.main.async {
            switch cmd.action {
            case "dark_mode_on":
                UIApplication.shared.connectedScenes
                    .compactMap { $0 as? UIWindowScene }
                    .flatMap { $0.windows }
                    .forEach { $0.overrideUserInterfaceStyle = .dark }
            case "dark_mode_off":
                UIApplication.shared.connectedScenes
                    .compactMap { $0 as? UIWindowScene }
                    .flatMap { $0.windows }
                    .forEach { $0.overrideUserInterfaceStyle = .light }
            default:
                break
            }
        }
    }
    
    // MARK: - Private: Device Info (queue, blocks briefly on main for UIKit reads)

    /// Must be called on `queue`. Sends synchronously (not via `_enqueueMessage`'s
    /// async hop) so device_info is guaranteed to be the first byte on the wire —
    /// previously this hopped to main async, so buffered replay / diagnostics
    /// (which run synchronously on `queue`) could reach macOS first, violating the
    /// handshake order macOS's WebSocketServer assumes.
    private func _sendDeviceInfo(to endpointKey: String) {
        let payload: DeviceInfoPayload = DispatchQueue.main.sync {
            let device = UIDevice.current
            let screen = UIScreen.main
            let bundle = Bundle.main
            return DeviceInfoPayload(
                deviceId: self.deviceId,
                deviceName: device.name,
                osVersion: "\(device.systemName) \(device.systemVersion)",
                appName: bundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
                    ?? bundle.object(forInfoDictionaryKey: "CFBundleName") as? String
                    ?? "Unknown",
                appVersion: bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.0",
                sdkVersion: self.config.sdkVersion,
                isSimulator: {
                    #if targetEnvironment(simulator)
                    return true
                    #else
                    return false
                    #endif
                }(),
                screenWidth: Double(screen.bounds.width * screen.scale),
                screenHeight: Double(screen.bounds.height * screen.scale)
            )
        }
        guard let msg = DebugMessage.create(type: .deviceInfo, payload: payload),
              let data = msg.toData(),
              let c = connections[endpointKey] else { return }
        _sendData(data, on: c)
    }
    
    // MARK: - Private: Heartbeat (main thread timer)
    
    private func _startHeartbeat() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.heartbeatTimer?.invalidate()
            self.heartbeatTimer = Timer.scheduledTimer(
                withTimeInterval: self.config.heartbeatInterval,
                repeats: true
            ) { [weak self] _ in
                self?.sendPerformanceMetrics()
                let hb = HeartbeatPayload(uptimeSeconds: ProcessInfo.processInfo.systemUptime)
                self?._enqueueMessage(type: .heartbeat, payload: hb)
                self?.queue.async { self?._checkAckStaleness() }
            }
        }
    }

    // MARK: - Private: Heartbeat ACK Watchdog (queue)

    /// Must be called on `queue`. Any ready endpoint that HAS previously proven ack support
    /// (an entry exists in `lastAckReceivedAt`) but hasn't produced a fresh `heartbeat_ack`
    /// within `ackStaleMultiplier × heartbeatInterval` is dropped and reconnected. This closes
    /// the "fire-and-forget" gap where TCP still reports `.ready` but the peer has stopped
    /// actually processing our messages — e.g. a hung macOS app, or a one-sided network
    /// blackhole that TCP keepalive hasn't caught yet. Endpoints that have never produced an
    /// ack (still in grace, or talking to a pre-2026-07-13 macOS app that doesn't send one)
    /// are deliberately left alone for backward compatibility.
    private func _checkAckStaleness() {
        guard !readyEndpointKeys.isEmpty else { return }
        let staleThreshold = config.heartbeatInterval * Self.ackStaleMultiplier
        let now = Date()
        let staleKeys = readyEndpointKeys.filter { key in
            guard let last = lastAckReceivedAt[key] else { return false }
            return now.timeIntervalSince(last) > staleThreshold
        }
        guard !staleKeys.isEmpty else { return }

        for key in staleKeys {
            DebugBridgeLog.log("[TTDebugBridge] 💔 No heartbeat_ack for \(Int(staleThreshold))s on \(key) — treating as stale, reconnecting")
            ConnectionDiagnostics.shared.recordEvent(state: "ackStale", detail: "no heartbeat_ack for \(Int(staleThreshold))s")
            _removeConnection(endpointKey: key)
        }
        if readyEndpointKeys.isEmpty {
            _updateState(.disconnected)
            _startDiagnosticTimer()
            _scheduleReconnect()
        }
    }

    // MARK: - Private: Reconnect (queue)
    
    private func _scheduleReconnect() {
        guard config.isEnabled, state != .idle else { return }
        
        reconnectAttempt += 1
        let delay = min(pow(2.0, Double(reconnectAttempt)), config.reconnectMaxDelay)
        DebugBridgeLog.log("[TTDebugBridge] ⏳ Reconnecting in \(delay)s (attempt \(reconnectAttempt))...")
        
        queue.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self, self.state != .idle else { return }
            self._updateState(.browsing)
            self._startBrowsing()
        }
    }
    
    // MARK: - Private: Messaging (any thread → queue)
    
    /// Thread-safe entry point for sending messages. Encodes on caller thread, dispatches to queue.
    private func _enqueueMessage<T: Encodable>(type: MessageType, payload: T, targetEndpointKey: String? = nil) {
        guard let msg = DebugMessage.create(type: type, payload: payload),
              let data = msg.toData() else { return }
        
        queue.async { [self] in
            if let targetEndpointKey {
                if let c = connections[targetEndpointKey] {
                    _sendData(data, on: c)
                }
            } else if state == .connected, !readyEndpointKeys.isEmpty {
                for key in readyEndpointKeys {
                    guard let c = connections[key] else { continue }
                    _sendData(data, on: c)
                }
            } else {
                messageBuffer.append(data)
                if messageBuffer.count > config.maxBufferedMessages {
                    messageBuffer.removeFirst()
                }
            }
        }
    }
    
    /// Sends length-prefixed data over TCP. Must be called on `queue`.
    private func _sendData(_ data: Data, on c: NWConnection) {
        // 4-byte big-endian length prefix + payload
        var length = UInt32(data.count).bigEndian
        var frame = Data(bytes: &length, count: 4)
        frame.append(data)
        c.send(content: frame, completion: .contentProcessed { error in
            if let error = error {
                DebugBridgeLog.log("[TTDebugBridge] Send error: \(error)")
            }
        })
    }
    
    /// Replays buffered messages to one newly ready observer. Must be called on `queue`.
    private func _replayBuffer(to endpointKey: String) {
        guard let c = connections[endpointKey], !messageBuffer.isEmpty else { return }
        let count = messageBuffer.count
        for data in messageBuffer {
            _sendData(data, on: c)
        }
        // Must clear after replay — otherwise every subsequent reconnect re-sends
        // this entire backlog again (duplicated stale logs/heartbeats indefinitely).
        messageBuffer.removeAll()
        DebugBridgeLog.log("[TTDebugBridge] 📤 Replayed \(count) buffered messages")
    }
    
    // MARK: - Private: State (queue)
    
    private func _updateState(_ s: BridgeState) {
        
        let isChanged = (self.state != s)
        self.state = s
        if s == .connected {
            UserDefaults.standard.set(true, forKey: Self.hasEverConnectedKey)
        }
        ConnectionDiagnostics.shared.recordStateChange(s)
        // Snapshot while still on `queue` — same thread `stateObservers` is mutated on, so
        // this read needs no lock. The snapshot array itself is safe to use from main after.
        let observers = Array(stateObservers.values)
        DispatchQueue.main.async { [weak self] in
            self?.onStateChange?(s)
            observers.forEach { $0(s) }
            // Also post notification so overlay and other observers can listen
            // without overwriting the onStateChange callback
            NotificationCenter.default.post(
                name: .ttDebugBridgeStateDidChange,
                object: self,
                userInfo: ["state": s.rawValue]
            )
            
            if TTDebugBridge.shared.config.isShowMessageLog {
                DispatchQueue.main.async {
                    if isChanged, self?.config.showStateNotice == true {
                        if s == .connected {
                            UIApplication.topViewController()?.onShowNoticeView(title: "🖥 TTDebugBridge", body: "Connected successfully to macOS TTBDebugPlus!", style: .SUCCESS)
                        } else if s == .disconnected {
                            UIApplication.topViewController()?.onShowNoticeView(title: "🖥 TTDebugBridge", body: "Connection failed or disconnected.", style: .WARNING)
                        }
                    }
                }
            }

        }
    }
    
    // MARK: - Private: Network Path Monitor
    
    private func _startPathMonitor() {
        _stopPathMonitor()
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            let status: String
            switch path.status {
            case .satisfied: status = "satisfied"
            case .unsatisfied: status = "unsatisfied"
            case .requiresConnection: status = "requiresConnection"
            @unknown default: status = "unknown"
            }

            let interfaces = path.availableInterfaces.map { $0.debugDescription }.joined(separator: ", ")
            ConnectionDiagnostics.shared.recordEvent(
                state: "network",
                detail: "path=\(status) interfaces=[\(interfaces)]"
            )

            // Delivered on `queue` (monitor.start(queue:) below) — safe to touch state directly.
            let wasSatisfied = self.lastPathStatus == .satisfied
            self.lastPathStatus = path.status

            if path.status == .unsatisfied {
                DebugBridgeLog.log("[TTDebugBridge] 🔄 Network path lost — Wi-Fi disconnected?")
                // Previously this only logged — a connection pointed at a now-unreachable
                // interface could sit "connected" for a long time. Proactively drop it.
                if !self.connections.isEmpty {
                    self._teardownConnection()
                    self._updateState(.disconnected)
                    self._startDiagnosticTimer()
                }
            } else if path.status == .satisfied, !wasSatisfied,
                      self.config.isEnabled, self.state != .idle, self.readyEndpointKeys.isEmpty {
                // Network just came back (Wi-Fi rejoin / network switch) — rebrowse now
                // instead of waiting out the exponential backoff timer.
                DebugBridgeLog.log("[TTDebugBridge] 🔄 Network path restored — rebrowsing now")
                self.reconnectAttempt = 0
                self._updateState(.browsing)
                self._startBrowsing()
            }
        }
        monitor.start(queue: queue)
        pathMonitor = monitor
    }

    private func _stopPathMonitor() {
        pathMonitor?.cancel()
        pathMonitor = nil
        lastPathStatus = nil
    }

    // MARK: - Private: App Foreground/Background Lifecycle

    private func _registerAppLifecycleObservers() {
        _removeAppLifecycleObservers()
        let nc = NotificationCenter.default
        let didBecomeActive = nc.addObserver(
            forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main
        ) { [weak self] _ in
            self?._handleAppDidBecomeActive()
        }
        let didEnterBackground = nc.addObserver(
            forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main
        ) { [weak self] _ in
            self?._handleAppDidEnterBackground()
        }
        appLifecycleObservers = [didBecomeActive, didEnterBackground]
    }

    private func _removeAppLifecycleObservers() {
        let nc = NotificationCenter.default
        for token in appLifecycleObservers { nc.removeObserver(token) }
        appLifecycleObservers.removeAll()
    }

    private func _handleAppDidEnterBackground() {
        queue.async { [weak self] in
            guard let self = self else { return }
            DebugBridgeLog.log("[TTDebugBridge] 📱 App entered background")
            ConnectionDiagnostics.shared.recordEvent(state: "lifecycle", detail: "app entered background")
        }
    }

    private func _handleAppDidBecomeActive() {
        queue.async { [weak self] in
            guard let self = self else { return }
            guard self.config.isEnabled, self.state != .idle else { return }
            DebugBridgeLog.log("[TTDebugBridge] 📱 App became active — verifying connection")
            ConnectionDiagnostics.shared.recordEvent(state: "lifecycle", detail: "app became active")
            // The connection may have gone stale while suspended (OS often doesn't
            // deliver network callbacks promptly to a backgrounded process). If we
            // have no ready endpoint, force a fresh browse rather than waiting for
            // backoff or a keepalive probe to eventually notice.
            if self.readyEndpointKeys.isEmpty {
                self.reconnectAttempt = 0
                self._updateState(.browsing)
                self._startBrowsing()
            }
        }
    }
    
    // MARK: - Private: Diagnostic Timer
    
    /// Fires every 30s while not connected to print a diagnostic summary.
    private func _startDiagnosticTimer() {
        _stopDiagnosticTimer()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.diagnosticTimer?.invalidate()
            self.diagnosticTimer = Timer.scheduledTimer(
                withTimeInterval: 30.0,
                repeats: true
            ) { [weak self] _ in
                guard let self = self else { return }
                guard self.state != .connected && self.state != .idle else { return }
                self._printDiagnosticSummary()
            }
        }
    }
    
    private func _stopDiagnosticTimer() {
        DispatchQueue.main.async { [weak self] in
            self?.diagnosticTimer?.invalidate()
            self?.diagnosticTimer = nil
        }
    }
    
    private func _printDiagnosticSummary() {
        let snapshot = ConnectionDiagnostics.shared.captureSnapshot(from: self)
        let durationStr = String(format: "%.0fs", snapshot.stateDuration)
        
        var lines: [String] = []
        lines.append("[TTDebugBridge] ──── Connection Diagnostic ────")
        lines.append("  State: \(snapshot.bridgeState.rawValue.uppercased()) (\(durationStr))")
        
        let wifiStatus = snapshot.wifiConnected ? "✅" : "❌"
        let ipInfo = snapshot.localIP ?? "N/A"
        lines.append("  Wi-Fi: \(wifiStatus) \(ipInfo)")
        
        if snapshot.vpnActive {
            lines.append("  VPN: ⚠️ Active")
        }
        
        lines.append("  Browser: \(snapshot.browseResultCount) services found")
        
        // Add a contextual hint
        switch snapshot.bridgeState {
        case .browsing where snapshot.browseResultCount == 0:
            lines.append("  Hint: Ensure TTBDebugPlus is running on Mac")
        case .disconnected:
            lines.append("  Hint: Reconnect attempt #\(snapshot.reconnectAttempt)")
        default:
            break
        }
        
        lines.append("[TTDebugBridge] ────────────────────────────────")
        
        DebugBridgeLog.log(lines.joined(separator: "\n"))
    }
    
    // MARK: - Public: Info.plist Self-Check

    /// Checks the host app's Info.plist for the two keys Bonjour discovery requires. Returns
    /// a list of problem descriptions (empty = correctly configured). Safe to call from any
    /// thread — reads `Bundle.main.infoDictionary` only. Exposed publicly so UI (e.g.
    /// `DebugBridgeStatusView`'s first-run checklist) can show a live ✓/✗ without duplicating
    /// this logic.
    public func checkInfoPlistConfiguration() -> [String] {
        let info = Bundle.main.infoDictionary ?? [:]
        var problems: [String] = []

        let bonjourServices = info["NSBonjourServices"] as? [String] ?? []
        if !bonjourServices.contains(config.serviceType) {
            problems.append("Missing/incorrect \"NSBonjourServices\" (must include \"\(config.serviceType)\")")
        }
        if (info["NSLocalNetworkUsageDescription"] as? String)?.isEmpty ?? true {
            problems.append("Missing \"NSLocalNetworkUsageDescription\"")
        }
        return problems
    }

    // MARK: - Private: Info.plist Self-Check

    /// Missing `NSBonjourServices`/`NSLocalNetworkUsageDescription` makes `NWBrowser` fail with
    /// a generic network error a few seconds later — indistinguishable from "no Mac on the
    /// network" or "mDNS blocked". This turns that into a loud, actionable warning at the
    /// moment `start()` is called, naming exactly what's missing and what to paste.
    private func _validateInfoPlistConfiguration() {
        let problems = checkInfoPlistConfiguration()
        guard !problems.isEmpty else { return }

        DebugBridgeLog.log("""
        [TTDebugBridge] ⚠️⚠️⚠️ Info.plist is not configured for Bonjour discovery — the bridge \
        will NEVER find TTBDebugPlus until this is fixed:
          • \(problems.joined(separator: "\n  • "))
        Add this to your app's Info.plist:
          <key>NSLocalNetworkUsageDescription</key>
          <string>Required for connecting to TTBDebugPlus on macOS to stream debug logs.</string>
          <key>NSBonjourServices</key>
          <array>
              <string>\(config.serviceType)</string>
          </array>
        """)
    }

    // MARK: - Private: Local Network Permission Detection

    /// `kDNSServiceErr_NoAuth` (-65555) — Bonjour's signal that this app's "Local Network"
    /// privacy permission is denied (or not yet decided). Checked explicitly so this can be
    /// surfaced as `.permissionDenied` instead of the generic `.disconnected`.
    private static let dnsServiceErrNoAuth: Int32 = -65555

    private func _isLocalNetworkPermissionError(_ error: NWError) -> Bool {
        if case .dns(let code) = error {
            return code == Self.dnsServiceErrNoAuth
        }
        return false
    }

    // MARK: - Private: Initial Network Info Log

    private func _logNetworkInfo() {
        let ip = NetworkDiagnosticUtils.getLocalIPAddress() ?? "N/A"
        let vpn = NetworkDiagnosticUtils.isVPNActive() ? " | VPN: ⚠️ Active" : ""
        let prefix = NetworkDiagnosticUtils.getNetworkPrefix() ?? "N/A"
        DebugBridgeLog.log("[TTDebugBridge] 📡 Network: IP=\(ip) Subnet=\(prefix)\(vpn)")
    }
    
    // MARK: - Private: Send Diagnostics to macOS
    
    private func _sendConnectionDiagnostics(to endpointKey: String) {
        let payload = ConnectionDiagnosticsPayload(
            localIP: NetworkDiagnosticUtils.getLocalIPAddress(),
            subnetMask: NetworkDiagnosticUtils.getSubnetMask(),
            networkPrefix: NetworkDiagnosticUtils.getNetworkPrefix(),
            isVPN: NetworkDiagnosticUtils.isVPNActive(),
            isWiFi: NetworkDiagnosticUtils.isWiFiConnected(),
            sdkVersion: config.sdkVersion,
            connectionAttempts: reconnectAttempt,
            stateDurationSeconds: Date().timeIntervalSince(ConnectionDiagnostics.shared.stateEnteredAt)
        )
        _enqueueMessage(type: .connectionDiagnostics, payload: payload, targetEndpointKey: endpointKey)
    }
    
    // MARK: - Private: System Metrics (safe from any thread)
    
    private func _getCPUUsage() -> Double {
        var threadList: thread_act_array_t?
        var threadCount = mach_msg_type_number_t()
        guard task_threads(mach_task_self_, &threadList, &threadCount) == KERN_SUCCESS,
              let threads = threadList else { return 0 }
        
        var total: Double = 0
        for i in 0..<Int(threadCount) {
            var info = thread_basic_info()
            var count = mach_msg_type_number_t(MemoryLayout<thread_basic_info>.size / MemoryLayout<Int32>.size)
            let r = withUnsafeMutablePointer(to: &info) {
                $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                    thread_info(threads[i], thread_flavor_t(THREAD_BASIC_INFO), $0, &count)
                }
            }
            if r == KERN_SUCCESS {
                total += Double(info.cpu_usage) / Double(TH_USAGE_SCALE) * 100.0
            }
        }
        
        vm_deallocate(mach_task_self_,
                      vm_address_t(bitPattern: threadList),
                      vm_size_t(threadCount * UInt32(MemoryLayout<thread_t>.size)))
        return total
    }
    
    private func _getMemoryUsage() -> Double {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
        let r = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        return r == KERN_SUCCESS ? Double(info.resident_size) / 1_048_576.0 : 0
    }
    
    private func _getDiskUsage() -> Double? {
        guard let a = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()),
              let total = a[.systemSize] as? Int64,
              let free = a[.systemFreeSize] as? Int64 else { return nil }
        return Double(total - free) / 1_048_576.0
    }
}
