//
//  PanelScrollView.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 3/24/20.
//  Copyright © 2020 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseScrollPanelNewView :UIScrollView {
    public var pading:(CGFloat,CGFloat,CGFloat,CGFloat) = (0,0,0,0)
    public var basePanelView:TTBaseUIView = TTBaseUIView()
    open var bgPanelColor:UIColor { get { return UIColor.clear}}
    
    open var isSetWidthContraint:Bool { get { return true } }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public convenience init(padding:(CGFloat,CGFloat,CGFloat,CGFloat) = (0,0,0,0)) {
        self.init(frame: .zero)
        self.pading = padding
        self.setupBaseUIView()
    }
    
    fileprivate func setupBaseUIView() {
        self.backgroundColor = self.bgPanelColor
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.translatesAutoresizingMaskIntoConstraints = false
        self.keyboardDismissMode = TTBaseUIKitConfig.getStyleConfig().dismissKeyboardScrollViewType
        self.addSubview(basePanelView)
        if isSetWidthContraint { self.basePanelView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true }
        self.basePanelView.setLeadingAnchor(constant: self.pading.0).setTopAnchor(constant: self.pading.1).setTrailingAnchor(self, constant: self.pading.2, priority: .defaultHigh).setBottomAnchor(constant: pading.3).done()
    }
}

extension TTBaseScrollPanelNewView {
    
}
