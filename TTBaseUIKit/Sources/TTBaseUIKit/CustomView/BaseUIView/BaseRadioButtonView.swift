//
//  BaseRadioButtonView.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 7/1/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseRadioButtonView : TTIconLabelView {
    
    fileprivate var activeColor:UIColor = TTView.textWarringColor  { didSet { self.onHandleChangeStatus() } }
    fileprivate var nonActiveColor:UIColor = TTView.textDefColor  { didSet { self.onHandleChangeStatus() } }
    
    fileprivate var activeIcon:AwesomePro.Light = AwesomePro.Light.checkCircle  { didSet { self.onHandleChangeStatus() } }
    fileprivate var nonActiveIcon:AwesomePro.Light = AwesomePro.Light.circle  { didSet { self.onHandleChangeStatus() } }
    
    fileprivate var isActive:Bool = true { didSet { self.onHandleChangeStatus() } }
    
    
    public init(isActive:Bool) {
        super.init()
        self.isActive = isActive
        self.setupBaseUIView()
    }
    
    public init(isActive:Bool, activeColor:UIColor, nonActiveColor:UIColor) {
        super.init()
        self.isActive = isActive
        self.activeColor = activeColor
        self.nonActiveColor = nonActiveColor
        self.setupBaseUIView()
    }
    
    public init(isActive:Bool,activeIcon:AwesomePro.Light, activeColor:UIColor, nonActiveIcon:AwesomePro.Light, nonActiveColor:UIColor) {
        super.init()
        self.isActive = isActive
        self.activeColor = activeColor
        self.nonActiveColor = nonActiveColor
        self.activeIcon = activeIcon
        self.nonActiveIcon = nonActiveIcon
        self.setupBaseUIView()
    }
    
    public required init() {
        super.init()
        self.setupBaseUIView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK:// For Base Private Funcs
fileprivate extension TTBaseRadioButtonView {
    func setupBaseUIView() {
        self.iconImageView.setIConImage(with: .checkCircle)
        self.onHandleChangeStatus()
    }
    
    func onHandleChangeStatus() {
        if self.isActive {
            self.iconImageView.setIConImage(with: self.activeIcon, color: self.activeColor, size: CGSize(width: 35, height: 35))
            self.textLabel.setTextColor(color: self.activeColor)
        } else {
            self.iconImageView.setIConImage(with: self.nonActiveIcon, color: self.nonActiveColor, size: CGSize(width: 35, height: 35))
            self.textLabel.setTextColor(color: self.nonActiveColor)
        }
    }
}

//MARK:// For Base Public Funcs
extension TTBaseRadioButtonView {
    public func setText(textString:String) {
        self.textLabel.setText(text: textString)
    }
    
    public func setActive() {
        self.isActive = true
    }
    
    public func setNonActive() {
        self.isActive = false
    }
}
