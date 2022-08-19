//
//  BaseTextSubtextHorTableViewCell.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 2/17/20.
//  Copyright © 2020 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

///
/// This Class to view Default Cell:
///
/// Title
///
/// SubTitle
///
/// Arrage horizontal
///

open class TTBaseTextSubtextHorTableViewCell : TTBaseUITableViewCell {
    
    open var minimumHeightLabel:CGFloat { get { return 30.0 }}
    
    open var paddingLine:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (0,0,0,0)}}
    open var paddingView:CGFloat { get { return TTSize.P_CONS_DEF }}
    open var paddingText:CGFloat { get { return TTSize.P_CONS_DEF }}

    open var isAutoSizeByRightLabel:Bool { get { return true }}
    
    open var titleMultiplierWidth:CGFloat? { get { return nil }}
    open var titleWidth:CGFloat? { get { return nil }}
    
    open var isSetTitleCenterY:Bool { get { return false }}
    open var isSetSubCenterY:Bool { get { return false }}
    
    open var isSetLine:Bool { get { return false }}
    
    
    open var numberOfLineTitle:Int { get { return 3 }}
    open var numberOfLineSub:Int { get { return 5 }}

    public var titleLabel:TTBaseUILabel = TTBaseUILabel(withType: .TITLE, text: "Text line",align: .left)
    public var subLabel:TTBaseUILabel = TTBaseUILabel(withType: .SUB_TITLE, text: "Sub Text Line",align: .left)
    public lazy var lineView:TTLineView = TTLineView()
    
    override open func updateUI() {
        self.setupBaseUI()
        self.setupBaseContraint()
    }
    
    
    fileprivate func setupBaseUI() {
        
        self.titleLabel.setMutilLine(numberOfLine: self.numberOfLineTitle, textAlignment: .left).done()
        self.subLabel.setMutilLine(numberOfLine: self.numberOfLineSub, textAlignment: .left).done()
        
        self.panel.addSubview(self.titleLabel)
        self.panel.addSubview(self.subLabel)
        
        if self.isSetLine { self.panel.addSubview(self.lineView) }

    }
    
    fileprivate func setupBaseContraint() {

        if self.isSetLine {
            self.lineView.setHeightAnchor(constant: TTSize.H_LINEVIEW)
                .setLeadingAnchor(constant: self.paddingLine.0).setTrailingAnchor(constant: self.paddingLine.2)
                .setBottomAnchor(constant: self.paddingLine.3)
        }
        
        if self.isAutoSizeByRightLabel {
            self.titleLabel.setVerticalContentHuggingPriority()
                .setLeadingAnchor(constant: self.paddingView).setTrailingWithNextToView(view: self.subLabel, constant: self.paddingText)
            
            self.subLabel.setVerticalContentHuggingPriority()
                .setTopAnchor(constant: self.paddingView).setBottomAnchor(constant: self.paddingView)
                .setTrailingAnchor(constant: self.paddingView)
                .heightAnchor.constraint(greaterThanOrEqualToConstant: self.minimumHeightLabel).isActive = true
        } else {
            self.titleLabel.setVerticalContentHuggingPriority()
                .setTopAnchor(constant: self.paddingView).setBottomAnchor(constant: self.paddingView)
                .setLeadingAnchor(constant: self.paddingView).setTrailingWithNextToView(view: self.subLabel, constant: self.paddingText)
                .heightAnchor.constraint(greaterThanOrEqualToConstant: self.minimumHeightLabel).isActive = true

            self.subLabel.setVerticalContentHuggingPriority()
                .setTrailingAnchor(constant: self.paddingView)
        }
        
        if let _titleMultiplierWidth = self.titleMultiplierWidth {
            self.titleLabel.widthAnchor.constraint(equalTo: self.subLabel.widthAnchor, multiplier: _titleMultiplierWidth).isActive = true
        }
        
        if let _titleWidth = self.titleWidth {
            self.titleLabel.setWidthAnchor(constant: _titleWidth)
        }
        
        if self.isSetTitleCenterY {
            self.titleLabel.setcenterYAnchor(constant: 0)
        } else {
            self.titleLabel.setTopAnchor(constant: self.paddingView)
        }
        
        if self.isSetSubCenterY {
            self.subLabel.setcenterYAnchor(constant: 0)
        } else {
            self.subLabel.setTopAnchor(constant: self.paddingView)
        }
        
    }
    
}
