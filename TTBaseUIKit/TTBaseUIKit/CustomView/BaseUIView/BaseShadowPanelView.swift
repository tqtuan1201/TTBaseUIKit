//
//  BaseShadowPanelView.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 9/4/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseShadowButtonView: TTBaseUIView {
    
    open var bgShadown:UIColor { get { return UIColor.darkGray.withAlphaComponent(0.4) }}
    open var textColor:UIColor {get { return TTView.textDefColor } }
    open var bgButton:UIColor { get { return .white } }
    
    public var button:TTBaseUIButton = TTBaseUIButton(textString: "BUTTON", type: .DEFAULT, isSetSize: false)
    public var shadowHeight:CGFloat = TTSize.P_CONS_DEF
    
    open func updateBaseShadowButtonView() { }
    public var onTouchButtonHandler:( () -> ())?
    
    public init(with button:TTBaseUIButton, shadownHeight:CGFloat = 8.0) {
        super.init()
        self.button = button
        self.shadowHeight = shadownHeight
        self.setupViewCodable(with: [self.button])
        self.updateBaseShadowButtonView()
    }
    
    required public init() { fatalError("init() has not been implemented") }

    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if self.layer.shadowPath == nil {
            self.layer.backgroundColor = UIColor.clear.cgColor
            self.layer.shadowColor = self.bgShadown.cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: self.shadowHeight )
            self.layer.shadowOpacity = 0.4
            self.layer.shadowRadius = 7.0
        }
    }
}

extension TTBaseShadowButtonView :TTViewCodable {
    
    public func bindComponents() {
        self.button.onTouchHandler = { [weak self] _ in self?.onTouchButtonHandler?() }
    }
    
    public func setupStyles() {
        if self.bgButton == UIColor.white {
            self.button.setBgColor(color: self.bgButton)
            self.button.setTextColor(color: self.textColor)
        }
    }
    
    public func setupConstraints() {
        self.button.setHeightAnchor(constant: TTSize.H_BUTTON)
        self.button.setFullContraints(lead: self.shadowHeight * 1.5, trail: self.shadowHeight * 1.5, top: 0, bottom: self.shadowHeight * 2)
    }
}


open class TTBaseShadowContentView<T: UIView>: TTBaseUIView {
    
    fileprivate var bgShadown:UIColor = UIColor.darkGray.withAlphaComponent(0.2)
    
    open var textColor:UIColor {get { return TTView.textDefColor } }
    open var bgPanel:UIColor { get { return .white } }
    
    public var panelView:T = T()
    public var shadowHeight:CGFloat = TTSize.P_CONS_DEF
    
    public init(with bgShadown:UIColor = UIColor.darkGray.withAlphaComponent(0.4)) {
        self.bgShadown = bgShadown
        super.init()
    }
    
    public required init() { super.init() }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if self.layer.shadowPath == nil {
            self.layer.backgroundColor = UIColor.clear.cgColor
            self.layer.shadowColor = self.bgShadown.cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: self.shadowHeight )
            self.layer.shadowOpacity = 0.4
            self.layer.shadowRadius = 7.0
        }
    }
    
    open override func updateBaseUIView() {
        super.updateBaseUIView()
        self.panelView.isUserInteractionEnabled = false
        self.addSubview(self.panelView)
        self.panelView.setFullContraints(lead: self.shadowHeight * 1.5, trail: self.shadowHeight * 1.5, top: 0, bottom: self.shadowHeight * 2.3)
    }
    
}

open class TTBaseShadowPanelView: TTBaseUIView {
    
    open var bgShadown:UIColor { get { return UIColor.darkGray.withAlphaComponent(0.4) }}
    open var textColor:UIColor {get { return TTView.textDefColor } }
    open var bgPanel:UIColor { get { return .white } }
    
    public var panelShadowView:TTBaseUIView = TTBaseUIView()
    public var shadowHeight:CGFloat = TTSize.P_CONS_DEF
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if self.layer.shadowPath == nil {
            self.layer.backgroundColor = UIColor.clear.cgColor
            self.layer.shadowColor = self.bgShadown.cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: self.shadowHeight )
            self.layer.shadowOpacity = 0.4
            self.layer.shadowRadius = 7.0
        }
    }
    
    open override func updateBaseUIView() {
        self.addSubview(self.panelShadowView)
        self.panelShadowView.setFullContraints(lead: self.shadowHeight * 1.5, trail: self.shadowHeight * 1.5, top: 0, bottom: self.shadowHeight * 2)
    }
}


open class TTBaseShadowPaddingPanelView: TTBaseUIView {
    
    open var bgShadown:UIColor { get { return UIColor.darkGray.withAlphaComponent(0.4) }}
    open var textColor:UIColor {get { return TTView.textDefColor } }
    open var bgPanel:UIColor { get { return .white } }
    open var shadowPadding:UIEdgeInsets { get { return .init(top: 0.0, left: TTSize.P_CONS_DEF, bottom: TTSize.P_CONS_DEF * 1.5, right: TTSize.P_CONS_DEF) } }
    
    public var panelShadowView:TTBaseUIView = TTBaseUIView()
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if self.layer.shadowPath == nil {
            self.layer.backgroundColor = UIColor.clear.cgColor
            self.layer.shadowColor = self.bgShadown.cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: self.shadowPadding.bottom / 2 )
            self.layer.shadowOpacity = 0.4
            self.layer.shadowRadius = 7.0
        }
    }
    
    open override func updateBaseUIView() {
        self.addSubview(self.panelShadowView)
        self.panelShadowView.setFullContraints(lead: self.shadowPadding.left, trail: self.shadowPadding.right, top: self.shadowPadding.top, bottom: self.shadowPadding.bottom)
    }
}
