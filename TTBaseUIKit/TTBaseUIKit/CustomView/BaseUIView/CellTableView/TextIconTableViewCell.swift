//
//  TextIconTableViewCell.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/19/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation

open class TTTextIconTableViewCell : TTBaseUITableViewCell {
    
    open var paddingLabel:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (TTSize.P_CONS_DEF,TTSize.P_CONS_DEF,TTSize.P_CONS_DEF,TTSize.P_CONS_DEF)}}
    open var numberOfLineLabel:Int { get { return 5 }}
    
    open var paddingRightImage:CGFloat = TTSize.P_CONS_RIGHT_H
    open var sizeImages:(CGFloat,CGFloat) { get { return (TTSize.H_ICON,TTSize.H_ICON)}}
    open var cornerImages:CGFloat { get { return TTBaseUIKitConfig.getSizeConfig().CORNER_RADIUS }}
    
    public var titleLabel:TTBaseUILabel = TTBaseUILabel(withType: .TITLE, text: "Text Line",align: .left)
    public var imageRight:TTBaseUIImageView = TTBaseUIImageView()
    
    
    override open func updateUI() {
        self.setupBaseUI()
        self.setupBaseContraint()
    }
    
    
    fileprivate func setupBaseUI() {
        self.imageRight.setCorner(withCornerRadius: self.cornerImages)
        self.titleLabel.setMutilLine(numberOfLine: self.numberOfLineLabel, textAlignment: .left).done()
        self.panel.addSubview(self.titleLabel)
        self.panel.addSubview(self.imageRight)
    }
    
    fileprivate func setupBaseContraint() {
        
        self.titleLabel.setVerticalContentHuggingPriority().setLeadingAnchor(self.panel, constant: self.paddingLabel.0).setTopAnchor(self.panel, constant: self.paddingLabel.1).setTrailingWithNextToView(view: self.imageRight, constant: self.paddingLabel.2).setBottomAnchor(self.panel, constant: self.paddingLabel.3).done()
        self.imageRight.setWidthAnchor(constant: self.sizeImages.0).setHeightAnchor(constant: self.sizeImages.1)
            .setTrailingAnchor(self.panel, constant: self.paddingRightImage).setcenterYAnchor(constant: 0).done()
        
    }
    
}
