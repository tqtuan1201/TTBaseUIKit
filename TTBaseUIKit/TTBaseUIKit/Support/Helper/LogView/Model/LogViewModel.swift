//
//  LogViewModel.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 9/11/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation

public class LogViewModel {
    
    public var name:String = ""
    public var request:String = ""
    public var response:String = ""
    public var urlRequest:String = ""
    public var time:Date = Date()
    
    public init(withName name:String, request:String, response:String, urlRequest:String) {
        self.name = name
        self.request = request
        self.response = response
        self.urlRequest = urlRequest
    }
    
    public func getDisplayService() -> String {
        return "\(name) - \(time.dateString(withFormat: .HH_MM_A))\n\(urlRequest)"
    }
}

class LogTrackingViewModel {
   
    var isSkipCheckPass:Bool = false
    var isStartAppToShow:Bool = true
    var isShow:Bool = false
    var displayString:String = "View log by json or report bugs"
    var logs:[LogViewModel] = []
    var passCode:String = ""
    init() { }
}

