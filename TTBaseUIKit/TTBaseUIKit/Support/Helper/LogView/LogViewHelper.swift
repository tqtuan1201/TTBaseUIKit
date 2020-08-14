//
//  LogViewHelper.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 9/11/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class LogViewHelper {
    
    fileprivate var viewModel:LogTrackingViewModel = LogTrackingViewModel()
    
    public static let share = LogViewHelper()
    private let concurrentQueue = DispatchQueue(label: "ConcurrentQueue", attributes: .concurrent, target: nil)
    
    private  init(){}
    
    public var didTouchLogButtonHandle:( () -> ())?
    public var didTouchReportlHandle:( () -> ())?
    public var didTouchSettinglHandle:( () -> ())?
    
    public func config(withDes des:String, isStartAppToShow:Bool) -> LogViewHelper {
        self.viewModel.displayString =  des
        self.viewModel.isStartAppToShow =  isStartAppToShow
        return self
    }
    
}

//MARK:// For Base Funcs
extension LogViewHelper {
    
    public func getLogs() -> [LogViewModel] {
        var logs: [LogViewModel] = []
        self.concurrentQueue.sync {  // reading always has to be sync!
          logs = self.viewModel.logs.reversed()
        }
        return logs
    }
    
    public func add(withLog log:LogViewModel) {
        self.concurrentQueue.async(flags: .barrier) {
            if self.viewModel.logs.count >= 70 { self.viewModel.logs = [] }
            self.viewModel.logs.append(log)
        }
    }
    
    public  func resetLogs() {
        self.viewModel.logs = []
    }
    
}

//MARK:// For Base View
extension LogViewHelper {
    
    public func onShow() {
        DispatchQueue.main.async {
            if let windown = UIApplication.shared.keyWindow {
                    let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.addAccountLongPressGesture(_:)))
                    windown.addGestureRecognizer(longPressRecognizer)
            }
        }
    }
    
    @objc fileprivate func addAccountLongPressGesture(_ sender: UILongPressGestureRecognizer)
    {
        if sender.state == .ended {
            
            if self.viewModel.isShow { return }
            
            DispatchQueue.main.async { [weak self] in guard let strongSelf = self else { return }
                let showLogVC = OptionLogPresentViewController(with: "IS DEV MODE", subTitle: strongSelf.viewModel.displayString)
                if !strongSelf.viewModel.isShow {
                    strongSelf.viewModel.isShow = true
                    UIApplication.topViewController()?.present(showLogVC, animated: true, completion: {
                        strongSelf.viewModel.isShow = true
                    })
                }
                
                showLogVC.didLoad? = { [weak self] in guard let strongSelf = self else { return }
                    strongSelf.viewModel.isShow = true
                }
                
                showLogVC.onDissmissViewHandler = { [weak self] in guard let strongSelf = self else { return }
                    strongSelf.viewModel.isShow = false
                }
                
                showLogVC.showLogButton.onTouchHandler = {  [weak self] _ in guard let strongSelf = self else { return }
                    showLogVC.dismiss(animated: true, completion: {
                        strongSelf.didTouchLogButtonHandle?()
                        strongSelf.viewModel.isShow = false
                        DispatchQueue.main.async {
                            UIApplication.topViewController()?.presentDef(vc: LogTrackingTableViewController(), type: .overFullScreen)
                        }
                    })
                }
                
                showLogVC.showReportBugButton.onTouchHandler = {  [weak self] _ in guard let strongSelf = self else { return }
                    showLogVC.dismiss(animated: true, completion: {
                        strongSelf.didTouchReportlHandle?()
                        strongSelf.viewModel.isShow = false
                    })
                }
                
                showLogVC.showSettingButton.onTouchHandler = {  [weak self] _ in guard let strongSelf = self else { return }
                    showLogVC.dismiss(animated: true, completion: {
                        strongSelf.didTouchSettinglHandle?()
                        strongSelf.viewModel.isShow = false
                    })
                }
                
            }
        }
    }
}


class OptionLogPresentViewController: TTCoverVerticalViewController {
    
    
    let label:TTBaseUILabel  = TTBaseUILabel(withType: .TITLE, text: "IS DEV MODE", align: .left)
    let subLabel:TTBaseUILabel  = TTBaseUILabel(withType: .SUB_TITLE, text: "View log by json or report bugs", align: .left)
    
    let showLogButton:TTBaseUIButton = TTBaseUIButton(textString: "SHOW LOG FILE", type: .DEFAULT, isSetSize: false)
    let showReportBugButton:TTBaseUIButton = TTBaseUIButton(textString: "REPORT BUG", type: .WARRING, isSetSize: false)
    let showSettingButton:TTBaseUIButton = TTBaseUIButton(textString: "SETTING", type: .WARRING, isSetSize: false)
    
    init(with title:String, subTitle:String) {
        super.init()
        self.label.setText(text: title)
        self.subLabel.setText(text: subTitle)
    }
    
    public var didLoad:( () -> ())?
    
    public required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.didLoad?()
    }
    
    override func updateBaseUI() {
        super.updateBaseUI()
        
        self.bgView = UIColor.black.withAlphaComponent(0.8)
        
        self.view.backgroundColor = UIColor.clear
        
        self.view.addSubview(self.label)
        self.view.addSubview(self.subLabel)
        self.view.addSubview(self.showLogButton)
        self.view.addSubview(self.showReportBugButton)
        self.view.addSubview(self.showSettingButton)
        
        self.label.setVerticalContentHuggingPriority()
            .setLeadingAnchor(constant: 8).setTrailingAnchor(constant: 8)
            .setTopAnchor(constant: 10)
        
        self.subLabel.setVerticalContentHuggingPriority()
            .setLeadingAnchor(constant: 8).setTrailingAnchor(constant: 8)
            .setTopAnchorWithAboveView(nextToView: self.label, constant: 10)
        
        self.showLogButton.setTopAnchorWithAboveView(nextToView: self.subLabel, constant: 30)
            .setLeadingAnchor(constant: 8).setTrailingAnchor(constant: 8)
            .setHeightAnchor(constant: 35)
        
        self.showReportBugButton.setTopAnchorWithAboveView(nextToView: self.showLogButton, constant: 8)
            .setLeadingAnchor(constant: 8).setTrailingAnchor(constant: 8)
            .setHeightAnchor(constant: 35)
            
        self.showSettingButton.setTopAnchorWithAboveView(nextToView: self.showReportBugButton, constant: 8)
            .setLeadingAnchor(constant: 8).setTrailingAnchor(constant: 8)
            .setHeightAnchor(constant: 35)
            .setBottomAnchor(constant: 20, isMarginsGuide: true, priority: .defaultHigh)
        
        
    }
    
}
