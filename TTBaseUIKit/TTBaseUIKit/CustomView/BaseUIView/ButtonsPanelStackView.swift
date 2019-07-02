//
//  ButtonsPanelStackView.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 7/1/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTButtonsPanelStackView :TTBasePanelViewUIStackView {
    
    open var padding:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (TTSize.P_CONS_DEF * 2, TTSize.P_CONS_DEF, TTSize.P_CONS_DEF * 2, TTSize.P_CONS_DEF )}}
    
    public var buttons:[TTBaseUIButton] = [TTBaseUIButton(textString: "Cancel", type: .DEFAULT, isSetSize: false), TTBaseUIButton(textString: "OK", type: .DEFAULT, isSetSize: false)]
    
    public var onTouchButtonsHandler:((_ button:TTBaseUIButton) -> Void)?
    
    public init(with buttons:[TTBaseUIButton]) {
        super.init(with: TTBaseUIStackView(axis: .horizontal, spacing: TTSize.P_CONS_DEF, alignment: .fill, distributionValue: .fillEqually))
        self.buttons = buttons
        self.setupBaseUIView()
    }
    
    public init(with buttons:[TTBaseUIButton], stackView:TTBaseUIStackView, padding:(CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)) {
        super.init(with: stackView, padding: padding)
        self.buttons = buttons
        self.setupBaseUIView()
    }
    
    public required init() {
        super.init(with: TTBaseUIStackView(axis: .horizontal, spacing: TTSize.P_CONS_DEF, alignment: .fill, distributionValue: .fillEqually))
        self.setupBaseUIView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TTButtonsPanelStackView  {
    
    fileprivate func setupBaseUIView() {
        for btn in self.buttons {
            self.baseStackView.addArrangedSubview(btn)
            btn.onTouchHandler = { [weak self]  button in guard let strongSelf = self else { return }
                strongSelf.onTouchButtonsHandler?(button)
            }
        }
    }
    
    
}
