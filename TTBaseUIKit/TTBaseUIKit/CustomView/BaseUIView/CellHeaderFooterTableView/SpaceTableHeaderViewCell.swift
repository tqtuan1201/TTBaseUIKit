//
//  SpaceTableHeaderViewCell.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/26/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTSpaceTableHeaderViewCell: TTBaseUITableViewHeaderFooterView {
    
    open var heightPanel:CGFloat { get { return TTSize.H_CELL_HEADER_SPACE } }
    public var heightAnchorPanel:NSLayoutConstraint?
    
    open override func updateUI() {
        self.heightAnchorPanel = self.panel.heightAnchor.constraint(equalToConstant: self.heightPanel)
        self.heightAnchorPanel?.priority = UILayoutPriority.defaultHigh
        self.heightAnchorPanel?.isActive = true
    }
}

open class TTEmptyTableHeaderViewCell: TTBaseUITableViewHeaderFooterView {
    public var heightAnchorPanel:NSLayoutConstraint?
    open override var backgroundViewColor: UIColor {get {return UIColor.red} }
    
    open override func updateUI() {
        
        heightAnchorPanel = self.panel.heightAnchor.constraint(equalToConstant: 0.1)
        heightAnchorPanel?.priority = UILayoutPriority.defaultHigh
        heightAnchorPanel?.isActive = true
        
        self.panel.backgroundColor = UIColor.clear
        self.textLabel?.frame.size.height = 0
        self.detailTextLabel?.frame.size.height = 0
        self.textLabel?.isHidden = true
        self.detailTextLabel?.isHidden = true
        self.isHidden = true
    }

}

extension TTEmptyTableHeaderViewCell {
    func setPanelColor(color:UIColor) {
        self.alpha = 1
        self.backgroundColor = color
        self.panel.backgroundColor = color
    }
}
