//
//  HotProductView.swift
//  TTBaseUIKitSwiftPMExample
//
//  Created by TuanTruong on 5/9/25.
//  Copyright © 2025 Truong Quang Tuan. All rights reserved.
//

import Foundation
import SwiftUI
import TTBaseUIKit

// MARK: - ViewModel
@MainActor
final class HomeHotProductViewModel: ObservableObject {
    @Published private(set) var isLoading: Bool = true
    @Published var detail: HomeBannerResponse?

    func getBanners() -> [HomeBannerItemModel] {
        if self.isLoading {
            return [HomeBannerItemModel(), HomeBannerItemModel(), HomeBannerItemModel(), HomeBannerItemModel(), HomeBannerItemModel(), HomeBannerItemModel()]
        } else {
            return self.detail?.items ?? []
        }
    }

    func fetch() {
        Task {
            self.isLoading = false
        }
    }
}

// MARK: - View
struct HomeHotProductView: View {
    @StateObject private var vm: HomeHotProductViewModel = HomeHotProductViewModel()

    let columns = [
        GridItem(.flexible(), spacing: XSize.P_CONS_DEF),
        GridItem(.flexible(), spacing: XSize.P_CONS_DEF)
    ]

    var body: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: XSize.P_CONS_DEF) {
            TTBaseSUIText(withBold: .HEADER, text: self.vm.detail?.sectionTitle ?? XText("App.Home.Hot.Title"), align: .leading, color: XView.textDefColor.toColor())

            TTBaseEqualHeightGridView(items: self.vm.getBanners(), columns: columns) { item in
                TTBaseNavigationLink {
                    ProductCard(product: item)
                } label: {
                    ProductCard(product: item)
                }
            }
        }
        .bg(byDef: .clear)
        .pHorizontal()
        .skeleton(active: self.vm.isLoading)
        .onAppear {
            self.vm.fetch()
        }
    }
}

// MARK: - ProductCard
struct ProductCard: View {
    let product: HomeBannerItemModel

    var body: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: XSize.P_CONS_DEF) {
            TTBaseSUIHStack(alignment: .center, spacing: XSize.P_XS) {
                TTBaseSUIZStack(alignment: .topLeading) {
                    if self.product.isBestSeller ?? false {
                        BestsellerBadge()
                            .pLeading(XSize.P_CONS_DEF)
                            .pTop(XSize.P_CONS_DEF)
                    }
                }
            }
            .addTestLayout()

            TTBaseSUIText(withBold: .TITLE, text: product.itemName ?? XText("App.Common.Updating"), align: .leading, color: XView.textDefColor.toColor())
                .lineLimit(2)

            TTBaseSUIText(withBold: .TITLE, text: self.product.itemName ?? "-", align: .leading, color: XView.buttonBgWar.toColor())

            salePriceRow

            TTBaseSUISpacer(withBg: .clear, radius: XSize.P_S, maxWidth: 2, maxHeight: nil)
                .lineLimit(2)
                .addTestLayout()
        }
        .pAll(XSize.P_CONS_DEF)
        .bg(byDef: .white)
        .baseBorder(color: .gray.opacity(0.1))
    }

    @ViewBuilder
    private var salePriceRow: some View {
        if self.product.isShowSalePrice() {
            TTBaseSUIText(withType: .SUB_SUB_TILE, text: self.product.itemName ?? "-", align: .leading, color: XView.iconColor.toColor())
        }
    }
}

// MARK: - BestsellerBadge
struct BestsellerBadge: View {
    var text: String = XText("App.Product.Badge.BestSeller")

    var body: some View {
        TTBaseSUIText(withType: .SUB_SUB_TILE, text: text, align: .center, color: .white)
            .pVertical(XSize.P_XS)
            .pHorizontal(XSize.P_S)
            .bg(byDef: XView.buttonBgDef.toColor())
            .corner(byDef: XSize.P_S)
            .accessibilityElement(children: .combine)
            .accessibilityLabel(text)
    }
}
