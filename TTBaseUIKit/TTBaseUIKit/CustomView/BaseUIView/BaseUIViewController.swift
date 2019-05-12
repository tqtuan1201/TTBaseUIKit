//
//  BaseUIViewController.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/11/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit



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

open class TTBaseUIViewController<BaseView:TTBaseUIView>: UIViewController {
    
    
    open var P_CONS_DEF:CGFloat { get { return TTSize.P_CONS_DEF}}
    
    open var bgView:UIColor { get { return TTView.viewBgColor}}
    open var isEffectView:Bool { get { return true}}
    
    open var paddingStatus:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (0,0,0,0)}}
    open var paddingNav:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (0,0,0,0)}}

    open var navType:NAV_STYLE { get { return .STATUS_NAV}}
    open lazy var statusBar:TTBaseUIView = TTBaseUIView()
    open lazy var navBar:TTBaseUINavigationView = TTBaseUINavigationView()
    
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
        self.updateBaseUI()
    }
    
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    deinit {
        TTBaseFunc.shared.printLog(with: "Release memory for ", object: TTBaseUIViewController.description())
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setupEffectForView()
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupConstraints()
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
        
        self.view.addSubview(self.panelEffectView)
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
}


extension TTBaseUIViewController {
    
    public func setBgNav(withStatusColor statusColor:UIColor, navColor:UIColor) {
        self.setStatusBgColor(color: statusColor)
        self.setNavBgColor(color: statusColor)
    }
    
    public func setStatusBgColor(color:UIColor) {
        self.statusBar.setBgColor(color)
    }
    
    public func setNavBgColor(color:UIColor) {
        self.navBar.setBgColor(color)
    }
    
}
