//
//  BaseUIStackView.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/13/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseUIStackView: UIStackView {
    
    open var axisContraint:NSLayoutConstraint.Axis = .vertical
    open var spacingContraint:CGFloat = TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF
    open var alignmentContraint:UIStackView.Alignment = .center
    open var distributionValue:UIStackView.Distribution = .equalSpacing
    

    public override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setupUI()
    }
    
    public convenience init(axis:NSLayoutConstraint.Axis, spacing:CGFloat, alignment:UIStackView.Alignment, distributionValue:UIStackView.Distribution = .equalSpacing) {
        self.init(frame: .zero)
        self.axisContraint = axis
        self.spacingContraint = spacing
        self.alignmentContraint = alignment
        self.distributionValue = distributionValue
        self.setupUI()
    }
    
    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.axis          = self.axisContraint
        self.spacing       = self.spacingContraint
        self.alignment     = self.alignmentContraint
        self.distribution  = self.distributionValue
        
        self.setAutoresizingMaskIntoConstraints().done()
        
    }
}

extension TTBaseUIStackView {
    /**
     * @discussion UIStackView is a non-rendering element, and as such, it does not get drawn on the screen. This means that changing backgroundColor essentially does nothing. If you want to change the background color, just add a UIView to it as a subview (that is not arranged)
     * @param color: set color for view
     */
    public func setBackgroundColorByView(color: UIColor, conerRadius:CGFloat = 0) {
        if let bgView = self.viewWithTag(CONSTANT.TAG_VIEW.BG_UISTACKVIEW.rawValue) { bgView.backgroundColor = color; return }
        let subView = UIView(frame: bounds)
        subView.tag = CONSTANT.TAG_VIEW.BG_UISTACKVIEW.rawValue
        subView.setConerRadius(with: conerRadius)
        subView.isUserInteractionEnabled = false
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
