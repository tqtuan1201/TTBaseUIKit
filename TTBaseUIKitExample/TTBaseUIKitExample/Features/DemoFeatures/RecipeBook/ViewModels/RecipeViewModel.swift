//
//  RecipeViewModel.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - RecipeViewModel
@MainActor
final class RecipeViewModel: ObservableObject {
    
    @Published var recipes: [Recipe] = []
    @Published var selectedRecipe: Recipe?
    @Published var tags: [String] = []
    @Published var selectedTag: String = "All"
    @Published var searchText: String = ""
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var errorMessage: String?
    
    private let service = RecipeService.shared
    private var currentSkip = 0
    private var totalRecipes = 0
    private let pageSize = 10
    
    var hasMore: Bool { currentSkip < totalRecipes }
    
    var filteredRecipes: [Recipe] {
        if searchText.isEmpty { return recipes }
        return recipes.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.cuisine.localizedCaseInsensitiveContains(searchText) ||
            $0.tags.contains(where: { $0.localizedCaseInsensitiveContains(searchText) })
        }
    }
    
    // MARK: - Fetch
    func loadRecipes() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        currentSkip = 0
        
        do {
            async let recipesTask = service.fetchRecipes(limit: pageSize, skip: 0)
            async let tagsTask = service.fetchTags()
            
            let (response, fetchedTags) = try await (recipesTask, tagsTask)
            recipes = response.recipes
            totalRecipes = response.total
            currentSkip = response.recipes.count
            tags = ["All"] + fetchedTags.prefix(15).map { $0 }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func loadMore() async {
        guard !isLoadingMore, hasMore else { return }
        isLoadingMore = true
        
        do {
            let response: RecipeResponse
            if selectedTag == "All" {
                response = try await service.fetchRecipes(limit: pageSize, skip: currentSkip)
            } else {
                response = try await service.fetchRecipes(byTag: selectedTag)
            }
            recipes.append(contentsOf: response.recipes)
            totalRecipes = response.total
            currentSkip += response.recipes.count
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoadingMore = false
    }
    
    func filterByTag(_ tag: String) async {
        selectedTag = tag
        isLoading = true
        errorMessage = nil
        currentSkip = 0
        
        do {
            if tag == "All" {
                let response = try await service.fetchRecipes(limit: pageSize, skip: 0)
                recipes = response.recipes
                totalRecipes = response.total
                currentSkip = response.recipes.count
            } else {
                let response = try await service.fetchRecipes(byTag: tag)
                recipes = response.recipes
                totalRecipes = response.total
                currentSkip = response.recipes.count
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
