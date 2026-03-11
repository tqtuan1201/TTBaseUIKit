# Layout Guardrails

## Required
- Use constraint helpers in `CustomView/Helpers/ContraintHelpers.swift`
- Use `setFullContraints` for container pinning
- Use `TTSize` spacing tokens

## Forbidden
- Direct `NSLayoutConstraint.activate`
- Hard-coded spacing values when tokens exist

## SwiftUI
- Use `.pAll`, `.pHorizontal`, `.pVertical` for padding
- Use `TTBaseSUIHStack`, `TTBaseSUIVStack`, `TTBaseSUIZStack` for layout
