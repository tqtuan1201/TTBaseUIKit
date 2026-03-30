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
    
    private enum Design {
        static let cardCorner: CGFloat = TTSize.CORNER_PANEL
        static let imageHeight: CGFloat = 180
    }
    
    var body: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: 0, bg: Color(TTView.viewBgCellColor), radius: Design.cardCorner) {
            // Image placeholder
            Color(UIColor.systemGray5)
                .size(height: Design.imageHeight)
                .clipShape(RoundedTopCorners(radius: Design.cardCorner))
            
            // Content placeholder
            TTBaseSUIVStack(alignment: .leading, spacing: TTSize.P_CONS_DEF / 2, bg: .clear) {
                // Category tag
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(UIColor.systemGray5))
                    .size(width: 60, height: 16)
                
                // Title
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(UIColor.systemGray5))
                    .size(height: 14)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(UIColor.systemGray5))
                    .size(width: 100, height: 14)
                
                // Brand
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(UIColor.systemGray5))
                    .size(width: 80, height: 12)
                
                // Rating
                TTBaseSUIHStack(alignment: .center, spacing: 4, bg: .clear) {
                    ForEach(0..<5, id: \.self) { _ in
                        Circle()
                            .fill(Color(UIColor.systemGray5))
                            .sizeSquare(width: 10)
                    }
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(UIColor.systemGray5))
                        .size(width: 30, height: 10)
                }
                
                // Price
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(UIColor.systemGray5))
                    .size(width: 70, height: 18)
            }
            .pAll(TTSize.P_CONS_DEF)
        }
        .skeleton(active: true, isShimmering: true, isLight: true)
        .baseShadow(corner: Design.cardCorner, color: .black.opacity(0.06), radius: 4, y: 2)
    }
}

// MARK: - ProductSkeletonGridView
/// Full-screen skeleton grid for loading state.
struct ProductSkeletonGridView: View {
    
    private let columns = [
        GridItem(.flexible(), spacing: TTSize.P_CONS_DEF),
        GridItem(.flexible(), spacing: TTSize.P_CONS_DEF)
    ]
    
    var body: some View {
        TTBaseSUILazyVGrid(columns: columns, spacing: TTSize.P_CONS_DEF) {
            ForEach(0..<6, id: \.self) { _ in
                ProductSkeletonView()
            }
        }
        .pHorizontal(TTSize.P_CONS_DEF)
    }
}

#Preview {
    ScrollView {
        ProductSkeletonGridView()
    }
    .bg(byDef: Color(UIColor.systemGroupedBackground))
}
