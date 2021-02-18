//
//  DismissView.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 5/30/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation

open class TTDismissView: TTBaseUIView {
    fileprivate var width:CGFloat = TTSize.W_DISSMISS_LINESPACE_PRESENTVIEW
    fileprivate var height:CGFloat = TTSize.H_DISSMISS_LINESPACE_PRESENTVIEW
    
    public init(width:CGFloat, height:CGFloat) {
        super.init()
        self.width = width
        self.height = height
        self.updateBaseUIView()
    }
    
    public required init() {
        super.init()
        self.updateBaseUIView()
    }
    
    open override func updateBaseUIView() {
        super.updateBaseUIView()
        self.setupBaseUIView()
    }
    
    fileprivate func setupBaseUIView() {
        let spaceView:TTBaseUIView = TTBaseUIView(withCornerRadius: TTSize.CORNER_RADIUS)
        self.addSubview(spaceView)
        spaceView.setBgColor(TTView.dismissPresentLineBgview)
        spaceView.setHeightAnchor(constant: self.height).setWidthAnchor(constant: self.width).setcenterYAnchor(constant: 0).setCenterXAnchor(constant: 0)
        self.setBgColor(TTView.dismissPresentBgview)
    }
}

