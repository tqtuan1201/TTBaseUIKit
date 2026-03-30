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

// MARK: - TTDebugBridge
/// Singleton bridge that connects the iOS app to a macOS TTBDebugPlus instance.
/// Discovers the macOS service via Bonjour, establishes WebSocket, and sends logs.
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
        public var sdkVersion: String = "4.2.0"
        public var isEnabled: Bool = true
        
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
    }
    
    public private(set) var state: BridgeState = .idle
    public var onStateChange: ((BridgeState) -> Void)?
    
    // MARK: - Private
    private var browser: NWBrowser?
    /// Strong reference to the active NWConnection — ONLY mutated on `queue`
    private var connection: NWConnection?
    private var heartbeatTimer: Timer?
    private var reconnectAttempt: Int = 0
    /// Serial queue. ALL mutable state reads/writes happen here. No exceptions.
    private let queue = DispatchQueue(label: "com.ttbdebug.bridge", qos: .utility)
    private var messageBuffer: [Data] = []
    private let deviceId: String
    /// Monotonically increasing ID to track connection generations
    private var connectionGeneration: UInt64 = 0
    
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
            _updateState(.browsing)
            _startBrowsing()
            TTBaseFunc.shared.printLog(object: "[TTDebugBridge] 🔍 Started browsing for debug services...")
        }
    }
    
    public func stop() {
        queue.async { [self] in
            _teardownConnection()
            _stopBrowsing()
            messageBuffer.removeAll()
            reconnectAttempt = 0
            _updateState(.idle)
            DispatchQueue.main.async { [self] in
                heartbeatTimer?.invalidate()
                heartbeatTimer = nil
            }
            TTBaseFunc.shared.printLog(object: "[TTDebugBridge] ⏹ Bridge stopped")
        }
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
                TTBaseFunc.shared.printLog(object: "[TTDebugBridge] Browser ready")
            case .failed(let error):
                TTBaseFunc.shared.printLog(object: "[TTDebugBridge] Browser failed: \(error)")
                self.queue.async { self._scheduleReconnect() }
            default:
                break
            }
        }
        
        b.browseResultsChangedHandler = { [weak self] results, _ in
            guard let self = self else { return }
            self.queue.async {
                guard self.browser === b else { return }
                guard self.state == .browsing || self.state == .disconnected else { return }
                if let endpoint = results.first?.endpoint {
                    TTBaseFunc.shared.printLog(object: "[TTDebugBridge] 📡 Found service: \(endpoint)")
                    self._connect(to: endpoint)
                }
            }
        }
        
        self.browser = b
        b.start(queue: queue)
    }
    
    private func _stopBrowsing() {
        browser?.stateUpdateHandler = nil
        browser?.browseResultsChangedHandler = nil
        browser?.cancel()
        browser = nil
    }
    
    // MARK: - Private: Connection (queue)
    
    /// Tears down the current connection cleanly. Must be called on `queue`.
    private func _teardownConnection() {
        if let c = connection {
            c.stateUpdateHandler = nil
            c.cancel()
            connection = nil
        }
        connectionGeneration &+= 1
    }
    
    /// Establishes a new TCP connection. Must be called on `queue`.
    private func _connect(to endpoint: NWEndpoint) {
        // Clean up previous
        _teardownConnection()
        _updateState(.connecting)
        
        // Increment generation — used to discard stale callbacks
        let gen = connectionGeneration
        
        // Build parameters — raw TCP, no WebSocket (avoids HTTP upgrade crash on Bonjour endpoints)
        let tcp = NWProtocolTCP.Options()
        tcp.noDelay = true
        let params = NWParameters(tls: nil, tcp: tcp)
        params.includePeerToPeer = true
        
        let c = NWConnection(to: endpoint, using: params)
        self.connection = c
        
        c.stateUpdateHandler = { [weak self] nwState in
            // NWConnection delivers this on `queue` (we pass queue to start)
            guard let self = self else { return }
            // Discard if this is a stale connection from a previous generation
            guard self.connectionGeneration == gen else { return }
            
            switch nwState {
            case .setup:
                // Initial state before start() is called — no action needed
                TTBaseFunc.shared.printLog(object: "[TTDebugBridge] 🔧 Connection setup (pre-start)")
                
            case .preparing:
                // Actively resolving endpoint / performing TCP handshake
                TTBaseFunc.shared.printLog(object: "[TTDebugBridge] 🔄 Preparing connection (DNS resolve / TCP handshake)...")
                
            case .ready:
                TTBaseFunc.shared.printLog(object: "[TTDebugBridge] ✅ Connected!")
                self.reconnectAttempt = 0
                self._updateState(.connected)
                self._stopBrowsing()
                self._sendDeviceInfo()
                self._startHeartbeat()
                self._flushBuffer()
                self._receiveLoop(gen: gen)
                
            case .waiting(let error):
                // Path is not viable (e.g. no route, Wi-Fi off).
                // Teardown and schedule reconnect to try fresh later.
                TTBaseFunc.shared.printLog(object: "[TTDebugBridge] ⏳ Waiting (path not viable): \(error)")
                self._teardownConnection()
                self._updateState(.disconnected)
                self._scheduleReconnect()
                
            case .failed(let error):
                TTBaseFunc.shared.printLog(object: "[TTDebugBridge] ❌ Failed: \(error)")
                self._teardownConnection()
                self._updateState(.disconnected)
                self._scheduleReconnect()
                
            case .cancelled:
                TTBaseFunc.shared.printLog(object: "[TTDebugBridge] 🚫 Connection cancelled")
                // Only act if still the current generation
                if self.connectionGeneration == gen {
                    self.connection = nil
                    self._updateState(.disconnected)
                }
                
            @unknown default:
                // Future-proof: log any new states added by Apple
                TTBaseFunc.shared.printLog(object: "[TTDebugBridge] ⚠️ Unknown connection state: \(nwState)")
            }
        }
        
        c.start(queue: queue)
    }
    
    // MARK: - Private: Length-Prefixed Receive (queue)
    
    private func _receiveLoop(gen: UInt64) {
        guard let c = connection, connectionGeneration == gen else { return }
        
        // Read 4-byte length header
        c.receive(minimumIncompleteLength: 4, maximumLength: 4) { [weak self] header, _, _, error in
            guard let self = self, self.connectionGeneration == gen else { return }
            
            if let error = error {
                TTBaseFunc.shared.printLog(object: "[TTDebugBridge] Recv header error: \(error)")
                return
            }
            
            guard let header = header, header.count == 4 else {
                // Connection closed gracefully
                return
            }
            
            let length = header.withUnsafeBytes { $0.load(as: UInt32.self).bigEndian }
            guard length > 0, length < 10_000_000 else { return } // sanity: max 10MB
            
            // Read message body
            c.receive(minimumIncompleteLength: Int(length), maximumLength: Int(length)) { [weak self] body, _, _, error in
                guard let self = self, self.connectionGeneration == gen else { return }
                
                if let error = error {
                    TTBaseFunc.shared.printLog(object: "[TTDebugBridge] Recv body error: \(error)")
                    return
                }
                
                if let data = body, !data.isEmpty,
                   let msg = DebugMessage.from(data: data) {
                    self._handleIncoming(msg)
                }
                
                // Continue reading next message
                self._receiveLoop(gen: gen)
            }
        }
    }
    
    private func _handleIncoming(_ msg: DebugMessage) {
        switch msg.type {
        case .screenshotRequest:
            _handleScreenshot(msg)
        case .appCommand:
            _handleCommand(msg)
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
    
    // MARK: - Private: Device Info (main → queue)
    
    private func _sendDeviceInfo() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let device = UIDevice.current
            let screen = UIScreen.main
            let bundle = Bundle.main
            
            let payload = DeviceInfoPayload(
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
            self._enqueueMessage(type: .deviceInfo, payload: payload)
        }
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
            }
        }
    }
    
    // MARK: - Private: Reconnect (queue)
    
    private func _scheduleReconnect() {
        guard config.isEnabled, state != .idle else { return }
        
        reconnectAttempt += 1
        let delay = min(pow(2.0, Double(reconnectAttempt)), config.reconnectMaxDelay)
        TTBaseFunc.shared.printLog(object: "[TTDebugBridge] ⏳ Reconnecting in \(delay)s (attempt \(reconnectAttempt))...")
        
        queue.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self, self.state != .idle else { return }
            self._updateState(.browsing)
            self._startBrowsing()
        }
    }
    
    // MARK: - Private: Messaging (any thread → queue)
    
    /// Thread-safe entry point for sending messages. Encodes on caller thread, dispatches to queue.
    private func _enqueueMessage<T: Encodable>(type: MessageType, payload: T) {
        guard let msg = DebugMessage.create(type: type, payload: payload),
              let data = msg.toData() else { return }
        
        queue.async { [self] in
            if state == .connected, let c = connection {
                _sendData(data, on: c)
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
                TTBaseFunc.shared.printLog(object: "[TTDebugBridge] Send error: \(error)")
            }
        })
    }
    
    /// Flushes buffered messages. Must be called on `queue`.
    private func _flushBuffer() {
        guard let c = connection, !messageBuffer.isEmpty else { return }
        let buffered = messageBuffer
        messageBuffer.removeAll()
        for data in buffered {
            _sendData(data, on: c)
        }
        TTBaseFunc.shared.printLog(object: "[TTDebugBridge] 📤 Flushed \(buffered.count) buffered messages")
    }
    
    // MARK: - Private: State (queue)
    
    private func _updateState(_ s: BridgeState) {
        state = s
        DispatchQueue.main.async { [weak self] in
            self?.onStateChange?(s)
        }
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
