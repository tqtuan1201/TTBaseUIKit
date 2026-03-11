# Pattern: Card or Panel

## Intent
- Encapsulate content with padding, corner radius, and optional shadow

## UIKit Building Blocks
- `TTBaseShadowPanelView`
- `TTBaseStackPanelView`
- `TTBasePanelButtonView`
- `TTBaseShadowView`

## SwiftUI Building Blocks
- `TTBaseSUIView`
- `.baseShadow()`
- `.corner(byDef:)`

## Rules
- Use `TTSize.CORNER_PANEL` or `TTSize.CORNER_RADIUS`
- Prefer `TTView.viewDefColor` for background

## Example
```swift
let panel = TTBaseShadowPanelView()
panel.setConerRadius(with: TTSize.CORNER_PANEL)
panel.backgroundColor = TTView.viewDefColor
```
