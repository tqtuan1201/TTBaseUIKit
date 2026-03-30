//
//  CalendarCollectionViewCell.swift
//  12BayV2
//
//  Created by Tuan Truong Quang on 8/1/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import TTBaseUIKit


protocol CalendarCollectionViewCellRepresentable {
    var dayString:String { get }
    var luminarString:String { get }
    var isEnable:Bool { get }
    var isShowCurrentDateCircle:Bool { get }
    var isShowPeriodCircle:Bool { get }
    var isAddLineView:Bool { get }
    var isShowFromRootView:Bool { get }
    var isShowToRootView:Bool { get }
}


class CalendarCollectionViewCell: TTBaseUICollectionViewCell {
    override var padding: CGFloat { get { return 0.0 }}
    
    public let dayLabel:TTBaseUILabel = TTBaseUILabel(withType: .TITLE, text: "DAY", align: .center)
    public let luminarLable:TTBaseUILabel = TTBaseUILabel(withType: .SUB_SUB_TILE, text: "Luminar", align: .center)
    public let selectedCircleView:TTBaseUICricleView = TTBaseUICricleView(withBorder: 0, color: UIColor.clear)
    
    fileprivate let lineView:TTBaseUIView = TTBaseUIView()
    
    fileprivate let lineFromViewRoot:TTBaseUIView = TTBaseUIView()
    fileprivate let lineToViewRoot:TTBaseUIView = TTBaseUIView()
    
    override func updateUI() {
        super.updateUI()
        self.setupViewCodable(with: [self.dayLabel, self.luminarLable, self.selectedCircleView, self.lineView, self.lineFromViewRoot, self.lineToViewRoot])
    }
    
    fileprivate func setTextColor(with color:UIColor) {
        self.dayLabel.setTextColor(color: color)
        self.luminarLable.setTextColor(color: color.withAlphaComponent(0.2))
    }
}

extension CalendarCollectionViewCell : TTViewCodable {
    
    func setupStyles() {
        
        self.selectedCircleView.setBgColor(XView.viewBgNavColor)
        self.lineView.setBgColor(XView.viewBgNavColor.withAlphaComponent(0.1))
        self.lineFromViewRoot.setBgColor(XView.viewBgNavColor.withAlphaComponent(0.1))
        self.lineToViewRoot.setBgColor(XView.viewBgNavColor.withAlphaComponent(0.1))
        self.dayLabel.setBgColor(UIColor.clear)
        self.panel.setBgColor(UIColor.clear)
        self.bringSubviewToFront(self.dayLabel)
    }
    func setupConstraints() {
        self.dayLabel.setFullContentHuggingPriority().setFullCenterAnchor(constant: 0)
        self.luminarLable.setFullContentHuggingPriority()
            .setTrailingAnchor(constant: XSize.P_CONS_DEF / 6)
            .setTopAnchorWithAboveView(nextToView: self.dayLabel, constant: XSize.P_CONS_DEF / 4)
        
        self.selectedCircleView.setFullCenterAnchor(constant: 0)
        self.selectedCircleView.heightAnchor.constraint(equalTo: self.panel.heightAnchor, multiplier: 0.9).isActive = true
        self.selectedCircleView.heightAnchor.constraint(equalTo:  self.selectedCircleView.widthAnchor, multiplier: 1).isActive = true
        
        self.lineView.setLeadingAnchor(constant: 0).setTrailingAnchor(constant: 0).setcenterYAnchor(constant: 0)
            .heightAnchor.constraint(equalTo: self.panel.heightAnchor, multiplier: 0.85).isActive = true
        
        self.lineFromViewRoot.setLeadingAnchor(constant: 0).setcenterYAnchor(constant: 0)
        self.lineFromViewRoot.widthAnchor.constraint(equalTo: self.panel.widthAnchor, multiplier: 0.5).isActive = true
        self.lineFromViewRoot.heightAnchor.constraint(equalTo: self.panel.heightAnchor, multiplier: 0.85).isActive = true
        
        self.lineToViewRoot.setTrailingAnchor(constant: 0).setcenterYAnchor(constant: 0)
        self.lineToViewRoot.widthAnchor.constraint(equalTo: self.panel.widthAnchor, multiplier: 0.5).isActive = true
        self.lineToViewRoot.heightAnchor.constraint(equalTo: self.panel.heightAnchor, multiplier: 0.85).isActive = true

    }
    
}

extension CalendarCollectionViewCell {
    func configure(withRepresentable viewModel: CalendarCollectionViewCellRepresentable) {
        
        self.dayLabel.setText(text: viewModel.dayString)
        
        self.luminarLable.setText(text: viewModel.luminarString)
        
        if viewModel.isEnable {
            self.setTextColor(with: XView.textDefColor)
        } else {
            self.setTextColor(with: XView.textDefColor.withAlphaComponent(0.2))
        }
        
        if viewModel.isShowCurrentDateCircle {
            self.setTextColor(with: XView.textWarringColor)
        }
        
        if viewModel.isShowPeriodCircle {
            self.selectedCircleView.isHidden = false
            self.setTextColor(with: UIColor.white)
        } else {
            self.selectedCircleView.isHidden = true
        }
        
        if viewModel.isAddLineView {
            self.lineView.isHidden = false
            
        } else {
            self.lineView.isHidden = true
        }
        
        if viewModel.isShowToRootView {
            self.lineFromViewRoot.isHidden = false
        } else {
            self.lineFromViewRoot.isHidden = true
        }
        
        if viewModel.isShowFromRootView {
            self.lineToViewRoot.isHidden = false
        } else {
            self.lineToViewRoot.isHidden = true
        }
    }
}

