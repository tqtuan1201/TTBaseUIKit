//
//  BaseSUIList.swift
//  TTBaseUIKit
//
//  Created by TTBaseUIKit on 9/3/26.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import SwiftUI

/// Wraps native `List` with TTBaseUIKit config defaults.
/// Strips the default system list background/separator styles and applies
/// TTBaseUIKit color tokens so the list matches the app's design system.
///
/// Supports three style types:
/// - `.PLAIN`       — UITableView-style plain list, no section grouping visual
/// - `.GROUPED`     — Inset grouped card appearance (iOS 13+)
/// - `.INSET`       — Inset plain (compact grouped rows)
///
/// Usage:
/// ```swift
/// // Plain list from data
/// TTBaseSUIList(type: .PLAIN) {
///     ForEach(items) { item in RowView(item: item) }
/// }
///
/// // With pull-to-refresh
/// TTBaseSUIList(type: .PLAIN, isEnablePullToRefresh: true) {
///     ForEach(items) { item in RowView(item: item) }
/// } pullToRefresh: {
///     viewModel.reload()
/// }
/// ```
public struct TTBaseSUIList<Content: View>: View {

    // MARK: - Type

    public enum TYPE {
        case PLAIN
        case GROUPED
        case INSET
    }

    // MARK: - Stored Properties

    public var type: TYPE                        = .PLAIN
    public var viewDefBgColor: Color             = TTBaseUIKitConfig.getViewConfig().viewStackDefBgColor
    public var rowBgColor: Color                 = Color(TTBaseUIKitConfig.getViewConfig().viewBgCellColor)
    public var separatorColor: Color             = Color(TTBaseUIKitConfig.getViewConfig().lineDefColor)
    public var showSeparator: Bool               = true
    public var isEnablePullToRefresh: Bool       = false

    public var content: () -> Content
    public var pullToRefresh: (() -> Void)?

    // MARK: - Inits

    /// Init 1: content only
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    /// Init 2: type + content
    public init(
        type: TYPE,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.type    = type
        self.content = content
    }

    /// Init 3: type + pull-to-refresh
    public init(
        type: TYPE = .PLAIN,
        isEnablePullToRefresh: Bool,
        @ViewBuilder content: @escaping () -> Content,
        pullToRefresh: (() -> Void)? = nil
    ) {
        self.type                    = type
        self.isEnablePullToRefresh   = isEnablePullToRefresh
        self.content                 = content
        self.pullToRefresh           = pullToRefresh
    }

    /// Init 4: full
    public init(
        type: TYPE = .PLAIN,
        bg: Color = TTBaseUIKitConfig.getViewConfig().viewStackDefBgColor,
        rowBgColor: Color = Color(TTBaseUIKitConfig.getViewConfig().viewBgCellColor),
        showSeparator: Bool = true,
        isEnablePullToRefresh: Bool = false,
        @ViewBuilder content: @escaping () -> Content,
        pullToRefresh: (() -> Void)? = nil
    ) {
        self.type                    = type
        self.viewDefBgColor          = bg
        self.rowBgColor              = rowBgColor
        self.showSeparator           = showSeparator
        self.isEnablePullToRefresh   = isEnablePullToRefresh
        self.content                 = content
        self.pullToRefresh           = pullToRefresh
    }

    // MARK: - Body

    public var body: some View {
        if #available(iOS 16.0, *) {
            self.buildList()
                .scrollContentBackground(.hidden)
                .background(self.viewDefBgColor)
                .listRowBackground(self.rowBgColor)
        } else {
            self.buildList()
                .background(self.viewDefBgColor)
                .onAppear { UITableView.appearance().backgroundColor = .clear }
        }
    }

    // MARK: - Build List

    @ViewBuilder
    private func buildList() -> some View {
        
        let base = self.applyStyle(List(content: self.content))
        if #available(iOS 15.0, *) {
            base.listRowSeparatorTint(self.showSeparator ? self.separatorColor : Color.clear)
        }
        if #available(iOS 15.0, *) {
            if self.isEnablePullToRefresh {
                base.refreshable {
                    TTBaseFunc.shared.printLog(object: "TTBaseSUIList - refreshable")
                    self.pullToRefresh?()
                }
            } else {
                base
            }
        } else {
            base
        }
    }

    @ViewBuilder
    private func applyStyle(_ list: List<Never, Content>) -> some View {
        switch self.type {
        case .GROUPED:
            list.listStyle(InsetGroupedListStyle())
        case .INSET:
            list.listStyle(InsetListStyle())
        default: // .PLAIN
            list.listStyle(PlainListStyle())
        }
    }
}

// MARK: - Convenience: TTBaseSUIListRow — strips default row insets/bg

/// Apply to each row inside `TTBaseSUIList` to remove default row padding.
public extension View {
    func listRowStyle(
        bg: Color = Color(TTBaseUIKitConfig.getViewConfig().viewBgCellColor),
        horizontalInset: CGFloat = 0
    ) -> some View {
        self
            .listRowBackground(bg)
            .listRowInsets(EdgeInsets(
                top: 0,
                leading: horizontalInset,
                bottom: 0,
                trailing: horizontalInset
            ))
    }
}

// MARK: - Preview

private struct SampleItem: Identifiable {
    let id: Int
    let title: String
    let sub: String
}

#Preview {
    let items = (0..<8).map { SampleItem(id: $0, title: "Item \($0 + 1)", sub: "Sub text for item \($0 + 1)") }

    TTBaseSUIVStack(alignment: .leading, spacing: 0, bg: Color(TTView.viewBgColor)) {
        TTBaseSUIText(withBold: .SUB_TITLE, text: ".PLAIN list", align: .leading, color: Color(TTView.textSubTitleColor))
            .pAll(TTSize.P_CONS_DEF)

        TTBaseSUIList(type: .PLAIN, bg: Color(TTView.viewBgColor)) {
            ForEach(items) { item in
                TTBaseSUIHStack(alignment: .center, spacing: TTSize.P_CONS_DEF) {
                    TTBaseSUIVStack(alignment: .leading, spacing: TTSize.P_CONS_DEF / 4) {
                        TTBaseSUIText(withBold: .TITLE, text: item.title, align: .leading, color: Color(TTView.textTitleColor))
                        TTBaseSUIText(withType: .SUB_TITLE, text: item.sub, align: .leading, color: Color(TTView.textSubTitleColor))
                    }
                    .maxWidth(alignment: .leading)
                }
                .pAll(TTSize.P_CONS_DEF)
                .listRowStyle()
            }
        }
    }
    .padding()
}
