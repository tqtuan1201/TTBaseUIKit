//
//  Service.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/5/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
public class Service {
    private init() {}
    
    public static func printData() {
        TTBaseFunc.shared.printLog(object: "Init TTBaseUIKit Successfully")
    }
    
    public static func printUpdate() {
        TTBaseFunc.shared.printLog(object: "Update TTBaseUIKit Successfully")
    }
    
    public static func ahuhu() {
        TTBaseFunc.shared.printLog(object: "Update TTBaseUIKit Successfully")
    }
}

