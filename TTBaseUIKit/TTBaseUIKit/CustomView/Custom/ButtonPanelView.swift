//
//  File.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/29/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

///
/// This Class to create Panel View with button
///
/// Panel view content button view
///
/// PanelView( -Button- )
///
open class TTButtonPanelView :TTBaseUIView {
    
    public enum TYPE {
        case DEFAULT
        case PADDING
    }
    
    open var padding:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (TTSize.P_CONS_DEF * 2, TTSize.P_CONS_DEF,TTSize.P_CONS_DEF * 2,TTSize.P_CONS_DEF )}}
    
    public var baseButton:TTBaseUIButton = TTBaseUIButton(textString: "BUTTON", type: .DEFAULT,  isSetSize: true)
    
    fileprivate var type:TYPE = .DEFAULT
    fileprivate var typeButtom:TTBaseUIButton.TYPE = .DEFAULT
    fileprivate var textButtomString:String = "BUTTON"
    open func updateButtonPanelView() { }
    
    public convenience init(with type:TYPE, typeButtom:TTBaseUIButton.TYPE = .DEFAULT, text:String, bgColor:UIColor = TTBaseUIKitConfig.getViewConfig().viewPanelWithButtomColor) {
        self.init()
        self.type = type
        self.typeButtom = typeButtom
        self.textButtomString = text
        self.backgroundColor = bgColor
        self.baseButton.setText(text: text).done()
        self.setupBaseUIView()
        self.updateButtonPanelView()
    }
    
    
}

extension TTButtonPanelView  {
    
    fileprivate func setupBaseUIView() {
        if self.type == .DEFAULT {
            self.baseButton = TTBaseUIButton(textString: self.textButtomString, type: self.typeButtom,  isSetSize: true)
            self.addSubview(self.baseButton)
            self.baseButton.setTopAnchor(constant: padding.1).setBottomAnchor(constant: padding.3).setCenterXAnchor(constant: 0).done()
        } else {
            
            self.baseButton = TTBaseUIButton(textString: self.textButtomString, type: self.typeButtom,  isSetSize: false)
            self.addSubview(self.baseButton)
            
            let lead = self.baseButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.padding.0)
            lead.priority = UILayoutPriority.defaultHigh
            lead.isActive = true
            
            let trail = self.baseButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.padding.2)
            trail.priority = UILayoutPriority.defaultHigh
            trail.isActive = true
            
            self.baseButton.topAnchor.constraint(equalTo: self.topAnchor, constant: self.padding.1).isActive = true
            self.baseButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self.padding.3).isActive = true
        }
    }
}
