//
//  LabelLeftRightView.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/27/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

///
/// This Class to view  LeftLabel-RightLabel view:
///
/// LeftLabel-RightLabel
///
/// HeightView base on height label, please set leading and trailing for view
///
open class TTLabelLeftRightView: TTBaseUIView {
    
    open var paddingView:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (0,0,0,0)}}
    open var paddingLabel:CGFloat { get {return TTSize.P_CONS_DEF}}
    open var widthLeftLabel:CGFloat { get {return TTSize.W_TEXT_LEFTVIEW}}
    open var widthRightLabel:CGFloat { get {return TTSize.W_TEXT_RIGHTVIEW}}
    open var isSetWidthAnchor:Bool { get { return false } }
    
    public var isHuggingRight:Bool? = nil
    
    public var leftLabel:TTBaseUILabel = TTBaseUILabel(withType: .TITLE, text: "Left label", align: .left)
    public var rightLabel:TTBaseUILabel = TTBaseUILabel(withType: .TITLE, text: "Right label", align: .right)
    
    required public init(withType type:TTBaseUILabel.TYPE = TTBaseUILabel.TYPE.TITLE, coner:CGFloat = TTBaseUIKitConfig.getSizeConfig().CORNER_RADIUS, isHuggingRight:Bool? = nil ) {
        super.init()
        self.leftLabel = TTBaseUILabel(withType: type, text: "Left label", align: .left)
        self.rightLabel = TTBaseUILabel(withType: type, text: "Right label", align: .right)
        self.isHuggingRight = isHuggingRight
        self.setConerRadius(with: coner)
        self.setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required public init() {
        fatalError("init() has not been implemented")
    }
    
    fileprivate func setupUI() {
        self.leftLabel.setMutilLine(numberOfLine: 2, textAlignment: .left).done()
        self.rightLabel.setMutilLine(numberOfLine: 2, textAlignment: .right).done()
        
        self.addSubview(leftLabel)
        self.addSubview(rightLabel)
        
        self.leftLabel.setLeadingAnchor(constant: self.paddingView.0).setTopAnchor(constant: self.paddingView.1).setBottomAnchor(constant: self.paddingView.2).done()
        self.rightLabel.setLeadingWithNextToView(view: self.leftLabel, constant: self.paddingLabel).setTopAnchor(constant: self.paddingView.1).setTrailingAnchor(constant: self.paddingView.2).setBottomAnchor(constant: self.paddingView.3).done()
        
        if let isRight = self.isHuggingRight {
            if isRight {
                self.rightLabel.setFullContentHuggingPriority().done()
                if isSetWidthAnchor { self.rightLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: TTSize.W_TEXT_RIGHTVIEW).isActive = true }
            } else {
                self.leftLabel.setFullContentHuggingPriority().done()
                if isSetWidthAnchor { self.leftLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: TTSize.W_TEXT_LEFTVIEW).isActive = true }
            }
        } else {
            if isSetWidthAnchor { self.rightLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: TTSize.W_TEXT_RIGHTVIEW).isActive = true }
            self.rightLabel.setHorizontalContentHuggingPriority().done()
            self.leftLabel.setVerticalContentHuggingPriority(priority: .required)
            self.rightLabel.setVerticalContentHuggingPriority(priority: .defaultLow)
            //self.rightLabel.heightAnchor.constraint(equalTo: self.leftLabel.heightAnchor, multiplier: 1).isActive = true
        }

    }
}

extension TTLabelLeftRightView {
    public func setText(withTextLeft left:String, right:String) {
        self.leftLabel.setText(text: left).done()
        self.rightLabel.setText(text: right).done()
    }
    
    public func setNumberOfLine( number:Int) {
        self.leftLabel.setMutilLine(numberOfLine: number, textAlignment: .left).done()
        self.rightLabel.setMutilLine(numberOfLine: number, textAlignment: .right).done()
    }
}
