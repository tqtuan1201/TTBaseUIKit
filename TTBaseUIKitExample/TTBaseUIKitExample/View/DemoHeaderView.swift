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
    
    
    var panelVIew:TTBaseUIView = TTBaseUIView()
    var titleLable:TTBaseUILabel = TTBaseUILabel(withType: .TITLE, text: "TTBaseUIKit".uppercased(), align: .center).setBold()
    var versionLable:TTBaseUILabel = TTBaseUILabel(withType: .SUB_TITLE, text: "A framework to quickly create iOS project via base views", align: .center)
    
    
    var lineView:TTBaseUIView = TTBaseUIView()
    
    fileprivate let trailBorderAnimationView = TTBaseBorderTrailView(
        config: .init(
            lineWidth: 4,
            cornerRadius: 16,
            trailLength: 0.42,
            duration: 5.2,             // seconds per lap
            colors: [ XView.buttonBgDef.withAlphaComponent(0.8), UIColor.white.withAlphaComponent(0.8), UIColor.orange.withAlphaComponent(0.8) ],
            glowOpacity: 0.09
        )
    )
    
    
    override func updateBaseUIView() {
        super.updateBaseUIView()
        
        self.panelVIew.addSubview(self.titleLable)
        self.panelVIew.addSubview(self.versionLable)
        
        self.setupViewCodable(with: [bgImageView, profileImageView, self.panelVIew, self.lineView])
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
        
        
        self.panelVIew.setTopAnchorWithAboveView(nextToView: self.profileImageView, constant: XSize.P_CONS_DEF)
            .setLeadingAnchor(constant: XSize.P_CONS_DEF / 2).setTrailingAnchor(constant: XSize.P_CONS_DEF / 2, priority: .defaultHigh)
        
        self.titleLable.setVerticalContentHuggingPriority().setLeadingAnchor(constant: 2.0).setTrailingAnchor(constant: 2.0, priority: .defaultHigh)
            .setTopAnchor(constant: XSize.P_CONS_DEF)
        
        self.versionLable.setVerticalContentHuggingPriority().setLeadingAnchor(constant: XSize.P_CONS_DEF).setTrailingAnchor(constant: XSize.P_CONS_DEF, priority: .defaultHigh)
            .setTopAnchorWithAboveView(nextToView: self.titleLable, constant: XSize.P_CONS_DEF)
            .setBottomAnchor(constant: XSize.P_CONS_DEF)
        
        
        self.lineView.setHeightAnchor(constant: XSize.P_CONS_DEF)
            .setLeadingAnchor(constant: 0).setTrailingAnchor(constant: 0)
            .setBottomAnchor(constant: 0)
        
        
        self.trailBorderAnimationView.translatesAutoresizingMaskIntoConstraints = false
        self.trailBorderAnimationView.start()
        self.panelVIew.addSubview(self.trailBorderAnimationView)
        self.trailBorderAnimationView.setFullContraints(constant: 0)
    }
}
