//
//  MenuSection.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import Foundation

// MARK: - MenuSection
/// Represents a section in the menu table view. Renamed from DataModel.
struct MenuSection {
    
    enum TYPE: Int {
        case CONFIG = 0
        case UIKIT = 1
        case SWIFT_UI = 2
        case FUNC_UTIL = 3
        case MORE = 4
        
        func getDes() -> String {
            switch self {
            case .CONFIG:
                return "When you use this framework. You have the ability to control Color, FontSize, UI size. Config setting in AppDelegate"
            case .UIKIT:
                return "The UIKit component is supported from iOS 10 and above, corresponding to library versions < 2.0.1. Below are some basic examples"
            case .SWIFT_UI:
                return "The SwiftUI component is supported from iOS 14 and above, corresponding to library versions >= 2.0.1. Below are some basic examples"
            case .FUNC_UTIL:
                return "Useful functions"
            case .MORE:
                return "Always updating (https://tqtuan1201.github.io)"
            }
        }
        
        func getIcon() -> String {
            switch self {
            case .CONFIG: return "gear"
            default:      return "menu-bar"
            }
        }
    }
    
    let type: TYPE
    let items: [MenuFunction]
    
    static func createAll() -> [MenuSection] {
        [
            .init(type: .CONFIG, items: MenuFunction.getConfig()),
            .init(type: .UIKIT, items: MenuFunction.getUIKIT()),
            .init(type: .SWIFT_UI, items: MenuFunction.getSwiftUIKIT()),
            .init(type: .FUNC_UTIL, items: MenuFunction.getFuncUtil()),
            .init(type: .MORE, items: MenuFunction.getUpdate()),
        ]
    }
}
