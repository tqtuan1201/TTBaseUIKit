//
//  EnvironmentsConfig.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 18/5/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//


class EnvironmentsConfig {
    
    static let IS_DEV: Bool = true
    static let IS_AUTO_INPUT_DEV: Bool = false
    static let IS_ENABLE_INJECT:Bool = false

    static let IS_SHOW_LOG:Bool = true
    
    
    static var IS_TEST_LAYOUT:Bool {
        if EnvironmentsConfig.IS_DEV {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}
