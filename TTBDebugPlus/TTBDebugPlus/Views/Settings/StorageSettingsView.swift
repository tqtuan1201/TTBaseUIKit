//
//  StorageSettingsView.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-29.
//  Settings tab showing storage usage, data locations, and cleanup actions
//

import SwiftUI

struct StorageSettingsView: View {
    @Environment(StorageManager.self) var storageManager
    @AppStorage("maxLogEntries") private var maxLogEntries: Int = 10000
    @AppStorage("autoCleanupDays") private var autoCleanupDays: Int = 30
    
    @State private var showDeleteConfirmation = false
    @State private var showClearCacheConfirmation = false
    @State private var cleanupMessage: String? = nil
    
    var body: some View {
        Form {
            // Storage Usage
            Section("Storage Usage") {
                if storageManager.isCalculating {
                    HStack {
                        ProgressView()
                            .scaleEffect(0.7)
                        Text("Calculating...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } else {
                    storageRow(title: "Sessions", size: storageManager.currentUsage.sessionsSize)
                    storageRow(title: "Media (Screenshots & Recordings)", size: storageManager.currentUsage.mediaSize)
                    storageRow(title: "Exports", size: storageManager.currentUsage.exportsSize)
                    storageRow(title: "Cache", size: storageManager.currentUsage.cacheSize)
                    
                    Divider()
                    
                    HStack {
                        Text("Total")
                            .font(.body.weight(.semibold))
                        Spacer()
                        Text(storageManager.currentUsage.formattedTotal)
                            .font(.body.weight(.semibold))
                            .foregroundColor(.ttPrimary)
                    }
                }
                
                Button("Refresh") {
                    Task {
                        await storageManager.calculateStorageUsage()
                    }
                }
                .font(.caption)
            }
            
            // Data Locations
            Section("Data Locations") {
                locationRow(
                    title: "Application Data",
                    path: storageManager.baseDirectory.path,
                    action: { storageManager.revealBaseDirectory() }
                )
                
                locationRow(
                    title: "Screenshots",
                    path: storageManager.screenshotsDirectory.path,
                    action: { storageManager.revealInFinder(storageManager.screenshotsDirectory) }
                )
                
                locationRow(
                    title: "Recordings",
                    path: storageManager.recordingsDirectory.path,
                    action: { storageManager.revealInFinder(storageManager.recordingsDirectory) }
                )
                
                locationRow(
                    title: "Cache",
                    path: storageManager.cacheDirectory.path,
                    action: { storageManager.revealInFinder(storageManager.cacheDirectory) }
                )
            }
            
            // Retention Settings
            Section("Data Retention") {
                Stepper("Max log entries: \(maxLogEntries.formatted())", value: $maxLogEntries, in: 1000...100000, step: 1000)
                Stepper("Auto-cleanup after: \(autoCleanupDays) days", value: $autoCleanupDays, in: 1...365)
            }
            
            // Cleanup Actions
            Section("Cleanup") {
                Button("Clear Cache") {
                    showClearCacheConfirmation = true
                }
                .foregroundColor(.ttWarning)
                
                Button("Delete All Data") {
                    showDeleteConfirmation = true
                }
                .foregroundColor(.ttError)
                
                if let msg = cleanupMessage {
                    Text(msg)
                        .font(.caption)
                        .foregroundColor(.ttSuccess)
                }
            }
        }
        .formStyle(.grouped)
        .padding()
        .onAppear {
            Task {
                await storageManager.calculateStorageUsage()
            }
        }
        .alert("Clear Cache?", isPresented: $showClearCacheConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Clear", role: .destructive) {
                try? storageManager.clearCache()
                cleanupMessage = "Cache cleared"
                Task { await storageManager.calculateStorageUsage() }
            }
        } message: {
            Text("This will remove temporary cached data. Active sessions will not be affected.")
        }
        .alert("Delete All Data?", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Delete All", role: .destructive) {
                try? storageManager.deleteAllData()
                cleanupMessage = "All data deleted"
                Task { await storageManager.calculateStorageUsage() }
            }
        } message: {
            Text("This will permanently delete all sessions, screenshots, recordings, and exports. This action cannot be undone.")
        }
    }
    
    // MARK: - Helpers
    
    private func storageRow(title: String, size: Int64) -> some View {
        HStack {
            Text(title)
                .font(.body)
            Spacer()
            Text(storageManager.currentUsage.formatted(size))
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
    
    private func locationRow(title: String, path: String, action: @escaping () -> Void) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                Text(path)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
            
            Spacer()
            
            Button("Reveal") {
                action()
            }
            .font(.caption)
        }
    }
}
