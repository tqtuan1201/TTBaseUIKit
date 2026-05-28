---
description: "Build native SwiftUI display components: avatar, badge, chip, rating, icon. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-display — Native SwiftUI Display Component Builder

Build reusable display native SwiftUI components using TTBaseUIKit design tokens.

## Mandatory Preflight Execution Gate

Before generating code or modifying files, run `ttb-skill-shared/fragments/ttb-preflight-execution-gate.frag.md`.

Required checks:

- Analyze intent, task type, scope, impacted files/modules, dependencies, architecture constraints, coding standards, and project-specific rules.
- Validate required inputs such as target module, screen/component name, file location, navigation flow, expected output, API contract, state management, routing, localization, naming, and reusable component requirements.
- Detect ambiguity, conflicting requirements, incomplete business logic, unclear UX/navigation, unclear module ownership, and unclear architecture direction.
- Score confidence from `0-100`: execute at `90-100`, execute with warning assumptions at `70-89`, and ask a survey below `70` using `ttb-skill-shared/templates/ttb-clarification-survey.md`.
- Support English, Vietnamese, mixed-language, diacritic-free Vietnamese, and light typo prompts.

## When

User says: "native display", "avatar", "badge", "chip", "rating", "icon display"

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

## Display Component Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  Components/Display/{Name}Display.swift
//  {AppName}
//

import SwiftUI
import TTBaseUIKit

// MARK: - {Name}Avatar
public struct {Name}Avatar: View {
    public enum Size {
        case small   // 32pt
        case medium  // 48pt
        case large   // 64pt
        case xlarge // 96pt

        var dimension: CGFloat {
            switch self {
            case .small:   return 32
            case .medium:  return 48
            case .large:   return 64
            case .xlarge:  return 96
            }
        }
    }

    public enum Content {
        case image(Image)
        case initials(String)
    }

    public var content: Content
    public var size: Size
    public var borderColor: Color?
    public var statusColor: Color?

    public init(content: Content, size: Size = .medium, borderColor: Color? = nil, statusColor: Color? = nil) {
        self.content = content
        self.size = size
        self.borderColor = borderColor
        self.statusColor = statusColor
    }

