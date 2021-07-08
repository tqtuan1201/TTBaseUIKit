//
//  BaseLableWithButtonView.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 7/8/21.
//  Copyright © 2021 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseLableWithButtonView : TTBaseUIView {
    
    open var buttonColor:UIColor { get { return TTBaseUIKitConfig.getViewConfig().buttonBgDef }}
    open var textColor:UIColor { get { return TTBaseUIKitConfig.getViewConfig().textDefColor }}
    open var viewBgColor:UIColor { get { return TTBaseUIKitConfig.getViewConfig().viewBgColor }}
    open var padding:CGFloat { get { return TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF }}
    open var buttonHeight:CGFloat { get { return TTBaseUIKitConfig.getSizeConfig().H_BUTTON }}
    
    public let stackView:TTBaseUIStackView = TTBaseUIStackView(axis: .vertical, spacing: TTSize.P_CONS_DEF, alignment: .fill, distributionValue: .fill)
    public let titleLabel:TTBaseUILabel = TTBaseUILabel(withType: .TITLE, text: "Title for description", align: .center)
    public let buttonView:TTBaseUIButton = TTBaseUIButton(textString: "Button view", type: .DEFAULT, isSetSize: false)

    public init(withButton button:String, label:String) {
        self.titleLabel.setText(text: label)
        self.buttonView.setText(text: button)
        super.init()
        self.setupViewCodable(with: [self.stackView])
    }
    
    public required init() {
        super.init()
        self.setupViewCodable(with: [self.stackView])
    }
    
}

extension TTBaseLableWithButtonView :TTViewCodable {
    
    public func setText(withTitle text:String) {
        self.titleLabel.isHidden = text.isEmpty
        self.titleLabel.setText(text: text)
    }
    
    public func setupStyles() {
        self.titleLabel.setMutilLine(numberOfLine: 0, textAlignment: .center, mode: .byTruncatingTail)
        if self.titleLabel.text == "" {self.titleLabel.isHidden = true }
        
        self.buttonView.setBgColor(color: self.buttonColor)
        self.setBgColor(self.viewBgColor)
        self.titleLabel.setTextColor(color: self.textColor)
    }
    
    public func setupCustomView() {
        self.stackView.addArrangedSubview(self.titleLabel)
        self.stackView.addArrangedSubview(self.buttonView)
    }
    
    public func setupConstraints() {
        self.titleLabel.setVerticalContentHuggingPriority(priority: .required)
        self.buttonView.setHeightAnchor(constant: self.buttonHeight)
        self.stackView.setFullContraints(constant: self.padding)
    }
    
}
