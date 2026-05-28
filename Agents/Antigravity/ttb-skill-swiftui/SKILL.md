---
name: "ttb-skill-swiftui"
description: "SwiftUI full-stack development for TTBaseUIKit apps. Use for SwiftUI/SUIBaseView/TTBaseSUI screens, reusable SwiftUI views, list/grid screens, SwiftUI ViewModels, and native SwiftUI fallback when TTBaseSUI has no equivalent. Supports English and Vietnamese user prompts. iOS 14+."
version: "2.3.0"
date_updated: "2026-05-22"
risk: "safe"
source: "internal"
loadLevel: "domain"
tags: ["swiftui", "ttbasesui", "suibaseview", "navigation", "viewmodel", "native-fallback", "routing", "multilingual"]
---

# ttb-skill-swiftui

SwiftUI development skill set for TTBaseUIKit apps.

Primary rule: use TTBaseSUI whenever an equivalent component exists. Use native SwiftUI only as a documented fallback.

## Mandatory Preflight Execution Gate

Before this skill generates code, refactors, migrates, modifies files, creates architecture, updates UI/navigation, changes dependencies, updates workflows, or changes business logic, run the shared gate:

- `ttb-skill-shared/fragments/ttb-preflight-execution-gate.frag.md`
- `ttb-skill-shared/templates/ttb-clarification-survey.md` when confidence is below threshold

Required phase order: Requirement Analysis -> Context Validation -> Ambiguity Detection -> Missing Information Detection -> Survey / Clarification -> Confidence Evaluation -> Execution Approval.

Execution thresholds:

| Confidence | Action |
|------------|--------|
| `90-100` | Execute directly and state key assumptions |
| `70-89` | Execute only with documented low-risk assumptions |
| `<70` | Do not execute; ask a concise survey first |

Cap confidence at `69` when target module, architecture direction, UIKit/SwiftUI choice, navigation behavior, API/business logic, localization format, state management, dependency info, or ownership is unclear. Parse English, Vietnamese, mixed-language, diacritic-free Vietnamese, and light typos before scoring.

## Trigger Scope

Use this skill when the user asks for any of these artifacts:

| Artifact | Route | Examples |
|----------|-------|----------|
| SwiftUI screen | `/ttb-sui-screen` | screen, page, flow, detail, settings, profile |
| SwiftUI list/grid screen | `/ttb-sui-list` | list, grid, collection, carousel, searchable list |
| Reusable TTBaseSUI view | `/ttb-sui-view` | card, row, header, badge, empty state, custom cell |
| SwiftUI ViewModel | `/ttb-sui-viewmodel` | ObservableObject, @Published state, loading/error state |
| Native SwiftUI screen fallback | `/ttb-native-screen` | custom chart, advanced gesture, custom animation, layout not covered by TTBaseSUI |
| Native SwiftUI view fallback | `/ttb-native-view` | bespoke visual component not covered by TTBaseSUI |

Do not use this skill for UIKit-only requests. Route UIKit/ViewController/cell/API/coordinator tasks to the UIKit skill.

## Multilingual Prompt Support

Treat English and Vietnamese prompts as equivalent intent signals. Keep generated code, comments, documentation, and final implementation notes in English unless the user explicitly asks for Vietnamese output.

Common aliases:

- English: `SwiftUI screen`, `build SwiftUI`, `TTBaseSUI view`, `SUIBaseView`, `SwiftUI list`, `grid screen`, `SwiftUI ViewModel`, `native SwiftUI`, `custom SwiftUI component`.
- Vietnamese: `tạo màn hình SwiftUI`, `tao man hinh SwiftUI`, `danh sách SwiftUI`, `danh sach SwiftUI`, `tạo view SwiftUI`, `tao view SwiftUI`, `điều hướng SwiftUI`, `dieu huong SwiftUI`, `tạo ViewModel SwiftUI`, `tao ViewModel SwiftUI`.

## Routing Contract

```yaml
input:
  required: [artifact_type, feature_name, visual_or_text_requirements]
  optional:
    - navigation_flow
    - data_source_or_api_contract
    - empty_loading_error_states
    - localization_keys
    - image_reference_or_mockup
    - ttbase_sui_component_availability
output:
  artifacts:
    - suibaseview_screen_or_reusable_view
    - ttbase_sui_components
    - native_swiftui_fallback_when_needed
    - swiftui_viewmodel_when_needed
    - verification_report
  completion_gate: "SUIBaseView + TTBaseNavigationLink when navigating + iOS 14 compatibility + build verification"
confidence:
  auto_route: ">= 0.78 for SwiftUI, TTBaseSUI, SUIBaseView, SwiftUI list/view/screen/viewmodel intents"
  clarify: "0.55-0.77 when the user says screen/view but does not specify UIKit or SwiftUI"
fallback:
  default: "Prefer TTBaseSUI. Use native SwiftUI only when TTBaseSUI has no equivalent and document the missing component."
```

## Workflow

1. Classify the requested artifact and choose exactly one route from the trigger table.
2. Extract requirements from text, screenshots, mockups, or existing code. Preserve visual hierarchy, spacing, states, copy intent, and navigation behavior.
3. Inspect the local codebase for existing patterns, token names, localization style, target folders, and project registration requirements.
4. Prefer TTBaseSUI components. If falling back to native SwiftUI, name the missing TTBaseSUI equivalent in the implementation notes.
5. Implement with iOS 14-compatible SwiftUI and TTBaseUIKit tokens.
6. Add or update localization keys when the project uses localization.
7. Register new files in the Xcode project when needed.
8. Run build verification and fix issues until `BUILD SUCCEEDED`, with a maximum of three fix attempts before reporting blockers.

