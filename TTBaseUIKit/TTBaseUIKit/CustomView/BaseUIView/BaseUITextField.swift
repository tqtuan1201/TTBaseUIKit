//
//  BaseUITextField.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/11/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseUITextField: UITextField   {
    
    fileprivate var textDefColor:UIColor = TTBaseUIKitConfig.getViewConfig().textDefColor
    fileprivate var textpading:CGFloat = 5.0
    fileprivate let lineHeight:CGFloat = 1.5
    fileprivate var lineColor:UIColor = TTBaseUIKitConfig.getViewConfig().lineDefColor
    
    
    public enum TYPE {
        case DEFAULT
        case NO_BORDER
        case NO_PADING
        case ONLY_BOTTOM
    }
    
    public var onTextEditChangedHandler:((_ textField:TTBaseUITextField,_ textString:String) -> Void)?
    public var onDismissKeyboard:(() -> Void)?
    public var onTouchIconHandler:((_ textField:TTBaseUITextField) -> Void)?
    
    open func updateUI() { }
    
    
    fileprivate var type:TYPE = .DEFAULT
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.updateUI()
    }
    
    public required  init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
        self.updateUI()
    }
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: self.textpading, dy: self.textpading)
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: self.textpading, dy: self.textpading)
    }
    
    public convenience init(withPlaceholder text:String, pading:CGFloat = 5, type:TYPE = .DEFAULT, isSetHiddenKeyboardAccessoryView:Bool = true) {
        self.init(frame: .zero)
        self.type = type
        self.textpading = pading
        self.placeholder = text
        if isSetHiddenKeyboardAccessoryView { self.setHiddenKeyboardAccessoryView().done()}
        switch type {
        case .DEFAULT:
            break
        case .NO_BORDER:
            self.setNoBorder().done()
            break
        case .ONLY_BOTTOM:
            self.borderStyle = .none
            break
        case .NO_PADING:
            self.textpading = 0
        break
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            if self.type == .ONLY_BOTTOM { self.addBorder(withRectEdge: .bottom, borderColor: self.lineColor, borderHeight: self.lineHeight) }
        }
    }
    
    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor  = UIColor.white
        self.textColor        = self.textDefColor
        self.font             = TTBaseUIKitConfig.getFontConfig().FONT
        self.borderStyle      = UITextField.BorderStyle.roundedRect
        self.addTarget(self, action: #selector(self.textEditChanged(_:)), for: .editingChanged)
    }
    
    fileprivate func setKeyBoardStyle(type:UIKeyboardType) {
        self.keyboardType = type
    }
    
    @objc fileprivate func dismissKeyboard(_ sennder: UIButton) {
        self.onDismissKeyboard?(); UIApplication.topViewController()?.dismissKeyboard()
    }
}

// For base Function
extension TTBaseUITextField {
    
    func setHiddenKeyboardAccessoryView() -> TTBaseUITextField {
        let panelView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: TTBaseUIKitConfig.getSizeConfig().W, height: 34))
        panelView.backgroundColor = TTView.viewBgAccessoryViewColor
        
        let hiddenButton:UIButton = UIButton(frame: CGRect.init(x: TTBaseUIKitConfig.getSizeConfig().W - 35, y: 2, width: 35, height: 32))
        hiddenButton.addTarget(self, action: #selector(self.dismissKeyboard(_:)), for: .touchUpInside)
        hiddenButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        hiddenButton.backgroundColor = UIColor.white
        hiddenButton.tintColor = TTBaseUIKitConfig.getViewConfig().buttonBgDef
        hiddenButton.setImage(UIImage(fromTTBaseUIKit: "img.hideKeyboard.png")?.withRenderingMode(.alwaysTemplate), for: .normal)
        hiddenButton.layer.cornerRadius    = 4
        hiddenButton.clipsToBounds = false
        
        panelView.addSubview(hiddenButton)
        
        self.inputAccessoryView = panelView

        return self
    }
    
    @discardableResult public func setKeyboardStyleByText() -> TTBaseUITextField {
        self.setKeyBoardStyle(type: .default)
        return self
    }
    
    @discardableResult public func setKeyboardStyleByNumber() -> TTBaseUITextField  {
        self.setKeyBoardStyle(type: .numberPad)
        return self
    }
    
    @discardableResult public func setKeyboardStyleByEmail()  -> TTBaseUITextField  {
        self.setKeyBoardStyle(type: .emailAddress)
        return self
    }
    
    @discardableResult public func setKeyboardStyleByDate()  -> TTBaseUITextField {
        self.setKeyBoardStyle(type: .numbersAndPunctuation)
        return self
    }
    
    @discardableResult public func setKeyboardStyleByMoney()  -> TTBaseUITextField {
        self.setKeyBoardStyle(type: .decimalPad)
        return self
    }
    
    @discardableResult public func setKeyboardStyleByPhone()  -> TTBaseUITextField {
        self.setKeyBoardStyle(type: .numberPad)
        return self
    }
    
    @discardableResult public func setNoBorder() -> TTBaseUITextField {
        self.layer.borderWidth = 0
        self.borderStyle       = .none
        self.layer.borderColor = UIColor.clear.cgColor
        return self
    }
    
    @discardableResult public func setTextColor(color:UIColor) -> TTBaseUITextField {
        self.textColor = color
        return self
    }
    
    public func setBgColor(_ color:UIColor) {
        self.backgroundColor = color
    }
    
    
    public func setText(text:String) {
        self.text = text
    }
    
    public func setPasswordView() {
        self.isSecureTextEntry = true
    }
    
    public func setIcon(icon:AwesomePro.Light, isRight:Bool, size:CGSize = CGSize.init(width: TTBaseUIKitConfig.getSizeConfig().H_ICON / 2, height:TTBaseUIKitConfig.getSizeConfig().H_ICON / 2), iconColor:UIColor = TTBaseUIKitConfig.getViewConfig().iconColor) {
        let panelIcon:UIView = UIView()
        let eyeIconImageView:TTBaseUIImageFontView = TTBaseUIImageFontView.init(withFontIconLightSize: icon,sizeIcon: CGSize(width: 30, height: 30), colorIcon: iconColor)
        
        eyeIconImageView.translatesAutoresizingMaskIntoConstraints = true
        panelIcon.addSubview(eyeIconImageView)
        
        panelIcon.frame = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        eyeIconImageView.frame = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        eyeIconImageView.tintColor = iconColor
        
        if isRight {
            self.rightView = panelIcon
            self.rightViewMode = .always
            self.rightView?.translatesAutoresizingMaskIntoConstraints = true
        } else {
            self.leftView = panelIcon
            self.leftViewMode = .always
            self.leftView?.translatesAutoresizingMaskIntoConstraints = true
        }
        eyeIconImageView.setActiveOnTouchHandle().onTouchHandler = { [weak self ] imageView in guard let strongSelf = self else { return }
            strongSelf.onTouchIconHandler?(strongSelf)
        }
    }
}

// For real time format text
extension TTBaseUITextField {
    
    @objc fileprivate func textEditChanged(_ sender:UITextField) {
        self.onTextEditChangedHandler?(self, String.get(sender.text))
    }
}

// MARK:// For format currency
extension TTBaseUITextField {
    
}
