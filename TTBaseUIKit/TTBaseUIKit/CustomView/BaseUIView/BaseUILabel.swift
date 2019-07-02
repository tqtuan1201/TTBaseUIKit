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
    public lazy var skeletonMarkView:TTBaseSkeletonMarkView = TTBaseSkeletonMarkView()
    
    var type:TYPE = .NONE
    
    public var onTouchHandler:((_ label:TTBaseUILabel) -> Void)?
    
    open func updateUI() { }
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
        self.updateUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
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

    @objc private func onTouchView(_ sender:UITapGestureRecognizer) {
        self.onTouchHandler?(self)
    }
    
    
    @discardableResult public func setTouchHandler() -> TTBaseUILabel {
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onTouchView(_:))))
        return self
    }
}

// MARK:// For base functions

extension TTBaseUILabel {
    
    public func setText(withText text:String, align:NSTextAlignment, color:UIColor, fontSize:CGFloat) {
        self.setFontSize(size: fontSize).setText(text: text).setAlign(align: align).setTextColor(color: color).done()
    }
    
    @discardableResult public func setText(text:String, isBold:Bool = false) -> TTBaseUILabel {
        self.text = text
        if isBold { self.setBold().done() }
        return self
    }
    
    @discardableResult public func setBold()  -> TTBaseUILabel {
        self.font = UIFont.boldSystemFont(ofSize: self.font.pointSize)
        return self
    }
    
    @discardableResult public func setAlign(align:NSTextAlignment) -> TTBaseUILabel {
        self.textAlignment = align
        return self
    }
    
    @discardableResult public func setTextColor(color:UIColor) -> TTBaseUILabel {
        self.textDefColor = color
        self.textColor = color
        return self
    }
    
    @discardableResult public func setFontSize(size:CGFloat) -> TTBaseUILabel {
        self.font = self.font.withSize(size)
        return self
    }
    
    @discardableResult public func setBgColor(_ color:UIColor)  -> TTBaseUILabel{
        self.viewDefBgColor = color
        self.backgroundColor = color
        return self
    }
    
}

// MARK: For setText
extension TTBaseUILabel {
    
    @discardableResult public func setFullContentHuggingPriority(priority:UILayoutPriority = UILayoutPriority.required) -> TTBaseUILabel {
        self.setHorizontalContentHuggingPriority(priority: priority).setVerticalContentHuggingPriority(priority: priority).done()
        return self
    }
    
    @discardableResult public func setHorizontalContentHuggingPriority(priority:UILayoutPriority = UILayoutPriority.required) -> TTBaseUILabel {
        self.setContentHuggingPriority( priority, for: .horizontal)
        self.setContentCompressionResistancePriority(  priority, for: .horizontal)
        return self
    }
    
    @discardableResult public func setVerticalContentHuggingPriority(priority:UILayoutPriority = UILayoutPriority.required) -> TTBaseUILabel {
        self.setContentHuggingPriority( priority, for: .vertical)
        self.setContentCompressionResistancePriority(  priority, for: .vertical)
        return self
    }
    
    @discardableResult public func setSizeToFit() -> TTBaseUILabel {
        self.clipsToBounds = true
        self.sizeToFit()
        return self
    }
    
    @discardableResult public func setMutilLine(numberOfLine:Int = 0, textAlignment:NSTextAlignment = .center)  -> TTBaseUILabel {
        self.numberOfLines = numberOfLine
        self.textAlignment = textAlignment
        self.lineBreakMode = .byWordWrapping
        return self
    }
    
    @discardableResult public func setTextAttr(with attr:NSMutableAttributedString) -> TTBaseUILabel{
        self.setText(text: "")
        self.attributedText = attr
        return self
    }
    
}

//MARK:// Skeleton
extension TTBaseUILabel {
    public func onAddSkeletonMark() {
        self.addSubview(self.skeletonMarkView)
        self.skeletonMarkView.setFullContraints(constant: 0)
    }
    public func onRemoveSkeletonMark() {
        self.skeletonMarkView.removeFromSuperview()
    }
}
