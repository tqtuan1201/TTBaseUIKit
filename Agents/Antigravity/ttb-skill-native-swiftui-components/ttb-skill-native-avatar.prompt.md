---
description: "Build native SwiftUI avatar component with image, initials, online status, and size variants. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-avatar — Native SwiftUI Avatar Component Builder

Build reusable avatar native SwiftUI components using TTBaseUIKit design tokens.

## Mandatory Preflight Execution Gate

Before generating code or modifying files, run `ttb-skill-shared/fragments/ttb-preflight-execution-gate.frag.md`.

Required checks:

- Analyze intent, task type, scope, impacted files/modules, dependencies, architecture constraints, coding standards, and project-specific rules.
- Validate required inputs such as target module, screen/component name, file location, navigation flow, expected output, API contract, state management, routing, localization, naming, and reusable component requirements.
- Detect ambiguity, conflicting requirements, incomplete business logic, unclear UX/navigation, unclear module ownership, and unclear architecture direction.
- Score confidence from `0-100`: execute at `90-100`, execute with warning assumptions at `70-89`, and ask a survey below `70` using `ttb-skill-shared/templates/ttb-clarification-survey.md`.
- Support English, Vietnamese, mixed-language, diacritic-free Vietnamese, and light typo prompts.

## When

User says: "native avatar", "user avatar", "profile picture", "initials avatar"

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
        .accessibilityLabel(XText("Accessibility.Avatar"))
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
        .accessibilityLabel(String(format: XText("Accessibility.Avatar.Status.Format"), XText(self.statusAccessibilityKey)))
    }

    private var statusAccessibilityKey: String {
        switch self.status {
        case .online:  return "Accessibility.Status.Online"
        case .offline: return "Accessibility.Status.Offline"
        case .busy:    return "Accessibility.Status.Busy"
        case .away:    return "Accessibility.Status.Away"
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
        .pAll(TTSize.P_L)
        .bg(byDef: TTView.viewBgColor.toColor())
    }
}
```

## Rules

1. **100% native SwiftUI primitives** — no `TTBaseSUI*`, `SUIBaseView`, or `TTBaseNavigationLink` wrappers in `/native-*` components
2. **TTBaseUIKit tokens + chainable modifiers**: `TTView.*.toColor()`, `TTSize.*`, `TTFont.*`, `.pAll()`, `.bg()`, `.corner()`, `.baseShadow()`, `.size()`
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
