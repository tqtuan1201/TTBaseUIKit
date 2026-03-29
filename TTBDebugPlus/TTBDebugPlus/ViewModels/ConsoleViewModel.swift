//
//  ConsoleViewModel.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-27.
//  Manages console log state, filtering, search, and live streaming
//

import SwiftUI
import Combine

// MARK: - Console ViewModel
@Observable
final class ConsoleViewModel {
    
    // MARK: - State
    var entries: [ConsoleLogEntry] = []
    var selectedEntry: ConsoleLogEntry? = nil
    var searchText: String = ""
    var selectedFilter: LogFilter = .all
    var isLiveStreaming: Bool = true
    var sortOrder: SortOrder = .newestFirst
    
    // Stats
    var totalCount: Int { entries.count }
    var errorCount: Int { entries.filter { $0.level == "error" }.count }
    var warningCount: Int { entries.filter { $0.level == "warning" }.count }
    
    // MARK: - Filtered entries
    var filteredEntries: [ConsoleLogEntry] {
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
    
    // MARK: - Sync from ConnectionManager
    func syncFromConnectionManager(_ connectionManager: ConnectionManager) {
        // Collect all console logs from selected device or all devices
        var allLogs: [ConsoleLogPayload] = []
        if let device = connectionManager.selectedDevice {
            allLogs = device.consoleLogs
        } else {
            allLogs = connectionManager.connectedDevices.flatMap { $0.consoleLogs }
        }
        
        // Convert to display model
        entries = allLogs.map { payload in
            ConsoleLogEntry(
                id: payload.id,
                timestamp: payload.timestamp,
                level: payload.level,
                subsystem: payload.subsystem,
                message: payload.message,
                threadId: payload.threadId ?? "0x0000",
                payload: nil,
                sourceFile: payload.sourceFile,
                sourceLine: payload.sourceLine
            )
        }
    }
    
    
    // MARK: - Actions
    func clearAll() {
        entries.removeAll()
        selectedEntry = nil
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
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter.string(from: date)
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
