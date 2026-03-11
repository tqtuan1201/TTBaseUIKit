# Design System Guardrails

## Required
- Colors must come from `TTView`
- Font sizes must come from `TTFont`
- Spacing and sizes must come from `TTSize`
- Use `StyleConfig` and `ParamConfig` for behavior flags

## Forbidden
- Hard-coded colors, fonts, spacing values
- Custom design tokens without updating BaseConfig

## SwiftUI
- Convert UIColor to Color with `.toColor()`
- Use `TTBaseSUIText` for text with tokenized sizes
