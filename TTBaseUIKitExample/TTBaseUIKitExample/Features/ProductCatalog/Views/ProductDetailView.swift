//
//  ProductDetailView.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
import TTBaseUIKit

// MARK: - ProductDetailView
/// Full product detail with image gallery, price, reviews, specs.
/// Refactored to maximize TTBaseUIKit SwiftUI base components.
struct ProductDetailView: View {
    
    let product: Product
    @State private var selectedImageIndex = 0
    @State private var showAllReviews = false
    @EnvironmentObject var hostingProvider: ViewControllerProvider
    
    // MARK: - Design
    private enum Design {
        static let imageGalleryHeight: CGFloat = 320
        static let sectionSpacing: CGFloat = TTSize.P_CONS_DEF * 1.5
        static let cardCorner: CGFloat = TTSize.CORNER_PANEL
        static let dotSize: CGFloat = 8
        static let accentColor = Color(red: 0.2, green: 0.5, blue: 0.95)
        static let cardBg = Color(TTView.viewBgCellColor)
    }
    
    var body: some View {
        SUIBaseViewDemo(
            backType: .POP,
            title: product.title
        ) {
            ScrollView(.vertical, showsIndicators: false) {
                TTBaseSUIVStack(alignment: .leading, spacing: Design.sectionSpacing) {
                    imageGallerySection
                    headerSection.pHorizontal(TTSize.P_CONS_DEF)
                    quickStatsSection.pHorizontal(TTSize.P_CONS_DEF)
                    descriptionSection.pHorizontal(TTSize.P_CONS_DEF)
                    specsSection.pHorizontal(TTSize.P_CONS_DEF)
                    reviewsSection.pHorizontal(TTSize.P_CONS_DEF)
                    addToCartSection.pHorizontal(TTSize.P_CONS_DEF)
                    
                    TTBaseSUISpacer(maxHeight: 30)
                }
            }
            .bg(byDef: Color(UIColor.systemGroupedBackground))
        }
    }
    
