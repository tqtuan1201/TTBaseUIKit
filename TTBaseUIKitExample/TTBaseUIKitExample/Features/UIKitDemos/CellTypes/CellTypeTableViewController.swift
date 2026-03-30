//
//  CellTypeTableViewController.swift
//  TTBaseUIKitExample
//
//  Created by Truong Quang Tuan on 6/8/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import TTBaseUIKit

class CellTypeTableViewController: TTListCellTestTableViewController {
    
    override var navType: TTBaseUIViewController<TTBaseUIView>.NAV_STYLE { get { return .STATUS_NAV}}
    
    override func updateBaseUI() {
        super.updateBaseUI()
        self.navBar = BaseUINavigationView(withType: .DETAIL)
        (self.navBar as! BaseUINavigationView).delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBgNav(withStatusColor: XView.viewBgNavColor, navColor: XView.viewBgNavColor)
        self.navBar.setTitle(title: "Base Table View Cells".uppercased())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
}

extension CellTypeTableViewController : BaseUINavigationViewDelegate {
    func navDidTouchUpBackButton(withNavView nav: BaseUINavigationView) {
        self.navigationController?.popViewController(animated: true)
    }
}
