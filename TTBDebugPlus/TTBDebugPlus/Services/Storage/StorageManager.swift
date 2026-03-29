//
//  StorageManager.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-29.
//  Centralized sandbox-aware file storage management
//

import Foundation
import AppKit

// MARK: - Storage Usage Model

struct StorageUsage {
    var sessionsSize: Int64 = 0
    var mediaSize: Int64 = 0
    var exportsSize: Int64 = 0
    var cacheSize: Int64 = 0
    
    var totalSize: Int64 {
        sessionsSize + mediaSize + exportsSize + cacheSize
    }
    
    var formattedTotal: String {
        ByteCountFormatter.string(fromByteCount: totalSize, countStyle: .file)
    }
    
    func formatted(_ size: Int64) -> String {
        ByteCountFormatter.string(fromByteCount: size, countStyle: .file)
    }
}

// MARK: - Storage Manager

@Observable
final class StorageManager {
    
    // MARK: - Directories
    
    /// Base application support directory (sandbox-aware)
    var baseDirectory: URL {
        guard let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            return FileManager.default.temporaryDirectory.appendingPathComponent("TTBDebugPlus", isDirectory: true)
        }
        return appSupport.appendingPathComponent("TTBDebugPlus", isDirectory: true)
    }
    
    /// Sessions directory — debug session data
    var sessionsDirectory: URL {
        baseDirectory.appendingPathComponent("Sessions", isDirectory: true)
    }
    
    /// Media directory — screenshots, recordings
    var mediaDirectory: URL {
        baseDirectory.appendingPathComponent("Media", isDirectory: true)
    }
    
    /// Screenshots subdirectory
    var screenshotsDirectory: URL {
        mediaDirectory.appendingPathComponent("Screenshots", isDirectory: true)
    }
    
    /// Recordings subdirectory
    var recordingsDirectory: URL {
        mediaDirectory.appendingPathComponent("Recordings", isDirectory: true)
    }
    
    /// Exports directory — HAR files, exported sessions
    var exportsDirectory: URL {
        baseDirectory.appendingPathComponent("Exports", isDirectory: true)
    }
    
    /// Cache directory (system-managed, separate from app support)
    var cacheDirectory: URL {
        guard let cache = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return FileManager.default.temporaryDirectory.appendingPathComponent("TTBDebugPlus", isDirectory: true)
        }
        return cache.appendingPathComponent("TTBDebugPlus", isDirectory: true)
    }
    
    // MARK: - Storage Usage (cached)
    
    var currentUsage: StorageUsage = StorageUsage()
    var isCalculating: Bool = false
    
    // MARK: - Init
    
    init() {
        ensureDirectoriesExist()
    }
    
    // MARK: - Directory Management
    
    /// Create all required directories if they don't exist
    func ensureDirectoriesExist() {
        let directories = [
            sessionsDirectory,
            screenshotsDirectory,
            recordingsDirectory,
            exportsDirectory,
            cacheDirectory
        ]
        
        let fm = FileManager.default
        for dir in directories {
            if !fm.fileExists(atPath: dir.path) {
                try? fm.createDirectory(at: dir, withIntermediateDirectories: true)
            }
        }
    }
    
    // MARK: - Save Operations
    
    /// Save screenshot data, returns URL of saved file
    func saveScreenshot(_ data: Data, deviceName: String) -> URL? {
        let timestamp = TTDateFormatter.iso8601.string(from: Date())
            .replacingOccurrences(of: ":", with: "-")
        let filename = "\(deviceName)_\(timestamp).png"
        let url = screenshotsDirectory.appendingPathComponent(filename)
        
        do {
            try data.write(to: url)
            return url
        } catch {
            print("[Storage] ❌ Failed to save screenshot: \(error)")
            return nil
        }
    }
    
    /// Save recording data, returns URL of saved file
    func saveRecording(_ data: Data, deviceName: String, format: String = "mp4") -> URL? {
        let timestamp = TTDateFormatter.iso8601.string(from: Date())
            .replacingOccurrences(of: ":", with: "-")
        let filename = "\(deviceName)_\(timestamp).\(format)"
        let url = recordingsDirectory.appendingPathComponent(filename)
        
        do {
            try data.write(to: url)
            return url
        } catch {
            print("[Storage] ❌ Failed to save recording: \(error)")
            return nil
        }
    }
    
    // MARK: - Storage Calculation
    
    /// Calculate storage usage for all categories (async)
    func calculateStorageUsage() async -> StorageUsage {
        isCalculating = true
        defer { isCalculating = false }
        
        var usage = StorageUsage()
        
        usage.sessionsSize = directorySize(sessionsDirectory)
        usage.mediaSize = directorySize(screenshotsDirectory) + directorySize(recordingsDirectory)
        usage.exportsSize = directorySize(exportsDirectory)
        usage.cacheSize = directorySize(cacheDirectory)
        
        await MainActor.run {
            currentUsage = usage
        }
        
        return usage
    }
    
    /// Calculate size of a directory recursively
    private func directorySize(_ url: URL) -> Int64 {
        let fm = FileManager.default
        guard let enumerator = fm.enumerator(at: url, includingPropertiesForKeys: [.fileSizeKey], options: [.skipsHiddenFiles]) else {
            return 0
        }
        
        var totalSize: Int64 = 0
        for case let fileURL as URL in enumerator {
            if let values = try? fileURL.resourceValues(forKeys: [.fileSizeKey]),
               let size = values.fileSize {
                totalSize += Int64(size)
            }
        }
        return totalSize
    }
    
    // MARK: - Cleanup Operations
    
    /// Clear cache directory
    func clearCache() throws {
        let fm = FileManager.default
        let contents = try fm.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
        for item in contents {
            try fm.removeItem(at: item)
        }
    }
    
    /// Delete old sessions older than specified days
    func cleanupOldSessions(olderThan days: Int) throws {
        let fm = FileManager.default
        guard let cutoff = Calendar.current.date(byAdding: .day, value: -days, to: Date()) else { return }
        
        let contents = try fm.contentsOfDirectory(
            at: sessionsDirectory,
            includingPropertiesForKeys: [.creationDateKey]
        )
        
        for item in contents {
            if let values = try? item.resourceValues(forKeys: [.creationDateKey]),
               let created = values.creationDate,
               created < cutoff {
                try fm.removeItem(at: item)
            }
        }
    }
    
    /// Delete all stored data (with confirmation expected from caller)
    func deleteAllData() throws {
        let fm = FileManager.default
        let directories = [sessionsDirectory, screenshotsDirectory, recordingsDirectory, exportsDirectory]
        
        for dir in directories {
            let contents = try fm.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil)
            for item in contents {
                try fm.removeItem(at: item)
            }
        }
    }
    
    // MARK: - Finder Integration
    
    /// Reveal a directory in Finder
    func revealInFinder(_ url: URL) {
        NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: url.path)
    }
    
    /// Reveal the base storage directory in Finder
    func revealBaseDirectory() {
        revealInFinder(baseDirectory)
    }
}
