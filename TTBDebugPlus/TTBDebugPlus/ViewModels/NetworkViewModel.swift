//
//  NetworkViewModel.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-27.
//  Manages network request state, filtering, search, device tracking, and detail views
//

import SwiftUI

// MARK: - Network ViewModel
@Observable
final class NetworkViewModel {
    
    // MARK: - State
    var entries: [NetworkRequestEntry] = []
    var selectedEntry: NetworkRequestEntry? = nil
    var searchText: String = ""
    var searchScope: SearchScope = .all
    var selectedDetailTab: NetworkDetailTab = .headers
    var selectedMethodFilter: String? = nil
    var selectedStatusFilter: StatusFilter = .all
    var isLiveStreaming: Bool = true
    var showOnlyPinned: Bool = false
    var pinnedIds: Set<String> = []
    
    // Device filter
    var selectedDeviceFilter: String? = nil // nil = all devices
    var availableDevices: [(id: String, name: String)] = []
    
    // Stats
    var totalRequests: Int { entries.count }
    var failedRequests: Int { entries.filter { $0.statusCode >= 400 }.count }
    
    // MARK: - Filtered entries
    var filteredEntries: [NetworkRequestEntry] {
        var result = entries
        
        // Device filter
        if let deviceId = selectedDeviceFilter {
            result = result.filter { $0.sourceDeviceId == deviceId }
        }
        
        // Pin filter
        if showOnlyPinned {
            result = result.filter { pinnedIds.contains($0.id) }
        }
        
        // Method filter
        if let method = selectedMethodFilter {
            result = result.filter { $0.method.uppercased() == method.uppercased() }
        }
        
        // Status filter
        switch selectedStatusFilter {
        case .all: break
        case .success: result = result.filter { $0.statusCode >= 200 && $0.statusCode < 300 }
        case .redirect: result = result.filter { $0.statusCode >= 300 && $0.statusCode < 400 }
        case .clientError: result = result.filter { $0.statusCode >= 400 && $0.statusCode < 500 }
        case .serverError: result = result.filter { $0.statusCode >= 500 }
        }
        
        // Deep search
        if !searchText.isEmpty {
            result = result.filter { entry in
                switch searchScope {
                case .all:
                    return entry.url.localizedCaseInsensitiveContains(searchText) ||
                           entry.method.localizedCaseInsensitiveContains(searchText) ||
                           entry.requestBody.localizedCaseInsensitiveContains(searchText) ||
                           entry.responseBody.localizedCaseInsensitiveContains(searchText) ||
                           entry.requestHeaders.values.contains { $0.localizedCaseInsensitiveContains(searchText) } ||
                           entry.sourceDeviceName.localizedCaseInsensitiveContains(searchText)
                case .url:
                    return entry.url.localizedCaseInsensitiveContains(searchText)
                case .body:
                    return entry.requestBody.localizedCaseInsensitiveContains(searchText) ||
                           entry.responseBody.localizedCaseInsensitiveContains(searchText)
                case .headers:
                    return entry.requestHeaders.values.contains { $0.localizedCaseInsensitiveContains(searchText) } ||
                           entry.responseHeaders.values.contains { $0.localizedCaseInsensitiveContains(searchText) } ||
                           entry.requestHeaders.keys.contains { $0.localizedCaseInsensitiveContains(searchText) }
                }
            }
        }
        
        // Sort newest first
        result.sort { $0.timestamp > $1.timestamp }
        
        return result
    }
    
    var maxDuration: Double {
        entries.map(\.durationMs).max() ?? 1.0
    }
    
    // MARK: - Available HTTP methods (dynamic from data)
    var availableMethods: [String] {
        Array(Set(entries.map { $0.method.uppercased() })).sorted()
    }
    
    // MARK: - Network Statistics
    var methodDistribution: [(method: String, count: Int)] {
        let grouped = Dictionary(grouping: entries, by: { $0.method.uppercased() })
        return grouped.map { ($0.key, $0.value.count) }.sorted { $0.count > $1.count }
    }
    
    var statusDistribution: [(range: String, count: Int, color: String)] {
        let groups: [(String, ClosedRange<Int>, String)] = [
            ("2xx", 200...299, "success"),
            ("3xx", 300...399, "info"),
            ("4xx", 400...499, "warning"),
            ("5xx", 500...599, "error")
        ]
        return groups.map { label, range, color in
            (label, entries.filter { range.contains($0.statusCode) }.count, color)
        }
    }
    
    var averageResponseTime: Double {
        guard !entries.isEmpty else { return 0 }
        return entries.map(\.durationMs).reduce(0, +) / Double(entries.count)
    }
    
