//
//  TTBaseStackScrollViewController.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 10/29/21.
//  Copyright © 2021 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseStackScrollViewController :TTBaseUIViewController<TTBaseUIView> {

    open var paddingScroll:(CGFloat, CGFloat, CGFloat, CGFloat) { get { return (0,0,0,0) } }
    open var isSetWidth:Bool { get { return true } }
    open var keyboardDismissMode:UIScrollView.KeyboardDismissMode { get { return UIScrollView.KeyboardDismissMode.onDrag } }
    
    public var stackScrollView:TTBaseScrollUIStackView = TTBaseScrollUIStackView(with: TTBaseUIStackView.init(axis: .vertical, spacing: TTSize.P_CONS_DEF, alignment: .fill))
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBaseView()
    }
    
    public init(withStackScrollView scrollView:TTBaseScrollUIStackView) {
        super.init()
        self.stackScrollView = scrollView
        self.setupBaseView()
    }
}


extension TTBaseStackScrollViewController {
    
    fileprivate func setupBaseView() {
        self.view.addSubview(self.stackScrollView)
        self.stackScrollView.setFullContraints(lead: self.paddingScroll.0, trail: self.paddingScroll.2, top: self.paddingScroll.1, bottom: self.paddingScroll.3)
        
        if self.isSetWidth { self.stackScrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true }
        self.stackScrollView.keyboardDismissMode = self.keyboardDismissMode
    }
}

