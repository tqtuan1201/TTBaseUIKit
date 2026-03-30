//
//  ConnectionManager.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-27.
//  Central manager for all device connections, Bonjour advertising, and message routing
//

import Foundation
import Network
import Combine

// MARK: - Connection Manager
/// Central observable manager that owns the Bonjour advertiser, WebSocket server,
/// and all active device sessions. Views bind to this for real-time device/log updates.
@Observable
final class ConnectionManager {
    
    // MARK: - State
    var sessions: [String: DeviceSession] = [:] // deviceId → session
    var isServerRunning: Bool = false
    var serverPort: UInt16? = nil
    var totalAPILogs: Int = 0
    var totalConsoleLogs: Int = 0
    
    // Sorted device list for UI binding
    var connectedDevices: [DeviceSession] {
        sessions.values
            .sorted { $0.connectedAt > $1.connectedAt }
    }
    
    var onlineDevices: [DeviceSession] {
        connectedDevices.filter { $0.isOnline }
    }
    
    // Active device selection
    var selectedDeviceId: String? = nil
    
    var selectedDevice: DeviceSession? {
        guard let id = selectedDeviceId else { return connectedDevices.first }
        return sessions[id]
    }
    
    // Cached log arrays — invalidated when counts change
    private var _cachedAPILogs: [APILogPayload]?
    private var _cachedAPILogsCount: Int = 0
    private var _cachedConsoleLogs: [ConsoleLogPayload]?
    private var _cachedConsoleLogsCount: Int = 0
    
    // All API logs across all devices (or filtered by selection)
    var allAPILogs: [APILogPayload] {
        if let cached = _cachedAPILogs, _cachedAPILogsCount == totalAPILogs {
            return cached
        }
        let result: [APILogPayload]
        if let device = selectedDevice {
            result = device.apiLogs
        } else {
            result = connectedDevices.flatMap { $0.apiLogs }
                .sorted { $0.timestamp > $1.timestamp }
        }
        _cachedAPILogs = result
        _cachedAPILogsCount = totalAPILogs
        return result
    }
    
    // All console logs across all devices (or filtered by selection)
    var allConsoleLogs: [ConsoleLogPayload] {
        if let cached = _cachedConsoleLogs, _cachedConsoleLogsCount == totalConsoleLogs {
            return cached
        }
        let result: [ConsoleLogPayload]
        if let device = selectedDevice {
            result = device.consoleLogs
        } else {
            result = connectedDevices.flatMap { $0.consoleLogs }
                .sorted { $0.timestamp > $1.timestamp }
        }
        _cachedConsoleLogs = result
        _cachedConsoleLogsCount = totalConsoleLogs
        return result
    }
    
    // MARK: - Private
    private let advertiser = BonjourAdvertiser()
    private let wsServer = WebSocketServer()
    private var heartbeatTimer: Timer?
    
    // MARK: - Init
    init() {
        setupCallbacks()
    }
    
    // MARK: - Start Server
    func startServer(port: UInt16 = 0) {
        guard !isServerRunning else { return }
        
        do {
            try advertiser.start(port: port)
            isServerRunning = true
            startHeartbeatMonitor()
            print("[TTBDebug] 🚀 Connection manager started")
        } catch {
            print("[TTBDebug] ❌ Failed to start server: \(error)")
            isServerRunning = false
        }
    }
    
    // MARK: - Stop Server
    func stopServer() {
        advertiser.stop()
        wsServer.disconnectAll()
        stopHeartbeatMonitor()
        sessions.removeAll()
        isServerRunning = false
        serverPort = nil
        print("[TTBDebug] Server stopped")
    }
    
