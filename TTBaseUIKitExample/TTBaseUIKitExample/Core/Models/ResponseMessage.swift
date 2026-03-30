//
//  ResponseModel.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/7/24.
//  Copyright © 2024 Truong Quang Tuan. All rights reserved.
//

import Foundation

struct ResponseMessage: Codable {

    var status: Int?
    var message: String?
    var isSuccess: Bool?
    var isExpired: Bool?
    
    init() {
        self.status = -1
        self.message = "Error"
        self.isSuccess = false
    }
    
    init(code:Int, desString:String, isSuccess:Bool, isExpired: Bool = false) {
        self.status = code
        self.isSuccess = isSuccess
        self.message = desString
        self.isExpired = isExpired
    }
   
    static func createError(with des:String) -> ResponseMessage {
        let res:ResponseMessage = ResponseMessage(code: -1, desString: des, isSuccess: false, isExpired: false)
        return res
    }
    
    static func createSuccess(with des:String) -> ResponseMessage {
        let res:ResponseMessage = ResponseMessage(code: 0, desString: des, isSuccess: true, isExpired: false)
        return res
    }
}

extension ResponseMessage {
    
    func getDes() -> String { return "Test" }
    
    func onCheckSuccess() -> Bool {
        return self.isSuccess ?? false
    }
    
    static func createErrorMessage(code:Int? = nil, des:String) -> ResponseMessage {
        let res = ResponseMessage(code: code ?? -1, desString: des, isSuccess: false, isExpired: false)
        return res
    }
}
