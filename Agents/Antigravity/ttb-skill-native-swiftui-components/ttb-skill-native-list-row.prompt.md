---
description: "Build native SwiftUI list row components: icon row, switch row, stepper row, disclosure row. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-list-row — Native SwiftUI List Row Component Builder

Build reusable list row native SwiftUI components using TTBaseUIKit design tokens.

## Mandatory Preflight Execution Gate

Before generating code or modifying files, run `ttb-skill-shared/fragments/ttb-preflight-execution-gate.frag.md`.

Required checks:

- Analyze intent, task type, scope, impacted files/modules, dependencies, architecture constraints, coding standards, and project-specific rules.
- Validate required inputs such as target module, screen/component name, file location, navigation flow, expected output, API contract, state management, routing, localization, naming, and reusable component requirements.
- Detect ambiguity, conflicting requirements, incomplete business logic, unclear UX/navigation, unclear module ownership, and unclear architecture direction.
- Score confidence from `0-100`: execute at `90-100`, execute with warning assumptions at `70-89`, and ask a survey below `70` using `ttb-skill-shared/templates/ttb-clarification-survey.md`.
- Support English, Vietnamese, mixed-language, diacritic-free Vietnamese, and light typo prompts.

## When

User says: "native list row", "list row component", "settings row", "table row", "switch row", "disclosure row"

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

## List Row Component Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  Components/ListRow/{Name}ListRow.swift
//  {AppName}
//

import SwiftUI
import TTBaseUIKit

// MARK: - {Name}IconListRow
public struct {Name}IconListRow: View {
    public let iconName: String
    public let titleKey: String
    public let subtitleKey: String?
    public var onTap: (() -> Void)?

    public init(
        iconName: String,
        titleKey: String,
        subtitleKey: String? = nil,
        onTap: (() -> Void)? = nil
    ) {
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
                    .font(.system(size: TTSize.H_SMALL_ICON * 0.6))
                    .foregroundColor(TTView.buttonBgDef.toColor())
                    .frame(width: TTSize.H_SMALL_ICON, height: TTSize.H_SMALL_ICON)
                    .bg(byDef: TTView.buttonBgDef.toColor().opacity(0.12))
                    .corner(byDef: TTSize.CORNER_RADIUS)

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
            .pVertical(TTSize.P_CONS_DEF)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - {Name}SwitchListRow
public struct {Name}SwitchListRow: View {
    public let titleKey: String
    public let subtitleKey: String?
    @Binding public var isOn: Bool
    public var isDisabled: Bool = false

    public init(titleKey: String, subtitleKey: String? = nil, isOn: Binding<Bool>, isDisabled: Bool = false) {
        self.titleKey = titleKey
        self.subtitleKey = subtitleKey
        self._isOn = isOn
        self.isDisabled = isDisabled
    }

    public var body: some View {
        HStack(spacing: TTSize.P_CONS_DEF) {
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

            Toggle("", isOn: self.$isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: TTView.buttonBgDef.toColor()))
                .disabled(self.isDisabled)
        }
        .pVertical(TTSize.P_CONS_DEF)
        .opacity(self.isDisabled ? 0.5 : 1.0)
        .accessibilityLabel(String(format: XText("Accessibility.Switch.State.Format"), XText(self.titleKey), self.isOn ? XText("Accessibility.State.On") : XText("Accessibility.State.Off")))
    }
}

// MARK: - {Name}DisclosureListRow
public struct {Name}DisclosureListRow: View {
    public let iconName: String
    public let iconColor: Color
    public let titleKey: String
    public let valueKey: String?
    public var onTap: (() -> Void)?

    public init(
        iconName: String,
        iconColor: Color = TTView.buttonBgDef.toColor(),
        titleKey: String,
        valueKey: String? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.iconName = iconName
        self.iconColor = iconColor
        self.titleKey = titleKey
        self.valueKey = valueKey
        self.onTap = onTap
    }

