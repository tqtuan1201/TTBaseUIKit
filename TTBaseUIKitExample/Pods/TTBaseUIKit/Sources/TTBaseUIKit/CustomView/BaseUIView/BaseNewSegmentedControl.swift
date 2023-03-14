//
//  BaseNewSegmentedControl.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 4/11/20.
//  Copyright © 2020 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseNewSegmentedControl: UISegmentedControl {
    
    open var textColor:UIColor { get { return TTView.textDefColor }}
    open var textSelectedColor:UIColor { get { return TTView.textWarringColor }}
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    public override init(items: [Any]?) {
        super.init(items: items)
        self.setupUI()
    }
    
    required public init?(coder: NSCoder) {
        super.init(items: [])
        self.setupUI()
    }
    
    public var onTouchHandler:((_ seg:TTBaseNewSegmentedControl, _ indexSelected:Int) -> Void)?
    
}

// MARK: For private base funcs
extension TTBaseNewSegmentedControl {
    
    fileprivate func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: textSelectedColor], for: .selected)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: textColor], for: .normal)
        self.selectedSegmentIndex = 0
        self.addTarget(self, action: #selector(self.selectionDidChange(_:)), for: .valueChanged)
        
    }
 
    @objc fileprivate func selectionDidChange(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        self.setSelectedIndex(with: index)
        self.onTouchHandler?(self, index)
    }
    
}

// MARK: For public base funcs
extension TTBaseNewSegmentedControl {
        
    public func setSelectedIndex(with index:Int) {
        self.selectedSegmentIndex = index
    }
}
