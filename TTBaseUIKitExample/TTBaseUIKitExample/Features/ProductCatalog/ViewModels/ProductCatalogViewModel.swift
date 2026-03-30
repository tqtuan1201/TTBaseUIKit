//
//  ProductCatalogViewModel.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import Foundation
import Combine

// MARK: - ProductCatalogViewModel
/// MVVM ViewModel for the Product Catalog feature.
/// Manages product data, filtering, search, and loading states.
@MainActor
final class ProductCatalogViewModel: ObservableObject {
    
    // MARK: - Published State
    @Published var products: [Product] = []
    @Published var filteredProducts: [Product] = []
    @Published var selectedCategory: ProductCategory = .all
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var errorMessage: String?
    @Published var selectedProduct: Product?
    @Published var sortOption: SortOption = .featured
    
    // MARK: - Pagination
    private var currentSkip: Int = 0
    private let pageSize: Int = 30
    private var totalProducts: Int = 0
    private var hasMore: Bool { currentSkip < totalProducts }
    
    // MARK: - Service
    private let service = ProductService.shared
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Sort Options
    enum SortOption: String, CaseIterable, Identifiable {
        case featured = "Featured"
        case priceLow = "Price: Low → High"
        case priceHigh = "Price: High → Low"
        case rating = "Top Rated"
        case discount = "Best Deals"
        
        var id: String { rawValue }
        
        var icon: String {
            switch self {
            case .featured: return "star.fill"
            case .priceLow: return "arrow.up"
            case .priceHigh: return "arrow.down"
            case .rating: return "heart.fill"
            case .discount: return "tag.fill"
            }
        }
    }
    
    // MARK: - Init
    init() {
        setupSearchDebounce()
    }
    
    // MARK: - Search Debounce
    private func setupSearchDebounce() {
        $searchText
            .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self else { return }
                Task { await self.applyFilters() }
            }
            .store(in: &cancellables)
        
        $selectedCategory
            .removeDuplicates()
            .sink { [weak self] _ in
                guard let self else { return }
                Task { await self.applyFilters() }
            }
            .store(in: &cancellables)
        
        $sortOption
            .removeDuplicates()
            .sink { [weak self] _ in
                guard let self else { return }
                Task { await self.applyFilters() }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Load Products
    func loadProducts() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        currentSkip = 0
        
        do {
            let response = try await service.fetchProducts(limit: pageSize, skip: 0)
            products = response.products
            totalProducts = response.total
            currentSkip = response.products.count
            await applyFilters()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // MARK: - Load More (Pagination)
    func loadMoreIfNeeded(currentItem: Product) async {
        guard let lastProduct = filteredProducts.last,
              currentItem.id == lastProduct.id,
              hasMore,
              !isLoadingMore else { return }
        
        isLoadingMore = true
        
        do {
            let response = try await service.fetchProducts(limit: pageSize, skip: currentSkip)
            products.append(contentsOf: response.products)
            currentSkip += response.products.count
            await applyFilters()
        } catch {
            // Silently fail for pagination
        }
        
        isLoadingMore = false
    }
    
    // MARK: - Filter & Sort
    private func applyFilters() async {
        var result = products
        
        // Category filter
        if selectedCategory != .all {
            result = result.filter { $0.category == selectedCategory.rawValue }
        }
        
        // Search filter
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if !query.isEmpty {
            result = result.filter {
                $0.title.lowercased().contains(query) ||
                $0.description.lowercased().contains(query) ||
                $0.category.lowercased().contains(query) ||
                ($0.brand?.lowercased().contains(query) ?? false)
            }
        }
        
        // Sort
        switch sortOption {
        case .featured:
            break // Keep API order
        case .priceLow:
            result.sort { $0.price < $1.price }
        case .priceHigh:
            result.sort { $0.price > $1.price }
        case .rating:
            result.sort { $0.rating > $1.rating }
        case .discount:
            result.sort { $0.discountPercentage > $1.discountPercentage }
        }
        
        filteredProducts = result
    }
    
    // MARK: - Refresh
    func refresh() async {
        await loadProducts()
    }
    
    // MARK: - Computed Properties
    var productCount: Int {
        filteredProducts.count
    }
    
    var isEmptyState: Bool {
        !isLoading && filteredProducts.isEmpty && errorMessage == nil
    }
    
    var categoryCounts: [ProductCategory: Int] {
        var counts: [ProductCategory: Int] = [.all: products.count]
        for product in products {
            if let cat = ProductCategory(rawValue: product.category) {
                counts[cat, default: 0] += 1
            }
        }
        return counts
    }
}
