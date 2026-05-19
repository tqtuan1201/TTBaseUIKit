---
name: "ttb-ref-native-design-tokens"
description: "Complete design token mapping for native SwiftUI components: colors, fonts, sizes, shadows, and spacing aligned with TTBaseUIKit config."
version: "1.0.1"
---

# ttb-ref-native-design-tokens — Native SwiftUI Design Token Reference

Design token reference for building native SwiftUI components with TTBaseUIKit.

## Color Tokens

### Brand Colors
```swift
TTView.buttonBgDef.toColor()     // Primary brand blue  (#1C82AD)
TTView.buttonBgWar.toColor()     // Destructive red    (#C41F53)
TTView.buttonBgDis.toColor()     // Disabled gray      (#454545)
```

### Text Colors
```swift
TTView.textHeaderColor.toColor()  // Headers / titles    (#3c3c3c)
TTView.textDefColor.toColor()    // Default body text  (#555555)
TTView.textSubTitleColor.toColor() // Subtitles / notes (#555555)
TTView.textTitleColor.toColor()  // Title text        (#555555)
TTView.textWarringColor.toColor() // Warning text      (#C41F53)
```

### Background Colors
```swift
TTView.viewBgColor.toColor()     // Main background    (#DBDBDB)
TTView.viewBgCellColor.toColor() // Card / cell bg    (#FFFFFF)
TTView.viewDefColor.toColor()    // Default white      (#FFFFFF)
TTView.viewDisableColor.toColor() // Disabled bg       (#c5c5c5)
TTView.viewBgNavColor.toColor()  // Nav bar bg        (#00A79E)
```

### Notification / Status Colors
```swift
TTView.notificationBgSuccess.toColor()  // Success / green  (#0077ab)
TTView.notificationBgWarning.toColor()  // Warning / yellow (#cc9a05)
TTView.notificationBgError.toColor()    // Error / red      (#b22a37)
```

### Interactive Colors
```swift
TTView.buttonBgDef.toColor()    // Primary button bg  (#1C82AD)
TTView.buttonBorderColor.toColor() // Button border   (#e5e5e5)
```

### Icon & Line Colors
```swift
TTView.iconColor.toColor()       // Default icon      (#777777)
TTView.lineDefColor.toColor()    // Separator / div   (#e5e5e5)
TTView.lineActiveColor.toColor() // Active line       (#C41F53)
```

### Special Colors
```swift
TTView.viewBgCellSelectedColor.toColor() // Cell selected   (#e8f2f6)
TTView.viewBgAccessoryViewColor.toColor() // Accessory bg  (alpha 0.8 white)
TTView.viewBgLoadingColor.toColor()      // Loading spinner  (#1C82AD)
TTView.viewTextLoadingColor.toColor()     // Loading text    (#1C82AD)
TTView.viewBgSkeleton.toColor()           // Skeleton bg     (#e8e8e8)
```

## Size Tokens

### Spacing Scale
```swift
TTSize.P_XS            // 4pt  — extra small (P_CONS_DEF / 2)
TTSize.P_S             // 8pt  — small (P_CONS_DEF)
TTSize.P_M             // 12pt — medium (P_CONS_DEF * 1.5)
TTSize.P_L             // 16pt — large (P_CONS_DEF * 2)
TTSize.P_XL            // 20pt — extra large (P_CONS_DEF * 2.5)

// Direct calculations
TTSize.P_CONS_DEF         // 8pt  — default spacing
TTSize.P_CONS_DEF * 2     // 16pt — double padding (screen edge)
TTSize.P_CONS_DEF / 2     // 4pt  — half padding
TTSize.P_CONS_DEF * 3     // 24pt — triple padding (section gap)
```

### Corner Radius
```swift
TTSize.CORNER_RADIUS    // 4pt  — default corner
TTSize.CORNER_BUTTON    // 4pt  — button corner
TTSize.CORNER_PANEL     // 8pt  — card / panel corner
TTSize.CORNER_IMAGE     // 20pt — avatar / image corner
```

### Heights
```swift
TTSize.H_BUTTON         // 40pt — button height
TTSize.H_TEXTFIELD      // 35pt — text field height
TTSize.H_CELL           // Calculated — table cell height
TTSize.H_NAV            // 45pt — nav bar height
TTSize.H_ICON           // 40pt — default icon
TTSize.H_SMALL_ICON      // 30pt — small icon
TTSize.H_SMALL_SMALL_ICON // 14pt — tiny icon
TTSize.H_SMALL_TINY_ICON  // 9pt  — very tiny icon
TTSize.H_ICON_CELL       // 56pt — cell icon
TTSize.H_LINEVIEW        // 1.5pt — divider thickness
TTSize.H_SEG             // 40pt — segment height
TTSize.H_PROCESS_VIEW    // 6pt  — progress bar height
```

## Font Tokens

```swift
// System font sizes (use with .font(.system(size:weight:)))
TTFont.HEADER_SUPER_H  // 24pt — super header / hero text
TTFont.HEADER_H        // ~16pt — header font size
TTFont.TITLE_H         // ~14pt — title font size
TTFont.SUB_TITLE_H     // ~12pt — subtitle / caption
TTFont.SUB_SUB_TITLE_H // ~10pt — smallest label
```

