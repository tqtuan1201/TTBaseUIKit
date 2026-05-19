---
description: "Build native SwiftUI list row components: icon row, switch row, stepper row, disclosure row. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-list-row — Native SwiftUI List Row Component Builder

Build reusable list row native SwiftUI components using TTBaseUIKit design tokens.

## When

User says: "native list row", "list row component", "settings row", "table row", "switch row", "disclosure row"

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
    public let title: String
    public let subtitle: String?
    public var trailing: (() -> AnyView)?
    public var onTap: (() -> Void)?

    public init(
        iconName: String,
        title: String,
        subtitle: String? = nil,
        trailing: (() -> AnyView)? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.iconName = iconName
        self.title = title
        self.subtitle = subtitle
        self.trailing = trailing
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
                    .background(TTView.buttonBgDef.toColor().opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: TTSize.CORNER_RADIUS))

                VStack(alignment: .leading, spacing: TTSize.P_S / 2) {
                    Text(self.title)
                        .font(.system(size: TTFont.TITLE_H, weight: .medium))
                        .foregroundColor(TTView.textDefColor.toColor())
                    if let subtitle = self.subtitle {
                        Text(subtitle)
                            .font(.system(size: TTFont.SUB_TITLE_H, weight: .regular))
                            .foregroundColor(TTView.textSubTitleColor.toColor())
                    }
                }

                Spacer()

                if let trailing = self.trailing {
                    trailing()
                } else {
                    Image(systemName: "chevron.right")
                        .font(.system(size: TTFont.SUB_TITLE_H))
                        .foregroundColor(TTView.iconColor.toColor())
                }
            }
            .padding(.vertical, TTSize.P_CONS_DEF)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - {Name}SwitchListRow
public struct {Name}SwitchListRow: View {
    public let title: String
    public let subtitle: String?
    @Binding public var isOn: Bool
    public var isDisabled: Bool = false

    public init(title: String, subtitle: String? = nil, isOn: Binding<Bool>, isDisabled: Bool = false) {
        self.title = title
        self.subtitle = subtitle
        self._isOn = isOn
        self.isDisabled = isDisabled
    }

    public var body: some View {
        HStack(spacing: TTSize.P_CONS_DEF) {
            VStack(alignment: .leading, spacing: TTSize.P_S / 2) {
                Text(self.title)
                    .font(.system(size: TTFont.TITLE_H, weight: .medium))
                    .foregroundColor(TTView.textDefColor.toColor())
                if let subtitle = self.subtitle {
                    Text(subtitle)
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
        .padding(.vertical, TTSize.P_CONS_DEF)
        .opacity(self.isDisabled ? 0.5 : 1.0)
        .accessibilityLabel("\(self.title), \(self.isOn ? "on" : "off")")
    }
}

// MARK: - {Name}DisclosureListRow
public struct {Name}DisclosureListRow: View {
    public let iconName: String
    public let iconColor: Color
    public let title: String
    public let value: String?
    public var onTap: (() -> Void)?

    public init(
        iconName: String,
        iconColor: Color = TTView.buttonBgDef.toColor(),
        title: String,
        value: String? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.iconName = iconName
        self.iconColor = iconColor
        self.title = title
        self.value = value
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
                    .background(self.iconColor.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: TTSize.CORNER_RADIUS))

                Text(self.title)
                    .font(.system(size: TTFont.TITLE_H, weight: .medium))
                    .foregroundColor(TTView.textDefColor.toColor())

                Spacer()

                if let value = self.value {
                    Text(value)
                        .font(.system(size: TTFont.SUB_TITLE_H, weight: .regular))
                        .foregroundColor(TTView.textSubTitleColor.toColor())
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: TTFont.SUB_TITLE_H))
                    .foregroundColor(TTView.iconColor.toColor())
            }
            .padding(.vertical, TTSize.P_CONS_DEF)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - {Name}StepperListRow
public struct {Name}StepperListRow: View {
    public let title: String
    @Binding public var value: Int
    public var range: ClosedRange<Int> = 0...100
    public var step: Int = 1
    public var valueFormatter: ((Int) -> String)?

    public init(
        title: String,
        value: Binding<Int>,
        range: ClosedRange<Int> = 0...100,
        step: Int = 1,
        valueFormatter: ((Int) -> String)? = nil
    ) {
        self.title = title
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
            Text(self.title)
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
        .padding(.vertical, TTSize.P_CONS_DEF)
        .accessibilityLabel("\(self.title), value \(self.displayValue)")
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
                title: "Account",
                subtitle: "Manage your account"
            ) { }

            Divider().padding(.leading, TTSize.P_CONS_DEF * 5)

            {Name}SwitchListRow(
                title: "Notifications",
                subtitle: "Receive push notifications",
                isOn: $isEnabled
            )

            Divider().padding(.leading, TTSize.P_CONS_DEF * 5)

            {Name}DisclosureListRow(
                iconName: "globe",
                iconColor: TTView.colorSuccess.toColor(),
                title: "Language",
                value: "English"
            ) { }

            Divider().padding(.leading, TTSize.P_CONS_DEF * 5)

            {Name}StepperListRow(
                title: "Quantity",
                value: $count,
                range: 1...99,
                step: 1
            ) { "\($0) items" }
        }
        .padding(.horizontal, TTSize.P_L)
        .background(TTView.viewBgCellColor.toColor())
        .clipShape(RoundedRectangle(cornerRadius: TTSize.CORNER_PANEL))
        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
        .padding(TTSize.P_L)
        .background(TTView.viewBgColor.toColor())
    }
}
```

## Rules

1. **100% native SwiftUI** — no TTBaseSUI* wrappers
2. **TTBaseUIKit tokens**: `TTView.*.toColor()`, `TTSize.*`, `TTFont.*`
3. **Icon container**: 30x30pt with 0.12 opacity bg + CORNER_RADIUS
4. **Spacing**: `TTSize.P_CONS_DEF` between icon and text
5. **Vertical padding**: `TTSize.P_CONS_DEF` for each row
6. **Use `Toggle`** with `labelsHidden()` for switch rows
7. **Use `Button` with `.buttonStyle(.plain)`** for tappable rows
8. **Use `.contentShape(Rectangle())`** for full-row tap targets
9. **Accessibility**: `.accessibilityLabel()` on all interactive rows
10. **Divider** between rows with `.padding(.leading, TTSize.P_CONS_DEF * 5)` indent
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
