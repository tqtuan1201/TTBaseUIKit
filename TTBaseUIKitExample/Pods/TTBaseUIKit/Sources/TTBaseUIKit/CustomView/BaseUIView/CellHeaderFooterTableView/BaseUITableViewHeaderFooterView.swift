//
//  BaseUITableViewCell.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/19/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseUITableViewHeaderFooterView: UITableViewHeaderFooterView, ReusableView {
    
    public var panel:TTBaseUIView            = TTBaseUIView()
    
    open var bgColor:UIColor { get { return TTBaseUIKitConfig.getViewConfig().viewBgCellColor }}
    open var backgroundViewColor:UIColor { get { return UIColor.clear }}
    open var tintHeaderColor:UIColor { get { return UIColor.white }}
    open var bgSelectColor:UIColor { get {  return TTBaseUIKitConfig.getViewConfig().viewBgCellSelectedColor }}
    
    open var padding:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (TTSize.P_CONS_LEFT_H,TTSize.P_CONS_TOP_H / 2,TTSize.P_CONS_RIGHT_H,TTSize.P_CONS_BOTOM_H / 2)}}
    open var cornerRadius:CGFloat { get { return TTSize.CORNER_RADIUS }}
    
    open var isSetBgSelected:Bool { get { return true }}
    open var isSetBoderBottom:Bool { get { return false }}
    
    open func updateUI() { }
    
    fileprivate var isSetBorder:Bool = false
    
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
        self.setupContraints()
        self.updateUI()
    }
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupUI()
        self.setupContraints()
        self.updateUI()
    }
    
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.panel.layoutIfNeeded()
        if self.isSetBoderBottom {
            self.panel.addBorder(withRectEdge: .bottom, borderColor: TTView.lineDefColor, borderHeight: 1)
        }
    }
    
    
    
    private func setupUI() {
        self.tintColor = self.tintHeaderColor
        self.panel.backgroundColor    = self.bgColor
        //self.backgroundColor = UIColor.clear
        self.backgroundView = self.setBackgroundView(withColor: self.backgroundViewColor)
        self.contentView.addSubview(panel)
        self.panel.setConerRadius(with: self.cornerRadius)
    }
    
    private func setupContraints() {
        self.panel.setFullContraints(view: self.contentView ,lead: self.padding.0, trail: self.padding.2, top: self.padding.1, bottom: self.padding.3)
    }
}

extension TTBaseUITableViewHeaderFooterView {
    
    
    public func setColor(color:UIColor){
        self.panel.backgroundColor = color
        self.tintColor = color
        
        
    }
    
    public func setBackgroundView(withColor color:UIColor) -> UIView {
        
        let panelBgView:UIView = UIView()
        panelBgView.translatesAutoresizingMaskIntoConstraints = false
        panelBgView.backgroundColor = color
        
        return panelBgView
    }
}
