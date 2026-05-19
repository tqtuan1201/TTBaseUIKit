//
//  HomeBannerView.swift
//  TTBaseUIKitSwiftPMExample
//
//  Created by TuanTruong on 5/9/25.
//  Copyright © 2025 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
import TTBaseUIKit
import Combine

// MARK: - Banner View
struct BannerView: View {
    static let HEIGHT: CGFloat = 180.0
    
    let model: HomeBannerItemModel
    var body: some View {
        TTBaseSUIZStack(alignment: .center) {
            TTBaseSUIImage(withname: "imagename", contentMode: .fit)
                .size(width: XSize.W - XSize.getPadding() * 2, height: BannerView.HEIGHT)
                .bg(byDef: Color.white)
        }.corner(byDef: 12)
    }
}



@MainActor
final class HomeBannerViewViewModel: ObservableObject {
    
    //@Published private(set) var isLoading: Bool = true
    @Published var detail: HomeBannerResponse?
    
    func getBanners() -> [HomeBannerItemModel] {
        return self.detail?.items ?? []
    }
    
    init(detail: HomeBannerResponse? = nil) {
        self._detail = .init(initialValue: detail)
    }
}

struct HomeBannerView: View {

    @State private var selection = 0
    
    @StateObject private var vm: HomeBannerViewViewModel = HomeBannerViewViewModel()
    
    init(selection: Int = 0, detail: HomeBannerResponse) {
        self.selection = selection
        self._vm =  StateObject(wrappedValue: HomeBannerViewViewModel.init(detail: detail))
    }
    var body: some View {
        TTBaseSUIVStack.init(alignment: .center, spacing: XSize.P_CONS_DEF, bg: Color.clear) {
            TabView(selection: $selection) {
                ForEach(Array(self.vm.getBanners().enumerated()), id: \.offset) { index, item in
                    BannerView(model: item)
                        .tag(index)
                        .pHorizontal()
                        .onTapGesture {
                            ScreenCoordinator.init(model: .init()).start()
                        }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .size(height: BannerView.HEIGHT)
            TTBaseSUIHStack(alignment: .top) {
                ForEach(0..<self.vm.getBanners().count, id: \.self) { i in
                    Circle().fill(Color.white)
                        .frame(width: i == selection ? 10 : 8, height: i == selection ? 10 : 8)
                        .opacity(i == selection ? 1.0 : 0.35)
                        .animation(.easeInOut(duration: 0.2), value: selection)
                        .onTapGesture { selection = i } // optional: tap to jump
                }
            }
        }
    }
}

/*
struct HomeBannerView: View {

    @State private var selection = 0
    
    @StateObject private var vm: HomeBannerViewViewModel = HomeBannerViewViewModel()

    var body: some View {
        TTBaseSUIVStack.init(alignment: .center, spacing: XSize.P_CONS_DEF, bg: Color.clear) {
            TabView(selection: $selection) {
                ForEach(Array(self.vm.getBanners().enumerated()), id: \.offset) { index, item in
                    BannerView(model: item)
                        .tag(index)
                        .pHorizontal()
                        .onTapGesture {
                            ScreenCoordinator.init(model: item.getScreenCoord()).start()
                        }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .size(height: BannerView.HEIGHT)
            TTBaseSUIHStack(alignment: .top) {
                ForEach(0..<self.vm.getBanners().count, id: \.self) { i in
                    Circle().fill(Color.white)
                        .frame(width: i == selection ? 10 : 8, height: i == selection ? 10 : 8)
                        .opacity(i == selection ? 1.0 : 0.35)
                        .animation(.easeInOut(duration: 0.2), value: selection)
                        .onTapGesture { selection = i } // optional: tap to jump
                }
            }
        }
            .skeleton(active: self.vm.isLoading)
            .onAppear {
            self.vm.fetch()
        }
    }
}
*/
#Preview {
    HomeBannerView.init(detail: .init())
}
