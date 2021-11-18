//
//  BaseUICollectionViewController.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/18/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation

open class TTBaseUICollectionViewController<BaseView:TTBaseUIView>: UICollectionViewController {

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if TTBaseUIKitConfig.getStyleConfig().isDismissKeyboardByTouchAnywhere { self.dismissKeyboard() }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()

    }
}
