//
//  LableSubLabelView.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 8/7/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

///
/// This Class to view Default:
///
///UIVIEW(-Vertical-(TitleLabel-SubTitleLabel))
///
///
open class TTLableSubLabelView: TTBaseUIView {
    
    open var paddingTitle:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (TTSize.P_CONS_DEF / 2, TTSize.P_CONS_DEF / 2, TTSize.P_CONS_DEF / 2, TTSize.P_CONS_DEF / 2)}}
    open var paddingSub:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (TTSize.P_CONS_DEF / 2, TTSize.P_CONS_DEF / 2, TTSize.P_CONS_DEF / 2, TTSize.P_CONS_DEF / 2)}}
    
    public var titleLabel:TTBaseUILabel = TTBaseUILabel(withType: .TITLE, text: "Title text", align: .left)
    public var subLabel:TTBaseUILabel = TTBaseUILabel(withType: .SUB_TITLE, text: "Subtitle text", align: .left)
    
    open override func updateBaseUIView() {
        super.updateBaseUIView()
        self.setupBaseUIView()
        self.setupBaseContraints()
        
    }
    
    
}

extension TTLableSubLabelView {
    
    fileprivate func setupBaseUIView() {
        
        self.titleLabel.setMutilLine(numberOfLine: 1, textAlignment: .left).setBold()
        self.subLabel.setMutilLine(numberOfLine: 2, textAlignment: .left)
        
        self.setBgColor(UIColor.clear)
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.subLabel)
    }
    
    fileprivate func setupBaseContraints() {
        self.titleLabel.setVerticalContentHuggingPriority()
            .setLeadingAnchor(constant: self.paddingTitle.0).setTopAnchor(constant: self.paddingTitle.1).setTrailingAnchor(constant: self.paddingTitle.2)
        
        self.subLabel.setVerticalContentHuggingPriority()
            .setTopAnchorWithAboveView(nextToView: self.titleLabel, constant: self.paddingSub.1)
            .setLeadingAnchor(constant: self.paddingSub.0).setTrailingAnchor(constant: self.paddingSub.2).setBottomAnchor(constant: self.paddingSub.3).done()
    }
    
    public func setText(with title:String, subTitle:String) {
        self.titleLabel.setText(text: title)
        self.subLabel.setText(text: subTitle)
    }
}
