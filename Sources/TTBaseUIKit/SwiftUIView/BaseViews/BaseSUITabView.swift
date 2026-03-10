//
//  BaseSUITabView.swift
//  TTBaseUIKit
//
//  Created by TTBaseUIKit on 9/3/26.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import SwiftUI

/// Wraps native `TabView` with TTBaseUIKit config defaults.
/// Supports two modes:
/// - `.PAGE`   — horizontal swipe pager (PageTabViewStyle) with optional dot indicators
/// - `.DEFAULT` — standard tab bar navigation
///
/// Usage:
/// ```swift
/// // Pager (swipe carousel)
/// TTBaseSUITabView(selection: $currentPage, type: .PAGE) {
///     ForEach(pages) { page in PageView(page: page).tag(page.id) }
/// }
///
/// // Pager with hidden dots
/// TTBaseSUITabView(selection: $idx, type: .PAGE_HIDDEN_DOTS) { ... }
///
/// // Standard tab bar
/// TTBaseSUITabView(type: .DEFAULT) {
///     HomeView().tabItem { Label("Home", systemImage: "house") }.tag(0)
///     SettingsView().tabItem { Label("Settings", systemImage: "gear") }.tag(1)
/// }
/// ```
public struct TTBaseSUITabView<SelectionValue: Hashable, Content: View>: View {

    // MARK: - Type

    public enum TYPE {
        case DEFAULT                    // standard tab bar
        case PAGE                       // horizontal pager with dot indicators
        case PAGE_HIDDEN_DOTS           // horizontal pager, dots hidden
    }

    // MARK: - Stored Properties

    public var type: TYPE                       = .PAGE
    public var selection: Binding<SelectionValue>?
    public var viewDefBgColor: Color            = TTBaseUIKitConfig.getViewConfig().viewStackDefBgColor
    public var viewDefCornerRadius: CGFloat     = 0
    public var indexDisplayMode: PageTabViewStyle.IndexDisplayMode = .automatic

    public let content: () -> Content

    // MARK: - Inits

    /// Init 1: content only (pager, auto selection)
    public init(@ViewBuilder content: @escaping () -> Content) where SelectionValue == Int {
        self.content   = content
        self.selection = nil
        self.type      = .PAGE
    }

    /// Init 2: selection binding + type
    public init(
        selection: Binding<SelectionValue>,
        type: TYPE = .PAGE,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.selection = selection
        self.type      = type
        self.content   = content
    }

    /// Init 3: selection + type + bg
    public init(
        selection: Binding<SelectionValue>,
        type: TYPE = .PAGE,
        bg: Color,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.selection        = selection
        self.type             = type
        self.viewDefBgColor   = bg
        self.content          = content
    }

    /// Init 4: full
    public init(
        selection: Binding<SelectionValue>? = nil,
        type: TYPE = .PAGE,
        bg: Color = TTBaseUIKitConfig.getViewConfig().viewStackDefBgColor,
        radius: CGFloat = 0,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.selection             = selection
        self.type                  = type
        self.viewDefBgColor        = bg
        self.viewDefCornerRadius   = radius
        self.content               = content
    }

    // MARK: - Body

    public var body: some View {
        switch self.type {
        case .PAGE:
            self.buildTabView()
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .background(self.viewDefBgColor)
                .cornerRadius(self.viewDefCornerRadius)

        case .PAGE_HIDDEN_DOTS:
            self.buildTabView()
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .background(self.viewDefBgColor)
                .cornerRadius(self.viewDefCornerRadius)

        case .DEFAULT:
            self.buildTabView()
                .background(self.viewDefBgColor)
                .cornerRadius(self.viewDefCornerRadius)
        }
    }

    // MARK: - Setup Base

    @ViewBuilder
    private func buildTabView() -> some View {
        if let sel = self.selection {
            TabView(selection: sel, content: self.content)
        } else {
            TabView(content: self.content)
        }
    }
}

// MARK: - Preview

#Preview {
    TTBaseSUIVStack(alignment: .leading, spacing: TTSize.P_CONS_DEF * 2, bg: Color.clear) {
        TTBaseSUIText(withBold: .SUB_TITLE, text: ".PAGE (swipe pager)", align: .leading, color: Color(TTView.textSubTitleColor))
            .pLeading(TTSize.P_CONS_DEF)

        TTBaseSUITabView(selection: .constant(0), type: .PAGE, bg: .clear) {
            ForEach(0..<3, id: \.self) { idx in
                TTBaseSUIView(withCornerRadius: TTSize.CORNER_PANEL, bg: [Color.red, Color.green, Color.blue][idx]) {
                    TTBaseSUIText(withBold: .HEADER, text: "Page \(idx + 1)", align: .center, color: .white)
                        .maxWidth()
                        .maxHeight()
                }
                .tag(idx)
            }
        }
        .frame(height: 160)
        .cornerRadius(TTSize.CORNER_PANEL)
        .pHorizontal(TTSize.P_CONS_DEF)

        TTBaseSUIText(withBold: .SUB_TITLE, text: ".PAGE_HIDDEN_DOTS", align: .leading, color: Color(TTView.textSubTitleColor))
            .pLeading(TTSize.P_CONS_DEF)

        TTBaseSUITabView(selection: .constant(1), type: .PAGE_HIDDEN_DOTS) {
            ForEach(0..<3, id: \.self) { idx in
                TTBaseSUIView(withCornerRadius: 0, bg: [Color.orange, Color.purple, Color.blue][idx]) {
                    TTBaseSUIText(withBold: .TITLE, text: "Slide \(idx + 1)", align: .center, color: .white)
                        .maxWidth().maxHeight()
                }
                .tag(idx)
            }
        }
        .frame(height: 120)
        .pHorizontal(TTSize.P_CONS_DEF)
    }
    .pAll(TTSize.P_CONS_DEF * 2)
    .bg(byDef: TTView.viewBgColor.toColor())
    .corner()
    .padding()
}
