//
//  BaseScrollHorizontalUIStackView.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 2/18/21.
//  Copyright © 2021 Truong Quang Tuan. All rights reserved.
//

import Foundation

open class TTBaseScrollHorizontalUIStackView :UIScrollView {
    public var pading:(CGFloat,CGFloat,CGFloat,CGFloat) = (0,0,0,0)
    public var baseStackView:TTBaseUIStackView = TTBaseUIStackView()
    open var bgPanelColor:UIColor { get { return UIColor.clear}}
    
    open var isSetHeightContraint:Bool { get { return true } }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    @available(*, unavailable,
      message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection."
    )
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(frame: .zero)
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
        self.addSubview(baseStackView)
        if isSetHeightContraint { self.baseStackView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true }
        self.baseStackView.setLeadingAnchor(constant: self.pading.0).setTopAnchor(constant: self.pading.1).setTrailingAnchor(self, constant: self.pading.2, priority: .defaultHigh).setBottomAnchor(constant: pading.3).done()
    }
}
