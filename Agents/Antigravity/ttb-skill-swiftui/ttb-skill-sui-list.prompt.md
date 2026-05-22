---
description: "Scaffold a TTBaseSUI SwiftUI list screen using SUIBaseView, TTBaseSUIScroll, and TTBaseNavigationLink. iOS 14+."
---

# ttb-skill-sui-list — TTBaseSUI List Screen Builder

Build a SwiftUI scrollable list screen using `SUIBaseView` + `TTBaseSUIScroll` + `TTBaseSUILazyVStack` + `TTBaseNavigationLink`.

## When

User says: "swiftui list", "list screen", "danh sách swiftui", "grid screen", "scrollable list"

## Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  {Name}ListScreen.swift
//  {AppName}
//

import SwiftUI
import TTBaseUIKit

// MARK: - {Name}ListScreen
struct {Name}ListScreen: View {

    @StateObject private var vm = {Name}ViewModel()

    var body: some View {
        SUIBaseView(
            backType: .SWIFTUI,
            title: XText("App.{Name}.Nav.Title"),
            type: .DEFAULT,
            isHiddenTabbar: true,
            backAction: {}
        ) {
            TTBaseSUIVStack(alignment: .center, spacing: TTSize.P_XS, bg: TTView.viewBgColor.toColor()) {
                searchSection
                if vm.isEmpty {
                    {Name}EmptyView()
                } else {
                    listSection
                }
            }
        }
        .onAppear { vm.fetchData() }
    }
}

// MARK: - Subviews
private extension {Name}ListScreen {

    private var searchSection: some View {
        TTBaseSUIVStack(alignment: .center, spacing: TTSize.P_XS, bg: .clear) {
            TTBaseSUITextField(placeholder: XText("App.{Name}.Search.Placeholder"), text: $vm.searchText, type: .SEARCH)
                .size(height: TTSize.H_TEXTFIELD)
                .bg(byDef: TTView.viewBgCellColor.toColor())
                .corner()
        }
        .pHorizontal()
        .pTop(TTSize.P_CONS_DEF)
        .baseShadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
    }

    private var listSection: some View {
        TTBaseSUIScroll(alignment: .vertical, bg: .clear) {
            TTBaseSUILazyVStack(alignment: .center, spacing: TTSize.P_CONS_DEF, bg: .clear) {
                ForEach(vm.filteredItems) { item in
                    TTBaseNavigationLink(destination: {
                        {Name}DetailScreen(item: item)
                    }, label: {
                        {Name}ItemView(item: item)
                            .pAll(TTSize.P_CONS_DEF)
                            .bg(byDef: TTView.viewBgCellColor.toColor())
                            .corner(byDef: TTSize.CORNER_PANEL)
                            .baseShadow()
                    })
                }
            }
            .pAll(TTSize.P_CONS_DEF)
            .pBottom(TTSize.H_BUTTON)
        }
        .skeleton(active: vm.isLoading)
        .maxHeight()
        .pBottom(TTSize.P_CONS_DEF)
    }
}

// MARK: - {Name}ItemView
struct {Name}ItemView: View {

    let item: {Name}Model

    var body: some View {
        TTBaseSUIHStack(alignment: .center, spacing: TTSize.P_CONS_DEF) {
            TTBaseSUICircleImage(withname: item.avatarUrl ?? "")
                .sizeSquare(width: 50)

            TTBaseSUIVStack(alignment: .leading, spacing: TTSize.P_XS) {
                TTBaseSUIText(withBold: .TITLE, text: item.title ?? "",
                              align: .leading, color: TTView.textDefColor.toColor())
                TTBaseSUIText(withType: .SUB_TITLE, text: item.subtitle ?? "",
                              align: .leading, color: TTView.textSubTitleColor.toColor())
            }
            .maxWidth(alignment: .leading)

            TTBaseSUISpacer()

            TTBaseSUIImage(withSystemName: "chevron.right", iconColor: TTView.textSubTitleColor.toColor(), contentMode: .fit)
                .sizeSquare(width: 14)
        }
        .skeleton(active: true)
    }
}

// MARK: - {Name}EmptyView
struct {Name}EmptyView: View {
    var body: some View {
        TTBaseSUIVStack(alignment: .center, spacing: TTSize.P_CONS_DEF) {
            TTBaseSUIImage(withSystemName: "tray", iconColor: TTView.iconColor.toColor(), contentMode: .fit)
                .sizeSquare(width: 80)
            TTBaseSUIText(withBold: .TITLE, text: XText("App.{Name}.Empty.Title"), align: .center, color: TTView.textDefColor.toColor())
            TTBaseSUIText(withType: .SUB_TITLE, text: XText("App.{Name}.Empty.Subtitle"), align: .center, color: TTView.textSubTitleColor.toColor())
        }
        .maxWidth().maxHeight()
        .bg(byDef: TTView.viewBgColor.toColor())
        .corner()
        .pAll(TTSize.P_L * 2)
    }
}