    var totalDataTransferred: Int {
        entries.map(\.sizeBytes).reduce(0, +)
    }
    
    var topSlowestRequests: [NetworkRequestEntry] {
        Array(entries.sorted { $0.durationMs > $1.durationMs }.prefix(5))
    }
    
    var errorRate: Double {
        guard !entries.isEmpty else { return 0 }
        let errors = entries.filter { $0.statusCode >= 400 }.count
        return Double(errors) / Double(entries.count) * 100
    }
    
    // MARK: - Per-Device Statistics
    var deviceDistribution: [(deviceName: String, deviceId: String, count: Int)] {
        let grouped = Dictionary(grouping: entries, by: { $0.sourceDeviceId })
        return grouped.map { deviceId, entries in
            (entries.first?.sourceDeviceName ?? "Unknown", deviceId, entries.count)
        }.sorted { $0.count > $1.count }
    }
    
    var domainDistribution: [(domain: String, count: Int)] {
        let grouped = Dictionary(grouping: entries) { entry -> String in
            URLComponents(string: entry.url)?.host ?? "unknown"
        }
        let all = grouped.map { (domain: $0.key, count: $0.value.count) }
        let sorted = all.sorted { $0.count > $1.count }
        return Array(sorted.prefix(10))
    }
    
    var responseTimeDistribution: [(range: String, count: Int)] {
        let buckets: [(String, Range<Double>)] = [
            ("<100ms", 0..<100),
            ("100-500ms", 100..<500),
            ("500ms-1s", 500..<1000),
            ("1s-5s", 1000..<5000),
            (">5s", 5000..<Double.infinity)
        ]
        return buckets.map { label, range in
            (label, entries.filter { range.contains($0.durationMs) }.count)
        }
    }
    
    // MARK: - Sync from ConnectionManager
    func syncFromConnectionManager(_ connectionManager: ConnectionManager) {
        // Pause gate — when paused, don't update entries
        guard isLiveStreaming else { return }
        
        var allEntries: [NetworkRequestEntry] = []
        
        // Always iterate ALL devices to preserve device provenance
        for device in connectionManager.connectedDevices {
            for payload in device.apiLogs {
                allEntries.append(NetworkRequestEntry(
                    id: payload.id,
                    timestamp: payload.timestamp,
                    statusCode: payload.statusCode,
                    method: payload.method,
                    url: payload.url,
                    durationMs: payload.durationMs,
                    sizeBytes: payload.sizeBytes,
                    requestHeaders: payload.requestHeaders,
                    requestBody: payload.requestBody,
                    responseHeaders: payload.responseHeaders,
                    responseBody: payload.responseBody,
                    remoteAddress: extractHost(from: payload.url),
                    sourceDeviceId: device.id,
                    sourceDeviceName: device.displayName
                ))
            }
        }
        
        entries = allEntries
        
        // Update available devices list
        availableDevices = connectionManager.connectedDevices.map { ($0.id, $0.displayName) }
    }
    
    /// Force refresh (used after unpausing or manual refresh)
    func forceRefresh(_ connectionManager: ConnectionManager) {
        let wasLive = isLiveStreaming
        isLiveStreaming = true
        syncFromConnectionManager(connectionManager)
        isLiveStreaming = wasLive
    }
    
    // MARK: - Actions
    func clearAll(_ connectionManager: ConnectionManager? = nil) {
        entries.removeAll()
        selectedEntry = nil
        pinnedIds.removeAll()
        // Also clear source data if connection manager provided
        connectionManager?.clearAllLogs()
    }
    
    func togglePin(_ id: String) {
        if pinnedIds.contains(id) {
            pinnedIds.remove(id)
        } else {
            pinnedIds.insert(id)
        }
    }
    
    func isPinned(_ id: String) -> Bool {
        pinnedIds.contains(id)
    }
    
    func toggleLiveStreaming(_ connectionManager: ConnectionManager) {
        isLiveStreaming.toggle()
        if isLiveStreaming {
            // Resuming — do a full resync
            syncFromConnectionManager(connectionManager)
        }
    }
    
    // MARK: - Keyboard Navigation
    func selectNext() {
        let entries = filteredEntries
        guard !entries.isEmpty else { return }
        if let current = selectedEntry, let idx = entries.firstIndex(where: { $0.id == current.id }) {
            let nextIdx = min(idx + 1, entries.count - 1)
            selectedEntry = entries[nextIdx]
        } else {
            selectedEntry = entries.first
        }
    }
    
