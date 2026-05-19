//
//  AllShipHome.swift
//  TTBaseUIKitSwiftPMExample
//
//  Created by TuanTruong on 4/9/25.
//  Copyright © 2025 Truong Quang Tuan. All rights reserved.
//

import TTBaseUIKit
import SwiftUI

struct AllShipHome: View {
    
    @StateObject private var vm: AllShipHomeViewModel
    
    
    init() {
        self._vm = StateObject(wrappedValue: AllShipHomeViewModel())
    }
    
    var body: some View {
        TTBaseSUIScroll(alignment: .vertical, bg: Color.white, cornerRadius: 0.0, showIndicators: false, content: {
            VStack(spacing: 16) {
                ZStack(alignment: .top) {
                    XView.buttonBgDef.toColor().pAll(.bottom, 70.0)
                    VStack(alignment: .center, spacing: 8.0) {
                        if self.vm.isHomeBannerLoading {
                            HomeBannerView(detail: HomeBannerResponse.init()).skeleton()
                        } else {
                            if let _banner = self.vm.bannerRes, (_banner.items?.count ?? 0) > 0 {
                                HomeBannerView(detail: _banner)
                            }
                        }
                        HomeActionButtonsView()
                    }
                }
                
                if self.vm.isHomePromosLoading {
                    HomeOffersView.init(res: .init()).skeleton()
                } else {
                    if let _promos = self.vm.promoRes, (_promos.items?.count ?? 0) > 0 {
                        HomeOffersView.init(res: _promos)
                    }
                }
                
                
                HomeHotProductView()
                
                // MARK: View All Button
                TTBaseNavigationLink(destination: {
                    ProductListView()
                }, label: {
                    Text(XText("App.Product.Button.All"))
                        .font(.system(size: XFont.TITLE_H, weight: .bold))
                        .foregroundColor(XView.buttonBgDef.toColor())
                        .frame(maxWidth: .infinity)
                        .size(height: XSize.H_BUTTON)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(XView.buttonBgDef.toColor(), lineWidth: 1)
                        )
                        .padding(.horizontal)
                }, isAnimation: true)
            }
            .pAll(.bottom, XSize.H_BUTTON * 2)
        }, pullToRefresh: {
            
        })
        .background(XView.buttonBgDef.toColor().ignoresSafeArea(.all, edges: .top))
        .onAppear {
            UITabBar.showTabBar(animated: true)
        }
    }
}




struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        AllShipHome()
    }
}
