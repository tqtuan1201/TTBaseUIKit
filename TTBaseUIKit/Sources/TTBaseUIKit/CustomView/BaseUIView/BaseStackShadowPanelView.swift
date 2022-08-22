//
//  BaseStackShadowPanelView.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 9/16/20.
//  Copyright © 2020 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseStackShadowPanelView :TTBaseShadowPanelView {
    
    open var connerDef:CGFloat { get { return TTSize.CORNER_RADIUS } }
    open var pading:(CGFloat,CGFloat,CGFloat,CGFloat) { return   (TTSize.P_CONS_DEF, TTSize.P_CONS_DEF, TTSize.P_CONS_DEF, TTSize.P_CONS_DEF) }
    public var baseStackView:TTBaseUIStackView = TTBaseUIStackView(axis: .horizontal, spacing: TTSize.P_CONS_DEF, alignment: .fill)
    
    open var bgPanelColor:UIColor { get { return UIColor.white}}
    
    public init(with baseStackview:TTBaseUIStackView) {
        super.init()
        self.baseStackView = baseStackview
        self.setupBaseUIView()
    }
    
    fileprivate func setupBaseUIView() {
        self.setBgColor(self.bgPanelColor)
        self.panelShadowView.addSubview(baseStackView)
        self.baseStackView.setLeadingAnchor(constant: self.pading.0).setTopAnchor(constant: self.pading.1).setTrailingAnchor(constant: self.pading.2).setBottomAnchor(constant: pading.3).done()
        self.panelShadowView.setConerRadius(with: self.connerDef)
    }
    
    public required init() {
        super.init()
        self.setupBaseUIView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

