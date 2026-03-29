//
//  ConsoleViewModel.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-27.
//  Manages console log state, filtering, search, and live streaming
//

import SwiftUI

// MARK: - Console ViewModel
@Observable
final class ConsoleViewModel {
    
    // MARK: - State
    var entries: [ConsoleLogEntry] = [] {
        didSet { invalidateFilterCache() }
    }
    var selectedEntry: ConsoleLogEntry? = nil
    var searchText: String = "" {
        didSet { invalidateFilterCache() }
    }
    var selectedFilter: LogFilter = .all {
        didSet { invalidateFilterCache() }
    }
    var isLiveStreaming: Bool = true
    var sortOrder: SortOrder = .newestFirst {
        didSet { invalidateFilterCache() }
    }
    
    // Stats — cached to avoid redundant O(n) scans
    var totalCount: Int { entries.count }
    var errorCount: Int { _cachedErrorCount ?? computeErrorCount() }
    var warningCount: Int { _cachedWarningCount ?? computeWarningCount() }
    
    // Cache for filtered entries
    private var _cachedFilteredEntries: [ConsoleLogEntry]?
    private var _cachedErrorCount: Int?
    private var _cachedWarningCount: Int?
    
    // Incremental sync tracking
    private var lastSyncedLogCount: Int = 0
    
    // MARK: - Filtered entries (cached)
    var filteredEntries: [ConsoleLogEntry] {
        if let cached = _cachedFilteredEntries { return cached }
        let result = computeFilteredEntries()
        _cachedFilteredEntries = result
        return result
    }
    
    private func invalidateFilterCache() {
        _cachedFilteredEntries = nil
        _cachedErrorCount = nil
        _cachedWarningCount = nil
    }
    
    private func computeErrorCount() -> Int {
        let count = entries.count(where: { $0.level == "error" })
        _cachedErrorCount = count
        return count
    }
    
    private func computeWarningCount() -> Int {
        let count = entries.count(where: { $0.level == "warning" })
        _cachedWarningCount = count
        return count
    }
    
    private func computeFilteredEntries() -> [ConsoleLogEntry] {
        var result = entries
        
        // Filter by level
        switch selectedFilter {
        case .all: break
        case .errors: result = result.filter { $0.level == "error" }
        case .warnings: result = result.filter { $0.level == "warning" }
        case .debug: result = result.filter { $0.level == "debug" }
        case .info: result = result.filter { $0.level == "info" }
        }
        
        // Search
        if !searchText.isEmpty {
            result = result.filter {
                $0.message.localizedCaseInsensitiveContains(searchText) ||
                $0.subsystem.localizedCaseInsensitiveContains(searchText) ||
                ($0.sourceFile ?? "").localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Sort
        switch sortOrder {
        case .newestFirst: result.sort { $0.timestamp > $1.timestamp }
        case .oldestFirst: result.sort { $0.timestamp < $1.timestamp }
        }
        
        return result
    }
    
    // MARK: - Sync from ConnectionManager (incremental)
    func syncFromConnectionManager(_ connectionManager: ConnectionManager) {
        // Collect all console logs from selected device or all devices
        var allLogs: [ConsoleLogPayload] = []
        if let device = connectionManager.selectedDevice {
            allLogs = device.consoleLogs
        } else {
            allLogs = connectionManager.connectedDevices.flatMap { $0.consoleLogs }
        }
        
        // Incremental: only convert new entries
        guard allLogs.count > lastSyncedLogCount else { return }
        let newLogs = allLogs[lastSyncedLogCount...]
        
        let newEntries = newLogs.map { payload in
            ConsoleLogEntry(
                id: payload.id,
                timestamp: payload.timestamp,
                level: payload.level,
                subsystem: payload.subsystem,
                message: payload.message,
                threadId: payload.threadId ?? "0x0000",
                payload: payload.payload,
                sourceFile: payload.sourceFile,
                sourceLine: payload.sourceLine
            )
        }
        
        entries.append(contentsOf: newEntries)
        lastSyncedLogCount = allLogs.count
    }
    
    
    // MARK: - Actions
    func clearAll() {
        entries.removeAll()
        selectedEntry = nil
        lastSyncedLogCount = 0
    }
}

// MARK: - Supporting Types

struct ConsoleLogEntry: Identifiable {
    let id: String
    let timestamp: TimeInterval
    let level: String
    let subsystem: String
    let message: String
    let threadId: String
    let payload: String?
    let sourceFile: String?
    let sourceLine: Int?
    
    var formattedTime: String {
        let date = Date(timeIntervalSince1970: timestamp / 1000)
        return TTDateFormatter.timeWithMillis.string(from: date)
    }
}

enum LogFilter: String, CaseIterable {
    case all = "All"
    case errors = "Errors"
    case warnings = "Warnings"
    case info = "Info"
    case debug = "Debug"
    
    var count: ((ConsoleViewModel) -> Int)? {
        switch self {
        case .all: return { $0.totalCount }
        case .errors: return { $0.errorCount }
        case .warnings: return { $0.warningCount }
        default: return nil
        }
    }
}

enum SortOrder {
    case newestFirst, oldestFirst
}
