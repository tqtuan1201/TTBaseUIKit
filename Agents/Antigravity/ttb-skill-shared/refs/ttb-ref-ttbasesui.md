---
name: "ttb-ref-ttbasesui"
description: "Complete reference for TTBaseSUI SwiftUI components, SUIBaseView navigation, TTBaseNavigationLink, chainable modifiers. iOS 14+."
version: "2.0.0"
---

# ttb-ref-ttbasesui — TTBaseSUI Component Reference

Complete reference for TTBaseSUI SwiftUI components, `SUIBaseView` navigation, `TTBaseNavigationLink`, and chainable modifiers.

## Navigation: SUIBaseView + TTBaseNavigationLink

### SUIBaseView — Screen Wrapper

`SUIBaseView` là screen wrapper **bắt buộc** cho mọi TTBaseUIKit SwiftUI screen.

```swift
SUIBaseView(
    backType: .SWIFTUI,                          // .SWIFTUI | .POP | .POP_TO_ROOT | .DISMISS | .DISMISS_ALL | .CLOSE_FLOW
    title: XText("App.Module.Nav.Title"),
    type: .DEFAULT,                              // .DEFAULT | .INFO | .NO_NAV
    isHiddenTabbar: true,
    backAction: { /* optional */ },
    titleAction: { /* optional */ },
    rightAction: { /* optional */ },
    bg: XView.viewBgColor.toColor(),
    @ViewBuilder content: () -> Content
)
```

**backType meanings:**
| Value | Khi nào dùng |
|-------|--------------|
| `.SWIFTUI` | SwiftUI-only app, dùng `presentationMode.dismiss()` |
| `.POP` | UIKit navigation, gọi `currentVC.pop()` |
| `.POP_TO_ROOT` | Pop về root của navigation stack |
| `.DISMISS` | Dismiss presented view controller |
| `.DISMISS_ALL` | Dismiss all presented view controllers |
| `.CLOSE_FLOW` | Pop to root + dismiss (complete flow close) |

### TTBaseNavigationLink — Navigation Giữa Các Màn Hình

Dùng **bên trong** `TTBaseSUIScroll` hoặc `TTBaseSUILazyVStack` để navigate.

```swift
// Simple navigation
TTBaseNavigationLink(destination: {
    DetailScreen(item: item)
}, label: {
    ItemCardView(item: item)
        .pAll(XSize.P_CONS_DEF)
        .bg(byDef: XView.viewBgCellColor.toColor())
        .corner(byDef: TTSize.CORNER_PANEL)
        .baseShadow()
})

// With active binding (programmatic control)
@State private var isShowingDetail = false
TTBaseNavigationLink(
    isActive: $isShowingDetail,
    destination: { DetailScreen(item: item) },
    label: { ItemRow(item: item) }
)

// Without animation
TTBaseNavigationLink(
    destination: { HeavyScreen(item: item) },
    label: { ItemRow(item: item) },
    isAnimation: false
)
```

## TTBaseSUI Text Components

```swift
// By type (automatic font size from TTFont)
TTBaseSUIText(withType: .HEADER_SUPER, text: "...", align: .center)
TTBaseSUIText(withType: .HEADER, text: "...", align: .left)
TTBaseSUIText(withType: .TITLE, text: "...", align: .leading)
TTBaseSUIText(withType: .SUB_TITLE, text: "...", align: .leading)
TTBaseSUIText(withType: .SUB_SUB_TILE, text: "...", align: .leading)

// By bold weight (custom color)
TTBaseSUIText(withBold: .HEADER, text: "...", align: .center, color: .white)
TTBaseSUIText(withBold: .TITLE, text: "...", align: .leading, color: TTView.textDefColor.toColor())
```

## TTBaseSUI Button Components

