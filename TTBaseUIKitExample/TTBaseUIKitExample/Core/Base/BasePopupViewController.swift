//
//  BasePopupViewController.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 2/8/24.
//  Copyright © 2024 Truong Quang Tuan. All rights reserved.
//

import TTBaseUIKit

class BasePopupViewController: TTBasePopupViewController {
    
    fileprivate let PADDING_ANIMATION:CGFloat = 100
    let bgImageView:TTBaseUIImageView = TTBaseUIImageView(imageName: "bgHeader.png", contentMode: .top)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBaseUIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        DispatchQueue.main.async { [weak self] in guard let strongSelf = self else { return }
            strongSelf.bgImageView.setMapBaseAnimation(withPadding: strongSelf.PADDING_ANIMATION)
        }
    }
}


//MARK:// For base private funcs
fileprivate extension BasePopupViewController {
    func setupBaseUIView() {
        self.view.backgroundColor = XView.labelBgDef
        self.view.addSubview(self.bgImageView)
        self.bgImageView.contentMode = .scaleAspectFill
        self.bgImageView.isUserInteractionEnabled = false
        self.bgImageView.setTopAnchor(constant: 0)
            .setLeadingAnchor(constant: -self.PADDING_ANIMATION).setTrailingAnchor(constant: 0)
            .setHeightAnchor(constant: XSize.H / 2)
    }
}

class BasePanelShadowView : TTBaseUIView {

    open var padingView:(CGFloat, CGFloat, CGFloat) { get { return (30,18,10)}}
    open var paddingNewPanel:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (0,0,0,0)}}
    open var paddingShadowLayer1:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (XSize.P_CONS_DEF * 1.5,6,XSize.P_CONS_DEF * 1.5,30)}}
    open var paddingShadowLayer2:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (XSize.P_CONS_DEF * 4,4,XSize.P_CONS_DEF * 4,100)}}
    
    let newPanel:TTBaseUIView = TTBaseUIView()
    let shadowViewLayer1:TTBaseUIView = TTBaseUIView(withCornerRadius: XSize.CORNER_RADIUS)
    let shadowViewLayer2:TTBaseUIView = TTBaseUIView(withCornerRadius: XSize.CORNER_RADIUS)
    
    override func updateBaseUIView() {
        super.updateBaseUIView()
        self.backgroundColor = UIColor.clear
    
        self.newPanel.setBgColor(UIColor.white)
        
        self.shadowViewLayer1.setBgColor(UIColor.white.withAlphaComponent(0.7))
        self.shadowViewLayer2.setBgColor(UIColor.white.withAlphaComponent(0.4))
        
        self.newPanel.setCorner(withCornerRadius: XSize.CORNER_RADIUS)
        
        self.shadowViewLayer1.isUserInteractionEnabled = false
        self.shadowViewLayer2.isUserInteractionEnabled = false
        
        
        self.addSubview(self.shadowViewLayer1)
        self.addSubview(self.shadowViewLayer2)
        self.addSubview(self.newPanel)

        self.shadowViewLayer2.setLeadingAnchor(constant: self.paddingShadowLayer2.0).setTopAnchor(constant: padingView.2)
            .setTrailingAnchor(constant: self.paddingShadowLayer2.2).setHeightAnchor(constant: self.paddingShadowLayer2.3)
        
        self.shadowViewLayer1.setLeadingAnchor(constant: self.paddingShadowLayer1.0).setTrailingAnchor(constant: self.paddingShadowLayer1.2)
            .setHeightAnchor(constant: self.paddingShadowLayer1.3).setTopAnchor(constant: padingView.1)
        
        self.newPanel.setLeadingAnchor(constant: self.paddingNewPanel.0).setTopAnchor(constant: padingView.0)
            .setTrailingAnchor(constant: self.paddingNewPanel.2).setBottomAnchor(constant: self.paddingNewPanel.3)
    }
    
}
