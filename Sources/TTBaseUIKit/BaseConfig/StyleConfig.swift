//
//  StyleConfig.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 11/10/21.
//  Copyright © 2021 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

public enum DismissKeyboardType {
    case ICON
    case TEXT
    case ICON_TEXT
}

open class StyleConfig {

    
    public var isDismissKeyboardByTouchAnywhere:Bool = false
    public var isDismissKeyboardByTouchAnyBaseUIView:Bool = false
    public var isDismissKeyboardByTouchAnyBaseScrollView:Bool = false
    public var dismissKeyboardType:DismissKeyboardType = DismissKeyboardType.ICON
    public var dismissKeyboardScrollViewType:UIScrollView.KeyboardDismissMode = .none
    
    public init() {}
}

