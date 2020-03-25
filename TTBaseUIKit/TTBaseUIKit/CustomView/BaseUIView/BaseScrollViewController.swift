//
//  BaseScrollViewController.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 3/24/20.
//  Copyright © 2020 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseScrollViewController :TTBaseUIViewController<TTBaseUIView> {

    open var paddingScroll:(CGFloat, CGFloat, CGFloat, CGFloat) { get { return (0,0,0,0) } }
    
    public var baseScrollView:TTBaseScrollPanelView = TTBaseScrollPanelView()

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBaseView()
    }
    
}


extension TTBaseScrollViewController {
    
    fileprivate func setupBaseView() {
        self.view.addSubview(self.baseScrollView)
        self.baseScrollView.setFullContraints(lead: self.paddingScroll.0, trail: self.paddingScroll.2, top: self.paddingScroll.1, bottom: self.paddingScroll.3)
    }
}
