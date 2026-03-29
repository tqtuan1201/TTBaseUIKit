//
//  Animations.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-29.
//  Design system animation tokens
//

import SwiftUI

// MARK: - Animation Tokens
enum TTAnimation {
    // Duration-based
    static let fast = Animation.easeInOut(duration: 0.1)
    static let normal = Animation.easeInOut(duration: 0.15)
    static let slow = Animation.easeInOut(duration: 0.25)
    
    // Spring-based
    static let spring = Animation.spring(response: 0.3, dampingFraction: 0.7)
    static let springGentle = Animation.spring(response: 0.4, dampingFraction: 0.8)
    
    // Durations (for use with withAnimation)
    static let durationFast: TimeInterval = 0.1
    static let durationNormal: TimeInterval = 0.15
    static let durationSlow: TimeInterval = 0.25
    
    // Transition presets
    static let fadeIn = AnyTransition.opacity.animation(normal)
    static let slideUp = AnyTransition.move(edge: .bottom).combined(with: .opacity).animation(slow)
    static let scaleIn = AnyTransition.scale(scale: 0.95).combined(with: .opacity).animation(normal)
}
