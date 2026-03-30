//
//  WebSocketServer.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-27.
//  Handles TCP connections from iOS devices using length-prefixed framing
//

import Foundation
import Network

// MARK: - WebSocket Server
/// Manages TCP connections from iOS devices.
/// Uses 4-byte big-endian length-prefixed framing for message exchange.
/// Handles message receiving, parsing, and routing to the ConnectionManager.
final class WebSocketServer {
    
    private let queue = DispatchQueue(label: "com.ttbdebug.websocket", qos: .userInitiated)
    
    // Callbacks
    var onDeviceConnected: ((String, NWConnection, DeviceInfoPayload) -> Void)?
    var onDeviceDisconnected: ((String) -> Void)?
    var onAPILog: ((String, APILogPayload) -> Void)?
    var onConsoleLog: ((String, ConsoleLogPayload) -> Void)?
    var onHeartbeat: ((String) -> Void)?
    var onScreenshot: ((String, ScreenshotResponsePayload) -> Void)?
    var onPerformanceMetrics: ((String, PerformanceMetricsPayload) -> Void)?
    var onConnectionDiagnostics: ((String, ConnectionDiagnosticsPayload) -> Void)?
    
    // Track connections by endpoint for identification before handshake
    private var pendingConnections: [String: NWConnection] = [:] // endpoint → connection
    private var identifiedConnections: [String: String] = [:] // endpoint → deviceId
    
    // MARK: - Handle New Connection
    /// Called when BonjourAdvertiser receives a new connection
    func handleNewConnection(_ connection: NWConnection) {
        let endpointId = "\(connection.endpoint)"
        pendingConnections[endpointId] = connection
        
        // Setup connection
        connection.stateUpdateHandler = { [weak self] state in
            switch state {
            case .ready:
                print("[TTBDebug] TCP connection ready: \(endpointId)")
                self?.receiveLoop(from: connection, endpointId: endpointId)
                
            case .failed(let error):
                print("[TTBDebug] TCP connection failed: \(error)")
                self?.handleDisconnection(endpointId: endpointId)
                
            case .cancelled:
                print("[TTBDebug] TCP connection cancelled: \(endpointId)")
                self?.handleDisconnection(endpointId: endpointId)
                
            default:
                break
            }
        }
        
        connection.start(queue: queue)
    }
    
    // MARK: - Length-Prefixed Receive
    /// Reads messages using 4-byte big-endian length prefix framing
    private func receiveLoop(from connection: NWConnection, endpointId: String) {
        // Step 1: Read 4-byte length header
        connection.receive(minimumIncompleteLength: 4, maximumLength: 4) { [weak self] header, _, _, error in
            guard let self = self else { return }
            
            if let error = error {
                print("[TTBDebug] Receive header error: \(error)")
                self.handleDisconnection(endpointId: endpointId)
                return
            }
            
            guard let header = header, header.count == 4 else {
                // Connection closed gracefully
                self.handleDisconnection(endpointId: endpointId)
                return
            }
            
            let length = header.withUnsafeBytes { $0.load(as: UInt32.self).bigEndian }
            guard length > 0, length < 10_000_000 else {
                print("[TTBDebug] Invalid message length: \(length)")
                return
            }
            
            // Step 2: Read message body
            connection.receive(minimumIncompleteLength: Int(length), maximumLength: Int(length)) { [weak self] body, _, _, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("[TTBDebug] Receive body error: \(error)")
                    self.handleDisconnection(endpointId: endpointId)
                    return
                }
                
                if let data = body, !data.isEmpty {
                    self.processMessage(data, endpointId: endpointId, connection: connection)
                }
                
                // Continue receiving next message
                self.receiveLoop(from: connection, endpointId: endpointId)
            }
        }
    }
    
    // MARK: - Process Message
    private func processMessage(_ data: Data, endpointId: String, connection: NWConnection) {
        guard let message = DebugMessage.from(data: data) else {
            print("[TTBDebug] Failed to decode message from \(endpointId)")
            return
        }
        
        switch message.type {
        case .deviceInfo:
            guard let info = message.decodePayload(DeviceInfoPayload.self) else { return }
            identifiedConnections[endpointId] = info.deviceId
            DispatchQueue.main.async {
                self.onDeviceConnected?(info.deviceId, connection, info)
            }
            print("[TTBDebug] 📱 Device identified: \(info.deviceName) (\(info.deviceId))")
            
        case .apiLog:
            guard let log = message.decodePayload(APILogPayload.self),
                  let deviceId = identifiedConnections[endpointId] else { return }
            DispatchQueue.main.async {
                self.onAPILog?(deviceId, log)
            }
            
        case .consoleLog:
            guard let log = message.decodePayload(ConsoleLogPayload.self),
                  let deviceId = identifiedConnections[endpointId] else { return }
            DispatchQueue.main.async {
                self.onConsoleLog?(deviceId, log)
            }
            
        case .heartbeat:
            guard let deviceId = identifiedConnections[endpointId] else { return }
            DispatchQueue.main.async {
                self.onHeartbeat?(deviceId)
            }
            
        case .screenshotResponse:
            guard let screenshot = message.decodePayload(ScreenshotResponsePayload.self),
                  let deviceId = identifiedConnections[endpointId] else { return }
            DispatchQueue.main.async {
                self.onScreenshot?(deviceId, screenshot)
            }
            
        case .performanceMetrics:
            guard let metrics = message.decodePayload(PerformanceMetricsPayload.self),
                  let deviceId = identifiedConnections[endpointId] else { return }
            DispatchQueue.main.async {
                self.onPerformanceMetrics?(deviceId, metrics)
            }
            
        case .connectionDiagnostics:
            guard let diag = message.decodePayload(ConnectionDiagnosticsPayload.self),
                  let deviceId = identifiedConnections[endpointId] else { return }
            DispatchQueue.main.async {
                self.onConnectionDiagnostics?(deviceId, diag)
            }
            
        default:
            print("[TTBDebug] Unhandled message type: \(message.type.rawValue)")
        }
    }
    
    // MARK: - Handle Disconnection
    private func handleDisconnection(endpointId: String) {
        if let deviceId = identifiedConnections[endpointId] {
            DispatchQueue.main.async {
                self.onDeviceDisconnected?(deviceId)
            }
            identifiedConnections.removeValue(forKey: endpointId)
        }
        
        pendingConnections[endpointId]?.cancel()
        pendingConnections.removeValue(forKey: endpointId)
    }
    
    // MARK: - Disconnect All
    func disconnectAll() {
        for (_, connection) in pendingConnections {
            connection.cancel()
        }
        pendingConnections.removeAll()
        identifiedConnections.removeAll()
    }
}
