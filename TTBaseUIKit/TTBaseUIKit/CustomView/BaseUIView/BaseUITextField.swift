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
    fileprivate var lineColor:UIColor = TTBaseUIKitConfig.getViewConfig().lineColor
    
    
    public enum TYPE {
        case DEFAULT
        case NO_BORDER
        case NO_PADING
        case ONLY_BOTTOM
    }
    
    public var onTextEditChangedHandler:((_ textField:TTBaseUITextField,_ textString:String) -> Void)?
    
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
        UIApplication.topViewController()?.dismissKeyboard()
    }
}

// For base Function
extension TTBaseUITextField {
    
    func setHiddenKeyboardAccessoryView() -> TTBaseUITextField {
        let panelView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: TTBaseUIKitConfig.getSizeConfig().W, height: 30))
        panelView.backgroundColor = UIColor.clear
        
        let hiddenButton:UIButton = UIButton(frame: CGRect.init(x: TTBaseUIKitConfig.getSizeConfig().W - 40, y: 0, width: 35, height: 30))
        hiddenButton.addTarget(self, action: #selector(self.dismissKeyboard(_:)), for: .touchUpInside)
        hiddenButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        hiddenButton.backgroundColor = UIColor.white
        hiddenButton.tintColor = TTBaseUIKitConfig.getViewConfig().buttonBgDef
        hiddenButton.setImage(UIImage(fromTTBaseUIKit: "img.hideKeyboard")?.withRenderingMode(.alwaysTemplate), for: .normal)
        hiddenButton.layer.cornerRadius    = 4
        hiddenButton.clipsToBounds = false
        
        panelView.addSubview(hiddenButton)
        
        self.inputAccessoryView = panelView
        return self
    }
    
    public func setKeyboardStyleByText() -> TTBaseUITextField {
        self.setKeyBoardStyle(type: .default)
        return self
    }
    
    public func setKeyboardStyleByNumber() -> TTBaseUITextField  {
        self.setKeyBoardStyle(type: .numberPad)
        return self
    }
    
    public func setKeyboardStyleByEmail()  -> TTBaseUITextField  {
        self.setKeyBoardStyle(type: .emailAddress)
        return self
    }
    
    public func setKeyboardStyleByDate()  -> TTBaseUITextField {
        self.setKeyBoardStyle(type: .numbersAndPunctuation)
        return self
    }
    
    public func setKeyboardStyleByMoney()  -> TTBaseUITextField {
        self.setKeyBoardStyle(type: .decimalPad)
        return self
    }
    
    public func setKeyboardStyleByPhone()  -> TTBaseUITextField {
        self.setKeyBoardStyle(type: .numberPad)
        return self
    }
    
    public func setNoBorder() -> TTBaseUITextField {
        self.layer.borderWidth = 0
        self.borderStyle       = .none
        self.layer.borderColor = UIColor.clear.cgColor
        return self
    }
    
    public func setTextColor(color:UIColor) -> TTBaseUITextField {
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