    func selectPrevious() {
        let entries = filteredEntries
        guard !entries.isEmpty else { return }
        if let current = selectedEntry, let idx = entries.firstIndex(where: { $0.id == current.id }) {
            let prevIdx = max(idx - 1, 0)
            selectedEntry = entries[prevIdx]
        } else {
            selectedEntry = entries.first
        }
    }
    
    func generateCURL() -> String? {
        guard let entry = selectedEntry else { return nil }
        return CURLGenerator.generate(from: APILogPayload(
            id: entry.id, timestamp: entry.timestamp,
            method: entry.method, url: entry.url,
            statusCode: entry.statusCode,
            requestHeaders: entry.requestHeaders,
            requestBody: entry.requestBody,
            responseHeaders: entry.responseHeaders,
            responseBody: entry.responseBody,
            durationMs: entry.durationMs,
            sizeBytes: entry.sizeBytes
        ))
    }
    
    func generatePostmanExport() -> String {
        let grouped = Dictionary(grouping: entries, by: { $0.sourceDeviceName })
        return CURLGenerator.generatePostmanCollection(
            from: entries.map { entry in
                APILogPayload(
                    id: entry.id, timestamp: entry.timestamp,
                    method: entry.method, url: entry.url,
                    statusCode: entry.statusCode,
                    requestHeaders: entry.requestHeaders,
                    requestBody: entry.requestBody,
                    responseHeaders: entry.responseHeaders,
                    responseBody: entry.responseBody,
                    durationMs: entry.durationMs,
                    sizeBytes: entry.sizeBytes
                )
            },
            name: "TTBDebugPlus Export (\(grouped.count) device\(grouped.count == 1 ? "" : "s"))"
        )
    }
    
    // MARK: - HAR Export
    func generateHARExport(stripAuth: Bool = true) -> String {
        HARGenerator.generate(from: entries, stripAuthHeaders: stripAuth)
    }
    
    // MARK: - Helpers
    private func extractHost(from url: String) -> String {
        guard let comps = URLComponents(string: url) else { return "unknown" }
        return "\(comps.host ?? "unknown"):\(comps.port ?? 443)"
    }
}

// MARK: - Supporting Types

struct NetworkRequestEntry: Identifiable {
    let id: String
    let timestamp: TimeInterval
    let statusCode: Int
    let method: String
    let url: String
    let durationMs: Double
    let sizeBytes: Int
    let requestHeaders: [String: String]
    let requestBody: String
    let responseHeaders: [String: String]
    let responseBody: String
    let remoteAddress: String
    let sourceDeviceId: String
    let sourceDeviceName: String
    
    var formattedTime: String {
        if durationMs >= 1000 {
            return String(format: "%.1fs", durationMs / 1000)
        }
        return "\(Int(durationMs))ms"
    }
    
    var formattedSize: String {
        if sizeBytes == 0 { return "0 B" }
        if sizeBytes < 1024 { return "\(sizeBytes) B" }
        if sizeBytes < 1_048_576 { return String(format: "%.1f KB", Double(sizeBytes) / 1024) }
        return String(format: "%.1f MB", Double(sizeBytes) / 1_048_576)
    }
    
    var urlPath: String {
        guard let comps = URLComponents(string: url) else { return url }
        var path = comps.path
        if let query = comps.query {
            path += "?\(query)"
        }
        return path
    }
    
    var urlDomain: String {
        URLComponents(string: url)?.host ?? "unknown"
    }
    
    var formattedTimestamp: String {
        let date = Date(timeIntervalSince1970: timestamp / 1000)
        let f = DateFormatter()
        f.dateFormat = "HH:mm:ss.SSS"
        return f.string(from: date)
    }
    
    // MARK: - Cookie Parsing
    var parsedCookies: [ParsedCookie] {
        // Combine all Set-Cookie headers
        let cookieHeaders = responseHeaders.filter { $0.key.lowercased() == "set-cookie" }
        guard !cookieHeaders.isEmpty else { return [] }
        
        return cookieHeaders.values.flatMap { value in
            value.components(separatedBy: ",").compactMap { ParsedCookie.parse($0.trimmingCharacters(in: .whitespaces)) }
        }
    }
    
    var hasCookies: Bool {
        responseHeaders.keys.contains { $0.lowercased() == "set-cookie" }
    }
}

// MARK: - Parsed Cookie
struct ParsedCookie: Identifiable {
    let id = UUID()
    let name: String
    let value: String
    let domain: String?
    let path: String?
    let expires: String?
    let isSecure: Bool
    let isHttpOnly: Bool
    let sameSite: String?
    
