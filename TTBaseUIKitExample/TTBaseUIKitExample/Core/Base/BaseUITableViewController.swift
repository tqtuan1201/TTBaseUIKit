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
    
    var lgNavType:BaseUINavigationView.TYPE { get { return .DEFAULT}}
    var backType:BaseUINavigationView.NAV_BACK = .BACK_POP
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if #available(iOS 26.0, *) {
            self.tabBarController?.tabBar.backgroundColor = UIColor.clear
        } else {
            self.tabBarController?.tabBar.backgroundColor = UIColor.white
        }
    }
    
    override init() {
        super.init()
        self.tableView = TTBaseUITableView(frame: CGRect.init(x: 0, y: 0, width: TTSize.W, height: TTSize.H), style: .plain)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async { [weak self] in guard let strongSelf = self else { return }
            guard let headerView = strongSelf.tableView.tableHeaderView else { return }
            headerView.layoutIfNeeded()
            let header = strongSelf.tableView.tableHeaderView
            strongSelf.tableView.tableHeaderView = header
        }
    }
    
    
    override func updateBaseUI() {
        super.updateBaseUI()
        self.navBar = BaseUINavigationView(withType: self.lgNavType)
        self.setDelegate()
    }
    
}


//For Base private funcs
extension BaseUITableViewController : BaseUINavigationViewDelegate{
    
    fileprivate func setDelegate() {
        if let lgNav = self.navBar as? BaseUINavigationView { lgNav.delegate = self }
    }
    
    func navDidTouchUpBackButton(withNavView nav: BaseUINavigationView) {
        self.navigationController?.popViewController(animated: true)
    }
}
