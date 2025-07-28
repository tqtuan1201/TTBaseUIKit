//
//  LogTrackingTableViewController.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 9/11/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class LogTrackingTableViewController: TTBaseUITableViewController {
    
    fileprivate var logs = LogViewHelper.share.getLogs()
    
    override open var navType: TTBaseUIViewController<TTBaseUIView>.NAV_STYLE { get { return .NO_VIEW}}
    
    fileprivate let backButton:TTBaseUIButton = TTBaseUIButton(textString: "BACK", type: .DEFAULT, isSetSize: false)
    fileprivate let titleLabel:TTBaseUILabel =  TTBaseUILabel(withType: .TITLE, text: "Everything you need for real-time UI inspection, logging, and network analysis", align: .left)
    fileprivate let panelView:TTBaseUIView = TTBaseUIView()
    
    
    let webView:TTBaseWKWebView =  TTBaseWKWebView()
    
    public var didTouchTitleLabelHandle:( (_ request:String) -> ())?
    public var didTouchSubLabelHandle:( (_ response:String) -> ())?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI(){
        
        self.view.addSubview(self.panelView)
        
        self.panelView.addSubview(self.backButton)
        self.panelView.addSubview(self.titleLabel)
        
        self.titleLabel.setTextColor(color: TTView.textWarringColor)
        
        self.backButton.setLeadingAnchor(constant: TTSize.P_CONS_DEF).setTrailingWithNextToView(view: self.titleLabel, constant: TTSize.P_CONS_DEF * 2.5)
            .setBottomAnchor(constant: TTSize.P_CONS_DEF)
            .setHeightAnchor(constant: 35).setWidthAnchor(constant: TTSize.H_CELL)
            .setTopAnchor(constant: TTSize.H_STATUS + TTSize.P_CONS_DEF)
        
        self.titleLabel.setTopAnchor(constant: TTSize.P_CONS_DEF + TTSize.H_STATUS).setBottomAnchor(constant: TTSize.P_CONS_DEF)
            .setTrailingAnchor(constant: TTSize.P_CONS_DEF)
        
        self.panelView.setLeadingAnchor(constant: 0).setTrailingAnchor(constant: 0)
            .setTopAnchor(constant: 0)
        
        self.tableView.contentInset.top = 70
        
        self.tableView.register(TTEmptyTableHeaderViewCell.self)
        self.tableView.register(TTTextTableHeaderFooterViewCell.self)
        
        self.tableView.register(LogTrackingTableViewCell.self)
        
        
        self.tableView.dataSource = self
        
        
        self.backButton.onTouchHandler = { [weak self] _ in guard let strongSelf = self else { return }
            strongSelf.dismiss(animated: true, completion: {
                
            })
        }
    }
}



extension LogTrackingTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let empty:TTEmptyTableHeaderViewCell = tableView.dequeueReusableHeaderFooterCell()
        return empty
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.logs.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let text:TTTextTableHeaderFooterViewCell = tableView.dequeueReusableHeaderFooterCell()
        text.titleLabel.setMutilLine(numberOfLine: 0, textAlignment: .left, mode: .byTruncatingTail)
        text.titleLabel.setBold().setText(text: logs[section].getDisplayService())
        return text
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:LogTrackingTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let log = self.logs[indexPath.section]
        cell.titleLabel.setText(text: log.request)
        cell.subLabel.setText(text: log.response)
        
        cell.titleLabel.setTouchHandler().onTouchHandler = { _ in
            UIPasteboard.general.string = log.request
            self.didTouchTitleLabelHandle?(log.request)
            self.present(LogTrackingWebViewController(), animated: true, completion: nil)
        }
        
        cell.subLabel.setTouchHandler().onTouchHandler = { _ in
            UIPasteboard.general.string = log.response
            self.didTouchSubLabelHandle?(log.response)
            self.present(LogTrackingWebViewController(), animated: true, completion: nil)
        }
        
        return cell
    }
    
}
