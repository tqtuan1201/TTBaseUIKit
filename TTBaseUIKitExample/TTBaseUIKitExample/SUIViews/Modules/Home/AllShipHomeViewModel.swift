//
//  AllShipHomeViewModel.swift
//  TMS_APP
//
//  Created by TuanTruong on 31/10/25.
//  Copyright © 2025 Tuan Truong Quang. All rights reserved.
//

import Foundation
import Combine
import TTBaseUIKit

@MainActor
final class AllShipHomeViewModel: ObservableObject {
    

    @Published var bannerRes: HomeBannerResponse?
    @Published var promoRes: HomeBannerResponse?
    @Published var isHomeBannerLoading: Bool = true
    @Published var isHomePromosLoading: Bool = true
    
    private var bag = Set<AnyCancellable>()
    private var fetchTask: Task<Void, Never>? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.fetchHomeBanner()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.fetchHomePromos()
        }
    }
    
    func fetchHomeBanner() {
        Task {
            self.isHomeBannerLoading = false
        }
    }
    
    func fetchHomePromos() {
        Task {
            self.isHomePromosLoading = false
        }
    }
    
}
