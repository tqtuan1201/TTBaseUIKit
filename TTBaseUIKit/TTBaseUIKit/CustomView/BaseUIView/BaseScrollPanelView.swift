//
//  BaseScrollPanelView.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 2/9/20.
//  Copyright © 2020 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit


open class TTBaseScrollPanelView :UIScrollView {
     
    open var bgPanelColor:UIColor { get { return UIColor.clear}}
    
    open var isSetWidthContraint:Bool { get { return true } }
    open var keyboardDMode:KeyboardDismissMode { get { return .onDrag } }
    
    open func updateBaseUIView() { }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if TTBaseUIKitConfig.getStyleConfig().isDismissKeyboardByTouchAnyBaseScrollView {
            DispatchQueue.main.async {
                self.findViewController()?.dismissKeyboard()
                UIApplication.topViewController()?.dismissKeyboard()
            }
        }
    }
    
    public init() {
        super.init(frame: .zero)
        self.setupBaseUIView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setupBaseUIView()
    }

    fileprivate func setupBaseUIView() {
        self.backgroundColor = self.bgPanelColor
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.translatesAutoresizingMaskIntoConstraints = false
        self.keyboardDismissMode = keyboardDMode
        self.updateBaseUIView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
