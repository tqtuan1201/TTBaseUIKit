//
//  MenuFunction.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import Foundation

// MARK: - MenuFunction
/// Represents a single menu item in the demo catalog.
struct MenuFunction {
    
    enum TYPE {
        case THEME
        case BASE_TABLE_VIEW_EMPTY
        case BASE_COLLECTIONVIEW
        case BASE_CUSTOM_FLOWLAYOUT_COLLECTIONVIEW
        case BASE_CALENDAR
        case BASE_TABLE_VIEW_CELL
        case BASE_VIEWCONTROLLER
        case BASE_TABLE_VIEW_CONTROLLER
        case BASE_COLLECTION_VIEW_CELL
        case BASE_AUTO_LAYOUT
        case BASE_ADVANCE_AUTO_LAYOUT
        case BASE_MESSAGE
        case BASE_POPUP
        case BASE_PRESENT_VC
        case BASE_PICKER
        case BASE_TEST
        case BASE_COMPONENTS
        
        case ANIMATION_SKELETON_UIKIT
        case ANIMATION_SKELETON_SWIFTUI
        
        case BASE_SWIFTUI_VIEW
        case BASE_SWIFTUI_BUTTON
        case BASE_SWIFTUI_TEXT
        case BASE_SWIFTUI_IMAGE
        case BASE_SWIFTUI_STACK
        case BASE_SWIFTUI_SPACER
        case BASE_SWIFTUI_SCROLL_STACK
        case BASE_SWIFTUI_DIVIDER
        
        case BASE_SWIFTUI_NEW_VERSION
        
        case BASE_FUNCS
        case DEBUG_UI
        case JAILBREAK_CHECKER
    }
    
    let type: TYPE
    let name: String
    let des: String
    
    func getImage() -> String {
        switch self.type {
        case .THEME:              return "gear"
        case .BASE_TABLE_VIEW_EMPTY: return "layout"
        case .BASE_COLLECTIONVIEW: return "layout"
        case .BASE_CUSTOM_FLOWLAYOUT_COLLECTIONVIEW: return "layout"
        case .BASE_TABLE_VIEW_CELL: return "row"
        case .BASE_COLLECTION_VIEW_CELL: return "row"
        case .BASE_MESSAGE:       return "chat"
        case .BASE_POPUP:         return "web-browser"
        case .BASE_PRESENT_VC:    return "web-browser"
        case .BASE_PICKER:        return "calendar"
        case .BASE_TEST:          return "row"
        case .BASE_VIEWCONTROLLER: return "TTBaseUIKit"
        case .BASE_TABLE_VIEW_CONTROLLER: return "TTBaseUIKit"
        case .BASE_COMPONENTS:    return "row"
        case .BASE_AUTO_LAYOUT:   return "row"
        case .BASE_ADVANCE_AUTO_LAYOUT: return "row"
        case .BASE_CALENDAR:      return "row"
        case .BASE_SWIFTUI_VIEW:  return "row"
        case .BASE_SWIFTUI_BUTTON: return "row"
        case .BASE_SWIFTUI_TEXT:  return "row"
        case .BASE_SWIFTUI_IMAGE: return "row"
        case .BASE_SWIFTUI_STACK: return "row"
        case .BASE_SWIFTUI_SPACER: return "row"
        case .BASE_FUNCS:         return "row"
        case .BASE_SWIFTUI_SCROLL_STACK: return "row"
        case .BASE_SWIFTUI_DIVIDER: return "row"
        case .DEBUG_UI:           return "debugging"
        case .JAILBREAK_CHECKER:  return "mobile-device"
        default:                  return "row"
        }
    }
}

// MARK: - Factory Methods
extension MenuFunction {
    
    static func getConfig() -> [MenuFunction] {
        [MenuFunction(type: .THEME, name: "Setup Basic Theme", des: "You can customize colors for buttons, labels, and more using ViewConfig, for buttons, labels, navigation using SizeConfig. for font sizes for titles, subtitles, and headers using FontConfig.")]
    }
    
