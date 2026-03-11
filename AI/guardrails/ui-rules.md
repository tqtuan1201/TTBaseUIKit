# UI Guardrails

## Required
- Use `TTBaseUIKitConfig.withDefaultConfig(...).start()` during app setup
- Use `TTSize`, `TTView`, `TTFont`, `TTStyle`, `TTParam` tokens
- UIKit views must subclass `TTBaseUIView` when a base exists
- UIKit controllers must subclass `TTBaseUIViewController`
- Use `TTViewCodable` for UIKit view assembly

## Forbidden
- Raw `NSLayoutConstraint.activate` in UIKit
- Hard-coded colors or fonts when tokens exist
- Storyboards or nibs for TTBaseUIKit components
- Direct `UIView`, `UILabel`, `UIButton` when `TTBase*` exists

## Preferred
- Use `TTBaseNotificationViewConfig` for toasts
- Use skeleton helpers for loading
- Use `TTBaseHostingController` for SwiftUI hosting
