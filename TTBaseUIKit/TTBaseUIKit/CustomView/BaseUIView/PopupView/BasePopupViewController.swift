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
    
    open override var navType: TTBaseUIViewController<DarkBaseUIView>.NAV_STYLE { get { return .NO_VIEW }}
    open override var isEffectView: Bool { get { return false } }
    fileprivate var isAllowTouchPanelView:Bool = true
    
    public var panelTouchView:TTBaseUIView =  TTBaseUIView()
    
    public init(isAllowTouchPanel:Bool) {
        super.init()
        self.isAllowTouchPanelView = isAllowTouchPanel
        self.setupBaseView()
        self.setupTargets()
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.insertSubview(self.panelTouchView, at: 0)
        self.panelTouchView.setFullContraints(constant: 0)
        self.panelTouchView.setBgColor(UIColor.clear)
        self.view.alpha = 0
        self.view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.6)
        UIView.animate(withDuration: 0.4) { self.view.alpha = 1 }
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
            self.panelTouchView.isUserInteractionEnabled = true
            self.panelTouchView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onTouchView(_:))))
        }
    }
    
    @objc private func onTouchView(_ sender:UITapGestureRecognizer) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
}
