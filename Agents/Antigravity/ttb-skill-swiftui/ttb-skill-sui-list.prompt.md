---
description: "Scaffold a TTBaseSUI SwiftUI list, grid, or carousel screen using SUIBaseView, TTBaseSUIScroll, and TTBaseNavigationLink. Supports English and Vietnamese prompt intents. iOS 14+."
---

# ttb-skill-sui-list - TTBaseSUI List Screen Builder

## Mandatory Preflight Execution Gate

Before generating code or modifying files, run `ttb-skill-shared/fragments/ttb-preflight-execution-gate.frag.md`.

Required checks:

- Analyze intent, task type, scope, impacted files/modules, dependencies, architecture constraints, coding standards, and project-specific rules.
- Validate required inputs such as target module, screen/component name, file location, navigation flow, expected output, API contract, state management, routing, localization, naming, and reusable component requirements.
- Detect ambiguity, conflicting requirements, incomplete business logic, unclear UX/navigation, unclear module ownership, and unclear architecture direction.
- Score confidence from `0-100`: execute at `90-100`, execute with warning assumptions at `70-89`, and ask a survey below `70` using `ttb-skill-shared/templates/ttb-clarification-survey.md`.
- Support English, Vietnamese, mixed-language, diacritic-free Vietnamese, and light typo prompts.

Build a SwiftUI list/grid screen with `SUIBaseView`, `TTBaseSUIScroll`, lazy TTBaseSUI containers, and `TTBaseNavigationLink`.

## Trigger

Use this prompt when the request means: SwiftUI list, list screen, grid screen, collection-style screen, carousel, searchable list, `danh sách SwiftUI`, `danh sach SwiftUI`, `màn hình danh sách`, or `luoi SwiftUI`.

## Input Fidelity

For screenshots or detailed descriptions, map visible content into:

- Search/filter/header areas.
- List item anatomy: image, title, subtitle, metadata, badges, actions.
- Empty/loading/error states.
- Navigation destination for each item.
- List density, spacing, separators, cards, grid columns, and carousel height.

Do not replace a requested list with a generic placeholder when item structure is visible.

## Base Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active
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
        TTBaseSUITextField(
            placeholder: XText("App.{Name}.Search.Placeholder"),
            text: $vm.searchText,
            type: .SEARCH
        )
        .size(height: TTSize.H_TEXTFIELD)
        .bg(byDef: TTView.viewBgCellColor.toColor())
        .corner()
        .pHorizontal(TTSize.P_CONS_DEF)
        .pTop(TTSize.P_CONS_DEF)
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
                    }, isAnimation: true)
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
```

## Item Pattern

```swift
struct {Name}ItemView: View {

    let item: {Name}Model

    var body: some View {
        TTBaseSUIHStack(alignment: .center, spacing: TTSize.P_CONS_DEF) {
            TTBaseSUICircleImage(withname: item.avatarUrl ?? "")
                .sizeSquare(width: 50)

            TTBaseSUIVStack(alignment: .leading, spacing: TTSize.P_XS) {
                TTBaseSUIText(withBold: .TITLE, text: item.title ?? "", align: .leading, color: TTView.textDefColor.toColor())
                TTBaseSUIText(withType: .SUB_TITLE, text: item.subtitle ?? "", align: .leading, color: TTView.textSubTitleColor.toColor())
            }
            .maxWidth(alignment: .leading)

            TTBaseSUISpacer()

            TTBaseSUIImage(withSystemName: "chevron.right", iconColor: TTView.textSubTitleColor.toColor(), contentMode: .fit)
                .sizeSquare(width: 14)
        }
    }
}
```

## Grid Pattern

Use `TTBaseEqualHeightGridView` when grid cells must align by height.

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
                    .bg(byDef: TTView.viewBgCellColor.toColor())
                    .corner(byDef: TTSize.CORNER_PANEL)
                    .baseShadow()
            }, isAnimation: true)
        }
        .pBottom(TTSize.H_BUTTON)
    }
    .hideKeyboardOnScroll()
    .maxHeight()
    .skeleton(active: vm.isLoading)
}
```

## Carousel Pattern

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
                    }, isAnimation: true)
                }
            }
        }
        .size(height: BannerCard.height)
    }
    .pHorizontal(TTSize.P_CONS_DEF)
}
```

## Rules

1. Wrap list screens in `SUIBaseView`.
2. Use `TTBaseNavigationLink(destination:label:isAnimation:)` for item navigation, with closure-based destination/label and explicit `isAnimation: true`.
3. Use `TTBaseSUIScroll` plus lazy TTBaseSUI containers for scrolling performance.
4. Use `TTBaseEqualHeightGridView` for multi-column card grids.
5. Use `TTBaseSUITabView` or horizontal `TTBaseSUIScroll` for paged/carousel content.
6. Use `.skeleton(active: vm.isLoading)` for loading state.
7. Use stable model identifiers in `ForEach`; never create `UUID()` inside rendering.
8. Prefer TTBaseSUI components over native SwiftUI primitives.
9. Use the card chain `.pAll()` -> `.bg()` -> `.corner()` -> `.baseShadow()`.
10. Extract item views into their own files when reused or visually complex.
11. Keep the generated list structure faithful to the provided image or description.

## Verification

After implementation:

1. Register new Swift files in the Xcode target.
2. Run the repository build verification command or shared `ttb-verify.sh` script when present.
3. Run the shared compliance check script when present.
4. Complete only when the build succeeds, or report exact blockers after three repair attempts.
