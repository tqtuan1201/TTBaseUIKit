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

    
    public var refreshViewColor: UIColor = UIColor.getColorFromHex.init(netHex: 0x1C82AD)
    public var textHeaderColor: UIColor = UIColor.getColorFromHex.init(netHex: 0x3c3c3c)
    public var textTitleColor: UIColor =  UIColor.getColorFromHex.init(netHex: 0x555555)
    public var textSubTitleColor: UIColor =  UIColor.getColorFromHex.init(netHex: 0x555555)
    public var textDefColor: UIColor =  UIColor.getColorFromHex.init(netHex: 0x555555)
    public var textWarringColor: UIColor = UIColor.getColorFromHex.init(netHex: 0xC41F53)
    
    public var viewBgSkeleton: UIColor = UIColor.getColorFromHex.init(netHex: 0xe8e8e8)
    public var viewBgGradientSkeleton: UIColor = UIColor.white.withAlphaComponent(0.2)
    public var viewBgGradientMoveSkeleton: UIColor = UIColor.darkGray.withAlphaComponent(0.08)
    
    public var viewBgAccessoryViewColor: UIColor = UIColor.white.withAlphaComponent(0.8)
    public var viewBgNavColor: UIColor = UIColor.getColorFromHex.init(netHex: 0x00A79E)
    public var viewBgLoadingColor: UIColor = UIColor.getColorFromHex.init(netHex: 0x1C82AD)
    public var viewDefColor: UIColor = UIColor.white
    public var viewDisableColor: UIColor = UIColor.getColorFromHex.init(netHex: 0xc5c5c5)
    public var viewBgColor: UIColor = UIColor.getColorFromHex.init(netHex: 0xDBDBDB)
    public var viewPanelWithButtomColor: UIColor = UIColor.white
    public var viewIconTextBgTableView: UIColor =  UIColor.darkText.withAlphaComponent(0.5)
    
    
    public var tableRowTextColor: UIColor = UIColor.getColorFromHex.init(netHex: 0x555555)
    public var tableRowTitleTextColor: UIColor = UIColor.white
    public var tableRowTitleBgColor: UIColor = UIColor.getColorFromHex.init(netHex: 0x929292)
    public var tableRowDev1BgColor: UIColor = UIColor.getColorFromHex.init(netHex: 0xF6F6F6)
    public var tableRowDev2BgColor: UIColor = UIColor.getColorFromHex.init(netHex: 0xEDEDED)
    
    public var viewBgCellColor: UIColor = UIColor.white
    public var viewBgCellSelectedColor: UIColor = UIColor.getColorFromHex.init(netHex: 0xe8f2f6)
    
    public var labelBgDef: UIColor = UIColor.getColorFromHex.init(netHex: 0x1C82AD)
    public var labelBgWar: UIColor = UIColor.getColorFromHex.init(netHex: 0xC41F53)
    public var labelBgDis: UIColor = UIColor.getColorFromHex.init(netHex: 0x454545)
    
    public var buttonBgDef: UIColor = UIColor.getColorFromHex.init(netHex: 0x1C82AD)
    public var buttonBgWar: UIColor = UIColor.getColorFromHex.init(netHex: 0xC41F53)
    public var buttonBgDis: UIColor = UIColor.getColorFromHex.init(netHex: 0x454545)
    public var buttonBorderColor: UIColor =  UIColor.getColorFromHex.init(netHex: 0xe5e5e5)
    
    public var segSelectedColor: UIColor = UIColor.getColorFromHex.init(netHex: 0x1C82AD)
    public var segTextColor: UIColor = UIColor.getColorFromHex.init(netHex: 0x1C82AD)
    public var segTextSelectedColor: UIColor = UIColor.white
    
    public var segBgDef: UIColor = UIColor.getColorFromHex.init(netHex: 0xDBDBDB)
    public var segBgLine: UIColor = UIColor.white
    public var segLineBottomBg: UIColor = UIColor.getColorFromHex.init(netHex: 0xC41F53)
    
    public var lineDefColor: UIColor =  UIColor.getColorFromHex.init(netHex: 0x1C82AD)
    public var linePINDefColor: UIColor =  UIColor.getColorFromHex.init(netHex: 0x1C82AD)
    public var linePINInputDefColor: UIColor =  UIColor.getColorFromHex.init(netHex: 0xe5e5e5)
    public var lineActiveColor: UIColor =  UIColor.getColorFromHex.init(netHex: 0xC41F53)
    
    public var iconColor: UIColor =  UIColor.getColorFromHex.init(netHex: 0x777777)
    public var iconRightTextFieldColor: UIColor =  UIColor.getColorFromHex.init(netHex: 0x777777)
    
    public var processViewBgColor:UIColor = UIColor.getColorFromHex.init(netHex: 0xC41F53).withAlphaComponent(0.4)
    public var processViewProcessColor:UIColor = UIColor.getColorFromHex.init(netHex: 0xC41F53).withAlphaComponent(0.2)
    public var processViewTrackColor:UIColor = UIColor.getColorFromHex.init(netHex: 0xC41F53).withAlphaComponent(0.8)

    public var notificationBgSuccess: UIColor = UIColor.getColorFromHex.init(netHex: 0x0077ab)
    public var notificationBgWarning: UIColor = UIColor.getColorFromHex.init(netHex: 0xcc9a05)
    public var notificationBgError: UIColor = UIColor.getColorFromHex.init(netHex: 0xb22a37)
    
    public var dismissPresentBgview: UIColor = UIColor.white
    public var dismissPresentLineBgview: UIColor = UIColor.getColorFromHex.init(netHex: 0xc5c5c5)
    
    public init() {}
}

