//
//  FontConfig.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/6/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

public class FontConfig {
    
    public var HEADER_SUPER_H:CGFloat = 24
    public var HEADER_H:CGFloat = 16
    public var TITLE_H:CGFloat = 14
    public var SUB_TITLE_H:CGFloat = 12
    public var SUB_SUB_TITLE_H:CGFloat = 10
    public var FONT:UIFont = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
    
    
    public init() {
        if Device.size() < .screen4_7Inch {
            self.HEADER_H = 14.5
            self.TITLE_H = 13.5
            self.SUB_TITLE_H = 11.5
            self.SUB_SUB_TITLE_H = 9.5
        }
    }
    
    public convenience init(with headerH:CGFloat, titleH:CGFloat, subTitleH:CGFloat, subSubTileH:CGFloat, font:UIFont) {
        self.init()
        self.HEADER_H = headerH
        self.TITLE_H = titleH
        self.SUB_TITLE_H = subTitleH
        self.SUB_SUB_TITLE_H = subSubTileH
        self.FONT = font
    }
   
}

// MARK: For Base public funcs
extension FontConfig {
    public func getHeaderSize() -> CGFloat { return self.HEADER_H }
    public func getTitleSize() -> CGFloat { return self.TITLE_H }
    public func getSubTitleSize() -> CGFloat { return self.SUB_TITLE_H }
    public func getSubSubTitleSize() -> CGFloat { return self.SUB_SUB_TITLE_H }
    public func getFont() -> UIFont { return self.FONT }
}