    // MARK: - Setup Callbacks
    private func setupCallbacks() {
        // Bonjour → WebSocket
        advertiser.onNewConnection = { [weak self] connection in
            self?.wsServer.handleNewConnection(connection)
        }
        
        advertiser.onStateChange = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .ready:
                    self?.isServerRunning = true
                    if let port = self?.advertiser.port {
                        self?.serverPort = port.rawValue
                    }
                case .failed, .cancelled:
                    self?.isServerRunning = false
                default:
                    break
                }
            }
        }
        
        // WebSocket → Sessions
        wsServer.onDeviceConnected = { [weak self] deviceId, connection, info in
            self?.handleDeviceConnected(deviceId: deviceId, connection: connection, info: info)
        }
        
        wsServer.onDeviceDisconnected = { [weak self] deviceId in
            self?.handleDeviceDisconnected(deviceId: deviceId)
        }
        
        wsServer.onAPILog = { [weak self] deviceId, log in
            self?.handleAPILog(deviceId: deviceId, log: log)
        }
        
        wsServer.onConsoleLog = { [weak self] deviceId, log in
            self?.handleConsoleLog(deviceId: deviceId, log: log)
        }
        
        wsServer.onHeartbeat = { [weak self] deviceId in
            self?.handleHeartbeat(deviceId: deviceId)
        }
        
        wsServer.onScreenshot = { [weak self] deviceId, screenshot in
            self?.handleScreenshot(deviceId: deviceId, screenshot: screenshot)
        }
        
        wsServer.onPerformanceMetrics = { [weak self] deviceId, metrics in
            self?.handlePerformanceMetrics(deviceId: deviceId, metrics: metrics)
        }
        
        wsServer.onConnectionDiagnostics = { [weak self] deviceId, diag in
            self?.handleConnectionDiagnostics(deviceId: deviceId, diagnostics: diag)
        }
    }
    
    // MARK: - Event Handlers
    
    private func handleDeviceConnected(deviceId: String, connection: NWConnection, info: DeviceInfoPayload) {
        let session: DeviceSession
        if let existing = sessions[deviceId] {
            // Reconnecting device
            existing.connection = connection
            existing.connectionState = .connected
            existing.deviceInfo = info
            existing.lastHeartbeat = Date()
            session = existing
            print("[TTBDebug] 📱 Device reconnected: \(info.deviceName)")
        } else {
            // New device
            session = DeviceSession(id: deviceId, connection: connection)
            session.deviceInfo = info
            session.connectionState = .connected
            session.lastHeartbeat = Date()
            sessions[deviceId] = session
            print("[TTBDebug] 📱 New device connected: \(info.deviceName)")
        }
        
        // Auto-select first device
        if selectedDeviceId == nil {
            selectedDeviceId = deviceId
        }
    }
    
    private func handleDeviceDisconnected(deviceId: String) {
        if let session = sessions[deviceId] {
            session.connectionState = .disconnected
            session.connection = nil
            print("[TTBDebug] 📱 Device disconnected: \(session.displayName)")
        }
    }
    
    private func handleAPILog(deviceId: String, log: APILogPayload) {
        guard let session = sessions[deviceId] else { return }
        session.apiLogs.append(log)
        totalAPILogs += 1
        
        // Limit in-memory logs per device
        if session.apiLogs.count > 5000 {
            session.apiLogs.removeFirst(1000)
        }
    }
    
    private func handleConsoleLog(deviceId: String, log: ConsoleLogPayload) {
        guard let session = sessions[deviceId] else { return }
        session.consoleLogs.append(log)
        totalConsoleLogs += 1
        
        // Limit in-memory logs per device
        if session.consoleLogs.count > 10000 {
            session.consoleLogs.removeFirst(2000)
        }
    }
    
    private func handleHeartbeat(deviceId: String) {
        sessions[deviceId]?.lastHeartbeat = Date()
        sessions[deviceId]?.connectionState = .connected
    }
    
    private func handleScreenshot(deviceId: String, screenshot: ScreenshotResponsePayload) {
        sessions[deviceId]?.latestScreenshot = screenshot
    }
    
    private func handlePerformanceMetrics(deviceId: String, metrics: PerformanceMetricsPayload) {
        sessions[deviceId]?.latestPerformance = metrics
    }
    
    private func handleConnectionDiagnostics(deviceId: String, diagnostics: ConnectionDiagnosticsPayload) {
        sessions[deviceId]?.latestDiagnostics = diagnostics
        print("[TTBDebug] 📋 Diagnostics from \(sessions[deviceId]?.displayName ?? deviceId): IP=\(diagnostics.localIP ?? "N/A"), VPN=\(diagnostics.isVPN)")
    }
    
    // MARK: - macOS Network Info (for ConnectionHealthView)
    
    /// Returns the macOS machine's local IP address.
    var macLocalIP: String? {
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0, let firstAddr = ifaddr else { return nil }
        defer { freeifaddrs(ifaddr) }
        
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let sa = ptr.pointee.ifa_addr.pointee
            guard sa.sa_family == UInt8(AF_INET) else { continue }
            let name = String(cString: ptr.pointee.ifa_name)
            guard name == "en0" else { continue }
            
            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            getnameinfo(ptr.pointee.ifa_addr, socklen_t(sa.sa_len),
                        &hostname, socklen_t(hostname.count),
                        nil, 0, NI_NUMERICHOST)
            return String(cString: hostname)
        }
        return nil
    }
    
    /// Returns the macOS subnet mask for en0.
    var macSubnetMask: String? {
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0, let firstAddr = ifaddr else { return nil }
        defer { freeifaddrs(ifaddr) }
        
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let sa = ptr.pointee.ifa_addr.pointee
            guard sa.sa_family == UInt8(AF_INET) else { continue }
            let name = String(cString: ptr.pointee.ifa_name)
            guard name == "en0" else { continue }
            
            guard let netmask = ptr.pointee.ifa_netmask else { continue }
            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            getnameinfo(netmask, socklen_t(netmask.pointee.sa_len),
                        &hostname, socklen_t(hostname.count),
                        nil, 0, NI_NUMERICHOST)
            return String(cString: hostname)
        }
        return nil
    }
    
    /// Returns the macOS network prefix for subnet comparison.
    var macNetworkPrefix: String? {
        guard let ip = macLocalIP, let mask = macSubnetMask else { return nil }
        let ipParts = ip.split(separator: ".").compactMap { UInt32($0) }
        let maskParts = mask.split(separator: ".").compactMap { UInt32($0) }
        guard ipParts.count == 4, maskParts.count == 4 else { return nil }
        
        let result = zip(ipParts, maskParts).map { $0.0 & $0.1 }
        return result.map { String($0) }.joined(separator: ".")
    }
    
    // MARK: - Heartbeat Monitor
    private func startHeartbeatMonitor() {
        heartbeatTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.checkHeartbeats()
        }
    }
    
    private func stopHeartbeatMonitor() {
        heartbeatTimer?.invalidate()
        heartbeatTimer = nil
    }
    
    private func checkHeartbeats() {
        let timeout: TimeInterval = 15 // seconds
        for (_, session) in sessions {
            if session.connectionState == .connected {
                let elapsed = Date().timeIntervalSince(session.lastHeartbeat)
                if elapsed > timeout {
                    session.connectionState = .disconnected
                    print("[TTBDebug] ⚠️ Device heartbeat timeout: \(session.displayName) (last: \(Int(elapsed))s ago)")
                }
            }
        }
    }
    
    // MARK: - Actions
    
    /// Clear all logs for all devices
    func clearAllLogs() {
        for (_, session) in sessions {
            session.apiLogs.removeAll()
            session.consoleLogs.removeAll()
        }
        totalAPILogs = 0
        totalConsoleLogs = 0
    }
    
    /// Request screenshot from selected device
    func requestScreenshot(quality: Double = 0.7, maxWidth: Int? = 1170) {
        selectedDevice?.requestScreenshot(quality: quality, maxWidth: maxWidth)
    }
    
    /// Send app command to selected device
    func sendCommand(_ action: String) {
        selectedDevice?.sendCommand(action)
    }
}
