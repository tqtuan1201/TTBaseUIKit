//
//  BasePaddingGenericView.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 4/11/20.
//  Copyright © 2020 Truong Quang Tuan. All rights reserved.
//


import Foundation
import UIKit

open class TTBasePaddingGenericView<BaseView:UIView>: TTBaseUIView {
    
    open var bgView:UIColor { get { return TTView.viewDefColor} }
    
    public var padding: UIEdgeInsets = UIEdgeInsets.init(top: TTSize.P_CONS_DEF, left: TTSize.P_CONS_DEF, bottom: TTSize.P_CONS_DEF, right: TTSize.P_CONS_DEF)
    public var baseView:BaseView = BaseView()

    public init(withAllPadding padding:CGFloat) {
        super.init()
        self.padding = UIEdgeInsets.init(top: padding, left: padding, bottom: padding, right: padding)
        self.setupCustomView()
        self.setupConstraints()
    }
    
    public init(withPadding padding:UIEdgeInsets) {
        super.init()
        self.padding = padding
        self.setupCustomView()
        self.setupConstraints()
    }
    
    public required init() {
        super.init()
        self.setupCustomView()
        self.setupConstraints()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init()
        self.setupCustomView()
        self.setupConstraints()
    }
    
}

extension TTBasePaddingGenericView {
        
    fileprivate func setupCustomView() {
        self.addSubview(self.baseView)
        self.setBgColor(self.bgView)
    }
    
    fileprivate func setupConstraints() {
        self.baseView.translatesAutoresizingMaskIntoConstraints = false
        self.baseView.setLeadingAnchor(constant: self.padding.left).setTrailingAnchor(constant: self.padding.right)
            .setTopAnchor(constant: self.padding.top).setBottomAnchor(constant: self.padding.bottom)
    }
    
}

