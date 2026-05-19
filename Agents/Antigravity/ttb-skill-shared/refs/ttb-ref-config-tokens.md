---
name: "ttb-ref-config-tokens"
description: "Quick reference for TTBaseUIKit design tokens: TTView/TTSize/TTFont colors, sizes, fonts, and common calculations."
version: "2.0.0"
---

# ttb-ref-config-tokens — Config Tokens Reference

Design tokens for consistent styling across TTBaseUIKit apps.

## Accessors

```swift
// Global shortcuts (defined in GlobalFunctions.swift)
TTView  // = TTBaseUIKitConfig.getViewConfig()
TTSize  // = TTBaseUIKitConfig.getSizeConfig()
TTFont  // = TTBaseUIKitConfig.getFontConfig()
TTStyle // = TTBaseUIKitConfig.getStyleConfig()
TTParam // = TTBaseUIKitConfig.getParamConfig()

// Direct access
TTBaseUIKitConfig.getViewConfig()
TTBaseUIKitConfig.getSizeConfig()
TTBaseUIKitConfig.getFontConfig()
```

## ⚠️ CRITICAL: Token Names

**Always use `TTView`, `TTSize`, `TTFont`** — never `XView`, `XSize`, `XFont`.

The following **DO NOT EXIST** in TTBaseUIKit:

| ❌ DO NOT USE | ✅ USE INSTEAD |
|--------------|----------------|
| `XView` | `TTView` |
| `XSize` | `TTSize` |
| `XFont` | `TTFont` |
| `TTView.colorSuccess` | `TTView.notificationBgSuccess` |
| `TTView.colorWarning` | `TTView.notificationBgWarning` |
| `TTView.colorError` | `TTView.notificationBgError` |
| `TTView.buttonBgHighlight` | Calculate manually |
| `TTView.buttonBgWarring` | `TTView.buttonBgWar` |
| `TTView.buttonBgDisable` | `TTView.buttonBgDis` |
| `TTView.textThirdTitleColor` | `TTView.textSubTitleColor` |
| `TTView.viewBgSecondaryColor` | `TTView.viewBgColor` |
| `TTView.separatorColor` | `TTView.lineDefColor` |
| `TTView.iconPrimaryColor` | `TTView.iconColor` |
| `TTView.iconSecondaryColor` | `TTView.iconColor` |
| `TTSize.P_XXL` | `TTSize.P_CONS_DEF * 4` (32pt) |
| `TTFont.SIZE_SUPER_HEADER` | `TTFont.HEADER_SUPER_H` |
| `TTFont.SIZE_HEADER` | `TTFont.HEADER_H` |
| `TTFont.SIZE_TITLE` | `TTFont.TITLE_H` |
| `TTFont.SIZE_CONTENT` | `TTFont.SUB_TITLE_H` |
| `TTFont.SIZE_SUBTITLE` | `TTFont.SUB_TITLE_H` |
| `TTFont.SIZE_NOTE` | `TTFont.SUB_SUB_TITLE_H` |
| `TTSize.ICON_SIZE_SMALL` | `TTSize.H_SMALL_SMALL_ICON` |
| `TTSize.ICON_SIZE_DEFAULT` | `TTSize.H_ICON` |
| `TTSize.ICON_SIZE_LARGE` | `TTSize.H_ICON_CELL` |
| `TTSize.H_TAB` | Use UIKit tabBarController.tabBar.bounds.height |
| `TTSize.W_BUTTON` | `TTSize.W / 2` |

## Color Tokens (UIColor)

### View Colors
```swift
TTView.viewBgColor            // Main background (#DBDBDB)
TTView.viewDefColor          // Default white (#FFFFFF)
TTView.viewBgCellColor       // Card / cell background (#FFFFFF)
TTView.viewBgNavColor        // Nav bar background (#00A79E)
TTView.viewBgLoadingColor     // Loading spinner background (#1C82AD)
TTView.viewDisableColor       // Disabled background (#c5c5c5)
TTView.lineDefColor          // Separator / divider lines (#e5e5e5)
TTView.lineActiveColor       // Active line color (#C41F53)
```

