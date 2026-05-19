---
description: "Build native SwiftUI divider and section components: horizontal divider, vertical divider, section spacer, section header. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-divider — Native SwiftUI Divider Component Builder

Build reusable divider and section native SwiftUI components using TTBaseUIKit design tokens.

## When

User says: "native divider", "separator", "section spacer", "section header", "line"

## Divider Component Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  Components/Divider/{Name}Divider.swift
//  {AppName}
//

import SwiftUI
import TTBaseUIKit

// MARK: - {Name}HorizontalDivider
public struct {Name}HorizontalDivider: View {
    public var color: Color = TTView.lineDefColor.toColor()
    public var thickness: CGFloat = TTSize.H_LINEVIEW
    public var leftInset: CGFloat = 0
    public var rightInset: CGFloat = 0

    public init(
        color: Color? = nil,
        thickness: CGFloat? = nil,
        leftInset: CGFloat = 0,
        rightInset: CGFloat = 0
    ) {
        if let c = color { self.color = c }
        if let t = thickness { self.thickness = t }
        self.leftInset = leftInset
        self.rightInset = rightInset
    }

    public var body: some View {
        Color(self.color)
            .frame(height: self.thickness)
            .padding(.leading, self.leftInset)
            .padding(.trailing, self.rightInset)
    }
}

// MARK: - {Name}VerticalDivider
public struct {Name}VerticalDivider: View {
    public var color: Color = TTView.lineDefColor.toColor()
    public var thickness: CGFloat = TTSize.H_LINEVIEW
    public var topInset: CGFloat = 0
    public var bottomInset: CGFloat = 0

    public init(
        color: Color? = nil,
        thickness: CGFloat? = nil,
        topInset: CGFloat = 0,
        bottomInset: CGFloat = 0
    ) {
        if let c = color { self.color = c }
        if let t = thickness { self.thickness = t }
        self.topInset = topInset
        self.bottomInset = bottomInset
    }

    public var body: some View {
        Color(self.color)
            .frame(width: self.thickness)
            .padding(.top, self.topInset)
            .padding(.bottom, self.bottomInset)
    }
}

// MARK: - {Name}SectionSpacer
public struct {Name}SectionSpacer: View {
    public enum Size {
        case small   // P_S (4pt)
        case medium  // P_CONS_DEF (8pt)
        case large  // P_L (16pt)
        case xlarge // P_XL (20pt)

        var value: CGFloat {
            switch self {
            case .small:   return TTSize.P_S
            case .medium:  return TTSize.P_CONS_DEF
            case .large:   return TTSize.P_L
            case .xlarge: return TTSize.P_XL
            }
        }
    }

    public var size: Size

    public init(size: Size = .large) {
        self.size = size
    }

    public var body: some View {
        Color.clear
            .frame(height: self.size.value)
    }
}

// MARK: - {Name}SectionHeader
public struct {Name}SectionHeader: View {
    public let title: String
    public var actionTitle: String?
    public var onAction: (() -> Void)?

    public init(title: String, actionTitle: String? = nil, onAction: (() -> Void)? = nil) {
        self.title = title
        self.actionTitle = actionTitle
        self.onAction = onAction
    }

    public var body: some View {
        HStack {
            Text(self.title)
                .font(.system(size: TTFont.SUB_TITLE_H, weight: .semibold))
                .foregroundColor(TTView.textSubTitleColor.toColor())
                .textCase(.uppercase)

            Spacer()

            if let actionTitle = self.actionTitle, let onAction = self.onAction {
                Button(action: onAction) {
                    Text(actionTitle)
                        .font(.system(size: TTFont.SUB_TITLE_H, weight: .medium))
                        .foregroundColor(TTView.buttonBgDef.toColor())
                }
                .accessibilityLabel("See all \(self.title)")
            }
        }
        .padding(.horizontal, TTSize.P_L)
        .padding(.vertical, TTSize.P_S)
    }
}

// MARK: - {Name}BulletList
public struct {Name}BulletList<Content: View>: View {
    public let spacing: CGFloat
    public let content: () -> Content

    public init(spacing: CGFloat = TTSize.P_CONS_DEF, @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: self.spacing) {
            self.content()
        }
    }
}

// MARK: - {Name}BulletItem
public struct {Name}BulletItem: View {
    public let text: String
    public var bulletColor: Color = TTView.buttonBgDef.toColor()
    public var textColor: Color = TTView.textDefColor.toColor()

    public init(_ text: String, bulletColor: Color? = nil, textColor: Color? = nil) {
        self.text = text
        if let bc = bulletColor { self.bulletColor = bc }
        if let tc = textColor { self.textColor = tc }
    }

    public var body: some View {
        HStack(alignment: .top, spacing: TTSize.P_CONS_DEF) {
            Circle()
                .fill(self.bulletColor)
                .frame(width: 6, height: 6)
                .padding(.top, 6)

            Text(self.text)
                .font(.system(size: TTFont.TITLE_H, weight: .regular))
                .foregroundColor(self.textColor)
        }
    }
}

// MARK: - Preview
struct {Name}Divider_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            {Name}SectionHeader(title: "Account Settings", actionTitle: "Edit") { }

            {Name}HorizontalDivider()

            VStack(spacing: TTSize.P_L) {
                HStack(spacing: TTSize.P_L) {
                    VStack { Text("Left"); Spacer() }
                    {Name}VerticalDivider()
                    VStack { Text("Right"); Spacer() }
                }
                .frame(height: 60)

                {Name}HorizontalDivider(leftInset: 40, rightInset: 40)

                {Name}BulletList {
                    {Name}BulletItem("First bullet point")
                    {Name}BulletItem("Second bullet point")
                    {Name}BulletItem("Third bullet point", bulletColor: TTView.colorSuccess.toColor())
                }
            }
            .padding(TTSize.P_L)
        }
        .background(TTView.viewBgCellColor.toColor())
        .clipShape(RoundedRectangle(cornerRadius: TTSize.CORNER_PANEL))
        .padding(TTSize.P_L)
        .background(TTView.viewBgColor.toColor())
    }
}
```

## Rules

1. **100% native SwiftUI** — no TTBaseSUI* wrappers
2. **TTBaseUIKit tokens**: `TTView.*.toColor()`, `TTSize.*`, `TTFont.*`
3. **Divider thickness = TTSize.H_LINEVIEW (1.5pt)** — default
4. **Divider color = TTView.lineDefColor** — separator gray
5. **Insets**: use `leftInset`/`rightInset` to indent from edges
6. **SectionSpacer**: clear Color view with height only
7. **SectionHeader**: uppercase text, optional action button on right
8. **Bullet**: 6pt circle with `padding(.top, 6)` for vertical alignment
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
