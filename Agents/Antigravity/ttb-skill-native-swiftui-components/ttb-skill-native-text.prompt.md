---
description: "Build native SwiftUI text components: title, body, caption, badge, label. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-text — Native SwiftUI Text Component Builder

Build reusable text-based native SwiftUI components using TTBaseUIKit design tokens.

## When

User says: "native text", "text component", "badge component", "label", "caption"

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
    public let text: String
    public var color: Color? = nil

    public init(_ text: String, color: Color? = nil) {
        self.text = text
        self.color = color
    }

    public var body: some View {
        Text(self.text)
            .font(.system(size: TTFont.HEADER_H, weight: .bold))
            .foregroundColor(self.color ?? TTView.textHeaderColor.toColor())
    }
}

// MARK: - {Name}Body
public struct {Name}Body: View {
    public let text: String
    public var color: Color? = nil
    public var numberOfLines: Int = 0

    public init(_ text: String, color: Color? = nil, numberOfLines: Int = 0) {
        self.text = text
        self.color = color
        self.numberOfLines = numberOfLines
    }

    public var body: some View {
        Text(self.text)
            .font(.system(size: TTFont.TITLE_H, weight: .regular))
            .foregroundColor(self.color ?? TTView.textDefColor.toColor())
            .lineLimit(self.numberOfLines > 0 ? self.numberOfLines : nil)
    }
}

// MARK: - {Name}Caption
public struct {Name}Caption: View {
    public let text: String
    public var color: Color? = nil

    public init(_ text: String, color: Color? = nil) {
        self.text = text
        self.color = color
    }

    public var body: some View {
        Text(self.text)
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

    public let text: String
    public var style: Style = .default

    public init(_ text: String, style: Style = .default) {
        self.text = text
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
        Text(self.text)
            .font(.system(size: TTFont.SUB_SUB_TITLE_H, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, TTSize.P_S)
            .padding(.vertical, TTSize.P_S / 2)
            .background(self.bgColor)
            .clipShape(RoundedRectangle(cornerRadius: TTSize.CORNER_RADIUS))
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
        .padding(TTSize.P_L)
        .background(TTView.viewBgColor.toColor())
    }
}
```

## Rules

1. **100% native SwiftUI** — no TTBaseSUI* wrappers
2. **TTBaseUIKit tokens**: `TTView.*.toColor()`, `TTSize.*`, `TTFont.*`
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