    // MARK: - Image Gallery
    private var imageGallerySection: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedImageIndex) {
                ForEach(Array(product.images.enumerated()), id: \.offset) { index, imageURL in
                    TTBaseSUIAsyncImage(
                        urlString: imageURL,
                        contentMode: .fit,
                        cornerRadius: 0
                    )
                    .maxWidth()
                    .bg(byDef: Design.cardBg)
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .size(height: Design.imageGalleryHeight)
            
            // Custom Page Indicator
            if product.images.count > 1 {
                TTBaseSUIHStack(alignment: .center, spacing: 6, bg: .clear) {
                    ForEach(0..<product.images.count, id: \.self) { index in
                        Circle()
                            .fill(index == selectedImageIndex ? Design.accentColor : Color(UIColor.systemGray4))
                            .frame(
                                width: index == selectedImageIndex ? 10 : Design.dotSize,
                                height: Design.dotSize
                            )
                            .animation(.spring(response: 0.3), value: selectedImageIndex)
                    }
                }
                .pVertical(TTSize.P_CONS_DEF * 0.8)
                .pHorizontal(TTSize.P_CONS_DEF)
                .bg(byDef: Design.cardBg.opacity(0.9))
                .corner(byDef: 20)
                .pBottom(TTSize.P_CONS_DEF)
            }
            
            // Discount Badge
            if product.hasDiscount {
                VStack {
                    HStack {
                        Spacer()
                        TTBaseSUIText(
                            withBold: .SUB_TITLE,
                            text: "-\(Int(product.discountPercentage))% OFF",
                            align: .center,
                            color: .white
                        )
                        .pHorizontal(TTSize.P_CONS_DEF)
                        .pVertical(TTSize.P_CONS_DEF / 2)
                        .background(
                            LinearGradient(
                                colors: [Color(red: 1.0, green: 0.25, blue: 0.2), Color(red: 0.9, green: 0.15, blue: 0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .corner(byDef: TTSize.CORNER_RADIUS)
                        .pTop(TTSize.P_CONS_DEF)
                        .pTrailing(TTSize.P_CONS_DEF)
                    }
                    Spacer()
                }
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: TTSize.P_CONS_DEF / 2, bg: .clear) {
            // Category + Brand
            TTBaseSUIHStack(alignment: .center, spacing: TTSize.P_CONS_DEF / 2, bg: .clear) {
                TTBaseSUIText(
                    withBold: .SUB_SUB_TILE,
                    text: product.category.uppercased(),
                    align: .center,
                    color: .white
                )
                .pHorizontal(TTSize.P_CONS_DEF * 0.8)
                .pVertical(4)
                .bg(byDef: categoryColor)
                .corner(byDef: 6)
                
                if let brand = product.brand {
                    TTBaseSUIText(
                        withType: .SUB_TITLE,
                        text: brand,
                        align: .leading,
                        color: Color(TTView.textSubTitleColor)
                    )
                }
            }
            
            // Title
            TTBaseSUIText(
                withBold: .HEADER,
                text: product.title,
                align: .leading,
                color: Color(TTView.textTitleColor)
            )
            
            // Rating Row
            TTBaseSUIHStack(alignment: .center, spacing: 4, bg: .clear) {
                ForEach(0..<5) { index in
                    Image(systemName: index < Int(product.rating.rounded()) ? "star.fill" : "star")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.orange)
                }
                TTBaseSUIText(
                    withBold: .SUB_TITLE,
                    text: String(format: "%.1f", product.rating),
                    align: .leading,
                    color: Color(TTView.textTitleColor)
                )
                TTBaseSUIText(
                    withType: .SUB_TITLE,
                    text: "(\(product.reviews.count) reviews)",
                    align: .leading,
                    color: Color(TTView.textSubTitleColor)
                )
            }
            
            // Price
            TTBaseSUIHStack(alignment: .center, spacing: TTSize.P_CONS_DEF, bg: .clear) {
                if product.hasDiscount {
                    Text(product.formattedDiscountedPrice)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(red: 0.85, green: 0.2, blue: 0.15))
                    
                    Text(product.formattedPrice)
                        .font(.system(size: 18, weight: .regular))
                        .strikethrough()
                        .foregroundColor(Color(UIColor.tertiaryLabel))
                    
                    TTBaseSUIText(
                        withBold: .SUB_SUB_TILE,
                        text: "Save \(String(format: "$%.2f", product.price - product.discountedPrice))",
                        align: .center,
                        color: .green
                    )
                    .pHorizontal(TTSize.P_CONS_DEF / 2)
                    .pVertical(3)
                    .bg(byDef: Color.green.opacity(0.1))
                    .corner(byDef: 4)
                } else {
                    Text(product.formattedPrice)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(TTView.textTitleColor))
                }
            }
        }
        .pAll(TTSize.P_CONS_DEF)
        .maxWidth(alignment: .leading)
        .bg(byDef: Design.cardBg)
        .corner(byDef: Design.cardCorner)
        .baseShadow(corner: Design.cardCorner, color: .black.opacity(0.06), radius: 6, y: 3)
    }
    
    // MARK: - Quick Stats
    private var quickStatsSection: some View {
        TTBaseSUIHStack(alignment: .center, spacing: TTSize.P_CONS_DEF, bg: .clear) {
            quickStatItem(
                icon: product.isInStock ? "checkmark.circle.fill" : (product.isLowStock ? "exclamationmark.circle.fill" : "xmark.circle.fill"),
                title: product.availabilityStatus,
                color: product.isInStock ? .green : (product.isLowStock ? .orange : .red)
            )
            
            quickStatItem(icon: "shippingbox.fill", title: product.shippingInformation, color: .blue)
            
            quickStatItem(icon: "arrow.uturn.left.circle.fill", title: product.returnPolicy, color: .purple)
        }
    }
    
    private func quickStatItem(icon: String, title: String, color: Color) -> some View {
        TTBaseSUIVStack(alignment: .center, spacing: 6, bg: .clear) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(color)
            
            TTBaseSUIText(
                withType: .SUB_SUB_TILE,
                text: title,
                align: .center,
                color: Color(TTView.textSubTitleColor)
            )
            .lineLimit(2)
        }
        .maxWidth()
        .pVertical(TTSize.P_CONS_DEF)
        .bg(byDef: Design.cardBg)
        .corner(byDef: TTSize.CORNER_RADIUS)
        .baseShadow(corner: TTSize.CORNER_RADIUS, color: .black.opacity(0.04), radius: 4, y: 2)
    }
    
    // MARK: - Description
    private var descriptionSection: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: TTSize.P_CONS_DEF, bg: .clear) {
            sectionHeader(title: "Description", icon: "text.alignleft")
            
            TTBaseSUIText(
                withType: .SUB_TITLE,
                text: product.description,
                align: .leading,
                color: Color(TTView.textSubTitleColor)
            )
        }
        .pAll(TTSize.P_CONS_DEF)
        .maxWidth(alignment: .leading)
        .bg(byDef: Design.cardBg)
        .corner(byDef: Design.cardCorner)
        .baseShadow(corner: Design.cardCorner, color: .black.opacity(0.04), radius: 4, y: 2)
    }
    
    // MARK: - Specifications
    private var specsSection: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: TTSize.P_CONS_DEF, bg: .clear) {
            sectionHeader(title: "Specifications", icon: "list.bullet.rectangle.fill")
            
            specRow(label: "SKU", value: product.sku)
            specRow(label: "Weight", value: "\(product.weight) kg")
            specRow(label: "Dimensions", value: "\(String(format: "%.1f", product.dimensions.width)) × \(String(format: "%.1f", product.dimensions.height)) × \(String(format: "%.1f", product.dimensions.depth)) cm")
            specRow(label: "Warranty", value: product.warrantyInformation)
            specRow(label: "Min. Order", value: "\(product.minimumOrderQuantity) units")
            
            if !product.tags.isEmpty {
                TTBaseSUIHStack(alignment: .center, spacing: 6, bg: .clear) {
                    TTBaseSUIText(
                        withBold: .SUB_SUB_TILE,
                        text: "Tags",
                        align: .leading,
                        color: Color(TTView.textSubTitleColor)
                    )
                    .size(width: 90)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        TTBaseSUIHStack(alignment: .center, spacing: 6, bg: .clear) {
                            ForEach(product.tags, id: \.self) { tag in
                                TTBaseSUIText(
                                    withType: .SUB_SUB_TILE,
                                    text: tag,
                                    align: .center,
                                    color: Design.accentColor
                                )
                                .pHorizontal(TTSize.P_CONS_DEF * 0.8)
                                .pVertical(4)
                                .bg(byDef: Design.accentColor.opacity(0.1))
                                .corner(byDef: 6)
                            }
                        }
                    }
                }
            }
        }
        .pAll(TTSize.P_CONS_DEF)
        .maxWidth(alignment: .leading)
        .bg(byDef: Design.cardBg)
        .corner(byDef: Design.cardCorner)
        .baseShadow(corner: Design.cardCorner, color: .black.opacity(0.04), radius: 4, y: 2)
    }
    
    private func specRow(label: String, value: String) -> some View {
        TTBaseSUIHStack(alignment: .center, spacing: 0, bg: .clear) {
            TTBaseSUIText(
                withBold: .SUB_SUB_TILE,
                text: label,
                align: .leading,
                color: Color(TTView.textSubTitleColor)
            )
            .size(width: 90)
            
            TTBaseSUIText(
                withType: .SUB_TITLE,
                text: value,
                align: .leading,
                color: Color(TTView.textTitleColor)
            )
            
            Spacer()
        }
    }
    
    // MARK: - Reviews
    private var reviewsSection: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: TTSize.P_CONS_DEF, bg: .clear) {
            sectionHeader(title: "Reviews (\(product.reviews.count))", icon: "bubble.left.and.bubble.right.fill")
            
            let displayedReviews = showAllReviews ? product.reviews : Array(product.reviews.prefix(2))
            
            ForEach(displayedReviews) { review in
                reviewCard(review: review)
            }
            
            if product.reviews.count > 2 {
                Button(action: { withAnimation(.spring()) { showAllReviews.toggle() } }) {
                    TTBaseSUIHStack(alignment: .center, spacing: 4, bg: .clear) {
                        Spacer()
                        TTBaseSUIText(
                            withBold: .SUB_TITLE,
                            text: showAllReviews ? "Show Less" : "View All \(product.reviews.count) Reviews",
                            align: .center,
                            color: Design.accentColor
                        )
                        Image(systemName: showAllReviews ? "chevron.up" : "chevron.down")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(Design.accentColor)
                        Spacer()
                    }
                }
            }
        }
        .pAll(TTSize.P_CONS_DEF)
        .maxWidth(alignment: .leading)
        .bg(byDef: Design.cardBg)
        .corner(byDef: Design.cardCorner)
        .baseShadow(corner: Design.cardCorner, color: .black.opacity(0.04), radius: 4, y: 2)
    }
    
    private func reviewCard(review: ProductReview) -> some View {
        TTBaseSUIVStack(alignment: .leading, spacing: 6, bg: .clear) {
            TTBaseSUIHStack(alignment: .center, spacing: 0, bg: .clear) {
                // Avatar
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Design.accentColor, Color(red: 0.4, green: 0.7, blue: 1.0)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .sizeSquare(width: 32)
                    .overlay(
                        TTBaseSUIText(
                            withBold: .SUB_TITLE,
                            text: String(review.reviewerName.prefix(1)),
                            align: .center,
                            color: .white
                        )
                    )
                
                TTBaseSUIVStack(alignment: .leading, spacing: 2, bg: .clear) {
                    TTBaseSUIText(
                        withBold: .SUB_TITLE,
                        text: review.reviewerName,
                        align: .leading,
                        color: Color(TTView.textTitleColor)
                    )
                    
                    TTBaseSUIHStack(alignment: .center, spacing: 2, bg: .clear) {
                        ForEach(0..<5) { i in
                            Image(systemName: i < review.rating ? "star.fill" : "star")
                                .font(.system(size: 9))
                                .foregroundColor(.orange)
                        }
                    }
                }
                .pLeading(TTSize.P_CONS_DEF / 2)
                
                Spacer()
            }
            
            TTBaseSUIText(
                withType: .SUB_TITLE,
                text: review.comment,
                align: .leading,
                color: Color(TTView.textSubTitleColor)
            )
            .pLeading(40)
        }
        .pAll(TTSize.P_CONS_DEF)
        .bg(byDef: Color(UIColor.systemGray6))
        .corner(byDef: TTSize.CORNER_RADIUS)
    }
    
    // MARK: - Add to Cart
    private var addToCartSection: some View {
        Button(action: {
            if let vc = hostingProvider.getCurrentVC() {
                vc.showNoticeView(body: "Added \(product.title) to cart!")
            }
        }) {
            TTBaseSUIHStack(alignment: .center, spacing: TTSize.P_CONS_DEF, bg: .clear) {
                Image(systemName: "cart.badge.plus")
                    .font(.system(size: 18, weight: .semibold))
                
                TTBaseSUIText(
                    withBold: .TITLE,
                    text: "Add to Cart",
                    align: .leading,
                    color: .white
                )
                
                Spacer()
                
                TTBaseSUIText(
                    withBold: .TITLE,
                    text: product.hasDiscount ? product.formattedDiscountedPrice : product.formattedPrice,
                    align: .trailing,
                    color: .white
                )
            }
            .foregroundColor(.white)
            .pHorizontal(TTSize.P_CONS_DEF * 2)
            .pVertical(TTSize.P_CONS_DEF)
            .background(
                LinearGradient(
                    colors: [Design.accentColor, Color(red: 0.15, green: 0.4, blue: 0.85)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .corner(byDef: Design.cardCorner)
            .baseShadow(corner: Design.cardCorner, color: Design.accentColor.opacity(0.35), radius: 10, y: 5)
        }
    }
    
    // MARK: - Helpers
    private func sectionHeader(title: String, icon: String) -> some View {
        TTBaseSUIHStack(alignment: .center, spacing: TTSize.P_CONS_DEF / 2, bg: .clear) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Design.accentColor)
            
            TTBaseSUIText(
                withBold: .TITLE,
                text: title,
                align: .leading,
                color: Color(TTView.textTitleColor)
            )
        }
    }
    
    private var categoryColor: Color {
        switch product.category {
        case "beauty": return Color(red: 0.85, green: 0.35, blue: 0.65)
        case "fragrances": return Color(red: 0.55, green: 0.45, blue: 0.85)
        case "furniture": return Color(red: 0.35, green: 0.65, blue: 0.55)
        case "groceries": return Color(red: 0.45, green: 0.65, blue: 0.35)
        default: return Color(UIColor.systemGray)
        }
    }
}
