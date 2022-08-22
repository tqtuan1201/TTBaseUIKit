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
    open var timeAnimationChangeFrame:TimeInterval { get { return 0.2 } }
    open var isGetKeyboardHeight:Bool { get { return false } }
    
    public var skeletonLayer:CALayer?
    public var panelView:TTBaseUIView = TTBaseUIView()
    public var bottomSafeAreaView:TTBaseUIView = TTBaseUIView()
    public var dissmissView:TTDismissView = TTDismissView()
    public var coverPresentationController:TTCoverVerticalPresentationController?
    public lazy var frameKeyBoard:CGRect = .zero
    
    public var onDissmissViewHandler:(() -> Void)?
    public var onHandleKeyboardWillShow:((_ size:CGRect) -> ())?
    public var onHandleKeyboardWillHide:(() -> ())?
    
    open func updateBaseUI() { }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.skeletonLayer != nil {self.skeletonLayer?.frame = CGRect.init(x: -4, y: 0, width: self.view.frame.width + 8, height: self.view.frame.height)}
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if TTBaseUIKitConfig.getStyleConfig().isDismissKeyboardByTouchAnywhere { self.dismissKeyboard() }
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        self.setKeyboardObserver()
        self.setupBaseUIView()
        self.updateBaseUI()
        if self.isAddDownSwipe { self.onSetDownSwipe()}
    }
    
    public init(padding:(CGFloat,CGFloat,CGFloat,CGFloat), bgView:UIColor, bgSafeView:UIColor) {
        super.init(nibName: nil, bundle: nil)
        self.setKeyboardObserver()
        self.padding = padding
        self.bgView = bgView
        self.bgSafeView = bgSafeView
        self.setupBaseUIView()
        if self.isAddDownSwipe { self.onSetDownSwipe()}
    }
    
    @available(*, unavailable,
      message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection."
    )
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        self.setKeyboardObserver()
        self.setupBaseUIView()
        self.updateBaseUI()
        if self.isAddDownSwipe { self.onSetDownSwipe()}
    }

    @available(*, unavailable,
      message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection."
    )
    public required init?(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
        self.setKeyboardObserver()
        self.setupBaseUIView()
        self.updateBaseUI()
        if self.isAddDownSwipe { self.onSetDownSwipe()}
    }
    
    deinit {
        self.onRemoveKeyboardObserver()
        TTBaseFunc.shared.printLog(with: "Release memory for ", object: TTBaseUIViewController.description())
    }
    
    
    public func setBgColor(with panel:UIColor, safe:UIColor) {
        self.bgView = panel
        self.bgSafeView = safe
        self.panelView.setBgColor(panel)
        self.bottomSafeAreaView.setBgColor(safe)
    }
    
    public func onUpdateLayout() {
        UIView.animate(withDuration: self.timeAnimationChangeFrame) { [weak self] in
            self?.coverPresentationController?.containerViewDidLayoutSubviews()
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        TTBaseFunc.shared.printLog(object: NSStringFromClass(self.classForCoder))
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
            self.dismiss(animated: true) { [weak self] in guard let strongSelf = self else { return }
                strongSelf.coverPresentationController = nil
                strongSelf.onDissmissViewHandler?()
            }
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
        self.coverPresentationController = TTCoverVerticalPresentationController(presentedViewController: presented, presenting: presenting)
        self.coverPresentationController?.onTouchDimmingViewHandler = { [weak self] in guard let strongSelf = self else { return }
            strongSelf.coverPresentationController = nil
            strongSelf.onDissmissViewHandler?()
        }
        return self.coverPresentationController
    }
    
}

//MARK:// For keyboard handle
extension TTCoverVerticalViewController {
    fileprivate func onRemoveKeyboardObserver() {
        //Removing notifies on keyboard appearing
        if !self.isGetKeyboardHeight { return }
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    fileprivate func setKeyboardObserver() {
        if !self.isGetKeyboardHeight { return }
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

     @objc fileprivate func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.frameKeyBoard = keyboardSize
            self.viewDidLayoutSubviews()
            self.onHandleKeyboardWillShow?(keyboardSize)
        }
    }
    
    @objc fileprivate func keyboardWillHide(notification: Notification) {
        self.frameKeyBoard = .zero
        self.onHandleKeyboardWillHide?()
    }
}

//MARK:// Skeleton animations
extension TTCoverVerticalViewController {
    
    public func setSkeletonAnimation() ->  TTCoverVerticalViewController {
        self.skeletonLayer = UIView.getGradientSkeletonLayer()
        if let skeLayer =  self.skeletonLayer { self.view.layer.addSublayer(skeLayer) }
        return self
    }
    
    public func onStartSkeletonAnimation(isSetAllSubView:Bool = true) {
        self.skeletonLayer?.isHidden = false
        
        let views = isSetAllSubView ? self.view.subviewsRecursive(): self.view.subviews
        for view in views {
            if view as? TTDismissView  == nil {
                if let lb = view as? TTBaseUILabel {lb.onAddSkeletonMark()}
                if let btn = view as? TTBaseUIButton {btn.onAddSkeletonMark()}
                if let img = view as? TTBaseUIImageView {img.onAddSkeletonMark()}
                if let web = view as? TTBaseWKWebView {web.onAddSkeletonMark()}
            }
        }
    }

    public func onStopSkeletonAnimation(isSetAllSubView:Bool = true) {
        if (self.skeletonLayer?.isHidden ?? false) == true { return }
        self.skeletonLayer?.isHidden = true
        self.skeletonLayer?.removeFromSuperlayer()
        let views = isSetAllSubView ? self.view.subviewsRecursive(): self.view.subviews
        for view in views {
            if let _ = view as? TTBaseUIView {
                //view.backgroundColor = view.viewDefBgColor
            } else if let lb = view as? TTBaseUILabel {
                lb.onRemoveSkeletonMark()
            }  else if let btn = view as? TTBaseUIButton {
                btn.onRemoveSkeletonMark()
            } else if let img = view as? TTBaseUIImageView {
                img.onRemoveSkeletonMark()
            } else if let web = view as? TTBaseWKWebView {
                web.onRemoveSkeletonMark()
            }
        }
    }
}

