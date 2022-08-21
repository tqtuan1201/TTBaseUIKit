//
//  TextSubTextTableHeaderFooterViewCell.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 7/24/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTTextSubTextTableHeaderFooterViewCell: TTBaseUITableViewHeaderFooterView {
    
    open var bgColorLabel:UIColor { get { return UIColor.clear }}
    open var bgTextLabel:UIColor { get { return TTView.textDefColor }}
    open var paddingText:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (TTSize.P_CONS_DEF,TTSize.P_CONS_DEF / 2,TTSize.P_CONS_DEF,TTSize.P_CONS_DEF / 2)}}
    open var textSpace:CGFloat { get { return TTSize.P_CONS_DEF / 2}}
    open var numberOfTitleLabel:Int { get { return 2 }}
    open var numberOfSubLabel:Int { get { return 4 }}
    
    public var titleLabel:TTBaseUILabel = TTBaseUILabel(withType: .TITLE, text: "TITLE TEXT DESCRIPTIONS",align: .left)
    public var subLabel:TTBaseUILabel = TTBaseUILabel(withType: .TITLE, text: "Subtext descriptions",align: .left)
    
    override open func updateUI() {
        super.updateUI()
        self.setupBaseUI()
    }
    
    
}

// MARK: For Private funcs
extension TTTextSubTextTableHeaderFooterViewCell {
    
    fileprivate func setupBaseUI() {
        
        self.titleLabel.setBold()
        
        self.titleLabel.backgroundColor = self.bgColorLabel
        self.panel.addSubview(self.titleLabel)
        self.panel.addSubview(self.subLabel)
        
        self.titleLabel.setVerticalContentHuggingPriority()
            .setLeadingAnchor(constant: self.paddingText.0).setTopAnchor(constant: self.paddingText.1).setTrailingAnchor(constant: self.paddingText.2)
        
        self.subLabel.setVerticalContentHuggingPriority()
            .setLeadingAnchor(constant: self.paddingText.0).setTopAnchorWithAboveView(nextToView: self.titleLabel, constant: self.textSpace)
            .setTrailingAnchor(constant: self.paddingText.2).setBottomAnchor(constant: self.paddingText.3, priority: .defaultHigh)
    }
}

// MARK: For Private funcs
extension TTTextSubTextTableHeaderFooterViewCell {
    public func setTextLabel(with textString:String, subText:String) {
        self.titleLabel.setText(text: textString).done()
        self.subLabel.setText(text: subText).done()
    }
}

