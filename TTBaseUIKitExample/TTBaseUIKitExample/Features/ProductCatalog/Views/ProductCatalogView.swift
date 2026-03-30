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
struct ProductCatalogView: View {
    
    @StateObject private var viewModel = ProductCatalogViewModel()
    @EnvironmentObject var hostingProvider: ViewControllerProvider
    
    @State private var showSortSheet = false
    @State private var isSearchActive = false
    
    // MARK: - Grid Layout
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    // MARK: - Design
    private enum Design {
        static let accentColor = Color(red: 0.2, green: 0.5, blue: 0.95)
        static let bgColor = Color(UIColor.systemGroupedBackground)
    }
    
    var body: some View {
        SUIBaseViewDemo(
            backType: .POP,
            title: "Product Catalog"
        ) {
            ZStack {
                Design.bgColor.ignoresSafeArea()
                
                VStack(spacing: 0) {
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
        }
        .onAppear {
            if viewModel.products.isEmpty {
                Task { await viewModel.loadProducts() }
            }
        }
    }
    
    // MARK: - Search & Filter Bar
    private var searchAndFilterBar: some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {
                // Search Field
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color(UIColor.systemGray))
                    
                    TextField("Search products...", text: $viewModel.searchText)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color(UIColor.label))
                    
                    if !viewModel.searchText.isEmpty {
                        Button(action: { viewModel.searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 14))
                                .foregroundColor(Color(UIColor.systemGray3))
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(12)
                
                // Sort Button
                Button(action: { showSortSheet = true }) {
                    Image(systemName: viewModel.sortOption.icon)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Design.accentColor)
                        .frame(width: 40, height: 40)
                        .background(Design.accentColor.opacity(0.1))
                        .cornerRadius(10)
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
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.white)
            
            // Product Count + Sort info
            HStack {
                Text("\(viewModel.productCount) products")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color(UIColor.secondaryLabel))
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: viewModel.sortOption.icon)
                        .font(.system(size: 10, weight: .medium))
                    Text(viewModel.sortOption.rawValue)
                        .font(.system(size: 11, weight: .medium))
                }
                .foregroundColor(Design.accentColor)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
            .background(Color.white)
            
            Divider()
        }
    }
    
    // MARK: - Category Chips
    private var categoryChipsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(ProductCategory.allCases) { category in
                    categoryChip(category: category)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .background(Color.white.opacity(0.95))
    }
    
    private func categoryChip(category: ProductCategory) -> some View {
        let isSelected = viewModel.selectedCategory == category
        let count = viewModel.categoryCounts[category] ?? 0
        
        return Button(action: {
            withAnimation(.spring(response: 0.3)) {
                viewModel.selectedCategory = category
            }
        }) {
            HStack(spacing: 5) {
                Image(systemName: category.icon)
                    .font(.system(size: 11, weight: .semibold))
                
                Text(category.displayName)
                    .font(.system(size: 12, weight: .semibold))
                
                if count > 0 && category != .all {
                    Text("\(count)")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(isSelected ? Design.accentColor : .white)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 1)
                        .background(isSelected ? Color.white : Color.white.opacity(0.3))
                        .cornerRadius(8)
                }
            }
            .foregroundColor(isSelected ? .white : Color(UIColor.secondaryLabel))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
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
            .cornerRadius(20)
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
            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(viewModel.filteredProducts) { product in
                    ProductCardView(product: product) {
                        navigateToDetail(product: product)
                    }
                    .onAppear {
                        Task { await viewModel.loadMoreIfNeeded(currentItem: product) }
                    }
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.9).combined(with: .opacity),
                        removal: .opacity
                    ))
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 20)
            
            // Loading More Indicator
            if viewModel.isLoadingMore {
                HStack(spacing: 10) {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Loading more...")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(UIColor.secondaryLabel))
                }
                .padding(.vertical, 16)
            }
        }
    }
    
    // MARK: - Loading State
    private var loadingState: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Skeleton header
                HStack(spacing: 8) {
                    ForEach(0..<4, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(UIColor.systemGray5))
                            .frame(width: 80, height: 34)
                    }
                }
                .skeleton(active: true, isShimmering: true, isLight: true)
                .padding(.horizontal, 16)
                
                ProductSkeletonGridView()
            }
            .padding(.top, 12)
        }
    }
    
    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48, weight: .light))
                .foregroundColor(Color(UIColor.systemGray3))
            
            TTBaseSUIText(withBold: .TITLE, text: "No Products Found", align: .center)
            
            TTBaseSUIText(
                withType: .SUB_TITLE,
                text: "Try adjusting your search or filter to find what you're looking for.",
                align: .center,
                color: Color(UIColor.secondaryLabel)
            )
            
            Button(action: {
                viewModel.searchText = ""
                viewModel.selectedCategory = .all
            }) {
                Text("Clear Filters")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Design.accentColor)
                    .cornerRadius(20)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Error State
    private func errorState(message: String) -> some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 48, weight: .light))
                .foregroundColor(Color(UIColor.systemGray3))
            
            TTBaseSUIText(withBold: .TITLE, text: "Connection Error", align: .center)
            
            TTBaseSUIText(
                withType: .SUB_TITLE,
                text: message,
                align: .center,
                color: Color(UIColor.secondaryLabel)
            )
            
            Button(action: {
                Task { await viewModel.loadProducts() }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.clockwise")
                    Text("Try Again")
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .background(Design.accentColor)
                .cornerRadius(20)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Navigation
    private func navigateToDetail(product: Product) {
        let detailView = ProductDetailView(product: product)
        if let hostVC = hostingProvider.getCurrentVC() {
            let detailVC = detailView.embeddedInHostingController()
            hostVC.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

// MARK: - Preview
#Preview {
    ProductCatalogView()
}
