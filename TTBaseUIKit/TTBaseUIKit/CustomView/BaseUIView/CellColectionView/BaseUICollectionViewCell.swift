//
//  BaseUICollectionViewCell.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/18/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseUICollectionViewCell : UICollectionViewCell, ReusableView {
    
    public var panel:TTBaseUIView            = TTBaseUIView()
    
    open var bgColor:UIColor { get { return TTBaseUIKitConfig.getViewConfig().viewBgCellColor }}
    open var bgSelectColor:UIColor { get {  return TTBaseUIKitConfig.getViewConfig().viewBgCellSelectedColor }}
    open var padding:CGFloat { get { return TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF }}
    open var cornerRadius:CGFloat { get { return TTBaseUIKitConfig.getSizeConfig().CORNER_RADIUS }}
    
    open func updateUI() { }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupBaseUIView()
        self.setupBaseContraints()
        self.updateUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupBaseUIView()
        self.setupBaseContraints()
        self.updateUI()
        
    }
    
    open override var isSelected: Bool {
        didSet {
            if isSelected {
                self.panel.backgroundColor = bgSelectColor
            } else {
                self.panel.backgroundColor = bgColor
            }
        }
    }
    
    fileprivate func  setupBaseUIView() {
        
        self.panel.backgroundColor = self.bgColor
        self.contentView.backgroundColor = UIColor.clear
        if cornerRadius != 0 { self.panel.layer.cornerRadius    = cornerRadius ; self.panel.clipsToBounds = true }
        
        self.contentView.addSubview(panel)
        
    }
   
    fileprivate func  setupBaseContraints() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.setLeadingAnchor(constant: 0).setTrailingAnchor(constant: 0).setTopAnchor(constant: 0).setBottomAnchor(constant: 0).done()
        
        self.panel.setTrailingAnchor(self.contentView, constant: self.padding).setLeadingAnchor(self.contentView, constant: self.padding).setTopAnchor(self.contentView, constant: self.padding).setBottomAnchor(self.contentView, constant: self.padding).done()
    }
    
}
