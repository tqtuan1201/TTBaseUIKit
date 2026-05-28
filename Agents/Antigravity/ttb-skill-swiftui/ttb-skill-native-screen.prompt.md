---
description: "Scaffold a native SwiftUI screen using standard SwiftUI primitives with TTBaseUIKit tokens. Fallback only when TTBaseSUI has no equivalent. Supports English and Vietnamese prompt intents. iOS 14+."
---

# ttb-skill-native-screen - Native SwiftUI Screen Builder

## Mandatory Preflight Execution Gate

Before generating code or modifying files, run `ttb-skill-shared/fragments/ttb-preflight-execution-gate.frag.md`.

Required checks:

- Analyze intent, task type, scope, impacted files/modules, dependencies, architecture constraints, coding standards, and project-specific rules.
- Validate required inputs such as target module, screen/component name, file location, navigation flow, expected output, API contract, state management, routing, localization, naming, and reusable component requirements.
- Detect ambiguity, conflicting requirements, incomplete business logic, unclear UX/navigation, unclear module ownership, and unclear architecture direction.
- Score confidence from `0-100`: execute at `90-100`, execute with warning assumptions at `70-89`, and ask a survey below `70` using `ttb-skill-shared/templates/ttb-clarification-survey.md`.
- Support English, Vietnamese, mixed-language, diacritic-free Vietnamese, and light typo prompts.

Fallback-only route for full SwiftUI screens that cannot be expressed accurately with TTBaseSUI components.

Use `/ttb-sui-screen` first unless the required UI needs custom drawing, advanced gestures, charting, complex animation, or a layout primitive that TTBaseSUI does not provide.

## Trigger

Use this prompt when the request means: native SwiftUI screen, custom SwiftUI layout, chart screen, advanced animation screen, complex gesture screen, `màn hình native SwiftUI`, `man hinh native SwiftUI`, `layout SwiftUI phức tạp`, or `custom animation SwiftUI`.

Before coding, document which TTBaseSUI equivalent is missing.

## Input Fidelity

When the user provides an image or detailed description, match the requested layout with native SwiftUI while preserving TTBaseUIKit token usage. Do not simplify custom visuals into generic rows or cards if the reference requires a bespoke layout.

## Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active
//  {Name}Screen.swift
//  {AppName}
//  FALLBACK: Native SwiftUI because TTBaseSUI lacks {missing_component_or_behavior}.
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
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: TTSize.P_CONS_DEF) {
                    headerSection
                    contentSection
                }
                .padding(TTSize.P_CONS_DEF * 2)
            }
            .background(TTView.viewBgColor.toColor())
        }
        .onAppear { vm.fetchData() }
    }
}

// MARK: - Subviews
private extension {Name}Screen {

    private var headerSection: some View {
        Text(XText("App.{Name}.Header"))
            .font(.system(size: TTFont.HEADER_H, weight: .bold))
            .foregroundColor(TTView.textDefColor.toColor())
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var contentSection: some View {
        VStack(alignment: .leading, spacing: TTSize.P_CONS_DEF) {
            Button {
                vm.performAction()
            } label: {
                Text(XText("App.{Name}.Action.Title"))
                    .font(.system(size: TTFont.TITLE_H, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: TTSize.H_BUTTON)
                    .background(TTView.buttonBgDef.toColor())
                    .clipShape(RoundedRectangle(cornerRadius: TTSize.CORNER_BUTTON))
            }
            .buttonStyle(PlainButtonStyle())
            .accessibilityLabel(XText("App.{Name}.Action.Title"))
        }
    }
}

// MARK: - Preview
struct {Name}Screen_Previews: PreviewProvider {
    static var previews: some View {
        {Name}Screen()
    }
}
```

## Native SwiftUI Token Rules

Use standard SwiftUI primitives, but style them only with TTBaseUIKit tokens:

```swift
TTView.viewBgColor.toColor()
TTView.viewBgCellColor.toColor()
TTView.textDefColor.toColor()
TTView.textSubTitleColor.toColor()
TTView.buttonBgDef.toColor()
TTView.iconColor.toColor()

TTSize.P_CONS_DEF
TTSize.P_XS
TTSize.P_L
TTSize.H_BUTTON
TTSize.H_TEXTFIELD
TTSize.CORNER_RADIUS
TTSize.CORNER_PANEL
TTSize.CORNER_BUTTON

TTFont.HEADER_H
TTFont.TITLE_H
TTFont.SUB_TITLE_H
TTFont.SUB_SUB_TITLE_H
```

## Rules

1. Full screens still use `SUIBaseView`.
2. Use native `Text`, `Button`, `VStack`, `HStack`, `ZStack`, `ScrollView`, `GeometryReader`, `Canvas`, or shape APIs only when TTBaseSUI cannot satisfy the requirement.
3. Use TTBaseUIKit tokens for colors, spacing, corner radius, and fonts.
4. Prefer chainable TTBaseUIKit extensions where they do not conflict with native layout.
5. iOS 14-compatible APIs only:
   - Use `foregroundColor`, not `foregroundStyle`.
   - Use `clipShape(RoundedRectangle(cornerRadius:))`, not `.clipShape(.rect())`.
   - Use `ScrollView(showsIndicators:)`, not `.scrollIndicators`.
   - Use `PreviewProvider`, not `#Preview`.
   - Use `.onAppear`, not `.task`.
   - Use `ObservableObject` and `@Published`, not `@Observable`.
6. Use `Button` for tappable controls; do not substitute `onTapGesture` for buttons.
7. Keep tap targets at least 44 x 44 points.
8. Extract subviews when `body` exceeds roughly 40 lines.
9. Document the missing TTBaseSUI component or behavior in implementation notes.
10. Keep output faithful to the provided image or written requirements.

## Verification

After implementation:

1. Register new Swift files in the Xcode target.
2. Run the repository build verification command or shared `ttb-verify.sh` script when present.
3. Run the shared compliance check script when present.
4. Complete only when the build succeeds, or report exact blockers after three repair attempts.
