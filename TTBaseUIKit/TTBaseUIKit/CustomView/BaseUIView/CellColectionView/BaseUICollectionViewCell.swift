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
    
    open var isSetPanelBgColor:Bool { get { return true } }
    open var bgColor:UIColor { get { return TTBaseUIKitConfig.getViewConfig().viewBgCellColor }}
    open var bgSelectColor:UIColor { get {  return TTBaseUIKitConfig.getViewConfig().viewBgCellSelectedColor }}
    open var padding:CGFloat { get { return TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF }}
    open var cornerRadius:CGFloat { get { return TTBaseUIKitConfig.getSizeConfig().CORNER_RADIUS }}
    
    open func updateUI() { }
    
    public var skeletonLayer:CALayer?
    
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
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if self.skeletonLayer != nil {self.skeletonLayer?.frame = CGRect.init(x: -4, y: 0, width: self.contentView.frame.width + 8, height: self.contentView.frame.height)}
    }
    
    
    open override var isSelected: Bool {
        didSet {
            if isSetPanelBgColor {
                if isSelected {
                    self.panel.backgroundColor = bgSelectColor
                } else {
                    self.panel.backgroundColor = bgColor
                }
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

//MARK:// For skeleton Animation
extension TTBaseUICollectionViewCell {
    public func setSkeletonAnimation() -> TTBaseUICollectionViewCell {
        self.skeletonLayer = UIView.getGradientSkeletonLayer()
        self.clipsToBounds = true
        if let skeLayer =  self.skeletonLayer { self.panel.layer.addSublayer(skeLayer) } 
        return self
    }
    
    public func onStartSkeletonAnimation(isSetAllSubView:Bool = true) {
        self.skeletonLayer?.isHidden = false
        let views = isSetAllSubView ? self.panel.subviewsRecursive(): self.panel.subviews
        for view in views {
            if let lb = view as? TTBaseUILabel {lb.onAddSkeletonMark()}
            if let btn = view as? TTBaseUIButton {btn.onAddSkeletonMark()}
            if let img = view as? TTBaseUIImageView {img.onAddSkeletonMark()}
        }
    }
    
    public func onStopSkeletonAnimation(isSetAllSubView:Bool = true) {
        if (self.skeletonLayer?.isHidden ?? false) == true { return }
        self.skeletonLayer?.isHidden = true
        let views = isSetAllSubView ? self.panel.subviewsRecursive(): self.panel.subviews
        for view in views {
            if let _ = view as? TTBaseUIView {
                //view.backgroundColor = view.viewDefBgColor
            } else if let lb = view as? TTBaseUILabel {
                lb.onRemoveSkeletonMark()
            }  else if let btn = view as? TTBaseUIButton {
                btn.onRemoveSkeletonMark()
            } else if let img = view as? TTBaseUIImageView {
                img.onRemoveSkeletonMark()
            }
        }
    }
}
