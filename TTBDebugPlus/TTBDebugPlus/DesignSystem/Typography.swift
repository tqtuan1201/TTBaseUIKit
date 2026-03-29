//
//  Typography.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-27.
//

import SwiftUI

// MARK: - Typography System
enum TTFont {
    // Display
    static let displayLarge = Font.system(size: 32, weight: .bold, design: .default)
    static let displayMedium = Font.system(size: 28, weight: .bold, design: .default)
    
    // Headings
    static let heading1 = Font.system(size: 24, weight: .bold, design: .default)
    static let heading2 = Font.system(size: 20, weight: .semibold, design: .default)
    static let heading3 = Font.system(size: 17, weight: .semibold, design: .default)
    
    // Body
    static let bodyLarge = Font.system(size: 15, weight: .regular, design: .default)
    static let bodyMedium = Font.system(size: 13, weight: .regular, design: .default)
    static let bodySmall = Font.system(size: 11, weight: .regular, design: .default)
    
    // Labels
    static let labelLarge = Font.system(size: 13, weight: .semibold, design: .default)
    static let labelMedium = Font.system(size: 11, weight: .semibold, design: .default)
    static let labelSmall = Font.system(size: 10, weight: .medium, design: .default)
    
    // Code (Monospaced)
    static let codeLarge = Font.system(size: 14, weight: .regular, design: .monospaced)
    static let codeMedium = Font.system(size: 12, weight: .regular, design: .monospaced)
    static let codeSmall = Font.system(size: 11, weight: .regular, design: .monospaced)
    
    // Special
    static let tabLabel = Font.system(size: 13, weight: .medium, design: .default)
    static let sidebarItem = Font.system(size: 13, weight: .medium, design: .default)
    static let sidebarHeader = Font.system(size: 11, weight: .bold, design: .default)
    static let statusBar = Font.system(size: 11, weight: .regular, design: .monospaced)
    static let badge = Font.system(size: 10, weight: .bold, design: .monospaced)
    static let timestamp = Font.system(size: 12, weight: .regular, design: .monospaced)
}

// MARK: - Text Style Modifiers
struct TTTextStyle: ViewModifier {
    let font: Font
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(color)
    }
}

extension View {
    func ttHeading1() -> some View {
        modifier(TTTextStyle(font: TTFont.heading1, color: .ttTextPrimary))
    }
    
    func ttHeading2() -> some View {
        modifier(TTTextStyle(font: TTFont.heading2, color: .ttTextPrimary))
    }
    
    func ttHeading3() -> some View {
        modifier(TTTextStyle(font: TTFont.heading3, color: .ttTextPrimary))
    }
    
    func ttBody() -> some View {
        modifier(TTTextStyle(font: TTFont.bodyMedium, color: .ttTextPrimary))
    }
    
    func ttBodySecondary() -> some View {
        modifier(TTTextStyle(font: TTFont.bodyMedium, color: .ttTextSecondary))
    }
    
    func ttCode() -> some View {
        modifier(TTTextStyle(font: TTFont.codeMedium, color: .ttTextPrimary))
    }
    
    func ttLabel() -> some View {
        modifier(TTTextStyle(font: TTFont.labelMedium, color: .ttTextSecondary))
    }
    
    func ttLabelSmall() -> some View {
        modifier(TTTextStyle(font: TTFont.labelSmall, color: .ttTextSecondary))
    }
    
    func ttCodeSmall() -> some View {
        modifier(TTTextStyle(font: TTFont.codeSmall, color: .ttTextPrimary))
    }
    
    func ttTimestamp() -> some View {
        modifier(TTTextStyle(font: TTFont.timestamp, color: .ttTextSecondary))
    }
    
    func ttBadge() -> some View {
        modifier(TTTextStyle(font: TTFont.badge, color: .ttTextPrimary))
    }
    
    func ttStatusBar() -> some View {
        modifier(TTTextStyle(font: TTFont.statusBar, color: .ttTextSecondary))
    }
    
    func ttSidebarHeader() -> some View {
        modifier(TTTextStyle(font: TTFont.sidebarHeader, color: .ttTextSecondary))
    }
    
    func ttSidebarItem() -> some View {
        modifier(TTTextStyle(font: TTFont.sidebarItem, color: .ttTextSecondary))
    }
    
    func ttDisplayLarge() -> some View {
        modifier(TTTextStyle(font: TTFont.displayLarge, color: .ttTextPrimary))
    }
    
    func ttDisplayMedium() -> some View {
        modifier(TTTextStyle(font: TTFont.displayMedium, color: .ttTextPrimary))
    }
}
