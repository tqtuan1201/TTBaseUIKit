---
description: "Scaffold a reusable TTBaseSUI view component. iOS 14+."
---

# ttb-skill-sui-view — TTBaseSUI View Builder

Build a reusable SwiftUI view using TTBaseSUI* wrapper components.

> Use this for reusable components (cards, rows, buttons, headers, badges, cells).
> For complex custom layouts, animations, charts — use `/ttb-native-view` instead.

## When

User says: "ttbasesui view", "swiftui component", "reusable view", "card view", "row view", "badge view"

## Tappable Card Pattern (Chainable)

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  CustomViews/{Name}CardView.swift
//  {AppName}
//

import SwiftUI
import TTBaseUIKit

// MARK: - {Name}CardView
struct {Name}CardView: View {

    let title: String
    let subtitle: String
    var onTap: (() -> Void)?

    var body: some View {
        TTBaseSUIHStack(alignment: .center, spacing: TTSize.P_CONS_DEF) {
            TTBaseSUIImage(withname: "icon_placeholder", conner: TTSize.CORNER_RADIUS)
                .sizeSquare(width: 50)

            TTBaseSUIVStack(alignment: .leading, spacing: TTSize.P_XS) {
                TTBaseSUIText(withBold: .TITLE, text: title,
                              align: .leading, color: TTView.textDefColor.toColor())
                TTBaseSUIText(withType: .SUB_TITLE, text: subtitle, align: .leading)
            }
            .maxWidth(alignment: .leading)

            TTBaseSUISpacer()

            TTBaseSUIImage(withname: "chevron.right",
                           color: TTView.textSubTitleColor.toColor(),
                           contentMode: .fit)
                .sizeSquare(width: 16)
        }
        .pAll(TTSize.P_CONS_DEF)
        .bg(byDef: TTView.viewBgCellColor.toColor())
        .corner(byDef: TTSize.CORNER_PANEL)
        .baseShadow()
        .onTapHandle { onTap?() }
    }
}
```

## Static Display Pattern (Chainable)

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  CustomViews/{Name}InfoView.swift
//  {AppName}
//

import SwiftUI
import TTBaseUIKit

// MARK: - {Name}InfoView
struct {Name}InfoView: View {

    let title: String
    let subtitle: String

    var body: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: TTSize.P_S) {
            TTBaseSUIText(withBold: .TITLE, text: title,
                          align: .leading, color: TTView.textDefColor.toColor())
            TTBaseSUIText(withType: .SUB_TITLE, text: subtitle, align: .leading)
        }
        .pAll(TTSize.P_CONS_DEF)
        .bg(byDef: TTView.viewBgCellColor.toColor())
        .corner(byDef: TTSize.CORNER_PANEL)
    }
}
```

## Action Button Row Pattern

```swift
// MARK: - ActionRowView
struct ActionRowView: View {
    let icon: String
    let title: String
    var badge: String?
    var onTap: (() -> Void)?

    var body: some View {
        TTBaseSUIHStack(alignment: .center, spacing: TTSize.P_CONS_DEF) {
            TTBaseSUIImage(withname: icon, conner: TTSize.CORNER_RADIUS)
                .sizeSquare(width: TTSize.H_SMALL_ICON)

            TTBaseSUIText(withBold: .TITLE, text: title, align: .leading, color: TTView.textDefColor.toColor())
                .maxWidth(alignment: .leading)

            TTBaseSUISpacer()

            if let badge = badge, !badge.isEmpty {
                TTBaseSUIText(withType: .SUB_SUB_TILE, text: badge, align: .center, color: .white)
                    .pVertical(TTSize.P_XS)
                    .pHorizontal(TTSize.P_S)
                    .bg(byDef: TTView.buttonBgWar.toColor())
                    .corner(byDef: TTSize.P_S)
            }

            TTBaseSUIImage(withSystemName: "chevron.right", iconColor: TTView.textSubTitleColor.toColor(), contentMode: .fit)
                .sizeSquare(width: 14)
        }
        .pAll(TTSize.P_CONS_DEF)
        .bg(byDef: TTView.viewBgCellColor.toColor())
        .onTapHandle { onTap?() }
    }
}
```

## Product/Card Grid Item Pattern

