# Spacing

Source: `TTBaseUIKit/Sources/TTBaseUIKit/BaseConfig/SizeConfig.swift`

## Base Tokens
- `P_CONS_DEF`: 8
- `P_CONS_LEFT_H`: 8
- `P_CONS_RIGHT_H`: 8
- `P_CONS_TOP_H`: 8
- `P_CONS_BOTOM_H`: 8
- `LINE_SPACING`: 4

## Scale
- `P_XS`: `P_CONS_DEF / 2` = 4
- `P_S`: `P_CONS_DEF` = 8
- `P_M`: `P_CONS_DEF * 1.5` = 12
- `P_L`: `P_CONS_DEF * 2` = 16
- `P_XL`: `P_CONS_DEF * 2.5` = 20

## Dynamic Padding
- `P`: `UIScreen.main.bounds.width / 50`

## Usage
- UIKit prefers `TTSize.*` tokens
- SwiftUI uses `.pAll`, `.pHorizontal`, `.pVertical`, `.pTop`, `.pBottom` in `View+Spacing.swift`
