---
name: "ttb-skill-swiftui"
description: "SwiftUI full-stack development for TTBaseUIKit apps: SUIBaseView navigation, TTBaseSUI components, chainable modifiers, Native SwiftUI fallback. iOS 14+."
version: "2.2.0"
date_updated: "2026-05-22"
risk: "safe"
source: "internal"
loadLevel: "domain"
tags: ["swiftui", "ttbasesui", "suibaseview", "navigation", "viewmodel", "native-fallback", "routing"]
---

# ttb-skill-swiftui

> SwiftUI development skill for TTBaseUIKit apps — TTBaseSUI components, MVVM, navigation, iOS 14+.
> **Rule #1: Use TTBaseSUI wherever it exists. Only fall back to Native SwiftUI when TTBaseSUI has no equivalent.**

## Tổng quan: Ba Tầng Tiếp Cận

| Tầng | Khi nào dùng | Lệnh |
|-------|--------------|------|
| **Tầng 1 — TTBaseSUI** | Mọi component TTBaseSUI đã có | `/ttb-sui-screen`, `/ttb-sui-view`, `/ttb-sui-list` |
| **Tầng 2 — SUIBaseView Navigation** | Navigation giữa các màn hình | Pattern bên dưới |
| **Tầng 3 — Native SwiftUI** | Khi TTBaseSUI không có component tương đương | `/ttb-native-screen`, `/ttb-native-view` |

## Danh sách Commands

| Command | Mô tả |
|---------|--------|
| `/ttb-sui-screen` | TTBaseSUI screen — dùng `SUIBaseView` + `TTBaseNavigationLink` |
| `/ttb-sui-view` | TTBaseSUI reusable view component |
| `/ttb-sui-list` | TTBaseSUI list screen với `TTBaseSUILazyVStack` |
| `/ttb-native-screen` | Native SwiftUI screen — chỉ khi TTBaseSUI không có |
| `/ttb-native-view` | Native SwiftUI reusable view — chỉ khi TTBaseSUI không có |
| `/ttb-sui-viewmodel` | SwiftUI ViewModel với `@Published` + `@MainActor` |

## Routing Contract

```yaml
input:
  required: [artifact_type, feature_name, state_model]
  optional: [navigation_flow, ttbase_sui_component_availability, data_source, localization_keys]
output:
  artifacts: [suibaseview_screen_or_view, ttbase_sui_components, swiftui_viewmodel_when_needed, verification_report]
  completion_gate: "SUIBaseView + TTBaseNavigationLink + iOS 14 compatibility + build verification"
confidence:
  auto_route: ">= 0.78 for SwiftUI, TTBaseSUI, SUIBaseView, SwiftUI list/view/screen/viewmodel intents"
  clarify: "0.55-0.77 when prompt says screen/view but does not say UIKit or SwiftUI"
fallback:
  default: "Prefer TTBaseSUI. Use native SwiftUI only when TTBaseSUI has no equivalent and document the gap."
```

Multilingual aliases: `SwiftUI screen`, `SUIBaseView`, `TTBaseSUI view`, `tạo màn hình SwiftUI`, `tao man hinh swiftui`, `danh sách SwiftUI`, `điều hướng SwiftUI`.

Anti-patterns: do not build full SwiftUI screens without `SUIBaseView`; do not use native SwiftUI when TTBaseSUI exists; do not navigate without `TTBaseNavigationLink`; do not use iOS 15+ APIs without `@available`.

## Tầng 1: SUIBaseView — Navigation Pattern Bắt Buộc

`SUIBaseView` là screen wrapper **duy nhất** cho TTBaseUIKit SwiftUI. Nó cung cấp navigation bar, back button, tabbar control, và `TTBaseNavigationLink` để điều hướng.

### Pattern Cơ Bản

```swift
import SwiftUI
import TTBaseUIKit

struct ProductListScreen: View {

    @StateObject private var vm = ProductViewModel()

    var body: some View {
        SUIBaseView(
            backType: .SWIFTUI,
            title: XText("App.ProductList.Nav.Title"),
            type: .DEFAULT,
            isHiddenTabbar: true,
            backAction: {}
        ) {
            TTBaseSUIVStack(alignment: .center, spacing: TTSize.P_XS, bg: TTView.viewBgColor.toColor()) {
                searchHeader
                if vm.isEmpty {
                    EmptyProductView()
                } else {
                    productGrid
                }
            }
        }
    }
}
```

