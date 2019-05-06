//
//  UIViewController+Config.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/11/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    public func dismissKeyboard() {
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
    }
    
    public func showLoadingView() {
        DispatchQueue.main.async { [weak self] in guard let strongSelf = self else { return }
            if strongSelf.view.viewWithTag(CONSTANT.TAG_VIEW.LOADING.rawValue) != nil { return }
            
            let panelLoadingView:TTBaseUIView = TTBaseUIView()
            panelLoadingView.layer.zPosition = 8000
            panelLoadingView.tag = CONSTANT.TAG_VIEW.LOADING.rawValue
            
            panelLoadingView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
            
            let panelInd:TTBaseUIView = TTBaseUIView(withCornerRadius: TTSize.CORNER_RADIUS)
            panelInd.backgroundColor = TTView.viewBgNavColor.withAlphaComponent(0.4)
            
            let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
            actInd.translatesAutoresizingMaskIntoConstraints = false
            actInd.style = UIActivityIndicatorView.Style.whiteLarge
            actInd.startAnimating()
            
            panelInd.addSubview(actInd)
            
            panelLoadingView.addSubview(panelInd)
            
            strongSelf.view.addSubview(panelLoadingView)
            
            actInd.setFullContraints(constant: TTSize.P_CONS_DEF * 2.5)
            
            panelInd.setHeightAnchor(constant: 80).setWidthAnchor(constant: 80).setFullCenterAnchor(constant: 0)
            
            panelLoadingView.setFullContraints(constant: 0)
            strongSelf.view.addSubview(panelLoadingView)
        }
    }
    
    public func removeLoading() {
        DispatchQueue.main.async { [weak self] in guard let strongSelf = self else { return }
            guard let loadingView =  strongSelf.view.viewWithTag(CONSTANT.TAG_VIEW.LOADING.rawValue) else { return }
            loadingView.removeFromSuperview()
        }
    }
    
    
    public func showAlert(_ message: String, andTitle title: String = "") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
