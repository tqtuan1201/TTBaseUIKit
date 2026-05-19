//
//  Util.swift
//  TTBaseUIKitExample
//
//  Created by Truong Quang Tuan on 6/7/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import TTBaseUIKit

var XSize: SizeConfig { TTBaseUIKitConfig.getSizeConfig() }
var XView: ViewConfig { TTBaseUIKitConfig.getViewConfig() }
var XFont: FontConfig { TTBaseUIKitConfig.getFontConfig() }

func XTextU(_ key:String) -> String{
    return key.localize(withBundle: Bundle.main).uppercased()
}

func XText(_ key:String) -> String {
    return key.localize(withBundle: Bundle.main)
}


func XPrint(_ key: AnyObject) {
    if (EnvironmentsConfig.IS_SHOW_LOG) {
        print(key)
    }
}

func XPrint(_ key: Any) {
    if (EnvironmentsConfig.IS_SHOW_LOG) {
        print(key)
    }
}
