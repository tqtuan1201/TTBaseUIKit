---
name: "ttb-skill-native-swiftui-components"
description: "Build reusable native SwiftUI UI components using 100% standard SwiftUI primitives with TTBaseUIKit design tokens, localization, chainable modifiers, and project architecture rules. NO TTBaseSUI wrappers. iOS 14+."
version: "2.3.0"
date_updated: "2026-05-30"
risk: "safe"
source: "internal"
loadLevel: "on-demand"
tags: ["swiftui", "native-swiftui", "components", "design-tokens", "routing"]
---

# ttb-skill-native-swiftui-components

> Build reusable native SwiftUI UI components using 100% standard SwiftUI primitives with TTBaseUIKit design tokens.
> NO TTBaseSUI wrappers | TTBaseUIKit rules still mandatory | iOS 14+

## Mandatory Preflight Execution Gate

Before this skill generates code, refactors, migrates, modifies files, creates architecture, updates UI/navigation, changes dependencies, updates workflows, or changes business logic, run the shared gate:

- `ttb-skill-shared/fragments/ttb-preflight-execution-gate.frag.md`
- `ttb-skill-shared/fragments/ttb-cross-functional-analysis-gate.frag.md` when component work is part of a feature update, new feature, or bug fix
- `ttb-skill-shared/templates/ttb-clarification-survey.md` when confidence is below threshold

Required phase order: Requirement Analysis -> Context Validation -> Ambiguity Detection -> Missing Information Detection -> Survey / Clarification -> Confidence Evaluation -> Execution Approval.

Execution thresholds:

| Confidence | Action |
|------------|--------|
| `90-100` | Execute directly and state key assumptions |
| `70-89` | Execute only with documented low-risk assumptions |
| `<70` | Do not execute; ask a concise survey first |

Cap confidence at `69` when target module, architecture direction, UIKit/SwiftUI choice, navigation behavior, API/business logic, localization format, state management, dependency info, or ownership is unclear. Parse English, Vietnamese, mixed-language, diacritic-free Vietnamese, and light typos before scoring.

When component work supports a feature update, new feature, or bug fix, analyze as Product Owner, Business Analyst, UX/UI Designer, Solution Architect, Senior Developer, and QA. Compare options across business value, architecture, UI/UX, performance, scalability, maintainability, security, testing, and operations; ask at least 5 value-expansion questions after analysis. If requirements are ambiguous/incomplete, ask at least 6 clarification questions before design/development.

## Scope Boundary

This skill is for **reusable native SwiftUI components only**.

- Use native SwiftUI primitives only: `Text`, `Button`, `VStack`, `HStack`, `ZStack`, `Image`, `Toggle`, `TextField`, `ScrollView`, `LazyVStack`, `LazyHStack`, `LazyVGrid`, `LazyHGrid`, `GeometryReader`, `PreferenceKey`, `Shape`, `ViewModifier`.
- Do **not** use `TTBaseSUI*` wrappers inside this skill: no `TTBaseSUIText`, `TTBaseSUIButton`, `TTBaseSUIVStack`, `TTBaseSUIScroll`, `TTBaseNavigationLink`, or `SUIBaseView` for atomic components.
- Still obey TTBaseUIKit project standards: file headers, folder structure, `MARK`, tokens, localization, iOS 14 compatibility, ViewModel ownership, weak captures, chainable modifiers, accessibility, and build verification.
- If the request is a full screen, navigation flow, or TTBaseSUI wrapper work, route to `ttb-skill-swiftui` (`/ttb-sui-screen`, `/ttb-native-screen`, `/ttb-sui-view`) instead of using this skill.

## Routing Contract

```yaml
input:
  required: [component_type, component_name, states_or_variants]
  optional: [accessibility_requirements, token_mapping, interaction_model, preview_examples]
output:
  artifacts: [native_swiftui_component, previews, tokenized_styles, verification_report]
  completion_gate: "iOS 14 native SwiftUI + TTBaseUIKit tokens + no TTBaseSUI wrapper misuse"
confidence:
  auto_route: ">= 0.78 for native SwiftUI reusable component intents"
  clarify: "0.55-0.77 when prompt could mean a full screen instead of a component"
fallback:
  default: "Route full screens or flows to ttb-skill-swiftui; use this skill only for reusable components."
```

Multilingual aliases: `native SwiftUI component`, `button component`, `card component`, `tao button`, `tao card`, `tao input`, `tao rating`, `tao bottom sheet`.

Anti-patterns: do not wrap native components in TTBaseSUI wrappers; do not invent tokens; do not use `AnyView` unless unavoidable; do not create a full feature flow from this component skill.

