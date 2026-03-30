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
        static let cardCorner: CGFloat = TTSize.CORNER_PANEL
        static let imageHeight: CGFloat = 180
        static let badgePadding: CGFloat = TTSize.P_CONS_DEF / 2
        static let contentPadding: CGFloat = TTSize.P_CONS_DEF
    }
    
    var body: some View {
        Button(action: onTap) {
            TTBaseSUIVStack(alignment: .leading, spacing: 0, bg: Color(TTView.viewBgCellColor), radius: Design.cardCorner) {
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
            .maxWidth()
            .size(height: Design.imageHeight)
            .bg(byDef: Color(UIColor.systemGray6))
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
            TTBaseSUIText(
                withBold: .SUB_SUB_TILE,
                text: product.category.uppercased(),
                align: .leading,
                color: .white
            )
            .pHorizontal(TTSize.P_CONS_DEF / 2)
            .pVertical(3)
            .bg(byDef: categoryColor)
            .corner(byDef: 4)
            
            // Title
            Text(product.title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Color(TTView.textTitleColor))
                .lineLimit(2)
                .fixedByVertical()
            
            // Brand
            if let brand = product.brand {
                TTBaseSUIText(
                    withType: .SUB_SUB_TILE,
                    text: brand,
                    align: .leading,
                    color: Color(TTView.textSubTitleColor)
                )
            }
            
            // Rating
            ratingView
            
            // Price
            priceView
        }
        .pAll(Design.contentPadding)
    }
    
    // MARK: - Rating View
    private var ratingView: some View {
        TTBaseSUIHStack(alignment: .center, spacing: 3, bg: .clear) {
            // Stars
            ForEach(0..<5) { index in
                Image(systemName: starType(for: index))
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(index < Int(product.rating.rounded()) ? .orange : Color(UIColor.systemGray4))
            }
            
            TTBaseSUIText(
                withBold: .SUB_SUB_TILE,
                text: String(format: "%.1f", product.rating),
                align: .leading,
                color: Color(TTView.textSubTitleColor)
            )
            
            TTBaseSUIText(
                withType: .SUB_SUB_TILE,
                text: "(\(product.reviews.count))",
                align: .leading,
                color: Color(UIColor.tertiaryLabel)
            )
        }
    }
    
    // MARK: - Price View
    private var priceView: some View {
        TTBaseSUIHStack(alignment: .center, spacing: 6, bg: .clear) {
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
                    .foregroundColor(Color(TTView.textTitleColor))
            }
            
            Spacer()
        }
    }
    
    // MARK: - Discount Badge
    private var discountBadge: some View {
        TTBaseSUIText(
            withBold: .SUB_SUB_TILE,
            text: "-\(Int(product.discountPercentage))%",
            align: .center,
            color: .white
        )
        .pHorizontal(TTSize.P_CONS_DEF / 2)
        .pVertical(4)
        .background(
            LinearGradient(
                colors: [Color(red: 1.0, green: 0.25, blue: 0.2), Color(red: 0.9, green: 0.15, blue: 0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .corner(byDef: TTSize.P_CONS_DEF / 2)
        .pAll(Design.badgePadding)
    }
    
    // MARK: - Stock Badge
    private var stockBadge: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                TTBaseSUIHStack(alignment: .center, spacing: 3, bg: .clear) {
                    Circle()
                        .fill(Color.orange)
                        .sizeSquare(width: 5)
                    TTBaseSUIText(
                        withBold: .SUB_SUB_TILE,
                        text: "Low Stock",
                        align: .center,
                        color: .orange
                    )
                }
                .pHorizontal(TTSize.P_CONS_DEF / 2)
                .pVertical(3)
                .bg(byDef: Color.orange.opacity(0.12))
                .corner(byDef: 4)
                .pAll(Design.badgePadding)
            }
        }
        .size(height: Design.imageHeight)
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
