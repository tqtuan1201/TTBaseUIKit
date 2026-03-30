//
//  ShowMessageViewController.swift
//  TTBaseUIKitExample
//
//  Created by Truong Quang Tuan on 6/8/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import TTBaseUIKit

class ShowMessageViewController: TTCoverVerticalViewController {
    
    fileprivate let paddingDef:CGFloat = TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF
    
    fileprivate let titleLabel:TTBaseUILabel = TTBaseUILabel(withType: .TITLE, text: "SELECT", align: .left)
    fileprivate let subtitleLabel:TTBaseUILabel = TTBaseUILabel(withType: .SUB_TITLE, text: "Please select", align: .left)
    fileprivate let panelStackView:TTBaseScrollUIStackView = TTBaseScrollUIStackView(with: TTBaseUIStackView(axis: .vertical, spacing: TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF, alignment: .fill))
    
    fileprivate let cancelButton:TTBaseUIButton = TTBaseUIButton(textString: "Cancel button", type: .WARRING, isSetSize: false)
    
    var didSelectType:((_ t:TTBaseNotificationViewConfig.POSITION) -> ())?
    override func updateBaseUI() {
        super.updateBaseUI()
        self.setupCustomView()
        self.bindComponents()
    }
    
}

fileprivate extension ShowMessageViewController  {
    
    func bindComponents() {
        self.cancelButton.onTouchHandler = { [weak self] _ in guard let strongSelf = self else { return }
            strongSelf.dismiss(animated: true, completion: nil)
        }
    }
    
    func setupCustomView() {
        
        self.titleLabel.setText(text: "PUSH MESSAGE VIEW")
        self.subtitleLabel.setMutilLine(numberOfLine: 4, textAlignment: .left)
        
        self.setBgColor(with: XView.dismissPresentLineBgview, safe: XView.dismissPresentLineBgview.withAlphaComponent(0.7))
        
        self.panelView.addSubview(self.titleLabel)
        self.panelView.addSubview(self.subtitleLabel)
        self.panelView.addSubview(self.panelStackView)
        self.panelView.addSubview(self.cancelButton)
        
        var heightPanelStack:CGFloat = 0
        for r in [TTBaseNotificationViewConfig.POSITION.TOP, TTBaseNotificationViewConfig.POSITION.BOTTOM, TTBaseNotificationViewConfig.POSITION.CENTER] {
            let lb:TTBaseInsetLabel = TTBaseInsetLabel(withType: .TITLE)
            var text:String = ""
            if r == .TOP {
                text = "POSITION.TOP"
            } else if r == .CENTER {
                text = "POSITION.CENTER"
            } else {
                text = "POSITION.BOTTOM"
            }
            lb.setBgColor(UIColor.white).setMutilLine(numberOfLine: 3, textAlignment: .left).setText(text: text)
            
            lb.setConerRadius(with: XSize.CORNER_RADIUS)
            
            lb.setTouchHandler().onTouchHandler = { [weak self] _ in guard let strongSelf = self else { return }
                strongSelf.didSelectType?(r)
                strongSelf.dismiss(animated: true, completion: nil)
            }
            
            self.panelStackView.baseStackView.addArrangedSubview(lb)
            
            heightPanelStack += lb.getHeight() + XSize.P_CONS_DEF
        }
        
        self.titleLabel.setVerticalContentHuggingPriority().setLeadingAnchor(constant: self.paddingDef).setTopAnchor(constant: self.paddingDef).setTrailingAnchor(constant: self.paddingDef)
        self.subtitleLabel.setVerticalContentHuggingPriority().setLeadingAnchor(constant: self.paddingDef).setTopAnchorWithAboveView(nextToView: self.titleLabel, constant: 0) .setTrailingAnchor(constant: self.paddingDef)
        
        
        self.panelStackView.setLeadingAnchor(constant: self.paddingDef).setTopAnchorWithAboveView(nextToView: self.subtitleLabel, constant: self.paddingDef * 2)
        self.panelStackView.setTrailingAnchor(constant: self.paddingDef)
        
        let limitHeight:CGFloat = XSize.H / 1.8
        if heightPanelStack > limitHeight {
            self.panelStackView.setHeightAnchor(constant: limitHeight)
        } else {
            self.panelStackView.setHeightAnchor(constant: heightPanelStack)
        }
        
        self.cancelButton.setLeadingAnchor(constant: self.paddingDef).setTrailingAnchor(constant: self.paddingDef)
        self.cancelButton.setTopAnchorWithAboveView(nextToView: self.panelStackView, constant: self.paddingDef * 2)
        self.cancelButton.setHeightAnchor(constant: XSize.H_BUTTON)
        self.cancelButton.setBottomAnchor(constant: self.paddingDef * 2).done()
    }
    
}
