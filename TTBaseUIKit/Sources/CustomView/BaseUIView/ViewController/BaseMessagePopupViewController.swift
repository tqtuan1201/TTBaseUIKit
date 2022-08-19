//
//  BaseMessagePopupViewController.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 2/18/21.
//  Copyright © 2021 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

public class TTBaseMessagePopupViewController : TTBasePopupViewController {
    
    public let titleLabel:TTBaseUILabel = TTBaseUILabel(withType: .TITLE, text: "App.Update.Title".localize(withBundle: Bundle.main), align: .center).setBold()
    public let subLabel:TTBaseUILabel = TTBaseUILabel(withType: .SUB_TITLE, text: "App.Update.SubTitle".localize(withBundle: Bundle.main), align: .center)
    
    public let cancelButton:TTBaseUIButton = TTBaseUIButton(textString: "App.Button.Cancel".localize(withBundle: Bundle.main), type: .DEFAULT, isSetSize: false).setBgColor(color: TTView.lineDefColor)
    public let agreeButton:TTBaseUIButton = TTBaseUIButton(textString: "App.Button.Update".localize(withBundle: Bundle.main), type: .DEFAULT, isSetSize: false).setBgColor(color: TTView.buttonBgDef)
    
    public let stackView:TTBaseUIStackView = TTBaseUIStackView(axis: .horizontal, spacing: TTSize.P_CONS_DEF, alignment: .fill, distributionValue: .fill)
    
    public let panelView:TTBaseUIView = TTBaseUIView(withCornerRadius: TTSize.CORNER_RADIUS)

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewCodable(with: [self.panelView])
    }
    
}

extension TTBaseMessagePopupViewController : TTViewCodable {
    
    
    public func setupData() {

    }
    
    public func setupStyles() {
        self.cancelButton.setTextColor(color: TTView.textDefColor)
        self.cancelButton.contentEdgeInsets.left = TTSize.P_CONS_DEF * 2
        self.cancelButton.contentEdgeInsets.right = TTSize.P_CONS_DEF * 2
        self.subLabel.setMutilLine(numberOfLine: 0, textAlignment: .center, mode: .byTruncatingTail)
    }
    
    public func setupCustomView() {
        
        self.panelView.addSubview(self.titleLabel)
        self.panelView.addSubview(self.subLabel)
        self.panelView.addSubview(self.stackView)
        
        self.stackView.addArrangedSubview(self.cancelButton)
        self.stackView.addArrangedSubview(self.agreeButton)
        
    }

    
    public  func setupConstraints() {
        self.titleLabel.setVerticalContentHuggingPriority()
            .setLeadingAnchor(constant: TTSize.getPaddingDef()).setTrailingAnchor(constant: TTSize.getPaddingDef())
            .setTopAnchor(constant: TTSize.getPaddingDef())
        
        self.subLabel.setVerticalContentHuggingPriority()
            .setTopAnchorWithAboveView(nextToView: self.titleLabel, constant: TTSize.getPaddingDef())
            .setLeadingAnchor(constant: TTSize.getPaddingDef()).setTrailingAnchor(constant: TTSize.getPaddingDef())
        
        
        self.cancelButton.setHorizontalContentHuggingPriority()
        
        self.stackView.setTopAnchorWithAboveView(nextToView: self.subLabel, constant: TTSize.getPaddingDef())
            .setLeadingAnchor(constant: TTSize.getPaddingDef()).setTrailingAnchor(constant: TTSize.getPaddingDef())
            .setBottomAnchor(constant: TTSize.getPaddingDef())
            .setHeightAnchor(constant: TTSize.H_BUTTON)
        
        
        self.panelView.setLeadingAnchor(constant: TTSize.getPaddingDef()).setTrailingAnchor(constant: TTSize.getPaddingDef())
            .setcenterYAnchor(constant: 0)
    }
}

extension UIViewController {
    
    public func showPopupConfirm(withText title:String = NSLocalizedString("App.Key.Notice", comment: ""), subTitle:String, leftButton:String?, rightButton:String?, isAllowTouchPanel:Bool = true, isRevertButtonColor:Bool = false, onTouchCancelHandle:( () -> ())? = nil, onTouchAgreeHandle:( () -> ())? = nil ) {
        
        DispatchQueue.main.async { [weak self] in guard let strongSelf = self else { return }
            
            let showPopupVC:TTBaseMessagePopupViewController = TTBaseMessagePopupViewController(isAllowTouchPanel: isAllowTouchPanel)
            if let _leftButton = leftButton { showPopupVC.cancelButton.setText(text: _leftButton) } else { showPopupVC.cancelButton.isHidden = true }
            if let _rightButton = rightButton { showPopupVC.agreeButton.setText(text: _rightButton) } else { showPopupVC.agreeButton.isHidden = true }
            showPopupVC.titleLabel.setText(text: title)
            showPopupVC.subLabel.setText(text: subTitle)
        
            if isRevertButtonColor {
                showPopupVC.cancelButton.setBgColor(color: TTView.buttonBgDef)
                showPopupVC.cancelButton.setTextColor(color: .white)
                showPopupVC.agreeButton.setBgColor(color: TTView.lineDefColor)
                showPopupVC.agreeButton.setTextColor(color: TTView.textDefColor)
            }
            
            strongSelf.presentDef(vc: showPopupVC, type: .overFullScreen)
            
            showPopupVC.cancelButton.onTouchHandler = { _ in
                showPopupVC.dismiss(animated: true) {
                    onTouchCancelHandle?()
                }
            }
            
            showPopupVC.agreeButton.onTouchHandler = { _ in
                showPopupVC.dismiss(animated: true) {
                    onTouchAgreeHandle?()
                }
            }
        }
    }
}
