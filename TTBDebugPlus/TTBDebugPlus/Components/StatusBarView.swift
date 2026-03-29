//
//  StatusBarView.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-27.
//  Bottom status bar — increased height, conditional metrics
//

import SwiftUI

struct StatusBarView: View {
    @Environment(AppState.self) var appState
    @Environment(ConnectionManager.self) var connectionManager
    
    private var hasDevice: Bool {
        connectionManager.selectedDevice?.isOnline == true
    }
    
    var body: some View {
        HStack(spacing: 0) {
            // Left side: Server status + device metrics
            HStack(spacing: 16) {
                // Server status
                HStack(spacing: 6) {
                    Circle()
                        .fill(connectionManager.isServerRunning ? Color.ttSuccess : Color.ttError)
                        .frame(width: 6, height: 6)
                    Text(connectionManager.isServerRunning ? "ONLINE" : "OFFLINE")
                        .font(TTFont.statusBar)
                        .foregroundColor(connectionManager.isServerRunning ? .ttSuccess : .ttError)
                }
                
                // Only show metrics when a device is connected (no more "--" values)
                if hasDevice, let perf = connectionManager.selectedDevice?.latestPerformance {
                    // Divider
                    Rectangle()
                        .fill(Color.ttBorder.opacity(0.4))
                        .frame(width: 1, height: 14)
                    
                    // Memory
                    HStack(spacing: 5) {
                        Image(systemName: "memorychip")
                            .font(.system(size: 10))
                            .foregroundColor(.ttTextTertiary)
                        Text(String(format: "%.0f MB", perf.memoryUsedMB))
                            .font(TTFont.statusBar)
                            .foregroundColor(.ttTextSecondary)
                    }
                    
                    // CPU
                    HStack(spacing: 5) {
                        Image(systemName: "cpu")
                            .font(.system(size: 10))
                            .foregroundColor(.ttTextTertiary)
                        Text(String(format: "%.1f%%", perf.cpuUsage))
                            .font(TTFont.statusBar)
                            .foregroundColor(perf.cpuUsage > 80 ? .ttWarning : .ttTextSecondary)
                    }
                }
            }
            .padding(.leading, 16)
            
            Spacer()
            
            // Right side: Connection + events
            HStack(spacing: 12) {
                let totalEvents = connectionManager.totalAPILogs + connectionManager.totalConsoleLogs
                if totalEvents > 0 {
                    Text("\(totalEvents.formatted()) events")
                        .font(TTFont.statusBar)
                        .foregroundColor(.ttTextTertiary)
                    
                    Rectangle()
                        .fill(Color.ttBorder.opacity(0.4))
                        .frame(width: 1, height: 14)
                }
                
                if let device = connectionManager.selectedDevice, device.isOnline {
                    HStack(spacing: 6) {
                        ConnectionIndicator(isConnected: true)
                        Text(device.displayName)
                            .font(TTFont.statusBar)
                            .foregroundColor(.ttTextSecondary)
                    }
                } else if connectionManager.onlineDevices.isEmpty {
                    ConnectionIndicator(isConnected: false, label: "No device")
                }
            }
            .padding(.trailing, 16)
        }
        .frame(height: 32)
        .background(Color.ttBackground)
        .overlay(
            Rectangle()
                .fill(Color.ttBorder.opacity(0.3))
                .frame(height: 1),
            alignment: .top
        )
    }
}

#Preview {
    StatusBarView()
        .environment(AppState())
        .environment(ConnectionManager())
        .preferredColorScheme(.dark)
}
