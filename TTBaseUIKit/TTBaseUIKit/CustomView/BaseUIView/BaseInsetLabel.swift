//
//  BaseInsetLabel.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 5/31/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseInsetLabel: TTBaseUILabel {
    
    public var inset = UIEdgeInsets(top: TTSize.P_CONS_DEF, left: TTSize.P_CONS_DEF, bottom: TTSize.P_CONS_DEF, right: TTSize.P_CONS_DEF)
    
    public convenience init(withInset inset:UIEdgeInsets) {
        self.init(frame: .zero)
        self.setInset(with: inset)
    }
    
    
    open override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: inset))
    }
    
    open override var intrinsicContentSize: CGSize {
        var intrinsicContentSize = super.intrinsicContentSize
        intrinsicContentSize.width += inset.left + inset.right
        intrinsicContentSize.height += inset.top + inset.bottom
        return intrinsicContentSize
    }
    
    public func setInset(with inset:UIEdgeInsets) {
        self.inset = inset
    }
    
    
}

extension TTBaseInsetLabel {
    
    public func resetInset() {
        self.inset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    }
    
    
    public func getHeight() -> CGFloat {
        self.sizeToFit()
        return self.frame.height + self.inset.top + self.inset.bottom
    }
    
}
