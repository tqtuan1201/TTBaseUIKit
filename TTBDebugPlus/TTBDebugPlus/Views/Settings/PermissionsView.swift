//
//  PermissionsView.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-29.
//  Settings tab showing permission status and system settings links
//

import SwiftUI

struct PermissionsView: View {
    @Environment(ConnectionManager.self) var connectionManager
    
    var body: some View {
        Form {
            // Local Network
            Section("Local Network") {
                HStack(spacing: 12) {
                    permissionIcon(granted: connectionManager.isServerRunning)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Local Network Access")
                            .font(.body)
                        
                        Text(connectionManager.isServerRunning
                             ? "Granted — Bonjour server is running"
                             : "Unknown — Server not started or permission denied")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button("Open Settings") {
                        openSystemSettings("x-apple.systempreferences:com.apple.preference.security?Privacy_LocalNetwork")
                    }
                    .font(.caption)
                }
                
                Text("TTBDebugPlus uses the local network to discover and communicate with iOS devices running the debug bridge SDK via Bonjour (_ttbdebug._tcp).")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Network & Firewall
            Section("Firewall") {
                HStack(spacing: 12) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.ttWarning)
                        .frame(width: 20)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Firewall Configuration")
                            .font(.body)
                        
                        Text("If the firewall is enabled, ensure TTBDebugPlus is allowed to receive incoming connections.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button("Open Firewall") {
                        openSystemSettings("x-apple.systempreferences:com.apple.preference.security?Firewall")
                    }
                    .font(.caption)
                }
            }
            
            // Sandbox Info
            Section("App Sandbox") {
                VStack(alignment: .leading, spacing: 8) {
                    permissionRow(
                        icon: "network",
                        title: "Network Server",
                        description: "Incoming connections (Bonjour listener)",
                        granted: true
                    )
                    
                    permissionRow(
                        icon: "globe",
                        title: "Network Client",
                        description: "Outgoing connections",
                        granted: true
                    )
                    
                    permissionRow(
                        icon: "folder",
                        title: "User-Selected Files",
                        description: "Read/write via open and save panels",
                        granted: true
                    )
                }
                
                Text("These permissions are declared in the app's entitlements and are always enabled.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .formStyle(.grouped)
        .padding()
    }
    
    // MARK: - Helpers
    
    private func permissionIcon(granted: Bool) -> some View {
        Image(systemName: granted ? "checkmark.circle.fill" : "questionmark.circle.fill")
            .foregroundColor(granted ? .ttSuccess : .ttWarning)
            .font(.ttIcon(TTIcon.xxxl))
            .frame(width: 20)
    }
    
    private func permissionRow(icon: String, title: String, description: String, granted: Bool) -> some View {
        HStack(spacing: 8) {
            Image(systemName: granted ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(granted ? .ttSuccess : .ttError)
                .font(.ttIcon(TTIcon.xl))
            
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.callout)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private func openSystemSettings(_ urlString: String) {
        if let url = URL(string: urlString) {
            NSWorkspace.shared.open(url)
        }
    }
}
