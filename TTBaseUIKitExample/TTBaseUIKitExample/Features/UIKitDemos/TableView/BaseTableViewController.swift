//
//  BaseTableViewController.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/7/24.
//  Copyright © 2024 Truong Quang Tuan. All rights reserved.
//

import TTBaseUIKit

class BaseTableViewController: BaseUITableViewController {
        
    override var lgNavType: BaseUINavigationView.TYPE { return .DETAIL}
    override var navType: TTBaseUIViewController<TTBaseUIView>.NAV_STYLE { return .STATUS_NAV}
    override var isSetHiddenTabar: Bool { return true}

    fileprivate var viewModel:BaseTableViewModel = BaseTableViewModel()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewCodable(with: [])
    }
    
}


// MARK://TTViewCodable bindViewModel
extension BaseTableViewController {
    
    func bindComponents() {
        
    }
    
    func bindViewModel() {
        
        self.viewModel.willShowLoading  = { [weak self] in guard let strongSelf = self else { return }
            DispatchQueue.main.async { strongSelf.showLoadingView(type: .TAB_TOP)}
        }
        
        self.viewModel.willRemoveLoading  = { [weak self] in guard let strongSelf = self else { return }
            DispatchQueue.main.async { strongSelf.removeLoading() ; strongSelf.refreshControl.endRefreshing(); strongSelf.tableView.isScrollEnabled = true}
        }
        
        self.viewModel.willShowMessage = { [weak self] mess in guard let strongSelf = self else { return }
            let stype:TTBaseNotificationViewConfig.NOTIFICATION_TYPE = mess.onCheckSuccess() ? .SUCCESS : .ERROR
            strongSelf.showNoticeView(body: mess.getDes(), style: stype)
        }
        
        self.viewModel.willRefreshData = { [weak self] vm in guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                
            }
        }
    }
}


// MARK://TTViewCodable Setup UIView
extension BaseTableViewController : TTViewCodable {
    
    func setupData() {
        self.navBar.setTitle(title: "BaseTableViewController".uppercased())
        self.tableView.register(TTTextSubtextIconTableViewCell.self)
        self.tableView.register(DemoTableViewCell.self)
        self.tableView.register(TTEmptyTableHeaderViewCell.self)
        self.tableView.dataSource = self
        self.tableView.setContentInset(inset: UIEdgeInsets.init(top: XSize.H_NAV, left: 0, bottom: 0, right: 0))
        
    }
    
    func setupCustomView() {
        
    }
    
    func setupStyles() {
        
    }
    
    func setupConstraints() {
        
    }
}



//MARK:// UITableViewDataSource
extension BaseTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfItemsToDisplay(session: section)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DemoTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.subLabel.setText(text: self.viewModel.getItemByIndexPath(index: indexPath) ?? "...")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let hisView:TTEmptyTableHeaderViewCell = tableView.dequeueReusableHeaderFooterCell()
        return hisView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let emptyView:TTEmptyTableHeaderViewCell = tableView.dequeueReusableHeaderFooterCell()
        return emptyView
    }
}
