---
description: "Scaffold a TTBaseSUI SwiftUI screen using SUIBaseView navigation wrapper and TTBaseNavigationLink. iOS 14+."
---

# ttb-skill-sui-screen — TTBaseSUI Screen Builder

Build a SwiftUI screen using TTBaseSUI components, `SUIBaseView` navigation wrapper, and `TTBaseNavigationLink` for navigation.

## When

User says: "swiftui screen", "build swiftui", "màn hình swiftui", "ttbasesui screen", "navigation screen"

## Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  {Name}Screen.swift
//  {AppName}
//

import SwiftUI
import TTBaseUIKit

// MARK: - {Name}Screen
struct {Name}Screen: View {

    @StateObject private var vm = {Name}ViewModel()

    var body: some View {
        SUIBaseView(
            backType: .SWIFTUI,
            title: XText("App.{Name}.Nav.Title"),
            type: .DEFAULT,
            isHiddenTabbar: true,
            backAction: {}
        ) {
            TTBaseSUIVStack(alignment: .center, spacing: XSize.P_XS, bg: XView.viewBgColor.toColor()) {
                headerSection
                if vm.isEmpty {
                    emptyView
                } else {
                    contentSection
                }
            }
        }
        .onAppear { vm.fetchData() }
    }
}

// MARK: - Subviews
private extension {Name}Screen {

    private var headerSection: some View {
        TTBaseSUIHStack(alignment: .center, spacing: XSize.P_CONS_DEF) {
            TTBaseSUIText(withBold: .HEADER, text: XText("App.{Name}.Header"), align: .leading, color: XView.textDefColor.toColor())
            TTBaseSUISpacer()
        }
        .pHorizontal(XSize.P_CONS_DEF)
        .pTop(XSize.P_CONS_DEF)
    }

    private var emptyView: some View {
        TTBaseSUIVStack(alignment: .center, spacing: XSize.P_CONS_DEF) {
            TTBaseSUIImage(withSystemName: "tray", iconColor: XView.iconColor.toColor(), contentMode: .fit)
                .sizeSquare(width: 80)
            TTBaseSUIText(withBold: .TITLE, text: XText("App.{Name}.Empty.Title"), align: .center, color: XView.textDefColor.toColor())
            TTBaseSUIText(withType: .SUB_TITLE, text: XText("App.{Name}.Empty.Subtitle"), align: .center, color: XView.textSubTitleColor.toColor())
        }
        .maxWidth().maxHeight()
        .bg(byDef: XView.viewBgColor.toColor())
        .corner()
        .pAll(XSize.P_L * 2)
    }

    private var contentSection: some View {
        TTBaseSUIScroll(alignment: .vertical, bg: .clear) {
            TTBaseSUIVStack(alignment: .center, spacing: XSize.P_CONS_DEF) {
                // Items go here
            }
            .pAll(XSize.P_CONS_DEF)
            .pBottom(XSize.H_BUTTON)
        }
        .skeleton(active: vm.isLoading)
        .maxHeight()
        .pBottom(XSize.P_CONS_DEF)
    }
}

// MARK: - Preview
struct {Name}Screen_Previews: PreviewProvider {
    static var previews: some View {
        {Name}Screen()
    }
}
```

## Navigation Pattern

Every screen that navigates to another screen MUST use `TTBaseNavigationLink`.

### Simple Navigation

```swift
private var itemsList: some View {
    TTBaseSUIScroll(alignment: .vertical) {
        TTBaseSUILazyVStack(alignment: .center, spacing: XSize.P_CONS_DEF) {
            ForEach(vm.items) { item in
                TTBaseNavigationLink(destination: {
                    {Name}DetailScreen(item: item)
                }, label: {
                    {Name}ItemView(item: item)
                        .pAll(XSize.P_CONS_DEF)
                        .bg(byDef: XView.viewBgCellColor.toColor())
                        .corner(byDef: XSize.CORNER_PANEL)
                        .baseShadow()
                })
            }
        }
        .pAll(XSize.P_CONS_DEF)
        .pBottom(XSize.H_BUTTON)
    }
    .skeleton(active: vm.isLoading)
    .maxHeight()
}
```

### Navigation with Active Binding

```swift
@State private var isShowingDetail = false

