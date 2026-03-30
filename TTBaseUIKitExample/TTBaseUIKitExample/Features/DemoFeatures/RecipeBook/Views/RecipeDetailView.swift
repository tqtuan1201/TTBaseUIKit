//
//  RecipeDetailView.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
import TTBaseUIKit

// MARK: - RecipeDetailView
struct RecipeDetailView: View {
    
    let recipe: Recipe
    @State private var currentImagePage = 0
    
    var body: some View {
        TTBaseSUIScroll(alignment: .vertical, showIndicators: false) {
            TTBaseSUIVStack(alignment: .leading, spacing: 0, bg: .clear) {
                // Hero Image
                heroImage
                
                // Content
                TTBaseSUIVStack(alignment: .leading, spacing: 20, bg: .clear) {
                    // Title & Meta
                    titleSection
                    
                    // Quick Stats
                    statsGrid
                    
                    // Tags
                    if !recipe.tags.isEmpty { tagsSection }
                    
                    // Ingredients
                    ingredientsSection
                    
                    // Instructions
                    instructionsSection
                }
                .pAll(16)
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarTitle(recipe.name, displayMode: .inline)
        .onAppear { UITabBar.hideTabBar(animated: true) }
    }
    
    // MARK: - Hero Image
    private var heroImage: some View {
        TTBaseSUIAsyncImage(urlString: recipe.image, contentMode: .fill, cornerRadius: 0)
            .frame(height: 260)
            .frame(maxWidth: .infinity)
            .clipped()
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [.clear, .black.opacity(0.4)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .overlay(
                TTBaseSUIVStack(alignment: .leading, spacing: 4, bg: .clear) {
                    TTBaseSUIHStack(alignment: .center, spacing: 6, bg: .clear) {
                        ForEach(recipe.mealType, id: \.self) { meal in
                            TTBaseSUIText(withType: .SUB_SUB_TILE, text: meal, align: .center, color: .white)
                                .pAll(.horizontal, 10)
                                .pAll(.vertical, 4)
                                .background(Color.white.opacity(0.25))
                                .cornerRadius(12)
                        }
                    }
                }
                .pAll(16),
                alignment: .bottomLeading
            )
    }
    
    // MARK: - Title Section
    private var titleSection: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: 8, bg: .clear) {
            TTBaseSUIText(withBold: .HEADER, text: recipe.name, align: .leading)
            
            TTBaseSUIHStack(alignment: .center, spacing: 12, bg: .clear) {
                // Rating
                TTBaseSUIHStack(alignment: .center, spacing: 4, bg: .clear) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.yellow)
                    TTBaseSUIText(withBold: .SUB_TITLE, text: String(format: "%.1f", recipe.rating), align: .leading)
                    TTBaseSUIText(withType: .SUB_SUB_TILE, text: "(\(recipe.reviewCount))", align: .leading, color: .secondary)
                }
                
                // Cuisine
                TTBaseSUIHStack(alignment: .center, spacing: 4, bg: .clear) {
                    Image(systemName: "globe")
                        .font(.system(size: 14))
                        .foregroundColor(.orange)
                    TTBaseSUIText(withType: .SUB_TITLE, text: recipe.cuisine, align: .leading, color: .secondary)
                }
                
                Spacer()
                
                // Difficulty
                TTBaseSUIText(withBold: .SUB_SUB_TILE, text: recipe.difficulty, align: .center,
                              color: difficultyColor(recipe.difficulty))
                    .pAll(.horizontal, 10)
                    .pAll(.vertical, 5)
                    .background(difficultyColor(recipe.difficulty).opacity(0.12))
                    .cornerRadius(10)
            }
        }
    }
    
    // MARK: - Stats Grid
    private var statsGrid: some View {
        TTBaseSUIHStack(alignment: .top, spacing: 0, bg: .clear) {
            statItem(icon: "flame.fill", value: "\(recipe.caloriesPerServing)", label: "Calories", color: .red)
            statItem(icon: "timer", value: "\(recipe.prepTimeMinutes)m", label: "Prep", color: .blue)
            statItem(icon: "oven.fill", value: "\(recipe.cookTimeMinutes)m", label: "Cook", color: .orange)
            statItem(icon: "person.2.fill", value: "\(recipe.servings)", label: "Servings", color: .green)
        }
        .pAll(12)
        .background(Color.clear)
        .cornerRadius(16)
        .bg(byDef: Color.white)
        .baseShadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    private func statItem(icon: String, value: String, label: String, color: Color) -> some View {
        TTBaseSUIVStack(alignment: .center, spacing: 6, bg: .clear) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
            TTBaseSUIText(withBold: .TITLE, text: value, align: .center)
            TTBaseSUIText(withType: .SUB_SUB_TILE, text: label, align: .center, color: .secondary)
        }
        .maxWidth()
    }
    
    // MARK: - Tags
    private var tagsSection: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: 8, bg: .clear) {
            TTBaseSUIText(withBold: .TITLE, text: "Tags", align: .leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(recipe.tags, id: \.self) { tag in
                        TTBaseSUIText(withType: .SUB_SUB_TILE, text: "#\(tag)", align: .center, color: .orange)
                            .pAll(.horizontal, 12)
                            .pAll(.vertical, 6)
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(14)
                    }
                }
            }
        }
    }
    
    // MARK: - Ingredients
    private var ingredientsSection: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: 10, bg: .clear) {
            TTBaseSUIHStack(alignment: .center, spacing: 8, bg: .clear) {
                Image(systemName: "list.bullet")
                    .foregroundColor(.green)
                TTBaseSUIText(withBold: .TITLE, text: "Ingredients (\(recipe.ingredients.count))", align: .leading)
            }
            
            TTBaseSUIVStack(alignment: .leading, spacing: 0, bg: .clear, radius: 14) {
                ForEach(Array(recipe.ingredients.enumerated()), id: \.offset) { idx, ingredient in
                    TTBaseSUIHStack(alignment: .center, spacing: 10, bg: .clear) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 6, height: 6)
                        TTBaseSUIText(withType: .SUB_TITLE, text: ingredient, align: .leading)
                            .maxWidth(alignment: .leading)
                    }
                    .pAll(12)
                    
                    if idx < recipe.ingredients.count - 1 {
                        Divider().padding(.leading, 28)
                    }
                }
            }
            .bg(byDef: Color.white)
            .baseShadow(color: .black.opacity(0.04), radius: 3, x: 0, y: 1)
        }
    }
    
    // MARK: - Instructions
    private var instructionsSection: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: 10, bg: .clear) {
            TTBaseSUIHStack(alignment: .center, spacing: 8, bg: .clear) {
                Image(systemName: "text.book.closed.fill")
                    .foregroundColor(.blue)
                TTBaseSUIText(withBold: .TITLE, text: "Instructions", align: .leading)
            }
            
            TTBaseSUIVStack(alignment: .leading, spacing: 0, bg: .clear, radius: 14) {
                ForEach(Array(recipe.instructions.enumerated()), id: \.offset) { idx, step in
                    TTBaseSUIHStack(alignment: .top, spacing: 12, bg: .clear) {
                        TTBaseSUIText(withBold: .SUB_TITLE, text: "\(idx + 1)", align: .center, color: .white)
                            .frame(width: 28, height: 28)
                            .background(Color.blue)
                            .clipShape(Circle())
                        
                        TTBaseSUIText(withType: .SUB_TITLE, text: step, align: .leading)
                            .maxWidth(alignment: .leading)
                    }
                    .pAll(12)
                    
                    if idx < recipe.instructions.count - 1 {
                        Divider().padding(.leading, 52)
                    }
                }
            }
            .bg(byDef: Color.white)
            .baseShadow(color: .black.opacity(0.04), radius: 3, x: 0, y: 1)
        }
    }
    
    private func difficultyColor(_ difficulty: String) -> Color {
        switch difficulty.lowercased() {
        case "easy": return .green
        case "medium": return .orange
        default: return .red
        }
    }
}
