//
//  IconLabelTextFieldView.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/29/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

///
/// This Class to create Icon with LabelTextFieldView View
///
/// Base on Icon-LabelTextFieldView element
///
///  panel(iconRight-[(Lable-TextField)])
///
open class TTIconLabelTextFieldView : TTBaseUIView {
    
    open var panelConer:CGFloat =  TTSize.CORNER_RADIUS
    open var paddingLeftImage:CGFloat = TTSize.P_CONS_DEF
    
    open var iconColor:UIColor { get { return TTView.iconColor }}
    open var sizeImages:(CGFloat,CGFloat) { get { return (TTSize.H_ICON_CELL,TTSize.H_ICON_CELL)}}
    open var cornerImages:CGFloat { get { return TTSize.CORNER_RADIUS }}
    
    open var paddingTextField:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (0,0,0,0)}}
    
    public var iconLeftImageView:TTBaseUIImageFontView = TTBaseUIImageFontView(withFontIconLightSize: .analytics)
    
    public var labelTextField:TTLabelTextFieldView = TTLabelTextFieldView()
    
    fileprivate var paddingIconLeftImage:CGFloat = TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF

    required public init() {
        super.init()
        self.setConerRadius(with: panelConer)
        self.setupBaseUIView()
        self.setupBaseConstraints()
    }
    
    required public init(withConner coner:CGFloat = TTBaseUIKitConfig.getSizeConfig().CORNER_RADIUS, paddingContentImage:CGFloat = TTBaseUIKitConfig.getSizeConfig().CORNER_RADIUS) {
        super.init()
        self.paddingIconLeftImage = paddingContentImage
        self.setConerRadius(with: coner)
        self.setupBaseUIView()
        self.setupBaseConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setConerRadius(with: panelConer)
        self.setupBaseUIView()
        self.setupBaseConstraints()
    }
    
    fileprivate func setupBaseUIView() {
        self.iconLeftImageView.paddingContentImage = self.paddingIconLeftImage
        self.iconLeftImageView.setIconColor(self.iconColor).done()
        self.addSubview(iconLeftImageView)
        self.addSubview(labelTextField)
    }
    
    fileprivate func setupBaseConstraints() {
        self.iconLeftImageView.setLeadingAnchor(constant: paddingLeftImage).setHeightAnchor(constant: self.sizeImages.0).setWidthAnchor(constant: self.sizeImages.1)
            .setTrailingWithNextToView(view: self.labelTextField, constant: self.paddingTextField.0).setcenterYAnchor(constant: 0).done()
        
        self.labelTextField.setTopAnchor(constant: self.paddingTextField.1).setBottomAnchor(constant: self.paddingTextField.3).setTrailingAnchor(constant: self.paddingTextField.2).done()
    }
}

extension TTIconLabelTextFieldView {
    
    public func setText(withTitle title:String, textPlaceHolder:String, icon:AwesomePro.Light) -> TTIconLabelTextFieldView {
        self.labelTextField.titleLabel.setText(text: title).done()
        self.labelTextField.inputTextField.placeholder = textPlaceHolder
        self.iconLeftImageView.setIConImage(with: icon.rawValue, color: self.iconColor).done()
        return self
    }
    
    public func setText(withTitle title:String, textPlaceHolder:String, iconName:String) -> TTIconLabelTextFieldView {
        self.labelTextField.titleLabel.setText(text: title).done()
        self.labelTextField.inputTextField.placeholder = textPlaceHolder
        self.iconLeftImageView.setIConImage(with: iconName, color: self.iconColor).done()
        return self
    }
    
    public func setColor(_ color:UIColor) -> TTIconLabelTextFieldView {
        self.iconLeftImageView.setIconColor(color).done()
        self.labelTextField.titleLabel.setTextColor(color: color).done()
        self.labelTextField.inputTextField.setTextColor(color: color).done()
        return self
    }
    
    public func onTouchHandle( complete:@escaping (() -> ()) ) {
        self.labelTextField.isUserInteractionEnabled = false
        self.iconLeftImageView.isUserInteractionEnabled = false
        self.setTouchHandler().onTouchHandler = { view in
            complete()
        }
    }
    
    
}
