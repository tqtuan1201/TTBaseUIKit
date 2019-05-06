//
//  TTUIImageCircleView.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/30/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTUIImageCircleView :TTBaseUIImageView, CircleDrawer, BorderDrawer {
    var borderDefColor: UIColor = UIColor.white
    var borderDefWidth: CGFloat = TTSize.H_BORDER
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.drawCircle()
        if borderDefWidth != 0 { self.drawBorder() }
    }
    
   public convenience init(withBorder size:CGFloat, color:UIColor) {
        self.init()
        self.borderDefColor = color
        self.borderDefWidth = size
        self.updateUI()
    }

}

