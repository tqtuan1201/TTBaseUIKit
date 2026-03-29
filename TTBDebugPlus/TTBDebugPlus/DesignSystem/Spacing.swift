//
//  Spacing.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-29.
//  Design system spacing tokens based on 4px/8px grid
//

import SwiftUI

// MARK: - Spacing Tokens
enum TTSpacing {
    // Base scale (4px grid)
    static let xxxs: CGFloat = 2
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 6
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 24
    static let xxxl: CGFloat = 32
    static let xxxxl: CGFloat = 40
    
    // Semantic aliases — Rows
    static let rowVertical: CGFloat = 7
    static let rowHorizontal: CGFloat = 16
    
    // Semantic aliases — Sections
    static let sectionPadding: CGFloat = 16
    static let cardPadding: CGFloat = 16
    
    // Semantic aliases — Toolbar / Filter
    static let toolbarVertical: CGFloat = 8
    static let toolbarHorizontal: CGFloat = 12
    static let filterBarGap: CGFloat = 6
    
    // Semantic aliases — Inline elements
    static let inlineGapTiny: CGFloat = 2
    static let inlineGapSmall: CGFloat = 3
    static let inlineGapMedium: CGFloat = 4
    static let inlineGapLarge: CGFloat = 6
    static let inlineGapXL: CGFloat = 8
    
    // Semantic aliases — Buttons
    static let buttonPaddingH: CGFloat = 20
    static let buttonPaddingV: CGFloat = 10
    static let buttonCompactH: CGFloat = 12
    static let buttonCompactV: CGFloat = 6
    
    // Semantic aliases — Input fields
    static let inputPaddingH: CGFloat = 10
    static let inputPaddingV: CGFloat = 5
    
    // Semantic aliases — Badges
    static let badgePaddingH: CGFloat = 8
    static let badgePaddingV: CGFloat = 3
}

// MARK: - Spacing View Modifier
struct TTContentPadding: ViewModifier {
    let horizontal: CGFloat
    let vertical: CGFloat
    
    func body(content: Content) -> some View {
        content.padding(.horizontal, horizontal).padding(.vertical, vertical)
    }
}

extension View {
    func ttPadding(_ spacing: CGFloat) -> some View {
        padding(spacing)
    }
    
    func ttPadding(h: CGFloat, v: CGFloat) -> some View {
        modifier(TTContentPadding(horizontal: h, vertical: v))
    }
    
    func ttRowPadding() -> some View {
        modifier(TTContentPadding(horizontal: TTSpacing.rowHorizontal, vertical: TTSpacing.rowVertical))
    }
    
    func ttSectionPadding() -> some View {
        padding(TTSpacing.sectionPadding)
    }
    
    func ttToolbarPadding() -> some View {
        modifier(TTContentPadding(horizontal: TTSpacing.toolbarHorizontal, vertical: TTSpacing.toolbarVertical))
    }
}
