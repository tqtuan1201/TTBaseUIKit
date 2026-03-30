//
//  ViewModelProtocol.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import Foundation

// MARK: - ViewModelProtocol
/// Base protocol for all ViewModels. Provides shared binding closures
/// for loading states, skeleton animations, and error messaging.
protocol ViewModelProtocol: AnyObject {
    var willShowLoading: (() -> Void)? { get set }
    var willRemoveLoading: (() -> Void)? { get set }
    var willShowSkeletonAnimation: (() -> Void)? { get set }
    var willRemoveSkeletonAnimation: (() -> Void)? { get set }
    var willShowMessage: ((_ message: ResponseMessage) -> Void)? { get set }
}
