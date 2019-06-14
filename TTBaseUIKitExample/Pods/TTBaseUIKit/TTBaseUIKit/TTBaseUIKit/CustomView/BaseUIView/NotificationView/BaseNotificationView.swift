//
//  TTBaseNotificationView.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 5/17/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseNotificationView: TTBaseUIView {
    
    
    public lazy var panelStackView:TTBaseUIStackView = TTBaseUIStackView(axis: .horizontal, spacing: TTSize.P_CONS_DEF, alignment: .center, distributionValue: .fillProportionally)
    public lazy var iconView:TTBaseUIImageFontView =  TTBaseUIImageFontView(withFontIconLightSize: .checkCircle, sizeIcon: CGSize(width: 50, height: 50), colorIcon: UIColor.white, contendMode: .scaleAspectFit)
    public lazy var titleLabel:TTBaseUILabel = TTBaseUILabel(withType: .TITLE, text: "Notification", align: .left)
    public lazy var subLabel:TTBaseUILabel = TTBaseUILabel(withType: .SUB_TITLE, text: "Notifi descriptions", align: .left)
    public lazy var buttonRight:TTBaseUIButton = TTBaseUIButton(textString: "OK", type: .WARRING, isSetSize: false)
    public lazy var panelView:TTBaseUIView = TTBaseUIView()
    
    fileprivate var padding:(CGFloat,CGFloat,CGFloat,CGFloat) = (0,0,0,0)
    fileprivate var bgColorNotifi:UIColor = UIColor.red
    fileprivate var bgPanelView:UIColor = UIColor.clear
    
    fileprivate var isAutoVerticalSize:Bool = false
    
    convenience init(withPadding padding:(CGFloat,CGFloat,CGFloat,CGFloat), bgColorNotifi:UIColor, bgPanelView:UIColor, isAutoVerticalSize:Bool) {
        self.init()
        self.padding = padding
        self.bgColorNotifi = bgColorNotifi
        self.bgPanelView = bgPanelView
        self.isAutoVerticalSize = isAutoVerticalSize
        self.setupBaseUIView()
        self.setupBaseContraints()
    }
    
    fileprivate func setupBaseUIView() {
        self.tag = CONSTANT.TAG_VIEW.NOTIFICATION_VIEW.rawValue
        self.backgroundColor = self.bgPanelView
        self.panelStackView.setBackgroundColorByView(color: bgColorNotifi, conerRadius: padding.0 != 0 ? TTSize.CORNER_RADIUS : 0)
        self.iconView.backgroundColor = UIColor.clear
        
        
        self.titleLabel.setMutilLine(numberOfLine: self.isAutoVerticalSize ? 2 : 1, textAlignment: .left).done()
        self.subLabel.setMutilLine(numberOfLine: self.isAutoVerticalSize ? 8 : 3, textAlignment: .left).done()
        
        self.titleLabel.setText(text: "What is Lorem Ipsum?").setTextColor(color: UIColor.white).done()
        self.subLabel.setText(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen bookLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book").setTextColor(color: UIColor.white).done()
        
        let spaceLeadView:TTBaseUIView = TTBaseUIView()
        let spacetrailingView:TTBaseUIView = TTBaseUIView()
        
        self.panelView.setBgColor(UIColor.clear)
        
        self.panelView.addSubview(titleLabel)
        self.panelView.addSubview(subLabel)
        
        self.panelStackView.addArrangedSubview(spaceLeadView)
        self.panelStackView.addArrangedSubview(iconView)
        self.panelStackView.addArrangedSubview(panelView)
        self.panelStackView.addArrangedSubview(buttonRight)
        self.panelStackView.addArrangedSubview(spacetrailingView)
        
        self.addSubview(panelStackView)
        
    }
    
    
    fileprivate func setupBaseContraints() {
        
        self.titleLabel.setVerticalContentHuggingPriority().setLeadingAnchor(constant: 0).setTopAnchor(constant: 0).setTrailingAnchor(constant: 0).done()
        self.subLabel.setVerticalContentHuggingPriority().setLeadingAnchor(constant: 0).setTopAnchorWithAboveView(nextToView: titleLabel, constant: TTSize.P_CONS_DEF / 4).setTrailingAnchor(constant: 0).setBottomAnchor(constant: 0).done()
        
        self.iconView.setWidthAnchor(constant: TTSize.NOTIFI_ICON_HEIGHT).setHeightAnchor(constant: TTSize.NOTIFI_ICON_HEIGHT).done()
        self.buttonRight.setVerticalContentHuggingPriority().setHorizontalContentHuggingPriority().done()
        
        self.panelStackView.setFullContraints(lead: self.padding.0, trail: self.padding.2, top: self.padding.1, bottom: self.padding.3)
        
        if self.isAutoVerticalSize {
            self.panelView.setTopAnchor(panelStackView, constant: TTSize.P_CONS_DEF, priority: .defaultHigh).setBottomAnchor(panelStackView, constant: TTSize.P_CONS_DEF, priority: .defaultHigh).done()
        } else {
            self.panelStackView.setHeightAnchor(constant: TTSize.NOTIFI_HEIGHT).done()
        }
    }
}

extension TTBaseNotificationView {
    public func setHiddenIcon() { self.iconView.isHidden = true }
    public func setHiddenButton() { self.buttonRight.isHidden = true }
}