    static func parse(_ raw: String) -> ParsedCookie? {
        let parts = raw.components(separatedBy: ";").map { $0.trimmingCharacters(in: .whitespaces) }
        guard let first = parts.first else { return nil }
        
        let nameValue = first.split(separator: "=", maxSplits: 1)
        guard nameValue.count >= 1 else { return nil }
        
        let name = String(nameValue[0])
        let value = nameValue.count > 1 ? String(nameValue[1]) : ""
        
        var domain: String? = nil
        var path: String? = nil
        var expires: String? = nil
        var isSecure = false
        var isHttpOnly = false
        var sameSite: String? = nil
        
        for attr in parts.dropFirst() {
            let lower = attr.lowercased()
            if lower.hasPrefix("domain=") { domain = String(attr.dropFirst(7)) }
            else if lower.hasPrefix("path=") { path = String(attr.dropFirst(5)) }
            else if lower.hasPrefix("expires=") { expires = String(attr.dropFirst(8)) }
            else if lower.hasPrefix("samesite=") { sameSite = String(attr.dropFirst(9)) }
            else if lower == "secure" { isSecure = true }
            else if lower == "httponly" { isHttpOnly = true }
        }
        
        return ParsedCookie(
            name: name, value: value, domain: domain, path: path,
            expires: expires, isSecure: isSecure, isHttpOnly: isHttpOnly, sameSite: sameSite
        )
    }
}

enum NetworkDetailTab: String, CaseIterable {
    case headers = "HEADERS"
    case preview = "PREVIEW"
    case response = "RESPONSE"
    case cookies = "COOKIES"
}

enum StatusFilter: String, CaseIterable {
    case all = "All"
    case success = "2xx"
    case redirect = "3xx"
    case clientError = "4xx"
    case serverError = "5xx"
}

enum SearchScope: String, CaseIterable {
    case all = "All"
    case url = "URL"
    case body = "Body"
    case headers = "Headers"
}

// MARK: - HAR Generator
enum HARGenerator {
    static func generate(from entries: [NetworkRequestEntry], stripAuthHeaders: Bool = true) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        var harEntries: [[String: Any]] = []
        
        for entry in entries {
            let startDate = Date(timeIntervalSince1970: entry.timestamp / 1000)
            
            // Request headers
            var reqHeaders: [[String: String]] = []
            for (key, value) in entry.requestHeaders {
                if stripAuthHeaders && key.lowercased() == "authorization" {
                    reqHeaders.append(["name": key, "value": "[STRIPPED]"])
                } else {
                    reqHeaders.append(["name": key, "value": value])
                }
            }
            
            // Response headers
            var resHeaders: [[String: String]] = []
            for (key, value) in entry.responseHeaders {
                resHeaders.append(["name": key, "value": value])
            }
            
            let harEntry: [String: Any] = [
                "startedDateTime": isoFormatter.string(from: startDate),
                "time": entry.durationMs,
                "request": [
                    "method": entry.method.uppercased(),
                    "url": entry.url,
                    "httpVersion": "HTTP/1.1",
                    "headers": reqHeaders,
                    "queryString": [],
                    "cookies": [],
                    "headersSize": -1,
                    "bodySize": entry.requestBody.count,
                    "postData": entry.requestBody.isEmpty ? [:] : [
                        "mimeType": entry.requestHeaders["Content-Type"] ?? "application/json",
                        "text": entry.requestBody
                    ]
                ] as [String: Any],
                "response": [
                    "status": entry.statusCode,
                    "statusText": HTTPURLResponse.localizedString(forStatusCode: entry.statusCode),
                    "httpVersion": "HTTP/1.1",
                    "headers": resHeaders,
                    "cookies": [],
                    "content": [
                        "size": entry.sizeBytes,
                        "mimeType": entry.responseHeaders["Content-Type"] ?? "application/json",
                        "text": entry.responseBody
                    ] as [String: Any],
                    "redirectURL": "",
                    "headersSize": -1,
                    "bodySize": entry.sizeBytes
                ] as [String: Any],
                "cache": [:] as [String: Any],
                "timings": [
                    "send": 0,
                    "wait": entry.durationMs,
                    "receive": 0
                ] as [String: Any]
            ]
            
            harEntries.append(harEntry)
        }
        
        let har: [String: Any] = [
            "log": [
                "version": "1.2",
                "creator": [
                    "name": "TTBDebugPlus",
                    "version": "1.0"
                ] as [String: Any],
                "entries": harEntries
            ] as [String: Any]
        ]
        
        if let data = try? JSONSerialization.data(withJSONObject: har, options: [.prettyPrinted, .sortedKeys]),
           let str = String(data: data, encoding: .utf8) {
            return str
        }
        return "{}"
    }
}
