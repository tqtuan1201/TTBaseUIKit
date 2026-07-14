//
//  DebugProtocol.swift
//  TTBaseUIKit
//
//  Created by TuanTruong on 2026-03-27.
//  Shared protocol models for iOS ↔ macOS debug communication
//  NOTE: These models must stay in sync with TTBDebugPlus/Services/Protocol/DebugMessage.swift
//

import Foundation

// MARK: - Message Envelope
struct DebugMessage: Codable {
    /// Wire protocol version. Bump when the envelope or a payload shape changes
    /// in a way older peers can't safely ignore.
    static let currentProtocolVersion = 1

    let type: MessageType
    let payload: Data
    let timestamp: TimeInterval
    /// `nil` means the peer predates this field (pre-2026-07-13 SDK/app) — treat as version 0.
    let protocolVersion: Int?
    /// Stamped by a macOS Relay Server when forwarding a producer's frame to viewers — never
    /// set or read by iOS itself. Kept here only for envelope parity with the macOS copy (see
    /// Phase 3 relay design doc); this SDK never needs to inspect it.
    var sourceDeviceId: String?

    init(type: MessageType, payload: Data) {
        self.type = type
        self.payload = payload
        self.timestamp = Date().timeIntervalSince1970 * 1000
        self.protocolVersion = DebugMessage.currentProtocolVersion
        self.sourceDeviceId = nil
    }
    
    static func create<T: Encodable>(type: MessageType, payload: T) -> DebugMessage? {
        do {
            let data = try JSONEncoder().encode(payload)
            return DebugMessage(type: type, payload: data)
        } catch {
            TTBaseFunc.shared.printLog(object: "[TTDebugBridge] ⚠️ Failed to encode \(type.rawValue) payload: \(error)")
            return nil
        }
    }

    func decodePayload<T: Decodable>(_ type: T.Type) -> T? {
        do {
            return try JSONDecoder().decode(type, from: payload)
        } catch {
            TTBaseFunc.shared.printLog(object: "[TTDebugBridge] ⚠️ decodePayload(\(type)) failed for \(self.type.rawValue): \(error)")
            return nil
        }
    }

    func toData() -> Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            TTBaseFunc.shared.printLog(object: "[TTDebugBridge] ⚠️ Failed to encode DebugMessage envelope (\(type.rawValue)): \(error)")
            return nil
        }
    }

    static func from(data: Data) -> DebugMessage? {
        do {
            return try JSONDecoder().decode(DebugMessage.self, from: data)
        } catch {
            TTBaseFunc.shared.printLog(object: "[TTDebugBridge] ⚠️ DebugMessage envelope decode failed (\(data.count) bytes): \(error)")
            return nil
        }
    }
}

// MARK: - Message Type
enum MessageType: String, Codable {
    case deviceInfo = "device_info"
    case apiLog = "api_log"
    case consoleLog = "console_log"
    case screenshotRequest = "screenshot_request"
    case screenshotResponse = "screenshot_response"
    case heartbeat = "heartbeat"
    case heartbeatAck = "heartbeat_ack"
    /// macOS-internal (Relay Client → Relay Server handshake) — this SDK never sends or
    /// receives it. Present only for envelope/enum parity with the macOS copy.
    case relayClientHello = "relay_client_hello"
    case appCommand = "app_command"
    case performanceMetrics = "performance_metrics"
    case disconnect = "disconnect"
    case connectionDiagnostics = "connection_diagnostics"
}

// MARK: - Payloads
struct DeviceInfoPayload: Codable {
    let deviceId: String
    let deviceName: String
    let osVersion: String
    let appName: String
    let appVersion: String
    let sdkVersion: String
    let isSimulator: Bool
    let screenWidth: Double
    let screenHeight: Double
    
