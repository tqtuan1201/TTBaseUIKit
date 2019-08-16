//
//  IconLabelNoPaddingView.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 8/15/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

///
/// This Class to view Default:
///
/// [Horizontal] - Icon UIImageFontView - Text Label
///
///
open class TTIconLabelHorizontalView: TTBaseUIView {
    
    open var sizeImages:(CGFloat,CGFloat) { get { return (TTSize.H_SMALL_ICON, TTSize.H_SMALL_ICON)}}
    open var padding:CGFloat { get { return TTSize.P_CONS_DEF}}
    open var paddingIcon:CGFloat { get { return TTSize.P_CONS_DEF}}
    open var isSetFullContentHugging:Bool { get { return false}}
    open var isSetHorizontalContentHugging:Bool { get { return false}}
    open var isSetVerticalContentHugging:Bool { get { return false}}
    
    
    public var iconImageView:TTBaseUIImageFontView = TTBaseUIImageFontView(withFontIconLightSize: .file, sizeIcon: CGSize(width: 60, height: 60), colorIcon: TTView.iconColor, contendMode: .scaleAspectFit)
    public var textLabel:TTBaseUILabel = TTBaseUILabel(withType: .TITLE, text: "Title Label", align: .left)
    
    fileprivate var textColor:UIColor = TTView.textDefColor
    fileprivate var iconColor:UIColor = TTView.iconColor
    
    public init(WithIcon nameIcon:AwesomePro.Light, text:String, color:UIColor) {
        super.init()
        self.iconColor = color
        self.textColor = color
        self.iconImageView = TTBaseUIImageFontView.init(withFontIconLightSize: nameIcon, sizeIcon: CGSize(width: 30, height: 30), colorIcon: iconColor)
        self.textLabel.setText(text: text)
        self.setupBaseUIView()
    }
    
    required public init() {
        super.init()
        self.setupBaseUIView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init()
        self.setupBaseUIView()
    }
    
}

extension TTIconLabelHorizontalView {
    fileprivate func setupBaseUIView() {
        
        self.setBgColor(UIColor.clear)
        self.textLabel.setTextColor(color: self.textColor)
        self.iconImageView.setIconColor(self.iconColor)
        
        self.textLabel.setMutilLine(numberOfLine: 4, textAlignment: .left)
        self.addSubview(self.iconImageView)
        self.addSubview(self.textLabel)
        
        self.iconImageView.setHeightAnchor(constant: sizeImages.0).setWidthAnchor(constant: sizeImages.1)
        self.iconImageView.setLeadingAnchor(constant: self.padding).setcenterYAnchor(constant: 0).setTrailingWithNextToView(view: self.textLabel, constant: self.paddingIcon)
        
        self.textLabel.setTopAnchor(constant: self.padding).setBottomAnchor(constant: self.padding).setTrailingAnchor(constant: self.padding)
        
        if self.isSetFullContentHugging { self.textLabel.setFullContentHuggingPriority() }
        
        if self.isSetHorizontalContentHugging { self.textLabel.setHorizontalContentHuggingPriority() }
        
        if self.isSetVerticalContentHugging { self.textLabel.setVerticalContentHuggingPriority() }
    }
}
