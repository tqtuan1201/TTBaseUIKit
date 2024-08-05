//
//  DemoHeaderView.swift
//  TTBaseUIKitExample
//
//  Created by Truong Quang Tuan on 6/7/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import TTBaseUIKit

class DemoHeaderView: TTBaseHeaderView {
    
    fileprivate let BORDER_HEIGHT:CGFloat = 8
    fileprivate let PADDING_LABEL_TEXT:CGFloat = XSize.P_CONS_DEF * 2
    fileprivate let PADDING_ANIMATION:CGFloat = 100
    
    var bgImageView:TTBaseUIImageView = TTBaseUIImageView(imageName: ["bg.view", "bgView1"].randomElement() ?? "bg.view", contentMode: .scaleAspectFill)
    var profileImageView:TTUIImageCircleView = TTUIImageCircleView(imageName: "TTBaseUIKit", contentMode: .scaleAspectFill)
    var titleLable:TTBaseUILabel = TTBaseUILabel(withType: .TITLE, text: "TTBaseUIKit".uppercased(), align: .center).setBold()
    var versionLable:TTBaseUILabel = TTBaseUILabel(withType: .SUB_TITLE, text: "A framework to quickly create iOS project via base views", align: .center)
    var lineView:TTBaseUIView = TTBaseUIView()
    override func updateBaseUIView() {
        super.updateBaseUIView()
        self.setupViewCodable(with: [bgImageView, profileImageView, titleLable, versionLable, self.lineView])
        self.bgImageView.setMapBaseAnimation(withPadding: PADDING_ANIMATION)
    }

}

extension DemoHeaderView : TTViewCodable {
    
    func setupData() {
        self.titleLable.setMutilLine(numberOfLine: 2, textAlignment: .center).done()
        self.lineView.setBgColor(UIColor.getColorFromHex(netHex: 0xd9d9d9))
    }
    
    func setupConstraints() {
        self.bgImageView.setLeadingAnchor(constant: -self.PADDING_ANIMATION).setTopAnchor(constant: 0).setTrailingAnchor(constant: 0).heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
        
        self.profileImageView.setCenterXAnchor(constant: 0).setcenterYAnchor(constant: 0).done()
        self.profileImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
        self.profileImageView.widthAnchor.constraint(equalTo: self.profileImageView.heightAnchor, multiplier: 1).isActive = true
        
        self.titleLable.setVerticalContentHuggingPriority().setLeadingAnchor(constant: PADDING_LABEL_TEXT).setTrailingAnchor(constant: PADDING_LABEL_TEXT, priority: .defaultHigh)
            .setTopAnchorWithAboveView(nextToView: self.profileImageView, constant: XSize.P_CONS_DEF).done()
        
        self.versionLable.setVerticalContentHuggingPriority().setLeadingAnchor(constant: PADDING_LABEL_TEXT).setTrailingAnchor(constant: PADDING_LABEL_TEXT, priority: .defaultHigh)
            .setTopAnchorWithAboveView(nextToView: self.titleLable, constant: 0).done()
        self.lineView.setHeightAnchor(constant: XSize.P_CONS_DEF)
            .setLeadingAnchor(constant: 0).setTrailingAnchor(constant: 0)
            .setBottomAnchor(constant: 0)
        
    }
}