### SUIBaseView Parameters

```swift
SUIBaseView(
    backType: BACK_TYPE,       // .SWIFTUI | .POP | .POP_TO_ROOT | .DISMISS | .DISMISS_ALL | .CLOSE_FLOW
    title: String,             // Navigation bar title
    type: TYPE,                // .DEFAULT | .INFO | .NO_NAV
    isHiddenTabbar: Bool,      // Ẩn/hiện tabbar khi vào màn
    backAction: (() -> Void)?, // Callback khi nhấn back
    titleAction: (() -> Void)?, // Callback khi nhấn title
    rightAction: (() -> Void)?, // Callback khi nhấn nút phải
    bg: Color = ...,           // Background color
    @ViewBuilder content: () -> Content
)
```

### Tầng 2: TTBaseNavigationLink — Điều Hướng Bắt Buộc

```swift
TTBaseNavigationLink(destination: {
    ProductItemScreen(product: product)
}, label: {
    ProductCardView(product: product)
        .pAll(TTSize.P_CONS_DEF)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .bg(byDef: TTView.viewBgColor.toColor())
        .corner()
        .pLeading(TTSize.P_CONS_DEF).pTrailing(TTSize.P_CONS_DEF).pTop(TTSize.P_CONS_DEF)
        .baseShadow()
})
```

**Đặt `TTBaseNavigationLink` BÊN TRONG `TTBaseSUIScroll` hoặc `TTBaseSUILazyVStack`.**

### Điều Hướng Có Active Binding

```swift
@State private var isShowingDetail = false

TTBaseNavigationLink(
    isActive: $isShowingDetail,
    destination: { DetailScreen() },
    label: { ButtonRow(label: "Go to Detail") }
)
```

### Điều Hướng Không Animation

```swift
TTBaseNavigationLink(
    destination: { HeavyScreen() },
    label: { NavLabel() },
    isAnimation: false
)
```

## Tầng 3: TTBaseSUI Component Reference Đầy Đủ

### Text Components

```swift
// Theo type (tự động apply font size)
TTBaseSUIText(withType: .HEADER_SUPER, text: "...", align: .center)
TTBaseSUIText(withType: .HEADER, text: "...", align: .leading)
TTBaseSUIText(withType: .TITLE, text: "...", align: .leading)
TTBaseSUIText(withType: .SUB_TITLE, text: "...", align: .leading)
TTBaseSUIText(withType: .SUB_SUB_TILE, text: "...", align: .leading)

// Theo bold weight (custom color)
TTBaseSUIText(withBold: .HEADER, text: "...", align: .center, color: .white)
TTBaseSUIText(withBold: .TITLE, text: "...", align: .leading, color: TTView.textDefColor.toColor())
```

### Button Component

```swift
TTBaseSUIButton(type: .DEFAULT, title: "CONFIRM")
TTBaseSUIButton(type: .DEFAULT_COLOR(color: .systemBlue, textColor: .white), title: "CUSTOM")
TTBaseSUIButton(type: .WARRING, title: "DELETE")
TTBaseSUIButton(type: .DISABLE, title: "DISABLED")
TTBaseSUIButton(type: .NO_BG_COLOR, title: "LINK")
TTBaseSUIButton(type: .BORDER, title: "OUTLINE")

// Custom action
TTBaseSUIButton(type: .DEFAULT) {
    TTBaseSUIText(withType: .TITLE, text: "Tap me")
} action: {
    viewModel.submit()
}
```

### Stack Components

```swift
TTBaseSUIVStack(alignment: .center, spacing: TTSize.P_CONS_DEF) { }
TTBaseSUIVStack(alignment: .center, spacing: TTSize.P_CONS_DEF, bg: .clear) { }
TTBaseSUIVStack(alignment: .center, spacing: TTSize.P_CONS_DEF, bg: .clear, radius: 8) { }
TTBaseSUIHStack(alignment: .center, spacing: TTSize.P_CONS_DEF) { }
TTBaseSUIZStack(alignment: .center, bg: .clear) { }
```

