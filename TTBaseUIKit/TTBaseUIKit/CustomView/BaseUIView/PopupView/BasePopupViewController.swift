//
//  BasePopupViewController.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 5/20/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBasePopupViewController : TTBaseUIViewController<DarkBaseUIView> {
    
    fileprivate var isAllowTouchPanelView:Bool = true
    
    public init(isAllowTouchPanel:Bool) {
        super.init()
        self.isAllowTouchPanelView = isAllowTouchPanel
        self.setupBaseView()
        self.setupTargets()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TTBasePopupViewController {
    
    fileprivate func setupBaseView() {
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle   = .crossDissolve
    }
    
    fileprivate func setupTargets() {
        if isAllowTouchPanelView {
            self.view.isUserInteractionEnabled = true
            self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onTouchView(_:))))
        }
    }
    
    @objc private func onTouchView(_ sender:UITapGestureRecognizer) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
}
