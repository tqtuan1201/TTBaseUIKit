# Skill: Architecture and Configuration

## Purpose
- Initialize and enforce TTBaseUIKit configuration and architecture

## Steps
1. Initialize `TTBaseUIKitConfig` at app start
2. Set `FontConfig`, `SizeConfig`, `ViewConfig`, `StyleConfig`, `ParamConfig`
3. Use `TTViewCodable` for UIKit assembly
4. Use `TTBaseSUI*` components for SwiftUI

## Rules
- Always call `TTBaseUIKitConfig.withDefaultConfig(...).start()`
- Use `TTSize`, `TTView`, `TTFont`, `TTStyle`, `TTParam` tokens

## Template References
- `AI/templates/screens/uikit-controller.md`
- `AI/templates/swiftui/swiftui-screen.md`

## UIKit Implementation
- Base controller is `TTBaseUIViewController`
- Base view is `TTBaseUIView`

## SwiftUI Implementation
- Use `TTBaseHostingController` for embedding SwiftUI in UIKit

## Example Code
```swift
let config = TTBaseUIKitConfig.withDefaultConfig(
    withFontConfig: FontConfig(),
    frameSize: SizeConfig(),
    view: ViewConfig(),
    style: StyleConfig(),
    params: ParamConfig()
)
config?.start()
```