```swift
// Default styles
TTBaseSUIButton(type: .DEFAULT, title: "CONFIRM")
TTBaseSUIButton(type: .DEFAULT_COLOR(color: .systemBlue, textColor: .white), title: "CUSTOM")
TTBaseSUIButton(type: .WARRING, title: "DELETE")
TTBaseSUIButton(type: .DISABLE, title: "DISABLED")
TTBaseSUIButton(type: .NO_BG_COLOR, title: "LINK")
TTBaseSUIButton(type: .BORDER, title: "OUTLINE")

// With custom content
TTBaseSUIButton(type: .DEFAULT) {
    TTBaseSUIHStack(alignment: .center, spacing: 8) {
        TTBaseSUIImage(withSystemName: "plus", iconColor: .white)
        TTBaseSUIText(withBold: .TITLE, text: "Add Item", color: .white)
    }
} action: {
    viewModel.addItem()
}
```

## TTBaseSUI Stack Components

```swift
TTBaseSUIVStack(alignment: .center, spacing: TTSize.P_CONS_DEF) { }
TTBaseSUIVStack(alignment: .center, spacing: TTSize.P_CONS_DEF, bg: .clear) { }
TTBaseSUIVStack(alignment: .center, spacing: TTSize.P_CONS_DEF, bg: .clear, radius: 8) { }
TTBaseSUIHStack(alignment: .center, spacing: TTSize.P_CONS_DEF) { }
TTBaseSUIHStack(alignment: .top, spacing: TTSize.P_CONS_DEF) { }
TTBaseSUIZStack(alignment: .center, bg: .clear) { }
TTBaseSUIZStack(alignment: .topLeading, bg: .clear) { }
```

## TTBaseSUI Scroll Components

```swift
// ScrollView wrapper
TTBaseSUIScroll(alignment: .vertical, showIndicators: false) { }
TTBaseSUIScroll(alignment: .vertical, bg: .clear, isEnablePullToRefresh: true) {
    // content
} pullToRefresh: {
    viewModel.fetch()
}

// Lazy vertical stack (performance for long lists)
TTBaseSUILazyVStack(alignment: .leading, spacing: TTSize.P_CONS_DEF, bg: .clear) { }
TTBaseSUILazyVStack(alignment: .center, spacing: TTSize.P_CONS_DEF, bg: .clear, radius: 8, pinnedViews: [.sectionHeaders]) { }

// Lazy horizontal stack
TTBaseSUILazyHStack(alignment: .center, spacing: TTSize.P_CONS_DEF) { }
```

## TTBaseSUI Grid Components

```swift
// Lazy vertical grid
let columns = [GridItem(.flexible()), GridItem(.flexible())]
TTBaseSUILazyVGrid(columns: columns, spacing: TTSize.P_CONS_DEF, bg: .clear) {
    ForEach(items) { item in ItemView(item: item) }
}

// Lazy horizontal grid
let rows = [GridItem(.fixed(80)), GridItem(.fixed(80))]
TTBaseSUILazyHGrid(rows: rows, spacing: TTSize.P_CONS_DEF) { }

// Equal-height grid — all items in same row share max height
TTBaseEqualHeightGridView(items: products, columns: columns) { product in
    ProductCard(product: product)
}
```

## TTBaseSUI Image Components

```swift
// Asset image (from bundle)
TTBaseSUIImage(withname: "icon_name")
TTBaseSUIImage(withname: "icon_name", conner: TTSize.CORNER_RADIUS)
TTBaseSUIImage(withname: "icon_name", contentMode: .fit)
TTBaseSUIImage(withname: "icon_name", color: .orange)

// System image (SF Symbols)
TTBaseSUIImage(withSystemName: "star.fill", iconColor: .orange, contentMode: .fit)
TTBaseSUIImage(withSystemName: "chevron.right", iconColor: XView.iconColor.toColor(), contentMode: .fit)

// Circle image
TTBaseSUICircleImage(withname: "avatar")
TTBaseSUICircleImage(withname: "avatar", conner: TTSize.CORNER_IMAGE)

// Async image (iOS 15+, graceful fallback on iOS 14)
TTBaseSUIAsyncImage(urlString: product.avatarUrl)
TTBaseSUIAsyncImage(urlString: product.avatarUrl, type: .CIRCLE)
    .sizeSquare(width: 60)
TTBaseSUIAsyncImage(urlString: product.avatarUrl, contentMode: .fill, cornerRadius: TTSize.CORNER_IMAGE)
```

