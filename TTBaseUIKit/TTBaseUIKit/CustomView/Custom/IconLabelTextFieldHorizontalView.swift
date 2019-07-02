//
//  IconLabelTextFieldHorizontalView.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 6/28/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

///
/// This Class to create Icon with LabelTextFieldView View
///
/// Base on Icon-TTBaseUILabel-TTBaseUITextField element
///
/// [Horizontal] - StackPanel(iconRight-Label-TextField] )
///
open class TTIconLabelTextFieldHorizontalView : TTBaseUIView {
    
    public enum TYPE {
        case ICON_LABEL_TEXTFIELD
        case LABEL_TEXTFIELD
        case ICON_TEXTFIELD
    }
    
    fileprivate var sizeIcon:CGSize = CGSize.init(width: TTSize.H_ICON, height: TTSize.H_ICON)
    fileprivate var isAutozing:Bool  = true
    fileprivate var panelCorner:CGFloat  = TTSize.CORNER_RADIUS
    
    fileprivate var type:TYPE = .ICON_LABEL_TEXTFIELD
    
    open var padding:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (TTSize.P_CONS_DEF,TTSize.P_CONS_DEF,TTSize.P_CONS_DEF,TTSize.P_CONS_DEF)}}
    open var paddingLabel:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (0,0,0,0)}}
    open var paddingTextField:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (0,0,TTSize.P_CONS_DEF,0)}}
    
    public var icon:TTBaseUIImageFontView = TTBaseUIImageFontView(withFontIconRegularSize: .user, sizeIcon: CGSize(width: 60, height: 60), colorIcon: TTView.textDefColor, contendMode: .scaleAspectFit)
    public var leftLabel:TTBaseUILabel = TTBaseUILabel(withType: .TITLE, text: "Left", align: .left)
    public var textField:TTBaseUITextField = TTBaseUITextField(withPlaceholder: "TextField")
    
    public var padingStack:TTBaseUIStackView = TTBaseUIStackView(axis: .horizontal, spacing: TTSize.P_CONS_DEF, alignment: .center, distributionValue: .fill)
    
    public init(type:TTIconLabelTextFieldHorizontalView.TYPE, textFieldType:TTBaseUITextField.TYPE, isAutozing:Bool = true, corner:CGFloat) {
        super.init()
        self.type = type
        self.textField = TTBaseUITextField(withPlaceholder: "TextField",type: textFieldType)
        self.isAutozing = isAutozing
        self.panelCorner = corner
        self.setupBaseUIView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required public init() {
        fatalError("init() has not been implemented")
    }
    
}

fileprivate extension TTIconLabelTextFieldHorizontalView {
    
    func setupBaseUIView() {
        
        self.leftLabel.setMutilLine(numberOfLine: 0, textAlignment: .left)
        self.setConerRadius(with: self.panelCorner)
        
        self.addSubview(self.padingStack)
        
        self.padingStack.addArrangedSubview(self.icon)
        self.padingStack.addArrangedSubview(self.leftLabel)
        self.padingStack.addArrangedSubview(self.textField)
        
        
        self.icon.setWidthAnchor(constant: self.sizeIcon.width).setHeightAnchor(constant: self.sizeIcon.height).done()
        self.textField.setHeightAnchor(constant: TTSize.H_TEXTFIELD)
        
        self.leftLabel.setFullContentHuggingPriority()
        
        self.padingStack.setFullContraints(lead: self.padding.0, trail: self.padding.2, top: self.padding.1, bottom: self.padding.3)
        
        switch self.type {
        case .ICON_LABEL_TEXTFIELD:
            break
        case .ICON_TEXTFIELD:
            self.leftLabel.isHidden = true
            break
        case .LABEL_TEXTFIELD:
            self.icon.isHidden = true
            break
        }
    }
}


// MARK:// For Base funcs
extension TTIconLabelTextFieldHorizontalView {
    @discardableResult public func setTextIcon(with icon:AwesomePro.Light, label:String, textPlaceHolder:String) -> TTIconLabelTextFieldHorizontalView{
        self.setIcon(with: icon).setText(with: label).setTextPlaceHolder(with: textPlaceHolder).done()
        return self
    }
    
    @discardableResult public func setIcon(with icon:AwesomePro.Light) -> TTIconLabelTextFieldHorizontalView{
        self.icon.setIConImage(with: icon)
        return self
    }
    @discardableResult public func setText(with  label:String) -> TTIconLabelTextFieldHorizontalView{
        self.leftLabel.setText(text: label)
        return self
    }
    @discardableResult public func setTextPlaceHolder(with textPlaceHolder:String) -> TTIconLabelTextFieldHorizontalView{
        self.textField.placeholder = textPlaceHolder
        return self
    }
}
