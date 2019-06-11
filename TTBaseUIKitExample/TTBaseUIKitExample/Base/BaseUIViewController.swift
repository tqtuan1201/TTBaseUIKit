//
//  BaseUIViewController.swift
//  TTBaseUIKitExample
//
//  Created by Truong Quang Tuan on 6/7/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import  TTBaseUIKit

class BaseUIViewController: TTBaseUIViewController<DarkBaseUIView> {
    
    var lgNavType:BaseUINavigationView.TYPE { get { return .DEFAULT}}
    var backType:BaseUINavigationView.NAV_BACK = .BACK_POP
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.updateForNav()
    }
    
    public override init() {
        super.init()
        self.navBar = BaseUINavigationView(withType: self.lgNavType)
        self.setDelegate()
    }
    
    public convenience init(backType:BaseUINavigationView.NAV_BACK) {
        self.init()
        self.backType = backType
    }
    
    public convenience init(withTitleNav title:String, backType:BaseUINavigationView.NAV_BACK = .BACK_POP) {
        self.init()
        self.backType = backType
        self.setTitleNav(title)
    }
    
    public convenience init(withNav nav:BaseUINavigationView, backType:BaseUINavigationView.NAV_BACK = .BACK_POP) {
        self.init()
        self.backType = backType
        self.navBar = nav
        self.setDelegate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: For private base funcs
extension BaseUIViewController {
    
    fileprivate func setDelegate() {
        if let lgNav = self.navBar as? BaseUINavigationView { lgNav.delegate = self }
    }
    
    fileprivate func updateForNav() {
        if let lgNav = self.navBar as? BaseUINavigationView {
            lgNav.setTitle(title: "TTBASEUIVIEW_KIT")
        }
    }
}

// MARK: For public base funcs
//--NAV
extension BaseUIViewController {
    
    func setTitleNav(_ text:String) {
        self.navBar.setTitle(title: text)
    }
    
    func setShowNav() {
        self.statusBar.isHidden = false
        self.navBar.isHidden = false
    }
    
    func setHiddenNav() {
        self.statusBar.isHidden = true
        self.navBar.isHidden = true
    }
    
}

extension BaseUIViewController :BaseUINavigationViewDelegate {
    func navDidTouchUpBackButton(withNavView nav: BaseUINavigationView) {
        if self.backType == .BACK_POP {
            self.navigationController?.popViewController(animated: true)
        } else if self.backType == .BACK_TO_ROOT {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    func navDidTouchUpRightButton(withNavView nav: BaseUINavigationView) {

    }
}
