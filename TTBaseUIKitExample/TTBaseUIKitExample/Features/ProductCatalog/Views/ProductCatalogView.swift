//
//  ProductCatalogView.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
import TTBaseUIKit

// MARK: - ProductCatalogView
/// Main product catalog with search, category filters, sort, and grid of products.
/// Refactored to maximize TTBaseUIKit SwiftUI base components.
struct ProductCatalogView: View {
    
    @StateObject private var viewModel = ProductCatalogViewModel()
    
    @State private var showSortSheet = false
    
    // MARK: - Grid Layout
    private let columns = [
        GridItem(.flexible(), spacing: TTSize.P_CONS_DEF),
        GridItem(.flexible(), spacing: TTSize.P_CONS_DEF)
    ]
    
    // MARK: - Design Tokens
    private enum Design {
        static let accentColor = Color(red: 0.2, green: 0.5, blue: 0.95)
        static let bgColor = Color(UIColor.systemGroupedBackground)
        static let cardBg = Color(TTView.viewBgCellColor)
    }
    
    var body: some View {
        ZStack {
            Design.bgColor.ignoresSafeArea()
            
            TTBaseSUIVStack(alignment: .leading, spacing: 0, bg: .clear) {
                // Search & Filter Bar
                searchAndFilterBar
                
                // Category Chips
                categoryChipsSection
                
                // Content
                if viewModel.isLoading && viewModel.products.isEmpty {
                    loadingState
                } else if let error = viewModel.errorMessage, viewModel.products.isEmpty {
                    errorState(message: error)
                } else if viewModel.isEmptyState {
                    emptyState
                } else {
                    productGrid
                }
            }
        }
        .navigationBarTitle("Product Catalog", displayMode: .inline)
        .onAppear {
            UITabBar.hideTabBar(animated: true)
            if viewModel.products.isEmpty {
                Task { await viewModel.loadProducts() }
            }
        }
    }
    
