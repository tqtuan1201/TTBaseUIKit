//
//  GatewayEmptyViewModel.swift
//  TTBaseUIKitExample
//
//  Created by Antigravity on 18/5/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import Foundation

@MainActor
final class GatewayEmptyViewModel: ObservableObject {
    @Published var isNetworkLightReady: Bool = false

    var canContinue: Bool {
        return self.isNetworkLightReady
    }

    func toggleNetworkLightReady() {
        self.isNetworkLightReady.toggle()
    }
}
