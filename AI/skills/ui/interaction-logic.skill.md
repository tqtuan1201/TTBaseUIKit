# Skill: Interaction Logic

## Purpose
- Wire user interactions using TTBaseUIKit idioms

## Steps
1. Define interaction points in the base view
2. Use handlers like `onTouchHandler` or gesture modifiers
3. Route actions to the controller or view model
4. Respect style config options in `TTStyle`

## Rules
- Use TTBaseUIKit event helpers
- Avoid mixing raw UIKit targets with base handlers when wrappers exist

## Template References
- `AI/templates/views/uikit-view.md`
- `AI/templates/swiftui/swiftui-view.md`

## UIKit Implementation
- Use `setTouchHandler()` for `TTBaseUILabel` and `TTBaseUIView`
- Use `TTBaseUIButton` actions via target or closure

## SwiftUI Implementation
- Use `onTapHandle` and `TTSUISwipeGestureModifier`

## Example Code
```swift
button.onTouchHandler = { _ in
    TTBaseFunc.shared.printLog(object: "Tapped")
}
```
