//
//  BaseSUILazyHStack.swift
//  TTBaseUIKit
//
//  Created by TTBaseUIKit on 9/3/26.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import SwiftUI

/// Wraps native `LazyHStack` with TTBaseUIKit config defaults.
///
/// Usage:
/// ```swift
/// TTBaseSUILazyHStack(alignment: .center, spacing: TTSize.P_CONS_DEF, bg: .white) {
///     ForEach(items) { item in
///         ItemView(item: item)
///     }
/// }
/// ```
public struct TTBaseSUILazyHStack<Content: View>: View {

    // MARK: - Stored Properties
    public var spacing: CGFloat                  = TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF
    public var viewDefBgColor: Color             = TTBaseUIKitConfig.getViewConfig().viewStackDefBgColor
    public var viewDefCornerRadius: CGFloat      = 0
    public var align: VerticalAlignment          = .center
    public var pinnedViews: PinnedScrollableViews = .init()

    public var content: () -> Content

    // MARK: - Init Overloads

    /// Init 1: Content only — all defaults
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    /// Init 2: alignment
    public init(
        alignment: VerticalAlignment = .center,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.align   = alignment
        self.content = content
    }

    /// Init 3: alignment + spacing
    public init(
        alignment: VerticalAlignment = .center,
        spacing: CGFloat,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.align   = alignment
        self.spacing = spacing
        self.content = content
    }

    /// Init 4: alignment + spacing + bg
    public init(
        alignment: VerticalAlignment = .center,
        spacing: CGFloat,
        bg: Color,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.align            = alignment
        self.spacing          = spacing
        self.viewDefBgColor   = bg
        self.content          = content
    }

    /// Init 5: alignment + spacing + bg + radius
    public init(
        alignment: VerticalAlignment = .center,
        spacing: CGFloat,
        bg: Color,
        radius: CGFloat,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.align                 = alignment
        self.spacing               = spacing
        self.viewDefBgColor        = bg
        self.viewDefCornerRadius   = radius
        self.content               = content
    }

    /// Init 6: full — alignment + spacing + bg + radius + pinnedViews
    public init(
        alignment: VerticalAlignment = .center,
        spacing: CGFloat,
        bg: Color,
        radius: CGFloat,
        pinnedViews: PinnedScrollableViews,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.align                 = alignment
        self.spacing               = spacing
        self.viewDefBgColor        = bg
        self.viewDefCornerRadius   = radius
        self.pinnedViews           = pinnedViews
        self.content               = content
    }

    // MARK: - Setup Base

    public func setupBase() -> LazyHStack<Content> {
        LazyHStack(
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
            TTBaseSUILazyHStack(alignment: .center, spacing: TTSize.P_CONS_DEF, bg: .clear) {
                ForEach(0..<10, id: \.self) { index in
                    TTBaseSUIView(withCornerRadius: TTSize.CORNER_RADIUS, bg: .white) {
                        TTBaseSUIText(withBold: .TITLE, text: "Item \(index)", align: .center, color: Color(TTView.textTitleColor))
                            .pAll(TTSize.P_CONS_DEF)
                    }
                    .sizeSquare(width: 80)
                }
            }
            .pAll(TTSize.P_CONS_DEF)
        }
    }
    .size(height: 120)
    .padding()
}
