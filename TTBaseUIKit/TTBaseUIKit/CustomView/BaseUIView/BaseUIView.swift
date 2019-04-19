//
//  TTBaseUIView.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/8/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//


import Foundation

import Foundation
import UIKit

open class TTBaseUIView: UIView, ViewDrawer {
    
    var viewDefBgColor: UIColor = TTBaseUIKitConfig.getViewConfig().viewDefColor
    var viewDefCornerRadius: CGFloat = TTBaseUIKitConfig.getSizeConfig().CORNER_RADIUS
    
    open func updateUI() { }
    
    public required init() {
        super.init(frame: .zero)
        self.viewDefCornerRadius = 0
        self.setupUI()
        self.updateUI()
    }
    
    public convenience init(withCornerRadius radio:CGFloat) {
        self.init(); self.setCorner(withCornerRadius: radio)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.viewDefCornerRadius = 0
        self.setupUI()
        self.updateUI()
    }
    
    private func setupUI() {
        self.drawView()
    }
   
}

extension TTBaseUIView {
    
    public func setCorner(withCornerRadius conner:CGFloat) {
        self.viewDefCornerRadius = conner
        self.drawView()
    }
    
    public func setBgColor(_ color:UIColor) {
        self.backgroundColor = color
    }
    
}