### Scroll Components

```swift
TTBaseSUIScroll(alignment: .vertical, showIndicators: false) { }
TTBaseSUIScroll(alignment: .vertical, bg: .clear, isEnablePullToRefresh: true) {
    // content
} pullToRefresh: {
    viewModel.fetch()
}

TTBaseSUILazyVStack(alignment: .leading, spacing: TTSize.P_CONS_DEF, bg: .clear) { }
TTBaseSUILazyHStack(alignment: .center, spacing: TTSize.P_CONS_DEF) { }
TTBaseSUILazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) { }
TTBaseSUILazyHGrid(rows: [GridItem(.fixed(60)), GridItem(.fixed(60))], spacing: 8) { }
```

### Grid Components

```swift
// Equal-height grid (tất cả items cùng chiều cao = chiều cao lớn nhất)
let columns = [GridItem(.flexible()), GridItem(.flexible())]
TTBaseEqualHeightGridView(items: products, columns: columns) { product in
    ProductCard(product: product)
}
```

### Image Components

```swift
// Asset image
TTBaseSUIImage(withname: "icon_name")
TTBaseSUIImage(withname: "icon_name", conner: TTSize.CORNER_RADIUS)
TTBaseSUIImage(withname: "icon_name", contentMode: .fit)

// System image
TTBaseSUIImage(withSystemName: "star.fill", iconColor: .orange, contentMode: .fit)

// Circle image
TTBaseSUICircleImage(withname: "avatar")
TTBaseSUICircleImage(withname: "avatar", conner: TTSize.CORNER_IMAGE)

// Async image (iOS 15+)
TTBaseSUIAsyncImage(urlString: product.avatarUrl)
TTBaseSUIAsyncImage(urlString: product.avatarUrl, type: .CIRCLE)
    .sizeSquare(width: 60)
```

### Divider Components

```swift
TTBaseSUIHorizontalDividerView(noConner: .LINE)           // Line mỏng
TTBaseSUIHorizontalDividerView(noConner: .SPACE)         // Khoảng trắng
TTBaseSUIHorizontalDividerView(withConner: 4, type: .SPACE)

TTBaseSUIVerticalDividerView(noConner: .LINE)             // Line dọc mỏng
TTBaseSUIVerticalDividerView(noConner: .SPACE)            // Khoảng trắng dọc
```

### Spacer

```swift
TTBaseSUISpacer()                           // Fill available space
TTBaseSUISpacer(maxHeight: 20)              // Fixed height spacer
TTBaseSUISpacer(maxWidth: 50)                // Fixed width spacer
TTBaseSUISpacer(withBg: .green, radius: 8)  // Colored spacer fill
```

### Container View

```swift
TTBaseSUIView(withCornerRadius: 0) { }
TTBaseSUIView(withCornerRadius: TTSize.CORNER_PANEL, bg: .white) { }
```

### Form Components

```swift
// TextField
TTBaseSUITextField(placeholder: "Enter name", text: $name)
TTBaseSUITextField(placeholder: "Password", text: $password, isSecure: true)
TTBaseSUITextField(placeholder: "Search...", text: $query, type: .SEARCH)
TTBaseSUITextField(placeholder: "Email", text: $email, type: .BORDER)
TTBaseSUITextField(placeholder: "Phone", text: $phone, type: .UNDERLINE)

// Toggle
TTBaseSUIToggle(label: "Enable notifications", isOn: $isEnabled)
TTBaseSUIToggle(label: "Dark mode", isOn: $isDark, type: .ICON(name: "moon.fill"))
TTBaseSUIToggle(label: "Custom tint", isOn: $isOn, tintColor: TTView.buttonBgDef.toColor())

// Slider
TTBaseSUISlider(value: $volume)
TTBaseSUISlider(value: $brightness, in: 0...100, step: 5)
TTBaseSUISlider(value: $size, in: 0...1, type: .WITH_LABELS(min: "0%", max: "100%"))
```

### List Components

