//
//  UIImageCircleIconView.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 5/1/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTUIImageFontCircleView: TTBaseUICricleView {
    
    var sizeIcon:CGSize = CGSize(width: 1000, height: 1000)
    var padding:CGFloat  = 12.0
    
    var bgColor:UIColor = UIColor.clear
    
    public var imageCircleView:TTBaseUIImageFontView = TTBaseUIImageFontView()
    
    public convenience init(with iconName:String, iconColor:UIColor, bgColor:UIColor, paddingContent:CGFloat = 12.0, borderWidth:CGFloat = 0, borderColor:UIColor =  UIColor.clear) {
        self.init()
        self.bgColor = bgColor
        self.padding = paddingContent
        self.imageCircleView = TTBaseUIImageFontView.init(withFontIconSize: iconName, sizeIcon: sizeIcon, colorIcon: iconColor, contendMode: .scaleAspectFit)
        self.imageCircleView.backgroundColor = UIColor.clear
        self.imageCircleView.isUserInteractionEnabled = false
        self.setupBaseUI()
    }
}

extension TTUIImageFontCircleView {
    fileprivate func setupBaseUI() {
        self.addSubview(imageCircleView)
        self.imageCircleView.setFullContraints(constant: self.padding)
    }
}
