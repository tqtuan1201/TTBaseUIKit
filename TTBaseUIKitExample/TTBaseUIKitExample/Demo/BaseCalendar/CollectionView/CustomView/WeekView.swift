//
//  WeekView.swift
//  12BayV2
//
//  Created by Tuan Truong Quang on 8/1/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import TTBaseUIKit

class WeekView: TTBaseUIView {
    
    var daysArr = ["T2", "T3", "T4", "T5", "T6", "T7", "CN"]
    
    let panelStackView:TTBaseUIStackView = TTBaseUIStackView(axis: .horizontal, spacing: 0, alignment: .fill, distributionValue: .fillEqually)
    
    override func updateBaseUIView() {
        super.updateBaseUIView()
        
        self.addSubview(self.panelStackView)
        for day in self.daysArr {
            let dayLabel:TTBaseUILabel = TTBaseUILabel(withType: .TITLE, text: day, align: .center).setBold()
            self.panelStackView.addArrangedSubview(dayLabel)
        }
        self.panelStackView.setFullContraints(constant: 0)
    }
}
