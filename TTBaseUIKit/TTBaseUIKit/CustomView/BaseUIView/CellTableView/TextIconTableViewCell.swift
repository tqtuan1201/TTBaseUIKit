//
//  TextIconTableViewCell.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/19/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

public enum TYPE_TEXT_ICON_VIEW_CELL {
    case LEFT_IMAGE
    case RIGHT_IMAGE
    case BOTH_IMAGE
}

///
/// This Class to view Cell:
/// Title - Image
///
open class TTTextIconTableViewCell : TTBaseUITableViewCell {
    
    open var type:TYPE_TEXT_ICON_VIEW_CELL { get { return .RIGHT_IMAGE } }
    
    open var paddingLabel:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (TTSize.P_CONS_DEF,TTSize.P_CONS_DEF,TTSize.P_CONS_DEF,TTSize.P_CONS_DEF)}}
    open var numberOfLineLabel:Int { get { return 5 }}
    
    open var paddingRightImage:CGFloat = TTSize.P_CONS_RIGHT_H
    open var paddingLeftImage:CGFloat = TTSize.P_CONS_RIGHT_H
    open var sizeImages:(CGFloat,CGFloat) { get { return (TTSize.H_ICON,TTSize.H_ICON)}}
    open var cornerImages:CGFloat { get { return TTBaseUIKitConfig.getSizeConfig().CORNER_RADIUS }}
    
    public var titleLabel:TTBaseUILabel = TTBaseUILabel(withType: .TITLE, text: "Text Line",align: .left)
    
    public lazy var imageRight:TTBaseUIImageView = TTBaseUIImageView()
    public lazy var imageLeft:TTBaseUIImageView = TTBaseUIImageView()
    
    open override func updateUI() {
        super.updateUI()
        self.setupBaseUI()
        self.setupBaseContraint()
    }
    
    fileprivate func setupBaseUI() {
        
        self.titleLabel.setMutilLine(numberOfLine: self.numberOfLineLabel, textAlignment: .left).done()
        self.panel.addSubview(self.titleLabel)
        
        switch self.type {
        case .RIGHT_IMAGE:
            self.imageRight.setCorner(withCornerRadius: self.cornerImages).done()
            self.panel.addSubview(self.imageRight)
            break
        case .LEFT_IMAGE:
            self.imageLeft.setCorner(withCornerRadius: self.cornerImages).done()
            self.panel.addSubview(self.imageLeft)
            break
        case .BOTH_IMAGE:
            self.imageRight.setCorner(withCornerRadius: self.cornerImages).done()
            self.imageLeft.setCorner(withCornerRadius: self.cornerImages).done()
            self.panel.addSubview(self.imageRight)
            self.panel.addSubview(self.imageLeft)
            break
        }
    }
    
    fileprivate func setupBaseContraint() {
        
        switch self.type {
        case .RIGHT_IMAGE:
            self.titleLabel.setVerticalContentHuggingPriority().setLeadingAnchor(self.panel, constant: self.paddingLabel.0).setTopAnchor(self.panel, constant: self.paddingLabel.1).setTrailingWithNextToView(view: self.imageRight, constant: self.paddingLabel.2).setBottomAnchor(self.panel, constant: self.paddingLabel.3).done()
            self.imageRight.setWidthAnchor(constant: self.sizeImages.0).setHeightAnchor(constant: self.sizeImages.1)
                .setTrailingAnchor(self.panel, constant: self.paddingRightImage).setcenterYAnchor(constant: 0).done()
            break
        case .LEFT_IMAGE:
            self.imageLeft.setWidthAnchor(constant: self.sizeImages.0).setHeightAnchor(constant: self.sizeImages.1)
                .setLeadingAnchor(self.panel, constant: paddingLeftImage).setTrailingWithNextToView(view: self.titleLabel, constant: self.paddingLabel.0).setcenterYAnchor(constant: 0).done()
            self.titleLabel.setVerticalContentHuggingPriority().setTopAnchor(self.panel, constant: self.paddingLabel.1).setBottomAnchor(self.panel, constant: self.paddingLabel.3).setTrailingAnchor(self.panel, constant: self.paddingLabel.2).done()
            break
        case .BOTH_IMAGE:
            self.imageLeft.setWidthAnchor(constant: self.sizeImages.0).setHeightAnchor(constant: self.sizeImages.1)
                .setLeadingAnchor(self.panel, constant: paddingLeftImage).setTrailingWithNextToView(view: self.titleLabel, constant: self.paddingLabel.0).setcenterYAnchor(constant: 0).done()
            self.titleLabel.setVerticalContentHuggingPriority().setTopAnchor(self.panel, constant: self.paddingLabel.1).setBottomAnchor(self.panel, constant: self.paddingLabel.3).setTrailingWithNextToView(view: self.imageRight, constant: self.paddingLabel.2).done()
            self.imageRight.setWidthAnchor(constant: self.sizeImages.0).setHeightAnchor(constant: self.sizeImages.1)
                .setTrailingAnchor(self.panel, constant: self.paddingRightImage).setcenterYAnchor(constant: 0).done()
            break
        }
    }
    
}
