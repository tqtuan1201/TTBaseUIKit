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
    fileprivate var textpading = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)

    fileprivate let lineHeight:CGFloat = 1.5
    fileprivate var lineColor:UIColor = TTBaseUIKitConfig.getViewConfig().lineDefColor
    fileprivate var isActiveFillEmail:Bool = false
    
    fileprivate var isInputText:Bool = true
    fileprivate var isForceUpperCase:Bool = false
    fileprivate var isAutoFieldEmail:Bool = false
    fileprivate var isRemoveDiacritics:Bool = false
    
    public enum TYPE {
        case DEFAULT
        case NO_BORDER
        case NO_PADING
        case ONLY_BOTTOM
    }
    
    public var iconImageView:TTBaseUIImageFontView? = nil
    
    public var onTextEditChangedHandler:((_ textField:TTBaseUITextField,_ textString:String) -> Void)?
    public var onDismissKeyboard:(() -> Void)?
    public var onTouchIconHandler:((_ textField:TTBaseUITextField) -> Void)?
    
    open var paddingIcon:CGFloat { get { return TTSize.P_CONS_DEF }}
    open func updateUI() { }
    
    public var onTouchHandler:((_ textField:TTBaseUITextField) -> Void)?
    public var onTouchReturnKeyHandler:((_ textField:TTBaseUITextField,_ type:UIReturnKeyType) -> Void)?
    
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
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: self.textpading)
    }

    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: self.textpading)
    }
    
    public convenience init(withPlaceholder text:String, pading:CGFloat = 5.0, type:TYPE = .DEFAULT, isSetHiddenKeyboardAccessoryView:Bool = true, returnKeyType:UIReturnKeyType = .default, isSetHeight:Bool = false) {
        self.init(frame: .zero)
        self.returnKeyType = returnKeyType
        self.type = type
        self.textpading = UIEdgeInsets.init(top: pading, left: pading, bottom: pading, right: pading)
        self.placeholder = text
        if isSetHiddenKeyboardAccessoryView { self.setHiddenKeyboardAccessoryView().done()}
        if isSetHeight { self.setHeightAnchor(constant: TTSize.H_TEXTFIELD)}
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
            self.textpading = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        break
        }
    }
    
    public convenience init(withPlaceholder text:String, textPadding:UIEdgeInsets, type:TYPE = .DEFAULT, isSetHiddenKeyboardAccessoryView:Bool = true, returnKeyType:UIReturnKeyType = .default, isSetHeight:Bool = false) {
        self.init(frame: .zero)
        self.returnKeyType = returnKeyType
        self.type = type
        self.textpading = textPadding
        self.placeholder = text
        if isSetHiddenKeyboardAccessoryView { self.setHiddenKeyboardAccessoryView().done()}
        if isSetHeight { self.setHeightAnchor(constant: TTSize.H_TEXTFIELD)}
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
            self.textpading = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
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
        self.delegate = self
    }
    
    fileprivate func setKeyBoardStyle(type:UIKeyboardType) {
        self.keyboardType = type
    }
    
    
    fileprivate func onDisMissKeyboardHandle() {
        self.onDismissKeyboard?()
        DispatchQueue.main.async {
            UIApplication.topViewController()?.dismissKeyboard()
            self.findViewController()?.dismissKeyboard()
        }
    }
    
    @objc fileprivate func dismissKeyboard(_ sennder: UIButton) {
        self.onDisMissKeyboardHandle()
    }
    
    
    @objc private func onTouchPanelView(_ sender:UITapGestureRecognizer) {
        self.onDisMissKeyboardHandle()
    }
    
    @discardableResult public func setTouchHandler() -> TTBaseUITextField {
        self.isInputText = false
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onTouchView(_:))))
        return self
    }
    
    @objc private func onTouchView(_ sender:UITapGestureRecognizer) {
        self.onTouchHandler?(self)
    }
}

// For base Function
extension TTBaseUITextField {
    
