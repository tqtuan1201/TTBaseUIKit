---
description: "Build native SwiftUI SF Symbol icon component with color, size, and style variants. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-icon — Native SwiftUI Icon Component Builder

Build reusable SF Symbol icon native SwiftUI components using TTBaseUIKit design tokens.

## When

User say native icon" "icon component" "SF Symbol"

## Icon Component Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  Components/Icon/{Name}Icon.swift
//  {AppName}
//

import SwiftUI
import TTBaseUIKit

// MARK: - {Name}Icon
public struct {Name}Icon: View {
    public enum Size: CGFloat {
        case tiny = 12
        case small = 16
        case medium = 24
        case large = 32
        case xlarge = 48

        var dimension: CGFloat { self.rawValue }
    }

    public enum Style {
        case filled
        case outline
    }

    public let systemName: String
    public var size: Size = .medium
    public var color: Color = TTView.iconColor.toColor()
    public var style: Style = .outline

    public init(
        _ systemName: String,
        size: Size = .medium,
        color: Color? = nil,
        style: Style = .outline
    ) {
        self.systemName = systemName
        self.size = size
        if let c = color { self.color = c }
        self.style = style
    }

    public var body: some View {
        Image(systemName: self.iconName)
            .font(.system(size: self.size.dimension))
            .foregroundColor(self.color)
            .accessibilityLabel(self.systemName)
    }

    private var iconName: String {
        switch self.style {
        case .filled:
            return self.systemName.contains(".fill") ? self.systemName : "\(self.systemName).fill"
        case .outline:
            return self.systemName.contains(".fill") ? String(self.systemName.dropLast(5)) : self.systemName
        }
    }
}

// MARK: - {Name}IconButton
public struct {Name}IconButton: View {
    public let systemName: String
    public var size: {Name}Icon.Size = .medium
    public var iconColor: Color = TTView.buttonBgDef.toColor()
    public var bgColor: Color = TTView.buttonBgDef.toColor().opacity(0.1)
    public var onTap: (() -> Void)?

    public init(
        _ systemName: String,
        size: {Name}Icon.Size = .medium,
        iconColor: Color? = nil,
        bgColor: Color? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.systemName = systemName
        self.size = size
        if let ic = iconColor { self.iconColor = ic }
        if let bg = bgColor { self.bgColor = bg }
        self.onTap = onTap
    }

    public var body: some View {
        Button {
            self.onTap?()
        } label: {
            Image(systemName: self.systemName)
                .font(.system(size: self.size.dimension))
                .foregroundColor(self.iconColor)
                .frame(width: 44, height: 44)
                .background(self.bgColor)
                .clipShape(Circle())
        }
        .accessibilityLabel(self.systemName)
    }
}

// MARK: - {Name}IconBadge
public struct {Name}IconBadge: View {
    public let systemName: String
    public var size: {Name}Icon.Size = .medium
    public var iconColor: Color = TTView.iconColor.toColor()
    public var badgeCount: Int?
    public var badgeColor: Color = TTView.colorError.toColor()

    public init(
        _ systemName: String,
        size: {Name}Icon.Size = .medium,
        iconColor: Color? = nil,
        badgeCount: Int? = nil,
        badgeColor: Color? = nil
    ) {
        self.systemName = systemName
        self.size = size
        if let ic = iconColor { self.iconColor = ic }
        self.badgeCount = badgeCount
        if let bc = badgeColor { self.badgeColor = bc }
    }

    public var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(systemName: self.systemName)
                .font(.system(size: self.size.dimension))
                .foregroundColor(self.iconColor)

            if let count = self.badgeCount, count > 0 {
                Text(count > 99 ? "99+" : "\(count)")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(self.badgeColor)
                    .clipShape(Capsule())
                    .offset(x: 8, y: -8)
            }
        }
        .accessibilityLabel("\(self.systemName), badge \(self.badgeCount ?? 0)")
    }
}

// MARK: - Preview
struct {Name}Icon_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: TTSize.P_XL) {
            HStack(spacing: TTSize.P_L) {
                {Name}Icon("star.fill", size: .tiny, color: .yellow)
                {Name}Icon("heart.fill", size: .small, color: .red)
                {Name}Icon("person.fill", size: .medium, color: TTView.buttonBgDef.toColor())
                {Name}Icon("gearshape.fill", size: .large, color: .gray)
                {Name}Icon("bell.fill", size: .xlarge, color: .orange)
            }

            HStack(spacing: TTSize.P_L) {
                {Name}IconButton("heart.fill", iconColor: .red, bgColor: Color.red.opacity(0.1)) { }
                {Name}IconButton("star.fill", iconColor: .yellow, bgColor: Color.yellow.opacity(0.1)) { }
                {Name}IconButton("bell.fill", iconColor: .blue, bgColor: Color.blue.opacity(0.1)) { }
            }

            HStack(spacing: TTSize.P_XL) {
                {Name}IconBadge("bell.fill", badgeCount: 5)
                {Name}IconBadge("envelope.fill", badgeCount: 99)
                {Name}IconBadge("cart.fill", badgeCount: 100)
                {Name}IconBadge("message.fill", badgeCount: 0)
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
3. **Sizes**: tiny (12pt), small (16pt), medium (24pt), large (32pt), xlarge (48pt)
4. **IconButton**: 44x44pt tap target, circular bg with 0.1 opacity
5. **IconBadge**: topTrailing ZStack offset (8, -8), Capsule shape for count
6. **Style toggle**: auto-convert `.fill` suffix for filled/outline
7. **Accessibility**: `.accessibilityLabel()` on all icons
8. **PreviewProvider** at bottom
9. **MARKER COMMENT** at top

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
