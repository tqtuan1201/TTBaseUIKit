//
//  BaseIconCircleView.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 2/9/20.
//  Copyright © 2020 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseIconCircleView: TTBaseUICricleView {
    
    fileprivate var sizeMultiplier:CGFloat = 0.6
    
    public var iconUIImage:TTBaseUIImageFontView = TTBaseUIImageFontView(withFontIconLightSize: .user, sizeIcon: CGSize.init(width: 60, height: 60), colorIcon: UIColor.white, contendMode: .scaleAspectFill)
    
    public init(with sizeMultiplier:CGFloat = 0.6) {
        self.sizeMultiplier = sizeMultiplier
        super.init()
        self.setupBaseUIView()
    }
    
    public required init() {
        super.init()
        self.setupBaseUIView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init()
        self.setupBaseUIView()
    }
    
    fileprivate func setupBaseUIView() {
        self.backgroundColor = TTView.buttonBgDef
        
        self.addSubview(self.iconUIImage)
        
        self.iconUIImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: self.sizeMultiplier).isActive = true
        self.iconUIImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: self.sizeMultiplier).isActive = true
        self.iconUIImage.setcenterYAnchor(constant: 0).setCenterXAnchor(constant: 0).done()
    }
    
}
