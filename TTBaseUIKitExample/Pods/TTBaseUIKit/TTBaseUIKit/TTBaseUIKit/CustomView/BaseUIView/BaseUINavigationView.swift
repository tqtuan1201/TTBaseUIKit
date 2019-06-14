//
//  BaseUINavigationView.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/11/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit


@objc protocol navigationViewRepresentable {
    func setTitle(title:String)
}

open class TTBaseUINavigationView: TTBaseUIView {
    
}

extension TTBaseUINavigationView : navigationViewRepresentable {
    open func setTitle(title: String) { }
}
