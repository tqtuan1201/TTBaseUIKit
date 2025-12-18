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
    public var didTouchDebugLayoutlHandle:( () -> ())?
    public var didTouchCapturelHandle:( () -> ())?
    public var didTouchSettinglHandle:( () -> ())?
    
    public var didSendCurrentRequest:( (_ request:String) -> ())?
    public var didSendCurrentResponse:( (_ response:String) -> ())?
    
    public func config(withDes des:String, isStartAppToShow:Bool, passCode:String) -> LogViewHelper {
        self.viewModel.displayString =  des
        self.viewModel.passCode =  passCode
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
    
    public func onShow(isAutoEnableRunTTBaseDebugUIKit isEnableDebugUI:Bool = false) {
        DispatchQueue.main.async {
            if let windown = UIApplication.getKeyWindow() {
                let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.addAccountLongPressGesture(_:)))
                windown.addGestureRecognizer(longPressRecognizer)
                
                if isEnableDebugUI {
                    let tripleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleWindowDoubleTap))
                    tripleTap.numberOfTapsRequired = 4
                    windown.addGestureRecognizer(tripleTap)
                }
            }
        }
    }
    
    public func onStartAndPresentVC() {
        self.onShow()
        self.onPresentVC()
    }
    
    @objc fileprivate func handleWindowDoubleTap() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if let topVC = UIApplication.topViewController() {
                topVC.view.onStartRunTTBaseDebugKit()
            }
        }
    }
    
    @objc fileprivate func addAccountLongPressGesture(_ sender: UILongPressGestureRecognizer)
    {
        if sender.state == .ended {
            self.onPresentVC()
        }
    }
    
    
    fileprivate func onPresentVC() {
        
        if self.viewModel.isShow { return }
        
        DispatchQueue.main.async { [weak self] in guard let strongSelf = self else { return }
            let showLogVC = TTBaseOptionLogPresentViewController(with: "DEVELOPER DEBUG TOOLKIT", subTitle: strongSelf.viewModel.displayString)
            if !strongSelf.viewModel.isShow {
                strongSelf.viewModel.isShow = true
                
                //isSkipCheckPass
                if strongSelf.viewModel.isSkipCheckPass {
                    UIApplication.topViewController()?.present(showLogVC, animated: true, completion: {
                        strongSelf.viewModel.isShow = true
                    })
                // Check input pass
                } else {
                    let ac = UIAlertController(title: "[DEV MODE] CHANGE SETTING APP\nInput passcode", message: nil, preferredStyle: .alert)
                    ac.addTextField()

                    let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
                        guard let answer = ac.textFields?[0] else { return }
                        if answer.text?.uppercased() == strongSelf.viewModel.passCode.uppercased() {
                            strongSelf.viewModel.isSkipCheckPass = true
                            UIApplication.topViewController()?.present(showLogVC, animated: true, completion: {
                                strongSelf.viewModel.isShow = true
                            })
                            
                        } else {
                            UIApplication.topViewController()?.onShowNoticeView(body: "The passcode is incorrect. Please reach out to the developer for assistance",style: .WARNING)
                            UIApplication.topViewController()?.present(ac, animated: true, completion: nil)
                        }
                    }
                    ac.addAction(submitAction)
                    UIApplication.topViewController()?.present(ac, animated: true, completion: nil)
                }
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
                        let logVC:LogTrackingTableViewController = LogTrackingTableViewController()
                        UIApplication.topViewController()?.presentDef(vc: logVC, type: .overFullScreen)
                        logVC.didTouchTitleLabelHandle = { request in
                            strongSelf.didSendCurrentRequest?(request)
                        }
                        
                        logVC.didTouchSubLabelHandle = { response in
                            strongSelf.didSendCurrentResponse?(response)
                        }
                    }
                })
            }
            
            showLogVC.debugUIButton.onTouchHandler = {  [weak self] _ in guard let strongSelf = self else { return }
                showLogVC.dismiss(animated: true, completion: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        if let topVC = UIApplication.topViewController() {
                            topVC.view.onStartRunTTBaseDebugKit()
                        }
                    }
                    strongSelf.didTouchDebugLayoutlHandle?()
                    strongSelf.viewModel.isShow = false
                })
            }
            
            showLogVC.captureBugButton.onTouchHandler = {  [weak self] _ in guard let strongSelf = self else { return }
                showLogVC.dismiss(animated: true, completion: {
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        if let topVC = UIApplication.topViewController() {
                            topVC.presentDrawAndShare(image: topVC.captureScreenshot())
                        }
                    }
                    strongSelf.didTouchDebugLayoutlHandle?()
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

