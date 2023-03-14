//
//  BaseButtonBadge.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 7/9/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseButtonBadge: TTBaseUIButton {
    
    fileprivate var icon:AwesomePro.Light = .bell
    fileprivate var iconColor:UIColor = UIColor.white
    fileprivate var textBadgeColor:UIColor = UIColor.white
    fileprivate var badgeBgColor:UIColor = UIColor.yellow
    
    var badgeLabel:TTBaseBadgeInsetLabel = {
        let bagLb = TTBaseBadgeInsetLabel(withType: .SUB_TITLE, text: "0", align: .center)
        bagLb.isUserInteractionEnabled = false
        return bagLb
    }()
    
    public init(with icon:AwesomePro.Light = AwesomePro.Light.bell, iconColor:UIColor = UIColor.white, badgeBgColor:UIColor = UIColor.yellow, textBadgeColor:UIColor = UIColor.darkText) {
        super.init(frame: .zero)
        self.icon = icon
        self.iconColor = iconColor
        self.badgeBgColor = badgeBgColor
        self.textBadgeColor = textBadgeColor
        self.setupBaseUIView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func setupBaseUIView() {
        self.setDefaultType()
        self.setIconImage(iconName: self.icon, color: self.iconColor, padding: TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF / 2)
        self.badgeLabel.setBgColor(self.badgeBgColor)
        self.addSubview(self.badgeLabel)
        self.badgeLabel.setFullContentHuggingPriority().setTopAnchor(constant: 2).setTrailingAnchor(constant: 2).done()
    }
}

extension TTBaseButtonBadge {
    
    public func setBadgeNumber(with badge:Int) {
        if badge  <= 0 {self.badgeLabel.isHidden = true; return }
        self.badgeLabel.isHidden = false
        self.badgeLabel.setText(text: String(badge))
    }
    
    public func setHiddenBadge() {
        self.badgeLabel.isHidden = true
    }
    
}
