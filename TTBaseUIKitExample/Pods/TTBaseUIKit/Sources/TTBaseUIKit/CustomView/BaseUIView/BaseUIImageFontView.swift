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
    
    public init(withFontIconSize nameCVarIcon:CVarArg, sizeIcon:CGSize = CGSize(width: 100, height: 100), colorIcon:UIColor = TTBaseUIKitConfig.getViewConfig().iconColor, contendMode:UIView.ContentMode = UIView.ContentMode.scaleAspectFit) {
        super.init()
        self.image = UIImage.fontAwesomeIconWithName(nameString: String(format: "%C", nameCVarIcon), size: sizeIcon, iconColor: colorIcon, backgroundColor: UIColor.clear)
        self.contentMode = contendMode
    }
    
    public init(withFontIconSize nameIconString:String, sizeIcon:CGSize = CGSize(width: 600, height: 600), colorIcon:UIColor = TTBaseUIKitConfig.getViewConfig().iconColor, contendMode:UIView.ContentMode = UIView.ContentMode.scaleAspectFit) {
        super.init()
        self.image = UIImage.fontAwesomeIconWithName(nameString: nameIconString, size: sizeIcon, iconColor: colorIcon, backgroundColor: UIColor.clear)
        self.contentMode = contendMode
    }
    
    public init(withFontIconLightSize icon:AwesomePro.Light, sizeIcon:CGSize = CGSize(width: 600, height: 600), colorIcon:UIColor = TTBaseUIKitConfig.getViewConfig().iconColor, contendMode:UIView.ContentMode = UIView.ContentMode.scaleAspectFit) {
        super.init()
        self.image = UIImage.fontAwesomeIconWithName(nameString: icon.rawValue, size: sizeIcon, iconColor: colorIcon, backgroundColor: UIColor.clear)
        self.contentMode = contendMode
    }
    
    public init(withFontIconRegularSize icon:AwesomePro.Regular, sizeIcon:CGSize = CGSize(width: 600, height: 600), colorIcon:UIColor = TTBaseUIKitConfig.getViewConfig().iconColor, contendMode:UIView.ContentMode = UIView.ContentMode.scaleAspectFit) {
        super.init()
        self.image = UIImage.fontAwesomeIconWithName(nameString: icon.rawValue, size: sizeIcon, iconColor: colorIcon, backgroundColor: UIColor.clear)
        self.contentMode = contendMode
    }
        
    public required init() {
        super.init()
        self.image = UIImage.fontAwesomeIconWithName(nameString: AwesomePro.Light.user.rawValue, size: CGSize.init(width: 60, height: 60), iconColor: TTView.iconColor, backgroundColor: UIColor.clear)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
