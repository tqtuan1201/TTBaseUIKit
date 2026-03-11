# Skill: Create View

## Purpose
- Create a new UIKit or SwiftUI view that follows TTBaseUIKit rules

## Steps
1. Identify UIKit or SwiftUI target
2. Select base class or base view
3. Use `TTViewCodable` for UIKit view assembly
4. Apply tokens from `TTSize`, `TTView`, `TTFont`, `TTStyle`
5. Use constraint helpers or SwiftUI modifiers

## Rules
- Use TTBaseUIKit tokens, not literals
- Prefer TTBaseUIKit wrappers over raw UIKit/SwiftUI
- Avoid `NSLayoutConstraint.activate`

## Template References
- `AI/templates/views/uikit-view.md`
- `AI/templates/swiftui/swiftui-view.md`

## UIKit Implementation
- Base: `TTBaseUIView`
- Protocol: `TTViewCodable`

## SwiftUI Implementation
- Base: `TTBaseSUIView`
- Modifiers: `View+Config+Extension`, `View+Spacing`, `View+Style`

## Example Code
```swift
final class ProfileCardView: TTBaseUIView, TTViewCodable {
    private let titleLabel = TTBaseUILabel(withType: .HEADER)

    override func updateBaseUIView() {
        setupViewCodable(with: [titleLabel])
    }

    func setupConstraints() {
        titleLabel.setLeadingAnchor(constant: TTSize.P_S)
            .setTopAnchor(constant: TTSize.P_S)
            .setTrailingAnchor(constant: TTSize.P_S)
            .done()
    }

    func setupStyles() {
        backgroundColor = TTView.viewDefColor
    }
}
```
