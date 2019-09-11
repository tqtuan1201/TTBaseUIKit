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
    private  init(){}
    
    public var didTouchLogButtonHandle:( () -> ())?
    public var didTouchLogLabelHandle:( () -> ())?
    
    public func config(withDes des:String, isStartAppToShow:Bool) -> LogViewHelper {
        self.viewModel.displayString =  des
        self.viewModel.isStartAppToShow =  isStartAppToShow
        return self
    }
    
}

//MARK:// For Base Funcs
extension LogViewHelper {
    
    public func getLogs() -> [LogViewModel] {
        return self.viewModel.logs.reversed()
    }
    
    public func add(withLog log:LogViewModel) {
        self.viewModel.logs.append(log)
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
                
                let buttonHeight:CGFloat = 45.0
                let labelHeight:CGFloat = 55.0
                let paddingBottom:CGFloat = 150.0
                
                if windown.viewWithTag(-1122) == nil {
                    
                    let button:TTBaseUIButton = TTBaseUIButton()
                    button.layer.zPosition = 900000
                    button.tag = -1122
                    button.frame = CGRect.init(x: TTSize.W - TTSize.P_CONS_DEF -  buttonHeight, y: TTSize.H - paddingBottom -  labelHeight, width: buttonHeight, height: buttonHeight)
                    button.translatesAutoresizingMaskIntoConstraints = true
                    button.backgroundColor = UIColor.red.withAlphaComponent(0.7)
                    button.setImage(UIImage(fromTTBaseUIKit: "img.log.png")?.withRenderingMode(.alwaysTemplate), for: .normal)
                    button.tintColor = UIColor.white
                    button.isUserInteractionEnabled = true
                    button.setConerRadius(with: 4)
                    
                    let textLabel:TTBaseInsetLabel = TTBaseInsetLabel(withType: .SUB_TITLE, text: "DEV MODE", align: .right)
                    textLabel.setConerRadius(with: 4)
                    textLabel.layer.zPosition = 900000
                    textLabel.tag = -1123
                    textLabel.isUserInteractionEnabled = true
                    textLabel.textColor = UIColor.white
                    textLabel.translatesAutoresizingMaskIntoConstraints = true
                    textLabel.frame = CGRect.init(x: TTSize.W - labelHeight * 2 - TTSize.P_CONS_DEF, y: TTSize.H - paddingBottom, width: labelHeight * 2, height: labelHeight)
                    textLabel.backgroundColor = UIColor.red.withAlphaComponent(0.3)
                    textLabel.setMutilLine(numberOfLine: 2, textAlignment: .right)
                    textLabel.text = self.viewModel.displayString
                    
                    windown.insertSubview(button, at: 80000)
                    windown.insertSubview(textLabel, at: 80000)
                    
                    if self.viewModel.isStartAppToShow {
                        textLabel.isHidden = false
                        button.isHidden = false
                    } else {
                        textLabel.isHidden = true
                        button.isHidden = true
                    }
                    
                    textLabel.setTouchHandler().onTouchHandler = { [weak self] _ in
                        self?.didTouchLogLabelHandle?()
                    }
                    
                    button.onTouchHandler = {  [weak self] _ in
                        self?.didTouchLogButtonHandle?()
                        DispatchQueue.main.async {
                            let logsVC = LogTrackingTableViewController()
                            UIApplication.topViewController()?.present(logsVC, animated: true, completion: nil)
                        }
                    }
                    
                    let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.addAccountLongPressGesture(_:)))
                    windown.addGestureRecognizer(longPressRecognizer)
                }
            }
        }
    }
    @objc fileprivate func addAccountLongPressGesture(_ sender: UILongPressGestureRecognizer)
    {
        if sender.state == .recognized {
            if let windown = UIApplication.shared.keyWindow {
                if let button = windown.viewWithTag(-1122){
                    if button.isHidden {
                        button.isHidden = false
                        button.isUserInteractionEnabled = true
                    } else {
                        button.isHidden = true
                    }
                }
                if let textLog = windown.viewWithTag(-1123){
                    if textLog.isHidden {
                        textLog.isUserInteractionEnabled = true
                        textLog.isHidden = false
                    } else {
                        textLog.isHidden = true
                    }
                }
            }
        }
    }
}

