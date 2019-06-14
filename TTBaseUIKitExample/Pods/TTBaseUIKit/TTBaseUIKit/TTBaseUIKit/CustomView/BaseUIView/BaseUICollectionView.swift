//
//  BaseUICollectionView.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/18/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseUICollectionView: UICollectionView {
    
    public var bgColor:UIColor = UIColor.clear
    public var isShowScrollIndicator:Bool = false
    public var isSetContentInset:Bool = true

    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.setupBaseUI()
    }
    
    public convenience init(collectionViewLayout layout: UICollectionViewLayout) {
        self.init(frame: .zero, collectionViewLayout: layout)
    }
    
    public convenience init(collectionViewLayout layout: UICollectionViewLayout, bgColor:UIColor, isShowCroll:Bool, isSetContent:Bool) {
        self.init(frame: .zero, collectionViewLayout: layout)
        self.bgColor = bgColor
        self.isShowScrollIndicator = isShowCroll
        self.isSetContentInset = isSetContent
        self.setupBaseUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupBaseUI() {
        
        self.showsVerticalScrollIndicator = self.isShowScrollIndicator
        self.showsHorizontalScrollIndicator = self.isShowScrollIndicator
        self.backgroundColor = self.bgColor
        self.translatesAutoresizingMaskIntoConstraints = false
        if isSetContentInset {
            self.contentInset = UIEdgeInsets(top: TTSize.H_NAV + TTSize.P_CONS_DEF, left: 0, bottom: TTSize.P_CONS_DEF, right: 0)
        }
        

    }
}
