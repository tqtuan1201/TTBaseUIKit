//
//  HomeNewHealthProductsViewCollectionCell.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 31/7/24.
//  Copyright © 2024 Truong Quang Tuan. All rights reserved.
//

import Foundation
import TTBaseUIKit

class DemoBaseUICollectionViewCell: TTBaseUICollectionViewCell {
    
    override var padding: CGFloat {get { return 0 } }
    override var isSetPanelBgColor: Bool {get { return false } }
    override var bgColor: UIColor { get { return .clear } }
    
    let backGroundView: TTBaseUIView = TTBaseUIView()// = BaseShadowView()
    
    let image:TTBaseUIImageView = TTBaseUIImageView(imageName: "AppIcon", contentMode: .scaleAspectFill)
    let nameLabel:TTBaseUILabel = TTBaseUILabel(withType: .TITLE, text: "Require two line\nDescription...", align: .left).setBold().setTextColor(color: XView.textDefColor)
    let priveLabel:TTBaseUILabel = TTBaseUILabel(withType: .TITLE, text: "Price...", align: .left).setTextColor(color: XView.textDefColor)
    
    override func updateUI() {
        super.updateUI()
        self.setupViewCodable(with: [])
    }
}

extension DemoBaseUICollectionViewCell :TTViewCodable {
    
    func setupStyles() {
        self.image.setConerDef()
        self.nameLabel.setMutilLine(numberOfLine: 2, textAlignment: .left, mode: .byTruncatingTail).setNonBold()
        self.priveLabel.setBold()
        self.panel.setBgColor(.clear)
    }
    
    func setupCustomView() {
        self.panel.addSubview(self.backGroundView)
        self.panel.addSubviews(views: [self.image, self.nameLabel, self.priveLabel])
    }
    
    func setupConstraints() {
        
        self.backGroundView
            .setFullContraints(constant: 0)
        
        let paddingImage:CGFloat = XSize.P_CONS_DEF * 2.0
        
        self.image.setTopAnchor(constant: paddingImage)
            .setLeadingAnchor(constant: paddingImage).setTrailingAnchor(constant: paddingImage)
            .heightAnchor.constraint(equalTo: self.image.widthAnchor, constant: 1.0).isActive = true
        
        self.nameLabel.setVerticalContentHuggingPriority()
            .setLeadingAnchor(constant: XSize.P_CONS_DEF * 2).setTrailingAnchor(constant: XSize.P_CONS_DEF)
            .setTopAnchorWithAboveView(nextToView: self.image, constant: XSize.P_CONS_DEF * 2)
        
        self.priveLabel.setVerticalContentHuggingPriority()
            .setLeadingAnchor(constant: XSize.P_CONS_DEF * 2).setTrailingAnchor(constant: XSize.P_CONS_DEF)
            .setTopAnchorWithAboveView(nextToView: self.nameLabel, constant: XSize.P_CONS_DEF * 1.4)
        
        }
}

