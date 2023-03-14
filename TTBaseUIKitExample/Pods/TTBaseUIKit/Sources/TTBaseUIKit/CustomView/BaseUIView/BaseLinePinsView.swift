//
//  BaseLinePinsView.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 9/16/20.
//  Copyright © 2020 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseLinePinsView: TTBaseUIView {
    
    open var numberOfPIN:Int { get { return 4 }}
    
    public var isShow:Bool = false
    
    fileprivate var pinString:String = "" {
        didSet {
            self.didChangValue?(pinString)
            self.handleInputPIN()
            if self.pinString.count == self.numberOfPIN { self.didCompleted?(pinString) }
        }
    }
    
    fileprivate let numSize:(CGFloat,CGFloat) =  (Device.size() < .screen5_5Inch) ? (35,39) : (45,49)
    
    public let panelStack:TTBaseUIStackView = TTBaseUIStackView(axis: .horizontal, spacing: TTSize.P_CONS_DEF, alignment: .center, distributionValue: .equalSpacing)
    
    public let hiddenTextField:TTBaseUITextField = TTBaseUITextField(withPlaceholder: "", pading: 10, type: .NO_BORDER, isSetHiddenKeyboardAccessoryView: false)
    
    public var didCompleted:( (_ otpString:String) -> ())?
    public var didChangValue:( (_ otpString:String) -> ())?
    
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
            let numLabel:TTBaseLinePinView = TTBaseLinePinView()
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
    }
}

//MARK:// For Base funcs
extension TTBaseLinePinsView {
    fileprivate func handleInputPIN() {
        
        let count:Int = self.pinString.count
        
        for (index, value) in self.pinString.enumerated() {
            guard let lb = self.layer.value(forKey: "Index_\(index)") as? TTBaseLinePinView else { return }
            lb.setText(text: String(value))
            lb.setActive()
        }
        if  count < self.numberOfPIN {
            for i in count ..< self.numberOfPIN {
                guard let lb = self.layer.value(forKey: "Index_\(i)") as? TTBaseLinePinView else { return }
                lb.setLine()
            }
        }
    }

}

//MARK:// For Public funcs
extension TTBaseLinePinsView {
    
    public func setPIN(withText PIN:String) {
        self.pinString = PIN
        self.hiddenTextField.setText(text: PIN)
    }
}
