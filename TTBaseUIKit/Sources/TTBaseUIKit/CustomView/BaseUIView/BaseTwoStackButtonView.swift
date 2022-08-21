//
//  BaseTwoStackButtonView.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 9/16/20.
//  Copyright © 2020 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseTwoStackButtonView: TTBaseUIView {
    
    open var padding:UIEdgeInsets { get { return .init(top: TTSize.P_CONS_DEF, left:  TTSize.P_CONS_DEF, bottom:  TTSize.P_CONS_DEF, right:  TTSize.P_CONS_DEF)}}
    open var paddingButton:CGFloat { get { return TTSize.P_CONS_DEF } }
    
    public var stackView:TTBaseUIStackView = TTBaseUIStackView(axis: .horizontal, spacing: TTSize.P_CONS_DEF, alignment: .fill, distributionValue: .fillEqually)
    
    public let buttonLeft:TTBaseUIButton = TTBaseUIButton(textString: "Left Button", type: .WARRING, isSetSize: false)
    public let buttonRight:TTBaseUIButton = TTBaseUIButton(textString: "Right Button", type: .DEFAULT, isSetSize: false)
    
    public init(withPaddingButton padding:CGFloat = TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF) {
        self.stackView = TTBaseUIStackView(axis: .horizontal, spacing: padding, alignment: .fill, distributionValue: .fillEqually)
        super.init()
    }
    
    public convenience init(withTitle left:String, right:String) {
        self.init()
        self.buttonLeft.setText(text: left)
        self.buttonRight.setText(text: right)
    }
    
    required public init() {
        super.init()
        self.stackView = TTBaseUIStackView(axis: .horizontal, spacing: self.paddingButton, alignment: .fill, distributionValue: .fillEqually)
    }
    
    open override func updateBaseUIView() {
        super.updateBaseUIView()
        self.setupBaseUIView()
    }
    
    
    fileprivate func setupBaseUIView() {
        self.addSubview(self.stackView)
        
        self.stackView.addArrangedSubview(self.buttonLeft)
        self.stackView.addArrangedSubview(self.buttonRight)
        self.stackView.setHeightAnchor(constant: TTSize.H_BUTTON)
        self.stackView.setFullContraints(lead: padding.left, trail: padding.right, top: padding.top, bottom: padding.bottom)
    }
    
    
    public func setLeftButton(withTitle title:String, textColor:UIColor, bgColor:UIColor) {
        self.buttonLeft.setText(text: title).setTextColor(color: textColor).setBgColor(color: bgColor)
    }
    
    public func setRightButton(withTitle title:String, textColor:UIColor, bgColor:UIColor) {
        self.buttonRight.setText(text: title).setTextColor(color: textColor).setBgColor(color: bgColor)
    }
    
    public func setText(left:String, right:String) {
        self.buttonLeft.setText(text: left)
        self.buttonRight.setText(text: right)
        if right.isEmpty {
            self.buttonRight.isHidden = true
        } else {
            self.buttonRight.isHidden = false
        }
    }
}
