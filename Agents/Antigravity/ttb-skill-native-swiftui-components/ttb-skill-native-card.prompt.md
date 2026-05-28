---
description: "Build native SwiftUI card components: tappable card, static card, action card. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-card — Native SwiftUI Card Component Builder

Build reusable card native SwiftUI components using TTBaseUIKit design tokens.

## Mandatory Preflight Execution Gate

Before generating code or modifying files, run `ttb-skill-shared/fragments/ttb-preflight-execution-gate.frag.md`.

Required checks:

- Analyze intent, task type, scope, impacted files/modules, dependencies, architecture constraints, coding standards, and project-specific rules.
- Validate required inputs such as target module, screen/component name, file location, navigation flow, expected output, API contract, state management, routing, localization, naming, and reusable component requirements.
- Detect ambiguity, conflicting requirements, incomplete business logic, unclear UX/navigation, unclear module ownership, and unclear architecture direction.
- Score confidence from `0-100`: execute at `90-100`, execute with warning assumptions at `70-89`, and ask a survey below `70` using `ttb-skill-shared/templates/ttb-clarification-survey.md`.
- Support English, Vietnamese, mixed-language, diacritic-free Vietnamese, and light typo prompts.

## When

User says: "native card", "card component", "tappable card", "action card", "static card"

## Native SwiftUI Compliance Baseline

These rules override any older examples in this prompt:

1. **100% native SwiftUI primitives** inside generated `/native-*` components: use `Text`, `Button`, `VStack`, `HStack`, `Image`, native controls, shapes, and modifiers; do not use `TTBaseSUI*`, `SUIBaseView`, or `TTBaseNavigationLink` here.
2. **TTBaseUIKit project rules still apply**: follow the current project folder structure, file header marker, `MARK` sections, access control, Xcode project registration, and verification scripts.
3. **Displayed strings must use `XText("key")`**. Prefer API names like `titleKey`, `textKey`, `placeholderKey`, `accessibilityKey`, and `hintKey`. Convert raw sample strings to localization keys before emitting production code.
4. **Use `TTView`, `TTSize`, and `TTFont` tokens** for colors, spacing, radii, heights, and fonts. Do not hardcode design values unless needed for geometry math.
5. **Chainable modifiers are mandatory where available**: prefer `.pAll()`, `.pHorizontal()`, `.pVertical()`, `.bg()`, `.corner()`, `.baseShadow()`, `.baseBorder()`, `.size()`, `.sizeSquare()`, `.maxWidth()`, and `.maxHeight()` over raw `.padding`, `.background`, `.clipShape`, `.frame` chains when the extension covers the behavior.
6. **Use `Button` or native controls for all tappable UI**. Do not use `.onTapGesture` as a button substitute; `.onTapHandle` is only allowed for real non-control gestures.
7. **Minimum tap target is 44x44** for every interactive element.
8. **`@StateObject` for owned ViewModels, `@ObservedObject` for injected ViewModels**. Do not instantiate observable objects inside `body`.
9. **Use `[weak self]` in every escaping closure inside classes/ViewModels/coordinators/services**. SwiftUI `View` structs should call injected closures/private methods without strongly capturing reference objects.
10. **Keep `body` under 40 lines**. Extract private computed subviews, helper methods, or private `View` structs.
11. **iOS 14+ only**: no `.task`, `NavigationStack`, `#Preview`, `.foregroundStyle()`, `AsyncImage`, or other iOS 15+ APIs.
12. **Accessibility is mandatory**: use `.accessibilityLabel(XText(...))` and `.accessibilityHint(XText(...))` for interactive or non-obvious UI.

## Card Component Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  Components/Card/{Name}Card.swift
//  {AppName}
//

import SwiftUI
import TTBaseUIKit

// MARK: - {Name}TappableCard
public struct {Name}TappableCard<Content: View>: View {
    public let content: () -> Content
    public var onTap: (() -> Void)?

    public init(onTap: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.onTap = onTap
        self.content = content
    }

    public var body: some View {
        Button {
            self.onTap?()
        } label: {
            self.content()
                .pAll(TTSize.P_CONS_DEF)
                .bg(byDef: TTView.viewBgCellColor.toColor())
                .corner(byDef: TTSize.CORNER_PANEL)
                .baseShadow()
        }
        .buttonStyle(.plain)
    }
}

// MARK: - {Name}StaticCard
public struct {Name}StaticCard<Content: View>: View {
    public let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        self.content()
            .pAll(TTSize.P_CONS_DEF)
            .bg(byDef: TTView.viewBgCellColor.toColor())
            .corner(byDef: TTSize.CORNER_PANEL)
            .baseShadow()
    }
}

// MARK: - {Name}ActionCard
public struct {Name}ActionCard: View {
    public let titleKey: String
    public let subtitleKey: String?
    public let iconName: String?
    public var buttonTitleKey: String?
    public var onTap: (() -> Void)?
    public var onAction: (() -> Void)?

    public init(
        titleKey: String,
        subtitleKey: String? = nil,
        iconName: String? = nil,
        buttonTitleKey: String? = nil,
        onTap: (() -> Void)? = nil,
        onAction: (() -> Void)? = nil
    ) {
        self.titleKey = titleKey
        self.subtitleKey = subtitleKey
        self.iconName = iconName
        self.buttonTitleKey = buttonTitleKey
        self.onTap = onTap
        self.onAction = onAction
    }