    // MARK: - Search & Filter Bar
    private var searchAndFilterBar: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: 0, bg: Design.cardBg) {
            TTBaseSUIHStack(alignment: .center, spacing: TTSize.P_CONS_DEF) {
                // Search Field
                TTBaseSUIHStack(alignment: .center, spacing: TTSize.P_CONS_DEF / 2) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color(UIColor.systemGray))
                    
                    TextField("Search products...", text: $viewModel.searchText)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color(TTView.textDefColor))
                    
                    if !viewModel.searchText.isEmpty {
                        Button(action: { viewModel.searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 14))
                                .foregroundColor(Color(UIColor.systemGray3))
                        }
                    }
                }
                .pHorizontal(TTSize.P_CONS_DEF)
                .pVertical(TTSize.P_CONS_DEF * 0.8)
                .bg(byDef: Color(UIColor.systemGray6))
                .corner(byDef: TTSize.CORNER_RADIUS)
                
                // Sort Button
                Button(action: { showSortSheet = true }) {
                    Image(systemName: viewModel.sortOption.icon)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Design.accentColor)
                        .sizeSquare(width: 40)
                        .bg(byDef: Design.accentColor.opacity(0.1))
                        .corner(byDef: TTSize.CORNER_RADIUS)
                }
                .actionSheet(isPresented: $showSortSheet) {
                    ActionSheet(
                        title: Text("Sort Products"),
                        buttons: ProductCatalogViewModel.SortOption.allCases.map { option in
                            .default(Text(option.rawValue + (viewModel.sortOption == option ? " ✓" : ""))) {
                                viewModel.sortOption = option
                            }
                        } + [.cancel()]
                    )
                }
            }
            .pAll(TTSize.P_CONS_DEF)
            
            // Product Count + Sort info
            TTBaseSUIHStack(alignment: .center, spacing: TTSize.P_CONS_DEF / 2) {
                TTBaseSUIText(
                    withBold: .SUB_SUB_TILE,
                    text: "\(viewModel.productCount) products",
                    align: .leading,
                    color: Color(TTView.textSubTitleColor)
                )
                
                Spacer()
                
                TTBaseSUIHStack(alignment: .center, spacing: 4, bg: .clear) {
                    Image(systemName: viewModel.sortOption.icon)
                        .font(.system(size: 10, weight: .medium))
                    TTBaseSUIText(
                        withType: .SUB_SUB_TILE,
                        text: viewModel.sortOption.rawValue,
                        align: .trailing,
                        color: Design.accentColor
                    )
                }
                .foregroundColor(Design.accentColor)
            }
            .pHorizontal(TTSize.P_CONS_DEF)
            .pVertical(TTSize.P_CONS_DEF / 2)
            
            TTBaseSUIHorizontalDividerView(noConner: .LINE)
        }
    }
    
    // MARK: - Category Chips
    private var categoryChipsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            TTBaseSUIHStack(alignment: .center, spacing: TTSize.P_CONS_DEF / 2) {
                ForEach(ProductCategory.allCases) { category in
                    categoryChip(category: category)
                }
            }
            .pHorizontal(TTSize.P_CONS_DEF)
            .pVertical(TTSize.P_CONS_DEF * 0.8)
        }
        .bg(byDef: Design.cardBg.opacity(0.95))
    }
    
    private func categoryChip(category: ProductCategory) -> some View {
        let isSelected = viewModel.selectedCategory == category
        let count = viewModel.categoryCounts[category] ?? 0
        
        return Button(action: {
            withAnimation(.spring(response: 0.3)) {
                viewModel.selectedCategory = category
            }
        }) {
            TTBaseSUIHStack(alignment: .center, spacing: 5, bg: .clear) {
                Image(systemName: category.icon)
                    .font(.system(size: 11, weight: .semibold))
                
                TTBaseSUIText(
                    withBold: .SUB_SUB_TILE,
                    text: category.displayName,
                    align: .center,
                    color: isSelected ? .white : Color(UIColor.secondaryLabel)
                )
                
                if count > 0 && category != .all {
                    TTBaseSUIText(
                        withBold: .SUB_SUB_TILE,
                        text: "\(count)",
                        align: .center,
                        color: isSelected ? Design.accentColor : .white
                    )
                    .pHorizontal(5)
                    .pVertical(1)
                    .bg(byDef: isSelected ? .white : .white.opacity(0.3))
                    .corner(byDef: 8)
                }
            }
            .foregroundColor(isSelected ? .white : Color(UIColor.secondaryLabel))
            .pHorizontal(TTSize.P_CONS_DEF)
            .pVertical(TTSize.P_CONS_DEF / 2)
            .background(
                isSelected ?
                LinearGradient(
                    colors: [Design.accentColor, Design.accentColor.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                ) :
                LinearGradient(
                    colors: [Color(UIColor.systemGray6), Color(UIColor.systemGray6)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .corner(byDef: 20)
            .baseShadow(corner: 20, color: isSelected ? Design.accentColor.opacity(0.3) : .clear, radius: isSelected ? 6 : 0, y: isSelected ? 3 : 0)
        }
    }
    
    // MARK: - Product Grid
    @ViewBuilder
    private var productGrid: some View {
        if #available(iOS 15.0, *) {
            scrollContent
                .refreshable { await viewModel.refresh() }
        } else {
            scrollContent
        }
    }
    
    @ViewBuilder
    private var scrollContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            TTBaseSUILazyVGrid(
                columns: columns,
                spacing: TTSize.P_CONS_DEF
            ) {
                ForEach(viewModel.filteredProducts) { product in
                    NavigationLink(destination: ProductDetailView(product: product)) {
                        ProductCardView(product: product) { }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .onAppear {
                        Task { await viewModel.loadMoreIfNeeded(currentItem: product) }
                    }
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.9).combined(with: .opacity),
                        removal: .opacity
                    ))
                }
            }
            .pHorizontal(TTSize.P_CONS_DEF)
            .pTop(TTSize.P_CONS_DEF / 2)
            .pBottom(TTSize.P_CONS_DEF * 2)
            
            // Loading More Indicator
            if viewModel.isLoadingMore {
                TTBaseSUIHStack(alignment: .center, spacing: TTSize.P_CONS_DEF) {
                    ProgressView()
                        .scaleEffect(0.8)
                    TTBaseSUIText(
                        withType: .SUB_SUB_TILE,
                        text: "Loading more...",
                        align: .center,
                        color: Color(TTView.textSubTitleColor)
                    )
                }
                .pVertical(TTSize.P_CONS_DEF)
            }
        }
    }
    
    // MARK: - Loading State
    private var loadingState: some View {
        ScrollView {
            TTBaseSUIVStack(alignment: .leading, spacing: TTSize.P_CONS_DEF) {
                // Skeleton header
                TTBaseSUIHStack(alignment: .center, spacing: TTSize.P_CONS_DEF / 2) {
                    ForEach(0..<4, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(UIColor.systemGray5))
                            .size(width: 80, height: 34)
                    }
                }
                .skeleton(active: true, isShimmering: true, isLight: true)
                .pHorizontal(TTSize.P_CONS_DEF)
                
                ProductSkeletonGridView()
            }
            .pTop(TTSize.P_CONS_DEF)
        }
    }
    
    // MARK: - Empty State
    private var emptyState: some View {
        TTBaseSUIVStack(alignment: .center, spacing: TTSize.P_CONS_DEF) {
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48, weight: .light))
                .foregroundColor(Color(UIColor.systemGray3))
            
            TTBaseSUIText(withBold: .TITLE, text: "No Products Found", align: .center)
            
            TTBaseSUIText(
                withType: .SUB_TITLE,
                text: "Try adjusting your search or filter to find what you're looking for.",
                align: .center,
                color: Color(TTView.textSubTitleColor)
            )
            
            TTBaseSUIButton(title: "Clear Filters") {
                viewModel.searchText = ""
                viewModel.selectedCategory = .all
            }
            .pHorizontal(TTSize.P_CONS_DEF * 2)
            
            Spacer()
        }
        .maxWidth()
    }
    
    // MARK: - Error State
    private func errorState(message: String) -> some View {
        TTBaseSUIVStack(alignment: .center, spacing: TTSize.P_CONS_DEF) {
            Spacer()
            
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 48, weight: .light))
                .foregroundColor(Color(UIColor.systemGray3))
            
            TTBaseSUIText(withBold: .TITLE, text: "Connection Error", align: .center)
            
            TTBaseSUIText(
                withType: .SUB_TITLE,
                text: message,
                align: .center,
                color: Color(TTView.textSubTitleColor)
            )
            
            TTBaseSUIButton(title: "Try Again") {
                Task { await viewModel.loadProducts() }
            }
            .pHorizontal(TTSize.P_CONS_DEF * 2)
            
            Spacer()
        }
        .maxWidth()
    }
    
}

// MARK: - Preview
#Preview {
    ProductCatalogView()
}
