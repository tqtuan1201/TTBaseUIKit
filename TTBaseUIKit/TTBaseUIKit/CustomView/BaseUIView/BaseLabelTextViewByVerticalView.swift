//
//  BaseLabelTextViewByVerticalView.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 2/7/20.
//  Copyright © 2020 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseLabelTextViewByVerticalView : TTBaseUIView {
    
    open var padding:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (0,0,0,0)}}
    open var heightTextView:CGFloat { get { return TTSize.H_TEXTFIELD * 3} }
    open var borderTextView:CGFloat { get { return 1} }
    open var numberOfLines:Int { get { return 50} }
    
    public let titleLabel:TTBaseUILabel = TTBaseUILabel(withType: .TITLE, text: "Title name", align: .left)
    public let textView:TTBaseUITextView = TTBaseUITextView(with: .DEFAULT, isSetHiddenKeyboardAccessoryView: true)
    
    public init(withLabel text:String, isBold:Bool) {
        super.init()
        self.titleLabel.setText(text: text)
        if isBold {self.titleLabel.setBold()}
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.textView)
        
        self.setupBaseUIView()
        self.setupBaseContraint()
    }
    
    required public init() { fatalError("init() has not been implemented") }
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
}

extension TTBaseLabelTextViewByVerticalView {
    
    fileprivate func setupBaseUIView() {
        self.titleLabel.setMutilLine(numberOfLine: 2, textAlignment: .left, mode: .byTruncatingTail)
    
        self.textView.textContainer.maximumNumberOfLines = self.numberOfLines
        self.textView.textContainer.lineBreakMode = .byWordWrapping
        self.textView.isScrollEnabled = false
        self.textView.setBorder(with: self.borderTextView, color: TTView.lineDefColor, coner: TTSize.CORNER_RADIUS)
        self.textView.setBgColor(TTView.lineDefColor.withAlphaComponent(0.4))
    }
    
    fileprivate func setupBaseContraint() {
        self.titleLabel.setVerticalContentHuggingPriority()
            .setLeadingAnchor(constant: padding.0).setTrailingAnchor(constant: padding.2)
            .setTopAnchor(constant: padding.1)
        
        self.textView.setTopAnchorWithAboveView(nextToView: self.titleLabel, constant: TTSize.P_CONS_DEF * 1.5)
            .setLeadingAnchor(constant: padding.0).setTrailingAnchor(constant: padding.2)
            .setBottomAnchor(constant: padding.3)
        
        if self.heightTextView != 0 {
            self.textView.heightAnchor.constraint(greaterThanOrEqualToConstant: self.heightTextView).isActive = true
        }
    }
    
}

