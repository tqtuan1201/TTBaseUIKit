//
//  DemoTableViewCell.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/7/24.
//  Copyright © 2024 Truong Quang Tuan. All rights reserved.
//

import TTBaseUIKit

class DemoTableViewCell :TTBaseUITableViewCell {
    
    let iconView:TTBaseUIImageView = TTBaseUIImageView()
    let titleLabel:TTBaseUILabel = TTBaseUILabel(withType: .TITLE, text: "Title Lable", align: .left)
    let subLabel:TTBaseUILabel = TTBaseUILabel(withType: .SUB_TITLE, text: "Copyright © 2024 Truong Quang Tuan. All rights reserved.", align: .left)
    let distanceLabel:TTBaseUILabel = TTBaseUILabel(withType: .SUB_TITLE, text: "300 m", align: .center)

    override func updateUI() {
        super.updateUI()
        self.setupBaseUIView()
    }
}

extension DemoTableViewCell {
    fileprivate func setupBaseUIView() {
        self.iconView.setImage(with: "layout", scale: .scaleAspectFit)
        self.distanceLabel.setTextColor(color: XView.textDefColor.withAlphaComponent(0.6))
        self.titleLabel.setBold().setMutilLine(numberOfLine: 3, textAlignment: .left)
        self.subLabel.setMutilLine(numberOfLine: 4, textAlignment: .left)
        
        self.panel.addSubview(self.iconView)
        self.panel.addSubview(self.titleLabel)
        self.panel.addSubview(self.subLabel)
        self.panel.addSubview(self.distanceLabel)
        
        self.iconView.setWidthAnchor(constant: XSize.H_ICON).setHeightAnchor(constant: XSize.H_ICON)
            .setLeadingAnchor(constant: XSize.P_CONS_DEF).setcenterYAnchor(constant: 0)
        
        self.titleLabel.setVerticalContentHuggingPriority()
            .setTopAnchor(constant: XSize.P_CONS_DEF * 2)
            .setLeadingWithNextToView(view: self.iconView, constant: XSize.P_CONS_DEF)
            .setTrailingWithNextToView(view: self.distanceLabel, constant: XSize.P_CONS_DEF)
        
        self.subLabel.setVerticalContentHuggingPriority()
            .setTopAnchorWithAboveView(nextToView: self.titleLabel, constant: XSize.P_CONS_DEF * 2)
            .setLeadingWithNextToView(view: self.iconView, constant: XSize.P_CONS_DEF)
            .setTrailingWithNextToView(view: self.distanceLabel, constant: XSize.P_CONS_DEF)
            .setBottomAnchor(constant: XSize.P_CONS_DEF * 2)
        
        self.distanceLabel.setFullContentHuggingPriority()
            .setTrailingAnchor(constant: XSize.P_CONS_DEF)
            .setcenterYAnchor(constant: 0)
            .widthAnchor.constraint(lessThanOrEqualToConstant: XSize.H_CELL * 1.5).isActive = true
    }
}
