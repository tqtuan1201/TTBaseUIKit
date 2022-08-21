//
//  TextSubtextIconTableViewCell.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/19/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
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
/// ImageView Right
///
open class TTTextSubtextIconTableViewCell : TTBaseUITableViewCell {
    
    open var paddingStack:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (TTSize.P_CONS_DEF,TTSize.P_CONS_DEF,TTSize.P_CONS_DEF,TTSize.P_CONS_DEF)}}
    open var spaceLabelStack:CGFloat { get { return TTSize.P_CONS_DEF / 2 }}
    
    open var paddingText:CGFloat { get { return TTSize.P_CONS_DEF }}
    
    open var numberOfLineTitle:Int { get { return 3 }}
    open var numberOfLineSub:Int { get { return 5 }}
    
    open var paddingRightImage:CGFloat = TTSize.P_CONS_RIGHT_H
    open var sizeImages:(CGFloat,CGFloat) { get { return (TTSize.H_ICON_CELL,TTSize.H_ICON_CELL)}}
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
        
        if self.sizeImages.0 == 0 {  self.paddingRightImage = 0 }
        
        self.titleLabel.setVerticalContentHuggingPriority().setTrailingAnchor(constant: paddingText).done()
        self.subLabel.setVerticalContentHuggingPriority().setTrailingAnchor(constant: paddingText).done()
        
        self.stackView.setLeadingAnchor(constant: self.paddingStack.0).setTopAnchor(constant: self.paddingStack.1).setTrailingWithNextToView(view: self.imageRight, constant: self.paddingStack.2).setBottomAnchor(constant: self.paddingStack.3).done()
        
        self.imageRight.setWidthAnchor(constant: self.sizeImages.0).setHeightAnchor(constant: self.sizeImages.1)
            .setTrailingAnchor(self.panel, constant: self.paddingRightImage).setcenterYAnchor(constant: 0).done()
        
    }
    
}

public protocol TTTextSubtextIconTableViewCellRepresentable {
    
    var imageName:String { get }
    
    var iconName:String { get }
    var iconColor:UIColor { get }
    
    var titleText:String { get }
    var subText:String { get }
    
}

extension TTTextSubtextIconTableViewCell {
    
    public func configure(withRepresentable viewModel: TTTextSubtextIconTableViewCellRepresentable) {
        
        self.titleLabel.setText(text: viewModel.titleText).done()
        self.subLabel.setText(text: viewModel.subText).done()
        
        if viewModel.iconName != "" {
            DispatchQueue.main.async { [weak self] in self?.imageRight.setIConImage(with: viewModel.iconName, color: viewModel.iconColor, scale: .scaleAspectFit).done() }
        } else if !viewModel.imageName.isEmpty {
            DispatchQueue.main.async { [weak self] in self?.imageRight.setImage(with: viewModel.imageName).done() }
        }
        
    }
}
