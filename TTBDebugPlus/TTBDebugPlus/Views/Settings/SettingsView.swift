//
//  SettingsView.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-27.
//

import SwiftUI

struct SettingsView: View {
    @Environment(AppState.self) var appState
    @AppStorage("appearance") private var appearance: String = "dark"
    @AppStorage("bonjourPort") private var bonjourPort: Int = 8899
    @AppStorage("heartbeatInterval") private var heartbeatInterval: Int = 5
    @AppStorage("maxLogEntries") private var maxLogEntries: Int = 10000
    @AppStorage("autoCleanupDays") private var autoCleanupDays: Int = 30
    @AppStorage("maskAuthHeaders") private var maskAuthHeaders: Bool = true
    @AppStorage("showTimestamps") private var showTimestamps: Bool = true
    @AppStorage("jsonIndentation") private var jsonIndentation: Int = 2
    
    var body: some View {
        TabView {
            // General
            generalSettings
                .tabItem {
                    Label("General", systemImage: "gearshape")
                }
            
            // Connection
            connectionSettings
                .tabItem {
                    Label("Connection", systemImage: "antenna.radiowaves.left.and.right")
                }
            
            // Permissions
            PermissionsView()
                .tabItem {
                    Label("Permissions", systemImage: "lock.shield")
                }
            
            // Storage
            StorageSettingsView()
                .tabItem {
                    Label("Storage", systemImage: "externaldrive")
                }
            
            // Dev Tools
            devToolsSettings
                .tabItem {
                    Label("Dev Tools", systemImage: "wrench.and.screwdriver")
                }
            
            // Privacy
            privacySettings
                .tabItem {
                    Label("Privacy", systemImage: "lock.shield")
                }
        }
        .frame(width: 560, height: 450)
    }
    
    // MARK: - General
    private var generalSettings: some View {
        Form {
            Section("Appearance") {
                Picker("Theme", selection: $appearance) {
                    Text("Dark").tag("dark")
                    Text("Light").tag("light")
                    Text("System").tag("system")
                }
                .pickerStyle(.segmented)
                
                Toggle("Show Timestamps", isOn: $showTimestamps)
                
                Stepper("JSON Indentation: \(jsonIndentation) spaces", value: $jsonIndentation, in: 1...8)
            }
            
            Section("Keyboard Shortcuts") {
                HStack {
                    Text("Clear Console")
                    Spacer()
                    Text("⌘K")
                        .font(TTFont.codeMedium)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Search")
                    Spacer()
                    Text("⌘F")
                        .font(TTFont.codeMedium)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Capture Screenshot")
                    Spacer()
                    Text("⇧⌘C")
                        .font(TTFont.codeMedium)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Export Session")
                    Spacer()
                    Text("⇧⌘E")
                        .font(TTFont.codeMedium)
                        .foregroundColor(.secondary)
                }
            }
        }
        .formStyle(.grouped)
        .padding()
    }
    
    // MARK: - Connection
    private var connectionSettings: some View {
        Form {
            Section("Bonjour Service") {
                Stepper("Port: \(bonjourPort)", value: $bonjourPort, in: 1024...65535)
                Text("Service Type: _ttbdebug._tcp")
                    .foregroundColor(.secondary)
            }
            
            Section("Heartbeat") {
                Stepper("Interval: \(heartbeatInterval)s", value: $heartbeatInterval, in: 1...30)
                Text("Device considered offline after \(heartbeatInterval * 2)s without heartbeat")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .formStyle(.grouped)
        .padding()
    }
    
    // MARK: - Data
    private var dataSettings: some View {
        Form {
            Section("Log Retention") {
                Stepper("Max entries per session: \(maxLogEntries.formatted())", value: $maxLogEntries, in: 1000...100000, step: 1000)
                Stepper("Auto-cleanup after: \(autoCleanupDays) days", value: $autoCleanupDays, in: 1...365)
            }
            
            Section("Storage") {
                HStack {
                    Text("Database Location")
                    Spacer()
                    Text("~/Library/Application Support/TTBDebugPlus/")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .truncationMode(.middle)
                }
            }
        }
        .formStyle(.grouped)
        .padding()
    }
    
    // MARK: - Dev Tools
    private var devToolsSettings: some View {
        Form {
            Section("JSON Editor") {
                Stepper("Default Indentation: \(jsonIndentation) spaces", value: $jsonIndentation, in: 1...8)
                
                Text("This indentation is used when formatting/beautifying JSON in the editor.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Section("Available Tools") {
                HStack {
                    Image(systemName: "curlybraces")
                        .foregroundColor(.ttPrimary)
                    Text("JSON Editor")
                    Spacer()
                    Text("Available")
                        .font(.caption)
                        .foregroundColor(.ttSuccess)
                }
                HStack {
                    Image(systemName: "textformat.abc")
                        .foregroundColor(.secondary)
                    Text("Base64 Encoder/Decoder")
                    Spacer()
                    Text("Coming Soon")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Image(systemName: "link")
                        .foregroundColor(.secondary)
                    Text("URL Encoder/Decoder")
                    Spacer()
                    Text("Coming Soon")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Section("Keyboard Shortcuts") {
                HStack {
                    Text("Navigate to Dev Tools")
                    Spacer()
                    Text("⌘5")
                        .font(TTFont.codeMedium)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Format JSON")
                    Spacer()
                    Text("⌥⇧F")
                        .font(TTFont.codeMedium)
                        .foregroundColor(.secondary)
                }
            }
        }
        .formStyle(.grouped)
        .padding()
    }
    
    // MARK: - Privacy
    private var privacySettings: some View {
        Form {
            Section("Data Masking") {
                Toggle("Mask Authorization Headers", isOn: $maskAuthHeaders)
                Text("When enabled, Bearer tokens and API keys are hidden in the UI")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Section("Security") {
                Text("All communication is local network only — no data is sent to external servers.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Log data is stored in the macOS app sandbox and protected by filesystem encryption.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .formStyle(.grouped)
        .padding()
    }
}

#Preview {
    SettingsView()
        .environment(AppState())
        .environment(ConnectionManager())
        .environment(StorageManager())
}
