//
//  UsageGuideView.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-27.
//  macOS app feature guide, keyboard shortcuts, tips & export reference
//

import SwiftUI

struct UsageGuideView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 10) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.ttSuccess.opacity(0.12))
                                .frame(width: 40, height: 40)
                            Image(systemName: "book.fill")
                                .font(.ttIcon(TTIcon.xxl))
                                .foregroundColor(.ttSuccess)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("How to Use TTBDebugPlus")
                                .font(TTFont.displayMedium)
                                .foregroundColor(.ttTextPrimary)
                            Text("Learn what each feature does and how to get the most out of it")
                                .font(TTFont.bodyMedium)
                                .foregroundColor(.ttTextSecondary)
                        }
                    }
                }
                
                // Feature Guides
                Text("FEATURES")
                    .font(TTFont.sidebarHeader)
                    .foregroundColor(.ttTextTertiary)
                    .tracking(0.8)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    featureGuideCard(
                        icon: "terminal.fill",
                        title: "Console",
                        color: .ttSuccess,
                        features: [
                            "View real-time app logs streamed from iOS",
                            "Filter by level: All, Errors, Warnings, Debug",
                            "Search text with highlight matching",
                            "Click a log entry to see JSON payload details",
                            "Auto-scroll follows new entries in LIVE mode"
                        ]
                    )
                    
                    featureGuideCard(
                        icon: "network",
                        title: "Network",
                        color: .ttPrimary,
                        features: [
                            "Inspect all API requests with status codes",
                            "Filter by status: 2xx, 4xx, 5xx",
                            "View request/response headers & JSON body",
                            "Waterfall timing bars for performance",
                            "Export any request as cURL command"
                        ]
                    )
                    
                    featureGuideCard(
                        icon: "iphone",
                        title: "Device",
                        color: .ttWarning,
                        features: [
                            "Capture remote screenshots from iOS",
                            "Record mode: auto-capture every 2 seconds",
                            "Annotate with freehand, arrows, shapes, text",
                            "Toggle dark mode, reduced motion, accessibility",
                            "Send app lifecycle commands (launch, kill, reset)"
                        ]
                    )
                    
                    featureGuideCard(
                        icon: "chart.xyaxis.line",
                        title: "Performance",
                        color: .ttError,
                        features: [
                            "Real-time CPU & Memory usage charts",
                            "Network bandwidth (upload/download)",
                            "FPS counter and disk usage",
                            "API analytics: avg response time, error rate",
                            "Slow request & duplicate request detection"
                        ]
                    )
                    
                    featureGuideCard(
                        icon: "bubble.left.and.text.bubble.right.fill",
                        title: "Feedback",
                        color: .purple,
                        features: [
                            "Create bug reports with title & description",
                            "Auto-tag: UI/UX, Network, Crash, Performance",
                            "Attach screenshots (with or without annotations)",
                            "Export reports as Markdown files",
                            "Mark reports as resolved / reopened"
                        ]
                    )
                    
                    featureGuideCard(
                        icon: "square.and.arrow.up.fill",
                        title: "Export",
                        color: .cyan,
                        features: [
                            "HAR 1.2 — compatible with Chrome DevTools",
                            "cURL — replay requests in Terminal",
                            "Markdown — structured bug reports",
                            "JSON — copy raw payloads",
                            "NSSharingServicePicker — system share sheet"
                        ]
                    )
                }
                
                // Keyboard Shortcuts
                Text("KEYBOARD SHORTCUTS")
                    .font(TTFont.sidebarHeader)
                    .foregroundColor(.ttTextTertiary)
                    .tracking(0.8)
                
                CardView(title: "") {
                    VStack(spacing: 0) {
                        shortcutRow(keys: "⌘ K", action: "Clear console logs", isAlternate: false)
                        shortcutRow(keys: "⌘ F", action: "Focus search field", isAlternate: true)
                        shortcutRow(keys: "⇧ ⌘ C", action: "Capture screenshot from iOS device", isAlternate: false)
                        shortcutRow(keys: "⇧ ⌘ E", action: "Export current session", isAlternate: true)
                        shortcutRow(keys: "⌘ ,", action: "Open Settings", isAlternate: false)
                        shortcutRow(keys: "⌘ 1–5", action: "Switch between tabs", isAlternate: true)
                    }
                }
                
                // Pro Tips
                Text("PRO TIPS")
                    .font(TTFont.sidebarHeader)
                    .foregroundColor(.ttTextTertiary)
                    .tracking(0.8)
                
                VStack(spacing: 12) {
                    tipCard(
                        icon: "arrow.clockwise.circle.fill",
                        title: "Replay API Requests",
                        description: "Copy any request as cURL from the Network tab, paste into Terminal to replay. Edit headers or body as needed.",
                        color: .ttPrimary
                    )
                    
                    tipCard(
                        icon: "doc.badge.arrow.up.fill",
                        title: "HAR Export for Team Sharing",
                        description: "Export your session as HAR file → open in Chrome DevTools (Network → Import HAR) or Proxyman for team-level analysis.",
                        color: .ttSuccess
                    )
                    
                    tipCard(
                        icon: "pencil.tip.crop.circle.fill",
                        title: "Annotate Before Sharing",
                        description: "Capture a screenshot → tap Annotate → draw arrows, circles, or text to highlight bugs → Share with your team using the system share sheet.",
                        color: .ttWarning
                    )
                    
                    tipCard(
                        icon: "shield.checkered",
                        title: "Production Safety",
                        description: "Always wrap TTDebugBridge.shared.start() in #if DEBUG to ensure zero impact on production builds. The bridge is a complete no-op when not started.",
                        color: .ttError
                    )
                    
                    tipCard(
                        icon: "antenna.radiowaves.left.and.right",
                        title: "Multiple Devices",
                        description: "TTBDebugPlus supports multiple connected devices simultaneously. Use the sidebar to switch between devices and view their individual logs.",
                        color: .purple
                    )
                }
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 24)
        }
        .background(Color.ttBackground)
    }
    
    // MARK: - Feature Guide Card
    private func featureGuideCard(icon: String, title: String, color: Color, features: [String]) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(color.opacity(0.12))
                        .frame(width: 36, height: 36)
                    Image(systemName: icon)
                        .font(.ttIcon(TTIcon.xxl))
                        .foregroundColor(color)
                }
                Text(title)
                    .font(TTFont.heading3)
                    .foregroundColor(.ttTextPrimary)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(features, id: \.self) { feature in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "checkmark")
                            .font(.ttIcon(TTIcon.xs))
                            .foregroundColor(color)
                            .padding(.top, 3)
                        Text(feature)
                            .font(TTFont.bodySmall)
                            .foregroundColor(.ttTextSecondary)
                    }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.ttSurface.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.ttBorder.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Shortcut Row
    private func shortcutRow(keys: String, action: String, isAlternate: Bool) -> some View {
        HStack {
            // Key badges
            HStack(spacing: 4) {
                ForEach(keys.split(separator: " ").map(String.init), id: \.self) { key in
                    Text(key)
                        .font(TTFont.codeMedium)
                        .foregroundColor(.ttTextPrimary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.ttSurface)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.ttBorder, lineWidth: 1)
                                )
                        )
                }
            }
            .frame(width: 120, alignment: .leading)
            
            Text(action)
                .font(TTFont.bodyMedium)
                .foregroundColor(.ttTextSecondary)
            
            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(isAlternate ? Color.ttSurface.opacity(0.15) : Color.clear)
    }
    
    // MARK: - Tip Card
    private func tipCard(icon: String, title: String, description: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.12))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.ttIcon(TTIcon.xxl))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(TTFont.labelLarge)
                    .foregroundColor(.ttTextPrimary)
                Text(description)
                    .font(TTFont.bodySmall)
                    .foregroundColor(.ttTextTertiary)
                    .lineSpacing(2)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.ttSurface.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.ttBorder.opacity(0.15), lineWidth: 1)
                )
        )
    }
}

#Preview {
    UsageGuideView()
        .frame(width: 900, height: 900)
        .preferredColorScheme(.dark)
}
