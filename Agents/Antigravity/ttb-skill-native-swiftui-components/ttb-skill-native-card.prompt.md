---
description: "Build native SwiftUI card components: tappable card, static card, action card. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-card — Native SwiftUI Card Component Builder

Build reusable card native SwiftUI components using TTBaseUIKit design tokens.

## When

User says: "native card", "card component", "tappable card", "action card", "static card"

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
                .padding(TTSize.P_CONS_DEF)
                .background(TTView.viewBgCellColor.toColor())
                .clipShape(RoundedRectangle(cornerRadius: TTSize.CORNER_PANEL))
                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
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
            .padding(TTSize.P_CONS_DEF)
            .background(TTView.viewBgCellColor.toColor())
            .clipShape(RoundedRectangle(cornerRadius: TTSize.CORNER_PANEL))
            .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
    }
}

// MARK: - {Name}ActionCard
public struct {Name}ActionCard: View {
    public let title: String
    public let subtitle: String?
    public let iconName: String?
    public var buttonTitle: String?
    public var onTap: (() -> Void)?
    public var onAction: (() -> Void)?

    public init(
        title: String,
        subtitle: String? = nil,
        iconName: String? = nil,
        buttonTitle: String? = nil,
        onTap: (() -> Void)? = nil,
        onAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.iconName = iconName
        self.buttonTitle = buttonTitle
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

                Text(self.title)
                    .font(.system(size: TTFont.HEADER_H, weight: .bold))
                    .foregroundColor(TTView.textHeaderColor.toColor())

                if let subtitle = self.subtitle {
                    Text(subtitle)
                        .font(.system(size: TTFont.TITLE_H, weight: .regular))
                        .foregroundColor(TTView.textDefColor.toColor())
                }

                if let buttonTitle = self.buttonTitle, let onAction = self.onAction {
                    Button(action: onAction) {
                        Text(buttonTitle)
                            .font(.system(size: TTFont.TITLE_H, weight: .semibold))
                            .foregroundColor(TTView.buttonBgDef.toColor())
                    }
                    .padding(.top, TTSize.P_S)
                }
            }
        }
    }
}

// MARK: - {Name}CardRow
public struct {Name}CardRow: View {
    public let iconName: String
    public let title: String
    public let subtitle: String?
    public var onTap: (() -> Void)?

    public init(iconName: String, title: String, subtitle: String? = nil, onTap: (() -> Void)? = nil) {
        self.iconName = iconName
        self.title = title
        self.subtitle = subtitle
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

                Image(systemName: "chevron.right")
                    .font(.system(size: TTFont.SUB_TITLE_H))
                    .foregroundColor(TTView.iconColor.toColor())
            }
            .padding(TTSize.P_CONS_DEF)
            .background(TTView.viewBgCellColor.toColor())
            .clipShape(RoundedRectangle(cornerRadius: TTSize.CORNER_PANEL))
            .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
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
                        Text("Tappable Card Content")
                            .font(.system(size: TTFont.TITLE_H))
                        Spacer()
                        Image(systemName: "arrow.right")
                    }
                }
                .onTapHandle { }

                {Name}StaticCard {
                    Text("Static Card — no interaction")
                        .font(.system(size: TTFont.TITLE_H))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                {Name}ActionCard(
                    title: "Get Started",
                    subtitle: "Complete your profile to unlock all features.",
                    iconName: "star.fill",
                    buttonTitle: "Let's Go"
                ) { } onAction: { }

                {Name}CardRow(
                    iconName: "person.circle.fill",
                    title: "Profile",
                    subtitle: "Manage your account"
                ) { }
            }
            .padding(TTSize.P_L)
        }
        .background(TTView.viewBgColor.toColor())
    }
}
```

## Rules

1. **100% native SwiftUI** — no TTBaseSUI* wrappers
2. **TTBaseUIKit tokens**: `TTView.*.toColor()`, `TTSize.*`, `TTFont.*`
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
