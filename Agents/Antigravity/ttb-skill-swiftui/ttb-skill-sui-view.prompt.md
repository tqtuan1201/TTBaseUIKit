---
description: "Scaffold a reusable TTBaseSUI SwiftUI view component such as a card, row, header, badge, empty state, or custom cell. Supports English and Vietnamese prompt intents. iOS 14+."
---

# ttb-skill-sui-view - TTBaseSUI View Builder

## Mandatory Preflight Execution Gate

Before generating code or modifying files, run `ttb-skill-shared/fragments/ttb-preflight-execution-gate.frag.md`.

Required checks:

- Analyze intent, task type, scope, impacted files/modules, dependencies, architecture constraints, coding standards, and project-specific rules.
- Validate required inputs such as target module, screen/component name, file location, navigation flow, expected output, API contract, state management, routing, localization, naming, and reusable component requirements.
- Detect ambiguity, conflicting requirements, incomplete business logic, unclear UX/navigation, unclear module ownership, and unclear architecture direction.
- Score confidence from `0-100`: execute at `90-100`, execute with warning assumptions at `70-89`, and ask a survey below `70` using `ttb-skill-shared/templates/ttb-clarification-survey.md`.
- Support English, Vietnamese, mixed-language, diacritic-free Vietnamese, and light typo prompts.

Build reusable SwiftUI view components using TTBaseSUI wrappers and TTBaseUIKit tokens.

## Trigger

Use this prompt when the request means: TTBaseSUI view, SwiftUI component, reusable view, card view, row view, badge view, custom cell, header view, empty state, `tạo view SwiftUI`, `tao view SwiftUI`, `tạo card`, `tao card`, or `custom view SwiftUI`.

Use `/ttb-native-view` only when TTBaseSUI has no equivalent for the required visual or interaction.

## Input Fidelity

For screenshots or detailed descriptions, preserve:

- Component size role: compact row, full card, badge, header, empty state, action button, or cell.
- Text hierarchy, icon position, image shape, badges, actions, disabled/loading states.
- Padding, spacing, corner radius, shadow, border, and background token role.
- Tappable behavior and accessibility labels.

## Tappable Card Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active
//  CustomViews/{Name}CardView.swift
//  {AppName}
//

import SwiftUI
import TTBaseUIKit

// MARK: - {Name}CardView
struct {Name}CardView: View {

    let title: String
    let subtitle: String
    var onTap: (() -> Void)?

    var body: some View {
        TTBaseSUIHStack(alignment: .center, spacing: TTSize.P_CONS_DEF) {
            TTBaseSUIImage(withname: "icon_placeholder", conner: TTSize.CORNER_RADIUS)
                .sizeSquare(width: 50)

            TTBaseSUIVStack(alignment: .leading, spacing: TTSize.P_XS) {
                TTBaseSUIText(withBold: .TITLE, text: title, align: .leading, color: TTView.textDefColor.toColor())
                TTBaseSUIText(withType: .SUB_TITLE, text: subtitle, align: .leading, color: TTView.textSubTitleColor.toColor())
            }
            .maxWidth(alignment: .leading)

            TTBaseSUISpacer()

            TTBaseSUIImage(withSystemName: "chevron.right", iconColor: TTView.textSubTitleColor.toColor(), contentMode: .fit)
                .sizeSquare(width: 14)
        }
        .pAll(TTSize.P_CONS_DEF)
        .bg(byDef: TTView.viewBgCellColor.toColor())
        .corner(byDef: TTSize.CORNER_PANEL)
        .baseShadow()
        .onTapHandle { onTap?() }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title)
    }
}
```

## Static Display Pattern

```swift
struct {Name}InfoView: View {

    let title: String
    let subtitle: String

