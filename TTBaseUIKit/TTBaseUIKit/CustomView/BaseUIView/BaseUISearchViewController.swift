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
    
    public var searchBar:UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = UIColor.white
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.tintColor = TTView.textDefColor
        searchBar.layer.shadowOpacity = 0
        searchBar.layer.borderWidth = 0
        searchBar.layer.borderColor = UIColor.clear.cgColor
        searchBar.layer.masksToBounds = false
        searchBar.placeholder = "Search Text"
        var textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = TTView.textDefColor
        return searchBar
    }()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.setupBaseUIView()
        self.setupBaseConstraints()
    }
    
    
}

extension TTBaseUISearchViewController {
    
    fileprivate func setupBaseUIView() {
        self.setStatusBgColor(color: UIColor.white)
        self.view.addSubview(self.searchBar)
    }
    
    fileprivate func setupBaseConstraints() {
        self.searchBar.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 0).isActive = true
        self.searchBar.heightAnchor.constraint(equalToConstant: TTSize.H_SEARCH_BAR).isActive = true
        self.searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        self.searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
    }
}
