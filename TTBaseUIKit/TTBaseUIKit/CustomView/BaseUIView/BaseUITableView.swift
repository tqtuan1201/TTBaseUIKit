//
//  TTBaseUITableView.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/19/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseUITableView: UITableView {
    
    public var bgColor:UIColor = UIColor.clear
    public var isShowScrollIndicator:Bool = false
    public var isSetContentInset:Bool = true
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.setupBaseUI()
    }
    
    
    public convenience init(style: UITableView.Style, bgColor:UIColor, isShowCroll:Bool, isSetContent:Bool) {
        self.init(frame: .zero, style: style)
        self.bgColor = bgColor
        self.isShowScrollIndicator = isShowCroll
        self.isSetContentInset = isSetContent
        self.setupBaseUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupBaseUI() {

        self.showsVerticalScrollIndicator = self.isShowScrollIndicator
        self.showsHorizontalScrollIndicator = self.isShowScrollIndicator
        self.backgroundColor = self.bgColor
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if isSetContentInset {
            self.contentInset = UIEdgeInsets(top: TTSize.H_NAV - TTSize.P_CONS_DEF, left: 0, bottom: TTSize.P_CONS_DEF, right: 0)
        }

    }
}
