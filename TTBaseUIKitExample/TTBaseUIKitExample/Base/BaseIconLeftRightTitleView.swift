//
//  BaseIconLeftRightTitleView.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 2/8/24.
//  Copyright © 2024 Truong Quang Tuan. All rights reserved.
//

import Foundation
import TTBaseUIKit

class BaseIconLeftRightTitleView: TTBaseUIView {
    
    fileprivate var iconColor:UIColor = XView.iconColor
    fileprivate var bgImgColor:UIColor = XView.labelBgDef
    fileprivate var textColor:UIColor = XView.textDefColor
    
    fileprivate var iconLeft:AwesomePro.Light? = nil
    fileprivate var iconRight:AwesomePro.Light? = nil
    
    fileprivate var titleString:String = "Title String"
    fileprivate var subTitleString:String = "Subtitle String"
    
    open var padding:UIEdgeInsets { get { return (UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0) )}}
    
    let stackPanelView:TTBaseUIStackView = TTBaseUIStackView(axis: .horizontal, spacing: 0, alignment: .fill, distributionValue: .fill)
    
    var iconLeftView:TTUIImageFontPaddingView = TTUIImageFontPaddingView(with: .user, iconColor: UIColor.white, bgColor: UIColor.clear, paddingContent: XSize.P_CONS_DEF * 1.5)
    var iconRightView:TTUIImageFontPaddingView = TTUIImageFontPaddingView(with: .user, iconColor: XView.iconColor, bgColor: UIColor.clear,  paddingContent: XSize.P_CONS_DEF * 1.8)
    
    let panelTextView:TTBaseUIView = TTBaseUIView()
    
    let textView:TTLableSubLabelView = TTLableSubLabelView()
    
    init(with bgIcon:UIColor, iconColor:UIColor, textColor:UIColor, iconLeft:AwesomePro.Light? = nil, iconRight:AwesomePro.Light?, titleString:String, subString:String, paddingIconLeft:CGFloat = XSize.P_CONS_DEF * 1.5, paddingIconRight:CGFloat = XSize.P_CONS_DEF * 1.8 ) {
        super.init()
        
        self.iconLeftView = TTUIImageFontPaddingView(with: .user, iconColor: UIColor.white, bgColor: UIColor.clear, paddingContent: paddingIconLeft)
        self.iconRightView = TTUIImageFontPaddingView(with: .user, iconColor: UIColor.white, bgColor: UIColor.clear, paddingContent: paddingIconRight)
        
        self.iconColor = iconColor
        self.bgImgColor = bgIcon
        self.textColor = textColor
        
        self.iconLeft = iconLeft
        self.iconRight = iconRight
        
        self.titleString = titleString
        self.subTitleString = subString
        
        self.setupBaseUIView()
        self.onUpdateShowView()
    }
    
    required init() {
        super.init()
        self.setupBaseUIView()
        self.onUpdateShowView()
    }
    
    func setupBaseUIView() {

        self.setConerRadius(with: XSize.CORNER_RADIUS)
        self.setBgColor(UIColor.white)
        
        self.iconLeftView.setBgColor(self.bgImgColor)
        
        self.iconRightView.setBgColor(UIColor.clear)

        self.textView.setBgColor(UIColor.clear)
        
        self.panelTextView.addSubview(self.textView)
        self.textView.setLeadingAnchor(constant: XSize.P_CONS_DEF).setTrailingAnchor(constant: XSize.P_CONS_DEF).setcenterYAnchor(constant: 0)
        
        self.addSubview(self.stackPanelView)
        self.stackPanelView.setFullContraints(lead: padding.left, trail: padding.right, top: padding.top, bottom: self.padding.bottom)
        
        self.iconLeftView.widthAnchor.constraint(equalTo: self.iconLeftView.heightAnchor, multiplier: 1).isActive = true
        self.iconRightView.widthAnchor.constraint(equalTo: self.iconRightView.heightAnchor, multiplier: 1).isActive = true
        
        self.stackPanelView.addArrangedSubview(self.iconLeftView)
        self.stackPanelView.addArrangedSubview(self.panelTextView)
        self.stackPanelView.addArrangedSubview(self.iconRightView)
        
    }
}

extension BaseIconLeftRightTitleView {
    func onUpdateShowView() {
        
        self.textView.titleLabel.setText(text: self.titleString)
        self.textView.subLabel.setText(text: self.subTitleString)
        
        if let leftIcon = self.iconLeft {
            self.iconLeftView.imageView.setIConImage(with: leftIcon, color: self.iconColor, scale: .scaleAspectFit, size: CGSize.init(width: 45.0, height: 45.0))
        }

        if let rightIcon = self.iconRight {
            self.iconRightView.imageView.setIConImage(with: rightIcon, color: XView.iconColor, scale: .scaleAspectFit, size: CGSize.init(width: 45.0, height: 45.0))
        }
        
        if self.iconLeft == nil {
            self.iconLeftView.isHidden = true
        } else {
            self.iconLeftView.isHidden = false
        }
        if self.iconRight == nil {
            self.iconRightView.isHidden = true
        } else {
            self.iconRightView.isHidden = false
        }
    }
}
