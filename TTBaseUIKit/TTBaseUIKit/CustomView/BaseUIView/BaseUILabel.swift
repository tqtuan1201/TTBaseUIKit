//
//  BaseUILabel.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/8/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseUILabel : UILabel, ViewDrawer, TextDrawer {
    
    public enum TYPE {
        case HEADER
        case TITLE
        case SUB_TITLE
        case SUB_SUB_TILE
        case NONE
    }
    
    public var viewDefBgColor: UIColor = UIColor.clear
    public var viewDefCornerRadius: CGFloat = 0
    
    public var textDefColor: UIColor = TTBaseUIKitConfig.getViewConfig().textDefColor
    public var textDefHeight: CGFloat = TTBaseUIKitConfig.getFontConfig().TITLE_H
    public var textDefIsUpper: Bool = false
    public var fontDef: UIFont = TTBaseUIKitConfig.getFontConfig().FONT
    
    var type:TYPE = .NONE
    
    public var onTouchHandler:((_ label:TTBaseUILabel) -> Void)?
    open func updateUI() { }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
        self.setupTargets()
        self.updateUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
        self.setupTargets()
        self.updateUI()
    }
    
    public convenience init(withType type:TYPE, text:String = "", align:NSTextAlignment = .center) {
        self.init()
        self.type = type
        switch type {
        case .HEADER:
            self.setFontSize(size: TTBaseUIKitConfig.getFontConfig().HEADER_H).done()
        break
        case .TITLE:
            self.setFontSize(size: TTBaseUIKitConfig.getFontConfig().TITLE_H).done()
        break
        case .SUB_TITLE:
            self.setFontSize(size: TTBaseUIKitConfig.getFontConfig().SUB_TITLE_H).done()
        break
        case .SUB_SUB_TILE:
            self.setFontSize(size: TTBaseUIKitConfig.getFontConfig().SUB_SUB_TITLE_H).done()
        break
        default: break
        }
        self.updateUI()
        self.setText(text: text).setAlign(align: align).done()
    }
    
    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.drawView()
        self.drawLable()
        
    }
    
    private func setupTargets() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onTouchView(_:))))
    }
    
    @objc private func onTouchView(_ sender:UITapGestureRecognizer) {
        self.onTouchHandler?(self)
    }
    
}

// MARK:// For base functions

extension TTBaseUILabel {
    
    public func setText(withText text:String, align:NSTextAlignment, color:UIColor, fontSize:CGFloat) {
        self.setFontSize(size: fontSize).setText(text: text).setAlign(align: align).setTextColor(color: color).done()
    }
    
    public func setText(text:String, isBold:Bool = false) -> TTBaseUILabel {
        self.text = text
        if isBold { self.setBold().done() }
        return self
    }
    
    public func setBold()  -> TTBaseUILabel {
        self.font = UIFont.boldSystemFont(ofSize: self.font.pointSize)
        return self
    }
    
    public func setAlign(align:NSTextAlignment) -> TTBaseUILabel {
        self.textAlignment = align
        return self
    }
    
    public func setTextColor(color:UIColor) -> TTBaseUILabel {
        self.textDefColor = color
        self.textColor = color
        return self
    }
    
    public func setFontSize(size:CGFloat) -> TTBaseUILabel {
        self.font = self.font.withSize(size)
        return self
    }
    
    public func setBgColor(_ color:UIColor) {
        self.viewDefBgColor = color
        self.backgroundColor = color
    }
    
}

// MARK: For setText
extension TTBaseUILabel {
    
    public func setFullContentHuggingPriority() -> TTBaseUILabel {
        self.setHorizontalContentHuggingPriority().setVerticalContentHuggingPriority().done()
        return self
    }
    
    public func setHorizontalContentHuggingPriority() -> TTBaseUILabel {
        self.setContentHuggingPriority( UILayoutPriority.defaultHigh, for: .horizontal)
        self.setContentCompressionResistancePriority(  UILayoutPriority.defaultHigh, for: .horizontal)
        return self
    }
    
    public func setVerticalContentHuggingPriority() -> TTBaseUILabel {
        self.setContentHuggingPriority( UILayoutPriority.defaultHigh, for: .vertical)
        self.setContentCompressionResistancePriority(  UILayoutPriority.defaultHigh, for: .vertical)
        return self
    }
    
    public func setSizeToFit() -> TTBaseUILabel {
        self.clipsToBounds = true
        self.sizeToFit()
        return self
    }
    
    public func setMutilLine(numberOfLine:Int = 0, textAlignment:NSTextAlignment = .center)  -> TTBaseUILabel {
        self.numberOfLines = numberOfLine
        self.textAlignment = textAlignment
        self.lineBreakMode = .byWordWrapping
        return self
    }
}