## Bốn Tầng Tiếp Cận SwiftUI trong TTBaseUIKit

| Tầng | Khi nào | Skill / Components |
|-------|---------|--------------------|
| **Tầng 1 — TTBaseSUI** | Component TTBaseSUI đã có | `TTBaseSUIButton`, `TTBaseSUIText`, etc. -> `ttb-skill-swiftui` |
| **Tầng 2 — SUIBaseView Navigation** | Navigation giữa màn hình | `SUIBaseView`, `TTBaseNavigationLink` -> `ttb-skill-swiftui` |
| **Tầng 3 — Native Atomic Components** | TTBaseSUI thiếu reusable atomic component | SwiftUI primitives + TTBaseUIKit tokens -> `/native-*` |
| **Tầng 4 — Chainable Modifier Extensions** | Modifier chains trong mọi SwiftUI code | `.pAll()`, `.bg()`, `.corner()`, `.baseShadow()`, `.size()` bắt buộc ưu tiên |

**Rule #1:** Với skill này, chỉ build native atomic component khi TTBaseSUI không có equivalent. Trong component được sinh ra, chỉ dùng native SwiftUI primitives; không dùng wrapper `TTBaseSUI*`.

## Skills in This Set

| Command | Description |
|---------|-------------|
| `/native-text` | Native text: Title, body, caption, badge |
| `/native-button` | Native button: Primary, secondary, destructive, link |
| `/native-card` | Native card: Tappable card, static card |
| `/native-list-row` | Native list row: Icon row, switch row, stepper row |
| `/native-input` | Native input: Text field, secure field, search bar |
| `/native-selector` | Native selector: Toggle, checkbox, radio, segmented |
| `/native-display` | Native display: Avatar, badge, chip, tag, rating |
| `/native-progress` | Native progress: Linear bar, circular, skeleton |
| `/native-divider` | Native divider: Horizontal, vertical, section spacer |
| `/native-tab-bar` | Native tab bar: Tab icon + label |
| `/native-icon` | Native icon: SF Symbol with color/size |
| `/native-bottom-sheet` | Native bottom sheet: Slide-up panel |
| `/native-empty-state` | Native empty state: Illustration + message + action |
| `/native-loading` | Native loading: Spinner, shimmer, skeleton |
| `/native-snackbar` | Native snackbar/toast: Bottom notification |
| `/native-chip` | Native chip/tag: Chip with states |
| `/native-avatar` | Native avatar: Image, initials, status |
| `/native-rating` | Native rating: Star rating, interactive and display |
| `/native-section-header` | Native section header with action |

## Khi Nào Dùng Tầng Nào

```text
Can build with existing TTBaseSUI component?
  YES -> use ttb-skill-swiftui, not this skill
  NO  -> Is it a reusable atomic component?
          YES -> use /native-* in this skill
          NO  -> full screen/navigation -> use ttb-skill-swiftui native screen flow
```

### So Sánh: /native-* vs /ttb-native-screen

| | `/native-*` | `/ttb-native-screen` |
|--|------------|---------------------|
| Scope | Reusable atomic component | Full screen/view |
| Usage | Inside TTBaseSUI/native screens as a leaf component | Entire screen layout |
| SwiftUI primitives | Required | Allowed |
| TTBaseSUI wrappers | Forbidden | Use `ttb-skill-swiftui` rules |
| `SUIBaseView` | Not used | Required for screens |
| Navigation | Not owned by component | `TTBaseNavigationLink` required |

### Khi Nào Dùng /native-*

Dùng khi cần build component mà **không có trong TTBaseSUI**:

- Custom `BadgeView` với animation
- Custom `RatingView` với interaction
- Custom `ChipView` với multi-state
- Custom chart component using iOS 14-safe SwiftUI drawing primitives
- Custom `BottomSheetView` với drag gesture
- Custom `SnackbarView` với queue logic

### Khi Không Dùng Skill Này

- Không build full screen hoặc navigation flow bằng `/native-*`.
- Không thay thế TTBaseSUI component đã tồn tại.
- Không dùng `TTBaseSUI*` wrapper trong output của skill này.
- Không bỏ qua TTBaseUIKit folder/file/project registration standards.

## Component Architecture

Each component follows this pattern:

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active
//  Components/{Category}/{Name}Component.swift
//  {AppName}
//  NATIVE SWIFTUI: Dung khi TTBaseSUI khong co component tuong duong
//

import SwiftUI
import TTBaseUIKit

// MARK: - {Name}Component
public struct {Name}Component: View {
    public let titleKey: String
    public var onTap: (() -> Void)?

