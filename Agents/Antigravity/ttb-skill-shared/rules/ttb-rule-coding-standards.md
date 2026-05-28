---
name: "ttb-rule-coding-standards"
description: "Coding standards for TTBaseUIKit apps: file headers, import order, MARK sections, naming conventions, spacing rules, SwiftUI conventions, and navigation patterns."
version: "2.0.0"
---

# ttb-rule-coding-standards — Coding Standards

Coding standards for TTBaseUIKit apps.

## File Header

Every generated file must include:

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  {FileName}.swift
//  {AppName}
//
```

## Import Order

```swift
import SwiftUI           // SwiftUI framework
import Foundation         // Foundation
import TTBaseUIKit        // Library imports
import SnapKit            // Third-party (if used)
```

## MARK Sections

### SwiftUI View
```swift
// MARK: - Properties
// MARK: - Body
// MARK: - Subviews
// MARK: - Actions
```

### SwiftUI ViewModel
```swift
// MARK: - Published Properties
// MARK: - Init
// MARK: - Data Fetching
// MARK: - Actions
// MARK: - Helpers
```

### Model
```swift
// MARK: - Codable Keys
// MARK: - Properties
// MARK: - Methods
// MARK: - Mock Helpers
```

### UIKit ViewController
```swift
// MARK: - Properties
// MARK: - UI Components
// MARK: - Lifecycle
// MARK: - TTViewCodable
// MARK: - Actions
```

## SwiftUI View Body Limit

- View body **must not exceed 40 lines**
- Extract subviews to `private var` computed properties
- Name subviews descriptively: `cardContent`, `headerSection`, `actionButton`

### Example with SUIBaseView + TTBaseNavigationLink
```swift
var body: some View {
    SUIBaseView(
        backType: .SWIFTUI,
        title: XText("App.ProductList.Nav.Title"),
        type: .DEFAULT,
        isHiddenTabbar: true,
        backAction: {}
    ) {
        TTBaseSUIVStack(alignment: .center, spacing: TTSize.P_CONS_DEF, bg: TTView.viewBgColor.toColor()) {
            if vm.isEmpty {
                emptyView
            } else {
                productGrid
            }
        }
    }
    .onAppear { vm.fetchData() }
}

private var emptyView: some View {
    TTBaseSUIVStack(alignment: .center, spacing: TTSize.P_CONS_DEF) {
        TTBaseSUIImage(withSystemName: "tray", iconColor: TTView.iconColor.toColor(), contentMode: .fit)
            .sizeSquare(width: 80)
        TTBaseSUIText(withBold: .TITLE, text: XText("App.ProductList.Empty"), align: .center, color: TTView.textDefColor.toColor())
    }
    .maxWidth().maxHeight()
    .pAll(TTSize.P_L * 2)
}

