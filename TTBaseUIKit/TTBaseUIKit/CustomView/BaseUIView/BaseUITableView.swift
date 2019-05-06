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
            self.contentInset = UIEdgeInsets(top: TTSize.H_NAV, left: 0, bottom: TTSize.P_CONS_DEF, right: 0)
        }

    }
}

extension TTBaseUITableView {
    
    public func reloadAsyncData() {
        DispatchQueue.main.async { [weak self] in self?.reloadData() }
    }
    
    public func reloadAsyncRows(with indexs:[IndexPath], animation:RowAnimation = RowAnimation.automatic) {
        DispatchQueue.main.async { [weak self] in guard let strongSelf = self else { return }
            for index in indexs { if strongSelf.cellForRow(at: index) != nil { strongSelf.reloadRows(at: [index], with: animation) } }
        }
    }
    
    public func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = self.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    
    public func setContentInset( inset:UIEdgeInsets) {
        self.contentInset = inset
    }
    public func resetContentInset() {
        self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
