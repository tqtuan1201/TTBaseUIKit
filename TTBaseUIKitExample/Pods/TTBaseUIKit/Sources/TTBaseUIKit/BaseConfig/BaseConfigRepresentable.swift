//
//  BaseRepresentable.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/8/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import UIKit

public protocol ViewConfigColor {
    
    var textHeaderColor:UIColor { get set }
    var textTitleColor:UIColor { get set }
    var textSubTitleColor:UIColor { get set }
    var textDefColor:UIColor { get set }
    var textWarringColor:UIColor { get set }
    
    var viewBgColor:UIColor { get set }
    var viewBgCellColor:UIColor { get set }
    
    var labelBgDef:UIColor { get set }
    var labelBgWar:UIColor { get set }
    var labelBgDis:UIColor { get set }
    
    var buttonBgDef:UIColor { get set }
    var buttonBgWar:UIColor { get set }
    var buttonBgDis:UIColor { get set }
    
}

