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
    
    var HEADER_H:CGFloat = 22
    var TITLE_H:CGFloat = 18
    var SUB_TITLE_H:CGFloat = 14
    var SUB_SUB_TITLE_H:CGFloat = 10
    var FONT:UIFont = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
    
    
    public init() {}
    
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
