//
//  MenuViewController.swift
//  TTBaseUIKitExample
//
//  Created by Truong Quang Tuan on 6/7/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import TTBaseUIKit

struct MenuFuction {
    let name:String
    let des:String
    let image:String = ""
    
    
    static func getAll() -> [MenuFuction] {
        var menus:[MenuFuction] = []
        menus.append(MenuFuction(name: "TableViewCell", des: "View all custom tableviewcell type"))
        menus.append(MenuFuction(name: "Messase Alter", des: "Same push notification by ios"))
        menus.append(MenuFuction(name: "POPUP_VIEW", des: "show popup alter view"))
        menus.append(MenuFuction(name: "PRESENT_VC", des:"Cover vertical animation transition"))
        menus.append(MenuFuction(name: "DATE_PICKER", des: "Choose date time from popup"))
        menus.append(MenuFuction(name: "EMPTY_TABLE", des: "Set background for uitableview when empty data"))
        menus.append(MenuFuction(name: "TEST_VIEW", des: "View all base views"))
        return menus
    }
}




class MenuViewController: BaseUITableViewController {
    
    override var navType: TTBaseUIViewController<TTBaseUIView>.NAV_STYLE { get { return .STATUS_NAV}}
    
    fileprivate let menu:[MenuFuction] = MenuFuction.getAll()
    fileprivate let headerView = DemoHeaderView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        guard let window = UIApplication.shared.keyWindow else { return }
        let noti:TTBaseNotificationViewConfig = TTBaseNotificationViewConfig(with: window)
        noti.setText(with: "WELCOME ^^", subTitle: "Just demo little element ui with write by  programmatically swift")
        noti.type = .NOTIFICATION_VIEW
        noti.touchType = .SWIPE
        noti.notifiType = .SUCCESS
        noti.onShow()

    }
    
    private func setupUI(){
        
        self.addHeaderView(with: headerView,isFixedAnchorTop: false)
        
        self.tableView.register(TTIconTextSubtextTableViewCell.self)
        self.tableView.register(TTEmptyTableHeaderViewCell.self)
        self.tableView.dataSource = self
    }
}



extension MenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let empty:TTEmptyTableHeaderViewCell = tableView.dequeueReusableHeaderFooterCell()
        return empty
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let empty:TTEmptyTableHeaderViewCell = tableView.dequeueReusableHeaderFooterCell()
        return empty
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menu = self.menu[indexPath.row]
        let cell:TTIconTextSubtextTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.titleLabel.setText(text: menu.name.uppercased())
        cell.subLabel.setText(text: menu.des)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menu = self.menu[indexPath.row]
        if menu.name == "TableViewCell" {
            self.navigationController?.pushViewController(CellTypeTableViewController(), animated: true)
        } else if menu.name == "Messase Alter" {
            let messageView = ShowMessageViewController()
            messageView.didSelectType = { type in
                guard let window = UIApplication.shared.keyWindow else { return }
                let noti:TTBaseNotificationViewConfig = TTBaseNotificationViewConfig(with: window)
                noti.setText(with: "WELCOME ^^", subTitle: "Just demo little ele")
                noti.type = .NOTIFICATION_VIEW
                noti.positionType = type
                noti.notifiType = .SUCCESS
                if type == .TOP {
                    noti.contentViewType = .ICON_TEXT_BUTTON
                } else if type == .CENTER {
                    noti.contentViewType = .ICON_TEXT
                } else {
                    noti.contentViewType = .TEXT
                }
                noti.onShow()
                noti.getCurrentNotifi.buttonRight.setText(text: "Right Button")
            }
            self.present(messageView, animated: true)
        } else if menu.name == "POPUP_VIEW" {
            
            let popupVC = TTPopupViewController(title: "SOMETHING LIKE THIS", subTitle: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has b", isAllowTouchPanel: true)
            self.present(popupVC, animated: true)
            
        } else if menu.name == "PRESENT_VC" {
            let vc = CoverPresentViewController()
            self.present(vc, animated: true)
            
        } else if menu.name == "DATE_PICKER" {
            
            let vc = DatePickerViewController()
            self.present(vc, animated: true)
            
        } else if menu.name == "EMPTY_TABLE" {
            let emptyVC = EmptyTableViewController()
            self.navigationController?.pushViewController(emptyVC, animated: true)
        } else if menu.name == "TEST_VIEW" {
            self.navigationController?.pushViewController(TestViewController(), animated: true)
        } else if menu.name == "" {
            
        }
    }
    
}
