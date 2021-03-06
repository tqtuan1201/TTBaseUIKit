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
    open var sectionFooterHeight:CGFloat { get { return  TTSize.H_FOOTER}}
    open var keyboardDismissMode:UIScrollView.KeyboardDismissMode { get { return  UIScrollView.KeyboardDismissMode.onDrag}}
    open var padding:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (0,0,0,0)}}
    open var paddingHeader:(CGFloat,CGFloat,CGFloat,CGFloat, CGFloat) { get { return (0,0,0,0,TTSize.W/1.6)}} // Lead.Top.Trail.Bottom.Height
    
    public var tableView:TTBaseUITableView = TTBaseUITableView(frame: .zero, style: .grouped)

    public override init() {
        super.init()
        self.tableView = TTBaseUITableView(frame: CGRect.init(x: 0, y: 0, width: TTSize.W, height: TTSize.H), style: self.tableStyle)
        if navType == .NO_VIEW {
            self.tableView.resetContentInset()
        } else if navType == .ONLY_STATUS {
            self.tableView.resetContentInset()
        } else if navType == .STATUS_NAV {
            self.tableView.setContentInset(inset: UIEdgeInsets(top: TTSize.H_NAV, left: 0, bottom: TTSize.P_CONS_DEF, right: 0))
        }
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
        
        //self.tableView.estimatedRowHeight       = estimatedRowHeight
        //self.tableView.rowHeight = UITableView.automaticDimension
        //self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        //self.tableView.sectionFooterHeight = UITableView.automaticDimension
        
        //self.tableView.estimatedSectionHeaderHeight = sectionHeaderHeight
        //self.tableView.estimatedSectionFooterHeight = sectionFooterHeight
        
        self.tableView.backgroundColor = self.bgTableView
        
        self.tableView.delegate                 = self
        
        self.tableView.keyboardDismissMode      = self.keyboardDismissMode
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

// MARK: For Base public funcs
extension TTBaseUITableViewController {
    
    public func removeHeaderView() {
        self.tableView.tableHeaderView = nil
    }
    
    public func addHeaderView(with headerView:TTBaseHeaderView, isFixedAnchorTop:Bool = true) {
        self.tableView.tableHeaderView = headerView
        
        if let headerView = self.tableView.tableHeaderView {
            headerView.isUserInteractionEnabled = true
            if self.paddingHeader.4 != 0 { headerView.setHeightAnchor(constant: self.paddingHeader.4).done() }
            
            let superViewTop:UIView = isFixedAnchorTop ? self.view : (headerView.superview ?? self.view)
            headerView.setLeadingAnchor(self.view,constant: self.paddingHeader.0, isApplySafeArea: false).setTopAnchor(superViewTop, constant: self.paddingHeader.1).setTrailingAnchor(self.view, constant: self.paddingHeader.2, isApplySafeArea: false, priority: .defaultHigh).done()
        }
        
        self.tableView.tableHeaderView?.layoutIfNeeded()
        self.tableView.tableHeaderView = self.tableView.tableHeaderView
        
    }
}
