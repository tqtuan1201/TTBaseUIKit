# Skill: Refactor

## Purpose
- Refactor existing UI code to match TTBaseUIKit standards

## Steps
1. Identify raw UIKit/SwiftUI primitives
2. Replace with TTBaseUIKit base components
3. Replace literals with tokens
4. Replace manual constraints with helpers
5. Validate against guardrails

## Rules
- Preserve public API and behaviors
- Prefer minimal changes per file

## Template References
- `AI/templates/views/uikit-view.md`
- `AI/templates/swiftui/swiftui-view.md`

## UIKit Implementation
- Replace `UIView` with `TTBaseUIView` when appropriate
- Replace `UILabel` with `TTBaseUILabel`

## SwiftUI Implementation
- Replace raw `Text` with `TTBaseSUIText` where a tokenized style exists

## Example Code
```swift
let label = TTBaseUILabel(withType: .TITLE)
```
