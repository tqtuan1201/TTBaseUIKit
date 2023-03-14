//
//  BaseTwoButtonDiffWidthView.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 3/7/20.
//  Copyright © 2020 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseTwoButtonDiffWidthView : TTBaseUIView {
    
    open var multiplierWidth:CGFloat { get { return 1/3 } }
    open var padding:CGFloat { get { return TTSize.P_CONS_DEF } }
    open var heightPanel:CGFloat { get { return TTSize.H_BUTTON_WITH_PANEL} }
    
    public let leftButton:TTBaseUIButton = TTBaseUIButton(textString: "App.Button.Back".localize(withBundle: Bundle.main).uppercased(), type: .DEFAULT, isSetSize: false)
    public let rightButton:TTBaseUIButton = TTBaseUIButton(textString: "App.Button.Next".localize(withBundle: Bundle.main).uppercased(), type: .DEFAULT, isSetSize: false)
    
    public var onTouchLeftButtonHandle:( () -> ())?
    public var onTouchRightButtonHandle:( () -> ())?
    
    override open func updateBaseUIView() {
        super.updateBaseUIView()
        self.setupViewCodable(with: [self.leftButton, self.rightButton])
    }
    
    public func setText(withLeft left:String, right:String) {
        self.leftButton.setText(text: left)
        self.rightButton.setText(text: right)
    }
    
    public convenience init(withText left:String, right:String) {
        self.init()
        self.setText(withLeft: left, right: right)
    }
}

extension TTBaseTwoButtonDiffWidthView :TTViewCodable {
    
    public func setupStyles() {
        self.setBgColor(.white)
        self.leftButton.setBgColor(color: TTView.buttonBgDis).setTextColor(color: .white)
        self.rightButton.setBgColor(color: TTView.buttonBgDef).setTextColor(color: .white)
    }
    
    public func bindComponents() {
        self.leftButton.onTouchHandler = { _ in
            self.onTouchLeftButtonHandle?()
        }
        
        self.rightButton.onTouchHandler = { _ in
            self.onTouchRightButtonHandle?()
        }
    }
    
    public func setupConstraints() {
        
        self.leftButton.setTopAnchor(constant: self.padding).setBottomAnchor(constant: self.padding)
            .setLeadingAnchor(constant: self.padding).setTrailingWithNextToView(view: self.rightButton, constant: TTSize.P_CONS_DEF)
        
        self.rightButton.setTopAnchor(constant: self.padding).setBottomAnchor(constant: self.padding)
            .setTrailingAnchor(constant: self.padding)
        
        print("self.multiplierWidth: \(self.multiplierWidth)")
        self.leftButton.widthAnchor.constraint(equalTo: self.rightButton.widthAnchor, multiplier: self.multiplierWidth).isActive = true
        self.setHeightAnchor(constant: self.heightPanel)
        
    }
    
}

