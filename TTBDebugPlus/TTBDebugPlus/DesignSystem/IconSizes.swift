//
//  IconSizes.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-29.
//  Design system icon size tokens
//

import SwiftUI

// MARK: - Icon Size Tokens
/// Standard icon sizes for SF Symbols used with `.font(.system(size:))`
enum TTIcon {
    static let xxxs: CGFloat = 7
    static let xxs: CGFloat = 8
    static let xs: CGFloat = 9
    static let sm: CGFloat = 10
    static let md: CGFloat = 11
    static let lg: CGFloat = 12
    static let xl: CGFloat = 14
    static let xxl: CGFloat = 16
    static let xxxl: CGFloat = 20
}

// MARK: - Icon Font Helpers
extension Font {
    /// Convenience for SF Symbol icon sizing
    static func ttIcon(_ size: CGFloat) -> Font {
        .system(size: size)
    }
}
