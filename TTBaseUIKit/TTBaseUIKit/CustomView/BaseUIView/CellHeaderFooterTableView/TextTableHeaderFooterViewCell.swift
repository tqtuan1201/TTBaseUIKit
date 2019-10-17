//
//  TextTableHeaderFooterViewCell.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/27/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTTextTableHeaderFooterViewCell: TTBaseUITableViewHeaderFooterView {
    
    open var bgColorLabel:UIColor { get { return UIColor.clear }}
    
    open var paddingLabel:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (TTSize.P_CONS_DEF,TTSize.P_CONS_DEF / 2,TTSize.P_CONS_DEF,TTSize.P_CONS_DEF / 2)}}
    open var numberOfLineLabel:Int { get { return 100 }}
    
    
    public var titleLabel:TTBaseUILabel = TTBaseUILabel(withType: .TITLE, text: "Text Line",align: .left)
    
    override open func updateUI() {
        super.updateUI()
        self.setupBaseUI()
    }
    
    
}

// MARK: For Private funcs
extension TTTextTableHeaderFooterViewCell {
    
    fileprivate func setupBaseUI() {
        self.titleLabel.backgroundColor = self.bgColorLabel
        self.panel.addSubview(self.titleLabel)
        
        self.titleLabel.setVerticalContentHuggingPriority().setLeadingAnchor(constant: self.paddingLabel.0).setTopAnchor(constant: self.paddingLabel.1)
            .setTrailingAnchor(constant: self.paddingLabel.2).setBottomAnchor(constant: self.paddingLabel.3, priority: .defaultHigh).done()
    }
}

// MARK: For Private funcs
extension TTTextTableHeaderFooterViewCell {
    public func setTextLabel(with textString:String) {
        self.titleLabel.setText(text: textString).done()
    }
}

