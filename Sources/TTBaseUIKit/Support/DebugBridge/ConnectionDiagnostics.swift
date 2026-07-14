//
//  ConnectionDiagnostics.swift
//  TTBaseUIKit
//
//  Created by TuanTruong on 2026-03-30.
//  Diagnostic model + formatted report for TTDebugBridge connection issues
//

import Foundation
import Network

// MARK: - Connection Diagnostics
/// Collects and formats diagnostic information about the TTDebugBridge connection.
/// Used to help iOS developers troubleshoot why their app isn't connecting to TTBDebugPlus.
public final class ConnectionDiagnostics {
    
    // MARK: - Diagnostic Snapshot
    
    public struct Snapshot {
        // Network
        public let wifiConnected: Bool
        public let localIP: String?
        public let subnetMask: String?
        public let networkPrefix: String?
        public let vpnActive: Bool
        
        // Bridge state
        public let bridgeState: TTDebugBridge.BridgeState
        public let stateDuration: TimeInterval
        public let reconnectAttempt: Int
        
        // Bonjour
        public let browseResultCount: Int
        public let lastFoundEndpoint: String?

        // Relay (Phase 9) — nil when no relay is configured (`config.relayHost`/`relayPort`),
        // regardless of whether it's actually connected right now (that's `bridgeState`/
        // `readyEndpointKeys`, not exposed per-endpoint here — this just says "is one set up").
        public let configuredRelayHost: String?
        public let configuredRelayPort: UInt16?

        // SDK
        public let sdkVersion: String
        public let isEnabled: Bool
        
        // History
        public let recentEvents: [DiagnosticEvent]
    }
    
    public struct DiagnosticEvent {
        public let timestamp: Date
        public let state: String
        public let detail: String
        
        public var formattedTime: String {
            let f = DateFormatter()
            f.dateFormat = "HH:mm:ss.SSS"
            return f.string(from: timestamp)
        }
    }
    
    // MARK: - Singleton
    
    static let shared = ConnectionDiagnostics()
    
    // MARK: - State Tracking
    
    private(set) var stateEnteredAt: Date = Date()
    private(set) var browseResultCount: Int = 0
    private(set) var lastFoundEndpoint: String?
    private(set) var eventHistory: [DiagnosticEvent] = []
    
    private let maxHistoryEvents = 50
    private let lock = NSLock()
    
    private init() {}
    
    // MARK: - Record Events
    
    func recordStateChange(_ state: TTDebugBridge.BridgeState, detail: String = "") {
        lock.lock()
        defer { lock.unlock() }
        
        stateEnteredAt = Date()
        let event = DiagnosticEvent(
            timestamp: Date(),
            state: state.rawValue,
            detail: detail
        )
        eventHistory.append(event)
        if eventHistory.count > maxHistoryEvents {
            eventHistory.removeFirst()
        }
    }
    
    func recordBrowseResults(count: Int, endpoint: String?) {
        lock.lock()
        defer { lock.unlock() }
        
        browseResultCount = count
        if let ep = endpoint {
            lastFoundEndpoint = ep
        }
    }
    
    func recordEvent(state: String, detail: String) {
        lock.lock()
        defer { lock.unlock() }
        
        let event = DiagnosticEvent(timestamp: Date(), state: state, detail: detail)
        eventHistory.append(event)
        if eventHistory.count > maxHistoryEvents {
            eventHistory.removeFirst()
        }
    }
    
    // MARK: - Capture Snapshot
    
    func captureSnapshot(from bridge: TTDebugBridge) -> Snapshot {
        lock.lock()
        let duration = Date().timeIntervalSince(stateEnteredAt)
        let resultCount = browseResultCount
        let endpoint = lastFoundEndpoint
        let events = Array(eventHistory.suffix(10))
        lock.unlock()
        
        return Snapshot(
            wifiConnected: NetworkDiagnosticUtils.isWiFiConnected(),
            localIP: NetworkDiagnosticUtils.getLocalIPAddress(),
            subnetMask: NetworkDiagnosticUtils.getSubnetMask(),
            networkPrefix: NetworkDiagnosticUtils.getNetworkPrefix(),
            vpnActive: NetworkDiagnosticUtils.isVPNActive(),
            bridgeState: bridge.state,
            stateDuration: duration,
            reconnectAttempt: bridge.currentReconnectAttempt,
            browseResultCount: resultCount,
            lastFoundEndpoint: endpoint,
            configuredRelayHost: bridge.config.relayHost,
            configuredRelayPort: bridge.config.relayPort,
            sdkVersion: bridge.config.sdkVersion,
            isEnabled: bridge.config.isEnabled,
            recentEvents: events
        )
    }
    
    // MARK: - Formatted Report
    
