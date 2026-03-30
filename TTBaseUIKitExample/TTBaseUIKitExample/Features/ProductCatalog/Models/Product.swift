//
//  Product.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import Foundation

// MARK: - API Response
struct ProductResponse: Codable {
    let products: [Product]
    let total: Int
    let skip: Int
    let limit: Int
}

// MARK: - Product Model
struct Product: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let category: String
    let price: Double
    let discountPercentage: Double
    let rating: Double
    let stock: Int
    let tags: [String]
    let brand: String?
    let sku: String
    let weight: Int
    let dimensions: ProductDimensions
    let warrantyInformation: String
    let shippingInformation: String
    let availabilityStatus: String
    let reviews: [ProductReview]
    let returnPolicy: String
    let minimumOrderQuantity: Int
    let meta: ProductMeta
    let images: [String]
    let thumbnail: String
    
    /// Discounted price
    var discountedPrice: Double {
        price * (1 - discountPercentage / 100)
    }
    
    /// Formatted price string
    var formattedPrice: String {
        String(format: "$%.2f", price)
    }
    
    /// Formatted discounted price string
    var formattedDiscountedPrice: String {
        String(format: "$%.2f", discountedPrice)
    }
    
    /// Average review rating
    var averageReviewRating: Double {
        guard !reviews.isEmpty else { return 0 }
        let total = reviews.reduce(0) { $0 + $1.rating }
        return Double(total) / Double(reviews.count)
    }
    
    /// Whether discounted
    var hasDiscount: Bool {
        discountPercentage > 0
    }
    
    /// In stock status
    var isInStock: Bool {
        availabilityStatus == "In Stock"
    }
    
    /// Low stock
    var isLowStock: Bool {
        availabilityStatus == "Low Stock"
    }
}

// MARK: - Product Dimensions
struct ProductDimensions: Codable {
    let width: Double
    let height: Double
    let depth: Double
}

// MARK: - Product Review
struct ProductReview: Codable, Identifiable {
    let rating: Int
    let comment: String
    let date: String
    let reviewerName: String
    let reviewerEmail: String
    
    var id: String { reviewerEmail + date }
}

// MARK: - Product Meta
struct ProductMeta: Codable {
    let createdAt: String
    let updatedAt: String
    let barcode: String
    let qrCode: String
}

// MARK: - Product Category (for filter chips)
enum ProductCategory: String, CaseIterable, Identifiable {
    case all = "All"
    case beauty = "beauty"
    case fragrances = "fragrances"
    case furniture = "furniture"
    case groceries = "groceries"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .all: return "All"
        case .beauty: return "Beauty"
        case .fragrances: return "Fragrances"
        case .furniture: return "Furniture"
        case .groceries: return "Groceries"
        }
    }
    
    var icon: String {
        switch self {
        case .all: return "square.grid.2x2.fill"
        case .beauty: return "sparkles"
        case .fragrances: return "wind"
        case .furniture: return "bed.double.fill"
        case .groceries: return "cart.fill"
        }
    }
}
