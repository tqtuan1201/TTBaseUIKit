//
//  TTBaseUIView.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/8/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//
import Foundation
import UIKit

open class TTBaseUIImageView: UIImageView, ViewDrawer {
    
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

    public convenience init(withCornerRadius radio:CGFloat, imageName:String, contentMode:UIView.ContentMode) {
        self.init()
        self.setCorner(withCornerRadius: radio)
        self.image = UIImage(named: imageName)
        self.contentMode = contentMode
    }

    public convenience init(imageName:String, contentMode:UIView.ContentMode) {
        self.init()
        self.image = UIImage(named: imageName)
        self.contentMode = contentMode
    }
    
    public convenience init(with imageName:String) {
        self.init()
        self.image = UIImage(named: imageName)
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.viewDefCornerRadius = 0
        self.setupUI()
        self.updateUI()
    }
    
    private func setupUI() {
        self.drawView()
        self.image =  UIImage(fromTTBaseUIKit: "img.NoImage.png")
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
    }
    
}

extension TTBaseUIImageView {
    
    public func setCorner(withCornerRadius conner:CGFloat) {
        if conner == 0 { return }
        self.viewDefCornerRadius = conner
        self.drawView()
    }
    
    public func setBgColor(_ color:UIColor) {
        self.backgroundColor = color
    }
    
}

