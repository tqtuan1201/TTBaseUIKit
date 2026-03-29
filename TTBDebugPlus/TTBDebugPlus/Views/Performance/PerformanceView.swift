//
//  PerformanceView.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-27.
//  Real-time performance monitoring dashboard with charts
//

import SwiftUI
import Charts

struct PerformanceView: View {
    @Environment(AppState.self) var appState
    @Environment(ConnectionManager.self) var connectionManager
    @State private var viewModel = PerformanceViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    Text("Performance Monitor")
                        .font(TTFont.displayMedium)
                        .foregroundColor(.ttTextPrimary)
                    Spacer()
                    if viewModel.cpuAlert || viewModel.memoryAlert {
                        StatusBadge(text: "⚠️ ALERT", color: .ttWarning)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                // Metric Cards Row
                HStack(spacing: 16) {
                    metricCard(
                        title: "CPU USAGE",
                        value: String(format: "%.1f%%", viewModel.currentCPU),
                        icon: "cpu",
                        color: viewModel.cpuAlert ? .ttError : .ttPrimary,
                        alert: viewModel.cpuAlert
                    )
                    metricCard(
                        title: "MEMORY",
                        value: String(format: "%.0f MB", viewModel.currentMemory),
                        icon: "memorychip",
                        color: viewModel.memoryAlert ? .ttError : .ttSuccess,
                        alert: viewModel.memoryAlert,
                        subtitle: String(format: "of %.0f MB total", viewModel.totalMemory)
                    )
                    if let fps = viewModel.currentFPS {
                        metricCard(
                            title: "FPS",
                            value: String(format: "%.0f", fps),
                            icon: "speedometer",
                            color: fps >= 55 ? .ttSuccess : .ttWarning
                        )
                    } else {
                        metricCard(
                            title: "FPS",
                            value: "N/A",
                            icon: "speedometer",
                            color: .ttTextTertiary
                        )
                    }
                    if let disk = viewModel.diskUsed {
                        metricCard(
                            title: "DISK USED",
                            value: String(format: "%.1f GB", disk / 1024),
                            icon: "internaldrive",
                            color: .ttTextSecondary
                        )
                    } else {
                        metricCard(
                            title: "DISK USED",
                            value: "N/A",
                            icon: "internaldrive",
                            color: .ttTextTertiary
                        )
                    }
                }
                .padding(.horizontal, 24)
                
                // Charts
                if viewModel.cpuHistory.isEmpty && viewModel.memoryHistory.isEmpty {
                    // Empty state for charts
                    CardView(title: "PERFORMANCE CHARTS") {
                        VStack(spacing: 12) {
                            Image(systemName: "chart.xyaxis.line")
                                .font(TTFont.displayLarge)
                                .foregroundColor(.ttTextTertiary)
                            Text("Waiting for metrics data...")
                                .font(TTFont.bodyMedium)
                                .foregroundColor(.ttTextTertiary)
                            Text("Performance charts will appear when data is received from the device.")
                                .font(TTFont.labelSmall)
                                .foregroundColor(.ttTextTertiary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    }
                    .padding(.horizontal, 24)
                } else {
                    HStack(alignment: .top, spacing: 16) {
                        cpuChart
                        memoryChart
                    }
                    .padding(.horizontal, 24)
                    
                    // Network bandwidth
                    networkChart
                        .padding(.horizontal, 24)
                }
                
                // API Analytics
                apiAnalyticsSection
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
            }
        }
        .background(Color.ttBackground)
        .onAppear {
            viewModel.syncMetrics(from: connectionManager)
            viewModel.analyzeAPIs(from: connectionManager.allAPILogs)
        }
        .onChange(of: connectionManager.totalAPILogs + connectionManager.totalConsoleLogs) {
            viewModel.syncMetrics(from: connectionManager)
            viewModel.analyzeAPIs(from: connectionManager.allAPILogs)
        }
    }
    
