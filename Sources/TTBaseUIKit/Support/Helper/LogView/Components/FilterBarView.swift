//
//  FilterBarView.swift
//  TTBaseUIKit
//
//  [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  FilterBarView.swift
//  TTBaseUIKit
//

import SwiftUI

public struct FilterBarView: View {

    @Binding public var selectedMethod: HTTPMethod
    @Binding public var selectedStatusCategory: HTTPStatusCategory
    @Binding public var searchText: String

    private let methods: [HTTPMethod] = [.unknown, .get, .post, .put, .patch, .delete, .head, .options]
    private let statusCategories: [HTTPStatusCategory] = [.all, .success, .redirect, .clientError, .serverError, .unknown]

    public init(
        selectedMethod: Binding<HTTPMethod>,
        selectedStatusCategory: Binding<HTTPStatusCategory>,
        searchText: Binding<String>
    ) {
        self._selectedMethod = selectedMethod
        self._selectedStatusCategory = selectedStatusCategory
        self._searchText = searchText
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Search bar
            searchBar

            // Filter chips
            filterChips

            statusChips
        }
        .background(LogViewTheme.background)
    }

    // MARK: - Search Bar
    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(LogViewTheme.secondaryText)
                .frame(width: 16, height: 16)

            TextField("Search URL, body, status...", text: $searchText)
                .font(.system(size: 14))
                .foregroundColor(LogViewTheme.primaryText)
                .autocapitalization(.none)
                .disableAutocorrection(true)

            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(LogViewTheme.secondaryText)
                        .frame(width: 16, height: 16)
                }
            }
        }
        .padding(.horizontal, CGFloat(TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF))
        .padding(.vertical, 10)
        .background(LogViewTheme.elevatedSurface)
        .cornerRadius(CGFloat(TTBaseUIKitConfig.getSizeConfig().CORNER_PANEL))
        .overlay(
            RoundedRectangle(cornerRadius: CGFloat(TTBaseUIKitConfig.getSizeConfig().CORNER_PANEL))
                .stroke(LogViewTheme.border, lineWidth: 1)
        )
        .padding(.horizontal, CGFloat(TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF))
        .padding(.vertical, 8)
    }

    // MARK: - Filter Chips
    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(methods, id: \.self) { method in
                    FilterChip(
                        title: method.displayName,
                        isSelected: selectedMethod == method,
                        color: method == .unknown ? nil : LogViewTheme.methodColor(for: method)
                    ) {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            selectedMethod = method
                        }
                    }
                }
            }
            .padding(.horizontal, CGFloat(TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF))
            .padding(.bottom, 8)
        }
    }

    private var statusChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(statusCategories, id: \.self) { category in
                    FilterChip(
                        title: category.displayName,
                        systemImageName: category.systemImageName,
                        isSelected: selectedStatusCategory == category,
                        color: LogViewTheme.statusColor(for: category)
                    ) {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            selectedStatusCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal, CGFloat(TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF))
            .padding(.bottom, 10)
        }
    }

}

// MARK: - Filter Chip
public struct FilterChip: View {

    public let title: String
    public let systemImageName: String?
    public let isSelected: Bool
    public let color: Color?
    public let action: () -> Void

    public init(
        title: String,
        systemImageName: String? = nil,
        isSelected: Bool,
        color: Color? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImageName = systemImageName
        self.isSelected = isSelected
        self.color = color
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                if let systemImageName = systemImageName {
                    Image(systemName: systemImageName)
                        .font(.system(size: 10, weight: .semibold))
                }
                Text(title)
                    .font(.system(size: 12, weight: isSelected ? .bold : .medium))
            }
            .foregroundColor(foregroundColor)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(backgroundColor)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(borderColor, lineWidth: isSelected ? 0 : 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var foregroundColor: Color {
        if isSelected {
            return LogViewTheme.background
        }
        if let color = color {
            return color
        }
        return LogViewTheme.secondaryText
    }

    private var backgroundColor: Color {
        if isSelected {
            return color ?? LogViewTheme.accent
        }
        return LogViewTheme.elevatedSurface
    }

    private var borderColor: Color {
        if isSelected {
            return Color.clear
        }
        return (color ?? LogViewTheme.border).opacity(0.55)
    }
}
