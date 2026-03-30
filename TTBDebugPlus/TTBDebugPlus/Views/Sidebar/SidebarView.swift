//
//  SidebarView.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-27.
//

import SwiftUI

struct SidebarView: View {
    @Environment(AppState.self) var appState
    @Environment(ConnectionManager.self) var connectionManager
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Branding Header
            brandingHeader
            
            Divider()
                .background(Color.ttBorder)
            
            // MARK: - Server Status
            serverStatusBar
            
            Divider()
                .background(Color.ttBorder)
            
            // MARK: - Content
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Connected Devices
                    connectedDevicesSection
                    
                    // Navigation Items
                    navigationSection
                }
                .padding(.horizontal, 12)
                .padding(.top, 12)
            }
            
            Spacer()
            
            // MARK: - Bottom Actions
            bottomActions
        }
        .background(Color.ttBackground.opacity(0.5))
    }
    
    // MARK: - Branding
    private var brandingHeader: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        LinearGradient(
                            colors: [Color.ttPrimary, Color.ttPrimaryDark],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                
                Image(systemName: "ladybug.fill")
                    .font(.ttIcon(TTIcon.xxl))
                    .foregroundColor(.ttTextPrimary)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("TTBDebugPlus")
                    .font(TTFont.heading3)
                    .foregroundColor(.ttTextPrimary)
                
                let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
                Text("V\(version)")
                    .font(TTFont.labelSmall)
                    .foregroundColor(.ttTextTertiary)
                    .tracking(0.5)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
    
    // MARK: - Server Status
    private var serverStatusBar: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(connectionManager.isServerRunning ? Color.ttSuccess : Color.ttError)
                .frame(width: 8, height: 8)
            
            Text(connectionManager.isServerRunning ? "Server Active" : "Server Offline")
                .font(TTFont.labelSmall)
                .foregroundColor(.ttTextSecondary)
            
            Spacer()
            
            if let port = connectionManager.serverPort {
                Text(":\(port)")
                    .font(TTFont.codeSmall)
                    .foregroundColor(.ttTextTertiary)
            }
            
            // Toggle server
            Button(action: {
                if connectionManager.isServerRunning {
                    connectionManager.stopServer()
                } else {
                    connectionManager.startServer()
                }
            }) {
                Image(systemName: connectionManager.isServerRunning ? "stop.circle.fill" : "play.circle.fill")
                    .font(.ttIcon(TTIcon.xl))
                    .foregroundColor(connectionManager.isServerRunning ? .ttError : .ttSuccess)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.ttSurface.opacity(0.3))
    }
    
    // MARK: - Connected Devices
    private var connectedDevicesSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("CONNECTED DEVICES")
                    .font(TTFont.sidebarHeader)
                    .foregroundColor(.ttTextTertiary)
                    .tracking(0.8)
                
                Spacer()
                
                Text("\(connectionManager.onlineDevices.count)")
                    .font(TTFont.badge)
                    .foregroundColor(.ttPrimary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(
                        Capsule()
                            .fill(Color.ttPrimary.opacity(0.15))
                    )
            }
            
            if connectionManager.connectedDevices.isEmpty {
                // No devices — show network hint
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        Image(systemName: "antenna.radiowaves.left.and.right.slash")
                            .font(.ttIcon(TTIcon.lg))
                            .foregroundColor(.ttTextTertiary)
                        Text("No devices found")
                            .font(TTFont.bodySmall)
                            .foregroundColor(.ttTextTertiary)
                    }
                    
                    if let ip = connectionManager.macLocalIP {
                        HStack(spacing: 4) {
                            Image(systemName: "network")
                                .font(.system(size: 9))
                                .foregroundColor(.ttTextMuted)
                            Text("Mac IP: \(ip)")
                                .font(TTFont.codeSmall)
                                .foregroundColor(.ttTextMuted)
                        }
                        .padding(.leading, 28)
                    }
                    
                    Button(action: { appState.selectedTab = .device }) {
                        Text("View Diagnostics →")
                            .font(TTFont.labelSmall)
                            .foregroundColor(.ttPrimary)
                    }
                    .buttonStyle(.plain)
                    .padding(.leading, 28)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 4)
            } else {
                ForEach(connectionManager.connectedDevices) { session in
                    DeviceRowView(
                        session: session,
                        isSelected: connectionManager.selectedDeviceId == session.id
                    )
                    .onTapGesture {
                        connectionManager.selectedDeviceId = session.id
                        appState.selectedTab = .device
                    }
                }
            }
        }
    }
    
    // MARK: - Navigation
    private var navigationSection: some View {
        VStack(spacing: 4) {
            ForEach(SidebarSection.allCases) { section in
                SidebarItemView(
                    section: section,
                    isSelected: appState.selectedSidebarItem == section,
                    badge: badgeCount(for: section)
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        appState.selectedSidebarItem = section
                        switch section {
                        case .devices: appState.selectedTab = .device
                        case .logs: appState.selectedTab = .console
                        case .network: appState.selectedTab = .network
                        case .performance: appState.selectedTab = .performance
                        case .devtools: appState.selectedTab = .devtools
                        }
                    }
                }
            }
        }
    }
    
    private func badgeCount(for section: SidebarSection) -> Int? {
        switch section {
        case .devices: return connectionManager.onlineDevices.count > 0 ? connectionManager.onlineDevices.count : nil
        case .logs: return connectionManager.totalConsoleLogs > 0 ? connectionManager.totalConsoleLogs : nil
        case .network: return connectionManager.totalAPILogs > 0 ? connectionManager.totalAPILogs : nil
        case .performance: return nil
        case .devtools: return nil
        }
    }
    
    // MARK: - Bottom Actions
    private var bottomActions: some View {
        VStack(spacing: 8) {
            Divider()
                .background(Color.ttBorder)
            
            HStack(spacing: 0) {
                Button(action: {
                    #if os(macOS)
                    NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                    #endif
                }) {
                    Label("SETTINGS", systemImage: "gearshape")
                        .font(TTFont.sidebarItem)
                        .foregroundColor(.ttTextSecondary)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                Spacer()
            }
            
            HStack(spacing: 0) {
                Button(action: {
                    appState.selectedTab = .guide
                }) {
                    Label("INTEGRATION GUIDE", systemImage: "book.fill")
                        .font(TTFont.sidebarItem)
                        .foregroundColor(appState.selectedTab == .guide ? .ttPrimary : .ttTextSecondary)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                Spacer()
            }
        }
        .padding(.bottom, 12)
    }
}

// MARK: - Device Row
struct DeviceRowView: View {
    let session: DeviceSession
    var isSelected: Bool = false
    
    var body: some View {
        HStack(spacing: 10) {
            // Device icon
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(session.isOnline ? Color.ttSuccess.opacity(0.12) : Color.ttSurface)
                    .frame(width: 32, height: 32)
                
                Image(systemName: session.isSimulator ? "laptopcomputer" : "iphone")
                    .font(.ttIcon(TTIcon.xl))
                    .foregroundColor(session.isOnline ? .ttSuccess : .ttTextTertiary)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(session.displayName)
                    .font(TTFont.labelMedium)
                    .foregroundColor(isSelected ? .ttPrimary : .ttTextPrimary)
                    .lineLimit(1)
                
                Text(session.osVersionString)
                    .font(TTFont.labelSmall)
                    .foregroundColor(.ttTextTertiary)
            }
            
            Spacer()
            
            // Status
            Circle()
                .fill(session.isOnline ? Color.ttSuccess : Color.ttTextTertiary)
                .frame(width: 6, height: 6)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isSelected ? Color.ttPrimary.opacity(0.12) : Color.clear)
        )
        .contentShape(Rectangle())
    }
}

// MARK: - Updated Sidebar Item with Badge
struct SidebarItemView: View {
    let section: SidebarSection
    let isSelected: Bool
    var badge: Int? = nil
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: section.icon)
                    .font(.ttIcon(TTIcon.xl))
                    .foregroundColor(isSelected ? .ttPrimary : .ttTextTertiary)
                    .frame(width: 20)
                
                Text(section.rawValue)
                    .font(TTFont.sidebarItem)
                    .foregroundColor(isSelected ? .ttPrimary : .ttTextSecondary)
                
                Spacer()
                
                if let badge = badge {
                    Text("\(badge)")
                        .font(TTFont.badge)
                        .foregroundColor(.ttTextTertiary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(Color.ttSurface)
                        )
                }
            }
        }
        .buttonStyle(TTSidebarItemStyle(isSelected: isSelected))
    }
}

#Preview {
    SidebarView()
        .environment(AppState())
        .environment(ConnectionManager())
        .frame(width: 230, height: 800)
        .preferredColorScheme(.dark)
}
