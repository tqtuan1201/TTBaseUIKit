//
//  BaseHeaderView.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/27/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation

open class TTBaseHeaderView: TTBaseUIView {
    open var bgColor:UIColor { get { return UIColor.white }}
    
    open override func updateBaseUIView() {
        self.setBgColor(bgColor)
    }
}