    enum CodingKeys: String, CodingKey {
        case deviceId = "device_id"
        case deviceName = "device_name"
        case osVersion = "os_version"
        case appName = "app_name"
        case appVersion = "app_version"
        case sdkVersion = "sdk_version"
        case isSimulator = "is_simulator"
        case screenWidth = "screen_width"
        case screenHeight = "screen_height"
    }
}

struct APILogPayload: Codable {
    let id: String
    let timestamp: TimeInterval
    let method: String
    let url: String
    let statusCode: Int
    let requestHeaders: [String: String]
    let requestBody: String
    let responseHeaders: [String: String]
    let responseBody: String
    let durationMs: Double
    let sizeBytes: Int
    
    enum CodingKeys: String, CodingKey {
        case id, timestamp, method, url
        case statusCode = "status_code"
        case requestHeaders = "request_headers"
        case requestBody = "request_body"
        case responseHeaders = "response_headers"
        case responseBody = "response_body"
        case durationMs = "duration_ms"
        case sizeBytes = "size_bytes"
    }
}

struct ConsoleLogPayload: Codable {
    let id: String
    let timestamp: TimeInterval
    let level: String
    let subsystem: String
    let message: String
    let sourceFile: String?
    let sourceLine: Int?
    let threadId: String?
    
    enum CodingKeys: String, CodingKey {
        case id, timestamp, level, subsystem, message
        case sourceFile = "source_file"
        case sourceLine = "source_line"
        case threadId = "thread_id"
    }
}

struct HeartbeatPayload: Codable {
    let timestamp: TimeInterval
    let uptimeSeconds: Double?
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case uptimeSeconds = "uptime_seconds"
    }
    
    init(timestamp: TimeInterval = Date().timeIntervalSince1970 * 1000, uptimeSeconds: Double? = nil) {
        self.timestamp = timestamp
        self.uptimeSeconds = uptimeSeconds
    }
}

struct ScreenshotRequestPayload: Codable {
    let quality: Double
    let maxWidth: Int?
    enum CodingKeys: String, CodingKey { case quality; case maxWidth = "max_width" }
    init(quality: Double = 0.7, maxWidth: Int? = 1170) { self.quality = quality; self.maxWidth = maxWidth }
}

struct ScreenshotResponsePayload: Codable {
    let imageData: String
    let timestamp: TimeInterval
    let screenWidth: Double
    let screenHeight: Double
    let orientation: String
    enum CodingKeys: String, CodingKey {
        case imageData = "image_data"; case timestamp
        case screenWidth = "screen_width"; case screenHeight = "screen_height"; case orientation
    }
}

struct AppCommandPayload: Codable {
    let action: String
}

struct PerformanceMetricsPayload: Codable {
    let cpuUsage: Double
    let memoryUsedMB: Double
    let memoryTotalMB: Double
    let fps: Double?
    let diskUsedMB: Double?
    let networkBytesSent: Int?
    let networkBytesReceived: Int?
    let timestamp: TimeInterval
    
    enum CodingKeys: String, CodingKey {
        case cpuUsage = "cpu_usage"
        case memoryUsedMB = "memory_used_mb"
        case memoryTotalMB = "memory_total_mb"
        case fps
        case diskUsedMB = "disk_used_mb"
        case networkBytesSent = "network_bytes_sent"
        case networkBytesReceived = "network_bytes_received"
        case timestamp
    }
}

struct ConnectionDiagnosticsPayload: Codable {
    let localIP: String?
    let subnetMask: String?
    let networkPrefix: String?
    let isVPN: Bool
    let isWiFi: Bool
    let sdkVersion: String
    let connectionAttempts: Int
    let stateDurationSeconds: Double
    
    enum CodingKeys: String, CodingKey {
        case localIP = "local_ip"
        case subnetMask = "subnet_mask"
        case networkPrefix = "network_prefix"
        case isVPN = "is_vpn"
        case isWiFi = "is_wifi"
        case sdkVersion = "sdk_version"
        case connectionAttempts = "connection_attempts"
        case stateDurationSeconds = "state_duration_seconds"
    }
}