```swift
// MARK: - ProductCardView
struct ProductCardView: View {
    let product: ProductItemModel

    var body: some View {
        TTBaseSUIZStack(alignment: .topLeading) {
            TTBaseSUIVStack(alignment: .leading, spacing: TTSize.P_XS) {
                TTBaseSUIZStack(alignment: .topLeading) {
                    TTBaseSUIImage(withname: product.avatarUrl ?? "", contentMode: .fill)
                        .frame(height: 120)
                }
                discountBadge
                productName
                productPrice
                TTBaseSUISpacer(maxWidth: 1).bg(byDef: .clear)
            }
        }
    }

    private var discountBadge: some View {
        let discountText = product.getDiscountToDisplay()
        if !discountText.isEmpty {
            TTBaseSUIText(withType: .SUB_SUB_TILE, text: discountText, align: .center, color: .white)
                .pVertical(TTSize.P_XS)
                .pHorizontal(TTSize.P_S)
                .bg(byDef: .red)
                .corner(byDef: TTSize.P_S)
                .pTop(TTSize.P_XS)
        }
    }

    private var productName: some View {
        TTBaseSUIText(withBold: .TITLE, text: product.productName ?? "", align: .leading, color: TTView.textDefColor.toColor())
            .lineLimit(2)
    }

    private var productPrice: some View {
        TTBaseSUIText(withBold: .TITLE, text: product.getMinPriceTDL(), align: .leading, color: TTView.textWarringColor.toColor())
    }
}
```

## Empty State Pattern

```swift
// MARK: - EmptyStateView
struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    var buttonTitle: String?
    var onButtonTap: (() -> Void)?

    var body: some View {
        TTBaseSUIVStack(alignment: .center, spacing: TTSize.P_CONS_DEF) {
            TTBaseSUIImage(withSystemName: icon, iconColor: TTView.iconColor.toColor().opacity(0.7), contentMode: .fit)
                .sizeSquare(width: 80)
                .pTop(TTSize.P_L * 5)

            TTBaseSUIText(withBold: .TITLE, text: title, align: .center, color: TTView.textDefColor.toColor())
            TTBaseSUIText(withType: .SUB_TITLE, text: subtitle, align: .center, color: TTView.textDefColor.toColor().opacity(0.7))
                .lineLimit(4)

            if let buttonTitle = buttonTitle {
                TTBaseSUIButton(type: .DEFAULT, title: buttonTitle)
                    .pTop(TTSize.P_CONS_DEF)
            }

            TTBaseSUISpacer()
        }
        .maxWidth().maxHeight()
        .bg(byDef: TTView.viewBgColor.toColor())
        .corner()
        .pAll(TTSize.P_L * 2)
    }
}
```

## Badge/Tag Pattern

```swift
// MARK: - BadgeView
struct BadgeView: View {
    let text: String
    let bgColor: Color

    var body: some View {
        TTBaseSUIText(withType: .SUB_SUB_TILE, text: text, align: .center, color: .white)
            .pVertical(TTSize.P_XS)
            .pHorizontal(TTSize.P_S)
            .bg(byDef: bgColor)
            .corner(byDef: TTSize.P_S)
            .accessibilityElement(children: .combine)
            .accessibilityLabel(text)
    }
}

// MARK: - BestsellerBadge
struct BestsellerBadge: View {
    var text: String = XText("App.Product.Badge.BestSeller")

    var body: some View {
        TTBaseSUIText(withType: .SUB_SUB_TILE, text: text, align: .center, color: .white)
            .pVertical(TTSize.P_XS)
            .pHorizontal(TTSize.P_S)
            .bg(byDef: TTView.buttonBgDef.toColor())
            .corner(byDef: TTSize.P_S)
            .accessibilityElement(children: .combine)
            .accessibilityLabel(text)
    }
}
```

## TTBaseSUI Component Reference

### Text
```swift
TTBaseSUIText(withType: .HEADER_SUPER, text: "...", align: .center)
TTBaseSUIText(withType: .HEADER, text: "...", align: .left)
TTBaseSUIText(withType: .TITLE, text: "...", align: .left)
TTBaseSUIText(withType: .SUB_TITLE, text: "...", align: .left)
TTBaseSUIText(withType: .SUB_SUB_TILE, text: "...", align: .left)
TTBaseSUIText(withBold: .HEADER, text: "...", align: .center, color: .white)
TTBaseSUIText(withBold: .TITLE, text: "...", align: .leading, color: TTView.textDefColor.toColor())
```

### Button
```swift
TTBaseSUIButton(type: .DEFAULT, title: "CONFIRM")
TTBaseSUIButton(type: .DEFAULT_COLOR(color: .systemBlue, textColor: .white), title: "CUSTOM")
TTBaseSUIButton(type: .WARRING, title: "DELETE")
TTBaseSUIButton(type: .DISABLE, title: "DISABLED")
TTBaseSUIButton(type: .NO_BG_COLOR, title: "LINK")
TTBaseSUIButton(type: .BORDER, title: "OUTLINE")
```

