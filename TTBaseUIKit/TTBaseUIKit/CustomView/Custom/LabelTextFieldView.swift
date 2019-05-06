//
//  LabelTextFieldView.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/14/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

///
/// This Class to view Default:
///
/// Title
///
/// TextField
///
/// UserName
/// Input:Admin
///
open class TTLabelTextFieldView : TTBaseUIView {
    
    
    open var paddingTopLine:CGFloat { get { return 2 } }
    open var padding:CGFloat { get { return TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF } }
    open var paddingTopView:CGFloat { get { return 4 } }
    open var heightTextField:CGFloat { get { return TTBaseUIKitConfig.getSizeConfig().H_TEXTFIELD } }
    open var heightLine:CGFloat { get { return TTBaseUIKitConfig.getSizeConfig().H_LINEVIEW } }
    
    open var sizeIconRight:(CGFloat, CGFloat) { get { return (TTSize.H_ICON / 2, TTSize.H_ICON / 2) } }
    open var iconRight:UIImage? { get { return UIImage.init(fromTTBaseUIKit: "img.icon.down.png") } }
    open var iconRightColor:UIColor { get { return TTView.iconRightTextFieldColor}}
    
    fileprivate var isPasswordTextField:Bool  = false
    
    public let iconRightImageView:TTBaseUIImageView = TTBaseUIImageView()

    public let titleLabel:TTBaseUILabel = TTBaseUILabel()
    public var inputTextField:TTBaseUITextField = TTBaseUITextField(withPlaceholder: "Please input text", type: .NO_PADING)
    public let lineView:TTLineView = TTLineView()
    
    public convenience init(withSetPasswordTextField isSet:Bool) {
        self.init()
        self.isPasswordTextField = isSet
        self.setupBaseUIView()
    }
    
    open override func updateBaseUIView() {
        super.updateBaseUIView()
        self.setupBaseUIView()
    }
    
    fileprivate func setupBaseUIView() {
        if isPasswordTextField { self.inputTextField = TTBasePasswordUITextField(withPlaceholder: "Please input text", type: .NO_PADING)}
        self.setupViewCodable(with: [titleLabel, inputTextField, lineView] )
        if self.iconRight != nil && !isPasswordTextField {
            self.iconRightImageView.image = self.iconRight
            self.inputTextField.rightView = self.iconRightImageView
            self.inputTextField.rightViewMode = .always
            self.iconRightImageView.tintColor = self.iconRightColor
            self.iconRightImageView.frame = CGRect.init(x: 0, y: 0, width: sizeIconRight.0, height: sizeIconRight.1)
            self.inputTextField.rightView?.translatesAutoresizingMaskIntoConstraints = true
        }
    }
    
}

extension TTLabelTextFieldView : TTViewCodable {
    
    public func setupConstraints() {
        self.titleLabel.setVerticalContentHuggingPriority().setLeadingAnchor(constant: self.padding).setTopAnchor(constant: self.padding).setTrailingAnchor(constant: self.padding).done()
        
        self.inputTextField.setLeadingAnchor(constant: self.padding).setTopAnchorWithAboveView(nextToView: self.titleLabel, constant: self.paddingTopView).setTrailingAnchor(constant: self.padding).setHeightAnchor(constant: self.heightTextField).done()
        
        self.lineView.setLeadingAnchor(constant: self.padding).setTopAnchorWithAboveView(nextToView: self.inputTextField, constant: self.paddingTopLine)
                     .setTrailingAnchor(constant: self.padding).setHeightAnchor(constant: self.heightLine).setBottomAnchor(constant: self.padding).done()
        
    }
    
    public func setupStyles() {
        self.titleLabel.setText(text: "Title text").setAlign(align: .left).done()
        self.inputTextField.setNoBorder().done()
    }
}

extension TTLabelTextFieldView {
    
    public func setTextForInputTextField(textString:String) {
        self.inputTextField.text = textString
    }
    
    public func setText(withTitle title:String, textPlaceHolder:String) -> TTLabelTextFieldView {
        self.titleLabel.setText(text: title).done()
        self.inputTextField.placeholder = textPlaceHolder
        return self
    }
    
    public func setColor(withTitleColor titleColor:UIColor, textFieldColor:UIColor) -> TTLabelTextFieldView {
        self.titleLabel.setTextColor(color: titleColor).done()
        self.inputTextField.setTextColor(color: textFieldColor).done()
        return self
    }
    
    public func setColor(withBgColor title:UIColor, textField:UIColor) -> TTLabelTextFieldView {
        self.titleLabel.setBgColor(title)
        self.inputTextField.setBgColor(title)
        return self
    }
}
