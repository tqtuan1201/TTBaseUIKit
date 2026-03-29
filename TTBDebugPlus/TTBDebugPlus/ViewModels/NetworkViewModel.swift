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
    var entries: [NetworkRequestEntry] = [] {
        didSet { invalidateFilterCache() }
    }
    var selectedEntry: NetworkRequestEntry? = nil
    var searchText: String = "" {
        didSet { invalidateFilterCache() }
    }
    var searchScope: SearchScope = .all {
        didSet { invalidateFilterCache() }
    }
    var selectedDetailTab: NetworkDetailTab = .headers
    var selectedMethodFilter: String? = nil {
        didSet { invalidateFilterCache() }
    }
    var selectedStatusFilter: StatusFilter = .all {
        didSet { invalidateFilterCache() }
    }
    var isLiveStreaming: Bool = true
    var showOnlyPinned: Bool = false {
        didSet { invalidateFilterCache() }
    }
    var pinnedIds: Set<String> = [] {
        didSet { if showOnlyPinned { invalidateFilterCache() } }
    }
    
    // Device filter
    var selectedDeviceFilter: String? = nil {
        didSet { invalidateFilterCache() }
    }
    var availableDevices: [(id: String, name: String)] = []
    
    // Cache for filtered entries — invalidated on any filter/data change
    private var _cachedFilteredEntries: [NetworkRequestEntry]?
    
    // Stats — cached to avoid redundant O(n) scans
    var totalRequests: Int { entries.count }
    var failedRequests: Int { _cachedFailedCount ?? computeFailedCount() }
    private var _cachedFailedCount: Int?
    
    // MARK: - Filtered entries (cached)
    var filteredEntries: [NetworkRequestEntry] {
        if let cached = _cachedFilteredEntries { return cached }
        let result = computeFilteredEntries()
        _cachedFilteredEntries = result
        return result
    }
    
    private func invalidateFilterCache() {
        _cachedFilteredEntries = nil
        _cachedFailedCount = nil
    }
    
    private func computeFailedCount() -> Int {
        let count = entries.count(where: { $0.statusCode >= 400 })
        _cachedFailedCount = count
        return count
    }
    
    private func computeFilteredEntries() -> [NetworkRequestEntry] {
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
            let upperMethod = method.uppercased()
            result = result.filter { $0.method == upperMethod }
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
    // MARK: - Single-Pass Statistics (O(n) instead of multiple O(n) scans)
    struct AggregatedStats {
        var methodCounts: [String: Int] = [:]
        var statusBuckets: [Int] = [0, 0, 0, 0] // 2xx, 3xx, 4xx, 5xx
        var totalDuration: Double = 0
        var totalSize: Int = 0
        var deviceCounts: [String: (name: String, count: Int)] = [:]
        var domainCounts: [String: Int] = [:]
        var timeBuckets: [Int] = [0, 0, 0, 0, 0] // <100, 100-500, 500-1s, 1-5s, >5s
        var errorCount: Int = 0
    }
    
    private var _cachedStats: AggregatedStats?
    
    private var stats: AggregatedStats {
        if let cached = _cachedStats { return cached }
        var s = AggregatedStats()
        for entry in entries {
            // Method
            s.methodCounts[entry.method, default: 0] += 1
            // Status
            switch entry.statusCode {
            case 200..<300: s.statusBuckets[0] += 1
            case 300..<400: s.statusBuckets[1] += 1
            case 400..<500: s.statusBuckets[2] += 1; s.errorCount += 1
            case 500..<600: s.statusBuckets[3] += 1; s.errorCount += 1
            default: break
            }
            // Duration
            s.totalDuration += entry.durationMs
            if entry.durationMs < 100 { s.timeBuckets[0] += 1 }
            else if entry.durationMs < 500 { s.timeBuckets[1] += 1 }
            else if entry.durationMs < 1000 { s.timeBuckets[2] += 1 }
            else if entry.durationMs < 5000 { s.timeBuckets[3] += 1 }
            else { s.timeBuckets[4] += 1 }
            // Size
            s.totalSize += entry.sizeBytes
            // Device
            if let existing = s.deviceCounts[entry.sourceDeviceId] {
                s.deviceCounts[entry.sourceDeviceId] = (existing.name, existing.count + 1)
            } else {
                s.deviceCounts[entry.sourceDeviceId] = (entry.sourceDeviceName, 1)
            }
            // Domain (use pre-parsed urlDomain)
            s.domainCounts[entry.urlDomain, default: 0] += 1
        }
        _cachedStats = s
        return s
    }
    
    var methodDistribution: [(method: String, count: Int)] {
        stats.methodCounts.map { ($0.key, $0.value) }.sorted { $0.1 > $1.1 }
    }
    
    var statusDistribution: [(range: String, count: Int, color: String)] {
        let s = stats.statusBuckets
        return [
            ("2xx", s[0], "success"),
            ("3xx", s[1], "info"),
            ("4xx", s[2], "warning"),
            ("5xx", s[3], "error")
        ]
    }
    
    var averageResponseTime: Double {
        guard !entries.isEmpty else { return 0 }
        return stats.totalDuration / Double(entries.count)
    }
    
    var totalDataTransferred: Int { stats.totalSize }
    
    var topSlowestRequests: [NetworkRequestEntry] {
        Array(entries.sorted { $0.durationMs > $1.durationMs }.prefix(5))
    }
    
    var errorRate: Double {
        guard !entries.isEmpty else { return 0 }
        return Double(stats.errorCount) / Double(entries.count) * 100
    }
    
    // MARK: - Per-Device Statistics
    var deviceDistribution: [(deviceName: String, deviceId: String, count: Int)] {
        stats.deviceCounts.map { ($0.value.name, $0.key, $0.value.count) }
            .sorted { $0.count > $1.count }
    }
    
    var domainDistribution: [(domain: String, count: Int)] {
        Array(stats.domainCounts.map { ($0.key, $0.value) }
            .sorted { $0.1 > $1.1 }.prefix(10))
    }
    
    var responseTimeDistribution: [(range: String, count: Int)] {
        let t = stats.timeBuckets
        return [
            ("<100ms", t[0]),
            ("100-500ms", t[1]),
            ("500ms-1s", t[2]),
            ("1s-5s", t[3]),
            (">5s", t[4])
        ]
    }
    
    // MARK: - Sync from ConnectionManager
    // MARK: - Incremental Sync (diff-based, O(new) not O(all))
    private var _syncedIds: Set<String> = []
    
    func syncFromConnectionManager(_ connectionManager: ConnectionManager) {
        // Pause gate — when paused, don't update entries
        guard isLiveStreaming else { return }
        
        var newEntries: [NetworkRequestEntry] = []
        
        for device in connectionManager.connectedDevices {
            for payload in device.apiLogs where !_syncedIds.contains(payload.id) {
                newEntries.append(NetworkRequestEntry(
                    from: payload,
                    sourceDeviceId: device.id,
                    sourceDeviceName: device.displayName
                ))
            }
        }
        
        if !newEntries.isEmpty {
            for entry in newEntries { _syncedIds.insert(entry.id) }
            entries.append(contentsOf: newEntries)
            _cachedStats = nil // Invalidate stats on new data
        }
        
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
        _syncedIds.removeAll()
        _cachedStats = nil
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
    
    // Pre-parsed URL components (computed once at init, not per render)
    let urlPath: String
    let urlDomain: String
    
    // Pre-formatted timestamp (computed once, not per render)
    let formattedTimestamp: String
    
    // Static DateFormatters — shared across all instances
    private static let timestampFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm:ss.SSS"
        return f
    }()
    
    /// Convenience init from API payload
    init(from payload: APILogPayload, sourceDeviceId: String, sourceDeviceName: String) {
        self.id = payload.id
        self.timestamp = payload.timestamp
        self.statusCode = payload.statusCode
        self.method = payload.method.uppercased()
        self.url = payload.url
        self.durationMs = payload.durationMs
        self.sizeBytes = payload.sizeBytes
        self.requestHeaders = payload.requestHeaders
        self.requestBody = payload.requestBody
        self.responseHeaders = payload.responseHeaders
        self.responseBody = payload.responseBody
        self.sourceDeviceId = sourceDeviceId
        self.sourceDeviceName = sourceDeviceName
        
        // Pre-parse URL components once
        let comps = URLComponents(string: payload.url)
        var path = comps?.path ?? payload.url
        if let query = comps?.query { path += "?\(query)" }
        self.urlPath = path
        self.urlDomain = comps?.host ?? "unknown"
        self.remoteAddress = "\(comps?.host ?? "unknown"):\(comps?.port ?? 443)"
        
        // Pre-format timestamp once
        let date = Date(timeIntervalSince1970: payload.timestamp / 1000)
        self.formattedTimestamp = Self.timestampFormatter.string(from: date)
    }
    
    /// Full memberwise init (for manual construction)
    init(id: String, timestamp: TimeInterval, statusCode: Int, method: String, url: String,
         durationMs: Double, sizeBytes: Int, requestHeaders: [String: String],
         requestBody: String, responseHeaders: [String: String], responseBody: String,
         remoteAddress: String, sourceDeviceId: String, sourceDeviceName: String) {
        self.id = id
        self.timestamp = timestamp
        self.statusCode = statusCode
        self.method = method.uppercased()
        self.url = url
        self.durationMs = durationMs
        self.sizeBytes = sizeBytes
        self.requestHeaders = requestHeaders
        self.requestBody = requestBody
        self.responseHeaders = responseHeaders
        self.responseBody = responseBody
        self.remoteAddress = remoteAddress
        self.sourceDeviceId = sourceDeviceId
        self.sourceDeviceName = sourceDeviceName
        
        let comps = URLComponents(string: url)
        var path = comps?.path ?? url
        if let query = comps?.query { path += "?\(query)" }
        self.urlPath = path
        self.urlDomain = comps?.host ?? "unknown"
        
        let date = Date(timeIntervalSince1970: timestamp / 1000)
        self.formattedTimestamp = Self.timestampFormatter.string(from: date)
    }
    
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
    
    // MARK: - Cookie Parsing
    var parsedCookies: [ParsedCookie] {
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
