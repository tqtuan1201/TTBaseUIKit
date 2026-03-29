//
//  NetworkRequestRow.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-29.
//  Row view for network request list + waterfall timing bar
//

import SwiftUI

// MARK: - Network Request Row
struct NetworkRequestRowView: View {
    let request: NetworkRequestEntry
    let maxDuration: Double
    var isSelected: Bool = false
    var isPinned: Bool = false
    var isHovered: Bool = false
    var isAlternate: Bool = false
    var showDeviceColumn: Bool = false
    
    var body: some View {
        HStack(spacing: 0) {
            // Pin indicator
            if isPinned {
                Image(systemName: "star.fill")
                    .font(.ttIcon(TTIcon.xxs))
                    .foregroundColor(.ttWarning)
                    .frame(width: 16)
            } else {
                Spacer().frame(width: 16)
            }
            
            // Status code
            StatusCodeBadge(code: request.statusCode)
                .frame(width: 55, alignment: .leading)
            
            // Method badge
            HTTPMethodBadge(method: request.method)
                .frame(width: 60, alignment: .leading)
            
            // URL path
            Text(request.urlPath)
                .font(TTFont.codeMedium)
                .foregroundColor(.ttTextPrimary)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .help(request.url) // Full URL tooltip
            
            // Device column (conditional)
            if showDeviceColumn {
                DeviceBadge(
                    deviceName: request.sourceDeviceName,
                    deviceId: request.sourceDeviceId,
                    compact: false
                )
                .frame(width: 100, alignment: .leading)
            }
            
            // Time
            Text(request.formattedTime)
                .font(TTFont.codeMedium)
                .foregroundColor(request.durationMs > 1000 ? .ttWarning : .ttTextSecondary)
                .frame(width: 65, alignment: .trailing)
            
            // Size
            Text(request.formattedSize)
                .font(TTFont.codeMedium)
                .foregroundColor(.ttTextSecondary)
                .frame(width: 70, alignment: .trailing)
            
            // Waterfall bar
            WaterfallBar(
                duration: request.durationMs,
                maxDuration: maxDuration,
                color: Color.forStatusCode(request.statusCode)
            )
            .frame(width: 100)
            .padding(.leading, 12)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 7)
        .background(rowBackground)
        .overlay(
            Rectangle().fill(Color.ttBorder.opacity(0.1)).frame(height: 1),
            alignment: .bottom
        )
        .contentShape(Rectangle())
    }
    
    private var rowBackground: Color {
        if isSelected { return Color.ttPrimary.opacity(0.12) }
        if isHovered { return Color.ttSurface.opacity(0.5) }
        if request.statusCode >= 400 { return Color.ttError.opacity(0.03) }
        if isAlternate { return Color.ttSurface.opacity(0.12) }
        return Color.clear
    }
}

// MARK: - Waterfall Bar
struct WaterfallBar: View {
    let duration: Double
    let maxDuration: Double
    let color: Color
    
    var widthFraction: CGFloat {
        CGFloat(min(duration / maxDuration, 1.0))
    }
    
    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 2)
                .fill(color.opacity(0.6))
                .frame(width: max(geometry.size.width * widthFraction, 4), height: 4)
                .frame(maxHeight: .infinity, alignment: .center)
        }
    }
}
