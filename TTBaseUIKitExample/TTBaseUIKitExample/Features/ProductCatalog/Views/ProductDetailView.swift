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
struct ProductDetailView: View {
    
    let product: Product
    @State private var selectedImageIndex = 0
    @State private var showAllReviews = false
    @EnvironmentObject var hostingProvider: ViewControllerProvider
    
    // MARK: - Design
    private enum Design {
        static let imageGalleryHeight: CGFloat = 320
        static let sectionSpacing: CGFloat = 20
        static let cardCorner: CGFloat = 16
        static let dotSize: CGFloat = 8
    }
    
    var body: some View {
        SUIBaseViewDemo(
            backType: .POP,
            title: product.title
        ) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: Design.sectionSpacing) {
                    // Image Gallery
                    imageGallerySection
                    
                    // Header: Title + Price
                    headerSection
                        .padding(.horizontal, 16)
                    
                    // Quick Stats
                    quickStatsSection
                        .padding(.horizontal, 16)
                    
                    // Description
                    descriptionSection
                        .padding(.horizontal, 16)
                    
                    // Specifications
                    specsSection
                        .padding(.horizontal, 16)
                    
                    // Reviews
                    reviewsSection
                        .padding(.horizontal, 16)
                    
                    // Add to Cart Button
                    addToCartSection
                        .padding(.horizontal, 16)
                    
                    Spacer(minLength: 30)
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
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
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: Design.imageGalleryHeight)
            
            // Custom Page Indicator
            if product.images.count > 1 {
                HStack(spacing: 6) {
                    ForEach(0..<product.images.count, id: \.self) { index in
                        Circle()
                            .fill(index == selectedImageIndex ?
                                  Color(red: 0.2, green: 0.5, blue: 0.95) :
                                  Color(UIColor.systemGray4))
                            .frame(
                                width: index == selectedImageIndex ? 10 : Design.dotSize,
                                height: Design.dotSize
                            )
                            .animation(.spring(response: 0.3), value: selectedImageIndex)
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .background(Color.white.opacity(0.9))
                .cornerRadius(20)
                .padding(.bottom, 12)
            }
            
            // Discount Badge
            if product.hasDiscount {
                VStack {
                    HStack {
                        Spacer()
                        Text("-\(Int(product.discountPercentage))% OFF")
                            .font(.system(size: 13, weight: .heavy))
                            .foregroundColor(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                LinearGradient(
                                    colors: [Color(red: 1.0, green: 0.25, blue: 0.2), Color(red: 0.9, green: 0.15, blue: 0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(12)
                            .padding(.top, 16)
                            .padding(.trailing, 16)
                    }
                    Spacer()
                }
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Category
            HStack(spacing: 8) {
                Text(product.category.uppercased())
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(categoryColor)
                    .cornerRadius(6)
                
                if let brand = product.brand {
                    Text(brand)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(UIColor.secondaryLabel))
                }
            }
            
            // Title
            Text(product.title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(UIColor.label))
            
            // Rating Row
            HStack(spacing: 4) {
                ForEach(0..<5) { index in
                    Image(systemName: index < Int(product.rating.rounded()) ? "star.fill" : "star")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.orange)
                }
                Text(String(format: "%.1f", product.rating))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(UIColor.label))
                Text("(\(product.reviews.count) reviews)")
                    .font(.system(size: 13))
                    .foregroundColor(Color(UIColor.secondaryLabel))
            }
            
            // Price
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                if product.hasDiscount {
                    Text(product.formattedDiscountedPrice)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(red: 0.85, green: 0.2, blue: 0.15))
                    
                    Text(product.formattedPrice)
                        .font(.system(size: 18, weight: .regular))
                        .strikethrough()
                        .foregroundColor(Color(UIColor.tertiaryLabel))
                    
                    Text("Save \(String(format: "$%.2f", product.price - product.discountedPrice))")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.green)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(4)
                } else {
                    Text(product.formattedPrice)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(UIColor.label))
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(Design.cardCorner)
        .baseShadow(corner: Design.cardCorner, color: .black.opacity(0.06), radius: 6, y: 3)
    }
    
    // MARK: - Quick Stats
    private var quickStatsSection: some View {
        HStack(spacing: 12) {
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
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(color)
            
            Text(title)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(Color(UIColor.secondaryLabel))
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color.white)
        .cornerRadius(12)
        .baseShadow(corner: 12, color: .black.opacity(0.04), radius: 4, y: 2)
    }
    
    // MARK: - Description
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader(title: "Description", icon: "text.alignleft")
            
            Text(product.description)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(Color(UIColor.secondaryLabel))
                .lineSpacing(4)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(Design.cardCorner)
        .baseShadow(corner: Design.cardCorner, color: .black.opacity(0.04), radius: 4, y: 2)
    }
    