    /// Generates a formatted diagnostic report for Xcode console output.
    public static func formatReport(_ snapshot: Snapshot) -> String {
        var lines: [String] = []
        
        lines.append("═══════════════════════════════════════════════════")
        lines.append("🔌 TTDebugBridge — Connection Diagnostics")
        lines.append("═══════════════════════════════════════════════════")
        
        // Status
        let stateIcon = iconForState(snapshot.bridgeState)
        let durationStr = String(format: "%.1fs", snapshot.stateDuration)
        lines.append("\(stateIcon) Status:        \(snapshot.bridgeState.rawValue.uppercased()) (\(durationStr) in this state)")
        
        // Network
        let wifiIcon = snapshot.wifiConnected ? "✅" : "❌"
        lines.append("📡 Wi-Fi:         \(wifiIcon) \(snapshot.wifiConnected ? "Connected" : "Not connected")")
        
        if let ip = snapshot.localIP {
            lines.append("🌐 Local IP:      \(ip)")
        }
        if let prefix = snapshot.networkPrefix {
            lines.append("🔍 Subnet:        \(prefix)")
        }
        if snapshot.vpnActive {
            lines.append("🛡 VPN:           ⚠️ Active (may block mDNS)")
        }
        
        // SDK
        lines.append("📦 SDK:           v\(snapshot.sdkVersion)")
        lines.append("⚙️ Enabled:       \(snapshot.isEnabled ? "Yes" : "No")")
        
        // Bonjour
        if snapshot.browseResultCount > 0 {
            lines.append("🔎 Services:      \(snapshot.browseResultCount) found")
        }
        if let ep = snapshot.lastFoundEndpoint {
            lines.append("📍 Endpoint:      \(ep)")
        }
        
        // Diagnostic hints
        let hints = generateHints(snapshot)
        if !hints.isEmpty {
            lines.append("")
            lines.append("💡 DIAGNOSTIC:")
            for hint in hints {
                lines.append("   \(hint)")
            }
        }
        
        // Next steps
        let steps = generateNextSteps(snapshot)
        if !steps.isEmpty {
            lines.append("")
            lines.append("   ➡️ Next steps:")
            for (i, step) in steps.enumerated() {
                lines.append("   \(i + 1). \(step)")
            }
        }
        
        lines.append("═══════════════════════════════════════════════════")
        
        return lines.joined(separator: "\n")
    }
    
    // MARK: - Hint Generation
    
    private static func iconForState(_ state: TTDebugBridge.BridgeState) -> String {
        switch state {
        case .idle: return "⏸"
        case .browsing: return "🔍"
        case .connecting: return "🔄"
        case .connected: return "✅"
        case .disconnected: return "❌"
        case .permissionDenied: return "🔒"
        }
    }
    
    private static func generateHints(_ s: Snapshot) -> [String] {
        var hints: [String] = []
        
        if !s.isEnabled {
            hints.append("Bridge is DISABLED. Set config.isEnabled = true")
        }
        
        if !s.wifiConnected {
            hints.append("⚠️ No Wi-Fi connection detected")
            hints.append("   Connect to a Wi-Fi network to enable Bonjour discovery")
        }
        
        if s.vpnActive {
            hints.append("⚠️ VPN is active — this may block Bonjour/mDNS (port 5353)")
        }
        
        switch s.bridgeState {
        case .idle:
            hints.append("Bridge hasn't started. Call TTDebugBridge.shared.start()")
            
        case .browsing:
            if s.stateDuration > 15 && s.browseResultCount == 0 {
                hints.append("⚠️ No macOS service found after \(Int(s.stateDuration))s")
                hints.append("   • TTBDebugPlus may not be running on Mac")
                hints.append("   • Devices may be on different Wi-Fi networks")
                hints.append("   • Corporate firewall may be blocking mDNS")
            }
            
        case .connecting:
            if s.stateDuration > 10 {
                hints.append("⚠️ Connection taking too long (\(Int(s.stateDuration))s)")
                hints.append("   TCP handshake may be blocked by firewall")
            }
            
        case .connected:
            hints.append("Connection healthy ✅")
            
        case .disconnected:
            if s.reconnectAttempt > 3 {
                hints.append("⚠️ Multiple reconnect attempts (\(s.reconnectAttempt))")
                hints.append("   Connection may be unstable")
            }

        case .permissionDenied:
            hints.append("⚠️ \"Local Network\" permission is denied for this app")
            hints.append("   Bonjour cannot work until this is granted")
        }

        return hints
    }
    
    private static func generateNextSteps(_ s: Snapshot) -> [String] {
        var steps: [String] = []
        
        if !s.wifiConnected {
            steps.append("Connect to Wi-Fi network")
            return steps
        }
        
        if s.vpnActive {
            steps.append("Try disabling VPN temporarily")
        }
        
        switch s.bridgeState {
        case .idle:
            steps.append("Add TTDebugBridge.shared.start() in AppDelegate")

        case .browsing where s.browseResultCount == 0 && s.stateDuration > 10:
            steps.append("Open TTBDebugPlus on your Mac")
            steps.append("Ensure Mac and iPhone are on the same Wi-Fi")
            if let ip = s.localIP {
                let prefix = ip.split(separator: ".").prefix(3).joined(separator: ".")
                steps.append("Check: Mac IP should start with \(prefix).xxx")
            }
            steps.append("Check iOS Settings → Privacy → Local Network")
            
        case .connecting:
            steps.append("Check Mac firewall: System Settings → Network → Firewall")
            steps.append("Allow incoming connections for TTBDebugPlus")
            
        case .disconnected:
            steps.append("Connection will auto-retry in a few seconds")
            steps.append("If persistent, restart both TTBDebugPlus and your app")

        case .permissionDenied:
            steps.append("Open Settings → Privacy & Security → Local Network")
            steps.append("Enable the toggle for this app")
            steps.append("Return to the app and tap Reset Connection")

        default:
            break
        }
        
        return steps
    }
}
