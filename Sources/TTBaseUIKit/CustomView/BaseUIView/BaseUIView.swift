//
//  TTBaseUIView.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/8/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseUIView: UIView, ViewDrawer {
    
    var viewDefBgColor: UIColor = TTBaseUIKitConfig.getViewConfig().viewDefColor
    var viewDefCornerRadius: CGFloat = TTBaseUIKitConfig.getSizeConfig().CORNER_RADIUS

    open func updateBaseUIView() { }
    public var onTouchHandler:((_ view:TTBaseUIView) -> Void)?

    public required init() {
        super.init(frame: .zero)
        self.viewDefCornerRadius = 0
        self.setupUI()
        self.updateBaseUIView()
    }
    
    public convenience init(withCornerRadius radio:CGFloat) {
        self.init(); self.setCorner(withCornerRadius: radio)
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if TTBaseUIKitConfig.getStyleConfig().isDismissKeyboardByTouchAnyBaseUIView {
            DispatchQueue.main.async {
                self.findViewController()?.dismissKeyboard()
                UIApplication.topViewController()?.dismissKeyboard()
            }
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @available(*, unavailable,
      message: "Loading this view from a nib is unsupported in favor of initializer dependency injection."
    )
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(frame: .zero)
        self.viewDefCornerRadius = 0
        self.setupUI()
        self.updateBaseUIView()
    }
    
    private func setupUI() {
        self.drawView()
    }
    
    @objc private func onTouchView(_ sender:UITapGestureRecognizer) {
        self.shakeAnimation(x: 1, y: 1, duration: 0.7)
        self.onTouchHandler?(self)
    }
}

extension TTBaseUIView {

    @discardableResult public func setSwipeHandler(with direction:UISwipeGestureRecognizer.Direction) -> TTBaseUIView {
        self.isUserInteractionEnabled = true
        let tap = UISwipeGestureRecognizer(target: self, action: #selector(self.onTouchView(_:)))
        tap.direction = direction
        self.addGestureRecognizer(tap)
        return self
    }
    
    @discardableResult public func setTouchHandler() -> TTBaseUIView {
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onTouchView(_:))))
        return self
    }
    
    public func setCorner(withCornerRadius conner:CGFloat) {
        self.viewDefCornerRadius = conner
        self.drawView()
    }
    
    @discardableResult public func setBgColor(_ color:UIColor) -> TTBaseUIView{
        self.viewDefBgColor = color
        self.backgroundColor = color
        return self
    }
    
}


extension TTBaseUIView {
    
}
