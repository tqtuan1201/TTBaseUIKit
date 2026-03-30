//
//  RecipeService.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import Foundation
import TTBaseUIKit

// MARK: - Recipe Endpoint
enum RecipeEndpoint: TTAPIEndpoint {
    case list(limit: Int, skip: Int)
    case detail(id: Int)
    case search(query: String)
    case tags
    case byTag(tag: String)
    case byMeal(mealType: String)
    
    var path: String {
        switch self {
        case .list:                     return "/recipes"
        case .detail(let id):           return "/recipes/\(id)"
        case .search:                   return "/recipes/search"
        case .tags:                     return "/recipes/tags"
        case .byTag(let tag):           return "/recipes/tag/\(tag)"
        case .byMeal(let meal):         return "/recipes/meal-type/\(meal)"
        }
    }
    
    var method: TTHTTPMethod { .GET }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .list(let limit, let skip):
            return [
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "skip", value: "\(skip)")
            ]
        case .search(let query):
            return [URLQueryItem(name: "q", value: query)]
        default:
            return nil
        }
    }
}

// MARK: - RecipeService
final class RecipeService: TTBaseAPIService {
    
    static let shared = RecipeService()
    
    private init() {
        super.init(baseURL: "https://dummyjson.com")
    }
    
    func fetchRecipes(limit: Int = 30, skip: Int = 0) async throws -> RecipeResponse {
        try await request(RecipeEndpoint.list(limit: limit, skip: skip))
    }
    
    func fetchRecipe(id: Int) async throws -> Recipe {
        try await request(RecipeEndpoint.detail(id: id))
    }
    
    func searchRecipes(query: String) async throws -> RecipeResponse {
        try await request(RecipeEndpoint.search(query: query))
    }
    
    func fetchTags() async throws -> [String] {
        try await request(RecipeEndpoint.tags)
    }
    
    func fetchRecipes(byTag tag: String) async throws -> RecipeResponse {
        try await request(RecipeEndpoint.byTag(tag: tag))
    }
    
    func fetchRecipes(byMeal mealType: String) async throws -> RecipeResponse {
        try await request(RecipeEndpoint.byMeal(mealType: mealType))
    }
}
