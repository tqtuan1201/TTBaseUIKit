//
//  UIViewController+Config.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/11/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

//MARK:// For custom loading view
extension UIViewController {
    
    
    public func dismissAll(animated: Bool, completion: (() -> Void)? = nil) {
        if let optionalWindow = UIApplication.shared.delegate?.window, let window = optionalWindow, let rootViewController = window.rootViewController, let presentedViewController = rootViewController.presentedViewController  {
            if let snapshotView = window.snapshotView(afterScreenUpdates: false) {
                presentedViewController.view.addSubview(snapshotView)
                presentedViewController.modalTransitionStyle = .coverVertical
            }
            if !isBeingDismissed {
                rootViewController.dismiss(animated: animated, completion: completion)
            }
        }
    }
    
    public func showLoadingView(type:CONSTANT.LOADING_TYPE, padding:CGFloat = 0) {
        DispatchQueue.main.async { [weak self] in guard let strongSelf = self else { return }
            if strongSelf.view.viewWithTag(CONSTANT.TAG_VIEW.LOADING.rawValue) != nil { return }
            switch type {
            case .VIEW_CENTER:
                let panel:TTBaseUIView = strongSelf.createCenterLoadingView()
                strongSelf.view.addSubview(panel)
                panel.setFullContraints(constant: 0)
                break
            case .NAV_BUTTOM:
                var paddingTop:CGFloat = 0
                if let baseVC = strongSelf as? TTBaseUIViewController {
                    switch baseVC.navType {
                    case .NO_VIEW:
                        paddingTop = 0
                        break
                    case .ONLY_STATUS:
                        paddingTop = TTSize.H_STATUS
                        break
                    case .STATUS_NAV:
                        paddingTop = TTSize.H_STATUS + TTSize.H_NAV
                        break
                    }
                }
                
                if padding != 0 {paddingTop = padding}
                
                let processView:TTBaseUIProgressView = TTBaseUIProgressView(progressViewStyle: .default)
                processView.onStart()
                processView.layer.zPosition = CONSTANT.POSITION_VIEW.LOADING_VIEW.rawValue
                processView.tag = CONSTANT.TAG_VIEW.LOADING.rawValue
                strongSelf.view.addSubview(processView)
                processView.setLeadingAnchor(constant: 0).setTopAnchor(constant: paddingTop).setTrailingAnchor(constant: 0).setHeightAnchor(constant: TTSize.H_PROCESS_VIEW).done()
                break
            case .TAB_TOP:
                let processView:TTBaseUIProgressView = TTBaseUIProgressView(progressViewStyle: .default)
                processView.onStart()
                processView.layer.zPosition = CONSTANT.POSITION_VIEW.LOADING_VIEW.rawValue
                processView.tag = CONSTANT.TAG_VIEW.LOADING.rawValue
                strongSelf.view.addSubview(processView)
                processView.setLeadingAnchor(constant: 0).setTrailingAnchor(constant: 0).setHeightAnchor(constant: TTSize.H_PROCESS_VIEW).done()
                processView.bottomAnchor.constraint(equalTo: strongSelf.view.layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
                break
            }
        }
    }
    
    fileprivate func createCenterLoadingView() -> TTBaseUIView {
        
        let panelLoadingView:TTBaseUIView = TTBaseUIView()
        panelLoadingView.layer.zPosition = CONSTANT.POSITION_VIEW.LOADING_VIEW.rawValue
        panelLoadingView.tag = CONSTANT.TAG_VIEW.LOADING.rawValue
        
        panelLoadingView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        
        let panelInd:TTBaseUIView = TTBaseUIView(withCornerRadius: TTSize.CORNER_RADIUS)
        panelInd.backgroundColor = TTView.viewBgLoadingColor.withAlphaComponent(0.4)
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.translatesAutoresizingMaskIntoConstraints = false
        actInd.style = Device.size() > DeviceSize.screen4Inch ? UIActivityIndicatorView.Style.large : UIActivityIndicatorView.Style.medium
        actInd.startAnimating()
        
        panelInd.addSubview(actInd)
        
        panelLoadingView.addSubview(panelInd)
        
        self.view.addSubview(panelLoadingView)
        
        actInd.setFullContraints(constant: TTSize.P_CONS_DEF * 2.5)
        
        panelInd.setHeightAnchor(constant: TTSize.H_LOADING_CENTER).setWidthAnchor(constant: TTSize.H_LOADING_CENTER).setFullCenterAnchor(constant: 0)
        
        panelLoadingView.setFullContraints(constant: 0)
        return panelLoadingView
    }
}

extension UIViewController {
    
    public func dismissKeyboard() {
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
    }
    
    public func removeLoading() {
        DispatchQueue.main.async { [weak self] in guard let strongSelf = self else { return }
            if let processView = strongSelf.view.viewWithTag(TTBaseUIKit.CONSTANT.TAG_VIEW.LOADING.rawValue) as? TTBaseUIProgressView {
                processView.onFinished()
                processView.removeFromSuperview()
            } else {
                guard let loadingView = strongSelf.view.viewWithTag(TTBaseUIKit.CONSTANT.TAG_VIEW.LOADING.rawValue) else { return }
                loadingView.removeFromSuperview()
            }
        }
    }
    
    
    public func showAlert(_ message: String, andTitle title: String = "") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    public func presentDef(vc:UIViewController, type:UIModalPresentationStyle = .fullScreen) {
        vc.modalPresentationStyle = type
        vc.modalTransitionStyle   = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    public func onDismiss() {
        DispatchQueue.main.async { [weak self] in  self?.dismiss(animated: true, completion: nil) }
    }
}
