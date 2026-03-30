//
//  ProductCardView.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
import TTBaseUIKit

// MARK: - ProductCardView
/// A premium product card with image, price, discount badge, and rating.
/// Uses TTBaseUIKit SwiftUI components for consistent styling.
struct ProductCardView: View {
    
    let product: Product
    let onTap: () -> Void
    
    @State private var isHovered = false
    
    // MARK: - Design Constants
    private enum Design {
        static let cardCorner: CGFloat = 16
        static let imageHeight: CGFloat = 180
        static let badgePadding: CGFloat = 8
        static let contentPadding: CGFloat = 12
        static let ratingStarSize: CGFloat = 10
    }
    
    var body: some View {
        Button(action: onTap) {
            TTBaseSUIVStack(alignment: .leading, spacing: 0, bg: .white, radius: Design.cardCorner) {
                // Product Image
                imageSection
                
                // Product Info
                infoSection
            }
            .baseShadow(
                corner: Design.cardCorner,
                color: .black.opacity(isHovered ? 0.18 : 0.08),
                radius: isHovered ? 12 : 6,
                y: isHovered ? 8 : 3
            )
            .scaleEffect(isHovered ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovered)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            isHovered = pressing
        }, perform: {})
    }
    
    // MARK: - Image Section
    private var imageSection: some View {
        ZStack(alignment: .topLeading) {
            // Product Image
            TTBaseSUIAsyncImage(
                urlString: product.thumbnail,
                contentMode: .fit,
                cornerRadius: 0
            )
            .frame(maxWidth: .infinity)
            .frame(height: Design.imageHeight)
            .background(Color(UIColor.systemGray6))
            .clipShape(RoundedTopCorners(radius: Design.cardCorner))
            
            // Discount Badge
            if product.hasDiscount {
                discountBadge
            }
            
            // Stock Badge (only for low stock)
            if product.isLowStock {
                stockBadge
            }
        }
    }
    
    // MARK: - Info Section
    private var infoSection: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: 6, bg: .clear) {
            // Category Tag
            Text(product.category.uppercased())
                .font(.system(size: 9, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(categoryColor)
                .cornerRadius(4)
            
            // Title
            Text(product.title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Color(UIColor.label))
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            
            // Brand
            if let brand = product.brand {
                Text(brand)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(UIColor.secondaryLabel))
            }
            
            // Rating
            ratingView
            
            // Price
            priceView
        }
        .padding(Design.contentPadding)
    }
    
    // MARK: - Rating View
    private var ratingView: some View {
        HStack(spacing: 3) {
            // Stars
            ForEach(0..<5) { index in
                Image(systemName: starType(for: index))
                    .font(.system(size: Design.ratingStarSize, weight: .medium))
                    .foregroundColor(index < Int(product.rating.rounded()) ? .orange : Color(UIColor.systemGray4))
            }
            
            Text(String(format: "%.1f", product.rating))
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(Color(UIColor.secondaryLabel))
            
            Text("(\(product.reviews.count))")
                .font(.system(size: 10))
                .foregroundColor(Color(UIColor.tertiaryLabel))
        }
    }
    
    // MARK: - Price View
    private var priceView: some View {
        HStack(alignment: .firstTextBaseline, spacing: 6) {
            if product.hasDiscount {
                Text(product.formattedDiscountedPrice)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(red: 0.85, green: 0.2, blue: 0.15))
                
                Text(product.formattedPrice)
                    .font(.system(size: 12, weight: .regular))
                    .strikethrough()
                    .foregroundColor(Color(UIColor.tertiaryLabel))
            } else {
                Text(product.formattedPrice)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(UIColor.label))
            }
            
            Spacer()
        }
    }
    
    // MARK: - Discount Badge
    private var discountBadge: some View {
        Text("-\(Int(product.discountPercentage))%")
            .font(.system(size: 11, weight: .heavy))
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                LinearGradient(
                    colors: [Color(red: 1.0, green: 0.25, blue: 0.2), Color(red: 0.9, green: 0.15, blue: 0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(8)
            .padding(Design.badgePadding)
    }
    
    // MARK: - Stock Badge
    private var stockBadge: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                HStack(spacing: 3) {
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 5, height: 5)
                    Text("Low Stock")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundColor(.orange)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(Color.orange.opacity(0.12))
                .cornerRadius(4)
                .padding(Design.badgePadding)
            }
        }
        .frame(height: Design.imageHeight)
    }
    
    // MARK: - Helpers
    private var categoryColor: Color {
        switch product.category {
        case "beauty": return Color(red: 0.85, green: 0.35, blue: 0.65)
        case "fragrances": return Color(red: 0.55, green: 0.45, blue: 0.85)
        case "furniture": return Color(red: 0.35, green: 0.65, blue: 0.55)
        case "groceries": return Color(red: 0.45, green: 0.65, blue: 0.35)
        default: return Color(UIColor.systemGray)
        }
    }
    
    private func starType(for index: Int) -> String {
        let rating = product.rating
        if Double(index) + 1 <= rating {
            return "star.fill"
        } else if Double(index) + 0.5 <= rating {
            return "star.leadinghalf.filled"
        } else {
            return "star"
        }
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            ForEach(0..<4) { _ in
                ProductCardView(
                    product: Product(
                        id: 1,
                        title: "Essence Mascara Lash Princess",
                        description: "The best mascara",
                        category: "beauty",
                        price: 9.99,
                        discountPercentage: 10.48,
                        rating: 4.5,
                        stock: 99,
                        tags: ["beauty"],
                        brand: "Essence",
                        sku: "BEA-001",
                        weight: 4,
                        dimensions: ProductDimensions(width: 15, height: 13, depth: 22),
                        warrantyInformation: "1 week",
                        shippingInformation: "3-5 days",
                        availabilityStatus: "In Stock",
                        reviews: [],
                        returnPolicy: "No return",
                        minimumOrderQuantity: 1,
                        meta: ProductMeta(createdAt: "", updatedAt: "", barcode: "", qrCode: ""),
                        images: [],
                        thumbnail: "https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/thumbnail.webp"
                    )
                ) { }
            }
        }
        .padding()
    }
    .background(Color(UIColor.systemGroupedBackground))
}
