//
//  HomeOffersView.swift
//  TTBaseUIKitSwiftPMExample
//
//  Created by TuanTruong on 5/9/25.
//  Copyright © 2025 Truong Quang Tuan. All rights reserved.
//

import Foundation
import TTBaseUIKit
import SwiftUI

// MARK: - OffersView


@MainActor
final class HomeOffersViewModel: ObservableObject {
    
    @Published var detail: HomeBannerResponse?
    
    func getBanners() -> [HomeBannerItemModel] {
        return self.detail?.items ?? []
    }
    
    init(detail: HomeBannerResponse? = nil) {
        self.detail = detail
    }
}

struct HomeOffersView: View {
    
    
    @StateObject private var vm: HomeOffersViewModel = HomeOffersViewModel()

    init(res: HomeBannerResponse) {
        self._vm = .init(wrappedValue: .init(detail: res))
    }
    
    var body: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: XSize.P_CONS_DEF * 2) {
            TTBaseSUIText(withBold: .HEADER, text: self.vm.detail?.sectionTitle ?? "Ưu đãi dành cho bạn", align: .leading, color: XView.textDefColor.toColor())
            TTBaseSUIScroll(alignment: .horizontal, showIndicators: false, content: {
                TTBaseSUIHStack(alignment: .center, spacing: XSize.P_CONS_DEF) {
                    ForEach(Array(self.vm.getBanners().enumerated()), id: \.offset) { _, item in
                        OfferCard(item: item)
                            .onTapGesture {
                                ScreenCoordinator.init(model: .init()).start()
                            }
                    }
                }
            }, isEnablePullToRefresh: false, pullToRefresh: nil)
            .size(height: OfferCard.HEIGHT)
        }.pHorizontal()
    }
}

private  struct OfferCard: View {
    static let HEIGHT: CGFloat = 170.0
    
    var item:HomeBannerItemModel
    var body: some View {
        TTBaseSUIZStack(alignment: .center) {
            TTBaseSUIImage(withname: "imagename")
                .size(width: XSize.W - XSize.getPadding() * 2, height: OfferCard.HEIGHT)
                .bg(byDef: Color.white)
        }.corner(byDef: 12)
    }
}

#Preview {
    HomeOffersView.init(res: .init())
}

extension View {
    @ViewBuilder
    func applySafeAreaInsetTopIfAvailable() -> some View {
        if #available(iOS 15.0, *) {
            self.safeAreaInset(edge: .top) {
                EmptyView()
            }
        } else {
            self
        }
    }
}
