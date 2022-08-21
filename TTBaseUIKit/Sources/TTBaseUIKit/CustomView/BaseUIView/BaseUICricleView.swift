//
//  BaseCricleUIView.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 5/1/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseUICricleView :TTBaseUIView, CircleDrawer, BorderDrawer {
    
    var borderDefColor: UIColor = UIColor.white
    var borderDefWidth: CGFloat = 0
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.drawCircle()
        if borderDefWidth != 0 { self.drawBorder() }
    }
    
    public convenience init(withBorder size:CGFloat, color:UIColor) {
        self.init()
        self.borderDefColor = color
        self.borderDefWidth = size
    }
    
}

extension TTBaseUICricleView {
    public func setBorder(with size:CGFloat, color:UIColor) {
        self.borderDefColor = color
        self.borderDefWidth = size
    }
}

