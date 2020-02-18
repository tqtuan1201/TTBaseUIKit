//
//  BaseUITextView.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 9/4/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseUITextView: UITextView   {
    
    fileprivate var textDefColor:UIColor = TTBaseUIKitConfig.getViewConfig().textDefColor
    fileprivate var textpading:CGFloat = 5.0
    fileprivate let lineHeight:CGFloat = 1.5
    fileprivate var lineColor:UIColor = TTBaseUIKitConfig.getViewConfig().lineDefColor
    fileprivate var isSetHiddenKeyboardAccessoryView:Bool = true
    
    open var paddingTextUIEdgeInsets:UIEdgeInsets { get { return UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)} }
    
    public enum TYPE {
        case DEFAULT
        case NO_BORDER
    }
    
    public var onTextEditChangedHandler:((_ textView:TTBaseUITextView,_ textString:String) -> Void)?
    public var onDismissKeyboard:(() -> Void)?
    public var onTouchIconHandler:((_ textView:TTBaseUITextView) -> Void)?
    
    open func updateUI() { }
    
    
    fileprivate var type:TYPE = .DEFAULT
    
    public init(with type:TYPE = .DEFAULT, isSetHiddenKeyboardAccessoryView:Bool = true) {
        self.type = type
        self.isSetHiddenKeyboardAccessoryView = isSetHiddenKeyboardAccessoryView
        super.init(frame: .zero, textContainer: nil)
        self.setupUI()
        self.updateUI()
    }
    
    
    public required  init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
        self.updateUI()
    }
    
    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textColor        = self.textDefColor
        self.font             = TTBaseUIKitConfig.getFontConfig().FONT
        self.textContainer.maximumNumberOfLines = 4
        self.textContainer.lineBreakMode = .byTruncatingTail
        self.textContainerInset = self.paddingTextUIEdgeInsets

        self.delegate = self
        if self.type == .NO_BORDER {
            self.setBorder(with: 0, color: .clear, coner: TTSize.CORNER_RADIUS)
        } else {
            self.setBorder(with: 1, color: TTView.lineDefColor, coner: TTSize.CORNER_RADIUS)
        }
        
        if self.isSetHiddenKeyboardAccessoryView {
            self.setHiddenKeyboardAccessoryView().done()
        }
    }
    
    fileprivate func setKeyBoardStyle(type:UIKeyboardType) {
        self.keyboardType = type
    }
    
    @objc fileprivate func dismissKeyboard(_ sennder: UIButton) {
        self.onDismissKeyboard?(); UIApplication.topViewController()?.dismissKeyboard()
    }
}

extension TTBaseUITextView : UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        self.onTextEditChangedHandler?(self, textView.text)
    }
}
// For base Function
extension TTBaseUITextView {
    
    func setHiddenKeyboardAccessoryView() -> TTBaseUITextView {
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
    
    @discardableResult public func setKeyboardStyleByText() -> TTBaseUITextView {
        self.setKeyBoardStyle(type: .default)
        return self
    }
    
    @discardableResult public func setKeyboardStyleByNumber() -> TTBaseUITextView  {
        self.setKeyBoardStyle(type: .numberPad)
        return self
    }
    
    @discardableResult public func setKeyboardStyleByEmail()  -> TTBaseUITextView  {
        self.setKeyBoardStyle(type: .emailAddress)
        return self
    }
    
    @discardableResult public func setKeyboardStyleByDate()  -> TTBaseUITextView {
        self.setKeyBoardStyle(type: .numbersAndPunctuation)
        return self
    }
    
    @discardableResult public func setKeyboardStyleByMoney()  -> TTBaseUITextView {
        self.setKeyBoardStyle(type: .decimalPad)
        return self
    }
    
    @discardableResult public func setKeyboardStyleByPhone()  -> TTBaseUITextView {
        self.setKeyBoardStyle(type: .numberPad)
        return self
    }
    
    @discardableResult public func setNoBorder() -> TTBaseUITextView {
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.clear.cgColor
        return self
    }
    
    @discardableResult public func setTextColor(color:UIColor) -> TTBaseUITextView {
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
    
    public func setAutoSizeWhenInputText(withMaximumNumberOfLines line:Int) {
           self.textContainer.lineBreakMode = .byTruncatingTail
           self.textContainer.maximumNumberOfLines = line
           self.isScrollEnabled = false
    }
}

// For real time format text
extension TTBaseUITextView {
    
    @objc fileprivate func textEditChanged(_ sender:UITextView) {
        self.onTextEditChangedHandler?(self, String.get(sender.text))
    }
    
}

// MARK:// For format currency
extension TTBaseUITextView {
    
}
