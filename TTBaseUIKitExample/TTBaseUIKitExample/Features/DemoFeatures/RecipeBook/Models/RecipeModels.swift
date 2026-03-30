//
//  RecipeModels.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import Foundation

// MARK: - Recipe Response
struct RecipeResponse: Codable {
    let recipes: [Recipe]
    let total: Int
    let skip: Int
    let limit: Int
}

// MARK: - Recipe
struct Recipe: Codable, Identifiable {
    let id: Int
    let name: String
    let ingredients: [String]
    let instructions: [String]
    let prepTimeMinutes: Int
    let cookTimeMinutes: Int
    let servings: Int
    let difficulty: String
    let cuisine: String
    let caloriesPerServing: Int
    let tags: [String]
    let userId: Int
    let image: String
    let rating: Double
    let reviewCount: Int
    let mealType: [String]
    
    var totalTime: Int { prepTimeMinutes + cookTimeMinutes }
    
    var formattedTotalTime: String {
        if totalTime >= 60 {
            let hours = totalTime / 60
            let mins = totalTime % 60
            return mins > 0 ? "\(hours)h \(mins)m" : "\(hours)h"
        }
        return "\(totalTime)m"
    }
    
    var difficultyColor: String {
        switch difficulty.lowercased() {
        case "easy": return "green"
        case "medium": return "orange"
        case "hard": return "red"
        default: return "gray"
        }
    }
    
    var ratingStars: String {
        let fullStars = Int(rating)
        let hasHalf = rating - Double(fullStars) >= 0.5
        var stars = String(repeating: "★", count: fullStars)
        if hasHalf { stars += "½" }
        return stars
    }
}
