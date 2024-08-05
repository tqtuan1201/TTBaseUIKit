//
//  MonthView.swift
//  12BayV2
//
//  Created by Tuan Truong Quang on 8/1/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import TTBaseUIKit

class MonthView: TTBaseUIView {
    
    fileprivate let enableColor:UIColor = UIColor.darkGray.withAlphaComponent(0.1)
    fileprivate let nonEnableColor:UIColor = UIColor.darkGray.withAlphaComponent(0.05)
    
    fileprivate var currentMonth:Date = Date()
    
    let backIconView:TTUIImageFontCircleView = TTUIImageFontCircleView(with: AwesomePro.Light.angleLeft.rawValue, iconColor: XView.iconColor, bgColor: UIColor.clear, paddingContent: 1, borderWidth: 0, borderColor: UIColor.clear)
    
    let nextIconView:TTUIImageFontCircleView = TTUIImageFontCircleView(with: AwesomePro.Light.angleRight.rawValue, iconColor: XView.iconColor, bgColor: UIColor.clear, paddingContent: 1, borderWidth: 0, borderColor: UIColor.clear)
    
    let nameMonthLabel:TTBaseUILabel = TTBaseUILabel(withType: .HEADER, text: "MONTH", align: .center)
    
    let panelStackView:TTBaseUIStackView = TTBaseUIStackView(axis: .horizontal, spacing: XSize.P_CONS_DEF / 2, alignment: .center, distributionValue: .fill)
    
    init(with currentMonth:Date = Date()) {
        super.init()
        self.currentMonth = currentMonth
        self.setupViewCodable(with: [panelStackView])
    }
    
    required init() {
        super.init()
        self.setupViewCodable(with: [panelStackView])
    }
}

extension MonthView : TTViewCodable {
    
    func setBackNonEnable() {
        self.backIconView.setBgColor(self.nonEnableColor)
        self.backIconView.imageCircleView.setIconColor(UIColor.white)
    }
    
    func setBackEnable() {
        self.backIconView.imageCircleView.setIconColor(XView.iconColor)
        self.backIconView.setBgColor(self.enableColor)
    }
    
    func setNextNonEnable() {
        self.backIconView.imageCircleView.setIconColor(UIColor.white)
        self.nextIconView.setBgColor(self.nonEnableColor)
    }
    
    func setNextEnable() {
        self.backIconView.imageCircleView.setIconColor(XView.iconColor)
        self.nextIconView.setBgColor(self.enableColor)
    }
    
    
    func setupData() {
        self.nameMonthLabel.setText(text: self.currentMonth.monthNameFull().uppercased())
    }
    
    func setupStyles() {
        self.backIconView.setBgColor(self.enableColor)
        self.nextIconView.setBgColor(self.enableColor)
    }
    
    func setupCustomView() {
        self.panelStackView.addArrangedSubview(self.backIconView)
        self.panelStackView.addArrangedSubview(self.nameMonthLabel)
        self.panelStackView.addArrangedSubview(self.nextIconView)
    }
    
    func setupConstraints() {
        self.panelStackView.setFullContraints(constant: 0)
        
        self.backIconView.setWidthAnchor(constant: XSize.H_SMALL_ICON).setHeightAnchor(constant: XSize.H_SMALL_ICON)
        self.nextIconView.setWidthAnchor(constant: XSize.H_SMALL_ICON).setHeightAnchor(constant: XSize.H_SMALL_ICON)
    }
}