    static func getUIKIT() -> [MenuFunction] {
        [
            MenuFunction(type: .BASE_COMPONENTS, name: "Base Components", des: "Base Cover Present Controller is to promote code reuse and maintainability by centralizing common functionality"),
            MenuFunction(type: .BASE_CALENDAR, name: "Base Calendar", des: "A custom visual calendar"),
            MenuFunction(type: .BASE_VIEWCONTROLLER, name: "Base View Controller", des: "Base View Controller is to promote code reuse and maintainability by centralizing common functionality"),
            MenuFunction(type: .BASE_TABLE_VIEW_CONTROLLER, name: "Base Table Controller", des: "Base Table Controller is to promote code reuse and maintainability by centralizing common functionality"),
            MenuFunction(type: .BASE_COLLECTIONVIEW, name: "Base Collection View Controller", des: "Base Collection View Controller is to promote code reuse and maintainability by centralizing common functionality"),
            MenuFunction(type: .BASE_CUSTOM_FLOWLAYOUT_COLLECTIONVIEW, name: "Base Custom Collection View Controller", des: "Automatic cell height in a UICollectionView using a custom UICollectionViewFlowLayout"),
            MenuFunction(type: .BASE_PRESENT_VC, name: "Base Cover Present Controller", des: "Base Cover Present Controller is to promote code reuse and maintainability by centralizing common functionality"),
            MenuFunction(type: .BASE_AUTO_LAYOUT, name: "Base Auto Layout", des: "TTBaseUIKit to make easy Auto Layout. This framework provides some functions to setup and update constraints."),
            MenuFunction(type: .BASE_ADVANCE_AUTO_LAYOUT, name: "Constraints Setup Sample", des: "TTBaseUIKit to make easy Auto Layout. This framework provides some functions to setup and update constraints."),
            MenuFunction(type: .BASE_TABLE_VIEW_CELL, name: "Custom TableViewCell", des: "View all custom tableviewcell type"),
            MenuFunction(type: .BASE_MESSAGE, name: "Messase Alter", des: "Same push notification by ios"),
            MenuFunction(type: .BASE_POPUP, name: "POPUP_VIEW", des: "show popup alter view"),
            MenuFunction(type: .BASE_PICKER, name: "DATE_PICKER", des: "Choose date time from popup"),
            MenuFunction(type: .BASE_TABLE_VIEW_EMPTY, name: "EMPTY_TABLE", des: "Set background for uitableview when empty data"),
            MenuFunction(type: .ANIMATION_SKELETON_UIKIT, name: "SKELETON UIKIT", des: "Play skeleton animation in UIKit world"),
        ]
    }
    
    static func getSwiftUIKIT() -> [MenuFunction] {
        [
            MenuFunction(type: .BASE_SWIFTUI_VIEW, name: "Base SwiftUI View", des: "Let's look at some illustrations of custom SwiftUI views"),
            MenuFunction(type: .BASE_SWIFTUI_BUTTON, name: "Base SwiftUI Button", des: "Let's look at some illustrations of custom SwiftUI views"),
            MenuFunction(type: .BASE_SWIFTUI_TEXT, name: "Base SwiftUI Text", des: "Let's look at some illustrations of custom SwiftUI views"),
            MenuFunction(type: .BASE_SWIFTUI_IMAGE, name: "Base SwiftUI Image", des: "Let's look at some illustrations of custom SwiftUI views"),
            MenuFunction(type: .BASE_SWIFTUI_STACK, name: "Base SwiftUI Stack", des: "Let's look at some illustrations of custom SwiftUI views"),
            MenuFunction(type: .BASE_SWIFTUI_SCROLL_STACK, name: "Base SwiftUI Scroll + Stack", des: "Let's look at some illustrations of custom SwiftUI views"),
            MenuFunction(type: .BASE_SWIFTUI_SPACER, name: "Base SwiftUI Spacer", des: "Let's look at some illustrations of custom SwiftUI views"),
            MenuFunction(type: .BASE_SWIFTUI_DIVIDER, name: "Base SwiftUI Divider", des: "Let's look at some illustrations of custom SwiftUI views"),
            MenuFunction(type: .ANIMATION_SKELETON_SWIFTUI, name: "SKELETON SWIFTUI", des: "Play skeleton animation in SwiftUI world"),
            MenuFunction(type: .BASE_SWIFTUI_NEW_VERSION, name: "Modern Update Alert", des: "Learn how to design a smooth, elegant SwiftUI alert for new app versions."),
        ]
    }
    
    static func getUpdate() -> [MenuFunction] {
        [MenuFunction(type: .THEME, name: "Always updating", des: "You can rest assured when using this library, we will always strive to update and maintain it")]
    }
    
    static func getFuncUtil() -> [MenuFunction] {
        [
            MenuFunction(type: .BASE_FUNCS, name: "Useful functions", des: "TTBaseUIKit provides common handling functions for String, Date, Json, Device, Language, VietNamLunar , Validation, NetworkSpeedTest"),
            MenuFunction(type: .DEBUG_UI, name: "Smart UI Debugging for iOS", des: "A powerful developer tool to inspect, trace, and debug UI components in both UIKit and SwiftUI — directly on-device or in the simulator."),
            MenuFunction(type: .JAILBREAK_CHECKER, name: "JailbreakGuard – Secure Device Integrity Checker", des: "Prevent unauthorized access with fast and reliable jailbreak detection built for iOS apps"),
        ]
    }
}
