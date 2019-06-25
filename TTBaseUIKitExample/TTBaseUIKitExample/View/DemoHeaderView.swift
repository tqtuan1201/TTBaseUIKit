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
    
    var bgImageView:TTBaseUIImageView = TTBaseUIImageView(imageName: "bg.view", contentMode: .scaleAspectFill)
    var profileImageView:TTUIImageCircleView = TTUIImageCircleView(imageName: "TTBaseUIKit", contentMode: .scaleAspectFill)
    var titleLable:TTBaseUILabel = TTBaseUILabel(withType: .TITLE, text: "TTBaseUIKit View programmatically".uppercased(), align: .center)
    var versionLable:TTBaseUILabel = TTBaseUILabel(withType: .SUB_TITLE, text: "Verion 1.0", align: .center)
    
    override func updateBaseUIView() {
        super.updateBaseUIView()
        self.setupViewCodable(with: [bgImageView, profileImageView, titleLable, versionLable])
        

    }

}

extension DemoHeaderView : TTViewCodable {
    
    func setupData() {
        self.titleLable.setMutilLine(numberOfLine: 2, textAlignment: .center).done()
    }
    
    func setupConstraints() {
        self.bgImageView.setLeadingAnchor(constant: 0).setTopAnchor(constant: 0).setTrailingAnchor(constant: 0).heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
        
        self.profileImageView.setCenterXAnchor(constant: 0).setcenterYAnchor(constant: 0).done()
        self.profileImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
        self.profileImageView.widthAnchor.constraint(equalTo: self.profileImageView.heightAnchor, multiplier: 1).isActive = true
        
        self.titleLable.setVerticalContentHuggingPriority().setLeadingAnchor(constant: PADDING_LABEL_TEXT).setTrailingAnchor(constant: PADDING_LABEL_TEXT, priority: .defaultHigh)
            .setTopAnchorWithAboveView(nextToView: self.profileImageView, constant: XSize.P_CONS_DEF).done()
        
        self.versionLable.setVerticalContentHuggingPriority().setLeadingAnchor(constant: PADDING_LABEL_TEXT).setTrailingAnchor(constant: PADDING_LABEL_TEXT, priority: .defaultHigh)
            .setTopAnchorWithAboveView(nextToView: self.titleLable, constant: 0).done()
        
    }
}
