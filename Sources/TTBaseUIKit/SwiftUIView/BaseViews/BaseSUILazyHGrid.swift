//
//  BaseSUILazyHGrid.swift
//  TTBaseUIKit
//
//  Created by TTBaseUIKit on 9/3/26.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import SwiftUI

/// Wraps native `LazyHGrid` with TTBaseUIKit config defaults.
///
/// Usage:
/// ```swift
/// TTBaseSUIScroll(alignment: .horizontal) {
///     TTBaseSUILazyHGrid(rows: [GridItem(.fixed(80)), GridItem(.fixed(80))], spacing: TTSize.P_CONS_DEF) {
///         ForEach(items) { item in ItemView(item: item) }
///     }
/// }
/// ```
public struct TTBaseSUILazyHGrid<Content: View>: View {

    // MARK: - Stored Properties
    public var rows: [GridItem]
    public var spacing: CGFloat                  = TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF
    public var viewDefBgColor: Color             = TTBaseUIKitConfig.getViewConfig().viewStackDefBgColor
    public var viewDefCornerRadius: CGFloat      = 0
    public var align: VerticalAlignment          = .center
    public var pinnedViews: PinnedScrollableViews = .init()

    public let content: () -> Content

    // MARK: - Init Overloads

    /// Init 1: rows + content only
    public init(
        rows: [GridItem],
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.rows    = rows
        self.content = content
    }

    /// Init 2: rows + spacing
    public init(
        rows: [GridItem],
        spacing: CGFloat,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.rows    = rows
        self.spacing = spacing
        self.content = content
    }

    /// Init 3: rows + spacing + bg
    public init(
        rows: [GridItem],
        spacing: CGFloat,
        bg: Color,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.rows             = rows
        self.spacing          = spacing
        self.viewDefBgColor   = bg
        self.content          = content
    }

    /// Init 4: rows + spacing + bg + radius
    public init(
        rows: [GridItem],
        spacing: CGFloat,
        bg: Color,
        radius: CGFloat,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.rows                  = rows
        self.spacing               = spacing
        self.viewDefBgColor        = bg
        self.viewDefCornerRadius   = radius
        self.content               = content
    }

    /// Init 5: full — rows + alignment + spacing + bg + radius + pinnedViews
    public init(
        rows: [GridItem],
        alignment: VerticalAlignment = .center,
        spacing: CGFloat,
        bg: Color,
        radius: CGFloat,
        pinnedViews: PinnedScrollableViews,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.rows                  = rows
        self.align                 = alignment
        self.spacing               = spacing
        self.viewDefBgColor        = bg
        self.viewDefCornerRadius   = radius
        self.pinnedViews           = pinnedViews
        self.content               = content
    }

    // MARK: - Setup Base

    public func setupBase() -> LazyHGrid<Content> {
        LazyHGrid(
            rows: self.rows,
            alignment: self.align,
            spacing: self.spacing,
            pinnedViews: self.pinnedViews,
            content: self.content
        )
    }

    // MARK: - Body

    public var body: some View {
        self.setupBase()
            .background(self.viewDefBgColor)
            .cornerRadius(self.viewDefCornerRadius)
    }
}

// MARK: - Preview

#Preview {
    TTBaseSUIView(bg: Color(TTView.viewBgColor)) {
        TTBaseSUIScroll(alignment: .horizontal) {
            TTBaseSUILazyHGrid(
                rows: [GridItem(.fixed(60)), GridItem(.fixed(60))],
                spacing: TTSize.P_CONS_DEF,
                bg: .clear,
                radius: 0
            ) {
                ForEach(0..<12, id: \.self) { index in
                    TTBaseSUIView(withCornerRadius: TTSize.CORNER_RADIUS, bg: .white) {
                        TTBaseSUIText(withType: .SUB_TITLE, text: "[\(index)]", align: .center, color: Color(TTView.textTitleColor))
                            .pAll(TTSize.P_CONS_DEF)
                    }
                    .sizeSquare(width: 60)
                }
            }
            .pAll(TTSize.P_CONS_DEF)
        }
    }
    .size(height: 160)
    .padding()
}
