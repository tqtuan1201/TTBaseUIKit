//
//  ProductCategoryView.swift
//  TTBaseUIKitSwiftPMExample
//
//  Created by TuanTruong on 19/9/25.
//  Copyright © 2025 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
import TTBaseUIKit

// MARK: - View
struct ProductCategoryView: View {
    
    @StateObject private var vm: ProductCategoryViewModel = ProductCategoryViewModel()
    
    var didSelectHandler: ((ProductCategoryItem) -> Void)?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 8.0) {
                ForEach(self.vm.categories) { item in
                    CategoryCell(
                        item: item,
                        isSelected: item.id == self.vm.selected?.id
                    )
                    .onTapGesture {
                        self.vm.selected = item
                        self.didSelectHandler?(item)
                    }
                }
            }.pAll(8.0)
        }
        .frame(height: XSize.H_BUTTON * 2 + XSize.P_CONS_DEF)
        .bg(byDef: .clear)
        .skeleton(active: self.vm.isLoading)
    }

    // Cell
    @ViewBuilder
    private func CategoryCell(item: ProductCategoryItem, isSelected: Bool) -> some View {
        let strokeColor = isSelected ? Color.orange : Color(.systemGray5)
        let fg = isSelected ? Color.orange : Color(.secondaryLabel)

        TTBaseSUIVStack(alignment: .center, spacing: XSize.P_CONS_DEF + 2) {
            TTBaseSUIImage.init(withname: item.name?.isEmpty == false ? item.name! : "icon-order", contentMode: .fit)
                .frame(height: 26)

            TTBaseSUIText(withType: .SUB_TITLE, text: item.name ?? "", align: .center, color: fg)
                .lineLimit(1)
        }
        .frame(width: XSize.W / 3, height: .infinity, alignment: .center)
        .pAll(XSize.P_CONS_DEF)
        .baseBorder(color: strokeColor, width: isSelected ? 2 : 1, radius: XSize.CORNER_RADIUS)
        .baseShadow(color: .black.opacity(0.03), radius: 1, x: 0, y: 1)
        .animation(.spring(response: 0.25, dampingFraction: 0.9), value: isSelected)
    }
}

// MARK: - Demo
struct CategoryBarDemo: View {
    var body: some View {
        TTBaseSUIVStack(alignment: .center, spacing: 0) {
            ProductCategoryView()
        }
        .bg(byDef: XView.viewBgColor.toColor())
    }
}

struct CategoryBarDemo_Previews: PreviewProvider {
    static var previews: some View {
        CategoryBarDemo()
    }
}
