//
//  Size.swift
//  Device
//
//  Created by Lucas Ortis on 30/10/2015.
//  Copyright © 2015 Ekhoo. All rights reserved.
//
public enum DeviceSize: Int, Comparable {
    case unknownSize = 0
    #if os(iOS)
    /// iPhone 4, 4s, iPod Touch 4th gen.
    case screen3_5Inch
    /// iPhone 5, 5s, 5c, SE, iPod Touch 5-6th gen.
    case screen4Inch
    /// iPhone 6, 6s, 7, 8, iPhoneSE2
    case screen4_7Inch
    /// iPhone mini 2020
    case screen5_4Inch
    /// iPhone 6+, 6s+, 7+, 8+
    case screen5_5Inch
    /// iPhone X, Xs, 11 Pro
    case screen5_8Inch
    /// iPhone Xr, 11, iPhone12, iPhone12Pro
    case screen6_1Inch
    /// iPhone Xs Max, 11 Pro Max
    case screen6_5Inch
    /// iPhone12ProMax
    case screen6_7Inch
    /// iPad Mini
    case screen7_9Inch
    /// iPad
    case screen9_7Inch
    /// iPad (10.2-inch)
    case screen10_2Inch
    /// iPad Pro (10.5-inch)
    case screen10_5Inch
    /// iPad Pro (11-inch)
    case screen11Inch
    /// iPad Pro (12.9-inch)
    case screen12_9Inch
    #elseif os(OSX)
    case screen11Inch
    case screen12Inch
    case screen13Inch
    case screen15Inch
    case screen17Inch
    case screen20Inch
    case screen21_5Inch
    case screen24Inch
    case screen27Inch
    #endif
}

public func <(lhs: DeviceSize, rhs: DeviceSize) -> Bool {
    return lhs.rawValue < rhs.rawValue
}

public func ==(lhs: DeviceSize, rhs: DeviceSize) -> Bool {
    return lhs.rawValue == rhs.rawValue
}
