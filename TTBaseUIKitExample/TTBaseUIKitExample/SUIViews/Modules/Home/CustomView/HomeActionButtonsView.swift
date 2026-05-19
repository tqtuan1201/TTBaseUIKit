//
//  HomeActionButtonsView.swift
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
final class HomeActionViewModel: ObservableObject {
    @Published private(set) var isLoading: Bool = true
    @Published var detail: HomeBannerResponse?

    func getItems() -> [HomeBannerItemModel] {
        if self.isLoading {
            return [HomeBannerItemModel(), HomeBannerItemModel(), HomeBannerItemModel()]
        } else {
            return self.detail?.items ?? []
        }
    }

    func fetch() {
        Task {
            let resObj = HomeBannerResponse.init(localMenus: HomeBannerItemModel.creatMenuLocal())
            self.detail = resObj
            self.isLoading = false
        }
    }
}

// MARK: - View
struct HomeActionButtonsView: View {
    @StateObject private var vm: HomeActionViewModel = HomeActionViewModel()

    var body: some View {
        TTBaseSUIView(withCornerRadius: XSize.CORNER_RADIUS, bg: .white) {
            TTBaseSUIHStack(alignment: .top, spacing: XSize.P_CONS_DEF / 4, bg: .clear) {
                ForEach(Array(self.vm.getItems().enumerated()), id: \.offset) { _, item in
                    ActionButton(item: item)
                        .opacity(item.isEnable() ? 1.0 : 0.5)
                        .pBottom(XSize.P_CONS_DEF)
                        .onTapGesture {
                            UIApplication.topViewController()?.showNoticeView(body: XText("App.Dev.Developement"), style: .WARNING)
                        }
                }
            }
            .bg(byDef: .clear)
            .pTop(XSize.P_CONS_DEF * 2)
            .pBottom(XSize.P_CONS_DEF)
            .skeleton(active: self.vm.isLoading)
        }
        .pAll()
        .bg(byDef: .clear)
        .baseShadow()
        .pHorizontal(XSize.P_CONS_DEF)
        .onAppear {
            self.vm.fetch()
        }
    }
}

// MARK: - ActionButton
private struct ActionButton: View {
    let item: HomeBannerItemModel

    var body: some View {
        VStack(spacing: XSize.P_CONS_DEF) {
            iconView
            TTBaseSUIText(withType: .TITLE, text: self.item.itemName ?? "", align: .center, color: .black)
        }
        .frame(maxWidth: .infinity)
    }

    private var iconView: some View {
        Group {
            if (self.item.urlImage ?? "").isValidURL() {
                TTBaseSUIImage(withname: self.item.urlImage ?? "", contentMode: .fit)
                    .sizeSquare(width: XSize.H_BUTTON + XSize.P_CONS_DEF * 2)
                    .pAll(XSize.P_CONS_DEF * 2)
                    .bg(byDef: XView.buttonBgDef.toColor().opacity(0.2))
            } else {
                TTBaseSUIImage(withname: self.item.urlImage ?? "", contentMode: .fit)
                    .sizeSquare(width: XSize.H_BUTTON * 1.5)
            }
        }
    }
}
