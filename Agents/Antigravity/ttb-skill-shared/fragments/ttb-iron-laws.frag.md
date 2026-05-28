---
name: "ttb-iron-laws"
description: "Code fragment — inject the 11 mandatory Iron Laws for TTBaseUIKit development."
version: "2.0.0"
---

# 11 Iron Laws — Single Source of Truth

> **MANDATORY** — These laws apply to ALL TTBaseUIKit skill workflows.
> Load this fragment once per session. Do not duplicate.

1. **iOS 14+ ONLY** — never use iOS 15+/16+/17+ APIs without `@available`
2. **TTBaseUIKit COMPONENTS** — never use raw UIKit when TTBaseUIKit exists
3. **TTViewCodable MVVM** — UIKit views must use TTViewCodable protocol
4. **TTBaseSUI FOR SWIFTUI** — use TTBaseSUI* wrappers for SwiftUI
5. **SUIBaseView WRAPPER** — every SwiftUI screen must use `SUIBaseView`
6. **TTBaseNavigationLink** — every navigation between screens uses `TTBaseNavigationLink`
7. **MVVM SEPARATION** — ViewModel never imports UIKit/SwiftUI
8. **xcodebuild CLI IS LAW** — use `xcodebuild` command, not Cmd+B
9. **ZERO REGRESSION** — every change verified against existing code
10. **ANTI-LOOP: MAX 3 ROUNDS** — 3 build failures → stop, document errors
11. **POST-BUILD VERIFICATION IS MANDATORY** — after every skill workflow: `BUILD SUCCEEDED`

---

## iOS 14+ API Quick Reference

| Never (iOS 15+) | Use Instead (iOS 14+) |
|---|---|
| `.task { }` | `.onAppear { Task { } }` |
| `NavigationStack` | `SUIBaseView` |
| `#Preview { }` | `PreviewProvider` |
| `.foregroundStyle()` | `.foregroundColor()` |
| `@Observable` | `ObservableObject` + `@Published` |
| `.clipShape(.rect())` | `.clipShape(RoundedRectangle())` |

---

## SUIBaseView + TTBaseNavigationLink (Laws #5-#6)

Every SwiftUI screen **MUST** use `SUIBaseView` as the root wrapper.
Every navigation between screens **MUST** use `TTBaseNavigationLink`.

```swift
// Every SwiftUI screen — Law #5
struct HomeScreen: View {
    var body: some View {
        SUIBaseView(
            backType: .SWIFTUI,
            title: XText("App.Home.Title"),
            type: .DEFAULT,
            isHiddenTabbar: true,
            backAction: {}
        ) {
            // Content here
        }
    }
}

// Navigation between screens — Law #6
TTBaseNavigationLink(destination: {
    DetailScreen(viewModel: vm)
}, label: {
    ItemRow(item: item)
}, isAnimation: true)
```

---

## Closure Safety

Every closure **must** use `[weak self]` + `guard let self = self`:

```swift
// ✅ CORRECT
viewModel.onSuccess = { [weak self] in
    guard let self = self else { return }
    self.pop()
}

// ❌ WRONG
viewModel.onSuccess = { self.pop() }  // RETAIN CYCLE
```

---

## MVVM Separation

ViewModel **never** imports UIKit or SwiftUI:

```swift
// ✅ CORRECT — ViewModel imports only Foundation
import Foundation

// ❌ WRONG — ViewModel importing UIKit
import UIKit  // ❌ NEVER in ViewModel
```

---

## Critical Token Warnings

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
| `TTSize.P_XXL` | `TTSize.P_CONS_DEF * 4` (32pt) |
| `TTSize.SIZE_SUPER_HEADER` | `TTFont.HEADER_SUPER_H` |
