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

    override func updateBaseUI() {
        super.updateBaseUI()

        self.view.addSubview(self.label)
        self.label.setFullContraints(constant: 0)
        self.label.setHeightAnchor(constant: 200)

        self.label.backgroundColor = UIColor.yellow.withAlphaComponent(0.2)

    }

}



