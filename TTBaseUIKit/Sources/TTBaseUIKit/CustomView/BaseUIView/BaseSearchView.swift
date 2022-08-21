//
//  BaseSearchView.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 3/24/20.
//  Copyright © 2020 Truong Quang Tuan. All rights reserved.
//


import Foundation
import UIKit

open class TTBaseSearchView : TTBaseUIView {
    
    open var paddingLine:CGFloat { get { return 0 }}
    open var padding:CGFloat { get { return TTSize.P_CONS_DEF }}
    open var paddingTextField:CGFloat { get { return TTSize.P_CONS_DEF }}
    open var isShowLine:Bool { get { return true }}
     
    public let icon:TTBaseUIImageFontView = TTBaseUIImageFontView(withFontIconRegularSize: .search, sizeIcon: CGSize(width: 30, height: 30), colorIcon: TTView.labelBgWar, contendMode: .scaleAspectFit)
    public let textField:TTBaseUITextField = TTBaseUITextField(withPlaceholder: "", pading: TTSize.P_CONS_DEF, type: .NO_BORDER, isSetHiddenKeyboardAccessoryView: true)
    public lazy var lineView:TTLineView = TTLineView()
    
    public var sizeIcon:CGFloat { get { return TTSize.H_SMALL_ICON - TTSize.P_CONS_DEF / 2}}
    public var heightView:CGFloat { get { return TTSize.H_TEXTFIELD  + TTSize.P_CONS_DEF * 2}}
    
    public var didChangeTextSearchHandle:( (_ text:String) -> ())?
    
    public init(withIconColor color:UIColor = TTBaseUIKitConfig.getViewConfig().labelBgWar, searchPlaceholder:String = "Please input your test") {
        super.init()
        self.icon.setIconColor(color)
        self.setupViewCodable(with: [self.icon, self.textField])
        self.textField.placeholder = searchPlaceholder
    }
    
    required public init() {
        super.init()
        self.setupViewCodable(with: [self.icon, self.textField])
    }
    
}

extension TTBaseSearchView :TTViewCodable {
    
    public func bindComponents() {
        self.textField.onTextEditChangedHandler = { [weak self] (_ , text) in guard let strongSelf = self else { return }
            strongSelf.didChangeTextSearchHandle?(text)
        }
    }
    
    public func setupCustomView() {
        
        if isShowLine {
            self.addSubview(self.lineView)
            self.lineView.setHeightAnchor(constant: TTSize.H_LINEVIEW).setBottomAnchor(constant: 0)
                .setLeadingAnchor(constant: self.paddingLine).setTrailingAnchor(constant: self.paddingLine)
        }
    }
    
    public func setupConstraints() {
        self.icon.setWidthAnchor(constant: self.sizeIcon).setHeightAnchor(constant: self.sizeIcon)
            .setLeadingAnchor(constant: self.padding).setcenterYAnchor(constant: 0)
        
        self.textField.setLeadingWithNextToView(view: self.icon, constant: self.paddingTextField)
            .setTopAnchor(constant: self.padding).setBottomAnchor(constant: self.padding)
            .setTrailingAnchor(constant: self.padding)
            .setHeightAnchor(constant: TTSize.H_TEXTFIELD)
    }
    
}


