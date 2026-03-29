//
//  NetworkStatsView.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-27.
//  Network analytics dashboard with per-device breakdown, domain stats, and timing charts
//

import SwiftUI
import Charts

// MARK: - Network Stats View
struct NetworkStatsView: View {
    let viewModel: NetworkViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    Text("API Analytics")
                        .font(TTFont.displayMedium)
                        .foregroundColor(.ttTextPrimary)
                    
                    Spacer()
                    
                    Text("\(viewModel.totalRequests) requests")
                        .font(TTFont.labelMedium)
                        .foregroundColor(.ttTextTertiary)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                // Summary Cards
                HStack(spacing: 16) {
                    statCard(title: "TOTAL", value: "\(viewModel.totalRequests)", icon: "arrow.up.arrow.down", color: .ttPrimary)
                    statCard(title: "FAILED", value: "\(viewModel.failedRequests)", icon: "xmark.circle", color: .ttError)
                    statCard(title: "AVG TIME", value: String(format: "%.0fms", viewModel.averageResponseTime), icon: "clock", color: .ttWarning)
                    statCard(title: "DATA", value: formatBytes(viewModel.totalDataTransferred), icon: "arrow.down.circle", color: .ttSuccess)
                    statCard(title: "ERROR RATE", value: String(format: "%.1f%%", viewModel.errorRate), icon: "exclamationmark.triangle", color: viewModel.errorRate > 10 ? .ttError : .ttSuccess)
                }
                .padding(.horizontal, 24)
                
                // Per-Device Breakdown
                if viewModel.deviceDistribution.count > 1 {
                    chartCard(title: "Requests by Device") {
                        Chart {
                            ForEach(viewModel.deviceDistribution, id: \.deviceId) { item in
                                BarMark(
                                    x: .value("Count", item.count),
                                    y: .value("Device", item.deviceName)
                                )
                                .foregroundStyle(Color.forDevice(item.deviceId))
                                .cornerRadius(4)
                                .annotation(position: .trailing) {
                                    Text("\(item.count)")
                                        .font(TTFont.codeSmall)
                                        .foregroundColor(.ttTextTertiary)
                                }
                            }
                        }
                        .chartXAxis(.hidden)
                        .chartYAxis {
                            AxisMarks { _ in
                                AxisValueLabel()
                                    .font(TTFont.codeMedium)
                                    .foregroundStyle(Color.ttTextSecondary)
                            }
                        }
                        .frame(height: CGFloat(max(viewModel.deviceDistribution.count * 40, 80)))
                    }
                    .padding(.horizontal, 24)
                }
                
