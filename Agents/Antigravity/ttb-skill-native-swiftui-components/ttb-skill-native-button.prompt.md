---
description: "Build native SwiftUI button components: primary, secondary, destructive, link, icon-only. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-button — Native SwiftUI Button Component Builder

Build reusable button native SwiftUI components using TTBaseUIKit design tokens.

## When

User says: "native button", "button component", "primary button", "destructive button", "link button", "icon button"

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
    public let title: String
    public var action: () -> Void

    public init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(action: self.action) {
            Text(self.title)
                .font(.system(size: TTFont.TITLE_H, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: TTSize.H_BUTTON)
                .background(TTView.buttonBgDef.toColor())
                .clipShape(RoundedRectangle(cornerRadius: TTSize.CORNER_BUTTON))
        }
        .accessibilityLabel(self.title)
    }
}

// MARK: - {Name}SecondaryButton
public struct {Name}SecondaryButton: View {
    public let title: String
    public var action: () -> Void

    public init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(action: self.action) {
            Text(self.title)
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
        .accessibilityLabel(self.title)
    }
}

// MARK: - {Name}DestructiveButton
public struct {Name}DestructiveButton: View {
    public let title: String
    public var action: () -> Void

    public init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(action: self.action) {
            Text(self.title)
                .font(.system(size: TTFont.TITLE_H, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: TTSize.H_BUTTON)
                .background(TTView.buttonBgWar.toColor())
                .clipShape(RoundedRectangle(cornerRadius: TTSize.CORNER_BUTTON))
        }
        .accessibilityLabel(self.title)
    }
}

// MARK: - {Name}LinkButton
public struct {Name}LinkButton: View {
    public let title: String
    public var action: () -> Void

    public init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(action: self.action) {
            Text(self.title)
                .font(.system(size: TTFont.TITLE_H, weight: .medium))
                .foregroundColor(TTView.buttonBgDef.toColor())
                .frame(height: TTSize.H_BUTTON)
        }
        .accessibilityLabel(self.title)
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
        .accessibilityLabel(self.iconName)
    }
}

// MARK: - Preview
struct {Name}Button_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: TTSize.P_L) {
            {Name}PrimaryButton("Primary Button") { }
            {Name}SecondaryButton("Secondary Button") { }
            {Name}DestructiveButton("Delete Account") { }
            {Name}LinkButton("Forgot Password?") { }
            HStack(spacing: TTSize.P_L) {
                {Name}IconButton("heart", style: .primary) { }
                {Name}IconButton("square.and.arrow.up", style: .secondary) { }
                {Name}IconButton("trash", style: .destructive) { }
            }
        }
        .padding(TTSize.P_L)
        .background(TTView.viewBgColor.toColor())
    }
}
```

## Rules

1. **100% native SwiftUI** — no TTBaseSUI* wrappers
2. **TTBaseUIKit tokens**: `TTView.*.toColor()`, `TTSize.*`, `TTFont.*`
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