### Text Colors
```swift
TTView.textHeaderColor        // Headers / titles (#3c3c3c)
TTView.textDefColor          // Default body text (#555555)
TTView.textSubTitleColor     // Subtitles / captions (#555555)
TTView.textTitleColor        // Title text (#555555)
TTView.textWarringColor      // Warning text (#C41F53)
```

### Button Colors
```swift
TTView.buttonBgDef           // Default button background (#1C82AD)
TTView.buttonBgWar           // Warning / destructive button (#C41F53)
TTView.buttonBgDis           // Disabled button background (#454545)
TTView.buttonBorderColor     // Button border (#e5e5e5)
```

### Label Colors
```swift
TTView.labelBgDef            // Label default background (#1C82AD)
TTView.labelBgWar             // Label warning background (#C41F53)
TTView.labelBgDis            // Label disabled background (#454545)
```

### Notification / Status Colors
```swift
TTView.notificationBgSuccess  // Success notification bg (#0077ab)
TTView.notificationBgWarning  // Warning notification bg (#cc9a05)
TTView.notificationBgError   // Error notification bg (#b22a37)
```

### Icon Colors
```swift
TTView.iconColor             // Default icon color (#777777)
TTView.iconRightTextFieldColor // Right icon in textfield (#777777)
```

## SwiftUI Color Conversion

```swift
// Convert UIColor token to SwiftUI Color
TTView.textDefColor.toColor()
TTView.viewBgColor.toColor()
TTView.buttonBgDef.toColor()
TTView.iconColor.toColor()

// Static hex converter
Color.fromHex(value: "1C82AD")
```

## Size Tokens (CGFloat)

### Padding / Spacing
```swift
TTSize.P_CONS_DEF    // Default padding: 8pt
TTSize.P_XS          // Extra small: 4pt (P_CONS_DEF / 2)
TTSize.P_S           // Small: 8pt (P_CONS_DEF)
TTSize.P_M           // Medium: 12pt (P_CONS_DEF * 1.5)
TTSize.P_L           // Large: 16pt (P_CONS_DEF * 2)
TTSize.P_XL          // Extra large: 20pt (P_CONS_DEF * 2.5)

TTSize.getPadding()       // = P_CONS_DEF * 2 = 16pt
TTSize.getPaddingDef()    // = P_CONS_DEF * 2 = 16pt
TTSize.getPaddingView()   // = P = W / 50

// Common calculations
TTSize.P_CONS_DEF * 2     // 16 — double padding
TTSize.P_CONS_DEF / 2     // 4  — half padding
TTSize.P_CONS_DEF * 3     // 24 — triple padding (section gap)
TTSize.P_CONS_DEF * 4     // 32 — quadruple padding (= P_XXL)
```

### Corner Radius
```swift
TTSize.CORNER_RADIUS   // Default corner: 4pt
TTSize.CORNER_BUTTON   // Button corner: 4pt
TTSize.CORNER_PANEL    // Card / panel corner: 8pt
TTSize.CORNER_IMAGE    // Avatar / image corner: 20pt
```

### Heights
```swift
TTSize.H_BUTTON        // Button height: 40pt
TTSize.H_TEXTFIELD     // TextField height: 35pt
TTSize.H_CELL         // Table cell height (calculated)
TTSize.H_NAV          // Navigation bar height: 45pt
TTSize.H_ICON         // Default icon: 40pt
TTSize.H_SMALL_ICON   // Small icon: 30pt
TTSize.H_SMALL_SMALL_ICON // Tiny icon: 14pt
TTSize.H_SMALL_TINY_ICON  // Very tiny icon: 9pt
TTSize.H_ICON_CELL    // Cell icon: 56pt
TTSize.H_LINEVIEW     // Divider thickness: 1.5pt
TTSize.H_SEG          // Segment height: 40pt
TTSize.H_PROCESS_VIEW // Progress bar height: 6pt
TTSize.H_LOADING_CENTER // Loading indicator: 70pt (40pt on small screens)
TTSize.H_STATUS       // Status bar height (dynamic)
```