                // Charts Row
                HStack(alignment: .top, spacing: 16) {
                    // Method Distribution
                    chartCard(title: "HTTP Method Distribution") {
                        if !viewModel.methodDistribution.isEmpty {
                            Chart {
                                ForEach(viewModel.methodDistribution, id: \.method) { item in
                                    BarMark(
                                        x: .value("Count", item.count),
                                        y: .value("Method", item.method)
                                    )
                                    .foregroundStyle(colorForMethod(item.method))
                                    .cornerRadius(4)
                                    .annotation(position: .trailing) {
                                        Text("\(item.count)")
                                            .font(TTFont.codeSmall)
                                            .foregroundColor(.ttTextTertiary)
                                    }
                                }
                            }
                            .chartXAxis(.hidden)
                            .chartYAxis {
                                AxisMarks { _ in
                                    AxisValueLabel()
                                        .font(TTFont.codeMedium)
                                        .foregroundStyle(Color.ttTextSecondary)
                                }
                            }
                            .frame(height: CGFloat(max(viewModel.methodDistribution.count * 35, 80)))
                        } else {
                            emptyChart
                        }
                    }
                    
                    // Status Code Distribution
                    chartCard(title: "Status Code Distribution") {
                        if viewModel.totalRequests > 0 {
                            Chart {
                                ForEach(viewModel.statusDistribution, id: \.range) { item in
                                    if item.count > 0 {
                                        SectorMark(
                                            angle: .value("Count", item.count),
                                            innerRadius: .ratio(0.55),
                                            angularInset: 2
                                        )
                                        .foregroundStyle(colorForStatusGroup(item.color))
                                        .annotation(position: .overlay) {
                                            if item.count > 0 {
                                                VStack(spacing: 1) {
                                                    Text(item.range)
                                                        .font(TTFont.labelSmall)
                                                        .foregroundColor(.ttTextPrimary)
                                                        .fontWeight(.bold)
                                                    Text("\(item.count)")
                                                        .font(TTFont.codeSmall)
                                                        .foregroundColor(.white.opacity(0.8))
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .frame(height: 160)
                        } else {
                            emptyChart
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                // Response Time Distribution + Domain Distribution
                HStack(alignment: .top, spacing: 16) {
                    // Response Time Histogram
                    chartCard(title: "Response Time Distribution") {
                        if viewModel.totalRequests > 0 {
                            Chart {
                                ForEach(viewModel.responseTimeDistribution, id: \.range) { item in
                                    BarMark(
                                        x: .value("Range", item.range),
                                        y: .value("Count", item.count)
                                    )
                                    .foregroundStyle(
                                        item.range.contains(">") || item.range.contains("5s")
                                            ? Color.ttError.opacity(0.7)
                                            : item.range.contains("1s")
                                                ? Color.ttWarning.opacity(0.7)
                                                : Color.ttPrimary.opacity(0.7)
                                    )
                                    .cornerRadius(4)
                                    .annotation(position: .top) {
                                        if item.count > 0 {
                                            Text("\(item.count)")
                                                .font(TTFont.codeSmall)
                                                .foregroundColor(.ttTextTertiary)
                                        }
                                    }
                                }
                            }
                            .chartYAxis {
                                AxisMarks { _ in
                                    AxisValueLabel()
                                        .font(TTFont.codeSmall)
                                        .foregroundStyle(Color.ttTextTertiary)
                                    AxisGridLine()
                                        .foregroundStyle(Color.ttBorder.opacity(0.2))
                                }
                            }
                            .chartXAxis {
                                AxisMarks { _ in
                                    AxisValueLabel()
                                        .font(TTFont.codeSmall)
                                        .foregroundStyle(Color.ttTextSecondary)
                                }
                            }
                            .frame(height: 160)
                        } else {
                            emptyChart
                        }
                    }
                    
                    // Top Domains
                    chartCard(title: "Top Domains") {
                        if !viewModel.domainDistribution.isEmpty {
                            VStack(spacing: 6) {
                                ForEach(viewModel.domainDistribution, id: \.domain) { item in
                                    HStack(spacing: 8) {
                                        Text(item.domain)
                                            .font(TTFont.codeMedium)
                                            .foregroundColor(.ttTextPrimary)
                                            .lineLimit(1)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        // Bar
                                        let maxCount = viewModel.domainDistribution.first?.count ?? 1
                                        GeometryReader { geometry in
                                            RoundedRectangle(cornerRadius: 3)
                                                .fill(Color.ttPrimary.opacity(0.5))
                                                .frame(width: max(geometry.size.width * CGFloat(item.count) / CGFloat(maxCount), 4))
                                        }
                                        .frame(width: 80, height: 8)
                                        
                                        Text("\(item.count)")
                                            .font(TTFont.codeMedium)
                                            .foregroundColor(.ttTextSecondary)
                                            .frame(width: 30, alignment: .trailing)
                                    }
                                    .padding(.vertical, 3)
                                }
                            }
                        } else {
                            emptyChart
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                // Top Slowest Requests
                if !viewModel.topSlowestRequests.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("SLOWEST REQUESTS")
                            .font(TTFont.sidebarHeader)
                            .foregroundColor(.ttTextSecondary)
                            .tracking(0.8)
                        
                        VStack(spacing: 4) {
                            ForEach(viewModel.topSlowestRequests) { req in
                                HStack(spacing: 12) {
                                    // Rank
                                    let rank = (viewModel.topSlowestRequests.firstIndex(where: { $0.id == req.id }) ?? 0) + 1
                                    Text("#\(rank)")
                                        .font(TTFont.labelSmall)
                                        .foregroundColor(.ttTextTertiary)
                                        .frame(width: 24)
                                    
                                    // Method + URL
                                    HTTPMethodBadge(method: req.method)
                                    Text(req.urlPath)
                                        .font(TTFont.codeMedium)
                                        .foregroundColor(.ttTextPrimary)
                                        .lineLimit(1)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    // Device badge (if multi-device)
                                    if viewModel.deviceDistribution.count > 1 {
                                        DeviceBadge(
                                            deviceName: req.sourceDeviceName,
                                            deviceId: req.sourceDeviceId,
                                            compact: true
                                        )
                                    }
                                    
                                    // Duration bar
                                    GeometryReader { geometry in
                                        let maxMs = viewModel.topSlowestRequests.first?.durationMs ?? 1
                                        RoundedRectangle(cornerRadius: 3)
                                            .fill(Color.ttWarning.opacity(0.6))
                                            .frame(width: max(geometry.size.width * CGFloat(req.durationMs / maxMs), 4))
                                    }
                                    .frame(width: 80, height: 8)
                                    
                                    // Time
                                    Text(req.formattedTime)
                                        .font(TTFont.codeMedium)
                                        .foregroundColor(.ttWarning)
                                        .fontWeight(.medium)
                                        .frame(width: 60, alignment: .trailing)
                                }
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.ttSurface.opacity(0.3))
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
                
                Spacer(minLength: 20)
            }
        }
        .background(Color.ttBackground)
    }
    
    // MARK: - Components
    
    private func statCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.ttIcon(TTIcon.lg))
                    .foregroundColor(color)
                Text(title)
                    .font(TTFont.sidebarHeader)
                    .foregroundColor(.ttTextTertiary)
                    .tracking(0.5)
            }
            
            Text(value)
                .font(TTFont.heading1)
                .foregroundColor(.ttTextPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.ttSurface.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.ttBorder.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    private func chartCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(TTFont.sidebarHeader)
                .foregroundColor(.ttTextSecondary)
                .tracking(0.8)
            
            content()
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.ttSurface.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.ttBorder.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    private var emptyChart: some View {
        VStack(spacing: 8) {
            Image(systemName: "chart.bar.xaxis")
                .font(TTFont.heading1)
                .foregroundColor(.ttTextMuted)
            Text("No data yet")
                .font(TTFont.labelSmall)
                .foregroundColor(.ttTextTertiary)
        }
        .frame(maxWidth: .infinity, minHeight: 100)
    }
    
    // MARK: - Helpers
    
    private func colorForMethod(_ method: String) -> Color {
        switch method.uppercased() {
        case "GET": return .ttPrimary
        case "POST": return .ttSuccess
        case "PUT": return .ttWarning
        case "DELETE": return .ttError
        case "PATCH": return .purple
        default: return .ttTextTertiary
        }
    }
    
    private func colorForStatusGroup(_ group: String) -> Color {
        switch group {
        case "success": return .ttSuccess
        case "info": return .ttPrimary
        case "warning": return .ttWarning
        case "error": return .ttError
        default: return .ttTextTertiary
        }
    }
    
    private func formatBytes(_ bytes: Int) -> String {
        if bytes < 1024 { return "\(bytes) B" }
        if bytes < 1_048_576 { return String(format: "%.1f KB", Double(bytes) / 1024) }
        return String(format: "%.1f MB", Double(bytes) / 1_048_576)
    }
}

#Preview {
    NetworkStatsView(viewModel: NetworkViewModel())
        .frame(width: 900, height: 700)
        .preferredColorScheme(.dark)
}