    @discardableResult public func setHiddenKeyboardAccessoryView() -> TTBaseUITextField {
        let panelView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: TTBaseUIKitConfig.getSizeConfig().W, height: 34))
        panelView.backgroundColor = TTView.viewBgAccessoryViewColor
        panelView.isUserInteractionEnabled = true
        panelView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onTouchPanelView(_:))))
        
        //Icon
        if TTBaseUIKitConfig.getStyleConfig().dismissKeyboardType == .ICON {
            let hiddenButton:UIButton = UIButton(frame: CGRect.init(x: TTBaseUIKitConfig.getSizeConfig().W - 35, y: 2, width: 35, height: 32))
            hiddenButton.addTarget(self, action: #selector(self.dismissKeyboard(_:)), for: .touchUpInside)
            hiddenButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
            hiddenButton.backgroundColor = UIColor.white
            hiddenButton.tintColor = TTBaseUIKitConfig.getViewConfig().buttonBgDef
            hiddenButton.layer.cornerRadius    = 4
            hiddenButton.clipsToBounds = false
            if let defImage = UIImage(fromTTBaseUIKit: "img.hideKeyboard.png") {
                hiddenButton.setImage(defImage.withRenderingMode(.alwaysTemplate), for: .normal)
            } else {
                hiddenButton.tintColor = UIColor.white
                hiddenButton.setTitleColor(TTBaseUIKitConfig.getViewConfig().buttonBgDef, for: UIControl.State.normal)
                hiddenButton.setTitle("TTBaseUIkit.Text.HiddenKeyboard".localize(withBundle: Bundle.main), for: .normal)
            }
            panelView.addSubview(hiddenButton)
        //Icon text
        } else if TTBaseUIKitConfig.getStyleConfig().dismissKeyboardType == .ICON_TEXT {
            let wPanel:CGFloat = TTBaseUIKitConfig.getSizeConfig().W_ICONTEXT_DISSMISS_KEYBOARD
            let panelButtonView:UIView = UIView(frame: .init(x: TTBaseUIKitConfig.getSizeConfig().W - wPanel - 2, y: 2, width: wPanel, height: 30))
            panelButtonView.backgroundColor = TTBaseUIKitConfig.getViewConfig().viewBgDissmissKeyboardColor
            panelButtonView.setConerDef()
            let iconView:UIImageView = UIImageView.init(frame: CGRect.init(x: 8, y: 5, width: 20, height: 20))
            iconView.image = UIImage(fromTTBaseUIKit: "img.hideKeyboard.png")
            iconView.contentMode = .scaleAspectFit
            iconView.image =  iconView.image?.tinted(with: TTBaseUIKitConfig.getViewConfig().buttonBgDef)
            let text:UILabel = UILabel(frame: .init(x: 35, y: 5, width: wPanel - 40, height: 20))
            text.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            text.textAlignment = .center
            text.text = "TTBaseUIkit.Text.HiddenKeyboard".localize(withBundle: Bundle.main)
            text.textColor = TTBaseUIKitConfig.getViewConfig().buttonBgDef
            
            panelButtonView.addSubview(iconView)
            panelButtonView.addSubview(text)
           
            panelView.addSubview(panelButtonView)
        //Text
        } else {
            let hiddenButton:UIButton = UIButton(frame: CGRect.init(x: TTBaseUIKitConfig.getSizeConfig().W - 100, y: 2, width: 100, height: 32))
            hiddenButton.addTarget(self, action: #selector(self.dismissKeyboard(_:)), for: .touchUpInside)
            hiddenButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF)
            hiddenButton.backgroundColor = UIColor.white
            hiddenButton.setTitleColor(TTBaseUIKitConfig.getViewConfig().buttonBgDef, for: UIControl.State.normal)
            hiddenButton.setTitle("TTBaseUIkit.Text.HiddenKeyboard".localize(withBundle: Bundle.main), for: .normal)
            hiddenButton.contentHorizontalAlignment = .right
            hiddenButton.layer.cornerRadius    = 4
            hiddenButton.clipsToBounds = false
            
            panelView.addSubview(hiddenButton)
        }
        
        self.inputAccessoryView = panelView

        return self
    }

    @discardableResult public func setAutoFillEmail() -> TTBaseUITextField {
        self.isAutoFieldEmail = true
        return self
    }
    
    @discardableResult public func setRemoveDiacritics() -> TTBaseUITextField {
        self.isRemoveDiacritics = true
        return self
    }
    
    @discardableResult public func setForceInputUpperCase() -> TTBaseUITextField {
        self.isForceUpperCase = true
        self.autocapitalizationType = .allCharacters
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
        self.iconImageView = TTBaseUIImageFontView.init(withFontIconLightSize: icon,sizeIcon: CGSize(width: 30, height: 30), colorIcon: iconColor)
        
        self.iconImageView!.translatesAutoresizingMaskIntoConstraints = true
        panelIcon.addSubview(self.iconImageView!)
        
        panelIcon.frame = CGRect.init(x: 0, y: 0, width: size.width + self.paddingIcon, height: size.height)
        if isRight {
            self.iconImageView!.frame = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        } else {
            self.iconImageView!.frame = CGRect.init(x: self.paddingIcon, y: 0, width: size.width, height: size.height)
        }
        self.iconImageView!.tintColor = iconColor
        
        if isRight {
            self.rightView = panelIcon
            self.rightViewMode = .always
            self.rightView?.translatesAutoresizingMaskIntoConstraints = true
        } else {
            self.leftView = panelIcon
            self.leftViewMode = .always
            self.leftView?.translatesAutoresizingMaskIntoConstraints = true
        }
        self.iconImageView!.setActiveOnTouchHandle().onTouchHandler = { [weak self ] imageView in guard let strongSelf = self else { return }
            strongSelf.onTouchIconHandler?(strongSelf)
        }
    }
}

