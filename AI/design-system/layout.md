# Layout

Source: `TTBaseUIKit/Sources/TTBaseUIKit/BaseConfig/SizeConfig.swift`

## Heights
- `H_STATUS`: `UIApplication.getStatusBarFrame()`
- `H_NAV`: 45
- `H_BUTTON`: 40
- `H_BUTTON_WITH_PANEL`: 55
- `H_TEXTFIELD`: 35
- `H_LINEVIEW`: 1.5
- `H_PROCESS_VIEW`: 6
- `H_BORDER`: 2
- `H_SEG`: 40
- `H_SEG_LINE`: 2
- `H_SEARCH_BAR`: 55
- `H_CELL`: `UIScreen.main.bounds.width / 5`
- `H_CELL_COLECT`: `UIScreen.main.bounds.width / 2.4`
- `H_CELL_HEADER_SPACE`: `UIScreen.main.bounds.width / 6.5`
- `H_HEADER`: `UIScreen.main.bounds.width / 3`
- `H_FOOTER`: `UIScreen.main.bounds.width / 5`
- `H_ICON`: 40
- `H_SMALL_ICON`: 30
- `H_SMALL_SMALL_ICON`: 14
- `H_SMALL_TINY_ICON`: 9
- `H_ICON_CELL`: 56
- `H_LOADING_CENTER`: 70 or 40 based on device size
- `NOTIFI_HEIGHT`: 80
- `NOTIFI_ICON_HEIGHT`: 45

## Widths
- `W_BUTTON`: `UIScreen.main.bounds.width / 2`
- `W_TEXT_RIGHTVIEW`: `UIScreen.main.bounds.width / 6`
- `W_TEXT_LEFTVIEW`: `UIScreen.main.bounds.width / 6`
- `W_ICONTEXT_DISSMISS_KEYBOARD`: 90
- `W_DISSMISS_PRESENTVIEW`: 6
- `W_DISSMISS_LINESPACE_PRESENTVIEW`: 40

## Ratios
- `RATIO`: 2 / 3

## Safe Area
- `H_BOTTOM_SAFE_AREA_INSET`: `UIApplication.getKeyWindow()?.safeAreaInsets.bottom ?? 0`

## Layout Rules
- Prefer `TTSize` tokens over literals
- Use constraint helpers in `CustomView/Helpers/ContraintHelpers.swift`
- UIKit screens should derive from `TTBaseUIViewController`