### Usage in SwiftUI Text
```swift
Text("Heading")
    .font(.system(size: TTFont.HEADER_H, weight: .bold))
    .foregroundColor(TTView.textHeaderColor.toColor())

Text("Title")
    .font(.system(size: TTFont.TITLE_H, weight: .medium))
    .foregroundColor(TTView.textDefColor.toColor())

Text("Caption")
    .font(.system(size: TTFont.SUB_TITLE_H, weight: .regular))
    .foregroundColor(TTView.textSubTitleColor.toColor())
```

### Font Weights
```swift
.weight(.regular)     // Normal text
.weight(.medium)     // Emphasis
.weight(.semibold)    // Button text, labels
.weight(.bold)       // Headings, titles
```

## Shadow Tokens

### Default Card Shadow
```swift
// Via modifier extension
.baseShadow()
// OR raw:
.shadow(color: .black.opacity(0.14), radius: 8, x: 0, y: 4)
```

### Panel Shadow
```swift
.shadow(color: .black.opacity(0.14), radius: 8, x: 0, y: 4)
```

## Quick Reference Table

| Token | Value | Usage |
|-------|-------|-------|
| `TTSize.P_S` | 4pt | Tight spacing, icon-to-text |
| `TTSize.P_CONS_DEF` | 8pt | Default item spacing |
| `TTSize.P_M` | 12pt | Medium spacing |
| `TTSize.P_L` | 16pt | Large spacing, screen padding |
| `TTSize.P_XL` | 20pt | Section separation |
| `TTSize.H_BUTTON` | 40pt | Button height |
| `TTSize.H_TEXTFIELD` | 35pt | TextField height |
| `TTSize.CORNER_RADIUS` | 4pt | Default corner |
| `TTSize.CORNER_PANEL` | 8pt | Card corner |
| `TTSize.H_LINEVIEW` | 1.5pt | Divider thickness |
| `TTSize.H_ICON` | 40pt | Default icon size |
| `TTFont.HEADER_H` | ~16pt | Header text |
| `TTFont.TITLE_H` | ~14pt | Title text |
| `TTFont.SUB_TITLE_H` | ~12pt | Subtitle text |

## Common Calculations

```swift
// Screen edge padding
.padding(TTSize.P_L)

// Card internal padding
.padding(TTSize.P_CONS_DEF)

// Between icon and text
HStack(spacing: TTSize.P_S)

// Between list items
VStack(spacing: TTSize.P_CONS_DEF)

// Between sections
VStack(spacing: TTSize.P_XL)

// Button with full width
.frame(maxWidth: .infinity)
.frame(height: TTSize.H_BUTTON)
.background(TTView.buttonBgDef.toColor())
.clipShape(RoundedRectangle(cornerRadius: TTSize.CORNER_BUTTON))

// Icon + Text row
HStack(spacing: TTSize.P_CONS_DEF) {
    Image(systemName: "icon")
        .frame(width: TTSize.H_SMALL_ICON, height: TTSize.H_SMALL_ICON)
    Text("Label")
        .font(.system(size: TTFont.TITLE_H))
}

// Tappable card
Button { action() } label: {
    content
}
.padding(TTSize.P_CONS_DEF)
.background(TTView.viewBgCellColor.toColor())
.clipShape(RoundedRectangle(cornerRadius: TTSize.CORNER_PANEL))
.shadow(color: .black.opacity(0.14), radius: 8, x: 0, y: 4)
.buttonStyle(.plain)
```

## iOS 14+ Color Conversion

```swift
// UIColor from TTBaseUIKit → SwiftUI Color
UIColor(TTBaseUIKitConfig.getViewConfig().buttonBgDef).toColor()

// Or via accessor
TTView.buttonBgDef.toColor()

// Static Color extension
Color.fromHex(value: "1C82AD")
```

## IMPORTANT: Non-Existent Tokens

The following tokens DO NOT exist in TTBaseUIKit — do NOT use them:

```swift
// ❌ These do NOT exist:
TTView.colorSuccess    // → Use TTView.notificationBgSuccess
TTView.colorWarning    // → Use TTView.notificationBgWarning
TTView.colorError      // → Use TTView.notificationBgError
TTView.colorInfo       // → Use TTView.viewBgLoadingColor or TTView.refreshViewColor
TTView.buttonBgHighlight
TTView.buttonBgWarring
TTView.buttonBgDisable
TTView.textThirdTitleColor
TTView.viewBgSecondaryColor
TTView.separatorColor
TTView.iconPrimaryColor
TTView.iconSecondaryColor
TTSize.P_XXL
TTSize.SIZE_SUPER_HEADER
TTSize.SIZE_HEADER
TTSize.SIZE_TITLE
TTSize.SIZE_CONTENT
TTSize.SIZE_SUBTITLE
TTSize.SIZE_NOTE
TTSize.ICON_SIZE_SMALL
TTSize.ICON_SIZE_DEFAULT
TTSize.ICON_SIZE_LARGE
TTSize.H_TAB
TTSize.W_BUTTON
XView   // Not an accessor
XSize   // Not an accessor
XFont   // Not an accessor
```
