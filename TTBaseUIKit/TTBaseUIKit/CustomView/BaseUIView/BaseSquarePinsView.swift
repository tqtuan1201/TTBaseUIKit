//
//  BaseSquarePinsView.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 2/7/20.
//  Copyright © 2020 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class BaseSquarePinsView: TTBaseUIView {
    
    open var numberOfPIN:Int { get { return 4 }}
    
    public var isShow:Bool = false
    
    fileprivate var pinString:String = "" {
        didSet {
            self.handleInputPIN()
            if self.pinString.count == self.numberOfPIN { self.didCompleted?(pinString) }
        }
    }
    
    fileprivate let numSize:(CGFloat,CGFloat) =  (Device.size() < .screen5_5Inch) ? (35,39) : (45,49)
    
    public let panelStack:TTBaseUIStackView = TTBaseUIStackView(axis: .horizontal, spacing: TTSize.P_CONS_DEF, alignment: .center, distributionValue: .equalSpacing)
    
    public let hiddenTextField:TTBaseUITextField = TTBaseUITextField(withPlaceholder: "", pading: 10, type: .NO_BORDER, isSetHiddenKeyboardAccessoryView: false)
    
    public var didCompleted:( (_ otpString:String) -> ())?
    
    override open func updateBaseUIView() {
        super.updateBaseUIView()
        
        self.addSubview(self.panelStack)
        self.setBgColor(UIColor.clear)
        
        self.addSubview(self.hiddenTextField)
        self.hiddenTextField.setFullContraints(constant: 0)
        self.hiddenTextField.alpha = 0
        
        self.hiddenTextField.resignFirstResponder()
        self.hiddenTextField.becomeFirstResponder()
        
        self.setTouchHandler().onTouchHandler = { [weak self] _ in guard let strongSelf = self else { return }
            strongSelf.hiddenTextField.resignFirstResponder()
            strongSelf.hiddenTextField.becomeFirstResponder()
        }
        
        self.hiddenTextField.setKeyboardStyleByPhone()
        
        self.panelStack.setFullContraints(constant: 0)
        
        for i in 0 ..< self.numberOfPIN {
            let numLabel:TTBaseSquarePinView = TTBaseSquarePinView()
            self.layer.setValue(numLabel, forKey: "Index_\(i)")
            numLabel.setWidthAnchor(constant: self.numSize.0).setHeightAnchor(constant: self.numSize.1)
            self.panelStack.addArrangedSubview(numLabel)
        }
        
        self.hiddenTextField.onTextEditChangedHandler = { (textField, value) in
            if value.count > self.numberOfPIN {
                let limitString = value[0 ..< self.numberOfPIN]
                self.pinString = String.init(limitString)
                self.hiddenTextField.setText(text: limitString)
            } else {
                self.pinString = value
            }
        }
        
        self.setHidden(withLineColor: TTView.lineDefColor)
    }
}

//MARK:// For Base funcs
extension BaseSquarePinsView {
    fileprivate func handleInputPIN() {
        
        let count:Int = self.pinString.count
        
        for (index, value) in self.pinString.enumerated() {
            guard let lb = self.layer.value(forKey: "Index_\(index)") as? TTBaseSquarePinView else { return }
            lb.setText(text: String(value))
            if self.isShow {
                lb.setShow()
            } else {
                lb.setHidden(withLineColor: TTView.labelBgDef)
            }
        }
        if  count < self.numberOfPIN {
            for i in count ..< self.numberOfPIN {
                guard let lb = self.layer.value(forKey: "Index_\(i)") as? TTBaseSquarePinView else { return }
                lb.setLine()
                lb.lineView.setBgColor(TTView.lineDefColor)
            }
        }
    }

}

//MARK:// For Public funcs
extension BaseSquarePinsView {
    public func setPIN(withText PIN:String) {
        self.pinString = PIN
        self.hiddenTextField.setText(text: PIN)
    }
    
    public func setShow() {
        self.isShow = true
        for i in 0 ..< self.numberOfPIN {
            guard let lb = self.layer.value(forKey: "Index_\(i)") as? TTBaseSquarePinView else { return }
            lb.lineView.isHidden = true
            lb.pinLabel.isHidden = false
            lb.lineView.setBgColor(TTView.lineDefColor)
        }
    }
    
    public func setHidden(withLineColor color:UIColor = TTBaseUIKitConfig.getViewConfig().labelBgDef) {
        self.isShow = false
        for i in 0 ..< self.numberOfPIN {
            guard let lb = self.layer.value(forKey: "Index_\(i)") as? TTBaseSquarePinView else { return }
            lb.lineView.isHidden = false
            lb.pinLabel.isHidden = true
            lb.lineView.setBgColor(color)
        }
    }
}
