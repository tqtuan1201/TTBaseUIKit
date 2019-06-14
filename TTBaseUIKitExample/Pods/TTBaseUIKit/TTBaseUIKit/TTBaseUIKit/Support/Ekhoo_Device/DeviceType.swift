//
//  Type.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 5/7/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
//
//  Type.swift
//  Device
//
//  Created by Stefan Jansen on 08-12-15.
//  Copyright © 2015 Ekhoo. All rights reserved.
//
public enum DeviceType: String {
    #if os(iOS)
    case iPhone
    case iPad
    case iPod
    case simulator
    #elseif os(OSX)
    case iMac
    case macMini
    case macPro
    case macBook
    case macBookAir
    case macBookPro
    case xserve
    #endif
    case unknown
}
