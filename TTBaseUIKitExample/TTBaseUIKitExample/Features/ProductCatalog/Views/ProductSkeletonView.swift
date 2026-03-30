//
//  ProductSkeletonView.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
import TTBaseUIKit

// MARK: - ProductSkeletonView
/// Skeleton loading placeholder matching ProductCardView layout.
struct ProductSkeletonView: View {
    
    var body: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: 0, bg: .white, radius: 16) {
            // Image placeholder
            Color(UIColor.systemGray5)
                .frame(height: 180)
                .clipShape(RoundedTopCorners(radius: 16))
            
            // Content placeholder
            VStack(alignment: .leading, spacing: 8) {
                // Category tag
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(UIColor.systemGray5))
                    .frame(width: 60, height: 16)
                
                // Title
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(UIColor.systemGray5))
                    .frame(height: 14)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(UIColor.systemGray5))
                    .frame(width: 100, height: 14)
                
                // Brand
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(UIColor.systemGray5))
                    .frame(width: 80, height: 12)
                
                // Rating
                HStack(spacing: 4) {
                    ForEach(0..<5, id: \.self) { _ in
                        Circle()
                            .fill(Color(UIColor.systemGray5))
                            .frame(width: 10, height: 10)
                    }
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(UIColor.systemGray5))
                        .frame(width: 30, height: 10)
                }
                
                // Price
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(UIColor.systemGray5))
                    .frame(width: 70, height: 18)
            }
            .padding(12)
        }
        .skeleton(active: true, isShimmering: true, isLight: true)
        .baseShadow(corner: 16, color: .black.opacity(0.06), radius: 4, y: 2)
    }
}

// MARK: - ProductSkeletonGridView
/// Full-screen skeleton grid for loading state.
struct ProductSkeletonGridView: View {
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(0..<6, id: \.self) { _ in
                ProductSkeletonView()
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    ScrollView {
        ProductSkeletonGridView()
    }
    .background(Color(UIColor.systemGroupedBackground))
}
