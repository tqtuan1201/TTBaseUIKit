//
//  ImageLabelVerView.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/18/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

///
/// This Class to view Default:
///
/// ImageView
///
/// Title
///
/// ImageView of Product
/// Product Name //Vertical align
///
open class TTImageLabelView : TTBaseUIView {
    
    public var pading:CGFloat = TTSize.P_CONS_DEF
    public var bgColor:UIColor = TTView.viewBgCellColor
    public var widthImage:CGFloat = TTSize.W / 2 - TTSize.P_CONS_DEF * 2.2
    public var heightImage:CGFloat = ( TTSize.W / 2 - TTSize.P_CONS_DEF * 2.2) * 1.2
    
    public let imageView:TTBaseUIImageView = TTBaseUIImageView()
    public let titleLabel:TTBaseUILabel = TTBaseUILabel()
    
    public required init() {
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func updateBaseUIView() {
        self.setupViewCodable(with: [imageView, titleLabel] )
    }
    
}

extension TTImageLabelView : TTViewCodable {
    public func setupConstraints() {
        
    }
}
