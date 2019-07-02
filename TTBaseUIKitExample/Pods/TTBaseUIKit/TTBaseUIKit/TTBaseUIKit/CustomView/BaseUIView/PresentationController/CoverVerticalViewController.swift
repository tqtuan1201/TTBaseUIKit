//
//  CoverVerticalViewController.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 5/30/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTCoverVerticalViewController: UIViewController {
    
    open var padding:(CGFloat,CGFloat,CGFloat,CGFloat) = (0,0,0,0)
    open var bgView:UIColor = UIColor.white
    open var bgSafeView:UIColor = UIColor.white
    open var isAddDownSwipe:Bool = true
    open var heightDissmissView:CGFloat = TTSize.H_DISSMISS_PRESENTVIEW
    
    public var panelView:TTBaseUIView = TTBaseUIView()
    public var bottomSafeAreaView:TTBaseUIView = TTBaseUIView()
    
    public var dissmissView:TTDismissView = TTDismissView()
    
    public var onDissmissViewHandler:(() -> Void)?
    
    open func updateBaseUI() { }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        self.setupBaseUIView()
        self.updateBaseUI()
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        self.setupBaseUIView()
        self.updateBaseUI()
        if self.isAddDownSwipe { self.onSetDownSwipe()}
    }
    
    public init(padding:(CGFloat,CGFloat,CGFloat,CGFloat), bgView:UIColor, bgSafeView:UIColor) {
        super.init(nibName: nil, bundle: nil)
        self.padding = padding
        self.bgView = bgView
        self.bgSafeView = bgSafeView
        self.setupBaseUIView()
        if self.isAddDownSwipe { self.onSetDownSwipe()}
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setBgColor(with panel:UIColor, safe:UIColor) {
        self.bgView = panel
        self.bgSafeView = safe
        self.panelView.setBgColor(panel)
        self.bottomSafeAreaView.setBgColor(safe)
    }
    
}

fileprivate extension TTCoverVerticalViewController {
    
    func onSetDownSwipe() {
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        downSwipe.direction = .down
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(downSwipe)
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if sender.direction == .down {
            self.dismiss(animated: true, completion: nil)
            self.onDissmissViewHandler?()
        }
    }
    
    func setupBaseUIView() {
        
        transitioningDelegate = self
        modalPresentationStyle = .custom
        
        self.bottomSafeAreaView.setBgColor(self.bgSafeView)
        
        self.panelView.setBgColor(self.bgView)
        
        self.view.addSubview(self.dissmissView)
        self.view.addSubview(self.bottomSafeAreaView)
        self.view.addSubview(self.panelView)
        
        self.dissmissView.setLeadingAnchor(constant: self.padding.0).setHeightAnchor(constant: self.heightDissmissView).setTrailingAnchor(constant: self.padding.2).setBottomAnchorWithBelowView(view: self.panelView, constant: 0)
        
        self.panelView.setLeadingAnchor(constant: self.padding.0).setTopAnchor(constant: self.padding.1).setTrailingAnchor(constant: self.padding.2).setBottomAnchor(constant: self.padding.3, isMarginsGuide: true, priority: .defaultHigh)
        
        self.bottomSafeAreaView.setLeadingAnchor(constant: self.padding.0).setTrailingAnchor(constant: self.padding.2).setBottomAnchor(constant: 0).setTopAnchorWithAboveView(nextToView: self.panelView, constant: 0).done()
        
    }
}


extension TTCoverVerticalViewController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let present =  TTCoverVerticalPresentationController(presentedViewController: presented, presenting: presenting)
        present.onTouchDimmingViewHandler = { [weak self] in guard let strongSelf = self else { return }
            strongSelf.onDissmissViewHandler?()
        }
        return present
    }
    
}
