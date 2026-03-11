# Skill: Create Component

## Purpose
- Build a reusable UI component following TTBaseUIKit patterns

## Steps
1. Identify component type and base class
2. Use tokens from `TTSize`, `TTView`, `TTFont`
3. Provide minimal API surface and defaults
4. Add TTViewCodable lifecycle if UIKit
5. Provide a SwiftUI counterpart when possible

## Rules
- Expose styling through tokens, not raw colors
- Use `TTBaseUILabel.TYPE` for text styling

## Template References
- `AI/templates/components/uikit-component.md`
- `AI/templates/swiftui/swiftui-component.md`

## UIKit Implementation
- Use `TTBaseUIView` or specific base element
- Keep `updateBaseUIView()` for config

## SwiftUI Implementation
- Provide a `View` struct and use `TTBaseSUI*` atoms

## Example Code
```swift
final class IconTitleView: TTBaseUIView, TTViewCodable {
    private let icon = TTBaseUIImageView()
    private let title = TTBaseUILabel(withType: .TITLE)

    override func updateBaseUIView() {
        setupViewCodable(with: [icon, title])
    }

    func setupConstraints() {
        icon.setLeadingAnchor(constant: TTSize.P_S)
            .setCenterXAnchor(constant: 0)
        title.setLeadingWithNextToView(view: icon, constant: TTSize.P_S)
            .setCenterXAnchor(constant: 0)
    }
}
```
