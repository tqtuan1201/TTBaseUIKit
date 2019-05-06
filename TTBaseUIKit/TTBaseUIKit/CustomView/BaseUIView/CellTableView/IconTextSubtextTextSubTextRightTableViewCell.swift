//
//  IconTextSubtextTextSubTextRightTableViewCell.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/27/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation

///
/// This Class to view Default Cell:
///
/// ImageView Left
///
/// Title Left - Title Right
///
/// Line view optional
///
/// SubTitle Left - SubTitle Right
///
import UIKit
import Foundation

open class TTIconTextSubtextTextSubTextRightTableViewCell : TTBaseUITableViewCell {
    
    open var paddingStack:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (TTSize.P_CONS_DEF,TTSize.P_CONS_DEF,TTSize.P_CONS_DEF,TTSize.P_CONS_DEF)}}
    open var spaceLabelStack:CGFloat { get { return TTSize.P_CONS_DEF / 2 }}
    
    open var lineHeight:CGFloat { get { return TTSize.H_LINEVIEW / 2 }}
    open var lineColor:UIColor { get { return TTView.viewBgColor }}
    
    open var paddingText:CGFloat { get { return TTSize.P_CONS_DEF }}
    
    open var numberOfLineTitle:Int { get { return 2 }}
    open var numberOfLineSub:Int { get { return 3 }}
    
    open var paddingLeftImage:CGFloat = TTSize.P_CONS_RIGHT_H
    open var sizeImages:(CGFloat,CGFloat) { get { return (TTSize.H_ICON_CELL,TTSize.H_ICON_CELL)}}
    open var cornerImages:CGFloat { get { return TTBaseUIKitConfig.getSizeConfig().CORNER_RADIUS }}
    
    
    public var lineView:TTLineView = TTLineView()
    public var titleLeftRightLabel:TTLabelLeftRightView = TTLabelLeftRightView(withType: .TITLE, coner: 0, isHuggingRight: nil)
    public var subLeftRight:TTLabelLeftRightView = TTLabelLeftRightView(withType: .SUB_TITLE, coner: 0, isHuggingRight: nil)
    public var imageRight:TTBaseUIImageView = TTBaseUIImageView()
    public var stackView:TTBaseUIStackView =  TTBaseUIStackView(axis: .vertical, spacing: TTSize.P_CONS_DEF, alignment: .leading)
    
    override open func updateUI() {
        self.setupBaseUI()
        self.setupBaseContraint()
    }
    
    
    fileprivate func setupBaseUI() {
        
        self.titleLeftRightLabel.setNumberOfLine(number: self.numberOfLineTitle)
        self.subLeftRight.setNumberOfLine(number: self.numberOfLineSub)
        
        self.imageRight.setCorner(withCornerRadius: self.cornerImages).done()
        
        self.lineView.setLineColor(lineColor)
        
        self.stackView.spacing = self.spaceLabelStack
        self.stackView.addArrangedSubview(self.titleLeftRightLabel)
        self.stackView.addArrangedSubview(self.lineView)
        self.stackView.addArrangedSubview(self.subLeftRight)
        
        self.panel.addSubview(self.stackView)
        self.panel.addSubview(self.imageRight)
    }
    
    fileprivate func setupBaseContraint() {
        
        if self.sizeImages.0 == 0 {  self.paddingLeftImage = 0 }
        
        self.imageRight.setWidthAnchor(constant: self.sizeImages.0).setHeightAnchor(constant: self.sizeImages.1)
            .setLeadingAnchor(constant: self.paddingLeftImage).setcenterYAnchor(constant: 0).done()
        
        self.titleLeftRightLabel.setTrailingAnchor(constant: paddingText).done()
        self.subLeftRight.setTrailingAnchor(constant: paddingText).done()
        
        self.stackView.setLeadingWithNextToView(view: imageRight, constant: self.paddingStack.0).setTopAnchor(constant: self.paddingStack.1)
            .setTrailingAnchor(constant: self.paddingStack.2).setBottomAnchor(constant: self.paddingStack.3).done()
        
        self.lineView.setHeightAnchor(constant: self.lineHeight).setTrailingAnchor(constant: paddingText).done()
    }
    
}


public protocol TTIconTextSubtextTextSubTextRightTableViewCellRepresentable {
    
    var imageName:String { get }
    var iconName:String { get }
    var titleLeftText:String { get }
    var titleRightText:String { get }
    var subLeftText:String { get }
    var subRightText:String { get }
    
}

extension TTIconTextSubtextTextSubTextRightTableViewCell {
    
    public func configure(withRepresentable viewModel: TTIconTextSubtextTextSubTextRightTableViewCellRepresentable) {
        self.titleLeftRightLabel.setText(withTextLeft: viewModel.titleLeftText, right: viewModel.titleRightText)
        self.subLeftRight.setText(withTextLeft: viewModel.subLeftText, right: viewModel.subRightText)
    }
}
