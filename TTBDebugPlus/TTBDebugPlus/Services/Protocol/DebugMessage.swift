//
//  DebugMessage.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-27.
//  Shared protocol models for iOS ↔ macOS communication
//

import Foundation

// MARK: - Message Envelope
/// Top-level message wrapper for all communications between iOS SDK and macOS app.
/// Every message is wrapped in this envelope with a `type` discriminator and a JSON `payload`.
struct DebugMessage: Codable {
    let type: MessageType
    let payload: Data // Raw JSON payload — decoded based on `type`
    let timestamp: TimeInterval
    
    init(type: MessageType, payload: Data) {
        self.type = type
        self.payload = payload
        self.timestamp = Date().timeIntervalSince1970 * 1000 // milliseconds
    }
    
    /// Convenience: create a message from any Encodable payload
    static func create<T: Encodable>(type: MessageType, payload: T) -> DebugMessage? {
        guard let data = try? JSONEncoder().encode(payload) else { return nil }
        return DebugMessage(type: type, payload: data)
    }
    
    /// Decode the payload into a specific type
    func decodePayload<T: Decodable>(_ type: T.Type) -> T? {
        try? JSONDecoder().decode(type, from: payload)
    }
    
    /// Serialize entire message to Data for transmission
    func toData() -> Data? {
        try? JSONEncoder().encode(self)
    }
    
    /// Deserialize from received Data
    static func from(data: Data) -> DebugMessage? {
        try? JSONDecoder().decode(DebugMessage.self, from: data)
    }
}

// MARK: - Message Type
enum MessageType: String, Codable, CaseIterable {
    case deviceInfo = "device_info"
    case apiLog = "api_log"
    case consoleLog = "console_log"
    case screenshotRequest = "screenshot_request"
    case screenshotResponse = "screenshot_response"
    case heartbeat = "heartbeat"
    case appCommand = "app_command"
    case performanceMetrics = "performance_metrics"
    case disconnect = "disconnect"
}

// MARK: - Device Info Payload
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

// MARK: - API Log Payload
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

// MARK: - Console Log Payload
struct ConsoleLogPayload: Codable {
    let id: String
    let timestamp: TimeInterval
    let level: String // "error", "warning", "info", "debug"
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

// MARK: - Heartbeat Payload
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

// MARK: - Screenshot Request Payload (macOS → iOS)
struct ScreenshotRequestPayload: Codable {
    let quality: Double
    let maxWidth: Int?
    
    enum CodingKeys: String, CodingKey {
        case quality
        case maxWidth = "max_width"
    }
    
    init(quality: Double = 0.7, maxWidth: Int? = 1170) {
        self.quality = quality
        self.maxWidth = maxWidth
    }
}

// MARK: - Screenshot Response Payload (iOS → macOS)
struct ScreenshotResponsePayload: Codable {
    let imageData: String // Base64 encoded JPEG
    let timestamp: TimeInterval
    let screenWidth: Double
    let screenHeight: Double
    let orientation: String
    
    enum CodingKeys: String, CodingKey {
        case imageData = "image_data"
        case timestamp
        case screenWidth = "screen_width"
        case screenHeight = "screen_height"
        case orientation
    }
}

// MARK: - App Command Payload (macOS → iOS)
struct AppCommandPayload: Codable {
    let action: String
    // Supported actions:
    // "dark_mode_on", "dark_mode_off"
    // "touch_points_on", "touch_points_off"
    // "reduced_motion_on", "reduced_motion_off"
    // "reset_sandbox"
}

// MARK: - Performance Metrics Payload (iOS → macOS)
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
