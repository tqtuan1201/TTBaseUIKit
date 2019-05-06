//
//  BaseUIImageFontView.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 5/1/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseUIImageFontView : TTBaseUIImageView {
    
    public convenience init(withFontIconSize nameCVarIcon:CVarArg, sizeIcon:CGSize = CGSize(width: 600, height: 600), colorIcon:UIColor = TTBaseUIKitConfig.getViewConfig().iconColor, contendMode:UIView.ContentMode = UIView.ContentMode.scaleAspectFit) {
        self.init()
        self.image = UIImage.fontAwesomeIconWithName(nameString: String(format: "%C", nameCVarIcon), size: sizeIcon, iconColor: colorIcon, backgroundColor: UIColor.clear)
        self.contentMode = contendMode
    }
    
    public convenience init(withFontIconSize nameIconString:String, sizeIcon:CGSize = CGSize(width: 600, height: 600), colorIcon:UIColor = TTBaseUIKitConfig.getViewConfig().iconColor, contendMode:UIView.ContentMode = UIView.ContentMode.scaleAspectFit) {
        self.init()
        self.image = UIImage.fontAwesomeIconWithName(nameString: nameIconString, size: sizeIcon, iconColor: colorIcon, backgroundColor: UIColor.clear)
        self.contentMode = contendMode
    }
    
    public convenience init(withFontIconLightSize icon:AwesomePro.Light, sizeIcon:CGSize = CGSize(width: 600, height: 600), colorIcon:UIColor = TTBaseUIKitConfig.getViewConfig().iconColor, contendMode:UIView.ContentMode = UIView.ContentMode.scaleAspectFit) {
        self.init()
        self.image = UIImage.fontAwesomeIconWithName(nameString: icon.rawValue, size: sizeIcon, iconColor: colorIcon, backgroundColor: UIColor.clear)
        self.contentMode = contendMode
    }
    
    public convenience init(withFontIconRegularSize icon:AwesomePro.Regular, sizeIcon:CGSize = CGSize(width: 600, height: 600), colorIcon:UIColor = TTBaseUIKitConfig.getViewConfig().iconColor, contendMode:UIView.ContentMode = UIView.ContentMode.scaleAspectFit) {
        self.init()
        self.image = UIImage.fontAwesomeIconWithName(nameString: icon.rawValue, size: sizeIcon, iconColor: colorIcon, backgroundColor: UIColor.clear)
        self.contentMode = contendMode
    }
    
}
