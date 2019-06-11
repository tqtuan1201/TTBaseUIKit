//
//  BaseUITableViewController.swift
//  TTBaseUIKitExample
//
//  Created by Truong Quang Tuan on 6/7/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import TTBaseUIKit

class BaseUITableViewController: TTBaseUITableViewController {
    
    override var navType: TTBaseUIViewController<TTBaseUIView>.NAV_STYLE { get { return .STATUS_NAV}}
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async { [weak self] in guard let strongSelf = self else { return }
            guard let headerView = strongSelf.tableView.tableHeaderView else { return }
            headerView.layoutIfNeeded()
            let header = strongSelf.tableView.tableHeaderView
            strongSelf.tableView.tableHeaderView = header
        }
    }
    
    override init() {
        super.init()
        self.navBar = BaseUINavigationView(withType: .DEFAULT)
        if let nav = self.navBar as? BaseUINavigationView  {nav.delegate = self }
        self.tableView = TTBaseUITableView(frame: CGRect.init(x: 0, y: 0, width: XSize.W, height: XSize.H), style: .grouped)
    }
    
    convenience init(withNav nav:BaseUINavigationView, stype:UITableView.Style = .grouped) {
        self.init()
        self.navBar = nav
        if let nav = self.navBar as? BaseUINavigationView  {nav.delegate = self }
        self.tableView = TTBaseUITableView(frame: CGRect.init(x: 0, y: 0, width: XSize.W, height: XSize.H), style: stype)
    }
    
    convenience init(stype:UITableView.Style = .grouped) {
        self.init()
        if let nav = self.navBar as? BaseUINavigationView  {nav.delegate = self }
        self.tableView = TTBaseUITableView(frame: CGRect.init(x: 0, y: 0, width: XSize.W, height: XSize.H), style: stype)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//For Base private funcs
extension BaseUITableViewController : BaseUINavigationViewDelegate{
    func navDidTouchUpBackButton(withNavView nav: BaseUINavigationView) {
        self.navigationController?.popViewController(animated: true)
    }
}
