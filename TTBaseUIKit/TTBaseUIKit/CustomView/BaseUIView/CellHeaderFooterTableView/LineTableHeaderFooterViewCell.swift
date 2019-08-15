//
//  BaseLineTableHeaderFooterViewCell.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 8/15/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTLineTableHeaderFooterViewCell: TTBaseUITableViewHeaderFooterView {
    
    open var spaceColor:UIColor { get { return TTView.lineDefColor.withAlphaComponent(0.5) }}
    open var spaceHeight:CGFloat { get { return TTSize.H_LINEVIEW * 2 }}
    open var spacePadding:CGFloat { get { return TTSize.P_CONS_DEF * 3 }}
    open var cellHeight:CGFloat { get { return TTSize.P_CONS_DEF }}
    public let spaceView:TTBaseUIView = TTBaseUIView()
    
    override open func updateUI() {
        super.updateUI()
        
        self.spaceView.setBgColor(self.spaceColor)
        self.panel.addSubview(self.spaceView)
        
        self.spaceView.setLeadingAnchor(constant: self.spacePadding).setTrailingAnchor(constant: self.spacePadding)
            .setHeightAnchor(constant: self.spaceHeight)
            .setcenterYAnchor(constant: 0)
        
        self.panel.setHeightAnchor(constant: self.cellHeight, priority: .defaultHigh)
    }
    
}

