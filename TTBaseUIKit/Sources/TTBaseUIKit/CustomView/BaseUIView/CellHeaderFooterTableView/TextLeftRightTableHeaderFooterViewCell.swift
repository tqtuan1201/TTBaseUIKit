//
//  TextLeftRightTableHeaderFooterViewCell.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 9/16/20.
//  Copyright © 2020 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTTextLeftRightTableHeaderFooterViewCell: TTBaseUITableViewHeaderFooterView {
    
    open var bgColorLabel:UIColor { get { return UIColor.clear }}
    
    open var paddingTextLeftRight:CGFloat { get { return TTSize.P_CONS_DEF }}
    open var paddingTopBottom:CGFloat { get { return TTSize.P_CONS_DEF }}
    
    open var textSpace:CGFloat { get { return TTSize.P_CONS_DEF}}
    open var numberOfTitleLabel:Int { get { return 1 }}
    open var numberOfSubLabel:Int { get { return 1 }}
    
    public var leftLabel:TTBaseUILabel = TTBaseUILabel(withType: .TITLE, text: "Left title",align: .left)
    public var rightLabel:TTBaseUILabel = TTBaseUILabel(withType: .TITLE, text: "right title",align: .right)
    
    override open func updateUI() {
        super.updateUI()
        self.setupBaseUI()
    }
    
    
}

// MARK: For Private funcs
extension TTTextLeftRightTableHeaderFooterViewCell {
    
    fileprivate func setupBaseUI() {
        
        self.leftLabel.setBold()
        
        self.leftLabel.backgroundColor = self.bgColorLabel
        self.panel.addSubview(self.leftLabel)
        self.panel.addSubview(self.rightLabel)
        
        self.leftLabel.setFullContentHuggingPriority()
            .setLeadingAnchor(constant: self.paddingTextLeftRight).setTrailingWithNextToView(view: self.rightLabel, constant: self.textSpace)
            .setTopAnchor(constant: self.paddingTopBottom).setBottomAnchor(constant: self.paddingTopBottom, priority: .defaultHigh)
        
        self.rightLabel.setVerticalContentHuggingPriority()
            .setTrailingAnchor(constant: self.paddingTextLeftRight)
            .setcenterYAnchor(constant: 0)
    }
}

// MARK: For Private funcs
extension TTTextLeftRightTableHeaderFooterViewCell {
    public func setTextLabel(with textString:String, rightText:String) {
        self.leftLabel.setText(text: textString).done()
        self.rightLabel.setText(text: rightText).done()
    }
}

