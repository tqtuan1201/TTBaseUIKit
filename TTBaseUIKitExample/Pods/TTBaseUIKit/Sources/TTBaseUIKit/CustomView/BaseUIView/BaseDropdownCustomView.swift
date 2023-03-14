//
//  BaseDropdownCustomView.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 8/17/22.
//  Copyright © 2022 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit
///
/// This Class to create Dropdown View
///
/// Label view content with icon right
///
/// PanelView( -Lable-Icon )
///
open class TTDropdownCustomView :TTBaseUIView {
    
    public enum TYPE {
        case DEFAULT
        case PADDING
    }

    open var padding:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (TTSize.P_CONS_DEF * 2, TTSize.P_CONS_DEF,TTSize.P_CONS_DEF * 2,TTSize.P_CONS_DEF )}}
    open var iconSize:CGSize { get { return .init(width: TTSize.H_SMALL_ICON / 2 , height: TTSize.H_SMALL_ICON / 2)}}
    open var borderColor:UIColor { get { return TTView.lineDefColor.withAlphaComponent(0.6)}}
    open var bgColor:UIColor { get { return UIColor.white}}
    open var borderHeight:CGFloat { get { return TTSize.H_LINEVIEW}}
    open var heightDef:CGFloat { get { return TTSize.H_BUTTON + TTSize.P_CONS_DEF}}
    
    public var textLabel:TTBaseUILabel = TTBaseUILabel.init(withType: .TITLE, text: "Text description", align: .left)
    public var iconView:TTBaseUIImageView = TTBaseUIImageView.init(imageName: "iconArrowDown", contentMode: .scaleAspectFit)
    
    fileprivate var type:TYPE = .DEFAULT
    fileprivate var typeButtom:TTBaseUIButton.TYPE = .DEFAULT
    fileprivate var textButtomString:String = "BUTTON"
    open func updateButtonPanelView() { }
    
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.addBorder(borderColor: self.borderColor, borderHeight: self.borderHeight)
    }
    
    public init(withTextToDisplay text:String, icon:String) {
        super.init()
        self.textLabel.setText(text: text)
        self.iconView.setImage(with: icon, scale: .scaleAspectFit)
        self.setupBaseUIView()
        
    }
    
    required public init() {
        super.init()
        self.setupBaseUIView()
    }
    
    
}

extension TTDropdownCustomView  {
    
    fileprivate func setupBaseUIView() {
        
        self.addSubviews(views: [self.textLabel, self.iconView])
        self.setConerDef()
        self.setBgColor(self.bgColor)
        
        self.textLabel.setMutilLine(numberOfLine: 0, textAlignment: .left, mode: .byTruncatingTail)
        self.textLabel.setVerticalContentHuggingPriority()
            .setLeadingAnchor(constant: self.padding.0).setTopAnchor(constant: self.padding.1)
            .self.setTrailingWithNextToView(view: self.iconView, constant: TTSize.P_CONS_DEF * 1.4)
            .setBottomAnchor(constant: self.padding.3)
        
        self.iconView.setWidthAnchor(constant: self.iconSize.width).setHeightAnchor(constant: self.iconSize.height)
            .setTrailingAnchor(constant: self.padding.2)
            .setcenterYAnchor(constant: 0)
        
        self.textLabel.setTextColor(color: TTView.textDefColor)
        self.iconView.setIconColor(TTView.iconColor)
        
        self.heightAnchor.constraint(greaterThanOrEqualToConstant: self.heightDef).isActive = true
        
    }
}
