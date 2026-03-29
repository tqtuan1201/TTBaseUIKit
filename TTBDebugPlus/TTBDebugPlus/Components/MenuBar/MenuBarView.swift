//
//  MenuBarView.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-29.
//  Menu bar extra content — quick access to server status, devices, and actions
//

import SwiftUI

struct MenuBarView: View {
    @Environment(ConnectionManager.self) var connectionManager
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header
            headerSection
            
            Divider()
                .padding(.vertical, 4)
            
            // MARK: - Server Status
            serverStatusSection
            
            Divider()
                .padding(.vertical, 4)
            
            // MARK: - Connected Devices
            devicesSection
            
            Divider()
                .padding(.vertical, 4)
            
            // MARK: - Quick Actions
            quickActionsSection
            
            Divider()
                .padding(.vertical, 4)
            
            // MARK: - App Actions
            appActionsSection
        }
        .padding(.vertical, 8)
        .frame(width: 280)
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [Color.ttPrimary, Color.ttPrimaryDark],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 32, height: 32)
                
                Image(systemName: "ladybug.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 1) {
                Text("TTBDebugPlus")
                    .font(.system(size: 13, weight: .semibold))
                
                Text("v\(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0")")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Connection count badge
            if connectionManager.onlineDevices.count > 0 {
                Text("\(connectionManager.onlineDevices.count)")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Capsule().fill(Color.ttSuccess))
            }
        }
        .padding(.horizontal, 12)
    }
    
    // MARK: - Server Status
    
    private var serverStatusSection: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(connectionManager.isServerRunning ? Color.ttSuccess : Color.ttError)
                .frame(width: 8, height: 8)
            
            Text(connectionManager.isServerRunning ? "Server Active" : "Server Offline")
                .font(.system(size: 12))
            
            Spacer()
            
            if let port = connectionManager.serverPort {
                Text(":\(port)")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(.secondary)
            }
            
            Button(action: {
                if connectionManager.isServerRunning {
                    connectionManager.stopServer()
                } else {
                    connectionManager.startServer()
                }
            }) {
                Text(connectionManager.isServerRunning ? "Stop" : "Start")
                    .font(.system(size: 11, weight: .medium))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(connectionManager.isServerRunning
                                  ? Color.ttError.opacity(0.15)
                                  : Color.ttSuccess.opacity(0.15))
                    )
                    .foregroundColor(connectionManager.isServerRunning ? .ttError : .ttSuccess)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12)
    }
    
    // MARK: - Devices
    
    private var devicesSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("CONNECTED DEVICES")
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.secondary)
                .tracking(0.5)
                .padding(.horizontal, 12)
            
            if connectionManager.connectedDevices.isEmpty {
                HStack(spacing: 6) {
                    Image(systemName: "antenna.radiowaves.left.and.right.slash")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                    Text("No devices connected")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
            } else {
                ForEach(connectionManager.connectedDevices) { session in
                    MenuBarDeviceRow(session: session)
                }
            }
        }
    }
    
    // MARK: - Quick Actions
    
    private var quickActionsSection: some View {
        VStack(spacing: 2) {
            MenuBarActionButton(
                icon: "trash",
                title: "Clear All Logs",
                shortcut: "⌘K"
            ) {
                connectionManager.clearAllLogs()
            }
            
            MenuBarActionButton(
                icon: "camera",
                title: "Capture Screenshot",
                shortcut: "⇧⌘C"
            ) {
                connectionManager.requestScreenshot()
            }
        }
    }
    
    // MARK: - App Actions
    
    private var appActionsSection: some View {
        VStack(spacing: 2) {
            MenuBarActionButton(
                icon: "macwindow",
                title: "Open Main Window",
                shortcut: ""
            ) {
                NSApplication.shared.activate(ignoringOtherApps: true)
                openWindow(id: "main-window")
            }
            
            Divider()
                .padding(.vertical, 4)
            
            MenuBarActionButton(
                icon: "gearshape",
                title: "Preferences...",
                shortcut: "⌘,"
            ) {
                NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                NSApplication.shared.activate(ignoringOtherApps: true)
            }
            
            Divider()
                .padding(.vertical, 4)
            
            MenuBarActionButton(
                icon: "power",
                title: "Quit TTBDebugPlus",
                shortcut: "⌘Q",
                isDestructive: true
            ) {
                NSApplication.shared.terminate(nil)
            }
        }
    }
}

// MARK: - Action Button

struct MenuBarActionButton: View {
    let icon: String
    let title: String
    let shortcut: String
    var isDestructive: Bool = false
    let action: () -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                    .foregroundColor(isDestructive ? .ttError : .primary)
                    .frame(width: 16)
                
                Text(title)
                    .font(.system(size: 12))
                    .foregroundColor(isDestructive ? .ttError : .primary)
                
                Spacer()
                
                if !shortcut.isEmpty {
                    Text(shortcut)
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(isHovered ? Color.primary.opacity(0.08) : Color.clear)
            )
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}
