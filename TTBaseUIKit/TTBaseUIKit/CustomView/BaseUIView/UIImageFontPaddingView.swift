//
//  UIImageFontPaddingView.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 8/7/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTUIImageFontPaddingView: TTBaseUIView {
    
    var sizeIcon:CGSize = CGSize(width: 100, height: 100)
    var padding:CGFloat  = 12.0
    
    var bgColor:UIColor = UIColor.clear
    
    public var imageView:TTBaseUIImageFontView = TTBaseUIImageFontView()
    
    public convenience init(with iconName:AwesomePro.Light, iconColor:UIColor, bgColor:UIColor, paddingContent:CGFloat = 12.0, borderWidth:CGFloat = 0, borderColor:UIColor =  UIColor.clear) {
        self.init()
        self.bgColor = bgColor
        self.padding = paddingContent
        self.imageView = TTBaseUIImageFontView.init(withFontIconSize: iconName.rawValue, sizeIcon: sizeIcon, colorIcon: iconColor, contendMode: .scaleAspectFit)
        self.imageView.backgroundColor = UIColor.clear
        self.imageView.isUserInteractionEnabled = false
        self.setupBaseUI()
    }
}

extension TTUIImageFontPaddingView {
    fileprivate func setupBaseUI() {
        self.addSubview(imageView)
        self.imageView.setFullContraints(constant: self.padding)
    }
}