// For real time format text
extension TTBaseUITextField : UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         // your Action According to your textfield
        self.onTouchReturnKeyHandler?(self, textField.returnKeyType)
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if self.isForceUpperCase {
            let firstLowercaseCharRange = string.rangeOfCharacter(from: NSCharacterSet.lowercaseLetters)
            if let _ = firstLowercaseCharRange {
                if let text = textField.text, text.isEmpty {
                    textField.text = string.uppercased()
                    TTBaseFunc.shared.printLog(object: "self.onTextEditChangedHandler | isForceUpperCase \(String.get(textField.text))")
                    self.onTextEditChangedHandler?(self, String.get(textField.text))
                }
                else {
                    let beginning = textField.beginningOfDocument
                    if let start = textField.position(from: beginning, offset: range.location),
                        let end = textField.position(from: start, offset: range.length),
                        let replaceRange = textField.textRange(from: start, to: end) {
                        textField.replace(replaceRange, withText: string.uppercased())
                    }
                }
                return false
            }
        }
        return self.isInputText
    }
    
    @objc fileprivate func textEditChanged(_ sender:UITextField) {
        
        if self.isRemoveDiacritics { sender.text = String.get(sender.text).removeDiacritics() }
        
        if self.isAutoFieldEmail {
            self.emailEditingChanged(sender)
            self.onTextEditChangedHandler?(self, String.get(sender.text))
            TTBaseFunc.shared.printLog(object: "self.onTextEditChangedHandler | isAutoFieldEmail: \(String.get(sender.text))")
        } else {
            TTBaseFunc.shared.printLog(object: "self.onTextEditChangedHandler \(String.get(sender.text))")
            self.onTextEditChangedHandler?(self, String.get(sender.text))
        }
    }
}

// MARK:// For auto fill email
extension TTBaseUITextField {
    
}


// MARK:// For format currency
extension TTBaseUITextField {
    
    fileprivate func emailEditingChanged(_ sender:UITextField) {
        sender.text = sender.text?.replace(" ", dataReplace: "")
        var emailString = sender.text ?? ""
        let preCharate:Int = emailString.subStringFromIndex("@").count
        
        if emailString.contains("@") &&  preCharate == 3 && isActiveFillEmail {
            for domain in TTBaseUtil.domainEmailList() {
                let preDomainString = "@" + domain[..<domain.index(domain.startIndex, offsetBy: 2)] //.substring(to: domain.index(domain.startIndex, offsetBy: 2))
                if emailString.contains(preDomainString) {
                    sender.text         = emailString.replace(preDomainString, dataReplace: "@" + domain)
                    self.isActiveFillEmail   = false
                    UIApplication.topViewController()?.dismissKeyboard()
                    break
                }
            }
        }
        let preAfterCharate:Int = sender.text?.subStringFromIndex("@").count ?? 0
        if preAfterCharate < 3 {isActiveFillEmail   = true }
    }
    
}
