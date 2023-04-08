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

    fileprivate lazy var maxLenght:Int?  = nil

    open var maxNumberOfLines:Int { get { return 4 } }
    open var paddingTextUIEdgeInsets:UIEdgeInsets { get { return UIEdgeInsets.init(top: TTSize.P_CONS_DEF, left: TTSize.P_CONS_DEF, bottom: TTSize.P_CONS_DEF, right: TTSize.P_CONS_DEF)} }
    open var paddingContentInset:UIEdgeInsets { get { return UIEdgeInsets.init(top: TTSize.P_CONS_DEF, left: 0, bottom: TTSize.P_CONS_DEF, right: TTSize.P_CONS_DEF)} }
    
    public enum TYPE {
        case DEFAULT
        case NO_BORDER
    }
    
    public var onTextEditChangedHandler:((_ textView:TTBaseUITextView,_ textString:String) -> Void)?
    public var onDismissKeyboard:(() -> Void)?
    public var onDidMaxLeightHandle:((_ text:String) -> Void)?
    public var onTouchIconHandler:((_ textView:TTBaseUITextView) -> Void)?
    public var onTouchReturnKeyHandler:((_ textView:TTBaseUITextView,_ type:UIReturnKeyType) -> Void)?
    
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
        
        self.textContainer.maximumNumberOfLines = self.maxNumberOfLines
        self.textContainer.lineBreakMode = .byTruncatingTail
        
        self.textContainerInset = self.paddingTextUIEdgeInsets
        self.contentInset = self.paddingContentInset
        
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
    
}

extension TTBaseUITextView : UITextViewDelegate {
    
    public func textViewDidChange(_ textView: UITextView) {
        self.onTextEditChangedHandler?(self, textView.text)
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" { self.onTouchReturnKeyHandler?(self, self.returnKeyType); return false}
        
        if let maxLenght = self.maxLenght {
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            if newText.count > maxLenght {
                self.onDidMaxLeightHandle?(newText)
                return false
            } else {
                return true
            }
        } else {
            return true
        }
    }
}
// For base Function
extension TTBaseUITextView {
    
    @discardableResult public func setHiddenKeyboardAccessoryView() -> TTBaseUITextView {
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
            hiddenButton.setImage(UIImage.getFromTTBaseUIKitPM(byName: "img.hideKeyboard.png")?.withRenderingMode(.alwaysTemplate), for: .normal)
            hiddenButton.layer.cornerRadius    = 4
            hiddenButton.clipsToBounds = false
            
            panelView.addSubview(hiddenButton)
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
    
    public func setMaxLenght(max:Int) {
        self.maxLenght = max
    }
}

// For real time format text
extension TTBaseUITextView {
    
    @objc fileprivate func textEditChanged(_ sender:UITextView) {
        self.onTextEditChangedHandler?(self, String.get(sender.text))
    }
    
}

