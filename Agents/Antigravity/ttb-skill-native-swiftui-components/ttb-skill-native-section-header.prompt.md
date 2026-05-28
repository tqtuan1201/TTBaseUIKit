---
description: "Build native SwiftUI section header component with title, subtitle, and action button. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-section-header — Native SwiftUI Section Header Component Builder

Build reusable section header native SwiftUI components using TTBaseUIKit design tokens.

## Mandatory Preflight Execution Gate

Before generating code or modifying files, run `ttb-skill-shared/fragments/ttb-preflight-execution-gate.frag.md`.

Required checks:

- Analyze intent, task type, scope, impacted files/modules, dependencies, architecture constraints, coding standards, and project-specific rules.
- Validate required inputs such as target module, screen/component name, file location, navigation flow, expected output, API contract, state management, routing, localization, naming, and reusable component requirements.
- Detect ambiguity, conflicting requirements, incomplete business logic, unclear UX/navigation, unclear module ownership, and unclear architecture direction.
- Score confidence from `0-100`: execute at `90-100`, execute with warning assumptions at `70-89`, and ask a survey below `70` using `ttb-skill-shared/templates/ttb-clarification-survey.md`.
- Support English, Vietnamese, mixed-language, diacritic-free Vietnamese, and light typo prompts.

## When

User says: "native section header", "section title", "list header", "group header"

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

## Section Header Component Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  Components/Section/{Name}SectionHeader.swift
//  {AppName}
//

import SwiftUI
import TTBaseUIKit

// MARK: - {Name}SectionHeader
public struct {Name}SectionHeader: View {
    public let titleKey: String
    public var subtitleKey: String?
    public var actionTitleKey: String?
    public var actionIcon: String?
    public var onAction: (() -> Void)?

    public init(
        titleKey: String,
        subtitleKey: String? = nil,
        actionTitleKey: String? = nil,
        actionIcon: String? = nil,
        onAction: (() -> Void)? = nil
    ) {
        self.titleKey = titleKey
        self.subtitleKey = subtitleKey
        self.actionTitleKey = actionTitleKey
        self.actionIcon = actionIcon
        self.onAction = onAction
    }

    public var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: TTSize.P_S / 2) {
                Text(XText(self.titleKey))
                    .font(.system(size: TTFont.SUB_TITLE_H, weight: .semibold))
                    .foregroundColor(TTView.textSubTitleColor.toColor())
                    .textCase(.uppercase)

                if let subtitleKey = self.subtitleKey {
                    Text(XText(subtitleKey))
                        .font(.system(size: TTFont.SUB_TITLE_H, weight: .regular))
                        .foregroundColor(TTView.textSubTitleColor.toColor().opacity(0.7))
                }
            }

            Spacer()

            if let actionTitleKey = self.actionTitleKey {
                Button(action: { self.onAction?() }) {
                    HStack(spacing: TTSize.P_S / 2) {
                        if let actionIcon = self.actionIcon {
                            Image(systemName: actionIcon)
                                .font(.system(size: TTFont.SUB_TITLE_H))
                        }
                        Text(XText(actionTitleKey))
                            .font(.system(size: TTFont.SUB_TITLE_H, weight: .medium))
                    }
                    .foregroundColor(TTView.buttonBgDef.toColor())
                }
                .accessibilityLabel(String(format: XText("Accessibility.Section.Action.Format"), XText(actionTitleKey), XText(self.titleKey)))
            }
        }
        .pHorizontal(TTSize.P_L)
        .pVertical(TTSize.P_CONS_DEF)
    }
}

// MARK: - {Name}SectionFooter
public struct {Name}SectionFooter: View {
    public let textKey: String
    public var textColor: Color = TTView.textSubTitleColor.toColor().opacity(0.7)

    public init(_ textKey: String, textColor: Color? = nil) {
        self.textKey = textKey
        if let tc = textColor { self.textColor = tc }
    }

    public var body: some View {
        Text(XText(self.textKey))
            .font(.system(size: TTFont.SUB_TITLE_H, weight: .regular))
            .foregroundColor(self.textColor)
            .frame(maxWidth: .infinity, alignment: .leading)
            .pHorizontal(TTSize.P_L)
            .pVertical(TTSize.P_S)
    }
}

// MARK: - {Name}ListSection
public struct {Name}ListSection<Content: View>: View {
    public var headerKey: String?
    public var footerKey: String?
    public var content: () -> Content

    public init(
        headerKey: String? = nil,
        footerKey: String? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.headerKey = headerKey
        self.footerKey = footerKey
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let headerKey = self.headerKey {
                {Name}SectionHeader(titleKey: headerKey)
            }

            self.content()

            if let footerKey = self.footerKey {
                {Name}SectionFooter(textKey: footerKey)
            }
        }
    }
}

// MARK: - Preview
struct {Name}SectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            {Name}SectionHeader(titleKey: "Settings.Account.Title", actionTitleKey: "Common.Action.Edit", actionIcon: "pencil") { }

            VStack(spacing: 0) {
                HStack {
                    Text(XText("Preview.Row.One"))
                    Spacer()
                }
                .pAll(TTSize.P_L)
                Divider()
                HStack {
                    Text(XText("Preview.Row.Two"))
                    Spacer()
                }
                .pAll(TTSize.P_L)
            }
            .bg(byDef: TTView.viewBgCellColor.toColor())

            {Name}SectionHeader(titleKey: "Settings.Notifications.Title", subtitleKey: "Settings.Notifications.Subtitle")

            VStack(spacing: 0) {
                HStack {
                    Text(XText("Preview.Row.One"))
                    Spacer()
                }
                .pAll(TTSize.P_L)
            }
            .bg(byDef: TTView.viewBgCellColor.toColor())

            {Name}ListSection(headerKey: "Settings.Security.Title", footerKey: "Settings.Security.FooterLastUpdated") {
                VStack(spacing: 0) {
                    HStack {
                        Text(XText("Settings.Security.ChangePassword"))
                        Spacer()
                    }
                    .pAll(TTSize.P_L)
                    Divider()
                    HStack {
                        Text(XText("Settings.Security.TwoFactor"))
                        Spacer()
                    }
                    .pAll(TTSize.P_L)
                }
                .bg(byDef: TTView.viewBgCellColor.toColor())
            }
        }
        .bg(byDef: TTView.viewBgColor.toColor())
    }
}
```

## Rules

1. **100% native SwiftUI primitives** — no `TTBaseSUI*`, `SUIBaseView`, or `TTBaseNavigationLink` wrappers in `/native-*` components
2. **TTBaseUIKit tokens + chainable modifiers**: `TTView.*.toColor()`, `TTSize.*`, `TTFont.*`, `.pAll()`, `.bg()`, `.corner()`, `.baseShadow()`, `.size()`
3. **Title**: uppercase via `.textCase(.uppercase)`, semibold, `TTView.textSubTitleColor`
4. **Subtitle**: 0.7 opacity, regular weight
5. **Action**: optional icon + text button, right-aligned
6. **ListSection**: composable wrapper combining header + content + footer
7. **Horizontal padding**: `TTSize.P_L (16pt)` for header/footer
8. **Vertical padding**: `TTSize.P_CONS_DEF (8pt)` for spacing
9. **PreviewProvider** at bottom
10. **MARKER COMMENT** at top

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
