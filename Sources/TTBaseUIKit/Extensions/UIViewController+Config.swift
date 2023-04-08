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
    
    public func showLoadingView(type:CONSTANT.LOADING_TYPE, padding:CGFloat = 0, description:String = "") {
        DispatchQueue.main.async { [weak self] in guard let strongSelf = self else { return }
            if strongSelf.view.viewWithTag(CONSTANT.TAG_VIEW.LOADING.rawValue) != nil { return }
            switch type {
            case .VIEW_CENTER:
                let panel:TTBaseUIView = strongSelf.createCenterLoadingView()
                strongSelf.view.addSubview(panel)
                panel.setFullContraints(constant: 0)
                
                if let descriptLabel:TTBaseUILabel = strongSelf.view.viewWithTag(TTBaseUIKit.CONSTANT.TAG_VIEW.LOADING_DESCRIPTIONVIEW.rawValue) as? TTBaseUILabel {
                    descriptLabel.setText(text: description)
                    descriptLabel.isHidden = description.isEmpty
                }
                
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
                processView.setLeadingAnchor(constant: -4).setTopAnchor(constant: paddingTop).setTrailingAnchor(constant: -4).setHeightAnchor(constant: TTSize.H_PROCESS_VIEW).done()
                break
            case .TAB_TOP:
                let processView:TTBaseUIProgressView = TTBaseUIProgressView(progressViewStyle: .default)
                processView.onStart()
                processView.layer.zPosition = CONSTANT.POSITION_VIEW.LOADING_VIEW.rawValue
                processView.tag = CONSTANT.TAG_VIEW.LOADING.rawValue
                strongSelf.view.addSubview(processView)
                processView.setLeadingAnchor(constant: -4).setTrailingAnchor(constant: -4).setHeightAnchor(constant: TTSize.H_PROCESS_VIEW).done()
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
        
        let descriptLabel:TTBaseUILabel = TTBaseUILabel(withType: .TITLE, text: description, align: .center)
        descriptLabel.tag = CONSTANT.TAG_VIEW.LOADING_DESCRIPTIONVIEW.rawValue
        descriptLabel.setTextColor(color: TTView.viewTextLoadingColor)
        descriptLabel.isHidden = true
        
        panelLoadingView.addSubview(descriptLabel)
        descriptLabel.setVerticalContentHuggingPriority()
            .setLeadingAnchor(constant: TTSize.getPaddingView()).setTrailingAnchor(constant: TTSize.getPaddingView())
            .setTopAnchorWithAboveView(nextToView: panelInd, constant: TTSize.P_CONS_DEF * 2)
        
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
            self.view.findViewController()?.view.endEditing(true)
            UIApplication.topViewController()?.view.endEditing(true)
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
    
    public func presentDef(vc:UIViewController, type:UIModalPresentationStyle = .fullScreen, transitionStyle:UIModalTransitionStyle = .crossDissolve, isAnimation:Bool = true) {
        vc.modalPresentationStyle = type
        vc.modalTransitionStyle   = transitionStyle
        self.present(vc, animated: isAnimation, completion: nil)
    }
    
    public func onDismiss() {
        DispatchQueue.main.async { [weak self] in  self?.dismiss(animated: true, completion: nil) }
    }
}



import Foundation
import MessageUI
import ContactsUI
import AddressBookUI

extension UIViewController : MFMessageComposeViewControllerDelegate {
    
    public func sendSMS(with messageString:String, phones:[String], completion:(() -> ())? = nil ) {
            let messageVC  = MFMessageComposeViewController()
            messageVC.body = messageString
            messageVC.recipients = phones
            messageVC.messageComposeDelegate = self
            self.showLoadingView(type: .VIEW_CENTER)
        self.present(messageVC, animated: true) { [weak self] in
            if completion == nil { self?.removeLoading() }
        }
    }
    
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}


//Nav Coord
extension UIViewController {

    public func push(_ vc: UIViewController, animated: Bool = true) {
        self.navigationController?.pushViewController(vc, animated: animated)
    }

    public func pop(animated: Bool = true) {
        self.navigationController?.popViewController(animated: animated)
    }
    
    public func close(animated: Bool = true) {
        self.runOnMainThread {
            if let nav = self.navigationController {
                nav.popViewController(animated: animated)
            } else {
                self.onDismiss()
            }
        }
    }
    
    public func closeAll(animated: Bool = true,_ completion: @escaping (() -> Void)) {
        self.runOnMainThread {
            if let nav = self.navigationController {
                nav.popToRootViewController(animated: true)
                completion()
            } else {
                self.dismissAll(animated: animated) {
                    completion()
                }
            }
        }
    }

    public func dismiss(animated: Bool) {
        self.dismiss(animated: animated, completion: nil)
    }

    public func dismiss(animated: Bool, _completion: @escaping (() -> Void)) {
        self.dismiss(animated: animated, completion: _completion)
    }

    public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    public var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

    public func runOnMainThread(completion: @escaping (() -> Void)) {
        DispatchQueue.main.async { completion() }
    }
    
    public func runOnBackgroundThread( bg:DispatchQoS.QoSClass = .background, completion: @escaping (() -> Void)) {
        DispatchQueue.global(qos: bg).async {
            completion()
        }
    }
    
}
