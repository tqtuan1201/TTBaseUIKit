# Skill: Create Controller

## Purpose
- Create a UIKit view controller following TTBaseUIKit lifecycle and layout rules

## Steps
1. Subclass `TTBaseUIViewController<BaseView>`
2. Override `updateBaseUI()` if needed
3. Configure `navType`, `isEffectView`, and `isSetHiddenTabar`
4. Use `setupViewCodable` on the BaseView
5. Use constraint helpers for layout

## Rules
- Do not use storyboards or nibs
- Keep `loadView` managed by the base class

## Template References
- `AI/templates/screens/uikit-controller.md`

## UIKit Implementation
- Base: `TTBaseUIViewController<BaseView>`
- View: `TTBaseUIView` subclass

## SwiftUI Implementation
- Use `TTBaseHostingController` when embedding SwiftUI

## Example Code
```swift
final class ProfileController: TTBaseUIViewController<ProfileView> {
    override func updateBaseUI() {
        navType = .STATUS_NAV
    }
}
```
