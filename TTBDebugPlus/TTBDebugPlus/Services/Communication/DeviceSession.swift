//
//  DeviceSession.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-27.
//  Represents a connected iOS device session
//

import Foundation
import Network

// MARK: - Device Session
/// Represents a single connected iOS device and its WebSocket connection.
/// Tracks device info, connection state, heartbeat, and received logs.
@Observable
final class DeviceSession: Identifiable, Hashable {
    let id: String // deviceId from handshake
    var deviceInfo: DeviceInfoPayload?
    var connection: NWConnection?
    var connectionState: ConnectionState = .connecting
    var lastHeartbeat: Date = Date()
    var connectedAt: Date = Date()
    
    // Accumulated data
    var apiLogs: [APILogPayload] = []
    var consoleLogs: [ConsoleLogPayload] = []
    var latestScreenshot: ScreenshotResponsePayload? = nil
    var latestPerformance: PerformanceMetricsPayload? = nil
    
    // Computed
    var displayName: String {
        deviceInfo?.deviceName ?? "Unknown Device"
    }
    
    var osVersionString: String {
        deviceInfo?.osVersion ?? "Unknown"
    }
    
    var appNameString: String {
        deviceInfo?.appName ?? "Unknown App"
    }
    
    var isSimulator: Bool {
        deviceInfo?.isSimulator ?? false
    }
    
    var isOnline: Bool {
        connectionState == .connected && Date().timeIntervalSince(lastHeartbeat) < 15
    }
    
    var shortId: String {
        String(id.prefix(8)).uppercased()
    }
    
    init(id: String, connection: NWConnection? = nil) {
        self.id = id
        self.connection = connection
    }
    
    // MARK: - Hashable
    static func == (lhs: DeviceSession, rhs: DeviceSession) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // MARK: - Send message to this device
    func send(_ message: DebugMessage) {
        guard let data = message.toData(), let connection = connection else { return }
        
        // Length-prefixed framing: 4-byte big-endian length + payload
        var length = UInt32(data.count).bigEndian
        var frame = Data(bytes: &length, count: 4)
        frame.append(data)
        
        connection.send(content: frame, completion: .contentProcessed { error in
            if let error = error {
                print("[TTBDebug] Send error to \(self.displayName): \(error)")
            }
        })
    }
    
    // MARK: - Request screenshot
    func requestScreenshot(quality: Double = 0.7, maxWidth: Int? = 1170) {
        let request = ScreenshotRequestPayload(quality: quality, maxWidth: maxWidth)
        if let message = DebugMessage.create(type: .screenshotRequest, payload: request) {
            send(message)
        }
    }
    
    // MARK: - Send app command
    func sendCommand(_ action: String) {
        let command = AppCommandPayload(action: action)
        if let message = DebugMessage.create(type: .appCommand, payload: command) {
            send(message)
        }
    }
}

// MARK: - Connection State
enum ConnectionState: String {
    case connecting = "Connecting"
    case connected = "Connected"
    case disconnected = "Disconnected"
    case failed = "Failed"
    
    var isActive: Bool {
        self == .connecting || self == .connected
    }
}
