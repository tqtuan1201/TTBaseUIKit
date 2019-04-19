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
    public override func updateUI() {
        self.backgroundColor = TTBaseUIKitConfig.getViewConfig().viewBgColor
    }
}

public class WhitekBaseUIView: TTBaseUIView {
    public override func updateUI() {
        self.backgroundColor = UIColor.white
    }
}

open class TTBaseUIViewController<BaseView:TTBaseUIView>: UIViewController {
    
    
    open var P_CONS_DEF:CGFloat { get { return TTSize.P_CONS_DEF}}
    
    open var bgView:UIColor { get { return TTView.viewBgColor}}
    open var paddingStatus:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (0,0,0,0)}}
    open var paddingNav:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (0,0,0,0)}}
    
    public var statusBar:TTBaseUIView = TTBaseUIView()
    public var navBar:TTBaseUINavigationView = TTBaseUINavigationView()
    
    fileprivate var isAddNavBar:Bool = true

    internal var contentView: BaseView {
        return view as! BaseView
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public init(isAddNavBar:Bool = true) {
        super.init(nibName: nil, bundle: nil)
        self.isAddNavBar = isAddNavBar
    }
    
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    deinit {
        TTBaseFunc.shared.printLog(with: "Release memory for ", object: TTBaseUIViewController.description())
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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
        if self.isAddNavBar {
            self.statusBar.layer.zPosition = 10000
            self.statusBar.backgroundColor = TTBaseUIKitConfig.getViewConfig().viewBgNavColor
            
            self.view.addSubview(self.statusBar)
            self.view.addSubview(self.navBar)
        }
    }
    
    
    private func setupConstraints() {
        if self.isAddNavBar {
            self.statusBar.setLeadingAnchor(constant: 0).setTopAnchor(constant: 0).setTrailingAnchor(constant: 0).setHeightAnchor(constant: TTBaseUIKitConfig.getSizeConfig().H_STATUS).layer.zPosition = 1000
            self.navBar.setLeadingAnchor(constant: 0).setTopAnchorWithAboveView(nextToView: self.statusBar, constant: 0).setTrailingAnchor(constant: 0).setHeightAnchor(constant: TTSize.H_NAV).layer.zPosition = 1000
        }
        
    }
}


extension TTBaseUIViewController {

}