// MARK: - Preview
struct {Name}ListScreen_Previews: PreviewProvider {
    static var previews: some View {
        {Name}ListScreen()
    }
}
```

## Grid List Pattern

For 2-column product grids, use `TTBaseEqualHeightGridView`:

```swift
private var productGrid: some View {
    let columns = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0)
    ]

    return TTBaseSUIScroll(alignment: .vertical, bg: .clear) {
        TTBaseEqualHeightGridView(items: vm.products, columns: columns) { product in
            TTBaseNavigationLink(destination: {
                ProductDetailScreen(product: product)
            }, label: {
                ProductCardView(product: product)
                    .pAll(TTSize.P_CONS_DEF)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .bg(byDef: TTView.viewBgColor.toColor())
                    .corner()
                    .pLeading(TTSize.P_CONS_DEF).pTrailing(TTSize.P_CONS_DEF).pTop(TTSize.P_CONS_DEF)
                    .baseShadow()
            })
        }
        .pBottom(TTSize.H_BUTTON)
    }
    .hideKeyboardOnScroll()
    .frame(maxHeight: .infinity)
    .pBottom(TTSize.P_CONS_DEF)
    .skeleton(active: vm.isLoading)
}
```

## Horizontal List Pattern (Banner/Carousel)

```swift
private var bannerSection: some View {
    TTBaseSUIVStack(alignment: .leading, spacing: TTSize.P_CONS_DEF) {
        TTBaseSUIText(withBold: .HEADER, text: XText("App.Home.Banner.Title"), align: .leading, color: TTView.textDefColor.toColor())

        TTBaseSUIScroll(alignment: .horizontal, showIndicators: false, isEnablePullToRefresh: false) {
            TTBaseSUIHStack(alignment: .center, spacing: TTSize.P_CONS_DEF) {
                ForEach(vm.banners) { banner in
                    TTBaseNavigationLink(destination: {
                        BannerDetailScreen(banner: banner)
                    }, label: {
                        BannerCard(banner: banner)
                    })
                }
            }
        }
        .size(height: BannerCard.HEIGHT)
    }
    .pHorizontal()
}
```

## Paged/Carousel List Pattern (TTBaseSUITabView)

```swift
@State private var currentPage = 0

private var pagerSection: some View {
    TTBaseSUIVStack(alignment: .center, spacing: TTSize.P_CONS_DEF) {
        TTBaseSUIText(withBold: .HEADER, text: XText("App.Home.Carousel.Title"), align: .leading, color: TTView.textDefColor.toColor())

        TTBaseSUITabView(selection: $currentPage, type: .PAGE) {
            ForEach(Array(vm.pages.enumerated()), id: \.offset) { index, page in
                TTBaseNavigationLink(destination: {
                    PageDetailScreen(page: page)
                }, label: {
                    PageCard(page: page)
                })
                .tag(index)
            }
        }
        .frame(height: 160)
        .corner(byDef: TTSize.CORNER_PANEL)
    }
    .pHorizontal()
}
```

## Section Header List Pattern

```swift
private var sectionedList: some View {
    TTBaseSUIScroll(alignment: .vertical) {
        TTBaseSUILazyVStack(alignment: .center, spacing: TTSize.P_CONS_DEF, bg: .clear) {
            ForEach(vm.sections) { section in
                sectionHeader(title: section.title)
                ForEach(section.items) { item in
                    TTBaseNavigationLink(destination: {
                        DetailScreen(item: item)
                    }, label: {
                        ListItemView(item: item)
                            .pAll(TTSize.P_CONS_DEF)
                            .bg(byDef: TTView.viewBgCellColor.toColor())
                            .corner(byDef: TTSize.CORNER_PANEL)
                    })
                }
            }
        }
        .pAll(TTSize.P_CONS_DEF)
        .pBottom(TTSize.H_BUTTON)
    }
    .skeleton(active: vm.isLoading)
}

private func sectionHeader(title: String) -> some View {
    TTBaseSUIText(withBold: .HEADER, text: title, align: .leading, color: TTView.textDefColor.toColor())
        .pTop(TTSize.P_CONS_DEF)
        .pBottom(TTSize.P_XS)
        .maxWidth(alignment: .leading)
}
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
.skeleton(active: isLoading)                    // shimmer loading
.onTapHandle { action() }                     // tap gesture
.sizeSquare(width: 50)                       // square frame
.maxWidth()                                 // fill width
.maxHeight()                                // fill height
.hideKeyboardOnScroll()                     // dismiss keyboard
```

## Rules

1. **SUIBaseView wrapper** — mọi list screen bọc trong `SUIBaseView`
2. **TTBaseNavigationLink** — dùng cho mọi navigation từ list item
3. **TTBaseSUIScroll** + **TTBaseSUILazyVStack** — cho scroll performance
4. **TTBaseEqualHeightGridView** — cho grid layouts 2+ columns
5. **TTBaseSUITabView** — cho horizontal pager/carousel
6. **`.skeleton(active: vm.isLoading)`** — cho loading state trên mọi list item
7. **`ForEach` với model's `id`** — stable identifier, KHÔNG bao giờ dùng `UUID()`
8. **TTBaseSUI components** — no native SwiftUI primitives
9. **Card chain**: `.pAll()` → `.bg()` → `.corner()` → `.baseShadow()`
10. **Extract item view** — mỗi item view là 1 file riêng
11. **@StateObject** cho owned ViewModel
12. **`.onAppear { }`** cho data loading

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
