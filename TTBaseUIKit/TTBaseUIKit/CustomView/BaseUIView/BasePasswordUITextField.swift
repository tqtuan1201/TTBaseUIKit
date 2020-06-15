//
//  TTBasePassWordUITextField.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 5/2/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBasePasswordUITextField:TTBaseUITextField {
    
    open var sizeIconRight:(CGFloat, CGFloat) { get { return (TTSize.H_ICON / 2, TTSize.H_ICON / 2) } }
    open var iconRightColor:UIColor { get { return TTView.iconRightTextFieldColor}}
    open var padingIcon:CGFloat { get { return 0}}
    
    public let panelIcon:TTBaseUIView = TTBaseUIView()
    public let eyeIconImageView:TTBaseUIImageFontView = TTBaseUIImageFontView.init(withFontIconLightSize: .eye,sizeIcon: CGSize(width: 30, height: 30), colorIcon: TTView.iconRightTextFieldColor)
    
    open override func updateUI() {
        super.updateUI()
        self.setupBaseUIView()
        self.setupTapHandle()
    }
    
    
}

extension TTBasePasswordUITextField {
    
    fileprivate func setupBaseUIView() {
        self.isSecureTextEntry = true
        self.panelIcon.translatesAutoresizingMaskIntoConstraints = true
        self.eyeIconImageView.translatesAutoresizingMaskIntoConstraints = true
        self.panelIcon.addSubview(self.eyeIconImageView)
        
        self.panelIcon.frame = CGRect.init(x: 0, y: 0, width: sizeIconRight.0 + padingIcon, height: sizeIconRight.1)
        self.eyeIconImageView.frame = CGRect.init(x: 0, y: 0, width: sizeIconRight.0, height: sizeIconRight.1)
        self.eyeIconImageView.tintColor = self.iconRightColor
        self.rightView = self.panelIcon
        self.rightViewMode = .always
        
        self.rightView?.translatesAutoresizingMaskIntoConstraints = true
        
    }
    
    fileprivate func setupTapHandle() {
        self.isUserInteractionEnabled = true
        self.panelIcon.isUserInteractionEnabled = true
        self.panelIcon.setTouchHandler().onTouchHandler = { [weak self ] imageView in guard let strongSelf = self else { return }
            if strongSelf.isSecureTextEntry {
                strongSelf.isSecureTextEntry = false
            } else {
                strongSelf.isSecureTextEntry = true
            }
        }
    }
}
