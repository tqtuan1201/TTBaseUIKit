//
//  SelectClassTypeView.swift
//  12BayV2
//
//  Created by Truong Quang Tuan on 7/28/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import TTBaseUIKit

class ShowPriceCalendarView : BaseIconLeftRightTitleView {
    
    var didChangeSwitch:((_ isOn:Bool) -> ())?
    
    lazy var rightSwitch:UISwitch = {
        let switchView = UISwitch()
        switchView.isUserInteractionEnabled = false
        switchView.translatesAutoresizingMaskIntoConstraints = false
        switchView.setOn(false, animated: true)
        switchView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        switchView.tintColor = XView.labelBgDef
        switchView.onTintColor = XView.labelBgDef
        return switchView
    }()
    
    required init() {
        super.init(with: XView.labelBgDef, iconColor: .white, textColor: XView.textDefColor,iconLeft: .dollarSign, iconRight: .exchange, titleString: "Title", subString: "Sub title")
        
        self.onUpdateWeekendView()
        self.onUpdateTargets()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(with: XView.labelBgDef, iconColor: .white, textColor: XView.textDefColor,iconLeft: .dollarSign, iconRight: .exchange, titleString: "Title", subString: "Sub title")
        self.onUpdateWeekendView()
        self.onUpdateTargets()
    }
    
    fileprivate func onUpdateWeekendView() {
        self.addSubview(self.rightSwitch)
        self.rightSwitch.backgroundColor = UIColor.clear
        self.rightSwitch.setTrailingAnchor(constant: XSize.P_CONS_DEF).setcenterYAnchor(constant: 0).done()
        
        self.iconRightView.setBgColor(UIColor.white)
        self.iconRightView.imageView.isHidden = true
    }
    
    
    fileprivate func onUpdateTargets() {
        self.setTouchHandler().onTouchHandler  = { _ in
            if self.rightSwitch.isOn {
                self.didChangeSwitch?(false)
                self.rightSwitch.setOn(false, animated: true)
            } else {
                self.didChangeSwitch?(true)
                self.rightSwitch.setOn(true, animated: true)
            }
        }
    }
}

