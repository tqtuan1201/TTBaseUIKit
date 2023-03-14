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
    open var padingIcon:CGFloat { get { return 0}}
    
    open var sizeIconRight:(CGFloat, CGFloat) { get { return (TTSize.H_ICON / 2, TTSize.H_ICON / 2) } }
    open var iconRightColor:UIColor { get { return TTView.iconRightTextFieldColor}}
    open var isAnimationLine:Bool { get { return true}}

    public let titleLabel:TTBaseUILabel = TTBaseUILabel()
    public var inputTextField:TTBaseUITextField = TTBaseUITextField(withPlaceholder: "Please input text", type: .NO_PADING, isSetHiddenKeyboardAccessoryView: true)
    public let lineView:TTLineView = TTLineView()

    fileprivate var isPasswordTextField:Bool  = false
    
    public var onTouchRightImageHandler:(() -> Void)?
    public let panelIcon:UIView = UIView()
    public var rightIconImageView:TTBaseUIImageFontView?
    
    public convenience init(withSetPasswordTextField isSet:Bool) {
        self.init()
        self.isPasswordTextField = isSet
        self.setupBaseUIView()
    }
    
    public convenience init(withShowImageRight nameIcon:AwesomePro.Light) {
        self.init()
        self.rightIconImageView = TTBaseUIImageFontView.init(withFontIconLightSize: nameIcon, sizeIcon: CGSize(width: 30, height: 30), colorIcon: self.iconRightColor)
        self.setupBaseUIView()
        self.setupRightImageView()
    }
    
    open override func updateBaseUIView() {
        super.updateBaseUIView()
        self.setupBaseUIView()
    }
    
    fileprivate func setupBaseUIView() {
        if self.isPasswordTextField { self.inputTextField = TTBasePasswordUITextField(withPlaceholder: "Please input text", type: .NO_PADING)}
        if self.isAnimationLine {self.lineView.setDefaultColor() }
        self.setupViewCodable(with: [titleLabel, inputTextField, lineView] )
    }
    
    fileprivate func setupRightImageView() {
        
        if let rightIconView = self.rightIconImageView {
            rightIconView.translatesAutoresizingMaskIntoConstraints = true
            self.panelIcon.addSubview(rightIconView)
            
            self.panelIcon.frame = CGRect.init(x: 0, y: 0, width: sizeIconRight.0 + padingIcon, height: sizeIconRight.1)
            rightIconView.frame = CGRect.init(x: 0, y: 0, width: sizeIconRight.0, height: sizeIconRight.1)
            rightIconView.tintColor = self.iconRightColor
            self.inputTextField.rightView = self.panelIcon
            self.inputTextField.rightViewMode = .always
            
            self.inputTextField.rightView?.translatesAutoresizingMaskIntoConstraints = true
            
            rightIconView.setActiveOnTouchHandle().onTouchHandler = { [weak self ] imageView in guard let strongSelf = self else { return }
                strongSelf.onTouchRightImageHandler?()
            }
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
    
    public func bindComponents() {
        if self.isAnimationLine {
            self.inputTextField.addTarget(self, action: #selector(self.editingDidBeginTextField(_:)), for: UIControl.Event.editingDidBegin)
            self.inputTextField.addTarget(self, action: #selector(self.editingDidEndTextField(_:)), for: UIControl.Event.editingDidEnd)
        }
    }
    
    @objc private func editingDidBeginTextField(_ textField:UITextField) {
        self.lineView.setActiveLineColor()
    }
    
    @objc private func editingDidEndTextField(_ textField:UITextField) {
        self.lineView.setDefaultColor()
    }
}

extension TTLabelTextFieldView {
    
    public func setRightView(withShowImageRight nameIcon:AwesomePro.Light) {
        self.rightIconImageView = TTBaseUIImageFontView.init(withFontIconLightSize: nameIcon, sizeIcon: CGSize(width: 30, height: 30), colorIcon: self.iconRightColor)
        self.setupRightImageView()
    }
    
    public func setTextForInputTextField(textString:String) {
        self.inputTextField.text = textString
    }
    
    @discardableResult public func setText(withTitle title:String, textPlaceHolder:String) -> TTLabelTextFieldView {
        self.titleLabel.setText(text: title).done()
        self.inputTextField.placeholder = textPlaceHolder
        return self
    }
    
    @discardableResult public func setColor(withTitleColor titleColor:UIColor, textFieldColor:UIColor) -> TTLabelTextFieldView {
        self.titleLabel.setTextColor(color: titleColor).done()
        self.inputTextField.setTextColor(color: textFieldColor).done()
        return self
    }
    
    @discardableResult public func setColor(withBgColor title:UIColor, textField:UIColor) -> TTLabelTextFieldView {
        self.titleLabel.setBgColor(title)
        self.inputTextField.setBgColor(title)
        return self
    }
    
    public func onTouchHandle( complete:@escaping (() -> ()) ) {
        self.titleLabel.isUserInteractionEnabled = false
        self.inputTextField.isUserInteractionEnabled = false
        self.setTouchHandler().onTouchHandler = { view in
            complete()
        }
    }
}
