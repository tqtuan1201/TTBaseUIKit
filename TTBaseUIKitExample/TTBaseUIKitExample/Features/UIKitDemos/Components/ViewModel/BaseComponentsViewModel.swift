//
//  BaseComponentsViewModel.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 31/7/24.
//  Copyright © 2024 Truong Quang Tuan. All rights reserved.
//

import TTBaseUIKit

class BaseComponentsViewModel: BaseViewModel {
    
    var willRefreshData: ((_ vm: BaseComponentsViewModel) -> Void)?
}

// MARK: - API
extension BaseComponentsViewModel {
    
    func onFetchData() {
        guard beginFetching() else { return }
    }
}
