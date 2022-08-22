//
//  BaBaseGradientUIImageView.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 8/7/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit
open class TTBaseGradientUIImageView :TTBaseUIImageView {
    
    fileprivate var gradientLayer:CAGradientLayer = {
        let layer = CAGradientLayer()
        return layer
    }()
    
    fileprivate var colors:[CGColor] = [TTView.labelBgWar.withAlphaComponent(0.2).cgColor, TTView.labelBgDef.withAlphaComponent(0.6).cgColor]
    
    public init(with colors:[CGColor]) {
        super.init()
        self.colors = colors
        self.setupBaseUIView()
    }
    
    public init(withColor colors:[CGColor], imageName:String) {
        super.init()
        self.colors = colors
        self.image = UIImage(named: imageName)
        self.setupBaseUIView()
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        super.init()
        self.setupBaseUIView()
    }
    
    public required init() {
        super.init()
        self.setupBaseUIView()
    }
    
    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        self.gradientLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    }
    
    fileprivate func setupBaseUIView() {
        self.gradientLayer.colors = self.colors
        self.layer.addSublayer(gradientLayer)
    }
    
}
