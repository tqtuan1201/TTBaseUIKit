//
//  LineView.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/15/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//
import UIKit
import Foundation
///
/// This Class to create line View
///
/// easy create line
///
/// ( -Line- )
///
open class TTLineView: TTBaseUIView {
    
    var bgColor:UIColor = TTBaseUIKitConfig.getViewConfig().lineColor
    
    override open func updateBaseUIView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.viewDefBgColor = bgColor
        self.drawView()
    }
    
}

extension TTLineView {
    public func setLineColor(_ color:UIColor) {
        self.setBgColor(color)
    }
}
