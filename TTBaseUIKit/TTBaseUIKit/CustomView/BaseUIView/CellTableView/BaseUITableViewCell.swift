//
//  BaseUITableViewCell.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/19/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseUITableViewCell: UITableViewCell, ReusableView {
    
    public var panel:TTBaseUIView            = TTBaseUIView()
    
    open var bgColor:UIColor { get { return TTBaseUIKitConfig.getViewConfig().viewBgCellColor }}
    open var bgSelectColor:UIColor { get {  return TTBaseUIKitConfig.getViewConfig().viewBgCellSelectedColor }}
    
    open var padding:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (TTSize.P_CONS_LEFT_H,TTSize.P_CONS_TOP_H / 2,TTSize.P_CONS_RIGHT_H,TTSize.P_CONS_BOTOM_H / 2)}}
    open var cornerRadius:CGFloat { get { return TTSize.CORNER_RADIUS }}
    
    open var isSetBgSelected:Bool { get { return true }}
    open var isSetBoderBottom:Bool { get { return false }}
    
    open func updateUI() { }
    
    fileprivate var isSetBorder:Bool = false
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
        self.setupContraints()
        self.updateUI()
    }
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupUI()
        self.setupContraints()
        self.updateUI()
    }
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if isSetBgSelected {
            if selected {
                self.panel.backgroundColor = bgSelectColor
            } else {
                self.panel.backgroundColor = bgColor
            }
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.panel.layoutIfNeeded()
        if self.isSetBoderBottom {
            self.panel.addBorder(withRectEdge: .bottom, borderColor: TTView.lineColor, borderHeight: 1)
        }
    }
    
    private func setupBgViewSelect() -> UIView {
        
        let panelBgView:UIView = UIView()
        panelBgView.translatesAutoresizingMaskIntoConstraints = false
        panelBgView.backgroundColor = self.bgSelectColor
        
        return panelBgView
    }
    
    private func setupUI() {
        self.selectionStyle           = .none
        self.panel.backgroundColor    = self.bgColor
        self.backgroundColor = UIColor.clear
        self.selectedBackgroundView   = self.setupBgViewSelect()
        self.contentView.addSubview(panel)
        self.panel.setConerRadius(with: self.cornerRadius)
    }
    
    private func setupContraints() {
        self.panel.setFullContraints(lead: self.padding.0, trail: self.padding.2, top: self.padding.1, bottom: self.padding.3)
    }
}

extension TTBaseUITableViewCell {
    
    public func getTableView() -> UITableView? {
        guard let superView = self.superview else { return nil }
        if #available(iOS 11, *) {
            if let tb =  superView as? UITableView {
                return tb
            } else {
                return nil
            }
        } else {
            if let tb =  superView.superview as? UITableView {
                return tb
            } else {
                return nil
            }
        }
    }
}
