//
//  ViewConfig.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/6/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class ViewConfig {

    public var textHeaderColor: UIColor = UIColor.darkText
    public var textTitleColor: UIColor =  UIColor.darkText
    public var textSubTitleColor: UIColor =  UIColor.darkText
    public var textDefColor: UIColor =  UIColor.getColorFromHex.init(netHex: 0x555555)
    public var textWarringColor: UIColor = UIColor.getColorFromHex.init(netHex: 0xC41F53)
    
    public var viewBgNavColor: UIColor = UIColor.getColorFromHex.init(netHex: 0x1C82AD)
    public var viewDefColor: UIColor = UIColor.white
    public var viewBgColor: UIColor = UIColor.getColorFromHex.init(netHex: 0xDBDBDB)
    
    public var viewBgCellColor: UIColor = UIColor.white
    public var viewBgCellSelectedColor: UIColor = UIColor.getColorFromHex.init(netHex: 0x1C82AD)
    
    public var labelBgDef: UIColor = UIColor.getColorFromHex.init(netHex: 0x1C82AD)
    public var labelBgWar: UIColor = UIColor.getColorFromHex.init(netHex: 0xC41F53)
    public var labelBgDis: UIColor = UIColor.getColorFromHex.init(netHex: 0x454545)
    
    public var buttonBgDef: UIColor = UIColor.getColorFromHex.init(netHex: 0x1C82AD)
    public var buttonBgWar: UIColor = UIColor.getColorFromHex.init(netHex: 0xC41F53)
    public var buttonBgDis: UIColor = UIColor.getColorFromHex.init(netHex: 0x454545)
    
    
    public var lineColor: UIColor =  UIColor.getColorFromHex.init(netHex: 0x1C82AD)
    
    
    public init() {}
}

