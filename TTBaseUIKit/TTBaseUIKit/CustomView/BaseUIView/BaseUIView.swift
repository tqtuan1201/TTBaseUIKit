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
    
    
    fileprivate lazy var startLocations : [NSNumber] = [-1.0,-0.5, 0.0]
    fileprivate lazy var endLocations : [NSNumber] = [1.0,1.5, 2.0]
    
    fileprivate lazy var gradientBackgroundColor : CGColor = UIColor(white: 0.85, alpha: 1.0).cgColor
    fileprivate lazy var gradientMovingColor : CGColor = UIColor(white: 0.75, alpha: 1.0).cgColor
    
    fileprivate lazy var movingAnimationDuration : CFTimeInterval = 0.8
    fileprivate lazy var delayBetweenAnimationLoops : CFTimeInterval = 1.0
    

    open func updateBaseUIView() { }
    public var onTouchHandler:((_ view:TTBaseUIView) -> Void)?
    
    public required init() {
        super.init(frame: .zero)
        self.viewDefCornerRadius = 0
        self.setupUI()
        self.updateBaseUIView()
    }
    
    public convenience init(withCornerRadius radio:CGFloat) {
        self.init(); self.setCorner(withCornerRadius: radio)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.viewDefCornerRadius = 0
        self.setupUI()
        self.updateBaseUIView()
    }
    
    private func setupUI() {
        self.drawView()
    }
    
    @objc private func onTouchView(_ sender:UITapGestureRecognizer) {
        self.onTouchHandler?(self)
    }
   
}

extension TTBaseUIView {
    
    @discardableResult public func setTouchHandler() -> TTBaseUIView {
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onTouchView(_:))))
        return self
    }
    
    public func setCorner(withCornerRadius conner:CGFloat) {
        self.viewDefCornerRadius = conner
        self.drawView()
    }
    
    public func setBgColor(_ color:UIColor) {
        self.viewDefBgColor = color
        self.backgroundColor = color
    }
    
}


extension TTBaseUIView {
    
}