private var productGrid: some View {
    TTBaseSUIScroll(alignment: .vertical) {
        TTBaseSUILazyVStack(alignment: .center, spacing: TTSize.P_CONS_DEF) {
            ForEach(vm.products) { product in
                TTBaseNavigationLink(destination: {
                    ProductDetailScreen(product: product)
                }, label: {
                    ProductCardView(product: product)
                        .pAll(TTSize.P_CONS_DEF)
                        .bg(byDef: TTView.viewBgCellColor.toColor())
                        .corner(byDef: TTSize.CORNER_PANEL)
                        .baseShadow()
                }, isAnimation: true)
            }
        }
        .pAll(TTSize.P_CONS_DEF)
        .pBottom(TTSize.H_BUTTON)
    }
    .skeleton(active: vm.isLoading)
    .maxHeight()
}
```

## Naming Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| ViewController | `{Name}ViewController` | `HomeViewController` |
| ViewModel | `{Name}ViewModel` | `HomeViewModel` |
| SwiftUI Screen | `{Name}Screen` | `HomeScreen` |
| SwiftUI View | `{Name}View` / `{Name}CardView` | `UserCardView` |
| SwiftUI Subview | `{Context}View` | `HeaderView`, `FooterView` |
| SwiftUI List Item | `{Name}ItemView` | `ProductItemView` |
| SwiftUI Empty State | `{Name}EmptyView` | `ProductEmptyView` |
| Coordinator | `{Name}Coordinator` | `HomeCoordinator` |
| API Service | `{Name}API` | `UserAPI` |
| RequestData | `{Name}RequestData` | `LoginRequestData` |
| Model | `{Name}Model` | `UserModel` |
| TableCell | `{Name}Cell` | `UserCell` |
| CollectionCell | `{Name}CollectionCell` | `UserCollectionCell` |
| CustomView | `{Name}View` | `BadgeView` |
| Closure property | `onEvent: (() -> Void)?` | `onSubmit: (() -> Void)?` |

## SwiftUI Navigation Conventions

### SUIBaseView Convention

```swift
SUIBaseView(
    backType: .SWIFTUI,                   // .SWIFTUI for pure SwiftUI, .POP for hybrid
    title: XText("App.Module.Nav.Title"),
    type: .DEFAULT,                        // .DEFAULT | .INFO | .NO_NAV
    isHiddenTabbar: true,                 // Hide tabbar when entering screen
    backAction: {}
) {
    // Screen content
}
```

### TTBaseNavigationLink Convention

```swift
// NavigationLink always inside Scroll/LazyVStack
TTBaseNavigationLink(destination: {
    DetailScreen(item: item)
}, label: {
    ItemCardView(item: item)
        .pAll(TTSize.P_CONS_DEF)
        .bg(byDef: TTView.viewBgCellColor.toColor())
        .corner(byDef: TTSize.CORNER_PANEL)
        .baseShadow()
}, isAnimation: true)
```

## Spacing

- Indent: 4 spaces (no tabs)
- No trailing whitespace
- One blank line between MARK sections
- Max 200 lines per file (split if longer)

## Self Usage

- Always use `self.` for instance property/method access
- Always use `self?` inside weak closures
- Omit `self.` only for disambiguating local variable from property

## Private

- All UI components: `private let`
- All computed properties: `private var` or `private(set)`
- Fileprivate for coordinator-scoped types

## Accessibility

- All user-facing strings via `XText`/`XTextU`
- No hardcoded strings in UI code
- Keys follow convention: `App.{Module}.{Screen}.{Element}`
- `.accessibilityLabel()` on all interactive views
- `.accessibilityElement(children: .combine)` for grouped accessibility

## SwiftUI Chainable Modifier Order

When chaining modifiers, follow this order:

```swift
TTBaseSUIView { ... }
    .pAll(TTSize.P_CONS_DEF)           // 1. Padding
    .bg(byDef: TTView.viewBgCellColor.toColor()) // 2. Background
    .corner(byDef: TTSize.CORNER_PANEL)           // 3. Corner radius
    .baseShadow()                      // 4. Shadow
    .onTapHandle { action() }         // 5. Interaction
    .skeleton(active: isLoading)      // 6. State
    .hidden(someCondition)            // 7. Conditional
```

## Token Usage

Always use `TTView`, `TTSize`, `TTFont` — never `XView`, `XSize`, `XFont`:

| ❌ WRONG | ✅ CORRECT |
|---------|-----------|
| `XView.textDefColor` | `TTView.textDefColor` |
| `XSize.P_CONS_DEF` | `TTSize.P_CONS_DEF` |
| `XFont.HEADER_H` | `TTFont.HEADER_H` |
| `XView.buttonBgDef.toColor()` | `TTView.buttonBgDef.toColor()` |

## ⚠️ Non-Existent APIs

The following DO NOT exist in TTBaseUIKit — do NOT use them:

```swift
// ❌ These do NOT exist:
XPrint("...")                  // → TTBaseFunc.shared.printLog(with:..., object:...)
BaseShadowPanelView()          // → TTBaseShadowPanelView()
BaseUIViewController           // → TTBaseUIViewController<TTBaseUIView>
lbl.setTextString(...)       // → lbl.setText(...)
btn.setTextString(...)       // → btn.setText(...)
navBaseStype                   // → navType
TTView.colorSuccess           // → TTView.notificationBgSuccess
TTView.colorWarning           // → TTView.notificationBgWarning
TTView.colorError             // → TTView.notificationBgError
TTView.buttonBgHighlight      // → Calculate manually
TTView.buttonBgWarring        // → TTView.buttonBgWar
TTView.buttonBgDisable         // → TTView.buttonBgDis
TTSize.P_XXL                 // → TTSize.P_CONS_DEF * 4
TTSize.SIZE_SUPER_HEADER     // → TTFont.HEADER_SUPER_H
```

---

**Version**: 2.0.0 | **Date**: 2026-05-19
**Changelog**: v2.0.0 — Added SUIBaseView naming convention. Added TTBaseNavigationLink convention. Added token usage table. Added non-existent APIs warnings. Updated example with correct TTSize/TTView. v1.4.0 — Updated SwiftUI example to use correct `.pAll(TTSize.P_CONS_DEF)` syntax. v1.3.0 — Added SwiftUI View MARK sections.
