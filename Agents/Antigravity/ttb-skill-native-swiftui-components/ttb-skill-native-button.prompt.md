---
description: "Build native SwiftUI button components: primary, secondary, destructive, link, icon-only. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-button — Native SwiftUI Button Component Builder

Build reusable button native SwiftUI components using TTBaseUIKit design tokens.

## When

User says: "native button", "button component", "primary button", "destructive button", "link button", "icon button"

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

## Button Component Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  Components/Button/{Name}Button.swift
//  {AppName}
//

import SwiftUI
import TTBaseUIKit

// MARK: - {Name}PrimaryButton
public struct {Name}PrimaryButton: View {
    public let titleKey: String
    public var action: () -> Void

    public init(_ titleKey: String, action: @escaping () -> Void) {
        self.titleKey = titleKey
        self.action = action
    }

    public var body: some View {
        Button(action: self.action) {
            Text(XText(self.titleKey))
                .font(.system(size: TTFont.TITLE_H, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: TTSize.H_BUTTON)
                .bg(byDef: TTView.buttonBgDef.toColor())
                .corner(byDef: TTSize.CORNER_BUTTON)
        }
        .accessibilityLabel(XText(self.titleKey))
    }
}

// MARK: - {Name}SecondaryButton
public struct {Name}SecondaryButton: View {
    public let titleKey: String
    public var action: () -> Void

    public init(_ titleKey: String, action: @escaping () -> Void) {
        self.titleKey = titleKey
        self.action = action
    }

    public var body: some View {
        Button(action: self.action) {
            Text(XText(self.titleKey))
                .font(.system(size: TTFont.TITLE_H, weight: .semibold))
                .foregroundColor(TTView.buttonBgDef.toColor())
                .frame(maxWidth: .infinity)
                .frame(height: TTSize.H_BUTTON)
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: TTSize.CORNER_BUTTON)
                        .stroke(TTView.buttonBgDef.toColor(), lineWidth: TTSize.H_BORDER)
                )
        }
        .accessibilityLabel(XText(self.titleKey))
    }
}

// MARK: - {Name}DestructiveButton
public struct {Name}DestructiveButton: View {
    public let titleKey: String
    public var action: () -> Void

    public init(_ titleKey: String, action: @escaping () -> Void) {
        self.titleKey = titleKey
        self.action = action
    }

    public var body: some View {
        Button(action: self.action) {
            Text(XText(self.titleKey))
                .font(.system(size: TTFont.TITLE_H, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: TTSize.H_BUTTON)
                .bg(byDef: TTView.buttonBgWar.toColor())
                .corner(byDef: TTSize.CORNER_BUTTON)
        }
        .accessibilityLabel(XText(self.titleKey))
    }
}

// MARK: - {Name}LinkButton
public struct {Name}LinkButton: View {
    public let titleKey: String
    public var action: () -> Void

    public init(_ titleKey: String, action: @escaping () -> Void) {
        self.titleKey = titleKey
        self.action = action
    }

    public var body: some View {
        Button(action: self.action) {
            Text(XText(self.titleKey))
                .font(.system(size: TTFont.TITLE_H, weight: .medium))
                .foregroundColor(TTView.buttonBgDef.toColor())
                .frame(height: TTSize.H_BUTTON)
        }
        .accessibilityLabel(XText(self.titleKey))
    }
}

// MARK: - {Name}IconButton
public struct {Name}IconButton: View {
    public enum Style {
        case primary
        case secondary
        case destructive
    }

    public let iconName: String
    public var style: Style = .primary
    public var size: CGFloat = 44
    public var action: () -> Void

    public init(_ iconName: String, style: Style = .primary, size: CGFloat = 44, action: @escaping () -> Void) {
        self.iconName = iconName
        self.style = style
        self.size = size
        self.action = action
    }

    private var iconColor: Color {
        switch self.style {
        case .primary:     return TTView.buttonBgDef.toColor()
        case .secondary:   return TTView.iconColor.toColor()
        case .destructive: return TTView.buttonBgWar.toColor()
        }
    }

    public var body: some View {
        Button(action: self.action) {
            Image(systemName: self.iconName)
                .font(.system(size: self.size * 0.5))
                .foregroundColor(self.iconColor)
                .frame(width: self.size, height: self.size)
                .background(Color.clear)
        }
        .accessibilityLabel(String(format: XText("Accessibility.Icon.Format"), self.iconName))
    }
}

// MARK: - Preview
struct {Name}Button_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: TTSize.P_L) {
            {Name}PrimaryButton("Preview.Button.Primary") { }
            {Name}SecondaryButton("Preview.Button.Secondary") { }
            {Name}DestructiveButton("Preview.Button.DeleteAccount") { }
            {Name}LinkButton("Preview.Button.ForgotPassword") { }
            HStack(spacing: TTSize.P_L) {
                {Name}IconButton("heart", style: .primary) { }
                {Name}IconButton("square.and.arrow.up", style: .secondary) { }
                {Name}IconButton("trash", style: .destructive) { }
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
3. **Height = TTSize.H_BUTTON (40pt)** — consistent button height
4. **Corner radius = TTSize.CORNER_BUTTON (4pt)** — default corner
5. **Min tap target = 44x44** — for icon buttons
6. **Accessibility**: `.accessibilityLabel()` on every button
7. **Button types**: Primary (brand blue), Secondary (outline), Destructive (red), Link (text only), Icon
8. **iOS 14+**: `Button(action:label:)` NOT `.task { }`, `.foregroundColor()` NOT `.foregroundStyle()`
9. **PreviewProvider** at bottom
10. **MARKER COMMENT** at top

## Button Style Guide

| Style | Background | Text Color | Border | Usage |
|-------|-----------|------------|--------|-------|
| Primary | `TTView.buttonBgDef` | White | None | Main CTA |
| Secondary | Clear | `TTView.buttonBgDef` | `buttonBgDef` | Secondary action |
| Destructive | `TTView.buttonBgWar` | White | None | Delete, danger |
| Link | Clear | `TTView.buttonBgDef` | None | Tertiary action |
| Icon | Clear | `TTView.buttonBgDef` | None | Toolbar actions |

## Post-Implementation Verification

After all files are generated, run Phase 6 from `ttb-phase-verify.md`:

```bash
cd /path/to/TTBaseUIKitExample
xcodebuild -project TTBaseUIKitExample.xcodeproj \
  -scheme TTBaseUIKitExample \
  -destination 'platform=iOS Simulator,name=iPhone 11' \
  build 2>&1 | tail -50
```

**Anti-Loop**: Max 3 build attempts. 3 failures → STOP, document errors.
