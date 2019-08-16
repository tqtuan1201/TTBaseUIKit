//
//  ImageLabelVerView.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/18/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

///
/// This Class to view Default:
///
/// [Horizontal] - Icon UIImageFontView - Text InsetLabel
///
///
open class TTIconLabelView : TTBaseUIView {
    
    open var multiplierImage:CGFloat { get { return 0.5}}
    open var padding:CGFloat { get { return TTSize.P_CONS_DEF}}
    open var numberOfLine:Int { get { return 4}}
    open var isSetContentHugging:Bool { get { return true}}
    open var sizeImages:(CGFloat,CGFloat) { get { return (TTSize.H_SMALL_ICON, TTSize.H_SMALL_ICON)}}
    
    
    public var iconImageView:TTBaseUIImageFontView = TTBaseUIImageFontView(withFontIconLightSize: .file, sizeIcon: CGSize(width: 60, height: 60), colorIcon: TTView.iconColor, contendMode: .scaleAspectFit)
    public var textLabel:TTBaseInsetLabel = TTBaseInsetLabel(withType: .TITLE, text: "Text Label", align: .left)
    
    fileprivate var textColor:UIColor = TTView.textDefColor
    fileprivate var iconColor:UIColor = TTView.iconColor
    fileprivate var isAutoHeightSizing:Bool = true
    
    public init(WithIcon nameIcon:AwesomePro.Light, text:String, color:UIColor, isAutoHeightSizing:Bool = true) {
        super.init()
        self.iconColor = color
        self.textColor = color
        self.isAutoHeightSizing = isAutoHeightSizing
        self.iconImageView = TTBaseUIImageFontView.init(withFontIconLightSize: nameIcon, sizeIcon: CGSize(width: 30, height: 30), colorIcon: iconColor)
        self.textLabel.setText(text: text)
        self.setupBaseUIView()
    }
    
    public init(withShowImageRight nameIcon:AwesomePro.Light, label:TTBaseUILabel, iconColor:UIColor, textColor:UIColor, isAutoHeightSizing:Bool = true) {
        super.init()
        self.iconColor = iconColor
        self.textColor = textColor
        self.isAutoHeightSizing = isAutoHeightSizing
        self.iconImageView = TTBaseUIImageFontView.init(withFontIconLightSize: nameIcon, sizeIcon: CGSize(width: 30, height: 30), colorIcon: iconColor)
        self.setupBaseUIView()
    }
    
    public init(withLabel label:TTBaseInsetLabel, isAutoHeightSizing:Bool = true) {
        super.init()
        self.isAutoHeightSizing = isAutoHeightSizing
        self.textLabel = label
        self.setupBaseUIView()
    }
    
    public init(withShowImageRight nameIcon:AwesomePro.Light, iconColor:UIColor, isAutoHeightSizing:Bool = true) {
        super.init()
        self.isAutoHeightSizing = isAutoHeightSizing
        self.iconColor = iconColor
        self.iconImageView = TTBaseUIImageFontView.init(withFontIconLightSize: nameIcon, sizeIcon: CGSize(width: 30, height: 30), colorIcon: iconColor)
        self.setupBaseUIView()
    }
    
    public required init() {
        super.init()
        self.setupBaseUIView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func setData(icon:AwesomePro.Light, text:String) {
        self.iconImageView.setIConImage(with: icon.rawValue).done()
        self.textLabel.setText(text: text)
    }
    
    public func setColor(with icon:UIColor, text:UIColor) {
        self.iconImageView.setIconColor(icon)
        self.textLabel.setTextColor(color: text)
    }
}

fileprivate extension TTIconLabelView {
    
    
    func setupBaseUIView() {
        
        self.textLabel.setTextColor(color: self.textColor)
        self.iconImageView.setIconColor(self.iconColor)
        
        self.textLabel.setMutilLine(numberOfLine: self.numberOfLine, textAlignment: .left)
        self.addSubview(self.iconImageView)
        self.addSubview(self.textLabel)
        
        self.iconImageView.setHeightAnchor(constant: sizeImages.0).setWidthAnchor(constant: sizeImages.1)
        self.iconImageView.setLeadingAnchor(constant: self.padding).setcenterYAnchor(constant: 0).setTrailingWithNextToView(view: self.textLabel, constant: self.padding)
        
        self.textLabel.setTopAnchor(constant: self.padding, priority: .defaultHigh).setBottomAnchor(constant: self.padding, priority: .defaultHigh).setTrailingAnchor(constant: self.padding)
        
        if self.isAutoHeightSizing {
            if self.isSetContentHugging { self.textLabel.setFullContentHuggingPriority() }
        } else {
            if self.isSetContentHugging { self.textLabel.setHorizontalContentHuggingPriority() }
        }
        
    }
    
}

// MARK:// For Base funcs
extension TTIconLabelView {
    @discardableResult public func setTextIcon(with icon:AwesomePro.Light, label:String) -> TTIconLabelView{
        self.iconImageView.setIConImage(with: icon)
        self.textLabel.setText(text: label)
        return self
    }
}