```swift
TTBaseSUIList(type: .PLAIN) {
    ForEach(items) { item in RowView(item: item) }
}

TTBaseSUIList(type: .GROUPED, isEnablePullToRefresh: true) {
    ForEach(items) { item in RowView(item: item) }
} pullToRefresh: {
    viewModel.reload()
}
```

### Tab Components

```swift
// Horizontal swipe pager
TTBaseSUITabView(selection: $currentPage, type: .PAGE) {
    ForEach(pages) { page in PageView(page: page).tag(page.id) }
}

// Pager without dots
TTBaseSUITabView(selection: $idx, type: .PAGE_HIDDEN_DOTS) { ... }

// Standard tab bar
TTBaseSUITabView(type: .DEFAULT) {
    HomeView().tabItem { Label("Home", systemImage: "house") }.tag(0)
    SettingsView().tabItem { Label("Settings", systemImage: "gear") }.tag(1)
}
```

### Group Component

```swift
TTBaseSUIGroup { }                              // Transparent group
TTBaseSUIGroup(bg: .white, radius: 8) { }      // Group with bg + radius
TTBaseSUIGroup(bg: .white, radius: 8, padding: TTSize.P_CONS_DEF) { }
```

## Tầng 4: Chainable Modifier Extensions (BẮT BUỘC DÙNG)

**Luôn dùng chainable extensions trong modifier chains. Chúng trả về `some View` và chain đúng.**

### Padding Extensions

```swift
.pAll(TTSize.P_CONS_DEF)                // all sides padding (default: 8pt)
.pAll(.horizontal, TTSize.P_CONS_DEF)    // horizontal only
.pAll(.vertical, TTSize.P_CONS_DEF)      // vertical only
.pHorizontal(TTSize.P_CONS_DEF)          // horizontal only (default: 8pt)
.pVertical(TTSize.P_CONS_DEF)            // vertical only (default: 8pt)
.pTop(TTSize.P_CONS_DEF)                // top only (default: 8pt)
.pBottom(TTSize.P_CONS_DEF)             // bottom only (default: 8pt)
.pLeading(TTSize.P_CONS_DEF)             // leading only (default: 8pt)
.pTrailing(TTSize.P_CONS_DEF)            // trailing only (default: 8pt)

// Dùng khi chain bị break
.padding(TTSize.P_CONS_DEF)              // standard SwiftUI padding
.padding(.horizontal, TTSize.P_CONS_DEF)
```

### Background & Corner Extensions

```swift
.bg(byDef: TTView.viewBgCellColor.toColor())  // background từ token
.bg(byUIColor: TTView.viewBgColor)           // UIColor version
.corner(byDef: TTSize.CORNER_PANEL)         // corner radius từ token
```

### Shadow & Border Extensions

```swift
.baseShadow()                                      // card shadow mặc định
.baseShadow(corner: 8, color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
.baseBorder(color: TTView.lineDefColor.toColor(), width: TTSize.H_LINEVIEW, radius: TTSize.CORNER_RADIUS)
```

### Size Extensions

```swift
.size(width: 120)                         // set width
.size(height: 40)                         // set height
.size(width: 100, height: 40)           // set both
.sizeSquare(width: 50)                    // square frame
.maxWidth()                               // fill width
.maxWidth(alignment: .leading)            // fill width, align left
.maxHeight()                               // fill height
```

### Interactive Extensions

```swift
.onTapHandle { action() }                // tap gesture (KHÔNG dùng onTapGesture cho buttons)
.skeleton(active: true)                   // shimmer loading
.skeleton(active: true, isShimmering: false)
.disabled(true)
.opacity(0.5)
.hidden(someCondition)                    // conditional hide
.showNoticeView(title: "Error", body: "Something went wrong", style: .ERROR)
```

### Layout Extensions

```swift
.fixedByHorizontal()                     // fixed width, free height
.fixedByVertical()                        // fixed height, free width
.fixedByAutoSize()                       // fixed both
.layoutPriority(1)
```

### Skeleton + Glass Effects

