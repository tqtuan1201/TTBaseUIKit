# Pattern: Liquid Glass

## Intent
- Use Liquid Glass material in SwiftUI and UIKit

## UIKit Building Blocks
- `UIView.applyLiquidGlassUIKit(...)`

## SwiftUI Building Blocks
- `.glassEffect(...)` in `View+LiquidGlass+Extension.swift`
- `WhiteLiquidGlassBackground`
- `BlackLiquidGlassBackground`

## Rules
- On SwiftUI, apply `.glassEffect` after sizing and layout modifiers
- On UIKit, call `applyLiquidGlassUIKit` after `layoutSubviews` to ensure bounds
