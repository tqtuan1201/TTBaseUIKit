//
//  ProductService.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import Foundation
import TTBaseUIKit

// MARK: - Product API Endpoint
/// Type-safe endpoint definitions for the DummyJSON Products API.
enum ProductEndpoint: TTAPIEndpoint {
    case list(limit: Int, skip: Int)
    case detail(id: Int)
    case search(query: String)
    case byCategory(category: String)
    
    var path: String {
        switch self {
        case .list:                        return "/products"
        case .detail(let id):              return "/products/\(id)"
        case .search:                      return "/products/search"
        case .byCategory(let category):    return "/products/category/\(category)"
        }
    }
    
    var method: TTHTTPMethod { .GET }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .list(let limit, let skip):
            return [
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "skip",  value: "\(skip)")
            ]
        case .search(let query):
            return [URLQueryItem(name: "q", value: query)]
        default:
            return nil
        }
    }
}

// MARK: - ProductService
/// Handles network requests to the DummyJSON Products API.
/// Built on top of `TTBaseAPIService` for clean, reusable networking.
final class ProductService: TTBaseAPIService {
    
    static let shared = ProductService()
    
    private init() {
        super.init(baseURL: "https://dummyjson.com")
    }
    
    // MARK: - Fetch All Products
    func fetchProducts(limit: Int = 30, skip: Int = 0) async throws -> ProductResponse {
        try await request(ProductEndpoint.list(limit: limit, skip: skip))
    }
    
    // MARK: - Fetch Single Product
    func fetchProduct(id: Int) async throws -> Product {
        try await request(ProductEndpoint.detail(id: id))
    }
    
    // MARK: - Search Products
    func searchProducts(query: String) async throws -> ProductResponse {
        try await request(ProductEndpoint.search(query: query))
    }
    
    // MARK: - Fetch by Category
    func fetchProducts(byCategory category: String) async throws -> ProductResponse {
        try await request(ProductEndpoint.byCategory(category: category))
    }
}
