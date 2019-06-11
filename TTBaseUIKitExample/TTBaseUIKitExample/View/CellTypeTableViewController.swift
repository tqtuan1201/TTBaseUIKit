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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.title = "CELL LIST"
    }
}
