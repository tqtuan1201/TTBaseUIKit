//
//  File.swift
//  TTBaseUIKit
//
//  Created by TuanTruong on 14/7/25.
//

import Foundation
import Combine

public func sleep(seconds: Double) async {
    let duration = UInt64(seconds * 1_000_000_000)
    try? await Task.sleep(nanoseconds: duration)
}