### Stacks
```swift
TTBaseSUIVStack(alignment: .center, spacing: TTSize.P_CONS_DEF) { }
TTBaseSUIVStack(alignment: .center, spacing: TTSize.P_CONS_DEF, bg: .clear) { }
TTBaseSUIVStack(alignment: .center, spacing: TTSize.P_CONS_DEF, bg: .clear, radius: 8) { }
TTBaseSUIHStack(alignment: .center, spacing: TTSize.P_CONS_DEF) { }
TTBaseSUIZStack(alignment: .center, bg: .clear) { }
```

### Images
```swift
TTBaseSUIImage(withname: "icon_name")
TTBaseSUIImage(withname: "icon_name", conner: TTSize.CORNER_RADIUS)
TTBaseSUIImage(withSystemName: "star.fill", iconColor: .orange, contentMode: .fit)
TTBaseSUICircleImage(withname: "avatar")
TTBaseSUIAsyncImage(urlString: product.avatarUrl)
TTBaseSUIAsyncImage(urlString: product.avatarUrl, type: .CIRCLE)
    .sizeSquare(width: 60)
```

### Dividers
```swift
TTBaseSUIHorizontalDividerView(noConner: .LINE)
TTBaseSUIHorizontalDividerView(noConner: .SPACE)
TTBaseSUIVerticalDividerView(noConner: .LINE)
```

### Spacer
```swift
TTBaseSUISpacer()
TTBaseSUISpacer(maxHeight: 20)
TTBaseSUISpacer(maxWidth: 50)
TTBaseSUISpacer(withBg: .green, radius: 8)
```

### Form
```swift
TTBaseSUITextField(placeholder: "Search...", text: $searchText, type: .SEARCH)
TTBaseSUIToggle(label: "Enable", isOn: $isEnabled)
TTBaseSUISlider(value: $volume)
```

## Modifier Reference (Chainable Extensions)

```swift
// TTBaseUIKit chainable extensions (preferred in modifier chains)
.pAll(TTSize.P_CONS_DEF)                        // all sides padding
.pHorizontal(TTSize.P_CONS_DEF)                   // horizontal only
.pVertical(TTSize.P_CONS_DEF)                     // vertical only
.pTop(TTSize.P_CONS_DEF)                       // top only
.pBottom(TTSize.P_CONS_DEF)                    // bottom only
.pLeading(TTSize.P_CONS_DEF)                  // leading only
.pTrailing(TTSize.P_CONS_DEF)                 // trailing only
.bg(byDef: TTView.viewBgCellColor.toColor())   // background
.corner(byDef: TTSize.CORNER_PANEL)          // corner radius
.baseShadow()                                  // card shadow
.baseBorder(color: TTView.lineDefColor.toColor(), width: TTSize.H_LINEVIEW, radius: TTSize.CORNER_RADIUS)
.skeleton(active: isLoading)                    // shimmer loading
.onTapHandle { action() }                      // tap gesture
.sizeSquare(width: 50)                        // square frame
.hidden(someCondition)                        // conditional hide
.maxWidth()                                  // fill width
.maxWidth(alignment: .leading)                // fill width, left align
.maxHeight()                                 // fill height
.lineLimit(2)                                // line limit on text
.accessibilityLabel("...")                   // accessibility
.accessibilityElement(children: .combine)    // combine children
```

## Rules

1. **iOS 14+ ONLY** — no iOS 15+/16+/17+ APIs
2. **TTBaseSUI components** — no native `Text`, `Button`, `VStack`, `HStack`, `ZStack`
3. **Data via `let` properties**, callbacks via `var` closures
4. **TTView/TTSize/TTFont tokens** — never hardcode colors/sizes
5. **Card chain**: `.pAll()` → `.bg()` → `.corner()` → `.baseShadow()`
6. **PreviewProvider** at bottom, NOT `#Preview`
7. Place **screen-specific** views in `{Feature}/CustomViews/`
8. Place **shared** views in `SharedViews/` or top-level `CustomViews/`
9. Each view in its **own file**
10. **Accessibility** — `.accessibilityLabel()` on all interactive views

## Post-Implementation Verification (MANDATORY)

After all files are generated, **run Phase 6 verification**:

1. **Add files to Xcode project** — ensure each `.swift` is registered in `project.pbxproj`
2. **Run verification**:
   ```bash
   bash ttb-skill-shared/scripts/ttb-verify.sh
   ```
3. **Check compliance**:
   ```bash
   bash ttb-skill-shared/scripts/ttb-compliance-check.sh
   ```
4. **Skill is complete only when** `BUILD SUCCEEDED`

**Anti-Loop**: Max 3 build attempts. 3 failures — STOP, document errors.

For full FCR 7-Dimension scoring, see `ttb-skill-shared/phases/ttb-phase-verify.md`.
