---
description: "Build native SwiftUI text components: title, body, caption, badge, label. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-text — Native SwiftUI Text Component Builder

Build reusable text-based native SwiftUI components using TTBaseUIKit design tokens.

## When

User says: "native text", "text component", "badge component", "label", "caption"

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

## Text Component Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  Components/Text/{Name}Text.swift
//  {AppName}
//

import SwiftUI
import TTBaseUIKit

// MARK: - {Name}Title
public struct {Name}Title: View {
    public let textKey: String
    public var color: Color? = nil

    public init(_ textKey: String, color: Color? = nil) {
        self.textKey = textKey
        self.color = color
    }

    public var body: some View {
        Text(XText(self.textKey))
            .font(.system(size: TTFont.HEADER_H, weight: .bold))
            .foregroundColor(self.color ?? TTView.textHeaderColor.toColor())
    }
}

// MARK: - {Name}Body
public struct {Name}Body: View {
    public let textKey: String
    public var color: Color? = nil
    public var numberOfLines: Int = 0

    public init(_ textKey: String, color: Color? = nil, numberOfLines: Int = 0) {
        self.textKey = textKey
        self.color = color
        self.numberOfLines = numberOfLines
    }

    public var body: some View {
        Text(XText(self.textKey))
            .font(.system(size: TTFont.TITLE_H, weight: .regular))
            .foregroundColor(self.color ?? TTView.textDefColor.toColor())
            .lineLimit(self.numberOfLines > 0 ? self.numberOfLines : nil)
    }
}

// MARK: - {Name}Caption
public struct {Name}Caption: View {
    public let textKey: String
    public var color: Color? = nil

    public init(_ textKey: String, color: Color? = nil) {
        self.textKey = textKey
        self.color = color
    }

    public var body: some View {
        Text(XText(self.textKey))
            .font(.system(size: TTFont.SUB_TITLE_H, weight: .regular))
            .foregroundColor(self.color ?? TTView.textSubTitleColor.toColor())
    }
}

// MARK: - {Name}Badge
public struct {Name}Badge: View {
    public enum Style {
        case `default`
        case success
        case warning
        case error
    }

    public let textKey: String
    public var style: Style = .default

    public init(_ textKey: String, style: Style = .default) {
        self.textKey = textKey
        self.style = style
    }

    private var bgColor: Color {
        switch self.style {
        case .default:  return TTView.buttonBgDef.toColor()
        case .success:  return TTView.notificationBgSuccess.toColor()
        case .warning:  return TTView.notificationBgWarning.toColor()
        case .error:   return TTView.notificationBgError.toColor()
        }
    }

    public var body: some View {
        Text(XText(self.textKey))
            .font(.system(size: TTFont.SUB_SUB_TITLE_H, weight: .semibold))
            .foregroundColor(.white)
            .pHorizontal(TTSize.P_S)
            .pVertical(TTSize.P_S / 2)
            .background(self.bgColor)
            .corner(byDef: TTSize.CORNER_RADIUS)
    }
}

// MARK: - Preview
struct {Name}Text_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: TTSize.P_L) {
            {Name}Title("Heading Text")
            {Name}Body("This is body text that spans multiple lines when needed.")
            {Name}Body("Truncated text", numberOfLines: 1)
            {Name}Caption("Caption / helper text")
            HStack(spacing: TTSize.P_S) {
                {Name}Badge("Default")
                {Name}Badge("Success", style: .success)
                {Name}Badge("Warning", style: .warning)
                {Name}Badge("Error", style: .error)
            }
        }
        .pAll(TTSize.P_L)
        .bg(byDef: TTView.viewBgColor.toColor())
    }
}
```

## Rules

1. **100% native SwiftUI primitives** — no `TTBaseSUI*`, `SUIBaseView`, or `TTBaseNavigationLink` wrappers in `/native-*` components
2. **TTBaseUIKit tokens + chainable modifiers**: `TTView.*.toColor()`, `TTSize.*`, `TTFont.*`, `.pAll()`, `.bg()`, `.corner()`, `.baseShadow()`, `.size()`
3. **Text hierarchy**: HEADER_H (heading) > TITLE_H (body) > SUB_TITLE_H (caption) > SUB_SUB_TITLE_H (badge)
4. **iOS 14+**: `.foregroundColor()` NOT `.foregroundStyle()`
5. **Line limiting**: pass `numberOfLines` param for truncation
6. **Badge styles**: `.default`, `.success`, `.warning`, `.error` using TTBaseUIKit status colors
7. **PreviewProvider** at bottom
8. **MARKER COMMENT** at top

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
