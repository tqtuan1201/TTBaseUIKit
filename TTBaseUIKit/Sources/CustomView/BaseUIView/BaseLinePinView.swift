//
//  BaseLinePinView.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 9/16/20.
//  Copyright © 2020 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseLinePinView : TTBaseUIView {

    open var nonActiveColor:UIColor { get { return TTBaseUIKitConfig.getViewConfig().textDefColor.withAlphaComponent(0.5) }}
    open var activeColor:UIColor { get { return TTBaseUIKitConfig.getViewConfig().textWarringColor }}
    open var borderColor:UIColor { get { return TTBaseUIKitConfig.getViewConfig().linePINDefColor }}

    open var isBoldPIN:Bool { get { return true } }
    open var fontSize:CGFloat { get { return TTFont.HEADER_SUPER_H } }
    
    open var paddingLine:CGFloat { get { return 0}}
    open var paddingBotomLine:CGFloat { get { return 0}}
    open var paddingBotomPin:CGFloat { get { return TTSize.P_CONS_DEF * 2.5}}
    
    public lazy var lineView:TTLineView = TTLineView()
    public lazy var pinLabel:TTBaseUILabel = TTBaseUILabel(withType: .HEADER_SUPER, text: "", align: .center)
    
    
    open override func updateBaseUIView() {
        self.setupBaseUIView()
        self.setLine()
    }
    
    public func setText(text:String) {
        self.pinLabel.setText(text: text)
        self.pinLabel.isHidden = false
    }
    
    public func setActive() {
        self.pinLabel.setTextColor(color: self.activeColor)
        self.lineView.setBgColor(self.activeColor)
    }
    
    public func setNonActive() {
        self.pinLabel.setTextColor(color: self.nonActiveColor)
        self.lineView.setBgColor(self.nonActiveColor)
    }

    public func setLine() {
        self.pinLabel.setText(text: "")
        self.pinLabel.setTextColor(color: self.nonActiveColor)
        self.lineView.setBgColor(self.nonActiveColor)
    }
    
    
}

//MARK:// For base funcs

extension TTBaseLinePinView {
    
    fileprivate func setupBaseUIView() {
        
        self.lineView.setBgColor(self.borderColor)
        self.addSubview(self.lineView)
        self.addSubview(self.pinLabel)
     
        if self.isBoldPIN { self.pinLabel.setBold() }
        self.pinLabel.setFontSize(size: self.fontSize)

        self.pinLabel.setFullContentHuggingPriority()
            .setFullCenterAnchor(constant: 0)
        
        self.lineView.setLeadingAnchor(constant: self.paddingLine).setTrailingAnchor(constant: self.paddingLine)
            .setBottomAnchor(constant: self.paddingBotomLine)
            .setHeightAnchor(constant: TTSize.H_LINEVIEW)
    
    }
}


