# Skill: Create Layout

## Purpose
- Build layouts using TTBaseUIKit spacing and constraint helpers

## Steps
1. Choose layout container type
2. Apply `TTSize` spacing tokens
3. Use constraint helpers for UIKit
4. Use `View+Spacing` for SwiftUI

## Rules
- No raw `NSLayoutConstraint.activate`
- No hard-coded spacing values when tokens exist

## Template References
- `AI/templates/views/uikit-view.md`
- `AI/templates/swiftui/swiftui-view.md`

## UIKit Implementation
- Use `setFullContraints` or per-edge helpers
- Use `setTopAnchorWithAboveView` for vertical stacking

## SwiftUI Implementation
- Use `.pAll`, `.pHorizontal`, `.pVertical`
- Use `TTBaseSUIVStack` or `TTBaseSUIHStack`

## Example Code
```swift
contentView.setFullContraints(constant: TTSize.P_S)
```
