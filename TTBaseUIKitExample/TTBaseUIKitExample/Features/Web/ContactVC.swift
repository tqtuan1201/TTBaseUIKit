//
//  ContactVC.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 5/2/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import Foundation
import TTBaseUIKit

class ContactVC: WebViewController {
    override var navType: TTBaseUIViewController<DarkBaseUIView>.NAV_STYLE { return .STATUS_NAV}
    override var lgNavType: BaseUINavigationView.TYPE { return .DEFAULT}
    override var isSetHiddenTabar: Bool { return false}
    
    init() {
        super.init(navTitle: "TTBaseUIKit", urlString: "https://tqtuan1201.github.io")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(navTitle: "TTBaseUIKit", urlString: "https://tqtuan1201.github.io")
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if #available(iOS 26.0, *) {
            self.tabBarController?.tabBar.backgroundColor = UIColor.clear
        } else {
            self.tabBarController?.tabBar.backgroundColor = UIColor.white
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
