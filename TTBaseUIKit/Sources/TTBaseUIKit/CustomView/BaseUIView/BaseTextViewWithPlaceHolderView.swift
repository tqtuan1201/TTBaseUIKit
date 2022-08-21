//
//  BaseTextViewWithPlaceHolderView.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 10/18/21.
//  Copyright © 2021 Truong Quang Tuan. All rights reserved.
//

import Foundation

open class TextViewWithPlaceHolderView: TTBaseUITextView {
    
    open var padding:CGFloat { get { return TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF }}
    
    public let textviewPlaceHolder:TTBaseUILabel = TTBaseUILabel(withType: .SUB_TITLE, text: "PlaceHolder", align: .natural)
    
    public var onTextEditChangedBySetPlaceHolderHandler:( (_ text:String) -> ())?
    
    fileprivate var isPadding:Bool = true
    
    public init(withTextPlaceHolder holder:String, isPadding:Bool = true) {
        super.init(with: .DEFAULT, isSetHiddenKeyboardAccessoryView: true)
        self.isPadding = isPadding
        self.textviewPlaceHolder.setText(text: holder)
        self.setupBaseUIView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(with: .DEFAULT, isSetHiddenKeyboardAccessoryView: true)
        self.setupBaseUIView()
    }
    
    public func onUpdateText(text:String) {
        self.setText(text: text)
        self.textviewPlaceHolder.isHidden = text.isEmpty ? false : true
    }
    
    public func setPlaceHolder(text:String) {
        self.textviewPlaceHolder.setText(text: text)
    }
    
    fileprivate func setupBaseUIView() {

        self.textviewPlaceHolder.isUserInteractionEnabled = false
        self.textviewPlaceHolder.alpha = 0.5
        self.textviewPlaceHolder.setMutilLine(numberOfLine: 0, textAlignment: .left, mode: .byTruncatingTail)
        self.isScrollEnabled = false
        
        self.setBgColor(.white)
        self.setBorder(with: 0, color: .clear, coner: 0)
        self.textContainerInset = UIEdgeInsets.init(top: self.padding, left: 0, bottom: self.padding, right: 0)
        self.addSubview(self.textviewPlaceHolder)
        
        self.textviewPlaceHolder.setVerticalContentHuggingPriority()
            .setLeadingAnchor(constant: self.isPadding ? self.padding : 0)
            .setTopAnchor(constant: TTSize.P_CONS_DEF)
            .widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.95).isActive = true
        
        self.onTextEditChangedHandler = { (_, text) in
            self.onTextEditChangedBySetPlaceHolderHandler?(text)
            DispatchQueue.main.async {
                if text.count != 0 {
                    self.textviewPlaceHolder.isHidden = true
                } else {
                    self.textviewPlaceHolder.isHidden = false
                }
            }
        }
    }
}
