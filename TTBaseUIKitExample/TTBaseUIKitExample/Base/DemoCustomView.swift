//
//  DemoCustomView.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 31/7/24.
//  Copyright © 2024 Truong Quang Tuan. All rights reserved.
//

import TTBaseUIKit

class DemoCustomView : TTBaseUIView {
    
    fileprivate let baseLabel:TTBaseUILabel = TTBaseUILabel.init(withType: .TITLE, text: "Title Label", align: .left).setBold()
    fileprivate let lineView:TTLineView = TTLineView()
    fileprivate let stackView:TTBaseUIStackView = .init(axis: .vertical, spacing: XSize.P_CONS_DEF, alignment: .fill, distributionValue: .fill)
    
    override func updateBaseUIView() {
        super.updateBaseUIView()
    }
    
    init(title:String, view:UIView) {
        super.init()
        self.setupViewCodable(with: [self.baseLabel, self.lineView, self.stackView])
        self.baseLabel.setText(text: title)
        self.stackView.addArrangedSubview(view)
        self.setTouchHandler().onTouchHandler = { _ in
            UIApplication.topViewController()?.showMessagePopup(mess: type(of: view).description(), completeHandle: nil)
        }
    }
    
    required init() {
        super.init()
        self.setupViewCodable(with: [self.baseLabel, self.stackView])
    }
}

//MARK://TTViewCodable blind
extension DemoCustomView :TTViewCodable {
    
    func setupData() {
        
    }
    
    func bindComponents() {
    }
}

//MARK://TTViewCodable BaseUI
extension DemoCustomView {
    
    func setupStyles() {
        self.setConerDef()
        self.setBgColor(UIColor.black.withAlphaComponent(0.1))
    }
    
    func setupCustomView() {
        
    }
    
    func setupConstraints() {
        self.baseLabel
            .setVerticalContentHuggingPriority()
            .setLeadingAnchor(constant: XSize.P_CONS_DEF).setTrailingAnchor(constant: XSize.P_CONS_DEF)
            .setTopAnchor(constant: XSize.P_CONS_DEF)
        
        self.lineView.setHeightAnchor(constant: 1)
            .setLeadingAnchor(constant: XSize.P_CONS_DEF).setTrailingAnchor(constant: XSize.P_CONS_DEF)
            .setTopAnchorWithAboveView(nextToView: self.baseLabel, constant: XSize.P_CONS_DEF)
        
        self.stackView.setTopAnchorWithAboveView(nextToView: self.lineView, constant: XSize.P_CONS_DEF * 1.4)
            .setLeadingAnchor(constant: XSize.P_CONS_DEF).setTrailingAnchor(constant: XSize.P_CONS_DEF)
            .setBottomAnchor(constant: XSize.P_CONS_DEF)
            .heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        
        
    }
    
}
