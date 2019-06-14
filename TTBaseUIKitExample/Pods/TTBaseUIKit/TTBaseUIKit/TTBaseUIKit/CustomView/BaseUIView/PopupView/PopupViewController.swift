//
//  PopupViewController.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 5/20/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTPopupViewController: TTBasePopupViewController {
    
    fileprivate lazy var titleString:String = ""
    fileprivate lazy var subString:String = ""
    
    
    public lazy var HEIGHT_BUTTON:CGFloat = TTSize.H_BUTTON
    
    public lazy var panelView:TTBaseUIView = TTBaseUIView(withCornerRadius: TTSize.CORNER_RADIUS)
    public lazy var titleLabel:TTBaseUILabel = TTBaseUILabel(withType: .TITLE, text: "Title Label", align: .center)
    public lazy var subTitle:TTBaseUILabel = TTBaseUILabel(withType: .SUB_TITLE, text: "Sub title for descriptions", align: .center)
    
    public lazy var buttons:[TTBaseUIButton] = []
    public lazy var cancelButton:TTBaseUIButton = TTBaseUIButton(textString: "Cancel", type: .DEFAULT, isSetSize: false)
    public lazy var okButton:TTBaseUIButton = TTBaseUIButton(textString: "OK", type: .WARRING, isSetSize: false)
    
    var didTouchCancelButton:(() -> Void)?
    var didTouchOKButton:(() -> Void)?
    
    fileprivate let panelButtonView:TTBaseUIStackView = TTBaseUIStackView(axis: .horizontal, spacing: TTSize.P_CONS_DEF, alignment: .fill, distributionValue: .fillEqually)
    
    
    override init(isAllowTouchPanel: Bool) {
        super.init(isAllowTouchPanel: isAllowTouchPanel)
    }
    
    public convenience init(title:String, subTitle:String, isAllowTouchPanel:Bool = true) {
        self.init(isAllowTouchPanel: isAllowTouchPanel)
        self.titleString = title
        self.subString = subTitle
        self.setupData()
    }
    
    public convenience init(title:String, subTitle:String, buttons:[TTBaseUIButton], isAllowTouchPanel:Bool = true) {
        self.init(isAllowTouchPanel: isAllowTouchPanel)
        self.titleString = title
        self.subString = subTitle
        self.buttons = buttons
        self.setupData()
        self.setupButtons()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewCodable(with: [])
    }
}

extension TTPopupViewController : TTViewCodable {
    
    fileprivate func setupButtons() {
        self.okButton.removeFromSuperview()
        self.cancelButton.removeFromSuperview()
        for btn in self.buttons {
            self.panelButtonView.addArrangedSubview(btn)
        }
    }
    
    open func setupStyles() {
        self.titleLabel.setMutilLine(numberOfLine: 2, textAlignment: .center).done()
        self.subTitle.setMutilLine(numberOfLine: 0, textAlignment: .center).done()
    }
    
    
    open func setupData() {
        self.titleLabel.setText(text: self.titleString).done()
        self.subTitle.setText(text: self.subString).done()
    }
    
    open func setupCustomView() {
        
        self.panelButtonView.addArrangedSubview(self.cancelButton)
        self.panelButtonView.addArrangedSubview(self.okButton)
        
        self.panelView.addSubview(titleLabel)
        self.panelView.addSubview(subTitle)
        self.panelView.addSubview(panelButtonView)
        
        self.view.addSubview(self.panelView)
    }
    
    public func bindViewModel() {
        self.cancelButton.onTouchHandler = { [weak self] button in guard let strongSelf = self else { return }
            strongSelf.didTouchCancelButton?()
            strongSelf.dismiss(animated: true, completion: nil)
        }
        self.okButton.onTouchHandler = { [weak self] button in guard let strongSelf = self else { return }
            strongSelf.didTouchOKButton?()
            strongSelf.dismiss(animated: true, completion: nil)
        }
    }
    
    open func setupConstraints() {
        if Device.isPad() {
            self.panelView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
        } else {
            self.panelView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85).isActive = true
        }
        
        self.panelView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 1).isActive = true
        self.panelView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 1).isActive = true
        
        
        self.titleLabel.setVerticalContentHuggingPriority().setTopAnchor(constant: P_CONS_DEF * 2).setLeadingAnchor(constant: P_CONS_DEF * 4).setTrailingAnchor(constant: P_CONS_DEF * 4).done()
        
        self.subTitle.setVerticalContentHuggingPriority().setTopAnchorWithAboveView(nextToView: self.titleLabel, constant: P_CONS_DEF * 2).done()
        self.subTitle.setLeadingAnchor(constant: P_CONS_DEF * 2).setTrailingAnchor(constant: P_CONS_DEF * 2).done()
        let lessThanOrEqualToConstant =  self.subTitle.heightAnchor.constraint(lessThanOrEqualToConstant: TTSize.H_CELL * 4)
        lessThanOrEqualToConstant.priority = .defaultHigh
        lessThanOrEqualToConstant.isActive = true
        
        
        self.panelButtonView.setTopAnchorWithAboveView(nextToView: self.subTitle, constant: P_CONS_DEF * 1.5).setHeightAnchor(constant: self.HEIGHT_BUTTON).done()
        self.panelButtonView.setLeadingAnchor(constant: P_CONS_DEF * 2).setTrailingAnchor(constant: P_CONS_DEF * 2).setBottomAnchor(constant: P_CONS_DEF * 2).done()
    }
}
