//
//  BaseViewModel.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import Foundation

// MARK: - BaseViewModel
/// Base class for all ViewModels. Provides default implementations
/// for the ViewModelProtocol binding closures and a shared fetch guard.
class BaseViewModel: ViewModelProtocol {
    
    var isFetching: Bool = false
    
    var willShowLoading: (() -> Void)?
    var willRemoveLoading: (() -> Void)?
    var willShowSkeletonAnimation: (() -> Void)?
    var willRemoveSkeletonAnimation: (() -> Void)?
    var willShowMessage: ((_ message: ResponseMessage) -> Void)?
    
    /// Call before starting a fetch. Returns true if allowed to proceed.
    func beginFetching() -> Bool {
        guard !isFetching else { return false }
        isFetching = true
        willShowLoading?()
        return true
    }
    
    /// Call when fetch completes.
    func endFetching() {
        isFetching = false
        willRemoveLoading?()
    }
}