    // MARK: - Specifications
    private var specsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "Specifications", icon: "list.bullet.rectangle.fill")
            
            specRow(label: "SKU", value: product.sku)
            specRow(label: "Weight", value: "\(product.weight) kg")
            specRow(label: "Dimensions", value: "\(String(format: "%.1f", product.dimensions.width)) × \(String(format: "%.1f", product.dimensions.height)) × \(String(format: "%.1f", product.dimensions.depth)) cm")
            specRow(label: "Warranty", value: product.warrantyInformation)
            specRow(label: "Min. Order", value: "\(product.minimumOrderQuantity) units")
            
            if !product.tags.isEmpty {
                HStack(spacing: 6) {
                    Text("Tags")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(UIColor.secondaryLabel))
                        .frame(width: 90, alignment: .leading)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(product.tags, id: \.self) { tag in
                                Text(tag)
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.95))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color(red: 0.2, green: 0.5, blue: 0.95).opacity(0.1))
                                    .cornerRadius(6)
                            }
                        }
                    }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(Design.cardCorner)
        .baseShadow(corner: Design.cardCorner, color: .black.opacity(0.04), radius: 4, y: 2)
    }
    
    private func specRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Color(UIColor.secondaryLabel))
                .frame(width: 90, alignment: .leading)
            
            Text(value)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(Color(UIColor.label))
            
            Spacer()
        }
    }
    
    // MARK: - Reviews
    private var reviewsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "Reviews (\(product.reviews.count))", icon: "bubble.left.and.bubble.right.fill")
            
            let displayedReviews = showAllReviews ? product.reviews : Array(product.reviews.prefix(2))
            
            ForEach(displayedReviews) { review in
                reviewCard(review: review)
            }
            
            if product.reviews.count > 2 {
                Button(action: { withAnimation(.spring()) { showAllReviews.toggle() } }) {
                    HStack {
                        Spacer()
                        Text(showAllReviews ? "Show Less" : "View All \(product.reviews.count) Reviews")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.95))
                        Image(systemName: showAllReviews ? "chevron.up" : "chevron.down")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.95))
                        Spacer()
                    }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(Design.cardCorner)
        .baseShadow(corner: Design.cardCorner, color: .black.opacity(0.04), radius: 4, y: 2)
    }
    
    private func reviewCard(review: ProductReview) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                // Avatar
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 0.2, green: 0.5, blue: 0.95), Color(red: 0.4, green: 0.7, blue: 1.0)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 32, height: 32)
                    .overlay(
                        Text(String(review.reviewerName.prefix(1)))
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(review.reviewerName)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(UIColor.label))
                    
                    HStack(spacing: 2) {
                        ForEach(0..<5) { i in
                            Image(systemName: i < review.rating ? "star.fill" : "star")
                                .font(.system(size: 9))
                                .foregroundColor(.orange)
                        }
                    }
                }
                
                Spacer()
            }
            
            Text(review.comment)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(Color(UIColor.secondaryLabel))
                .padding(.leading, 40)
        }
        .padding(12)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(12)
    }
    
    // MARK: - Add to Cart
    private var addToCartSection: some View {
        Button(action: {
            // Demo action
            if let vc = hostingProvider.getCurrentVC() {
                vc.showNoticeView(body: "Added \(product.title) to cart!")
            }
        }) {
            HStack(spacing: 10) {
                Image(systemName: "cart.badge.plus")
                    .font(.system(size: 18, weight: .semibold))
                
                Text("Add to Cart")
                    .font(.system(size: 16, weight: .bold))
                
                Spacer()
                
                Text(product.hasDiscount ? product.formattedDiscountedPrice : product.formattedPrice)
                    .font(.system(size: 16, weight: .bold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [Color(red: 0.2, green: 0.5, blue: 0.95), Color(red: 0.15, green: 0.4, blue: 0.85)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .baseShadow(corner: 16, color: Color(red: 0.2, green: 0.5, blue: 0.95).opacity(0.35), radius: 10, y: 5)
        }
    }
    
    // MARK: - Helpers
    private func sectionHeader(title: String, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.95))
            
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(UIColor.label))
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