    public var body: some View {
        {Name}TappableCard(onTap: self.onTap) {
            VStack(alignment: .leading, spacing: TTSize.P_CONS_DEF) {
                if let iconName = self.iconName {
                    Image(systemName: iconName)
                        .font(.system(size: TTSize.H_SMALL_ICON))
                        .foregroundColor(TTView.buttonBgDef.toColor())
                }

                Text(XText(self.titleKey))
                    .font(.system(size: TTFont.HEADER_H, weight: .bold))
                    .foregroundColor(TTView.textHeaderColor.toColor())

                if let subtitleKey = self.subtitleKey {
                    Text(XText(subtitleKey))
                        .font(.system(size: TTFont.TITLE_H, weight: .regular))
                        .foregroundColor(TTView.textDefColor.toColor())
                }

                if let buttonTitleKey = self.buttonTitleKey, let onAction = self.onAction {
                    Button(action: onAction) {
                        Text(XText(buttonTitleKey))
                            .font(.system(size: TTFont.TITLE_H, weight: .semibold))
                            .foregroundColor(TTView.buttonBgDef.toColor())
                    }
                    .pTop(TTSize.P_S)
                }
            }
        }
    }
}

// MARK: - {Name}CardRow
public struct {Name}CardRow: View {
    public let iconName: String
    public let titleKey: String
    public let subtitleKey: String?
    public var onTap: (() -> Void)?

    public init(iconName: String, titleKey: String, subtitleKey: String? = nil, onTap: (() -> Void)? = nil) {
        self.iconName = iconName
        self.titleKey = titleKey
        self.subtitleKey = subtitleKey
        self.onTap = onTap
    }

    public var body: some View {
        Button {
            self.onTap?()
        } label: {
            HStack(spacing: TTSize.P_CONS_DEF) {
                Image(systemName: self.iconName)
                    .font(.system(size: TTSize.H_SMALL_ICON))
                    .foregroundColor(TTView.buttonBgDef.toColor())
                    .frame(width: TTSize.H_SMALL_ICON, height: TTSize.H_SMALL_ICON)

                VStack(alignment: .leading, spacing: TTSize.P_S / 2) {
                    Text(XText(self.titleKey))
                        .font(.system(size: TTFont.TITLE_H, weight: .medium))
                        .foregroundColor(TTView.textDefColor.toColor())
                    if let subtitleKey = self.subtitleKey {
                        Text(XText(subtitleKey))
                            .font(.system(size: TTFont.SUB_TITLE_H, weight: .regular))
                            .foregroundColor(TTView.textSubTitleColor.toColor())
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: TTFont.SUB_TITLE_H))
                    .foregroundColor(TTView.iconColor.toColor())
            }
            .pAll(TTSize.P_CONS_DEF)
            .bg(byDef: TTView.viewBgCellColor.toColor())
            .corner(byDef: TTSize.CORNER_PANEL)
            .baseShadow()
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
struct {Name}Card_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: TTSize.P_L) {
                {Name}TappableCard {
                    HStack {
                        Text(XText("Preview.Card.TappableContent"))
                            .font(.system(size: TTFont.TITLE_H))
                        Spacer()
                        Image(systemName: "arrow.right")
                    }
                }
                .onTapHandle { }

                {Name}StaticCard {
                    Text(XText("Preview.Card.StaticContent"))
                        .font(.system(size: TTFont.TITLE_H))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                {Name}ActionCard(
                    titleKey: "Preview.Card.GetStarted.Title",
                    subtitleKey: "Preview.Card.GetStarted.Subtitle",
                    iconName: "star.fill",
                    buttonTitleKey: "Common.Action.GetStarted"
                ) { } onAction: { }

                {Name}CardRow(
                    iconName: "person.circle.fill",
                    titleKey: "Preview.Card.Profile.Title",
                    subtitleKey: "Preview.Card.Profile.Subtitle"
                ) { }
            }
            .pAll(TTSize.P_L)
        }
        .bg(byDef: TTView.viewBgColor.toColor())
    }
}
```

## Rules

1. **100% native SwiftUI primitives** — no `TTBaseSUI*`, `SUIBaseView`, or `TTBaseNavigationLink` wrappers in `/native-*` components
2. **TTBaseUIKit tokens + chainable modifiers**: `TTView.*.toColor()`, `TTSize.*`, `TTFont.*`, `.pAll()`, `.bg()`, `.corner()`, `.baseShadow()`, `.size()`
3. **Card background**: `TTView.viewBgCellColor.toColor()` — white
4. **Corner radius = TTSize.CORNER_PANEL (8pt)** — panel/card corner
5. **Shadow = `.opacity(0.08), radius: 4, x: 0, y: 2`** — subtle card shadow
6. **Padding = TTSize.P_CONS_DEF (8pt)** — internal padding
7. **Use `Button`** for tappable cards — `.buttonStyle(.plain)` to remove button styling
8. **Body < 40 lines** — extract complex content
9. **PreviewProvider** at bottom
10. **MARKER COMMENT** at top

## Card Type Guide

| Card Type | Interactive | Shadow | Corner | Usage |
|-----------|------------|--------|--------|-------|
| TappableCard | Yes (onTap) | Yes | 8pt | List item, selectable |
| StaticCard | No | Yes | 8pt | Display info, static content |
| ActionCard | Yes (onTap) + action button | Yes | 8pt | CTA with header + button |
| CardRow | Yes (onTap) | Yes | 8pt | Icon + text + chevron row |

## Post-Implementation Verification

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
4. **Skill is complete only when** `✅ BUILD SUCCEEDED`

**Anti-Loop**: Max 3 build attempts. 3 failures → STOP, document errors.

For full FCR 7-Dimension scoring, see `ttb-skill-shared/phases/ttb-phase-verify.md`.
