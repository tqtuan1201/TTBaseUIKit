# Typography

Source: `TTBaseUIKit/Sources/TTBaseUIKit/BaseConfig/FontConfig.swift`

## Scale
- `HEADER_SUPER_H`: 24
- `HEADER_H`: 16
- `TITLE_H`: 14
- `SUB_TITLE_H`: 12
- `SUB_SUB_TITLE_H`: 10

## Base Font
- `FONT`: `UIFont.systemFont(ofSize: 14, weight: .regular)`

## Device Adjustments
- On devices smaller than 4.7 inch, defaults are reduced:
- `HEADER_H` becomes 14.5
- `TITLE_H` becomes 13.5
- `SUB_TITLE_H` becomes 11.5
- `SUB_SUB_TITLE_H` becomes 9.5

## Usage
- UIKit uses `TTBaseUILabel.TYPE` to map to sizes
- SwiftUI `TTBaseSUIText` uses the same sizes via `TTFont.*`
