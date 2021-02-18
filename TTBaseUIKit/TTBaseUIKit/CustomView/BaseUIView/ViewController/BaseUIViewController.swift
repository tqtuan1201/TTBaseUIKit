//
//  BaseUIViewController.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/11/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

public protocol TTBaseUIViewControllerRepresentable {}

public class DarkBaseUIView: TTBaseUIView {
    public override func updateBaseUIView() {
        self.backgroundColor = TTBaseUIKitConfig.getViewConfig().viewBgColor
    }
}

public class WhitekBaseUIView: TTBaseUIView {
    public override func updateBaseUIView() {
        self.backgroundColor = UIColor.white
    }
}

open class TTBaseUIViewController<BaseView:TTBaseUIView>: UIViewController, TTBaseUIViewControllerRepresentable {
    
    
    open var P_CONS_DEF:CGFloat { get { return TTSize.P_CONS_DEF}}
    
    open var bgView:UIColor { get { return TTView.viewBgColor}}
    open var isEffectView:Bool { get { return true}}
    open var isGetKeyboardHeight:Bool { get { return false } }
    open var isSetHiddenTabar:Bool { get { return false}}
    
    open var paddingStatus:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (0,0,0,0)}}
    open var paddingNav:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (0,0,0,0)}}

    open var navType:NAV_STYLE { get { return .STATUS_NAV}}
    open lazy var statusBar:TTBaseUIView = TTBaseUIView()
    open lazy var navBar:TTBaseUINavigationView = TTBaseUINavigationView()

    public lazy var frameKeyBoard:CGRect = .zero

    public var skeletonLayer:CALayer?
    
    public var onHandleKeyboardWillShow:((_ size:CGRect) -> ())?
    public var onHandleKeyboardWillHide:(() -> ())?
    
    fileprivate let panelEffectView:TTBaseUIView = {
        let view = TTBaseUIView()
        view.isUserInteractionEnabled = false
        view.layer.zPosition = CONSTANT.POSITION_VIEW.EFFECT_VIEW.rawValue
        return view
    }()
    
    public enum NAV_STYLE {
        case ONLY_STATUS
        case STATUS_NAV
        case NO_VIEW
    }

    internal var contentView: BaseView {
        return view as! BaseView
    }
    
    open func updateBaseUI() { }
    
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        self.setKeyboardObserver()
        self.updateBaseUI()
    }
    
    @available(*, unavailable,
      message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection."
    )
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        self.setKeyboardObserver()
        self.updateBaseUI()
    }

    @available(*, unavailable,
      message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection."
    )
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
        self.setKeyboardObserver()
        self.updateBaseUI()
    }
    
    deinit {
        self.onRemoveKeyboardObserver()
        TTBaseFunc.shared.printLog(with: "Release memory for ", object: TTBaseUIViewController.description())
    }
    
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if self.isSetHiddenTabar { self.tabBarController?.tabBar.isHidden = false ; self.hidesBottomBarWhenPushed = false }
    }
    
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setupEffectForView()
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
    
        if self.isSetHiddenTabar { self.tabBarController?.tabBar.isHidden = true ; self.hidesBottomBarWhenPushed = true }
        
    }
    
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.skeletonLayer != nil {self.skeletonLayer?.frame = CGRect.init(x: -4, y: 0, width: self.contentView.frame.width + 8, height: self.contentView.frame.height)}
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupConstraints()
        TTBaseFunc.shared.printLog(object: NSStringFromClass(self.classForCoder))
    }
    
    open override func loadView() {
        super.loadView()
        self.view = BaseView()
        self.view.translatesAutoresizingMaskIntoConstraints = true
    }
    
    
    private func setupUI() {
        self.view.backgroundColor = self.bgView
        self.statusBar.layer.zPosition = 10000
        self.statusBar.backgroundColor = TTBaseUIKitConfig.getViewConfig().viewBgNavColor
        self.statusBar.layer.zPosition = CONSTANT.POSITION_VIEW.NAV_VIEW.rawValue
        self.navBar.layer.zPosition = CONSTANT.POSITION_VIEW.NAV_VIEW.rawValue
        switch self.navType {
        case .STATUS_NAV:
            self.view.addSubview(self.statusBar)
            self.view.addSubview(self.navBar)
            
        break
        case .ONLY_STATUS:
            self.view.addSubview(self.statusBar)
            break
        case .NO_VIEW:
            break
        }
    
        if self.isEffectView { self.view.addSubview(self.panelEffectView) }
        
    }
    
    private func setupEffectForView() {
        if self.isEffectView {
            self.panelEffectView.alpha = 0.8
            UIView.animate(withDuration: 0.2) {
                self.panelEffectView.alpha = 0
            }
        }
    }
    
    private func setupConstraints() {
        
        switch self.navType {
        case .STATUS_NAV:
            self.statusBar.setLeadingAnchor(constant: 0).setTopAnchor(constant: 0).setTrailingAnchor(constant: 0).setHeightAnchor(constant: TTBaseUIKitConfig.getSizeConfig().H_STATUS).done()
            self.navBar.setLeadingAnchor(constant: 0).setTopAnchorWithAboveView(nextToView: self.statusBar, constant: 0).setTrailingAnchor(constant: 0).setHeightAnchor(constant: TTSize.H_NAV).done()
            break
        case .ONLY_STATUS:
            self.statusBar.setLeadingAnchor(constant: 0).setTopAnchor(constant: 0).setTrailingAnchor(constant: 0).setHeightAnchor(constant: TTBaseUIKitConfig.getSizeConfig().H_STATUS).done()
            break
        case .NO_VIEW:
            break
        }

        self.panelEffectView.setFullContraints(constant: 0)
        
    }
    
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


extension TTBaseUIViewController {
    
    public func setBgNav(withStatusColor statusColor:UIColor, navColor:UIColor) {
        self.setStatusBgColor(color: statusColor)
        self.setNavBgColor(color: navColor)
    }
    
    public func setStatusBgColor(color:UIColor) {
        self.statusBar.setBgColor(color)
    }
    
    public func setNavBgColor(color:UIColor) {
        self.navBar.setBgColor(color)
    }
    
}


//MARK:// Skeleton animations
extension TTBaseUIViewController {
    
    public func setSkeletonAnimation() ->  TTBaseUIViewController {
        self.skeletonLayer = UIView.getGradientSkeletonLayer()
        if let skeLayer =  self.skeletonLayer { self.contentView.layer.addSublayer(skeLayer) }
        return self
    }
    
    public func onStartSkeletonAnimation(isSetAllSubView:Bool = true) {
        self.skeletonLayer?.isHidden = false
        
        let views = isSetAllSubView ? self.contentView.subviewsRecursive(): self.contentView.subviews
        for view in views {
            if view as? TTBaseUINavigationView  == nil {
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
        let views = isSetAllSubView ? self.contentView.subviewsRecursive(): self.contentView.subviews
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