## TTBaseSUI Divider Components

```swift
// Horizontal divider
TTBaseSUIHorizontalDividerView(noConner: .LINE)              // Thin line
TTBaseSUIHorizontalDividerView(noConner: .SPACE)             // Spacer
TTBaseSUIHorizontalDividerView(withConner: 4, type: .LINE)

// Vertical divider
TTBaseSUIVerticalDividerView(noConner: .LINE)
TTBaseSUIVerticalDividerView(noConner: .SPACE)
```

## TTBaseSUI Spacer

```swift
TTBaseSUISpacer()                                        // Expands to fill space
TTBaseSUISpacer(maxHeight: 20)                          // Fixed height
TTBaseSUISpacer(maxWidth: 50)                            // Fixed width
TTBaseSUISpacer(maxWidth: 50, maxHeight: 20)           // Fixed both
TTBaseSUISpacer(withBg: .green, radius: 8)             // Colored fill spacer
```

## TTBaseSUI Container View

```swift
TTBaseSUIView(withCornerRadius: 0) { }
TTBaseSUIView(withCornerRadius: TTSize.CORNER_PANEL, bg: .white) { }
```

## TTBaseSUI Group

```swift
TTBaseSUIGroup { }                                                    // Transparent
TTBaseSUIGroup(bg: .white, radius: 8) { }                           // With bg + radius
TTBaseSUIGroup(bg: .white, radius: 8, padding: TTSize.P_CONS_DEF) { }
```

## TTBaseSUI Form Components

### TextField
```swift
TTBaseSUITextField(placeholder: "Enter name", text: $name)
TTBaseSUITextField(placeholder: "Password", text: $password, isSecure: true)
TTBaseSUITextField(placeholder: "Search...", text: $query, type: .SEARCH)
TTBaseSUITextField(placeholder: "Email", text: $email, type: .BORDER)
TTBaseSUITextField(placeholder: "Phone", text: $phone, type: .UNDERLINE)
```

### Toggle
```swift
TTBaseSUIToggle(label: "Enable notifications", isOn: $isEnabled)
TTBaseSUIToggle(label: "Dark mode", isOn: $isDark, type: .ICON(name: "moon.fill"))
TTBaseSUIToggle(label: "Custom tint", isOn: $isOn, tintColor: XView.buttonBgDef.toColor())
```

### Slider
```swift
TTBaseSUISlider(value: $volume)
TTBaseSUISlider(value: $brightness, in: 0...100, step: 5)
TTBaseSUISlider(value: $size, in: 0...1, type: .WITH_LABELS(min: "0%", max: "100%"))
```

## TTBaseSUI List Components

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

## TTBaseSUI Tab/Pager Components

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

## Chainable Modifier Extensions

### Padding
```swift
.pAll(TTSize.P_CONS_DEF)                  // all sides (default: 8pt)
.pAll(.horizontal, TTSize.P_CONS_DEF)      // horizontal only
.pAll(.vertical, TTSize.P_CONS_DEF)        // vertical only
.pHorizontal(TTSize.P_CONS_DEF)             // horizontal (default: 8pt)
.pVertical(TTSize.P_CONS_DEF)               // vertical (default: 8pt)
.pTop(TTSize.P_CONS_DEF)                   // top only (default: 8pt)
.pBottom(TTSize.P_CONS_DEF)                // bottom only (default: 8pt)
.pLeading(TTSize.P_CONS_DEF)              // leading only (default: 8pt)
.pTrailing(TTSize.P_CONS_DEF)             // trailing only (default: 8pt)
```

### Background & Corner
```swift
.bg(byDef: XView.viewBgCellColor.toColor())  // background from token
.bg(byUIColor: XView.viewBgCellColor)        // UIColor version
.corner(byDef: TTSize.CORNER_PANEL)          // corner radius from token
```

