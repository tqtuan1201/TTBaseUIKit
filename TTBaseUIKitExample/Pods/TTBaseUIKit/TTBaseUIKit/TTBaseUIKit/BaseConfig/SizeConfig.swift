//
//  SizeConfig.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/6/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

public class SizeConfig {
    
    public var W:CGFloat = UIScreen.main.bounds.width
    public var H:CGFloat = UIScreen.main.bounds.height
    public var P:CGFloat = UIScreen.main.bounds.width / 50
    
    
    
    public var RATIO:CGFloat = 2/3
    public var CORNER_RADIUS:CGFloat = 4.0

    public var H_ICON:CGFloat = 40.0
    public var H_ICON_CELL:CGFloat = 56.0
    
    public var H_LOADING_CENTER:CGFloat = Device.size() > .screen4Inch ? 70.0 : 40.0
    
    public var H_DISSMISS_PRESENTVIEW:CGFloat = 20.0
    public var W_DISSMISS_PRESENTVIEW:CGFloat = 6.0
    public var H_DISSMISS_LINESPACE_PRESENTVIEW:CGFloat = 6.0
    public var W_DISSMISS_LINESPACE_PRESENTVIEW:CGFloat = 40.0
    
    public var H_SEG:CGFloat = 40.0
    public var H_SEG_LINE:CGFloat = 2.0
    
    public var H_TEXTFIELD:CGFloat = 35.0
    public var H_LINEVIEW:CGFloat = 1.5
    public var H_STATUS:CGFloat = UIApplication.shared.statusBarFrame.height
    public var H_NAV:CGFloat = 45.0
    public var H_PROCESS_VIEW:CGFloat = 6.0
    public var H_BORDER:CGFloat = 2
    
    public var H_CELL:CGFloat = UIScreen.main.bounds.width / 5
    public var H_CELL_HEADER_SPACE:CGFloat = UIScreen.main.bounds.width / 6.5
    public var H_HEADER:CGFloat = UIScreen.main.bounds.width / 3
    public var H_FOOTER:CGFloat = UIScreen.main.bounds.width / 5
    public var H_SEARCH_BAR:CGFloat = 55.0
    
    
    public var H_CELL_COLECT:CGFloat = UIScreen.main.bounds.width / 2.4
    public var H_BUTTON:CGFloat = 40.0
    public var H_BUTTON_WITH_PANEL:CGFloat = 55.0
    
    public var W_BUTTON:CGFloat = UIScreen.main.bounds.width / 2
    public var W_TEXT_RIGHTVIEW:CGFloat = UIScreen.main.bounds.width / 6
    public var W_TEXT_LEFTVIEW:CGFloat = UIScreen.main.bounds.width / 6
    
    public var P_CONS_DEF:CGFloat = 8.0
    public var P_CONS_LEFT_H:CGFloat = 8.0
    public var P_CONS_RIGHT_H:CGFloat = 8.0
    public var P_CONS_TOP_H:CGFloat = 8.0
    public var P_CONS_BOTOM_H:CGFloat = 8.0
    
    public var NOTIFI_HEIGHT:CGFloat = 80.0
    public var NOTIFI_ICON_HEIGHT:CGFloat = 45.0
    
    public init() {}
    
    public convenience init(with paddingH:CGFloat, cellH:CGFloat, cellCollH:CGFloat, connerRadio:CGFloat, heightIcon:CGFloat) {
        self.init()
        self.P = paddingH
        self.H_CELL = cellH
        self.H_CELL_COLECT = cellCollH
        self.CORNER_RADIUS = connerRadio
        self.H_ICON = heightIcon
    }

    public func updateContraintsH(withHeightUpdate top:CGFloat, botom:CGFloat, left:CGFloat, right:CGFloat, defValue:CGFloat) -> SizeConfig {
        self.P_CONS_TOP_H = top
        self.P_CONS_TOP_H = P_CONS_BOTOM_H
        self.P_CONS_LEFT_H = left
        self.P_CONS_RIGHT_H = right
        self.P_CONS_DEF = defValue
        return self
    }
}

// MARK: FOR BASE FUNC
extension SizeConfig {

    public func getPaddingView() -> CGFloat { return self.P }
    public func getCellHight() -> CGFloat { return self.H_CELL }
    public func getCollHeight() -> CGFloat { return self.H_CELL_COLECT }
    public func getConnerRadio() -> CGFloat { return self.CORNER_RADIUS }
    public func getHeightIcon() -> CGFloat { return self.H_ICON }
    public func getHeightNavWithStatus() -> CGFloat { return self.H_NAV + self.H_STATUS }
    
}
