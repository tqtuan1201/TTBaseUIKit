//
//  ListCellTestTableViewController.swift
//  TTBaseUIKitExample
//
//  Created by Truong Quang Tuan on 6/7/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import TTBaseUIKit


class ListCellTestTableViewController: BaseUITableViewController {
    
    override var tableStyle: UITableView.Style { get { return .plain}}
    
    let arrays: [UITableViewCell.Type] = [
        TTTextIconTableViewCell.self,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewCodable(with: [])
    }
    
}

// For Base funcs
extension ListCellTestTableViewController : TTViewCodable {
    
    func setupCustomView() {
        self.navBar.setTitle(title: "LIST CELL FOR VIEW")
    }
    
    func setupData() {
        
        self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "UITableViewHeaderFooterView")
        
        self.tableView.register(TTEmptyTableHeaderViewCell.self)
        for (index, cell) in arrays.enumerated() {
            self.tableView.register(cell, forCellReuseIdentifier: "CELL_\(index)")
        }
        
        
        self.tableView.dataSource = self
        
    }
    
}



// MARK: For Cell -  UITableViewDataSource
extension ListCellTestTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrays.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL_\(indexPath.row)", for: indexPath)
        cell.backgroundView = nil
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let nameCell:UITableViewHeaderFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "UITableViewHeaderFooterView") as! UITableViewHeaderFooterView
        return nameCell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let empty:TTEmptyTableHeaderViewCell = tableView.dequeueReusableHeaderFooterCell()
        return empty
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nameString = self.arrays[indexPath.row].description()
        self.showAlert(nameString)
        UIPasteboard.general.string = nameString
    }
    
}
