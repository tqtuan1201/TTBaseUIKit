//
//  ListCellTestTableViewController.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/27/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

public class TTListCellTestTableViewController: TTBaseUITableViewController {
    
    override open var tableStyle: UITableView.Style { get { return .grouped}}
    
    let arrays: [UITableViewCell.Type] = [
        TTTextIconTableViewCell.self,
        TTTextSubtextIconTableViewCell.self,
        TTIconTextSubtextTableViewCell.self,
        TTIconTextSubtextTextSubTextRightTableViewCell.self
    ]
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewCodable(with: [])
    }
    
}

// For Base funcs
extension TTListCellTestTableViewController : TTViewCodable {
    
    public func setupCustomView() {
        self.navBar.backgroundColor = UIColor.black
        self.statusBar.backgroundColor = UIColor.black
        self.statusBar.backgroundColor = UIColor.black
    }
    
    public func setupData() {

        self.tableView.register(TTSpaceTableHeaderViewCell.self)
        self.tableView.register(TTEmptyTableHeaderViewCell.self)
        for (index, cell) in arrays.enumerated() {
            self.tableView.register(cell, forCellReuseIdentifier: "CELL_\(index)")
        }
        
        
        self.tableView.dataSource = self
        
    }
    
}



// MARK: For Cell -  UITableViewDataSource
extension TTListCellTestTableViewController: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrays.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL_\(indexPath.row)", for: indexPath)
        cell.backgroundView = nil
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let space:TTSpaceTableHeaderViewCell = tableView.dequeueReusableHeaderFooterCell()
        return space
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
