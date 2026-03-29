//
//  Colors.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-27.
//

import SwiftUI

// MARK: - Design Tokens
extension Color {
    // Primary palette
    static let ttPrimary = Color(hex: "#3B82F6")
    static let ttPrimaryLight = Color(hex: "#60A5FA")
    static let ttPrimaryDark = Color(hex: "#2563EB")
    
    // Secondary
    static let ttSecondary = Color(hex: "#60A5FA")
    
    // Surfaces & Backgrounds
    static let ttBackground = Color(hex: "#0F172A")
    static let ttSurface = Color(hex: "#1E293B")
    static let ttSurfaceLight = Color(hex: "#334155")
    static let ttSurfaceHover = Color(hex: "#283548")
    
    // Borders
    static let ttBorder = Color(hex: "#334155")
    static let ttBorderLight = Color(hex: "#475569")
    
    // Text
    static let ttTextPrimary = Color(hex: "#F8FAFC")
    static let ttTextSecondary = Color(hex: "#94A3B8")
    static let ttTextTertiary = Color(hex: "#64748B")
    static let ttTextMuted = Color(hex: "#475569")
    
    // Status colors
    static let ttSuccess = Color(hex: "#22C55E")
    static let ttError = Color(hex: "#EF4444")
    static let ttWarning = Color(hex: "#F59E0B")
    static let ttInfo = Color(hex: "#3B82F6")
    
    // HTTP Method colors
    static let ttMethodGet = Color(hex: "#22C55E")
    static let ttMethodPost = Color(hex: "#3B82F6")
    static let ttMethodPut = Color(hex: "#F59E0B")
    static let ttMethodDelete = Color(hex: "#EF4444")
    static let ttMethodPatch = Color(hex: "#A855F7")
    
    // Status code colors
    static let ttStatus2xx = Color(hex: "#22C55E")
    static let ttStatus3xx = Color(hex: "#3B82F6")
    static let ttStatus4xx = Color(hex: "#F59E0B")
    static let ttStatus5xx = Color(hex: "#EF4444")
    
    // JSON syntax highlighting
    static let ttJsonKey = Color(hex: "#60A5FA")
    static let ttJsonString = Color(hex: "#FB923C")
    static let ttJsonNumber = Color(hex: "#4ADE80")
    static let ttJsonBool = Color(hex: "#C084FC")
    static let ttJsonNull = Color(hex: "#94A3B8")
    static let ttJsonBrace = Color(hex: "#94A3B8")
    
    // Log level colors
    static let ttLogError = Color(hex: "#EF4444")
    static let ttLogWarning = Color(hex: "#F59E0B")
    static let ttLogInfo = Color(hex: "#3B82F6")
    static let ttLogDebug = Color(hex: "#64748B")
    
    // Light mode overrides
    static let ttLightBackground = Color(hex: "#F1F5F9")
    static let ttLightSurface = Color(hex: "#FFFFFF")
    static let ttLightBorder = Color(hex: "#E2E8F0")
}

// MARK: - Hex Color Init
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Status Code Color Helper
extension Color {
    static func forStatusCode(_ code: Int) -> Color {
        switch code {
        case 200..<300: return .ttStatus2xx
        case 300..<400: return .ttStatus3xx
        case 400..<500: return .ttStatus4xx
        case 500..<600: return .ttStatus5xx
        default: return .ttTextSecondary
        }
    }
    
    static func forHTTPMethod(_ method: String) -> Color {
        switch method.uppercased() {
        case "GET": return .ttMethodGet
        case "POST": return .ttMethodPost
        case "PUT": return .ttMethodPut
        case "DELETE": return .ttMethodDelete
        case "PATCH": return .ttMethodPatch
        default: return .ttTextSecondary
        }
    }
    
    static func forLogLevel(_ level: String) -> Color {
        switch level.lowercased() {
        case "error": return .ttLogError
        case "warning": return .ttLogWarning
        case "info": return .ttLogInfo
        case "debug": return .ttLogDebug
        default: return .ttTextSecondary
        }
    }
    
    // MARK: - Device Colors
    /// Stable color palette for multi-device identification
    private static let deviceColorPalette: [Color] = [
        Color(hex: "#06B6D4"), // cyan
        Color(hex: "#F97316"), // orange
        Color(hex: "#A855F7"), // purple
        Color(hex: "#EC4899"), // pink
        Color(hex: "#14B8A6"), // teal
        Color(hex: "#6366F1"), // indigo
        Color(hex: "#84CC16"), // lime
        Color(hex: "#F43F5E"), // rose
    ]
    
    /// Returns a stable color for a given device ID
    static func forDevice(_ deviceId: String) -> Color {
        let hash = abs(deviceId.hashValue)
        return deviceColorPalette[hash % deviceColorPalette.count]
    }
    
    // Row alternating background
    static let ttRowAlternate = Color(hex: "#1E293B").opacity(0.3)
}

// MARK: - Opacity Tokens
enum TTOpacity {
    /// Barely visible tint (error row background)
    static let subtle: Double = 0.03
    /// Very faint hover/tint
    static let faint: Double = 0.08
    /// Active state / selected indicator
    static let light: Double = 0.12
    /// Medium overlay
    static let medium: Double = 0.15
    /// Border / divider opacity
    static let border: Double = 0.3
    /// Semi-transparent overlay
    static let strong: Double = 0.5
    /// Heavy overlay (modals, spotlight)
    static let heavy: Double = 0.6
    /// Card surface
    static let surface: Double = 0.75
}
