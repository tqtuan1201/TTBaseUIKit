//
//  IconTextSubtextTableViewCell.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/27/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

///
/// This Class to view Default Cell:
///
/// ImageView Left
///
/// Title
///
/// SubTitle
///
open class TTIconTextSubtextTableViewCell : TTBaseUITableViewCell {
    
    open var paddingStack:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (TTSize.P_CONS_DEF,TTSize.P_CONS_DEF,TTSize.P_CONS_DEF,TTSize.P_CONS_DEF)}}
    open var spaceLabelStack:CGFloat { get { return TTSize.P_CONS_DEF / 2 }}
    
    open var paddingText:CGFloat { get { return TTSize.P_CONS_DEF }}
    
    open var numberOfLineTitle:Int { get { return 3 }}
    open var numberOfLineSub:Int { get { return 5 }}
    
    open var paddingLeftImage:CGFloat = TTSize.P_CONS_RIGHT_H
    open var sizeImages:(CGFloat,CGFloat) { get { return (TTSize.H_ICON,TTSize.H_ICON)}}
    open var cornerImages:CGFloat { get { return TTBaseUIKitConfig.getSizeConfig().CORNER_RADIUS }}
    
    public var titleLabel:TTBaseUILabel = TTBaseUILabel(withType: .TITLE, text: "Text line",align: .left)
    public var subLabel:TTBaseUILabel = TTBaseUILabel(withType: .SUB_TITLE, text: "Sub Text Line",align: .left)
    public var imageRight:TTBaseUIImageView = TTBaseUIImageView()
    public var stackView:TTBaseUIStackView =  TTBaseUIStackView(axis: .vertical, spacing: TTSize.P_CONS_DEF, alignment: .leading)
    
    override open func updateUI() {
        self.setupBaseUI()
        self.setupBaseContraint()
    }
    
    
    fileprivate func setupBaseUI() {
        
        self.imageRight.setCorner(withCornerRadius: self.cornerImages).done()
        self.titleLabel.setMutilLine(numberOfLine: self.numberOfLineTitle, textAlignment: .left).done()
        self.subLabel.setMutilLine(numberOfLine: self.numberOfLineSub, textAlignment: .left).done()
        
        self.stackView.spacing = self.spaceLabelStack
        self.stackView.addArrangedSubview(self.titleLabel)
        self.stackView.addArrangedSubview(self.subLabel)
        
        self.panel.addSubview(self.stackView)
        self.panel.addSubview(self.imageRight)
    }
    
    fileprivate func setupBaseContraint() {
        
        if self.sizeImages.0 == 0 {  self.paddingLeftImage = 0 }
        
        self.imageRight.setWidthAnchor(constant: self.sizeImages.0).setHeightAnchor(constant: self.sizeImages.1)
            .setLeadingAnchor(constant: self.paddingLeftImage).setcenterYAnchor(constant: 0).done()
        
        self.titleLabel.setVerticalContentHuggingPriority().setTrailingAnchor(constant: paddingText).done()
        self.subLabel.setVerticalContentHuggingPriority().setTrailingAnchor(constant: paddingText).done()
        
        self.stackView.setLeadingWithNextToView(view: imageRight, constant: self.paddingStack.0).setTopAnchor(constant: self.paddingStack.1)
            .setTrailingAnchor(constant: self.paddingStack.2).setBottomAnchor(constant: self.paddingStack.3).done()
        
        
    }
    
}
