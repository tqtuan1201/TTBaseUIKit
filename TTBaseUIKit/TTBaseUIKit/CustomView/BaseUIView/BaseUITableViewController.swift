//
//  BaseUITableViewController.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/19/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseUITableViewController: TTBaseUIViewController<TTBaseUIView>, UITableViewDelegate {

    open var bgTableView:UIColor { get { return  UIColor.clear}}
    open var tableStyle:UITableView.Style { get { return  UITableView.Style.grouped}}
    open var estimatedRowHeight:CGFloat { get { return  TTSize.H_CELL}}
    open var sectionHeaderHeight:CGFloat { get { return  TTSize.H_HEADER}}
    open var estimatedSectionFooterHeight:CGFloat { get { return  TTSize.H_FOOTER}}
    open var keyboardDismissMode:UIScrollView.KeyboardDismissMode { get { return  UIScrollView.KeyboardDismissMode.onDrag}}
    open var padding:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (0,0,0,0)}}
    
    public var tableView:TTBaseUITableView = TTBaseUITableView(frame: .zero, style: .grouped)

    public override init(isAddNavBar: Bool = true) {
        super.init(isAddNavBar: isAddNavBar)
    }
    
    convenience init(withShowNavBar isShow:Bool = true, stype:UITableView.Style = .grouped) {
        self.init(isAddNavBar: isShow)
        self.tableView = TTBaseUITableView(frame: .zero, style: stype)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        TTBaseFunc.shared.printLog(with: "Release memory for ", object: self.description)
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupBaseView()
        self.setupBaseConstraint()
    }

    private func setupBaseView() {
        
        self.tableView.separatorStyle           = .none
        self.tableView.estimatedRowHeight       = estimatedRowHeight
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionHeaderHeight = sectionHeaderHeight
        self.tableView.sectionFooterHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionFooterHeight = estimatedSectionFooterHeight
        self.tableView.backgroundColor = self.bgTableView
        
        self.tableView.delegate                 = self
        
        self.tableView.keyboardDismissMode      = .onDrag
        self.view.insertSubview(self.tableView, at: 0)
        
    }
    
    private func setupBaseConstraint() {
        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.padding.1).isActive = true
        if #available(iOS 11.0, *) {
            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant:  self.padding.0).isActive = true
        } else {
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant:  self.padding.0).isActive = true
        }
        if #available(iOS 11.0, *) {
            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant:  self.padding.0).isActive = true
        } else {
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant:  self.padding.2).isActive = true
        }
        self.tableView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor, constant:  self.padding.3).isActive = true
    }

    
}