### Shadow & Border
```swift
.baseShadow()                               // card shadow default
.baseShadow(corner: 8, color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
.baseBorder(color: XView.lineDefColor.toColor(), width: TTSize.H_LINEVIEW, radius: TTSize.CORNER_RADIUS)
```

### Size
```swift
.size(width: 120)                          // set width
.size(height: 40)                         // set height
.size(width: 100, height: 40)          // set both
.sizeSquare(width: 50)                   // square frame
.maxWidth()                              // fill width
.maxWidth(alignment: .leading)           // fill width, left align
.maxHeight()                             // fill height
```

### Interactive
```swift
.onTapHandle { action() }               // tap gesture (KHÔNG dùng onTapGesture cho buttons)
.skeleton(active: true)                  // shimmer loading
.skeleton(active: true, isShimmering: false)
.disabled(true)
.opacity(0.5)
.hidden(someCondition)                  // conditional hide
.showNoticeView(title: "Error", body: "Something went wrong", style: .ERROR)
```

### Layout
```swift
.fixedByHorizontal()                    // fixed width, free height
.fixedByVertical()                      // fixed height, free width
.fixedByAutoSize()                    // fixed both
.layoutPriority(1)
```

### Glass Effects
```swift
.enableGlassEffectV2(isClear: false, cornerRadius: 16) {
    WhiteLiquidGlassBackground(cornerRadius: 16)
}
.enableGlassEffect(cornerRadius: 16) {
    BlackLiquidGlassBackground(cornerRadius: 16)
}
```

### Keyboard & Navigation
```swift
.hideKeyboardOnScroll()                 // dismiss keyboard on scroll
.hiddenNavigationBar()                   // ẩn navigation bar hoàn toàn
```

## Common Patterns

### Card Pattern (Chainable)
```swift
TTBaseSUIView { ... }
    .pAll(TTSize.P_CONS_DEF)
    .bg(byDef: XView.viewBgCellColor.toColor())
    .corner(byDef: TTSize.CORNER_PANEL)
    .baseShadow()
```

### Row Pattern (Chainable)
```swift
TTBaseSUIHStack(alignment: .center, spacing: TTSize.P_CONS_DEF) {
    TTBaseSUIImage(withname: "icon", conner: TTSize.CORNER_RADIUS)
    TTBaseSUIText(withBold: .TITLE, text: title, align: .leading)
    TTBaseSUISpacer()
    TTBaseSUIImage(withSystemName: "chevron.right", iconColor: XView.iconColor.toColor())
}
    .pAll(TTSize.P_CONS_DEF)
    .bg(byDef: XView.viewBgCellColor.toColor())
    .corner(byDef: TTSize.CORNER_PANEL)
```

### Loading State
```swift
ItemView(item: item)
    .skeleton(active: viewModel.isLoading)
```

### Navigation Card Pattern
```swift
TTBaseNavigationLink(destination: {
    DetailScreen(item: item)
}, label: {
    ItemCardView(item: item)
        .pAll(TTSize.P_CONS_DEF)
        .bg(byDef: XView.viewBgCellColor.toColor())
        .corner(byDef: TTSize.CORNER_PANEL)
        .baseShadow()
})
```

## iOS 14+ API Notes

| Native SwiftUI (iOS 15+) | TTBaseSUI / iOS 14+ |
|---|---|
| `.foregroundStyle()` | `.foregroundColor()` |
| `NavigationStack { }` | `NavigationView { }` (via SUIBaseView) |
| `#Preview { }` | `PreviewProvider` protocol |
| `.task { }` | `.onAppear { Task { } }` |
| `@Observable` | `ObservableObject` + `@Published` |
| `.clipShape(.rect())` | `.clipShape(RoundedRectangle())` |
| `.scrollIndicators(.hidden)` | `ScrollView(showsIndicators: false)` |

## Version

**Version**: 2.0.0 | **Date**: 2026-05-19
**Changelog**: v2.0.0 — Complete rewrite. Added SUIBaseView navigation wrapper. Added TTBaseNavigationLink. Added full inventory: TextField, Toggle, Slider, List, TabView, Group, AsyncImage, EqualHeightGrid. Strengthened chainable modifier rules.
