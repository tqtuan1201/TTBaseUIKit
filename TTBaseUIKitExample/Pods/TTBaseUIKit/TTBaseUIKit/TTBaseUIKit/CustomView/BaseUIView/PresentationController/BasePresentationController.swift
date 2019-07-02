//
//  File.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 5/30/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBasePresentationController: UIPresentationController {
    
    private var calculatedFrameOfPresentedViewInContainerView = CGRect.zero
    private var shouldSetFrameWhenAccessingPresentedView = false
    
    fileprivate lazy var dimmingView: UIView = UIView()
    fileprivate lazy var dimmingBgColor:UIColor = UIColor.darkGray.withAlphaComponent(0.6)
    
    public var onTouchDimmingViewHandler:(() -> Void)?
    open var timeAnimation:TimeInterval = 0.4
    
    public override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.setupDimmingView()
    }
    
    public init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, dimmingBgColor:UIColor ) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.dimmingBgColor = dimmingBgColor
        self.setupDimmingView()
    }
    
    deinit { TTBaseFunc.shared.printLog(object: "De-init: \(self.description)") }
    
    override open var presentedView: UIView? {
        if shouldSetFrameWhenAccessingPresentedView {
            super.presentedView?.frame = calculatedFrameOfPresentedViewInContainerView
        }
        return super.presentedView
    }
    
    open override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        shouldSetFrameWhenAccessingPresentedView = completed
    }
    
    open override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        shouldSetFrameWhenAccessingPresentedView = false
        
        UIView.animate(withDuration: self.timeAnimation) { [weak self] in self?.dimmingView.alpha = 0 }
    }
    
    
    open override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        calculatedFrameOfPresentedViewInContainerView = frameOfPresentedViewInContainerView
    }
    
    open override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        containerView?.insertSubview(dimmingView, at: 0)
        
        UIView.animate(withDuration: self.timeAnimation) { [weak self] in self?.dimmingView.alpha = 1 }
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimmingView]|", options: [], metrics: nil, views: ["dimmingView": dimmingView]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[dimmingView]|", options: [], metrics: nil, views: ["dimmingView": dimmingView]))
    }
}

// MARK: - Private
private extension TTBasePresentationController {
    
    func setupDimmingView() {
        self.dimmingView = UIView()
        self.dimmingView.alpha = 0
        self.dimmingView.translatesAutoresizingMaskIntoConstraints = false
        self.dimmingView.backgroundColor = self.dimmingBgColor
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        dimmingView.addGestureRecognizer(recognizer)
        
    }
    
    @objc dynamic func handleTap(recognizer: UITapGestureRecognizer) {
        self.onTouchDimmingViewHandler?()
        self.presentingViewController.dismiss(animated: true)
    }
}