```swift
.skeleton(active: isLoading)             // shimmer loading animation
.enableGlassEffectV2(isClear: false, cornerRadius: 16) { WhiteLiquidGlassBackground(cornerRadius: 16) }
.enableGlassEffect(cornerRadius: 16) { BlackLiquidGlassBackground(cornerRadius: 16) }
```

### Keyboard & Navigation Helpers

```swift
.hideKeyboardOnScroll()                  // dismiss keyboard on scroll
.hiddenNavigationBar()                    // ẩn navigation bar hoàn toàn
```

## Pattern Chainable Card Bắt Buộc

```swift
TTBaseSUIView { ... }
    .pAll(TTSize.P_CONS_DEF)
    .bg(byDef: TTView.viewBgCellColor.toColor())
    .corner(byDef: TTSize.CORNER_PANEL)
    .baseShadow()
```

## 11 Iron Laws

1. **iOS 14+ ONLY** — no `.task`, `NavigationStack`, `#Preview`, `.foregroundStyle()`
2. **SUIBaseView WRAPPER** — mọi screen phải bọc trong `SUIBaseView`
3. **TTBaseNavigationLink** — dùng cho mọi navigation giữa các màn hình
4. **TTBaseSUI FIRST** — dùng `TTBaseSUI*` component trước. Chỉ Native SwiftUI khi không có equivalent
5. **TTView/TTSize/TTFont TOKENS** — không hardcode color/size
6. **XText("key")** — mọi string hiển thị phải qua localization
7. **@StateObject cho owned VM** — `@ObservedObject` cho VM được truyền vào
8. **[weak self]** — mọi closure phải có weak capture
9. **Body < 40 lines** — extract subviews nếu dài hơn
10. **Chainable extensions** — ưu tiên `.pAll()`, `.bg()`, `.corner()` trong modifier chains

## Decision Tree

```
┌─────────────────────────────────────────────────────────────┐
│ Cần build màn hình mới?                                     │
│  ↓                                                          │
│ TTBaseSUI component có chưa?                                │
│  ├── CÓ → Dùng TTBaseSUI + SUIBaseView + TTBaseNavigationLink│
│  └── KHÔNG → TTBaseSUI thiếu component gì?                   │
│              ├── Cần navigation → TTBaseNavigationLink        │
│              ├── Cần card/sheet/bottom → Native SwiftUI + token│
│              └── Cần chart/anim phức tạp → Native SwiftUI + token│
└─────────────────────────────────────────────────────────────┘
```

## Files in This Skill Set

| File | Purpose |
|------|---------|
| `ttb-skill-sui-screen.prompt.md` | TTBaseSUI screen với SUIBaseView + TTBaseNavigationLink |
| `ttb-skill-sui-view.prompt.md` | TTBaseSUI reusable view component |
| `ttb-skill-sui-list.prompt.md` | SwiftUI list với TTBaseSUILazyVStack |
| `ttb-skill-sui-viewmodel.prompt.md` | SwiftUI ViewModel với @Published |
| `ttb-skill-native-screen.prompt.md` | Native SwiftUI screen — chỉ fallback |
| `ttb-skill-native-view.prompt.md` | Native SwiftUI reusable view — chỉ fallback |
| `ttb-ref-ttbasesui.md` | TTBaseSUI component reference đầy đủ |
| `ttb-ref-config-tokens.md` | Color/size/font tokens |

## Shared Resources

- `ttb-skill-shared/rules/ttb-rule-anti-patterns.md` — SwiftUI decision matrix + anti-patterns
- `ttb-skill-shared/rules/ttb-rule-coding-standards.md` — Coding standards
- `ttb-skill-shared/refs/ttb-ref-ios14-compatibility.md` — iOS 14 API guide
- `ttb-skill-shared/refs/ttb-ref-swiftui-performance.md` — Performance optimization
- `ttb-skill-shared/refs/ttb-ref-navigation.md` — Navigation pattern reference

---

**Version**: 2.2.0 | **Date**: 2026-05-22
**Changelog**: v2.2.0 — Added standardized routing contract, EN/VI SwiftUI aliases, input/output schema, confidence guidance, and fallback strategy. v2.0.0 — Complete rewrite with SUIBaseView + TTBaseNavigationLink and full TTBaseSUI inventory.