    public init(titleKey: String, onTap: (() -> Void)? = nil) {
        self.titleKey = titleKey
        self.onTap = onTap
    }

    public var body: some View {
        Button(action: self.handleTap) {
            titleLabel
                .maxWidth()
                .size(height: max(TTSize.H_BUTTON, 44))
                .bg(byDef: TTView.buttonBgDef.toColor())
                .corner(byDef: TTSize.CORNER_BUTTON)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(XText(self.titleKey))
    }

    private var titleLabel: some View {
        Text(XText(self.titleKey))
            .font(.system(size: TTFont.TITLE_H, weight: .semibold))
            .foregroundColor(.white)
            .pHorizontal(TTSize.P_CONS_DEF)
    }

    private func handleTap() {
        self.onTap?()
    }
}

struct {Name}Component_Previews: PreviewProvider {
    static var previews: some View {
        {Name}Component(titleKey: "Feature.Component.Title")
            .pAll(TTSize.P_L)
            .bg(byDef: TTView.viewBgColor.toColor())
    }
}
```

## Localization Rules

Every user-visible string must go through `XText("key")`.

```swift
// Correct
Text(XText("Feature.Empty.Title"))
Button(action: self.submit) { Text(XText("Feature.Action.Submit")) }
.accessibilityLabel(XText("Feature.Action.Submit"))

// Incorrect
Text("Submit")
Button("Submit") { self.submit() }
.accessibilityLabel("Submit")
```

Guidelines:

- Public component APIs should prefer `titleKey`, `textKey`, `placeholderKey`, `accessibilityKey`, `hintKey` over raw display strings.
- Dynamic values may be interpolated after localization, for example `String(format: XText("Feature.Count.Format"), count)`.
- SF Symbol names, asset names, enum cases, debug-only preview labels, and non-display identifiers are not localization strings.
- Previews may use sample localization keys, not raw production copy.

## Token Access

Full reference: `ttb-skill-shared/refs/ttb-ref-config-tokens.md` and `refs/ttb-ref-native-design-tokens.md`.

**Colors** (use `TTView.*.toColor()`):
- Text: `textDefColor`, `textHeaderColor`, `textSubTitleColor`
- Background: `viewBgColor`, `viewBgCellColor`, `viewBgSkeleton`
- Button: `buttonBgDef`, `buttonBgWar`, `buttonBgDis`
- Semantic: `notificationBgSuccess`, `notificationBgWarning`, `notificationBgError`
- UI: `iconColor`, `lineDefColor`

**Sizes** (use `TTSize.*`):
- Spacing: `P_XS`, `P_S`, `P_CONS_DEF`, `P_M`, `P_L`, `P_XL`
- Heights: `H_BUTTON`, `H_TEXTFIELD`, `H_ICON`, `H_SMALL_ICON`, `H_LINEVIEW`
- Radius: `CORNER_RADIUS`, `CORNER_BUTTON`, `CORNER_PANEL`, `CORNER_IMAGE`

**Fonts** (use `.system(size: TTFont.*)`):
- `HEADER_SUPER_H`, `HEADER_H`, `TITLE_H`, `SUB_TITLE_H`, `SUB_SUB_TITLE_H`

Token rules:

- Do not invent tokens (`XView`, `XSize`, `XFont`) in native component output unless the current project already exposes those aliases and existing code in the target module uses them.
- Do not hardcode colors or spacing except unavoidable SwiftUI constants for geometry math; prefer `TTView`, `TTSize`, `TTFont`.
- Keep component colors configurable only when a real design need exists; defaults must come from TTBaseUIKit tokens.

## Tầng 4: Chainable Modifier Extensions (BẮT BUỘC DÙNG)

Always prefer TTBaseUIKit chainable extensions in modifier chains. Use standard SwiftUI modifiers only when no chainable extension exists or the chainable extension cannot express the needed behavior.

### Padding Extensions

```swift
.pAll(TTSize.P_CONS_DEF)
.pAll(.horizontal, TTSize.P_CONS_DEF)
.pAll(.vertical, TTSize.P_CONS_DEF)
.pHorizontal(TTSize.P_CONS_DEF)
.pVertical(TTSize.P_CONS_DEF)
.pTop(TTSize.P_CONS_DEF)
.pBottom(TTSize.P_CONS_DEF)
.pLeading(TTSize.P_CONS_DEF)
.pTrailing(TTSize.P_CONS_DEF)

// Fallback only when chainable extension is not suitable
.padding(TTSize.P_CONS_DEF)
.padding(.horizontal, TTSize.P_CONS_DEF)
```

### Background & Corner Extensions

```swift
.bg(byDef: TTView.viewBgCellColor.toColor())
.bg(byUIColor: TTView.viewBgColor)
.corner(byDef: TTSize.CORNER_PANEL)
```

### Shadow & Border Extensions

```swift
.baseShadow()
.baseShadow(corner: 8, color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
.baseBorder(color: TTView.lineDefColor.toColor(), width: TTSize.H_LINEVIEW, radius: TTSize.CORNER_RADIUS)
```

### Size Extensions

```swift
.size(width: 120)
.size(height: TTSize.H_BUTTON)
.size(width: 100, height: TTSize.H_BUTTON)
.sizeSquare(width: TTSize.H_ICON)
.maxWidth()
.maxWidth(alignment: .leading)
.maxHeight()
```

### Interactive Extensions

```swift
.onTapHandle { action() }       // Only for non-button gestures; tappable controls must use Button
.skeleton(active: isLoading)
.disabled(isDisabled)
.opacity(isDisabled ? 0.5 : 1)
.hidden(shouldHide)
```

### Required Chainable Patterns

```swift
// Card / panel
content
    .pAll(TTSize.P_CONS_DEF)
    .bg(byDef: TTView.viewBgCellColor.toColor())
    .corner(byDef: TTSize.CORNER_PANEL)
    .baseShadow()

// Button label
Text(XText(titleKey))
    .font(.system(size: TTFont.TITLE_H, weight: .semibold))
    .foregroundColor(.white)
    .maxWidth()
    .size(height: max(TTSize.H_BUTTON, 44))
    .bg(byDef: TTView.buttonBgDef.toColor())
    .corner(byDef: TTSize.CORNER_BUTTON)
```

## ViewModel and Closure Rules

- Use `@StateObject` for ViewModels owned by the component/screen.
- Use `@ObservedObject` for ViewModels injected from a parent.
- Use `@EnvironmentObject` only for app-wide shared state already established in the project.
- For class/VM/coordinator/service closures, always capture `[weak self]`.
- SwiftUI `View` structs cannot weak-capture `self`; their `Button` action should call an injected closure or a private method without strongly capturing reference objects.
- Async completion handlers, timers, notification observers, delegate callbacks, Combine sinks, and service callbacks must use `[weak self]` and guard/optional self handling.

```swift
final class ExampleViewModel: ObservableObject {
    @Published private(set) var isLoading = false

    func fetch() {
        self.isLoading = true
        service.fetch { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            self.handle(result)
        }
    }
}

struct ParentOwnedComponent: View {
    @ObservedObject var viewModel: ExampleViewModel
}

struct SelfOwnedComponent: View {
    @StateObject private var viewModel = ExampleViewModel()
}
```

## Native SwiftUI Iron Laws

1. **iOS 14+ ONLY** — no `.task`, `NavigationStack`, `#Preview`, `.foregroundStyle()`, `AsyncImage`, `PhotosPicker`, or other iOS 15+ APIs.
2. **100% Native SwiftUI primitives inside `/native-*`** — no `TTBaseSUI*`, no `SUIBaseView`, no `TTBaseNavigationLink` in atomic components.
3. **TTBaseUIKit project structure is mandatory** — follow existing folders, naming, access control, file headers, `MARK` sections, Xcode project registration, and shared verification scripts.
4. **TTView/TTSize/TTFont tokens only** — no hardcoded design colors/sizes/fonts unless required for geometry math.
5. **XText("key") for every displayed string** — labels, placeholders, button text, empty states, accessibility labels/hints.
6. **Use `Button` for tappable controls** — never use `onTapGesture` as a button substitute; `.onTapHandle` is only for genuine non-control gestures.
7. **Minimum 44x44 tap target** — all interactive elements must meet Apple hit-area expectations.
8. **`@StateObject` for owned VM, `@ObservedObject` for injected VM** — do not recreate observed objects in `body`.
9. **`[weak self]` in class/VM closures** — every escaping closure that captures class instances must weak-capture self.
10. **Body < 40 lines** — extract subviews into private computed properties/private `View` structs.
11. **Chainable extensions mandatory** — prefer `.pAll()`, `.pHorizontal()`, `.bg()`, `.corner()`, `.baseShadow()`, `.size()`, `.maxWidth()` in modifier chains.
12. **Accessibility always** — `.accessibilityLabel(XText(...))`, `.accessibilityHint(XText(...))` where helpful, Dynamic Type-safe layout.
13. **`@ViewBuilder` / `Group` instead of `AnyView`** — avoid type erasure unless there is no reasonable alternative.
14. **PreviewProvider at bottom** — use iOS 14-compatible previews, sample localization keys, and token backgrounds; no raw preview copy.
15. **MARKER COMMENT at top of every generated file** — keep TTBaseUIKit agent marker and native SwiftUI note.

## Component Categories

| Category | Components |
|----------|------------|
| Display | Text, Avatar, Badge, Chip/Tag, Rating, Icon |
| Interactive | Button, Toggle, Checkbox, Radio, Segmented, Slider |
| Input | TextField, SecureField, SearchBar, Stepper |
| Container | Card, ListRow, EmptyState, Loading, Skeleton, Snackbar, BottomSheet |
| Layout | Divider, Spacer, SectionHeader |

## Files in This Skill Set

| File | Purpose |
|------|---------|
| `SKILL.md` | Skill entry point (this file) |
| `refs/ttb-ref-native-design-tokens.md` | Complete design token and chainable modifier reference |
| `ttb-skill-native-*.prompt.md` | Native component prompt files |

## Shared Resources

- `ttb-skill-shared/rules/ttb-rule-anti-patterns.md` — SwiftUI anti-patterns + decision matrix
- `ttb-skill-shared/rules/ttb-rule-coding-standards.md` — File headers, MARK sections
- `ttb-skill-shared/refs/ttb-ref-config-tokens.md` — Color/size/font tokens
- `ttb-skill-shared/refs/ttb-ref-ios14-compatibility.md` — iOS 14 API guide
- `ttb-skill-shared/fragments/ttb-iron-laws.frag.md` — Iron Laws
- `ttb-skill-swiftui/SKILL.md` — SUIBaseView, navigation, TTBaseSUI, chainable modifier source rules

## Prompt Compliance Gate

Before generating or editing any native component, check:

- Is this truly missing in TTBaseSUI? If not, route to `ttb-skill-swiftui`.
- Does every displayed string use `XText("key")`?
- Are modifier chains using TTBaseUIKit chainable extensions where available?
- Is every interactive element a `Button`/native control with a 44x44 minimum target?
- Are VM ownership wrappers correct (`@StateObject` vs `@ObservedObject`)?
- Do class/VM escaping closures use `[weak self]`?
- Is `body` under 40 lines with extracted subviews?
- Does the file use only iOS 14-compatible APIs?
- Does the component follow current project folder/naming/project registration conventions?

## Audit Checklist

Run this checklist against `SKILL.md`, `refs/`, and every `ttb-skill-native-*.prompt.md` before considering the skill clean:

- No production code sample emits `Text("...")`, `Button("...")`, or `.accessibilityLabel("...")`; use `XText` keys or `String(format: XText(...))`.
- No tappable component uses `.onTapGesture`; use `Button`/native controls. Use `.onTapHandle` only for non-control gestures such as a dimming overlay.
- No iOS 15+ SwiftUI APIs: `.task`, `NavigationStack`, `#Preview`, `.foregroundStyle`, `AsyncImage`, `.animation(_:value:)`.
- No `TTBaseSUI*`, `SUIBaseView`, or `TTBaseNavigationLink` in generated `/native-*` code samples.
- No `AnyView` in generated samples; use `@ViewBuilder`, generic content, or `Group`.
- Prefer chainable modifiers over raw `.padding`, `.background`, `.clipShape`, `.shadow`, and `.frame` when an equivalent extension exists.

## Post-Implementation Verification (MANDATORY)

After all files are generated, **run Phase 6 verification**:

1. **Add files to Xcode project** — ensure each `.swift` is registered in `project.pbxproj`.
2. **Run verification**:
   ```bash
   bash ttb-skill-shared/scripts/ttb-verify.sh
   ```
3. **Check compliance**:
   ```bash
   bash ttb-skill-shared/scripts/ttb-compliance-check.sh
   ```
4. **Skill is complete only when** `BUILD SUCCEEDED`.

**Anti-Loop**: Max 3 build attempts. 3 failures — STOP, document errors.

For full FCR 7-Dimension scoring, see `ttb-skill-shared/phases/ttb-phase-verify.md`.

---

**Version**: 2.3.0 | **Date**: 2026-05-30
**Changelog**: v2.3.0 — Added cross-functional product analysis gate, option exploration, 5 value-expansion questions, and 6-question ambiguity clarification gate. v2.2.0 — Added standardized routing contract, EN/VI native component aliases, input/output schema, confidence guidance, and fallback strategy. v2.1.0 — Synced mandatory chainable modifier, localization, VM ownership, weak capture, body length, iOS 14, and TTBaseUIKit project-structure rules from `ttb-skill-swiftui`; clarified that `/native-*` outputs use only native SwiftUI primitives and never `TTBaseSUI*` wrappers.