    // MARK: - Metric Card
    private func metricCard(title: String, value: String, icon: String, color: Color, alert: Bool = false, subtitle: String? = nil) -> some View {
        CardView(title: title) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color.opacity(0.12))
                        .frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .font(.ttIcon(TTIcon.xxxl))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(value)
                        .font(TTFont.heading2)
                        .foregroundColor(alert ? color : .ttTextPrimary)
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(TTFont.labelSmall)
                            .foregroundColor(.ttTextTertiary)
                    }
                }
            }
        }
    }
    
    // MARK: - CPU Chart
    private var cpuChart: some View {
        CardView(title: "CPU USAGE (%)") {
            Chart(viewModel.cpuHistory) { point in
                LineMark(
                    x: .value("Time", point.timestamp),
                    y: .value("CPU", point.value)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [.ttPrimary, .ttPrimaryLight],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .lineStyle(StrokeStyle(lineWidth: 2))
                
                AreaMark(
                    x: .value("Time", point.timestamp),
                    y: .value("CPU", point.value)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [.ttPrimary.opacity(0.3), .ttPrimary.opacity(0.0)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
            .chartYScale(domain: 0...100)
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: 4)) {
                    AxisValueLabel(format: .dateTime.hour().minute())
                        .foregroundStyle(Color.ttTextTertiary)
                }
            }
            .chartYAxis {
                AxisMarks(values: [0, 25, 50, 75, 100]) {
                    AxisValueLabel()
                        .foregroundStyle(Color.ttTextTertiary)
                    AxisGridLine()
                        .foregroundStyle(Color.ttBorder.opacity(0.3))
                }
            }
            .frame(height: 180)
        }
    }
    
    // MARK: - Memory Chart
    private var memoryChart: some View {
        CardView(title: "MEMORY (MB)") {
            Chart(viewModel.memoryHistory) { point in
                AreaMark(
                    x: .value("Time", point.timestamp),
                    y: .value("Memory", point.value)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [.ttSuccess.opacity(0.4), .ttSuccess.opacity(0.05)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                LineMark(
                    x: .value("Time", point.timestamp),
                    y: .value("Memory", point.value)
                )
                .foregroundStyle(Color.ttSuccess)
                .lineStyle(StrokeStyle(lineWidth: 2))
            }
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: 4)) {
                    AxisValueLabel(format: .dateTime.hour().minute())
                        .foregroundStyle(Color.ttTextTertiary)
                }
            }
            .chartYAxis {
                AxisMarks {
                    AxisValueLabel()
                        .foregroundStyle(Color.ttTextTertiary)
                    AxisGridLine()
                        .foregroundStyle(Color.ttBorder.opacity(0.3))
                }
            }
            .frame(height: 180)
        }
    }
    
    // MARK: - Network Chart
    private var networkChart: some View {
        CardView(title: "NETWORK BANDWIDTH (KB/s)") {
            Chart {
                ForEach(viewModel.networkSentHistory) { point in
                    BarMark(
                        x: .value("Time", point.timestamp),
                        y: .value("Sent", point.value)
                    )
                    .foregroundStyle(Color.ttPrimary.opacity(0.7))
                }
                
                ForEach(viewModel.networkRecvHistory) { point in
                    BarMark(
                        x: .value("Time", point.timestamp),
                        y: .value("Recv", -point.value)
                    )
                    .foregroundStyle(Color.ttSuccess.opacity(0.7))
                }
            }
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: 6)) {
                    AxisValueLabel(format: .dateTime.hour().minute().second())
                        .foregroundStyle(Color.ttTextTertiary)
                }
            }
            .chartYAxis {
                AxisMarks {
                    AxisValueLabel()
                        .foregroundStyle(Color.ttTextTertiary)
                    AxisGridLine()
                        .foregroundStyle(Color.ttBorder.opacity(0.3))
                }
            }
            .frame(height: 150)
            
            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Circle().fill(Color.ttPrimary).frame(width: 8, height: 8)
                    Text("Upload").font(TTFont.labelSmall).foregroundColor(.ttTextTertiary)
                }
                HStack(spacing: 4) {
                    Circle().fill(Color.ttSuccess).frame(width: 8, height: 8)
                    Text("Download").font(TTFont.labelSmall).foregroundColor(.ttTextTertiary)
                }
            }
        }
    }
    
    // MARK: - API Analytics
    private var apiAnalyticsSection: some View {
        CardView(title: "API ANALYTICS") {
            VStack(spacing: 14) {
                analyticsRow(label: "Avg Response Time", value: String(format: "%.0fms", viewModel.averageResponseTime), color: viewModel.averageResponseTime > 1000 ? .ttWarning : .ttTextPrimary)
                Divider().background(Color.ttBorder.opacity(0.2))
                analyticsRow(label: "Slow Requests (>\(Int(viewModel.slowAPIThreshold))ms)", value: "\(viewModel.slowRequestCount)", color: viewModel.slowRequestCount > 0 ? .ttWarning : .ttSuccess)
                Divider().background(Color.ttBorder.opacity(0.2))
                analyticsRow(label: "Duplicate Requests", value: "\(viewModel.duplicateRequestCount)", color: viewModel.duplicateRequestCount > 0 ? .ttWarning : .ttSuccess)
                Divider().background(Color.ttBorder.opacity(0.2))
                analyticsRow(label: "Error Rate", value: String(format: "%.1f%%", viewModel.errorRate), color: viewModel.errorRate > 5 ? .ttError : .ttSuccess)
            }
        }
    }
    
    private func analyticsRow(label: String, value: String, color: Color) -> some View {
        HStack {
            Text(label)
                .font(TTFont.bodyMedium)
                .foregroundColor(.ttTextSecondary)
            Spacer()
            Text(value)
                .font(TTFont.codeLarge)
                .foregroundColor(color)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    PerformanceView()
        .environment(AppState())
        .environment(ConnectionManager())
        .frame(width: 1100, height: 900)
        .preferredColorScheme(.dark)
}
