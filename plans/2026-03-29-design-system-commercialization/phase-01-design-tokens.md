# Phase 1: Design System Extension

> Parent: [plan.md](plan.md)

## Overview

**Date:** 2026-03-29
**Priority:** High
**Status:** ⬜ TODO
**Estimated Effort:** 6h

Extend the existing design system with missing token categories: spacing, corner radius, shadows, animations, opacity, and icon sizes. These tokens will be used in Phase 2 to replace all magic numbers.

## Key Insights

- Current design system covers colors (45+ tokens) and typography (15+ tokens) well
- Missing: spacing, radius, shadow, opacity, animation, icon sizing → hundreds of magic numbers scattered across 25+ files
- Apple HIG recommends 8px grid system for macOS spacing
- Industry standard: design tokens as single source of truth

## Requirements

1. Create `TTSpacing` enum with values on 4px/8px grid
2. Create `TTRadius` enum standardizing corner radii (4/6/8/12)
3. Create `TTShadow` view modifier system
4. Create `TTAnimation` tokens for consistent transitions
5. Create `TTIcon` enum for icon sizing
6. Create `TTOpacity` tokens for consistent transparency
7. Add missing typography modifiers to `Typography.swift`

## Architecture

All new files in `TTBDebugPlus/DesignSystem/`

## Related Code Files

- [Colors.swift](../../TTBDebugPlus/TTBDebugPlus/DesignSystem/Colors.swift)
- [Typography.swift](../../TTBDebugPlus/TTBDebugPlus/DesignSystem/Typography.swift)
- [ButtonStyles.swift](../../TTBDebugPlus/TTBDebugPlus/DesignSystem/ButtonStyles.swift)
- [CardView.swift](../../TTBDebugPlus/TTBDebugPlus/DesignSystem/CardView.swift)

## Implementation Steps

### 1. Create `Spacing.swift`
```swift
enum TTSpacing {
    static let xxxs: CGFloat = 2
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 6
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 24
    static let xxxl: CGFloat = 32
    
    // Semantic aliases
    static let rowVertical: CGFloat = 7
    static let rowHorizontal: CGFloat = 16
    static let sectionPadding: CGFloat = 16
    static let cardPadding: CGFloat = 16
    static let toolbarPadding: CGFloat = 8
    static let filterBarPadding: CGFloat = 6
}
```

### 2. Create `Radius.swift`
```swift
enum TTRadius {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 6
    static let md: CGFloat = 8
    static let lg: CGFloat = 12
    static let xl: CGFloat = 16
    static let full: CGFloat = 999 // Capsule
}
```

### 3. Create `Shadows.swift`
```swift
struct TTShadow: ViewModifier { ... }
// Predefined: .ttShadowSm, .ttShadowMd, .ttShadowLg
```

### 4. Create `Animations.swift`
```swift
enum TTAnimation {
    static let fast = Animation.easeInOut(duration: 0.1)
    static let normal = Animation.easeInOut(duration: 0.15)
    static let slow = Animation.easeInOut(duration: 0.25)
    static let spring = Animation.spring(response: 0.3, dampingFraction: 0.7)
}
```

### 5. Create `IconSizes.swift`
```swift
enum TTIcon {
    static let xxxs: CGFloat = 7
    static let xxs: CGFloat = 8
    static let xs: CGFloat = 9
    static let sm: CGFloat = 10
    static let md: CGFloat = 11
    static let lg: CGFloat = 12
    static let xl: CGFloat = 14
    static let xxl: CGFloat = 16
}
```

### 6. Add opacity tokens to `Colors.swift`
```swift
enum TTOpacity {
    static let subtle: Double = 0.03
    static let light: Double = 0.08
    static let medium: Double = 0.12
    static let strong: Double = 0.3
    static let heavy: Double = 0.5
    static let overlay: Double = 0.6
}
```

### 7. Extend `Typography.swift` — add missing modifiers
- `.ttLabelSmall()`, `.ttCodeSmall()`, `.ttTimestamp()`, `.ttBadge()`

## Todo List

- [ ] Create `Spacing.swift` with all spacing tokens
- [ ] Create `Radius.swift` with corner radius tokens
- [ ] Create `Shadows.swift` with shadow modifiers
- [ ] Create `Animations.swift` with animation tokens
- [ ] Create `IconSizes.swift` with icon size tokens
- [ ] Add `TTOpacity` to `Colors.swift`
- [ ] Add missing view modifiers to `Typography.swift`
- [ ] Verify build compiles

## Success Criteria

- All token files compile without error
- Token values match existing hardcoded values in codebase (preserve visual identity)
- No view files modified in this phase (tokens only)

## Risk Assessment

- **Low risk** — additive only, no existing code modified
- Token naming must match team conventions to avoid confusion later
