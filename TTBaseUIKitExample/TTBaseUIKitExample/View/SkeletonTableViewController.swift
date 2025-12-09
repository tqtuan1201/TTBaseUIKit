//
//  SkeletonTableViewController.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 24/11/25.
//  Copyright © 2025 Truong Quang Tuan. All rights reserved.
//

import Foundation
import Foundation
import TTBaseUIKit

class SkeletonTableViewController: BaseUITableViewController {
    
    override var navType: TTBaseUIViewController<TTBaseUIView>.NAV_STYLE { get { return .STATUS_NAV}}
    override var lgNavType: BaseUINavigationView.TYPE { get { return .DETAIL}}
    
    fileprivate var dataTest:[String] = ["","","","","","","","","","","","","",""] {
        didSet { self.tableView.reloadAsyncData() }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    

    private func setupUI(){
        self.navBar = BaseUINavigationView(withType: .DETAIL)
        self.navBar.setTitle(title: "Skeleton Animation (UIKIT)".uppercased())
        self.tableView.register(TTTextSubtextIconTableViewCell.self)
        self.tableView.register(TTEmptyTableHeaderViewCell.self)
        self.tableView.dataSource = self
    }
}



extension SkeletonTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.dataTest.isEmpty {
            self.tableView.setStaticBgNoData(title: "NO DATA", des: "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making ") {
                print("Touch handle!!!!")
            }
        }
        return 1//viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataTest.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TTTextSubtextIconTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setSkeletonAnimation().onStartSkeletonCustomViewAnimation(withDef: XSize.H / 2, width: XSize.W)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let empty:TTEmptyTableHeaderViewCell = tableView.dequeueReusableHeaderFooterCell()
        return empty
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let empty:TTEmptyTableHeaderViewCell = tableView.dequeueReusableHeaderFooterCell()
        return empty
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

import SwiftUI
struct SkeletonTableViewController_Previews: PreviewProvider {
    static var previews: some View {
        TTBaseUIViewControllerPreview {
            let vc = SkeletonTableViewController()
            return vc
        }
    }
}
