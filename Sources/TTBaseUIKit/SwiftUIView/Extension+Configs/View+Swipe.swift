//
//  View+Swipe.swift
//  TTBaseUIKit
//
//  Created by TuanTruong on 7/7/25.
//
import SwiftUI

/// Hướng vuốt được hỗ trợ
public enum TTSUISwipeDirection : CaseIterable, Hashable {
    case LEFT, RIGHT, UP, DOWN
}

// MARK: - Single-direction modifier (unchanged)
private struct TTSUISwipeGestureModifier: ViewModifier {
    let direction: TTSUISwipeDirection
    let threshold: CGFloat
    let action: () -> Void
    @State private var start = CGPoint.zero

    func body(content: Content) -> some View {
        content.highPriorityGesture(
            DragGesture(minimumDistance: self.threshold)
                .onChanged { self.start = $0.startLocation }
                .onEnded   { value in
                    if self.hit(self.direction, value.translation) { self.action() }
                }
        )
    }

    // decide if translation qualifies for this direction
    private func hit(_ dir: TTSUISwipeDirection, _ t: CGSize) -> Bool {
        switch dir {
        case .LEFT:  t.width < -self.threshold && abs(t.height) < self.threshold / 2
        case .RIGHT: t.width >  self.threshold && abs(t.height) < self.threshold / 2
        case .UP:    t.height < -self.threshold && abs(t.width) < self.threshold / 2
        case .DOWN:  t.height >  self.threshold && abs(t.width) < self.threshold / 2
        }
    }
}

// MARK: - NEW multi-direction modifier
private struct MultiSwipeGestureModifier: ViewModifier {
    let directions: Set<TTSUISwipeDirection>
    let threshold: CGFloat
    let action: (TTSUISwipeDirection) -> Void
    @State private var start = CGPoint.zero
    
    func body(content: Content) -> some View {
        content.highPriorityGesture(
            DragGesture(minimumDistance: self.threshold)
                .onChanged { self.start = $0.startLocation }
                .onEnded   { value in
                    let t = value.translation
                    // evaluate directions in a deterministic order
                    for dir in TTSUISwipeDirection.allCases {
                        if self.directions.contains(dir) && self.hit(dir, t) {
                            self.action(dir)
                            break
                        }
                    }
                }
        )
    }
    
    private func hit(_ dir: TTSUISwipeDirection, _ t: CGSize) -> Bool {
        switch dir {
        case .LEFT:  t.width < -self.threshold && abs(t.height) < self.threshold / 2
        case .RIGHT: t.width >  self.threshold && abs(t.height) < self.threshold / 2
        case .UP:    t.height < -self.threshold && abs(t.width) < self.threshold / 2
        case .DOWN:  t.height >  self.threshold && abs(t.width) < self.threshold / 2
        }
    }
}

// MARK: - Sugar APIs
public extension View {
    /// Detect a swipe in *one* direction.
    func onSwipe(_ direction: TTSUISwipeDirection, threshold: CGFloat = 50, perform action: @escaping () -> Void ) -> some View {
        self.modifier(TTSUISwipeGestureModifier(direction: direction, threshold: threshold, action: action))
    }

    /// Detect swipes in *multiple* directions; the closure tells you which one fired.
    func onSwipe(_ directions: TTSUISwipeDirection..., threshold: CGFloat = 50, perform action: @escaping (TTSUISwipeDirection) -> Void ) -> some View {
        self.modifier(MultiSwipeGestureModifier(directions: Set(directions), threshold: threshold, action: action))
    }

    /// Convenience for horizontal swipes with separate closures.
    func onHorizontalSwipe( threshold: CGFloat = 50, onLeft: @escaping () -> Void, onRight: @escaping () -> Void ) -> some View {
        self.onSwipe(.LEFT, .RIGHT, threshold: threshold) { dir in
            dir == .LEFT ? onLeft() : onRight()
        }
    }
}
