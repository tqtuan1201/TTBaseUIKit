//
//  ProductList.swift
//  TTBaseUIKitSwiftPMExample
//
//  Created by TuanTruong on 19/9/25.
//  Copyright © 2025 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
import TTBaseUIKit


struct EmptyProductView: View {
    var title: String = XText("App.ProductList.Empty.Title")
    var subtitle: String = XText("App.ProductList.Empty.Subtitle")
    var showButton: Bool = false

    var body: some View {
        TTBaseSUIVStack(alignment: .center, spacing: XSize.P_CONS_DEF) {
            TTBaseSUIImage(withSystemName: "shippingbox", iconColor: XView.buttonBgDef.toColor().opacity(0.7), contentMode: .fit)
                .sizeSquare(width: 80)
                .pTop(XSize.P_L * 5)
            TTBaseSUIText(withBold: .TITLE, text: self.title, align: .center, color: XView.textDefColor.toColor())
            TTBaseSUIText(withType: .SUB_TITLE, text: self.subtitle, align: .center, color: XView.textDefColor.toColor().opacity(0.7))
                .lineLimit(4)

            if showButton {
                TTBaseSUIButton(type: .DEFAULT, title: XText("App.ProductList.Empty.Action"))
                    .pTop(XSize.P_CONS_DEF)
            }

            TTBaseSUISpacer()
        }
        .maxWidth()
        .maxHeight()
        .bg(byDef: XView.viewBgColor.toColor())
        .corner()
        .pAll(XSize.P_L * 2)
    }
}

struct ProductListView: View {
    @StateObject private var vm: ProductViewModel = ProductViewModel()

    let columns = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0)
    ]

    var body: some View {
        SUIBaseView(backType: .SWIFTUI, title: XText("App.ProductList.Nav.Title"), type: .DEFAULT, isHiddenTabbar: true, backAction: {}) {
            TTBaseSUIVStack(alignment: .center, spacing: XSize.P_XS, bg: XView.viewBgColor.toColor()) {
                searchHeader
                if self.vm.isShowEmpty() {
                    EmptyProductView()
                } else {
                    productGrid
                }
            }
        }
    }

    // MARK: - Subviews
    private var searchHeader: some View {
        TTBaseSUIVStack(alignment: .center, spacing: XSize.P_XS, bg: XView.viewBgColor.toColor()) {
            TTBaseSUIHStack(alignment: .center, spacing: XSize.P_XS) {
                TTBaseSUIImage(withSystemName: "magnifyingglass", iconColor: XView.iconColor.toColor(), contentMode: .fit)
                    .size(width: 20, height: 20)
                    .pLeading(XSize.P_CONS_DEF)
                TextField(XText("App.Product.Category.Search"), text: self.$vm.textSearch)
                    .textFieldStyle(PlainTextFieldStyle())
                    .size(height: XSize.H_TEXTFIELD)
            }
            .size(height: XSize.H_TEXTFIELD)
            .bg(byDef: XView.viewBgCellColor.toColor())
            .corner()
            .pHorizontal()
            .pTop()

            ProductCategoryView { selected in
                self.vm.selectedCategory = selected
            }
        }
        .baseShadow(corner: XSize.CORNER_RADIUS, color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
    }

    private var productGrid: some View {
        TTBaseSUIScroll(alignment: .vertical, bg: .clear) {
            TTBaseEqualHeightGridView(items: self.vm.items, columns: columns) { product in
                TTBaseNavigationLink {
                    ProductItemView(product: product)
                } label: {
                    ProductItemView(product: product)
                        .pAll(XSize.P_CONS_DEF)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .bg(byDef: XView.viewBgColor.toColor())
                        .corner()
                        .pLeading(XSize.P_CONS_DEF).pTrailing(XSize.P_CONS_DEF).pTop(XSize.P_CONS_DEF)
                        .baseShadow()
                }
            }
            .pBottom(XSize.H_BUTTON)
        }
        .hideKeyboardOnScroll()
        .frame(maxHeight: .infinity)
        .pBottom(XSize.P_CONS_DEF)
        .skeleton(active: self.vm.isLoading)
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView()
    }
}

