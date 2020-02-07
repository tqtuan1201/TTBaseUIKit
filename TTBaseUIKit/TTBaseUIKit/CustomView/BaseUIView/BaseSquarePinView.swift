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

    open var borderColor:UIColor { get { return TTBaseUIKitConfig.getViewConfig().viewBgCellColor }}
    
    open var borderWidth:CGFloat { get { return TTBaseUIKitConfig.getSizeConfig().H_LINEVIEW }}

    public lazy var lineView:TTLineView = TTLineView()
    public lazy var pinLabel:TTBaseUILabel = TTBaseUILabel(withType: .HEADER, text: "", align: .center)
    
    
    open override func updateBaseUIView() {
        self.setupBaseUIView()
    }
    
    public func setText(text:String) {
        self.pinLabel.setText(text: text)
        self.pinLabel.isHidden = false
        self.lineView.isHidden = true
        self.setBorder(with: self.borderWidth, color: TTView.buttonBgDef, coner: TTSize.CORNER_RADIUS)
    }

    public func setLine() {
        self.pinLabel.setText(text: "")
        self.pinLabel.isHidden = true
        self.lineView.isHidden = false
        self.setBorder(with: self.borderWidth, color: TTView.lineDefColor, coner: TTSize.CORNER_RADIUS)
    }
    
    public func setShow() {
        self.lineView.isHidden = true
        self.pinLabel.isHidden = false
    }
    
    public func setHidden(withLineColor color:UIColor) {
        self.lineView.setBgColor(color)
        self.lineView.isHidden = false
        self.pinLabel.isHidden = true
    }
    
}

//MARK:// For base funcs

extension TTBaseSquarePinView {
    
    fileprivate func setupBaseUIView() {

        self.setBorder(with: self.borderWidth, color: TTView.lineDefColor, coner: TTSize.CORNER_RADIUS)
        
        self.addSubview(self.lineView)
        self.addSubview(self.pinLabel)
     
        
        self.lineView.setWidthAnchor(constant: TTSize.P_CONS_DEF).setHeightAnchor(constant: TTSize.H_LINEVIEW)
            .setFullCenterAnchor(constant: 0)
        
        self.pinLabel.setFullCenterAnchor(constant: 0)
            
    }
}

