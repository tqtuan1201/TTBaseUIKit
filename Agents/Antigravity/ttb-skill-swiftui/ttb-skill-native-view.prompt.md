---
description: "Scaffold a native SwiftUI reusable view using standard SwiftUI primitives with TTBaseUIKit tokens. Fallback only when TTBaseSUI has no equivalent. Supports English and Vietnamese prompt intents. iOS 14+."
---

# ttb-skill-native-view - Native SwiftUI View Builder

## Mandatory Preflight Execution Gate

Before generating code or modifying files, run `ttb-skill-shared/fragments/ttb-preflight-execution-gate.frag.md`.

Required checks:

- Analyze intent, task type, scope, impacted files/modules, dependencies, architecture constraints, coding standards, and project-specific rules.
- Validate required inputs such as target module, screen/component name, file location, navigation flow, expected output, API contract, state management, routing, localization, naming, and reusable component requirements.
- Detect ambiguity, conflicting requirements, incomplete business logic, unclear UX/navigation, unclear module ownership, and unclear architecture direction.
- Score confidence from `0-100`: execute at `90-100`, execute with warning assumptions at `70-89`, and ask a survey below `70` using `ttb-skill-shared/templates/ttb-clarification-survey.md`.
- Support English, Vietnamese, mixed-language, diacritic-free Vietnamese, and light typo prompts.

Fallback-only route for reusable SwiftUI components that cannot be expressed accurately with TTBaseSUI wrappers.

Use `/ttb-sui-view` first unless the component needs custom drawing, charting, advanced animation, advanced gestures, or a layout behavior missing from TTBaseSUI.

## Trigger

Use this prompt when the request means: native SwiftUI view, custom SwiftUI component, chart view, animated view, gesture-heavy view, bespoke layout, `native SwiftUI view`, `custom layout SwiftUI`, `view SwiftUI phức tạp`, or `bieu do SwiftUI`.

Before coding, document which TTBaseSUI equivalent is missing.

## Input Fidelity

For screenshots or detailed descriptions, preserve custom shape, animation, gesture, chart, and spatial requirements. Use native SwiftUI only for the part that requires it; keep the rest aligned with TTBaseUIKit tokens and local project conventions.

## Tappable Native Card Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active
//  CustomViews/{Name}CardView.swift
//  {AppName}
//  FALLBACK: Native SwiftUI because TTBaseSUI lacks {missing_component_or_behavior}.
//

import SwiftUI
import TTBaseUIKit

// MARK: - {Name}CardView
struct {Name}CardView: View {

    let title: String
    let subtitle: String
    var onTap: (() -> Void)?

    var body: some View {
        Button {
            onTap?()
        } label: {
            HStack(spacing: TTSize.P_CONS_DEF) {
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(TTView.iconColor.toColor())

                VStack(alignment: .leading, spacing: TTSize.P_XS) {
                    Text(title)
                        .font(.system(size: TTFont.TITLE_H, weight: .bold))
                        .foregroundColor(TTView.textDefColor.toColor())

                    Text(subtitle)
                        .font(.system(size: TTFont.SUB_TITLE_H))
                        .foregroundColor(TTView.textSubTitleColor.toColor())
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: "chevron.right")
                    .font(.system(size: TTFont.SUB_TITLE_H))
                    .foregroundColor(TTView.textSubTitleColor.toColor())
            }
            .padding(TTSize.P_CONS_DEF)
            .background(TTView.viewBgCellColor.toColor())
            .clipShape(RoundedRectangle(cornerRadius: TTSize.CORNER_PANEL))
            .shadow(color: .black.opacity(0.14), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title)
    }
}

// MARK: - Preview
struct {Name}CardView_Previews: PreviewProvider {
    static var previews: some View {
        {Name}CardView(title: "Card Title", subtitle: "Description")
            .padding()
    }
}
```

## Static Native Display Pattern

```swift
struct {Name}InfoView: View {

    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: TTSize.P_S) {
            Text(title)
                .font(.system(size: TTFont.TITLE_H, weight: .bold))
                .foregroundColor(TTView.textDefColor.toColor())

            Text(subtitle)
                .font(.system(size: TTFont.SUB_TITLE_H))
                .foregroundColor(TTView.textSubTitleColor.toColor())
        }
        .padding(TTSize.P_CONS_DEF)
        .background(TTView.viewBgCellColor.toColor())
        .clipShape(RoundedRectangle(cornerRadius: TTSize.CORNER_RADIUS))
    }
}
```

## Rules

1. Use standard SwiftUI primitives only for the missing TTBaseSUI behavior.
2. Use TTBaseUIKit tokens for colors, spacing, corner radius, and fonts.
3. Use `foregroundColor`, not `foregroundStyle`.
4. Use `clipShape(RoundedRectangle(cornerRadius:))`, not `.clipShape(.rect())`.
5. Use `PreviewProvider`, not `#Preview`.
6. Use `Button` for tappable controls; do not substitute `onTapGesture` for buttons.
7. Keep tap targets at least 44 x 44 points.
8. Add accessibility labels for images and interactive views.
9. Prefer `@ViewBuilder` or `Group` instead of `AnyView`.
10. Extract subviews when `body` exceeds roughly 40 lines.
11. Document the missing TTBaseSUI component or behavior in implementation notes.
12. Keep output faithful to the provided image or written requirements.

## Verification

After implementation:

1. Register new Swift files in the Xcode target.
2. Run the repository build verification command or shared `ttb-verify.sh` script when present.
3. Run the shared compliance check script when present.
4. Complete only when the build succeeds, or report exact blockers after three repair attempts.
