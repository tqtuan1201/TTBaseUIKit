//
//  SessionManager.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-27.
//  Manages debug session persistence, export/import
//

import Foundation

// MARK: - Debug Session Model
struct DebugSession: Codable, Identifiable {
    let id: String
    let deviceName: String
    let appName: String
    let startTime: Date
    var endTime: Date?
    var consoleLogs: [ConsoleLogPayload]
    var apiLogs: [APILogPayload]
    var performanceSnapshots: [PerformanceMetricsPayload]
    
    var duration: TimeInterval {
        (endTime ?? Date()).timeIntervalSince(startTime)
    }
    
    var formattedDuration: String {
        let mins = Int(duration / 60)
        let secs = Int(duration.truncatingRemainder(dividingBy: 60))
        if mins > 0 { return "\(mins)m \(secs)s" }
        return "\(secs)s"
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: startTime)
    }
    
    var totalLogCount: Int {
        consoleLogs.count + apiLogs.count
    }
    
    init(deviceName: String, appName: String) {
        self.id = UUID().uuidString
        self.deviceName = deviceName
        self.appName = appName
        self.startTime = Date()
        self.consoleLogs = []
        self.apiLogs = []
        self.performanceSnapshots = []
    }
}

// MARK: - Session Manager
@Observable
final class SessionManager {
    
    var recentSessions: [DebugSession] = []
    var currentSession: DebugSession?
    
    private let maxRecentSessions = 20
    private let fileManager = FileManager.default
    
    private var sessionsDirectory: URL {
        let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let dir = appSupport.appendingPathComponent("TTBDebugPlus/sessions", isDirectory: true)
        try? fileManager.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }
    
    init() {
        loadRecentSessions()
    }
    
    // MARK: - Session Lifecycle
    
    func startSession(deviceName: String, appName: String) {
        // Auto-save previous session
        if let current = currentSession {
            saveSession(current)
        }
        currentSession = DebugSession(deviceName: deviceName, appName: appName)
    }
    
    func endSession() {
        guard var session = currentSession else { return }
        session.endTime = Date()
        saveSession(session)
        currentSession = nil
    }
    
    // MARK: - Add Data
    
    func addConsoleLog(_ log: ConsoleLogPayload) {
        currentSession?.consoleLogs.append(log)
    }
    
    func addAPILog(_ log: APILogPayload) {
        currentSession?.apiLogs.append(log)
    }
    
    func addPerformanceSnapshot(_ snapshot: PerformanceMetricsPayload) {
        currentSession?.performanceSnapshots.append(snapshot)
    }
    
    // MARK: - Persistence
    
    func saveSession(_ session: DebugSession) {
        var sessionToSave = session
        if sessionToSave.endTime == nil {
            sessionToSave.endTime = Date()
        }
        
        let fileName = "\(session.id).ttbdebug"
        let fileURL = sessionsDirectory.appendingPathComponent(fileName)
        
        if let data = try? JSONEncoder().encode(sessionToSave) {
            try? data.write(to: fileURL)
            loadRecentSessions()
        }
    }
    
    func loadRecentSessions() {
        guard let files = try? fileManager.contentsOfDirectory(at: sessionsDirectory,
                                                                includingPropertiesForKeys: [.creationDateKey],
                                                                options: .skipsHiddenFiles) else { return }
        
        let sessions = files
            .filter { $0.pathExtension == "ttbdebug" }
            .compactMap { url -> DebugSession? in
                guard let data = try? Data(contentsOf: url) else { return nil }
                return try? JSONDecoder().decode(DebugSession.self, from: data)
            }
            .sorted { $0.startTime > $1.startTime }
        
        recentSessions = Array(sessions.prefix(maxRecentSessions))
    }
    
    func loadSession(id: String) -> DebugSession? {
        let fileURL = sessionsDirectory.appendingPathComponent("\(id).ttbdebug")
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return try? JSONDecoder().decode(DebugSession.self, from: data)
    }
    
    func deleteSession(id: String) {
        let fileURL = sessionsDirectory.appendingPathComponent("\(id).ttbdebug")
        try? fileManager.removeItem(at: fileURL)
        recentSessions.removeAll { $0.id == id }
    }
    
    // MARK: - Export/Import
    
    func exportSession(_ session: DebugSession, to url: URL) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(session)
        try data.write(to: url)
    }
    
    func importSession(from url: URL) throws -> DebugSession {
        let data = try Data(contentsOf: url)
        let session = try JSONDecoder().decode(DebugSession.self, from: data)
        saveSession(session)
        return session
    }
}
