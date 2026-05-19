---
description: "Build native SwiftUI section header component with title, subtitle, and action button. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-section-header — Native SwiftUI Section Header Component Builder

Build reusable section header native SwiftUI components using TTBaseUIKit design tokens.

## When

User says: "native section header", "section title", "list header", "group header"

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
    public let title: String
    public var subtitle: String?
    public var actionTitle: String?
    public var actionIcon: String?
    public var onAction: (() -> Void)?

    public init(
        title: String,
        subtitle: String? = nil,
        actionTitle: String? = nil,
        actionIcon: String? = nil,
        onAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.actionTitle = actionTitle
        self.actionIcon = actionIcon
        self.onAction = onAction
    }

    public var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: TTSize.P_S / 2) {
                Text(self.title)
                    .font(.system(size: TTFont.SUB_TITLE_H, weight: .semibold))
                    .foregroundColor(TTView.textSubTitleColor.toColor())
                    .textCase(.uppercase)

                if let subtitle = self.subtitle {
                    Text(subtitle)
                        .font(.system(size: TTFont.SUB_TITLE_H, weight: .regular))
                        .foregroundColor(TTView.textSubTitleColor.toColor().opacity(0.7))
                }
            }

            Spacer()

            if let actionTitle = self.actionTitle {
                Button(action: { self.onAction?() }) {
                    HStack(spacing: TTSize.P_S / 2) {
                        if let actionIcon = self.actionIcon {
                            Image(systemName: actionIcon)
                                .font(.system(size: TTFont.SUB_TITLE_H))
                        }
                        Text(actionTitle)
                            .font(.system(size: TTFont.SUB_TITLE_H, weight: .medium))
                    }
                    .foregroundColor(TTView.buttonBgDef.toColor())
                }
                .accessibilityLabel("\(actionTitle), \(self.title)")
            }
        }
        .padding(.horizontal, TTSize.P_L)
        .padding(.vertical, TTSize.P_CONS_DEF)
    }
}

// MARK: - {Name}SectionFooter
public struct {Name}SectionFooter: View {
    public let text: String
    public var textColor: Color = TTView.textSubTitleColor.toColor().opacity(0.7)

    public init(_ text: String, textColor: Color? = nil) {
        self.text = text
        if let tc = textColor { self.textColor = tc }
    }

    public var body: some View {
        Text(self.text)
            .font(.system(size: TTFont.SUB_TITLE_H, weight: .regular))
            .foregroundColor(self.textColor)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, TTSize.P_L)
            .padding(.vertical, TTSize.P_S)
    }
}

// MARK: - {Name}ListSection
public struct {Name}ListSection<Content: View>: View {
    public var header: String?
    public var footer: String?
    public var content: () -> Content

    public init(
        header: String? = nil,
        footer: String? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.header = header
        self.footer = footer
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let header = self.header {
                {Name}SectionHeader(title: header)
            }

            self.content()

            if let footer = self.footer {
                {Name}SectionFooter(text: footer)
            }
        }
    }
}

// MARK: - Preview
struct {Name}SectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            {Name}SectionHeader(title: "Account Settings", actionTitle: "Edit", actionIcon: "pencil") { }

            VStack(spacing: 0) {
                HStack {
                    Text("Row 1")
                    Spacer()
                }
                .padding(TTSize.P_L)
                Divider()
                HStack {
                    Text("Row 2")
                    Spacer()
                }
                .padding(TTSize.P_L)
            }
            .background(TTView.viewBgCellColor.toColor())

            {Name}SectionHeader(title: "Notifications", subtitle: "Manage your notification preferences")

            VStack(spacing: 0) {
                HStack {
                    Text("Row 1")
                    Spacer()
                }
                .padding(TTSize.P_L)
            }
            .background(TTView.viewBgCellColor.toColor())

            {Name}ListSection(header: "Security", footer: "Last updated: 2 days ago") {
                VStack(spacing: 0) {
                    HStack {
                        Text("Change Password")
                        Spacer()
                    }
                    .padding(TTSize.P_L)
                    Divider()
                    HStack {
                        Text("Two-Factor Auth")
                        Spacer()
                    }
                    .padding(TTSize.P_L)
                }
                .background(TTView.viewBgCellColor.toColor())
            }
        }
        .background(TTView.viewBgColor.toColor())
    }
}
```

## Rules

1. **100% native SwiftUI** — no TTBaseSUI* wrappers
2. **TTBaseUIKit tokens**: `TTView.*.toColor()`, `TTSize.*`, `TTFont.*`
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
