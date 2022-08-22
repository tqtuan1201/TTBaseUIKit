//
//  BaseShadowCollectionViewCell.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 10/22/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseShadowCollectionViewCell: TTBaseUICollectionViewCell {
    
    open var bgShadown:UIColor { get { return UIColor.darkGray.withAlphaComponent(0.2) }}
    open var bgButton:UIColor { get { return .white } }
    
    override open var padding: CGFloat { TTSize.P_CONS_DEF }
    
    public var shadowHeight:CGFloat = TTSize.P_CONS_DEF / 2
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if self.layer.shadowPath == nil {
            self.layer.backgroundColor = UIColor.clear.cgColor
            self.layer.shadowColor = self.bgShadown.cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: self.shadowHeight )
            self.layer.shadowOpacity = 0.2
            self.layer.shadowRadius = 3.0
        }
    }

    
    override open func updateUI() {
        super.updateUI()
        
        
    }
    
    
}
