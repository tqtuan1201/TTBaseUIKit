//
//  TTBaseFunc.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/8/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation

internal class TTBaseFunc {
    private init() {}
    static let shared = TTBaseFunc()
    
    
}

// MARK: For commom funcs
extension TTBaseFunc {
    
    func printLog(with lineDes:String = "", object:Any) {
        if Config.isPrintLog {
            if !lineDes.isEmpty {print(lineDes + "\n")}
            print("::TTBASEUIKIT: \(object)")
        }
    }
    
}

