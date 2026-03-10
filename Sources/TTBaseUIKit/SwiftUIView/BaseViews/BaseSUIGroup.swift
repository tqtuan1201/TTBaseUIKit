//
//  BaseSUIGroup.swift
//  TTBaseUIKit
//
//  Created by TTBaseUIKit on 9/3/26.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import SwiftUI

/// Wraps native `Group` and adds optional background + corner radius via TTBaseUIKit tokens.
///
/// `Group` itself is transparent — `TTBaseSUIGroup` lets you optionally apply a
/// background color and corner radius to the group as a whole, making it easy to
/// visually section content without nesting an extra container.
///
/// Usage:
/// ```swift
/// // Transparent group (same as Group — just semantic grouping)
/// TTBaseSUIGroup {
///     TTBaseSUIText(withType: .TITLE, text: "Line 1")
///     TTBaseSUIText(withType: .TITLE, text: "Line 2")
/// }
///
/// // Group with background card appearance
/// TTBaseSUIGroup(bg: .white, radius: TTSize.CORNER_PANEL) {
///     TTBaseSUIText(withBold: .TITLE, text: "Section Title")
///     TTBaseSUIHorizontalDividerView(noConner: .LINE)
///     TTBaseSUIText(withType: .SUB_TITLE, text: "Body text")
/// }
///
/// // Group with padding + shadow
/// TTBaseSUIGroup(bg: .white, radius: TTSize.CORNER_PANEL, padding: TTSize.P_CONS_DEF) {
///     RowContent()
/// }
/// .baseShadow()
/// ```
public struct TTBaseSUIGroup<Content: View>: View {

    // MARK: - Stored Properties

    public var viewDefBgColor: Color         = TTBaseUIKitConfig.getViewConfig().viewStackDefBgColor
    public var viewDefCornerRadius: CGFloat  = 0
    public var padding: CGFloat              = 0

    public let content: () -> Content

    // MARK: - Inits

    /// Init 1: transparent group (no bg, no corner) — pure semantic grouping
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    /// Init 2: bg + content
    public init(
        bg: Color,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.viewDefBgColor = bg
        self.content        = content
    }

    /// Init 3: bg + radius + content
    public init(
        bg: Color,
        radius: CGFloat,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.viewDefBgColor       = bg
        self.viewDefCornerRadius  = radius
        self.content              = content
    }

    /// Init 4: bg + radius + padding + content
    public init(
        bg: Color,
        radius: CGFloat,
        padding: CGFloat,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.viewDefBgColor       = bg
        self.viewDefCornerRadius  = radius
        self.padding              = padding
        self.content              = content
    }

    // MARK: - Body

    public var body: some View {
        Group(content: self.content)
            .padding(self.padding)
            .background(self.viewDefBgColor)
            .cornerRadius(self.viewDefCornerRadius)
    }
}

// MARK: - Helper Extension

public extension TTBaseSUIGroup {

    /// Apply a corner radius helper (mirrors TTBaseSUIHStack.setCorner pattern)
    func setCorner(radius: CGFloat = TTSize.CORNER_RADIUS) -> some View {
        self.body.cornerRadius(radius)
    }
}

// MARK: - Preview

#Preview {
    TTBaseSUIVStack(alignment: .leading, spacing: TTSize.P_CONS_DEF * 1.5, bg: Color.clear) {
        TTBaseSUIText(withBold: .SUB_TITLE, text: "Transparent group (no bg)", align: .leading, color: Color(TTView.textSubTitleColor))

        TTBaseSUIGroup {
            TTBaseSUIText(withType: .TITLE, text: "Row A", align: .leading, color: Color(TTView.textDefColor))
            TTBaseSUIText(withType: .TITLE, text: "Row B", align: .leading, color: Color(TTView.textDefColor))
        }
        .maxWidth(alignment: .leading)
        .background(Color.yellow.opacity(0.15))   // only for demo contrast

        TTBaseSUIText(withBold: .SUB_TITLE, text: "Group with bg + radius", align: .leading, color: Color(TTView.textSubTitleColor))

        TTBaseSUIGroup(bg: .white, radius: TTSize.CORNER_PANEL, padding: TTSize.P_CONS_DEF) {
            TTBaseSUIVStack(alignment: .leading, spacing: TTSize.P_CONS_DEF / 2) {
                TTBaseSUIText(withBold: .TITLE, text: "Section Title", align: .leading, color: Color(TTView.textTitleColor))
                TTBaseSUIHorizontalDividerView(noConner: .LINE)
                TTBaseSUIText(withType: .SUB_TITLE, text: "Section body content goes here.", align: .leading, color: Color(TTView.textSubTitleColor))
            }
        }
        .baseShadow()
        .maxWidth(alignment: .leading)

        TTBaseSUIText(withBold: .SUB_TITLE, text: "Group with border", align: .leading, color: Color(TTView.textSubTitleColor))

        TTBaseSUIGroup(bg: .white, radius: TTSize.CORNER_RADIUS, padding: TTSize.P_CONS_DEF) {
            TTBaseSUIText(withType: .TITLE, text: "Bordered group content", align: .leading, color: Color(TTView.textDefColor))
        }
        .baseBorder(radius: TTSize.CORNER_RADIUS)
        .maxWidth(alignment: .leading)
    }
    .pAll(TTSize.P_CONS_DEF * 2)
    .bg(byDef: TTView.viewBgColor.toColor())
    .corner()
    .padding()
}
