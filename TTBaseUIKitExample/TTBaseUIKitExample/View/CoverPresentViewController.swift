//
//  CoverPresentViewController.swift
//  TTBaseUIKitExample
//
//  Created by Truong Quang Tuan on 6/11/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import TTBaseUIKit

class CoverPresentViewController: TTCoverVerticalViewController {

    let label:TTBaseUILabel  = TTBaseUILabel(withType: .TITLE, text: "CHILD VC", align: .center)
    fileprivate let bodyView:TTBaseShadowView = TTBaseShadowView()
    fileprivate let messageLabel:TTBaseUILabel = TTBaseUILabel.init(withType: .HEADER, text: "Demo\nCoverPresentViewController", align: .center)
    
    
    override func updateBaseUI() {
        super.updateBaseUI()
        self.messageLabel.setMutilLine(numberOfLine: 0, textAlignment: .center, mode: .byTruncatingTail)
        self.panelView.backgroundColor = XView.viewBgColor
        
        self.panelView.addSubview(self.bodyView)
        self.bodyView.addSubview(self.messageLabel)
        self.bodyView.setLeadingAnchor(constant: XSize.P_CONS_DEF * 3).setTrailingAnchor(constant: XSize.P_CONS_DEF * 3)
            .setTopAnchor(constant: XSize.P_CONS_DEF * 4).setBottomAnchor(constant: XSize.P_CONS_DEF * 4)
        
        self.messageLabel.setFullContraints(constant: XSize.P_CONS_DEF)
        
        self.view.setHeightAnchor(constant: XSize.H / 2)
    }

}



