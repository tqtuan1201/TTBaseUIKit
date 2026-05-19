---
description: "Build native SwiftUI avatar component with image, initials, online status, and size variants. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-avatar — Native SwiftUI Avatar Component Builder

Build reusable avatar native SwiftUI components using TTBaseUIKit design tokens.

## When

User says: "native avatar", "user avatar", "profile picture", "initials avatar"

## Avatar Component Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  Components/Avatar/{Name}Avatar.swift
//  {AppName}
//

import SwiftUI
import TTBaseUIKit

// MARK: - {Name}Avatar
public struct {Name}Avatar: View {
    public enum Size: CGFloat {
        case xsmall = 24
        case small = 32
        case medium = 48
        case large = 64
        case xlarge = 96
    }

    public enum Content {
        case image(Image)
        case initials(String)
        case placeholder
    }

    public var content: Content = .placeholder
    public var size: Size = .medium
    public var borderColor: Color?
    public var borderWidth: CGFloat = 2

    public init(
        content: Content = .placeholder,
        size: Size = .medium,
        borderColor: Color? = nil,
        borderWidth: CGFloat = 2
    ) {
        self.content = content
        self.size = size
        self.borderColor = borderColor
        self.borderWidth = borderWidth
    }

    private var initialsText: String {
        if case .initials(let text) = self.content {
            return String(text.prefix(2)).uppercased()
        }
        return "?"
    }

    private var initialsColor: Color {
        TTView.buttonBgDef.toColor()
    }

    public var body: some View {
        ZStack {
            self.backgroundView

            if case .image(let img) = self.content {
                img
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: self.size.rawValue, height: self.size.rawValue)
                    .clipShape(Circle())
            } else if case .initials = self.content {
                Text(self.initialsText)
                    .font(.system(size: self.size.rawValue * 0.35, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .frame(width: self.size.rawValue, height: self.size.rawValue)
        .overlay(
            Circle()
                .stroke(self.borderColor ?? Color.clear, lineWidth: self.borderWidth)
        )
        .accessibilityLabel("Avatar")
    }

    private var backgroundView: some View {
        Group {
            switch self.content {
            case .image:
                EmptyView()
            case .initials:
                Circle()
                    .fill(self.initialsColor)
            case .placeholder:
                Circle()
                    .fill(TTView.viewDisableColor.toColor())
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: self.size.rawValue * 0.5))
                            .foregroundColor(.white)
                    )
            }
        }
    }
}

// MARK: - {Name}AvatarWithStatus
public struct {Name}AvatarWithStatus: View {
    public let content: {Name}Avatar.Content
    public var size: {Name}Avatar.Size = .medium
    public var status: Status = .offline

    public enum Status {
        case online
        case offline
        case busy
        case away

        var color: Color {
            switch self {
            case .online:  return TTView.notificationBgSuccess.toColor()
            case .offline: return TTView.viewDisableColor.toColor()
            case .busy:   return TTView.notificationBgError.toColor()
            case .away:   return TTView.notificationBgWarning.toColor()
            }
        }

        var size: CGFloat {
            switch self {
            case .online, .offline:  return 0.25
            case .busy, .away:       return 0.25
            }
        }
    }

    public init(content: {Name}Avatar.Content, size: {Name}Avatar.Size = .medium, status: Status = .offline) {
        self.content = content
        self.size = size
        self.status = status
    }

    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            {Name}Avatar(content: self.content, size: self.size)

            Circle()
                .fill(self.status.color)
                .frame(width: self.size.rawValue * self.status.size, height: self.size.rawValue * self.status.size)
                .overlay(
                    Circle()
                        .stroke(TTView.viewBgCellColor.toColor(), lineWidth: 2)
                )
                .offset(x: 2, y: 2)
        }
        .accessibilityLabel("Avatar with \(self.statusAccessibilityLabel) status")
    }

    private var statusAccessibilityLabel: String {
        switch self.status {
        case .online:  return "online"
        case .offline: return "offline"
        case .busy:    return "busy"
        case .away:    return "away"
        }
    }
}

// MARK: - Preview
struct {Name}Avatar_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: TTSize.P_XL) {
            HStack(spacing: TTSize.P_L) {
                {Name}Avatar(content: .initials("JD"), size: .xsmall)
                {Name}Avatar(content: .initials("AB"), size: .small)
                {Name}Avatar(content: .initials("TC"), size: .medium)
                {Name}Avatar(content: .initials("XY"), size: .large)
                {Name}Avatar(content: .initials("MN"), size: .xlarge)
            }

            HStack(spacing: TTSize.P_L) {
                {Name}Avatar(content: .placeholder, size: .medium)
                {Name}Avatar(content: .initials("JD"), size: .medium, borderColor: TTView.buttonBgDef.toColor())
            }

            HStack(spacing: TTSize.P_L) {
                {Name}AvatarWithStatus(content: .initials("JD"), size: .medium, status: .online)
                {Name}AvatarWithStatus(content: .initials("AB"), size: .medium, status: .busy)
                {Name}AvatarWithStatus(content: .initials("TC"), size: .medium, status: .away)
                {Name}AvatarWithStatus(content: .initials("XY"), size: .medium, status: .offline)
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
3. **Sizes**: xsmall (24pt), small (32pt), medium (48pt), large (64pt), xlarge (96pt)
4. **Content**: `.image(Image)`, `.initials(String)`, `.placeholder`
5. **Initials**: `prefix(2).uppercased()`, font size = size * 0.35
6. **Status dot**: size * 0.25, offset (2, 2), white border stroke
7. **Accessibility**: `.accessibilityLabel()` on all avatars
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
