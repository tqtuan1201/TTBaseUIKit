---
description: "Scaffold a TTBaseSUI SwiftUI screen using SUIBaseView, TTBaseUIKit tokens, and TTBaseNavigationLink. Supports English and Vietnamese prompt intents. iOS 14+."
---

# ttb-skill-sui-screen - TTBaseSUI Screen Builder

## Mandatory Preflight Execution Gate

Before generating code or modifying files, run `ttb-skill-shared/fragments/ttb-preflight-execution-gate.frag.md`.

Required checks:

- Analyze intent, task type, scope, impacted files/modules, dependencies, architecture constraints, coding standards, and project-specific rules.
- Validate required inputs such as target module, screen/component name, file location, navigation flow, expected output, API contract, state management, routing, localization, naming, and reusable component requirements.
- Detect ambiguity, conflicting requirements, incomplete business logic, unclear UX/navigation, unclear module ownership, and unclear architecture direction.
- Score confidence from `0-100`: execute at `90-100`, execute with warning assumptions at `70-89`, and ask a survey below `70` using `ttb-skill-shared/templates/ttb-clarification-survey.md`.
- Support English, Vietnamese, mixed-language, diacritic-free Vietnamese, and light typo prompts.

Build a full SwiftUI screen for a TTBaseUIKit app using `SUIBaseView` and TTBaseSUI components.

## Trigger

Use this prompt when the request means: SwiftUI screen, SwiftUI page, SUIBaseView screen, navigation screen, detail screen, settings screen, `tạo màn hình SwiftUI`, `tao man hinh SwiftUI`, `màn hình SUIBaseView`, or `dieu huong SwiftUI`.

Do not use this prompt for UIKit ViewControllers or for native SwiftUI fallback-only layouts.

## Input Fidelity

Before coding, extract these requirements from text, screenshots, or mockups:

- Screen title, navigation type, tab bar visibility, and back/right actions.
- Primary regions in visual order.
- Content states: loaded, empty, loading, error, disabled.
- Data source and navigation destinations.
- Spacing, hierarchy, icon intent, and color roles.

Match the provided image or description closely. Do not add unrelated sections.

## Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active
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
            TTBaseSUIVStack(alignment: .center, spacing: TTSize.P_XS, bg: TTView.viewBgColor.toColor()) {
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
        TTBaseSUIHStack(alignment: .center, spacing: TTSize.P_CONS_DEF) {
            TTBaseSUIText(
                withBold: .HEADER,
                text: XText("App.{Name}.Header"),
                align: .leading,
                color: TTView.textDefColor.toColor()
            )

            TTBaseSUISpacer()
        }
        .pHorizontal(TTSize.P_CONS_DEF)
        .pTop(TTSize.P_CONS_DEF)
    }

    private var emptyView: some View {
        TTBaseSUIVStack(alignment: .center, spacing: TTSize.P_CONS_DEF) {
            TTBaseSUIImage(withSystemName: "tray", iconColor: TTView.iconColor.toColor(), contentMode: .fit)
                .sizeSquare(width: 80)

            TTBaseSUIText(
                withBold: .TITLE,
                text: XText("App.{Name}.Empty.Title"),
                align: .center,
                color: TTView.textDefColor.toColor()
            )

            TTBaseSUIText(
                withType: .SUB_TITLE,
                text: XText("App.{Name}.Empty.Subtitle"),
                align: .center,
                color: TTView.textSubTitleColor.toColor()
            )
        }
        .maxWidth()
        .maxHeight()
        .bg(byDef: TTView.viewBgColor.toColor())
        .corner()
        .pAll(TTSize.P_L * 2)
    }

    private var contentSection: some View {
        TTBaseSUIScroll(alignment: .vertical, bg: .clear) {
            TTBaseSUIVStack(alignment: .center, spacing: TTSize.P_CONS_DEF) {
                // Add content sections here.
            }
            .pAll(TTSize.P_CONS_DEF)
            .pBottom(TTSize.H_BUTTON)
        }
        .skeleton(active: vm.isLoading)
        .maxHeight()
        .pBottom(TTSize.P_CONS_DEF)
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

Use `TTBaseNavigationLink` for every SwiftUI-to-SwiftUI navigation.

```swift
TTBaseNavigationLink(destination: {
    {Name}DetailScreen(item: item)
}, label: {
    {Name}ItemView(item: item)
        .pAll(TTSize.P_CONS_DEF)
        .bg(byDef: TTView.viewBgCellColor.toColor())
        .corner(byDef: TTSize.CORNER_PANEL)
        .baseShadow()
}, isAnimation: true)
```

Programmatic navigation:

```swift
@State private var isShowingDetail = false

TTBaseNavigationLink(
    isActive: $isShowingDetail,
    destination: { DetailScreen(item: item) },
    label: { ItemRow(item: item) },
    isAnimation: true
)
```

## Component Preference

Use TTBaseSUI components first:

- `TTBaseSUIText` for text.
- `TTBaseSUIButton` for buttons.
- `TTBaseSUIVStack`, `TTBaseSUIHStack`, `TTBaseSUIZStack` for layout.
- `TTBaseSUIScroll`, `TTBaseSUILazyVStack`, `TTBaseSUILazyVGrid`, `TTBaseEqualHeightGridView` for scroll and grid layouts.
- `TTBaseSUIImage`, `TTBaseSUICircleImage`, `TTBaseSUIAsyncImage` for images when supported.
- `TTBaseSUITextField`, `TTBaseSUIToggle`, `TTBaseSUISlider` for forms.

Preferred card chain:

```swift
.pAll(TTSize.P_CONS_DEF)
.bg(byDef: TTView.viewBgCellColor.toColor())
.corner(byDef: TTSize.CORNER_PANEL)
.baseShadow()
```

## Rules

1. Every screen must be wrapped in `SUIBaseView`.
2. Every navigation path must use `TTBaseNavigationLink(destination:label:isAnimation:)` with closure-based `destination`, closure-based `label`, and explicit `isAnimation: true` unless disabling animation is required.
3. Prefer `TTBaseSUI*` components before native SwiftUI.
4. Use iOS 14-compatible APIs only: no `.task`, `NavigationStack`, `#Preview`, `.foregroundStyle`, or `.scrollIndicators`.
5. Use `TTView`, `TTSize`, and `TTFont` tokens instead of hardcoded colors and sizes.
6. Use localization helpers for user-visible strings.
7. Use `.onAppear { }` for lifecycle loading.
8. Use `@StateObject` for owned ViewModels.
9. Put `PreviewProvider` at the bottom.
10. Extract subviews when `body` exceeds roughly 40 lines.
11. Keep generated UI faithful to the image or written requirements.

## Verification

After implementation:

1. Ensure every new Swift file is registered in the Xcode target.
2. Run the repository build verification command or shared `ttb-verify.sh` script when present.
3. Run the shared compliance check script when present.
4. Complete only when the build succeeds, or report exact blockers after three repair attempts.
