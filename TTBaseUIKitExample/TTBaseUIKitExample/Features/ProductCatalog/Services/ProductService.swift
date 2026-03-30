//
//  ProductService.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import Foundation

// MARK: - ProductService
/// Handles network requests to the DummyJSON Products API.
final class ProductService {
    
    static let shared = ProductService()
    
    private let baseURL = "https://dummyjson.com/products"
    private let session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        config.requestCachePolicy = .returnCacheDataElseLoad
        self.session = URLSession(configuration: config)
    }
    
    // MARK: - Fetch All Products
    func fetchProducts(limit: Int = 30, skip: Int = 0) async throws -> ProductResponse {
        guard let url = URL(string: "\(baseURL)?limit=\(limit)&skip=\(skip)") else {
            throw ProductServiceError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw ProductServiceError.serverError
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(ProductResponse.self, from: data)
    }
    
    // MARK: - Fetch Single Product
    func fetchProduct(id: Int) async throws -> Product {
        guard let url = URL(string: "\(baseURL)/\(id)") else {
            throw ProductServiceError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw ProductServiceError.serverError
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(Product.self, from: data)
    }
    
    // MARK: - Search Products
    func searchProducts(query: String) async throws -> ProductResponse {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/search?q=\(encodedQuery)") else {
            throw ProductServiceError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw ProductServiceError.serverError
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(ProductResponse.self, from: data)
    }
    
    // MARK: - Fetch by Category
    func fetchProducts(byCategory category: String) async throws -> ProductResponse {
        guard let url = URL(string: "\(baseURL)/category/\(category)") else {
            throw ProductServiceError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw ProductServiceError.serverError
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(ProductResponse.self, from: data)
    }
}

// MARK: - Error Types
enum ProductServiceError: LocalizedError {
    case invalidURL
    case serverError
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid API URL"
        case .serverError: return "Server returned an error"
        case .decodingError: return "Failed to decode response"
        }
    }
}
