//
//  LogViewTheme.swift
//  TTBaseUIKit
//
//  [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active
//  LogViewTheme.swift
//  TTBaseUIKit
//

import SwiftUI
import UIKit

@available(iOS 14.0, *)
internal enum LogViewTheme {

    static let background = Color(hex: 0x070A0F)
    static let navigation = Color(hex: 0x090D14)
    static let surface = Color(hex: 0x0D111A)
    static let elevatedSurface = Color(hex: 0x121826)
    static let codeSurface = Color(hex: 0x0B1020)
    static let border = Color(hex: 0x263244)
    static let subtleBorder = Color(hex: 0x1B2433)
    static let primaryText = Color(hex: 0xE6EDF3)
    static let secondaryText = Color(hex: 0x9AA7B8)
    static let mutedText = Color(hex: 0x657386)
    static let accent = Color(hex: 0x38BDF8)
    static let success = Color(hex: 0x22C55E)
    static let redirect = Color(hex: 0x60A5FA)
    static let warning = Color(hex: 0xF59E0B)
    static let danger = Color(hex: 0xEF4444)
    static let purple = Color(hex: 0xA78BFA)

    static let uiBackground = UIColor(hex: 0x070A0F)
    static let uiNavigation = UIColor(hex: 0x090D14)
    static let uiCodeSurface = UIColor(hex: 0x0B1020)
    static let uiPrimaryText = UIColor(hex: 0xE6EDF3)
    static let uiSecondaryText = UIColor(hex: 0x9AA7B8)
    static let uiMutedText = UIColor(hex: 0x657386)
    static let uiAccent = UIColor(hex: 0x38BDF8)
    static let uiSuccess = UIColor(hex: 0x22C55E)
    static let uiWarning = UIColor(hex: 0xF59E0B)
    static let uiDanger = UIColor(hex: 0xEF4444)
    static let uiPurple = UIColor(hex: 0xA78BFA)

    static func methodColor(for method: HTTPMethod) -> Color {
        switch method {
        case .get: return success
        case .post: return accent
        case .put: return warning
        case .delete: return danger
        case .patch: return purple
        case .head, .options: return redirect
        case .unknown: return mutedText
        }
    }

    static func statusColor(for category: HTTPStatusCategory) -> Color {
        switch category {
        case .all: return accent
        case .success: return success
        case .redirect: return redirect
        case .clientError: return warning
        case .serverError: return danger
        case .unknown: return mutedText
        }
    }
}

private extension Color {
    init(hex: UInt32, opacity: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: opacity
        )
    }
}

private extension UIColor {
    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255.0,
            green: CGFloat((hex >> 8) & 0xFF) / 255.0,
            blue: CGFloat(hex & 0xFF) / 255.0,
            alpha: alpha
        )
    }
}
