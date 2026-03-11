# Skill: Validation

## Purpose
- Validate UI code for compliance with TTBaseUIKit rules

## Steps
1. Check for TTBaseUIKit base classes and tokens
2. Verify layout helpers are used in UIKit
3. Verify SwiftUI modifiers use TTBaseUIKit helpers
4. Confirm no forbidden APIs

## Rules
- No `NSLayoutConstraint.activate`
- No raw `UIColor(...)` or `Color(...)` when tokens exist
- No `Font.system(...)` or `UIFont(...)` when tokens exist

## Template References
- `AI/guardrails/ui-rules.md`
- `AI/guardrails/layout-rules.md`
- `AI/guardrails/design-system-rules.md`

## UIKit Implementation
- Ensure `TTViewCodable` and `TTBaseUIViewController` usage

## SwiftUI Implementation
- Ensure `TTBaseSUI*` usage and modifiers

## Example Code
```swift
let isValid = view is TTBaseUIView
```
