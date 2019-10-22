//
//  TTBaseShadowView.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 10/22/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseShadowView: TTBaseUIView {
    
    open var bgShadown:UIColor { get { return UIColor.darkGray.withAlphaComponent(0.4) }}
    open var shadowHeight:CGFloat { get { return TTSize.P_CONS_DEF / 2 } }
    open var paddingNewPanel:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (TTSize.P_CONS_DEF,0,TTSize.P_CONS_DEF,TTSize.P_CONS_DEF)}}

    public lazy var newPanelView:TTBaseUIView = TTBaseUIView()
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if self.layer.shadowPath == nil {
            self.layer.backgroundColor = UIColor.clear.cgColor
            self.layer.shadowColor = self.bgShadown.cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: self.shadowHeight )
            self.layer.shadowOpacity = 0.2
            self.layer.shadowRadius = 3.0
        }
    }
    
    open override func updateBaseUIView() {
        super.updateBaseUIView()
        self.setupBaseShadowView()
    }
}

extension TTBaseShadowView {

    public func setupBaseShadowView() {
        self.addSubview(self.newPanelView)
        self.newPanelView.setFullContraints(lead: self.paddingNewPanel.0, trail: self.paddingNewPanel.2, top: self.paddingNewPanel.1, bottom: self.paddingNewPanel.3)
    }
}
