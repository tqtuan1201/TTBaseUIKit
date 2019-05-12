//
//  BaseUISearchViewController.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 5/6/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseUISearchViewController : TTBaseUITableViewController {

    open override var navType: TTBaseUIViewController<TTBaseUIView>.NAV_STYLE { get { return .ONLY_STATUS}}
    
    public var searchBar:TTBaseSearchBar = TTBaseSearchBar(withType: .DEF, textPlaceHolder: "Please input text")

    override open func viewDidLoad() {
        super.viewDidLoad()
        self.setupBaseUIView()
        self.setupBaseConstraints()
    }
    
    
}

extension TTBaseUISearchViewController {
    
    fileprivate func setupBaseUIView() {
        self.tableView.setContentInset(inset: UIEdgeInsets.init(top: TTSize.H_SEARCH_BAR , left: 0, bottom: TTSize.P_CONS_DEF, right: 0))
        self.setStatusBgColor(color: UIColor.white)
        self.view.addSubview(self.searchBar)
    }
    
    fileprivate func setupBaseConstraints() {
        self.searchBar.setTopAnchorWithAboveView(nextToView: self.statusBar, constant: 0).done()
        self.searchBar.heightAnchor.constraint(equalToConstant: TTSize.H_SEARCH_BAR).isActive = true
        self.searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        self.searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
    }
}
