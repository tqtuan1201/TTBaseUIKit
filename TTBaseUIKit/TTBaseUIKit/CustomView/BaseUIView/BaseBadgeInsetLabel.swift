//
//  BagInsetLabel.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 7/9/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseBadgeInsetLabel: TTBaseUILabel {
    
    public var inset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    
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
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if self.text == nil || self.text == "" || self.text == "0" { return }
        if self.text?.count == 1 {
            let padingX = self.frame.height - self.frame.width
            let currentPaddingX = self.frame.origin.x
            self.frame.size.width = self.frame.size.height
            self.frame.origin.x = currentPaddingX - padingX
            self.setConerRadius(with: self.frame.width / 2)
        } else {
            self.setConerRadius(with: self.frame.height / 2)
        }
    }
}

extension TTBaseBadgeInsetLabel {
    
    public func resetInset() {
        self.inset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    }
    
    
    public func getHeight() -> CGFloat {
        self.sizeToFit()
        return self.frame.height + self.inset.top + self.inset.bottom
    }
    
}
