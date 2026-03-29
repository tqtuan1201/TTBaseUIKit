//
//  CardView.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-27.
//

import SwiftUI

// MARK: - Card Container
struct CardView<Content: View>: View {
    var title: String? = nil
    var titleTrailing: AnyView? = nil
    var padding: CGFloat = 16
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title = title {
                HStack {
                    Text(title)
                        .font(TTFont.sidebarHeader)
                        .foregroundColor(.ttTextSecondary)
                        .tracking(1.2)
                    
                    Spacer()
                    
                    if let trailing = titleTrailing {
                        trailing
                    }
                }
            }
            
            content()
        }
        .padding(padding)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.ttSurface.opacity(0.75))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.ttBorder.opacity(0.5), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.12), radius: 6, y: 3)
        )
    }
}

// MARK: - Status Badge
struct StatusBadge: View {
    let text: String
    var color: Color = .ttSuccess
    var style: BadgeStyle = .filled
    
    enum BadgeStyle {
        case filled, outlined, dot
    }
    
    var body: some View {
        switch style {
        case .filled:
            Text(text)
                .font(TTFont.badge)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(
                    Capsule().fill(color)
                )
            
        case .outlined:
            Text(text)
                .font(TTFont.badge)
                .foregroundColor(color)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(
                    Capsule()
                        .stroke(color, lineWidth: 1)
                )
            
        case .dot:
            HStack(spacing: 6) {
                Circle()
                    .fill(color)
                    .frame(width: 6, height: 6)
                Text(text)
                    .font(TTFont.labelSmall)
                    .foregroundColor(.ttTextSecondary)
            }
        }
    }
}

// MARK: - Method Badge
struct HTTPMethodBadge: View {
    let method: String
    
    var body: some View {
        Text(method.uppercased())
            .font(TTFont.badge)
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.forHTTPMethod(method))
            )
    }
}

// MARK: - Status Code Badge
struct StatusCodeBadge: View {
    let code: Int
    
    var body: some View {
        Text("\(code)")
            .font(TTFont.badge)
            .foregroundColor(Color.forStatusCode(code))
            .fontWeight(.bold)
    }
}

// MARK: - Log Level Badge
struct LogLevelBadge: View {
    let level: String
    
    var iconName: String {
        switch level.lowercased() {
        case "error": return "xmark.circle.fill"
        case "warning": return "exclamationmark.triangle.fill"
        case "info": return "info.circle.fill"
        case "debug": return "wrench.and.screwdriver.fill"
        default: return "circle.fill"
        }
    }
    
    var body: some View {
        Image(systemName: iconName)
            .font(.system(size: 12))
            .foregroundColor(Color.forLogLevel(level))
    }
}

// MARK: - Section Divider
struct SectionDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color.ttBorder.opacity(0.3))
            .frame(height: 1)
    }
}

// MARK: - Connection Status Indicator
struct ConnectionIndicator: View {
    var isConnected: Bool
    var label: String? = nil
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(isConnected ? Color.ttSuccess : Color.ttError)
                .frame(width: 8, height: 8)
                .overlay(
                    Circle()
                        .fill(isConnected ? Color.ttSuccess : Color.ttError)
                        .frame(width: 8, height: 8)
                        .blur(radius: isConnected ? 4 : 0)
                        .opacity(isConnected ? 0.5 : 0)
                )
            
            if let label = label {
                Text(label)
                    .font(TTFont.labelSmall)
                    .foregroundColor(.ttTextSecondary)
            }
        }
    }
}

// MARK: - Device Badge
/// Compact colored badge showing which device a request came from
struct DeviceBadge: View {
    let deviceName: String
    let deviceId: String
    var compact: Bool = false
    
    private var deviceColor: Color {
        Color.forDevice(deviceId)
    }
    
    private var shortName: String {
        // Shorten "iPhone 15 Pro Max" → "iPhone 15P"
        let parts = deviceName.split(separator: " ")
        if parts.count <= 2 { return deviceName }
        let first = parts[0]
        let rest = parts.dropFirst().map { String($0.prefix(1)) }.joined()
        return "\(first) \(rest)"
    }
    
    var body: some View {
        if compact {
            // Dot-only mode for narrow layouts
            Circle()
                .fill(deviceColor)
                .frame(width: 6, height: 6)
                .help(deviceName)
        } else {
            HStack(spacing: 4) {
                Circle()
                    .fill(deviceColor)
                    .frame(width: 6, height: 6)
                Text(shortName)
                    .font(TTFont.codeSmall)
                    .foregroundColor(deviceColor)
                    .lineLimit(1)
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(
                Capsule()
                    .fill(deviceColor.opacity(0.12))
            )
            .help(deviceName)
        }
    }
}
