//
//  BaseTitlePanelView.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 9/16/20.
//  Copyright © 2020 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseTitlePanelView: TTBaseUIView {
    
    public var titleLabel:TTBaseUILabel = TTBaseUILabel(withType: .HEADER, text: "Title Description", align: .left)
    public var lineView:TTLineView = TTLineView()
    public var iconRight:TTBaseUIImageFontView = TTBaseUIImageFontView(withFontIconLightSize: .angleDoubleDown, sizeIcon: CGSize(width: 24.0, height: 24.0), colorIcon: TTView.iconColor, contendMode: .scaleAspectFit)
    
    public var panelContentView:TTBaseUIView = TTBaseUIView()
    
    open var paddingTitleView:UIEdgeInsets { get { return UIEdgeInsets.init(top: TTSize.P_CONS_DEF, left: TTSize.P_CONS_DEF, bottom: TTSize.P_CONS_DEF, right: TTSize.P_CONS_DEF)}}
    open var paddingPanelView:UIEdgeInsets { get { return UIEdgeInsets.init(top: TTSize.P_CONS_DEF, left: TTSize.P_CONS_DEF, bottom: TTSize.P_CONS_DEF, right: TTSize.P_CONS_DEF)}}
    
    open var paddingLeadTrailLine:CGFloat { get { return TTSize.P_CONS_DEF }}
    open var minimumHeightBodyView:CGFloat { get { return TTSize.H_BUTTON }}
    open var conerRadius:CGFloat { get { return TTSize.CORNER_RADIUS }}
    open var lineBg:UIColor { get { return TTView.lineDefColor }}
    open var bgColor:UIColor { get { return .white }}
    
    open func updatePannelContentView() { }
    
    public convenience init(withTitle title:String, isBold:Bool = true) {
        self.init()
        if isBold { self.titleLabel.setBold() }
        self.titleLabel.setText(text: title)
    }
    
    public override func updateBaseUIView() {
        super.updateBaseUIView()
        self.setupViewCodable(with: [self.titleLabel, self.lineView, self.iconRight, self.panelContentView])
        self.updatePannelContentView()
    }
    
    
    public func setWarningStype() {
        self.setBorder(with: 1.0, color: TTView.labelBgWar.withAlphaComponent(0.8), coner: TTSize.CORNER_RADIUS)
        self.setBgColor(UIColor.getColorFromHex(netHex: 0xfdfafb))
    }
    
    public func setNormalStype() {
        self.setConerRadius(with: self.conerRadius)
        self.setBgColor(self.bgColor)
    }
    
    public func setNoConerStype() {
        self.lineView.isHidden = true
        self.iconRight.isHidden = true
        self.setConerRadius(with: 0)
        self.titleLabel.setBgColor(.clear)
        self.backgroundColor = .clear
    }
}

extension  TTBaseTitlePanelView :TTViewCodable {

    public func setupStyles() {
        self.setConerRadius(with: TTSize.CORNER_RADIUS)
        self.panelContentView.setBgColor(.clear)
    }
    
    public func setupConstraints() {
        self.titleLabel.setVerticalContentHuggingPriority()
            .setLeadingAnchor(constant: self.paddingTitleView.left).setTrailingWithNextToView(view: self.iconRight, constant: self.paddingTitleView.right)
            .setTopAnchor(constant: self.paddingTitleView.top)
        
        self.lineView.setTopAnchorWithAboveView(nextToView: self.titleLabel, constant: self.self.paddingTitleView.bottom)
            .setHeightAnchor(constant: 1)
            .setLeadingAnchor(constant: self.paddingLeadTrailLine).setTrailingAnchor(constant: self.paddingLeadTrailLine)
        
        self.panelContentView.setTopAnchorWithAboveView(nextToView: self.lineView, constant: self.paddingPanelView.top)
            .setLeadingAnchor(constant: self.paddingPanelView.left).setTrailingAnchor(constant: self.paddingPanelView.right)
            .setBottomAnchor(constant: self.paddingPanelView.bottom)
            .heightAnchor.constraint(greaterThanOrEqualToConstant: self.minimumHeightBodyView).isActive = true
        
        self.iconRight.setWidthAnchor(constant: TTSize.H_ICON - TTSize.P_CONS_DEF).setHeightAnchor(constant:TTSize.H_ICON  - TTSize.P_CONS_DEF)
            .setTopAnchor(constant: TTSize.P_CONS_DEF).setTrailingAnchor(constant: 0)
    }
}
