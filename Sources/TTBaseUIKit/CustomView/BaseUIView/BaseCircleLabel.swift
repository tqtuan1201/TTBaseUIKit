//
//  BaseCircleLabel.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 7/9/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseCircleLabel :TTBaseUILabel {
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width/2
    }
}