    private var avatarContent: some View {
        Group {
            switch self.content {
            case .image(let img):
                img
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .initials(let text):
                Text(text.prefix(2).uppercased())
                    .font(.system(size: self.size.dimension * 0.35, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
    }

    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            avatarContent
                .frame(width: self.size.dimension, height: self.size.dimension)
                .clipShape(Circle())  // Circle shape required; chainable corner is not equivalent
                .overlay(
                    Circle()
                        .stroke(self.borderColor ?? Color.clear, lineWidth: 2)
                )

            if let statusColor = self.statusColor {
                Circle()
                    .fill(statusColor)
                    .frame(width: self.size.dimension * 0.25, height: self.size.dimension * 0.25)
                    .overlay(
                        Circle()
                            .stroke(TTView.viewBgCellColor.toColor(), lineWidth: 2)
                    )
                    .offset(x: 2, y: 2)
            }
        }
        .accessibilityLabel(XText("Accessibility.Avatar"))
    }
}

// MARK: - {Name}Chip
public struct {Name}Chip: View {
    public enum Style {
        case filled
        case outlined
    }

    public let textKey: String
    public var style: Style = .filled
    public var iconName: String?
    public var isSelected: Bool = false
    public var onTap: (() -> Void)?

    public init(textKey: String, style: Style = .filled, iconName: String? = nil, isSelected: Bool = false, onTap: (() -> Void)? = nil) {
        self.textKey = textKey
        self.style = style
        self.iconName = iconName
        self.isSelected = isSelected
        self.onTap = onTap
    }

    private var chipColor: Color {
        if self.isSelected {
            return TTView.buttonBgDef.toColor()
        }
        return self.style == .filled ? TTView.viewDisableColor.toColor() : Color.clear
    }

    private var textColor: Color {
        if self.isSelected {
            return .white
        }
        return TTView.textDefColor.toColor()
    }

    public var body: some View {
        Button {
            self.onTap?()
        } label: {
            HStack(spacing: TTSize.P_S) {
                if let iconName = self.iconName {
                    Image(systemName: iconName)
                        .font(.system(size: TTFont.SUB_TITLE_H * 0.9))
                }
                Text(XText(self.textKey))
                    .font(.system(size: TTFont.SUB_TITLE_H, weight: .medium))
            }
            .foregroundColor(self.textColor)
            .pHorizontal(TTSize.P_CONS_DEF)
            .pVertical(TTSize.P_S)
            .background(self.chipColor)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(self.style == .outlined ? TTView.buttonBorderColor.toColor() : Color.clear, lineWidth: TTSize.H_LINEVIEW)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(XText(self.textKey))
    }
}

// MARK: - {Name}Rating
public struct {Name}Rating: View {
    public let rating: Double
    public let maxRating: Int
    public var starSize: CGFloat = 20
    public var isInteractive: Bool = false
    public var onRatingChanged: ((Double) -> Void)?

    public init(rating: Double, maxRating: Int = 5, starSize: CGFloat = 20, isInteractive: Bool = false, onRatingChanged: ((Double) -> Void)? = nil) {
        self.rating = rating
        self.maxRating = maxRating
        self.starSize = starSize
        self.isInteractive = isInteractive
        self.onRatingChanged = onRatingChanged
    }

    public var body: some View {
        HStack(spacing: TTSize.P_S / 2) {
            ForEach(1...self.maxRating, id: \.self) { index in
                let fillAmount = self.rating - Double(index - 1)

                Button {
                    guard self.isInteractive else { return }
                    self.onRatingChanged?(Double(index))
                } label: {
                    Image(systemName: self.starImageName(for: fillAmount))
                        .font(.system(size: self.starSize))
                        .foregroundColor(TTView.notificationBgWarning.toColor())
                        .sizeSquare(width: max(self.starSize, 44))
                }
                .buttonStyle(.plain)
                .disabled(!self.isInteractive)
            }
        }
        .accessibilityLabel(String(format: XText("Accessibility.Rating.Value.Format"), Int(self.rating), self.maxRating))
    }

    private func starImageName(for fillAmount: Double) -> String {
        if fillAmount >= 1.0 {
            return "star.fill"
        } else if fillAmount >= 0.5 {
            return "star.leadinghalf.fill"
        } else {
            return "star"
        }
    }
}

// MARK: - {Name}StatusBadge
public struct {Name}StatusBadge: View {
    public enum Status {
        case success
        case warning
        case error
        case info
        case pending

        var color: Color {
            switch self {
            case .success:  return TTView.notificationBgSuccess.toColor()
            case .warning:  return TTView.notificationBgWarning.toColor()
            case .error:    return TTView.notificationBgError.toColor()
            case .info:     return TTView.buttonBgDef.toColor()
            case .pending:  return TTView.viewDisableColor.toColor()
            }
        }

        var iconName: String {
            switch self {
            case .success:  return "checkmark.circle.fill"
            case .warning:  return "exclamationmark.triangle.fill"
            case .error:    return "xmark.circle.fill"
            case .info:     return "info.circle.fill"
            case .pending:  return "clock.fill"
            }
        }
    }

    public let textKey: String
    public var status: Status

    public init(textKey: String, status: Status) {
        self.textKey = textKey
        self.status = status
    }

    public var body: some View {
        HStack(spacing: TTSize.P_S) {
            Image(systemName: self.status.iconName)
                .font(.system(size: TTFont.SUB_TITLE_H))

            Text(XText(self.textKey))
                .font(.system(size: TTFont.SUB_TITLE_H, weight: .medium))
        }
        .foregroundColor(self.status.color)
        .pHorizontal(TTSize.P_CONS_DEF)
        .pVertical(TTSize.P_S)
        .background(self.status.color.opacity(0.12))
        .corner(byDef: TTSize.CORNER_RADIUS)
        .accessibilityLabel(String(format: XText("Accessibility.Status.Format"), XText(self.textKey)))
    }
}

// MARK: - Preview
struct {Name}Display_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: TTSize.P_XL) {
            HStack(spacing: TTSize.P_L) {
                {Name}Avatar(content: .initials("JD"), size: .small)
                {Name}Avatar(content: .initials("AB"), size: .medium, statusColor: TTView.notificationBgSuccess.toColor())
                {Name}Avatar(content: .initials("TC"), size: .large)
            }

            HStack(spacing: TTSize.P_S) {
                {Name}Chip(textKey: "Preview.Tag.iOS", isSelected: true) { }
                {Name}Chip(textKey: "Preview.Tag.SwiftUI") { }
                {Name}Chip(textKey: "Preview.Tag.UIKit", style: .outlined) { }
            }

            {Name}Rating(rating: 3.5)

            HStack(spacing: TTSize.P_CONS_DEF) {
                {Name}StatusBadge(textKey: "Preview.Status.Success", status: .success)
                {Name}StatusBadge(textKey: "Preview.Status.Warning", status: .warning)
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
3. **Avatar sizes**: small (32pt), medium (48pt), large (64pt), xlarge (96pt)
4. **Avatar**: Circle clip, optional border, optional status dot
5. **Chip**: Capsule shape, filled/outlined styles, optional icon
6. **Rating**: half-star support via `star.leadinghalf.fill`
7. **StatusBadge**: color + icon + text, 0.12 opacity bg
8. **Accessibility**: `.accessibilityLabel()` on all display components
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