    public var body: some View {
        Button {
            self.onTap?()
        } label: {
            HStack(spacing: TTSize.P_CONS_DEF) {
                Image(systemName: self.iconName)
                    .font(.system(size: TTSize.H_SMALL_ICON * 0.6))
                    .foregroundColor(self.iconColor)
                    .frame(width: TTSize.H_SMALL_ICON, height: TTSize.H_SMALL_ICON)
                    .bg(byDef: self.iconColor.opacity(0.12))
                    .corner(byDef: TTSize.CORNER_RADIUS)

                Text(XText(self.titleKey))
                    .font(.system(size: TTFont.TITLE_H, weight: .medium))
                    .foregroundColor(TTView.textDefColor.toColor())

                Spacer()

                if let valueKey = self.valueKey {
                    Text(XText(valueKey))
                        .font(.system(size: TTFont.SUB_TITLE_H, weight: .regular))
                        .foregroundColor(TTView.textSubTitleColor.toColor())
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: TTFont.SUB_TITLE_H))
                    .foregroundColor(TTView.iconColor.toColor())
            }
            .pVertical(TTSize.P_CONS_DEF)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - {Name}StepperListRow
public struct {Name}StepperListRow: View {
    public let titleKey: String
    @Binding public var value: Int
    public var range: ClosedRange<Int> = 0...100
    public var step: Int = 1
    public var valueFormatter: ((Int) -> String)?

    public init(
        titleKey: String,
        value: Binding<Int>,
        range: ClosedRange<Int> = 0...100,
        step: Int = 1,
        valueFormatter: ((Int) -> String)? = nil
    ) {
        self.titleKey = titleKey
        self._value = value
        self.range = range
        self.step = step
        self.valueFormatter = valueFormatter
    }

    private var displayValue: String {
        self.valueFormatter?(self.value) ?? "\(self.value)"
    }

    public var body: some View {
        HStack(spacing: TTSize.P_CONS_DEF) {
            Text(XText(self.titleKey))
                .font(.system(size: TTFont.TITLE_H, weight: .medium))
                .foregroundColor(TTView.textDefColor.toColor())

            Spacer()

            HStack(spacing: TTSize.P_CONS_DEF) {
                Button {
                    if self.value - self.step >= self.range.lowerBound {
                        self.value -= self.step
                    }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: TTSize.H_SMALL_ICON * 0.8))
                        .foregroundColor(TTView.buttonBgDef.toColor())
                }
                .disabled(self.value <= self.range.lowerBound)

                Text(self.displayValue)
                    .font(.system(size: TTFont.TITLE_H, weight: .semibold))
                    .foregroundColor(TTView.textDefColor.toColor())
                    .frame(minWidth: 32)

                Button {
                    if self.value + self.step <= self.range.upperBound {
                        self.value += self.step
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: TTSize.H_SMALL_ICON * 0.8))
                        .foregroundColor(TTView.buttonBgDef.toColor())
                }
                .disabled(self.value >= self.range.upperBound)
            }
        }
        .pVertical(TTSize.P_CONS_DEF)
        .accessibilityLabel(String(format: XText("Accessibility.Stepper.Value.Format"), XText(self.titleKey), self.displayValue))
    }
}

// MARK: - Preview
struct {Name}ListRow_Previews: PreviewProvider {
    @State static var isEnabled = true
    @State static var count = 5

    static var previews: some View {
        VStack(spacing: 0) {
            {Name}IconListRow(
                iconName: "person.fill",
                titleKey: "Settings.Account.Title",
                subtitleKey: "Settings.Account.Subtitle"
            ) { }

            Divider().pLeading(TTSize.P_CONS_DEF * 5)

            {Name}SwitchListRow(
                titleKey: "Settings.Notifications.Title",
                subtitleKey: "Settings.Notifications.Subtitle",
                isOn: $isEnabled
            )

            Divider().pLeading(TTSize.P_CONS_DEF * 5)

            {Name}DisclosureListRow(
                iconName: "globe",
                iconColor: TTView.colorSuccess.toColor(),
                titleKey: "Language",
                value: "English"
            ) { }

            Divider().pLeading(TTSize.P_CONS_DEF * 5)

            {Name}StepperListRow(
                titleKey: "Quantity",
                value: $count,
                range: 1...99,
                step: 1
            ) { "\($0) items" }
        }
        .pHorizontal(TTSize.P_L)
        .bg(byDef: TTView.viewBgCellColor.toColor())
        .corner(byDef: TTSize.CORNER_PANEL)
        .baseShadow()
        .pAll(TTSize.P_L)
        .bg(byDef: TTView.viewBgColor.toColor())
    }
}
```

## Rules

1. **100% native SwiftUI primitives** — no `TTBaseSUI*`, `SUIBaseView`, or `TTBaseNavigationLink` wrappers in `/native-*` components
2. **TTBaseUIKit tokens + chainable modifiers**: `TTView.*.toColor()`, `TTSize.*`, `TTFont.*`, `.pAll()`, `.bg()`, `.corner()`, `.baseShadow()`, `.size()`
3. **Icon container**: 30x30pt with 0.12 opacity bg + CORNER_RADIUS
4. **Spacing**: `TTSize.P_CONS_DEF` between icon and text
5. **Vertical padding**: `TTSize.P_CONS_DEF` for each row
6. **Use `Toggle`** with `labelsHidden()` for switch rows
7. **Use `Button` with `.buttonStyle(.plain)`** for tappable rows
8. **Use `.contentShape(Rectangle())`** for full-row tap targets
9. **Accessibility**: `.accessibilityLabel()` on all interactive rows
10. **Divider** between rows with `.pLeading(TTSize.P_CONS_DEF * 5)` indent
11. **PreviewProvider** at bottom
12. **MARKER COMMENT** at top

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
