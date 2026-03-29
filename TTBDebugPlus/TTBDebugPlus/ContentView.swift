//
//  ContentView.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-27.
//

import SwiftUI

struct ContentView: View {
    @Environment(AppState.self) var appState
    @Environment(ConnectionManager.self) var connectionManager
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            // MARK: - Sidebar
            SidebarView()
                .navigationSplitViewColumnWidth(min: 200, ideal: 230, max: 280)
        } detail: {
            // MARK: - Main Content Area
            VStack(spacing: 0) {
                // Top Tab Bar
                TabBarView()
                
                // Content area based on selected tab
                mainContentView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Bottom Status Bar
                StatusBarView()
            }
            .background(Color.ttBackground)
        }
        .navigationSplitViewStyle(.balanced)
        .onAppear {
            syncAppStateFromConnectionManager()
        }
        .onChange(of: connectionManager.totalAPILogs + connectionManager.totalConsoleLogs) {
            syncAppStateFromConnectionManager()
        }
    }
    
    @ViewBuilder
    private var mainContentView: some View {
        switch appState.selectedTab {
        case .console:
            ConsoleView()
        case .network:
            NetworkView()
        case .device:
            DeviceView()
        case .performance:
            PerformanceView()
        case .devtools:
            DevToolsView()
        case .feedback:
            FeedbackView()
        case .guide:
            GuideContainerView()
        }
    }
    
    /// Sync ConnectionManager's live data into AppState for views that use it
    private func syncAppStateFromConnectionManager() {
        appState.isServerRunning = connectionManager.isServerRunning
        appState.totalEvents = connectionManager.totalAPILogs + connectionManager.totalConsoleLogs
        
        // Update connected devices from real connections (keep mock if none)
        if !connectionManager.connectedDevices.isEmpty {
            appState.connectedDevices = connectionManager.connectedDevices.map { session in
                ConnectedDevice(
                    id: session.shortId,
                    name: session.displayName,
                    osVersion: session.osVersionString,
                    appName: session.appNameString,
                    appVersion: session.deviceInfo?.appVersion ?? "Unknown",
                    isConnected: session.isOnline,
                    isSimulator: session.isSimulator
                )
            }
        }
        
        // Update performance from latest metrics
        if let perf = connectionManager.selectedDevice?.latestPerformance {
            appState.memoryUsage = perf.memoryUsedMB
            appState.cpuUsage = perf.cpuUsage
        }
    }
}

#Preview {
    ContentView()
        .environment(AppState())
        .environment(ConnectionManager())
        .frame(width: 1400, height: 900)
}
