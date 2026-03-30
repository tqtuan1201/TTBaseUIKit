//
//  DemoFeaturesView.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
import TTBaseUIKit

// MARK: - Demo Feature Item
struct DemoFeatureItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String
    let gradient: [Color]
    let destination: DemoFeatureDestination
}

enum DemoFeatureDestination {
    case recipeBook
    case productCatalog
    case userDirectory
    case socialFeed
    case quotesWall
    case todoManager
    case photoGallery
    case contactsBook
}

// MARK: - DemoFeaturesView
struct DemoFeaturesView: View {
    
    private var features: [DemoFeatureItem] {
        let all: [DemoFeatureItem] = [
        DemoFeatureItem(
            icon: "🍳",
            title: "Recipe Book",
            subtitle: "Discover delicious recipes from around the world with ingredients & step-by-step instructions.",
            gradient: [Color.orange, Color.red],
            destination: .recipeBook
        ),
        DemoFeatureItem(
            icon: "🛍️",
            title: "Product Catalog",
            subtitle: "Search, filter & sort products with detail views. Data from DummyJSON API.",
            gradient: [Color(red: 0.2, green: 0.5, blue: 0.95), Color(red: 0.15, green: 0.4, blue: 0.85)],
            destination: .productCatalog
        ),
        DemoFeatureItem(
            icon: "👥",
            title: "User Directory",
            subtitle: "Browse user profiles with search, filter & detailed profile cards.",
            gradient: [Color.blue, Color.purple],
            destination: .userDirectory
        ),
        DemoFeatureItem(
            icon: "📝",
            title: "Social Feed",
            subtitle: "Explore posts with reactions, comments & engagement metrics.",
            gradient: [Color.green, Color.blue.opacity(0.8)],
            destination: .socialFeed
        ),
        DemoFeatureItem(
            icon: "💬",
            title: "Quotes Wall",
            subtitle: "Get inspired by beautiful quotes from famous authors.",
            gradient: [Color.purple, Color.pink],
            destination: .quotesWall
        ),
        DemoFeatureItem(
            icon: "✅",
            title: "Todo Manager",
            subtitle: "Track tasks with completion status & progress analytics.",
            gradient: [Color.blue.opacity(0.8), Color.blue],
            destination: .todoManager
        ),
        DemoFeatureItem(
            icon: "📸",
            title: "Photo Gallery",
            subtitle: "Browse photo albums with masonry grid layout & detail view.",
            gradient: [Color.pink, Color.orange],
            destination: .photoGallery
        ),
        DemoFeatureItem(
            icon: "📇",
            title: "Contacts Book",
            subtitle: "Professional contact directory with company info & geolocation.",
            gradient: [Color.purple.opacity(0.8), Color.blue],
            destination: .contactsBook
        ),
        ]
        
        // PhotoGallery uses AsyncImage (iOS 15+)
        if #available(iOS 15.0, *) {
            return all
        } else {
            return all.filter { $0.destination != .photoGallery }
        }
    }
    
    var body: some View {
        NavigationView {
            TTBaseSUIScroll(alignment: .vertical, showIndicators: false) {
                TTBaseSUIVStack(alignment: .leading, spacing: 12, bg: .clear) {
                    // Header
                    demoHeader
                    
                    // Feature Cards
                    ForEach(features) { feature in
                        NavigationLink(destination: destinationView(for: feature.destination)) {
                            featureCard(feature)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    // Footer
                    footerView
                }
                .pAll(16)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitle("Demo Features", displayMode: .inline)
            .onAppear {
                UITabBar.showTabBar(animated: true)
            }
        }
        .navigationViewStyle(.stack)
        .onAppear {
            UINavigationBarAppearance().setColor(title: .white, background: XView.viewBgNavColor)
        }
    }
    
    // MARK: - Header
    private var demoHeader: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: 8, bg: .clear) {
            TTBaseSUIText(withBold: .HEADER, text: "API Showcase", align: .leading)
            TTBaseSUIText(withType: .SUB_TITLE, text: "Professional SwiftUI demos powered by DummyJSON & JSONPlaceholder APIs, built with TTBaseUIKit components.", align: .leading, color: .secondary)
        }
        .pBottom(8)
    }
    
    // MARK: - Feature Card
    private func featureCard(_ feature: DemoFeatureItem) -> some View {
        TTBaseSUIHStack(alignment: .center, spacing: 14, bg: .clear) {
            // Icon
            Text(feature.icon)
                .font(.system(size: 32))
                .frame(width: 56, height: 56)
                .background(
                    LinearGradient(gradient: Gradient(colors: feature.gradient), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .opacity(0.15)
                )
                .cornerRadius(14)
            
            // Text Content
            TTBaseSUIVStack(alignment: .leading, spacing: 4, bg: .clear) {
                TTBaseSUIText(withBold: .TITLE, text: feature.title, align: .leading)
                TTBaseSUIText(withType: .SUB_SUB_TILE, text: feature.subtitle, align: .leading, color: .secondary)
                    .lineLimit(2)
            }
            .maxWidth(alignment: .leading)
            
            // Chevron
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary)
        }
        .pAll(14)
        .cornerRadius(16)
        .bg(byDef: Color.white)
        .baseShadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
    }
    
    // MARK: - Footer
    private var footerView: some View {
        TTBaseSUIVStack(alignment: .center, spacing: 4, bg: .clear) {
            TTBaseSUIText(withType: .SUB_SUB_TILE, text: "Built with TTBaseUIKit SwiftUI Components", align: .center, color: .secondary)
            TTBaseSUIText(withType: .SUB_SUB_TILE, text: "Data from dummyjson.com & jsonplaceholder.typicode.com", align: .center, color: .secondary)
        }
        .maxWidth()
        .pVertical(16)
    }
    
    // MARK: - Destination Router
    @ViewBuilder
    private func destinationView(for destination: DemoFeatureDestination) -> some View {
        switch destination {
        case .recipeBook:
            RecipeListView()
        case .productCatalog:
            ProductCatalogView()
        case .userDirectory:
            UserDirectoryView()
        case .socialFeed:
            SocialFeedView()
        case .quotesWall:
            QuotesWallView()
        case .todoManager:
            TodoManagerView()
        case .photoGallery:
            if #available(iOS 15.0, *) {
                PhotoGalleryView()
            } else {
                Text("Photo Gallery requires iOS 15+")
            }
        case .contactsBook:
            ContactsBookView()
        }
    }
}

#Preview {
    DemoFeaturesView()
}