### Screen Dimensions
```swift
TTSize.W    // Screen width
TTSize.H    // Screen height
TTSize.P    // Padding based on screen width (W / 50)
```

### Screen-safe Heights
```swift
TTSize.H_BOTTOM_SAFE_AREA_INSET  // Safe area bottom inset
TTSize.getBottomSafeArea()       // Safe area bottom (min H_BUTTON * 4)
```

## Font Tokens (CGFloat)

### TTFont Label Types
```swift
TTFont.HEADER_SUPER_H  // 24pt — super header / hero text
TTFont.HEADER_H        // ~16pt — header font size
TTFont.TITLE_H         // ~14pt — title font size
TTFont.SUB_TITLE_H     // ~12pt — subtitle / caption
TTFont.SUB_SUB_TITLE_H // ~10pt — smallest label

// Methods
TTFont.getHeaderSize()     // → HEADER_H
TTFont.getTitleSize()     // → TITLE_H
TTFont.getSubTitleSize()  // → SUB_TITLE_H
TTFont.getSubSubTitleSize() // → SUB_SUB_TITLE_H
TTFont.getFont()          // → UIFont system font
```

### TTBaseUILabel TYPE enum
```swift
TTBaseUILabel(withType: .HEADER_SUPER, ...)  // HEADER_SUPER
TTBaseUILabel(withType: .HEADER, ...)       // HEADER
TTBaseUILabel(withType: .TITLE, ...)        // TITLE
TTBaseUILabel(withType: .SUB_TITLE, ...)    // SUB_TITLE
TTBaseUILabel(withType: .SUB_SUB_TILE, ...) // SUB_SUB_TILE
TTBaseUILabel(withType: .NONE, ...)        // Custom
```

## Quick Reference Table

| Category | Token | Value | Usage |
|----------|-------|-------|-------|
| Padding | `TTSize.P_CONS_DEF` | 8pt | Default spacing |
| Padding | `TTSize.P_L` | 16pt | Large spacing |
| Padding | `TTSize.P_XL` | 20pt | Extra large spacing |
| Spacing | `TTSize.P_XS` | 4pt | Small spacing |
| Corner | `TTSize.CORNER_RADIUS` | 4pt | Default radius |
| Corner | `TTSize.CORNER_PANEL` | 8pt | Card radius |
| Button H | `TTSize.H_BUTTON` | 40pt | Button height |
| Text | `TTFont.HEADER_H` | ~16pt | Header font |
| Text | `TTFont.TITLE_H` | ~14pt | Title font |
| Text | `TTFont.SUB_TITLE_H` | ~12pt | Subtitle font |
| Color | `TTView.viewBgColor` | — | Background |
| Color | `TTView.textDefColor` | — | Body text |
| Color | `TTView.buttonBgDef` | — | Button bg |

## Common Calculations

```swift
// Double padding (screen edge)
TTSize.P_CONS_DEF * 2         // 16pt

// Card padding
TTSize.P_CONS_DEF              // 8pt

// Screen edge padding
TTSize.P_CONS_DEF * 2          // 16pt

// List item spacing
TTSize.P_CONS_DEF              // 8pt

// Section spacing
TTSize.P_CONS_DEF * 3          // 24pt
```

---

**Version**: 2.0.0 | **Date**: 2026-05-19
**Changelog**: v2.0.0 — Added critical token warnings table at top. Added P_CONS_DEF * 4 calculation. Fixed all non-existent token references. Version bumped.
