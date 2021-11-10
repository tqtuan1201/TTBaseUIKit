//
//  BaseScrollUIStackView.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 5/13/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseScrollUIStackView :UIScrollView {
    public var pading:(CGFloat,CGFloat,CGFloat,CGFloat) = (0,0,0,0)
    public var baseStackView:TTBaseUIStackView = TTBaseUIStackView()
    open var bgPanelColor:UIColor { get { return UIColor.clear}}
    
    open var isSetWidthContraint:Bool { get { return true } }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public convenience init(with baseStackview:TTBaseUIStackView, padding:(CGFloat,CGFloat,CGFloat,CGFloat) = (0,0,0,0)) {
        self.init(frame: .zero)
        self.baseStackView = baseStackview
        self.pading = padding
        self.setupBaseUIView()
    }
    
    fileprivate func setupBaseUIView() {
        self.backgroundColor = self.bgPanelColor
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.translatesAutoresizingMaskIntoConstraints = false
        self.keyboardDismissMode = TTBaseUIKitConfig.getStyleConfig().dismissKeyboardScrollViewType
        self.addSubview(baseStackView)
        if isSetWidthContraint { self.baseStackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true }
        self.baseStackView.setLeadingAnchor(constant: self.pading.0).setTopAnchor(constant: self.pading.1).setTrailingAnchor(self, constant: self.pading.2, priority: .defaultHigh).setBottomAnchor(constant: pading.3).done()
    }
}

extension TTBaseScrollUIStackView {
    
}
