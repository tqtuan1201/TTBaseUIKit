//
//  BasePanelViewUIStackView.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 6/28/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBasePanelViewUIStackView :TTBaseUIView {
    fileprivate var isSetWidthHeightBaseStack:Bool = true
    
    public var pading:(CGFloat,CGFloat,CGFloat,CGFloat) = (0,0,0,0)
    public var baseStackView:TTBaseUIStackView = TTBaseUIStackView(axis: .horizontal, spacing: TTSize.P_CONS_DEF, alignment: .center)
    open var bgPanelColor:UIColor { get { return UIColor.clear}}
    
    public init(with baseStackview:TTBaseUIStackView, padding:(CGFloat,CGFloat,CGFloat,CGFloat) = (0,0,0,0), isSetWidthHeightBaseStack:Bool = true) {
        super.init()
        self.isSetWidthHeightBaseStack = isSetWidthHeightBaseStack
        self.baseStackView = baseStackview
        self.pading = padding
        self.setupBaseUIView()
    }
    
    fileprivate func setupBaseUIView() {
        self.setBgColor(self.bgPanelColor)
        self.addSubview(baseStackView)
        if self.isSetWidthHeightBaseStack {
            self.baseStackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
            self.baseStackView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
        }
        self.baseStackView.setLeadingAnchor(constant: self.pading.0).setTopAnchor(constant: self.pading.1).setTrailingAnchor(self, constant: self.pading.2, priority: .defaultHigh).setBottomAnchor(constant: pading.3).done()
    }
    
    public required init() {
        super.init()
        self.setupBaseUIView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