TTBaseNavigationLink(
    isActive: $isShowingDetail,
    destination: { DetailScreen(item: item) },
    label: { ItemRow(item: item) }
)
```

### Navigation without Animation

```swift
TTBaseNavigationLink(destination: {
    HeavyDetailScreen(item: item)
}, label: {
    ItemRow(item: item)
}, isAnimation: false)
```

## SUIBaseView Parameters

```swift
SUIBaseView(
    backType: .SWIFTUI,              // .SWIFTUI | .POP | .POP_TO_ROOT | .DISMISS | .DISMISS_ALL | .CLOSE_FLOW
    title: XText("App.Module.Nav.Title"),
    type: .DEFAULT,                 // .DEFAULT | .INFO | .NO_NAV
    isHiddenTabbar: true,
    backAction: { /* optional custom back handling */ },
    titleAction: { /* optional title tap */ },
    rightAction: { /* optional right bar button */ },
    bg: XView.viewBgColor.toColor(),
    @ViewBuilder content: () -> Content
)
```

## TTBaseNavigationLink Parameters

```swift
TTBaseNavigationLink(
    destination: { DestinationScreen() },   // required closure
    label: { LabelView() },                // required closure
    isForceBarHidden: Bool = true,         // hide nav bar in destination
    isAnimation: Bool = true               // enable/disable push animation
)

TTBaseNavigationLink(
    isActive: Binding<Bool>,              // for programmatic control
    destination: { DestinationScreen() },
    label: { LabelView() },
    isForceBarHidden: Bool = true,
    isAnimation: Bool = true
)
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

### Scroll
```swift
TTBaseSUIScroll { }
TTBaseSUIScroll(alignment: .vertical, bg: .clear, isEnablePullToRefresh: true) {
    // content
} pullToRefresh: {
    vm.fetch()
}
TTBaseSUILazyVStack(alignment: .center, spacing: TTSize.P_CONS_DEF, bg: .clear) { }
```

### Other
```swift
TTBaseSUISpacer()
TTBaseSUISpacer(maxHeight: 20)
TTBaseSUIImage(withname: "icon", conner: TTSize.CORNER_RADIUS)
TTBaseSUIImage(withSystemName: "star.fill", iconColor: .orange, contentMode: .fit)
TTBaseSUICircleImage(withname: "avatar")
TTBaseSUIHorizontalDividerView(noConner: .LINE)
TTBaseSUIHorizontalDividerView(noConner: .SPACE)
TTBaseSUIVerticalDividerView(noConner: .LINE)
```

### Form
```swift
TTBaseSUITextField(placeholder: "Search...", text: $searchText, type: .SEARCH)
TTBaseSUITextField(placeholder: "Password", text: $password, isSecure: true)
TTBaseSUIToggle(label: "Enable", isOn: $isEnabled)
TTBaseSUIToggle(label: "Mode", isOn: $isOn, type: .ICON(name: "moon.fill"))
TTBaseSUISlider(value: $volume)
TTBaseSUISlider(value: $val, in: 0...1, type: .WITH_LABELS(min: "0%", max: "100%"))
```

### List
```swift
TTBaseSUIList(type: .PLAIN) { ForEach(items) { ItemRow($0) } }
TTBaseSUIList(type: .GROUPED, isEnablePullToRefresh: true) { ... } pullToRefresh: { }
```

## Modifier Reference (Chainable Extensions + SwiftUI)

```swift
// TTBaseUIKit chainable extensions (preferred in modifier chains)
.pAll(TTSize.P_CONS_DEF)                  // all sides padding
.pHorizontal(TTSize.P_CONS_DEF)            // horizontal only
.pVertical(TTSize.P_CONS_DEF)             // vertical only
.pTop(TTSize.P_CONS_DEF)                  // top only
.pBottom(TTSize.P_CONS_DEF)               // bottom only
.pLeading(TTSize.P_CONS_DEF)              // leading only
.pTrailing(TTSize.P_CONS_DEF)             // trailing only
.bg(byDef: TTView.viewBgCellColor.toColor())  // background
.corner(byDef: TTSize.CORNER_PANEL)           // corner radius
.baseShadow()                                 // card shadow
.skeleton(active: isLoading)                   // shimmer loading
.onTapHandle { action() }                     // tap gesture
.sizeSquare(width: 50)                        // square frame
.hidden(someCondition)                      // conditional hide
.maxWidth()                                 // fill width
.maxHeight()                                // fill height
.hideKeyboardOnScroll()                     // dismiss keyboard on scroll
```

## Rules

1. **SUIBaseView wrapper** — mọi screen phải bọc trong `SUIBaseView`
2. **TTBaseNavigationLink** — dùng cho mọi navigation giữa các màn hình
3. **TTBaseSUI components** — ưu tiên `TTBaseSUI*` trước native SwiftUI
4. **iOS 14+ ONLY** — no `.task`, `NavigationStack`, `#Preview`, `.foregroundStyle()`
5. **TTView/TTSize/TTFont tokens** — không hardcoded colors/sizes
6. **XTextU("key")** cho nav titles, **XText("key")** cho content
7. **`.onAppear { }`** cho lifecycle, NOT `.task { }`
8. **@StateObject** cho owned ViewModel
9. **PreviewProvider** ở cuối file, NOT `#Preview`
10. **Extract sub-views** ra `private var` nếu body > 40 lines
11. **Chainable extensions** — ưu tiên `.pAll()`, `.bg()`, `.corner()` trong modifier chains

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
