//
//  BaseSquarePinView.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 2/7/20.
//  Copyright © 2020 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseSquarePinView : TTBaseUIView {

    open var borderColor:UIColor { get { return TTBaseUIKitConfig.getViewConfig().linePINDefColor }}
    open var borderInputColor:UIColor { get { return TTBaseUIKitConfig.getViewConfig().linePINInputDefColor }}
    
    open var borderWidth:CGFloat { get { return TTBaseUIKitConfig.getSizeConfig().H_LINEVIEW }}

    public lazy var lineView:TTLineView = TTLineView()
    public lazy var circleView:TTBaseCircleLabel = TTBaseCircleLabel()
    public lazy var pinLabel:TTBaseUILabel = TTBaseUILabel(withType: .HEADER, text: "", align: .center)
    
    
    open override func updateBaseUIView() {
        self.setupBaseUIView()
    }
    
    public func setText(text:String) {
        self.pinLabel.setText(text: text)
        self.pinLabel.isHidden = false
        self.lineView.isHidden = true
        self.circleView.isHidden = true
        self.setBorder(with: self.borderWidth, color: TTView.buttonBgDef, coner: TTSize.CORNER_RADIUS)
    }

    public func setLine() {
        self.pinLabel.setText(text: "")
        self.pinLabel.isHidden = true
        self.lineView.isHidden = false
        self.circleView.isHidden = true
        self.setBorder(with: self.borderWidth, color: TTView.linePINDefColor, coner: TTSize.CORNER_RADIUS)
    }
    
    public func setCircle() {
        self.pinLabel.setText(text: "")
        self.pinLabel.isHidden = true
        self.lineView.isHidden = true
        self.circleView.isHidden = false
        self.setBorder(with: self.borderWidth, color: TTView.linePINDefColor, coner: TTSize.CORNER_RADIUS)
    }
    
    public func setShow() {
        self.lineView.isHidden = true
        self.circleView.isHidden = true
        self.pinLabel.isHidden = false
    }
    
    public func setHidden(withLineColor color:UIColor) {
        self.lineView.setBgColor(color)
        self.lineView.isHidden = false
        self.circleView.isHidden = true
        self.pinLabel.isHidden = true
    }

    public func setHidden(withCircleColor color:UIColor) {
        self.lineView.isHidden = true
        self.circleView.isHidden = false
        self.pinLabel.isHidden = true
        self.setBorder(with: self.borderWidth, color: self.borderInputColor, coner: TTSize.CORNER_RADIUS)
    }
    
}

//MARK:// For base funcs

extension TTBaseSquarePinView {
    
    fileprivate func setupBaseUIView() {

        self.setBorder(with: self.borderWidth, color: self.borderColor, coner: TTSize.CORNER_RADIUS)
        self.lineView.setBgColor(self.borderColor)
        self.circleView.setBgColor(UIColor.darkGray)
        self.circleView.setText(text: "").isHidden = true
        
        self.addSubview(self.lineView)
        self.addSubview(self.circleView)
        self.addSubview(self.pinLabel)
     
        
        self.lineView.setWidthAnchor(constant: TTSize.P_CONS_DEF).setHeightAnchor(constant: TTSize.H_LINEVIEW)
            .setFullCenterAnchor(constant: 0)
        
        self.circleView.setWidthAnchor(constant: 8.0).setHeightAnchor(constant: 8.0).setFullCenterAnchor(constant: 0)
        
        
        self.pinLabel.setFullCenterAnchor(constant: 0)
            
    }
}

