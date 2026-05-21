---
description: "Build native SwiftUI divider and section components: horizontal divider, vertical divider, section spacer, section header. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-divider — Native SwiftUI Divider Component Builder

Build reusable divider and section native SwiftUI components using TTBaseUIKit design tokens.

## When

User says: "native divider", "separator", "section spacer", "section header", "line"

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
    public let titleKey: String
    public var actionTitleKey: String?
    public var onAction: (() -> Void)?

    public init(titleKey: String, actionTitleKey: String? = nil, onAction: (() -> Void)? = nil) {
        self.titleKey = titleKey
        self.actionTitleKey = actionTitleKey
        self.onAction = onAction
    }

    public var body: some View {
        HStack {
            Text(XText(self.titleKey))
                .font(.system(size: TTFont.SUB_TITLE_H, weight: .semibold))
                .foregroundColor(TTView.textSubTitleColor.toColor())
                .textCase(.uppercase)

            Spacer()

            if let actionTitleKey = self.actionTitleKey, let onAction = self.onAction {
                Button(action: onAction) {
                    Text(XText(actionTitleKey))
                        .font(.system(size: TTFont.SUB_TITLE_H, weight: .medium))
                        .foregroundColor(TTView.buttonBgDef.toColor())
                }
                .accessibilityLabel(String(format: XText("Accessibility.Section.Action.Format"), XText(actionTitleKey), XText(self.titleKey)))
            }
        }
        .pHorizontal(TTSize.P_L)
        .pVertical(TTSize.P_S)
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
    public let textKey: String
    public var bulletColor: Color = TTView.buttonBgDef.toColor()
    public var textColor: Color = TTView.textDefColor.toColor()

    public init(_ textKey: String, bulletColor: Color? = nil, textColor: Color? = nil) {
        self.textKey = textKey
        if let bc = bulletColor { self.bulletColor = bc }
        if let tc = textColor { self.textColor = tc }
    }

    public var body: some View {
        HStack(alignment: .top, spacing: TTSize.P_CONS_DEF) {
            Circle()
                .fill(self.bulletColor)
                .frame(width: 6, height: 6)
                .padding(.top, 6)

            Text(XText(self.textKey))
                .font(.system(size: TTFont.TITLE_H, weight: .regular))
                .foregroundColor(self.textColor)
        }
    }
}

// MARK: - Preview
struct {Name}Divider_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            {Name}SectionHeader(titleKey: "Settings.Account.Title", actionTitleKey: "Common.Action.Edit") { }

            {Name}HorizontalDivider()

            VStack(spacing: TTSize.P_L) {
                HStack(spacing: TTSize.P_L) {
                    VStack { Text(XText("Preview.Divider.Left")); Spacer() }
                    {Name}VerticalDivider()
                    VStack { Text(XText("Preview.Divider.Right")); Spacer() }
                }
                .frame(height: 60)

                {Name}HorizontalDivider(leftInset: 40, rightInset: 40)

                {Name}BulletList {
                    {Name}BulletItem("First bullet point")
                    {Name}BulletItem("Second bullet point")
                    {Name}BulletItem("Third bullet point", bulletColor: TTView.colorSuccess.toColor())
                }
            }
            .pAll(TTSize.P_L)
        }
        .bg(byDef: TTView.viewBgCellColor.toColor())
        .corner(byDef: TTSize.CORNER_PANEL)
        .pAll(TTSize.P_L)
        .bg(byDef: TTView.viewBgColor.toColor())
    }
}
```

## Rules

1. **100% native SwiftUI primitives** — no `TTBaseSUI*`, `SUIBaseView`, or `TTBaseNavigationLink` wrappers in `/native-*` components
2. **TTBaseUIKit tokens + chainable modifiers**: `TTView.*.toColor()`, `TTSize.*`, `TTFont.*`, `.pAll()`, `.bg()`, `.corner()`, `.baseShadow()`, `.size()`
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
