//
//  TwoButtomView.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 10/22/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTTwoButtomView: TTBaseUIView {
    
    open var paddingButton:CGFloat { get { return TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF }}
    
    public let buttonLeft:TTBaseUIButton = TTBaseUIButton(textString: "Left Button", type: .WARRING, isSetSize: false)
    public let buttonRight:TTBaseUIButton = TTBaseUIButton(textString: "Right Button", type: .DEFAULT, isSetSize: false)
    
    public convenience init(withTitle left:String, right:String) {
        self.init()
        self.buttonLeft.setText(text: left)
        self.buttonRight.setText(text: right)
    }
    
    open override func updateBaseUIView() {
        super.updateBaseUIView()
        self.setupBaseUIView()
    }
    
    
    fileprivate func setupBaseUIView() {
        
        self.addSubview(self.buttonLeft)
        self.addSubview(self.buttonRight)

        self.buttonLeft.setLeadingAnchor(constant: 0).setTrailingWithNextToView(view: self.buttonRight, constant: self.paddingButton)
            .setHeightAnchor(constant: TTSize.H_BUTTON)
            .setTopAnchor(constant: 0).setBottomAnchor(constant: 0)
            
        self.buttonRight.setTrailingAnchor(constant: 0)
            .setHeightAnchor(constant: TTSize.H_BUTTON)
            .setTopAnchor(constant: 0).setBottomAnchor(constant: 0)
            
        self.buttonLeft.widthAnchor.constraint(equalTo: self.buttonRight.widthAnchor, multiplier: 1).isActive = true
    }
    
}
