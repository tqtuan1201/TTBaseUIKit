//
//  UIViewController+Config.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/11/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
extension UIViewController {
    public func dismissKeyboard() {
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
    }
}