    var body: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: TTSize.P_S) {
            TTBaseSUIText(withBold: .TITLE, text: title, align: .leading, color: TTView.textDefColor.toColor())
            TTBaseSUIText(withType: .SUB_TITLE, text: subtitle, align: .leading, color: TTView.textSubTitleColor.toColor())
        }
        .pAll(TTSize.P_CONS_DEF)
        .bg(byDef: TTView.viewBgCellColor.toColor())
        .corner(byDef: TTSize.CORNER_PANEL)
    }
}
```

## Badge Pattern

```swift
struct BadgeView: View {

    let text: String
    let backgroundColor: Color

    var body: some View {
        TTBaseSUIText(withType: .SUB_SUB_TILE, text: text, align: .center, color: .white)
            .pVertical(TTSize.P_XS)
            .pHorizontal(TTSize.P_S)
            .bg(byDef: backgroundColor)
            .corner(byDef: TTSize.P_S)
            .accessibilityElement(children: .combine)
            .accessibilityLabel(text)
    }
}
```

## Empty State Pattern

```swift
struct EmptyStateView: View {

    let icon: String
    let title: String
    let subtitle: String
    var buttonTitle: String?
    var onButtonTap: (() -> Void)?

    var body: some View {
        TTBaseSUIVStack(alignment: .center, spacing: TTSize.P_CONS_DEF) {
            TTBaseSUIImage(withSystemName: icon, iconColor: TTView.iconColor.toColor().opacity(0.7), contentMode: .fit)
                .sizeSquare(width: 80)

            TTBaseSUIText(withBold: .TITLE, text: title, align: .center, color: TTView.textDefColor.toColor())
            TTBaseSUIText(withType: .SUB_TITLE, text: subtitle, align: .center, color: TTView.textSubTitleColor.toColor())
                .lineLimit(4)

            if let buttonTitle = buttonTitle {
                TTBaseSUIButton(type: .DEFAULT) {
                    TTBaseSUIText(withBold: .TITLE, text: buttonTitle, align: .center, color: .white)
                } action: {
                    onButtonTap?()
                }
                .pTop(TTSize.P_CONS_DEF)
            }

            TTBaseSUISpacer()
        }
        .maxWidth()
        .maxHeight()
        .bg(byDef: TTView.viewBgColor.toColor())
        .corner()
        .pAll(TTSize.P_L * 2)
    }
}
```

## Component Reference

Prefer these components:

- Text: `TTBaseSUIText`
- Button: `TTBaseSUIButton`
- Layout: `TTBaseSUIVStack`, `TTBaseSUIHStack`, `TTBaseSUIZStack`, `TTBaseSUIGroup`, `TTBaseSUIView`
- Image: `TTBaseSUIImage`, `TTBaseSUICircleImage`, `TTBaseSUIAsyncImage` when deployment supports it
- Dividers/spacers: `TTBaseSUIHorizontalDividerView`, `TTBaseSUIVerticalDividerView`, `TTBaseSUISpacer`
- Form controls: `TTBaseSUITextField`, `TTBaseSUIToggle`, `TTBaseSUISlider`

## Rules

1. Use TTBaseSUI components instead of native `Text`, `Button`, `VStack`, `HStack`, and `ZStack`.
2. Pass data through `let` properties and actions through closure properties.
3. Use `TTView`, `TTSize`, and `TTFont` tokens instead of hardcoded styling.
4. Use the card chain `.pAll()` -> `.bg()` -> `.corner()` -> `.baseShadow()`.
5. Use `PreviewProvider`, not `#Preview`.
6. Place screen-specific views in the feature `CustomViews` folder.
7. Place shared views in a shared `CustomViews` or `SharedViews` folder following the local project structure.
8. Keep each reusable view in its own file when it is reused or complex.
9. Add accessibility labels to interactive custom views.
10. Keep visual output faithful to the provided image or written requirements.

## Verification

After implementation:

1. Register new Swift files in the Xcode target.
2. Run the repository build verification command or shared `ttb-verify.sh` script when present.
3. Run the shared compliance check script when present.
4. Complete only when the build succeeds, or report exact blockers after three repair attempts.