## Image and Description Fidelity

When the user provides an image, screenshot, or detailed visual description:

- Identify all visible regions before coding: navigation bar, primary content, actions, lists/cards, empty/loading/error states, overlays, and bottom controls.
- Match layout order, alignment, approximate spacing, typography hierarchy, color roles, icon intent, and component states using TTBaseUIKit tokens.
- Do not invent unrelated sections or marketing copy.
- If information is missing, infer conservative defaults from nearby project patterns and clearly state the assumption.
- Validate that generated screens still satisfy accessibility, dynamic text resilience, and iOS 14 API constraints.

## Core SwiftUI Rules

1. iOS 14+ only: no `NavigationStack`, `.task`, `#Preview`, `.foregroundStyle`, `.scrollIndicators`, `@Observable`, or iOS 15+ APIs without `@available`.
2. Every full SwiftUI screen uses `SUIBaseView`.
3. Navigation between SwiftUI screens uses `TTBaseNavigationLink`.
4. Use `TTBaseSUI*` components before native SwiftUI primitives.
5. Use `TTView`, `TTSize`, and `TTFont` tokens instead of hardcoded colors, spacing, and font sizes.
6. User-visible strings go through the project localization helper, usually `XText("key")` or the existing local convention.
7. Owned ViewModels use `@StateObject`; injected ViewModels use `@ObservedObject`.
8. ViewModels are `@MainActor ObservableObject` with `@Published` state and no UIKit/SwiftUI imports.
9. Use `[weak self]` in escaping closures.
10. Extract subviews when `body` grows beyond roughly 40 lines.
11. Use `PreviewProvider`, not `#Preview`.

## Required Screen Pattern

```swift
import SwiftUI
import TTBaseUIKit

struct ProductListScreen: View {

    @StateObject private var vm = ProductListViewModel()

    var body: some View {
        SUIBaseView(
            backType: .SWIFTUI,
            title: XText("App.ProductList.Nav.Title"),
            type: .DEFAULT,
            isHiddenTabbar: true,
            backAction: {}
        ) {
            TTBaseSUIVStack(alignment: .center, spacing: TTSize.P_XS, bg: TTView.viewBgColor.toColor()) {
                headerSection
                contentSection
            }
        }
        .onAppear { vm.fetchData() }
    }
}
```

## Required Navigation Pattern

```swift
TTBaseNavigationLink(destination: {
    ProductDetailScreen(product: product)
}, label: {
    ProductCardView(product: product)
        .pAll(TTSize.P_CONS_DEF)
        .bg(byDef: TTView.viewBgCellColor.toColor())
        .corner(byDef: TTSize.CORNER_PANEL)
        .baseShadow()
}, isAnimation: true)
```

Place `TTBaseNavigationLink` inside the relevant scroll, stack, list, grid, or card row. Use closure-based `destination` and `label` parameters, pass `isAnimation: true` explicitly for normal navigation, and use `isAnimation: false` only when required by performance or UX.

## TTBaseSUI Component Preference

Use these families before native SwiftUI:

- Text: `TTBaseSUIText`
- Buttons: `TTBaseSUIButton`
- Stacks: `TTBaseSUIVStack`, `TTBaseSUIHStack`, `TTBaseSUIZStack`
- Scroll/list/grid: `TTBaseSUIScroll`, `TTBaseSUILazyVStack`, `TTBaseSUILazyHStack`, `TTBaseSUILazyVGrid`, `TTBaseEqualHeightGridView`, `TTBaseSUIList`
- Images: `TTBaseSUIImage`, `TTBaseSUICircleImage`, `TTBaseSUIAsyncImage` when project deployment supports it
- Forms: `TTBaseSUITextField`, `TTBaseSUIToggle`, `TTBaseSUISlider`
- Containers: `TTBaseSUIView`, `TTBaseSUIGroup`, dividers, spacers, tab views

Preferred card modifier chain:

```swift
.pAll(TTSize.P_CONS_DEF)
.bg(byDef: TTView.viewBgCellColor.toColor())
.corner(byDef: TTSize.CORNER_PANEL)
.baseShadow()
```

## Command Prompt Files

Load only the route-specific prompt file that matches the task:

| File | Use when |
|------|----------|
| `ttb-skill-sui-screen.prompt.md` | Build a TTBaseSUI screen with `SUIBaseView` and navigation |
| `ttb-skill-sui-view.prompt.md` | Build a reusable TTBaseSUI component |
| `ttb-skill-sui-list.prompt.md` | Build a TTBaseSUI list/grid/carousel screen |
| `ttb-skill-sui-viewmodel.prompt.md` | Build a SwiftUI ViewModel |
| `ttb-skill-native-screen.prompt.md` | Build a native SwiftUI screen fallback |
| `ttb-skill-native-view.prompt.md` | Build a native SwiftUI reusable view fallback |

## Verification

After implementation:

1. Ensure every new Swift file is part of the Xcode target.
2. Run the project verification command used by the repository, preferably `xcodebuild` or the shared `ttb-verify.sh` script when present.
3. Check for iOS 14 API compatibility and TTBaseUIKit token compliance.
4. Complete only when the build succeeds, or report exact blocking errors after three failed repair attempts.

## Anti-Patterns

- Building full SwiftUI screens without `SUIBaseView`.
- Using native SwiftUI components when a TTBaseSUI equivalent exists.
- Navigating between screens without `TTBaseNavigationLink`.
- Hardcoding colors, sizes, or user-visible strings.
- Adding iOS 15+ APIs without availability guards.
- Creating unrelated UI not present in the input image or description.
- Leaving generated files unregistered in the Xcode project.

---

Version: 2.3.0 | Date: 2026-05-22
