//
//  SwiftUIView.swift
//  TTBaseUIKit
//
//  Created by TuanTruong on 4/7/25.
//

import SwiftUI

// MARK: - Design-system priority scale
public enum TTBASESUI_LAYOUTPRIORITY: Double, CaseIterable {
    case LOWSUPER  = -333
    case LOWEST  = -10
    case LOW     = 0          // less likely to expand/shrink
    case NORMAL  = 11          // default (recommended)
    case HIGH    = 22
    case HIGHEST = 33          // almost always wins
    case HIGHSUPER = 333          // almost always wins
}

// MARK: - View helpers
public extension View {
    
    /// Apply a predefined layout priority (`.low`, `.normal`, `.high`, `.highest`).
    /// Defaults to `.normal`, so you may call `.lp()` for the most common case.
    @inlinable
    func lp(_ priority: TTBASESUI_LAYOUTPRIORITY = .NORMAL) -> some View {
        self.layoutPriority(priority.rawValue)
    }
    
    /// Apply an arbitrary `Double` layout priority—useful for fine-tuning.
    @inlinable
    func lp(_ value: Double) -> some View {
        self.layoutPriority(value)
    }
}
