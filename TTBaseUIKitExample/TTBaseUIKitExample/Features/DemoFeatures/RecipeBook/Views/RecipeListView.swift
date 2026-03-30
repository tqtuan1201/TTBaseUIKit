//
//  RecipeListView.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
import TTBaseUIKit

// MARK: - RecipeListView
struct RecipeListView: View {
    
    @StateObject private var viewModel = RecipeViewModel()
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: 0, bg: Color(.systemGroupedBackground)) {
            if viewModel.isLoading && viewModel.recipes.isEmpty {
                skeletonView
            } else if let error = viewModel.errorMessage, viewModel.recipes.isEmpty {
                errorView(error)
            } else {
                contentView
            }
        }
        .navigationBarTitle("Recipe Book", displayMode: .inline)
        .onAppear {
            UITabBar.hideTabBar(animated: true)
            Task { await viewModel.loadRecipes() }
        }
    }
    
    // MARK: - Content
    private var contentView: some View {
        TTBaseSUIScroll(alignment: .vertical, showIndicators: false) {
            TTBaseSUIVStack(alignment: .leading, spacing: 12, bg: .clear) {
                searchBar
                if !viewModel.tags.isEmpty { tagFilterBar }
                
                TTBaseSUILazyVGrid(columns: columns, spacing: 12, bg: .clear) {
                    ForEach(viewModel.filteredRecipes) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                            recipeCard(recipe)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
                if viewModel.hasMore { loadMoreButton }
            }
            .pAll(16)
        }
    }
    
    private var searchBar: some View {
        TTBaseSUIHStack(alignment: .center, spacing: 10, bg: .clear) {
            Image(systemName: "magnifyingglass").foregroundColor(.secondary)
            TextField("Search recipes...", text: $viewModel.searchText).font(.system(size: 15))
        }
        .pAll(12).cornerRadius(12).bg(byDef: Color.white)
    }
    
    private var tagFilterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(viewModel.tags, id: \.self) { tag in
                    let isSelected = viewModel.selectedTag == tag
                    TTBaseSUIText(withType: .SUB_SUB_TILE, text: tag, align: .center,
                                color: isSelected ? .white : .primary)
                        .pAll(.horizontal, 14).pAll(.vertical, 7)
                        .background(isSelected ? Color.orange : Color(.systemBackground))
                        .cornerRadius(20)
                        .baseShadow(color: .black.opacity(0.04), radius: 3, x: 0, y: 1)
                        .onTapGesture { Task { await viewModel.filterByTag(tag) } }
                }
            }
        }
    }
    
    private func recipeCard(_ recipe: Recipe) -> some View {
        TTBaseSUIVStack(alignment: .leading, spacing: 0, bg: .clear, radius: 16) {
            TTBaseSUIAsyncImage(urlString: recipe.image, contentMode: .fill, cornerRadius: 0)
                .frame(height: 120).clipped()
            TTBaseSUIVStack(alignment: .leading, spacing: 6, bg: .clear) {
                TTBaseSUIText(withBold: .SUB_TITLE, text: recipe.name, align: .leading).lineLimit(2)
                TTBaseSUIHStack(alignment: .center, spacing: 4, bg: .clear) {
                    Image(systemName: "globe").font(.system(size: 10)).foregroundColor(.orange)
                    TTBaseSUIText(withType: .SUB_SUB_TILE, text: recipe.cuisine, align: .leading, color: .secondary).lineLimit(1)
                }
                TTBaseSUIHStack(alignment: .center, spacing: 4, bg: .clear) {
                    Image(systemName: "clock").font(.system(size: 10)).foregroundColor(.secondary)
                    TTBaseSUIText(withType: .SUB_SUB_TILE, text: recipe.formattedTotalTime, align: .leading, color: .secondary)
                    Spacer()
                    TTBaseSUIHStack(alignment: .center, spacing: 2, bg: .clear) {
                        Image(systemName: "star.fill").font(.system(size: 10)).foregroundColor(.yellow)
                        TTBaseSUIText(withType: .SUB_SUB_TILE, text: String(format: "%.1f", recipe.rating), align: .trailing, color: .secondary)
                    }
                }
                TTBaseSUIText(withType: .SUB_SUB_TILE, text: recipe.difficulty, align: .center,
                              color: difficultyColor(recipe.difficulty))
                    .pAll(.horizontal, 8).pAll(.vertical, 3)
                    .background(difficultyColor(recipe.difficulty).opacity(0.12)).cornerRadius(8)
            }
            .pAll(10)
        }
        .bg(byDef: Color.white)
        .baseShadow(color: .black.opacity(0.06), radius: 5, x: 0, y: 2)
    }
    
    private func difficultyColor(_ difficulty: String) -> Color {
        switch difficulty.lowercased() {
        case "easy": return .green; case "medium": return .orange; default: return .red
        }
    }
    
    private var skeletonView: some View {
        TTBaseSUIScroll(alignment: .vertical, showIndicators: false) {
            TTBaseSUIVStack(alignment: .leading, spacing: 12, bg: .clear) {
                RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray5)).frame(height: 44)
                    .skeleton(active: true, isShimmering: true, isLight: true)
                TTBaseSUILazyVGrid(columns: columns, spacing: 12, bg: .clear) {
                    ForEach(0..<6, id: \.self) { _ in
                        TTBaseSUIVStack(alignment: .leading, spacing: 0, bg: Color(.systemBackground), radius: 16) {
                            RoundedRectangle(cornerRadius: 0).fill(Color(.systemGray5)).frame(height: 120)
                            TTBaseSUIVStack(alignment: .leading, spacing: 6, bg: .clear) {
                                RoundedRectangle(cornerRadius: 4).fill(Color(.systemGray5)).frame(height: 16)
                                RoundedRectangle(cornerRadius: 4).fill(Color(.systemGray5)).frame(height: 12).frame(maxWidth: 100)
                                RoundedRectangle(cornerRadius: 4).fill(Color(.systemGray5)).frame(height: 12).frame(maxWidth: 80)
                            }.pAll(10)
                        }.skeleton(active: true, isShimmering: true, isLight: true)
                    }
                }
            }.pAll(16)
        }
    }
    
    private func errorView(_ message: String) -> some View {
        TTBaseSUIVStack(alignment: .center, spacing: 16, bg: .clear) {
            Image(systemName: "exclamationmark.triangle.fill").font(.system(size: 48)).foregroundColor(.orange)
            TTBaseSUIText(withBold: .TITLE, text: "Something went wrong", align: .center)
            TTBaseSUIText(withType: .SUB_TITLE, text: message, align: .center, color: .secondary)
            TTBaseSUIButton(type: .DEFAULT, title: "Try Again") { Task { await viewModel.loadRecipes() } }
        }.maxWidth().maxHeight().pAll(32)
    }
    
    private var loadMoreButton: some View {
        TTBaseSUIHStack(alignment: .center, spacing: 8, bg: .clear) {
            if viewModel.isLoadingMore {
                ProgressView()
                TTBaseSUIText(withType: .SUB_TITLE, text: "Loading more...", align: .center, color: .secondary)
            } else {
                TTBaseSUIButton(type: .BORDER, title: "Load More Recipes") { Task { await viewModel.loadMore() } }
            }
        }.maxWidth().pVertical(8)
    }
}
