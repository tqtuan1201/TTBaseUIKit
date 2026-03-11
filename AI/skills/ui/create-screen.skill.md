# Skill: Create Screen

## Purpose
- Build a screen with architecture and patterns aligned to TTBaseUIKit

## Steps
1. Choose UIKit or SwiftUI screen type
2. If UIKit, create BaseView and BaseViewController
3. Assemble UI via `TTViewCodable`
4. Apply design tokens and layout helpers
5. Add actions and data bindings

## Rules
- UIKit screens must derive from `TTBaseUIViewController`
- SwiftUI screens should use `TTBaseSUI*` base components

## Template References
- `AI/templates/screens/uikit-controller.md`
- `AI/templates/screens/swiftui-screen.md`

## UIKit Implementation
- BaseView for UI tree
- Controller for navigation and lifecycle

## SwiftUI Implementation
- A single `View` with base components and modifiers

## Example Code
```swift
final class SettingsView: TTBaseUIView, TTViewCodable { }
final class SettingsController: TTBaseUIViewController<SettingsView> { }
```
