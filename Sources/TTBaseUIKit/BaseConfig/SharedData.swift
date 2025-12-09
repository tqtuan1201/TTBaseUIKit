//
//  File.swift
//  TTBaseUIKit
//
//  Created by TuanTruong on 28/11/25.
//

import Foundation

open class TTBaseUIKitSharedData {
    
    public var isShowedNewVersionPopup: Bool = false

    /// Creates a new ParamConfig with default values.
    public static let share = TTBaseUIKitSharedData()
    fileprivate init() {}
}
