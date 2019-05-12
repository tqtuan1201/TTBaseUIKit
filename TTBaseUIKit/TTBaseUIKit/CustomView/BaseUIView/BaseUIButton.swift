//
//  BaseUIButton.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/11/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseUIButton: UIButton, ViewDrawer, TextDrawer {
    
    var viewDefBgColor: UIColor = TTBaseUIKitConfig.getViewConfig().buttonBgDef
    var viewDefCornerRadius: CGFloat = TTBaseUIKitConfig.getSizeConfig().CORNER_RADIUS
    var textDefColor: UIColor = UIColor.white
    var textDefHeight: CGFloat = TTBaseUIKitConfig.getFontConfig().TITLE_H
    var textDefIsUpper: Bool = true
    var fontDef: UIFont  = TTBaseUIKitConfig.getFontConfig().FONT
   
    public enum TYPE {
        case DEFAULT
        case ICON
        case DISABLE
        case WARRING
    }
    
    var type:TYPE = .DEFAULT
    
    
    public var onTouchHandler:((_ button:TTBaseUIButton) -> Void)?
    
    public convenience init(textString text:String = "", type:TYPE = .DEFAULT, isSetSize:Bool = false) {
        self.init(frame: .zero)
        self.type = type
        switch type {
        case .DEFAULT:
            self.setDefaultType()
            break
        case .ICON:
            self.setDefaultType()
        break
        case .DISABLE:
            self.setNonEnable()
            break
        case .WARRING:
            self.setWarringType().done()
            break
        }
        self.setText(text: text).done()
        if isSetSize { self.setWidthAnchor(constant: TTBaseUIKitConfig.getSizeConfig().W_BUTTON).setHeightAnchor(constant: TTBaseUIKitConfig.getSizeConfig().H_BUTTON).done() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.setupTargets()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
        self.setupTargets()
    }
    
    private func setupTargets(){
        self.addTarget(self, action: #selector(self.onTouch(_:)), for: .touchUpInside)
    }
    
    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 8, right: 8)
        self.drawView()
        self.drawButton()
    }
    
    @objc private func onTouch(_ sender:UIButton) {
        self.onTouchHandler?(self)
        self.shakeAnimation(x: 1, y: 1, duration: 0.7)
    }
}

extension TTBaseUIButton {
    
    public func setDefaultType() {
        self.isUserInteractionEnabled = true
        self.backgroundColor = viewDefBgColor
    }
    
    public func setWarringType() -> TTBaseUIButton {
        self.isUserInteractionEnabled = true
        self.setTextColor(color: UIColor.white).setBgColor(color: TTBaseUIKitConfig.getViewConfig().buttonBgWar).done()
        return self
    }
    
    public func setEnable() -> TTBaseUIButton {
        self.isUserInteractionEnabled = true
        self.backgroundColor = viewDefBgColor.withAlphaComponent(1)
        return self
    }
    
    public func setNonEnable() {
        self.backgroundColor = viewDefBgColor.withAlphaComponent(0.5)
        self.isUserInteractionEnabled = false
    }
    
    public func setImage(imageNameString:String, color:UIColor) {
        self.setText(text: "").done()
        self.setImage(UIImage(named: imageNameString), for: .normal)
        self.backgroundColor = UIColor.clear
        self.tintColor = color
        self.imageView?.contentMode = .scaleAspectFit
    }
    
    public func resetBorderCorner() -> TTBaseUIButton {
        self.layer.cornerRadius    = 0
        self.clipsToBounds         = false
        return self
    }

    public func setHidden() -> TTBaseUIButton {
        self.setTitle("", for: .normal)
        self.isHidden = true
        return self
    }
    
    public func setNonHidden() -> TTBaseUIButton {
        self.isHidden = false
        return self
    }
    
    public func setTextAligment(alignment:UIControl.ContentHorizontalAlignment = .center) -> TTBaseUIButton {
        self.contentHorizontalAlignment = alignment
        return self
    }
    
    public func setText(text:String) -> TTBaseUIButton {
        self.setTitle(text, for: .normal)
        return self
    }
    
    public func setTextColor(color:UIColor) -> TTBaseUIButton {
        self.setTitleColor(color, for: UIControl.State.normal)
        return self
    }
    
    public func setBgColor(color:UIColor) -> TTBaseUIButton {
        self.viewDefBgColor  = color
        self.backgroundColor = color
        return self
    }
    
    public func setText(text:String,textColor:UIColor,bgColor:UIColor, alignment:UIControl.ContentHorizontalAlignment = .center) {
        self.setText(text: text).setTextColor(color: textColor).setTextAligment(alignment: alignment).done()
    }
    
    public func setFullContentHuggingPriority() -> TTBaseUIButton {
        self.setHorizontalContentHuggingPriority().setVerticalContentHuggingPriority().done()
        return self
    }
    
    public func setHorizontalContentHuggingPriority() -> TTBaseUIButton {
        self.setContentHuggingPriority( UILayoutPriority.required, for: .horizontal)
        self.setContentCompressionResistancePriority(  UILayoutPriority.required, for: .horizontal)
        return self
    }
    
    public func setVerticalContentHuggingPriority() -> TTBaseUIButton {
        self.setContentHuggingPriority( UILayoutPriority.required, for: .vertical)
        self.setContentCompressionResistancePriority(  UILayoutPriority.required, for: .vertical)
        return self
    }
    
    
}
