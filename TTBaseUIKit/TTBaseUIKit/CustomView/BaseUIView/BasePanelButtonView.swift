//
//  BasePanelButtonView.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 3/24/20.
//  Copyright © 2020 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBasePanelButtonView :TTBaseUIView {
    
    open var padding:CGFloat { get { return TTSize.P_CONS_DEF }}
    open var heightButton:CGFloat { get { return TTSize.H_BUTTON }}
    
    public var buttonView:TTBaseUIButton = TTBaseUIButton(textString: "BUTTON", type: .DEFAULT, isSetSize: false)

    open func updateBasePanelButtonView() { }
    
    public init(with text:String, textColor:UIColor, bgColor:UIColor) {
        super.init()
        self.buttonView.setText(text: text, textColor: textColor, bgColor: bgColor)
        self.setupBaseUIView()
        self.updateBasePanelButtonView()
    }
    
    public init(withBaseButton newButton:TTBaseUIButton) {
        super.init()
        self.buttonView = newButton
        self.setupBaseUIView()
        self.updateBasePanelButtonView()
    }

    
    required public init?(coder aDecoder: NSCoder) {
        super.init()
        self.setupBaseUIView()
        self.updateBasePanelButtonView()
    }
    
    required public init() {
        super.init()
        self.setupBaseUIView()
        self.updateBasePanelButtonView()
    }
    
    fileprivate func setupBaseUIView() {
        self.addSubview(self.buttonView)
        self.buttonView.setHeightAnchor(constant: self.heightButton)
            .setFullContraints(constant: self.padding)
    }
}
