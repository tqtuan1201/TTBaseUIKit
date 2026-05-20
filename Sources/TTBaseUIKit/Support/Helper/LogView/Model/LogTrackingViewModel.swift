//
//  LogTrackingViewModel.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 9/11/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation

public class LogTrackingViewModel {

    public var isSkipCheckPass: Bool = false
    public var isStartAppToShow: Bool = true
    public var isShow: Bool = false
    public var displayString: String = "Easily inspect layouts, monitor logs, and simulate environments while building your app"
    public var logs: [LogViewModel] = []
    public var passCode: String = ""

    public init() {}
}
