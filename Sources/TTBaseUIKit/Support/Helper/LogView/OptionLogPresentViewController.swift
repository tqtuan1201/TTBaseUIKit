//
//  File.swift
//  TTBaseUIKit
//
//  Created by TuanTruong on 25/7/25.
//

import Foundation
import UIKit

class TTBaseOptionLogPresentViewController: TTCoverVerticalViewController {
    
    
    let label:TTBaseUILabel  = TTBaseUILabel(withType: .TITLE, text: "📐 TTBaseDebugKit©", align: .left)
    let subLabel:TTBaseUILabel  = TTBaseUILabel(withType: .SUB_TITLE, text: "TTBaseDebugKit provides developers with powerful in-app tools for inspecting UI, tracking logs, and simulating environments—making debugging faster, easier, and more efficient", align: .left)
    
    let showLogButton:TTBaseUIButton = TTBaseUIButton(textString: "SHOW LOG API RESPONSE", type: .DEFAULT, isSetSize: false)
    let debugUIButton:TTBaseUIButton = TTBaseUIButton(textString: "DEBUG UI/LAYOUT\n(TRIPLE TAP THE SCREEN)", type: .WARRING, isSetSize: false)
    let captureBugButton:TTBaseUIButton = TTBaseUIButton(textString: "CAPTURE THE SCREEN", type: .WARRING, isSetSize: false)
    let showSettingButton:TTBaseUIButton = TTBaseUIButton(textString: "SETTING DEV", type: .WARRING, isSetSize: false)
    
    init(with title:String, subTitle:String) {
        super.init()
        self.label.setText(text: title)
        self.subLabel.setText(text: subTitle)
    }
    
    public var didLoad:( () -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.didLoad?()
    }
    
    override func updateBaseUI() {
        super.updateBaseUI()
        
        self.bgView = UIColor.black.withAlphaComponent(0.8)
        
        self.view.backgroundColor = UIColor.clear
        
        self.view.addSubview(self.label)
        self.view.addSubview(self.subLabel)
        self.view.addSubview(self.showLogButton)
        self.view.addSubview(self.debugUIButton)
        self.view.addSubview(self.captureBugButton)
        self.view.addSubview(self.showSettingButton)
        
        self.label.setVerticalContentHuggingPriority()
            .setLeadingAnchor(constant: 8).setTrailingAnchor(constant: 8)
            .setTopAnchor(constant: 10)
        
        self.subLabel.setVerticalContentHuggingPriority()
            .setLeadingAnchor(constant: 8).setTrailingAnchor(constant: 8)
            .setTopAnchorWithAboveView(nextToView: self.label, constant: 10)
        
        self.showLogButton.setTopAnchorWithAboveView(nextToView: self.subLabel, constant: 30)
            .setLeadingAnchor(constant: 8).setTrailingAnchor(constant: 8)
            .setHeightAnchor(constant: 35)
        
        self.debugUIButton.setTopAnchorWithAboveView(nextToView: self.showLogButton, constant: 8)
            .setLeadingAnchor(constant: 8).setTrailingAnchor(constant: 8)
            .setHeightAnchor(constant: 35)
        
        self.captureBugButton.setTopAnchorWithAboveView(nextToView: self.debugUIButton, constant: 8)
            .setLeadingAnchor(constant: 8).setTrailingAnchor(constant: 8)
            .setHeightAnchor(constant: 35)
            
        self.showSettingButton.setTopAnchorWithAboveView(nextToView: self.captureBugButton, constant: 8)
            .setLeadingAnchor(constant: 8).setTrailingAnchor(constant: 8)
            .setHeightAnchor(constant: 35)
            .setBottomAnchor(constant: 20, isMarginsGuide: true, priority: .defaultHigh)
        
        
    }
    
}
