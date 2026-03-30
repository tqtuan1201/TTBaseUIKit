//
//  DemoViewModel.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/7/24.
//  Copyright © 2024 Truong Quang Tuan. All rights reserved.
//

import TTBaseUIKit


class DemoViewModel: BaseViewModel {
    
    var willRefreshData: ((_ vm: DemoViewModel) -> Void)?
}

// MARK: - API
extension DemoViewModel {
    
    func onFetchData() {
        guard beginFetching() else { return }
    }
}
