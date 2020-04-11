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
    var viewDefCornerRadius: CGFloat = TTBaseUIKitConfig.getSizeConfig().CORNER_BUTTON
    var textDefColor: UIColor = UIColor.white
    var textDefHeight: CGFloat = TTBaseUIKitConfig.getFontConfig().TITLE_H
    var textDefIsUpper: Bool = true
    var fontDef: UIFont  = TTBaseUIKitConfig.getFontConfig().FONT
   
    public lazy var skeletonMarkView:TTBaseSkeletonMarkView = TTBaseSkeletonMarkView()
    
    public enum TYPE {
        case NO_BG_COLOR
        case DEFAULT
        case ICON
        case DISABLE
        case BORDER
        case WARRING
    }
    
    var type:TYPE = .DEFAULT
    
    open func updateBaseUIButtonView() { }
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
            self.setWarringType()
            break
        case .NO_BG_COLOR:
            self.setNoBgType()
        case .BORDER:
            self.setBorderType()
        }
        
        self.setText(text: text).done()
        if isSetSize { self.setWidthAnchor(constant: TTBaseUIKitConfig.getSizeConfig().W_BUTTON).setHeightAnchor(constant: TTBaseUIKitConfig.getSizeConfig().H_BUTTON).done() }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.setupTargets()
        self.updateBaseUIButtonView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
        self.setupTargets()
        self.updateBaseUIButtonView()
    }
    
    private func setupTargets(){
        self.addTarget(self, action: #selector(self.onTouch(_:)), for: .touchUpInside)
    }
    
    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentEdgeInsets = UIEdgeInsets(top: TTSize.P_CONS_DEF, left: TTSize.P_CONS_DEF, bottom: TTSize.P_CONS_DEF, right: TTSize.P_CONS_DEF)
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

    public func setNoBgType() {
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.clear
        self.setTextColor(color: TTView.textDefColor)
    }

    public func setBorderType() {
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.white
        self.setBorder(with: TTSize.H_BORDER, color: TTView.buttonBorderColor, coner: TTSize.CORNER_BUTTON)
    }
    
    @discardableResult public func setWarringType() -> TTBaseUIButton {
        self.isUserInteractionEnabled = true
        self.setTextColor(color: UIColor.white).setBgColor(color: TTBaseUIKitConfig.getViewConfig().buttonBgWar).done()
        return self
    }
    
    @discardableResult public func setEnable() -> TTBaseUIButton {
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
    
    @discardableResult public func resetBorderCorner() -> TTBaseUIButton {
        self.layer.cornerRadius    = 0
        self.clipsToBounds         = false
        return self
    }

    @discardableResult public func setHidden() -> TTBaseUIButton {
        self.setTitle("", for: .normal)
        self.isHidden = true
        return self
    }
    
    @discardableResult public func setNonHidden() -> TTBaseUIButton {
        self.isHidden = false
        return self
    }
    
    public func setTextAligment(alignment:UIControl.ContentHorizontalAlignment = .center) -> TTBaseUIButton {
        self.contentHorizontalAlignment = alignment
        return self
    }
    
    @discardableResult public func setText(text:String) -> TTBaseUIButton {
        self.setTitle(text, for: .normal)
        return self
    }
    
    @discardableResult public func setTextColor(color:UIColor) -> TTBaseUIButton {
        self.setTitleColor(color, for: UIControl.State.normal)
        return self
    }
    
    @discardableResult public func setBgColor(color:UIColor) -> TTBaseUIButton {
        self.viewDefBgColor  = color
        self.backgroundColor = color
        return self
    }
    
    public func setIconImage(iconName:AwesomePro.Light, color:UIColor, padding:CGFloat = TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF) {
        self.setText(text: "").done()
        self.setImage(UIImage.fontAwesomeIconWithName(nameString: iconName.rawValue, size: CGSize(width: 70, height: 70), iconColor: color, backgroundColor: UIColor.clear) , for: .normal)
        self.backgroundColor = UIColor.clear
        self.tintColor = color
        self.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        self.imageView?.contentMode = .scaleAspectFit
    }
    
    public func setText(text:String,textColor:UIColor,bgColor:UIColor, alignment:UIControl.ContentHorizontalAlignment = .center) {
        self.setText(text: text).setTextColor(color: textColor).setTextAligment(alignment: alignment).done()
    }
    
    @discardableResult public func setFullContentHuggingPriority() -> TTBaseUIButton {
        self.setHorizontalContentHuggingPriority().setVerticalContentHuggingPriority().done()
        return self
    }
    
    @discardableResult public func setHorizontalContentHuggingPriority() -> TTBaseUIButton {
        self.setContentHuggingPriority( UILayoutPriority.required, for: .horizontal)
        self.setContentCompressionResistancePriority(  UILayoutPriority.required, for: .horizontal)
        return self
    }
    
    @discardableResult public func setVerticalContentHuggingPriority() -> TTBaseUIButton {
        self.setContentHuggingPriority( UILayoutPriority.required, for: .vertical)
        self.setContentCompressionResistancePriority(  UILayoutPriority.required, for: .vertical)
        return self
    }
    
    public func setEnableWithDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in guard let strongSelf = self else { return }
            strongSelf.isUserInteractionEnabled = true
            strongSelf.backgroundColor = strongSelf.viewDefBgColor.withAlphaComponent(1)
        }
    }
    
}


//MARK:// Skeleton
extension TTBaseUIButton {
    
    public func onAddSkeletonMark() {
        if self.viewWithTag(CONSTANT.TAG_VIEW.BUTTON_SKELETON.rawValue) != nil { return }
        self.addSubview(self.skeletonMarkView)
        self.skeletonMarkView.tag = CONSTANT.TAG_VIEW.BUTTON_SKELETON.rawValue
        self.addSubview(self.skeletonMarkView)
        self.skeletonMarkView.setFullContraints(constant: 0)
    }
    
    public func onRemoveSkeletonMark() {
        UIView.animate(withDuration: 0.2, animations: {
            self.skeletonMarkView.alpha = 0
        }) { (isComplete) in
            self.skeletonMarkView.removeFromSuperview()
        }
    }
    
}
