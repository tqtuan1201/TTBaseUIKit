//
//  SlideImageCollectionViewCell.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 8/15/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTSlideImageCollectionViewCell : TTBaseUICollectionViewCell {
    
    open override var bgColor: UIColor { get { return UIColor.clear }}
    open override var padding: CGFloat { get { return 0.0 }}
    
    open var paddingImage:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (0,0,0,0)}}
    
    public let bgImage:TTBaseUIImageView = TTBaseUIImageView(withCornerRadius: TTSize.CORNER_RADIUS)
    
    override open func updateUI() {
        super.updateUI()
        self.setupBaseUIView()
        self.setupBaseContraints()
    }
    
}

extension TTSlideImageCollectionViewCell {
    
    fileprivate func setupBaseUIView() {
        self.panel.addSubview(self.bgImage)
    }
    
    fileprivate func setupBaseContraints() {
        self.bgImage.setFullContraints(lead: self.paddingImage.0, trail: self.paddingImage.2, top: self.paddingImage.1, bottom: self.paddingImage.3)
    }
}

