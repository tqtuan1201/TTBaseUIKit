//
//  Shadows.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-29.
//  Design system shadow tokens
//

import SwiftUI

// MARK: - Shadow Tokens
enum TTShadow {
    case sm, md, lg, glow(Color)
    
    var color: Color {
        switch self {
        case .sm: return .black.opacity(0.08)
        case .md: return .black.opacity(0.12)
        case .lg: return .black.opacity(0.2)
        case .glow(let color): return color.opacity(0.3)
        }
    }
    
    var radius: CGFloat {
        switch self {
        case .sm: return 4
        case .md: return 6
        case .lg: return 12
        case .glow: return 8
        }
    }
    
    var y: CGFloat {
        switch self {
        case .sm: return 2
        case .md: return 3
        case .lg: return 6
        case .glow: return 0
        }
    }
}

// MARK: - Shadow View Modifier
struct TTShadowModifier: ViewModifier {
    let shadow: TTShadow
    
    func body(content: Content) -> some View {
        content.shadow(color: shadow.color, radius: shadow.radius, y: shadow.y)
    }
}

extension View {
    func ttShadow(_ shadow: TTShadow) -> some View {
        modifier(TTShadowModifier(shadow: shadow))
    }
}
