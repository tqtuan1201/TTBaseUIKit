//
//  ValueConfig.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/8/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation

class Config {
    private init() {}
    
    static var isPrintLog:Bool = true
    
    struct Value {
        static let LinkFrameworks = "Frameworks/TTBaseUIKit.framework"
        static let noImageName:String = "img.NoImage.png"
        static let logoDefName:String = "img.logo.Def.png"
        static let fontImageNamePro:String = "fa-light-300"
        static let fontImageNameFree:String = "fa-regular-400"
        static let noDataGifImageName:String = "empty.gif"
    }

}

