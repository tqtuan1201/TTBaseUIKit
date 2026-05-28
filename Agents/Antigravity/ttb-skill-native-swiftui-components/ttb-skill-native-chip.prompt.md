---
description: "Build native SwiftUI chip and tag components: selectable chip, filter tag, status tag. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-chip — Native SwiftUI Chip Component Builder

Build reusable chip/tag native SwiftUI components using TTBaseUIKit design tokens.

## Mandatory Preflight Execution Gate

Before generating code or modifying files, run `ttb-skill-shared/fragments/ttb-preflight-execution-gate.frag.md`.

Required checks:

- Analyze intent, task type, scope, impacted files/modules, dependencies, architecture constraints, coding standards, and project-specific rules.
- Validate required inputs such as target module, screen/component name, file location, navigation flow, expected output, API contract, state management, routing, localization, naming, and reusable component requirements.
- Detect ambiguity, conflicting requirements, incomplete business logic, unclear UX/navigation, unclear module ownership, and unclear architecture direction.
- Score confidence from `0-100`: execute at `90-100`, execute with warning assumptions at `70-89`, and ask a survey below `70` using `ttb-skill-shared/templates/ttb-clarification-survey.md`.
- Support English, Vietnamese, mixed-language, diacritic-free Vietnamese, and light typo prompts.

## When

User says: "native chip", "tag", "filter chip", "selectable tag", "category tag"

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

## Chip Component Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  Components/Chip/{Name}Chip.swift
//  {AppName}
//

import SwiftUI
import TTBaseUIKit

// MARK: - {Name}Chip
public struct {Name}Chip: View {
    public enum Style {
        case filled
        case outlined
        case soft
    }

    public let textKey: String
    public var style: Style = .filled
    public var isSelected: Bool = false
    public var iconName: String?
    public var onTap: (() -> Void)?

    public init(
        textKey: String,
        style: Style = .filled,
        isSelected: Bool = false,
        iconName: String? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.textKey = textKey
        self.style = style
        self.isSelected = isSelected
        self.iconName = iconName
        self.onTap = onTap
    }

    private var backgroundColor: Color {
        switch self.style {
        case .filled:
            return self.isSelected ? TTView.buttonBgDef.toColor() : TTView.viewDisableColor.toColor()
        case .outlined:
            return self.isSelected ? TTView.buttonBgDef.toColor().opacity(0.1) : Color.clear
        case .soft:
            return self.isSelected ? TTView.buttonBgDef.toColor().opacity(0.15) : TTView.viewDisableColor.toColor().opacity(0.1)
        }
    }

    private var foregroundColor: Color {
        if self.isSelected {
            switch self.style {
            case .filled: return .white
            case .outlined, .soft: return TTView.buttonBgDef.toColor()
            }
        }
        return TTView.textDefColor.toColor()
    }

    private var borderColor: Color {
        self.style == .outlined ? TTView.buttonBorderColor.toColor() : Color.clear
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
            .foregroundColor(self.foregroundColor)
            .pHorizontal(TTSize.P_CONS_DEF)
            .pVertical(TTSize.P_S)
            .background(self.backgroundColor)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(self.borderColor, lineWidth: TTSize.H_LINEVIEW)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(String(format: XText("Accessibility.Chip.State.Format"), XText(self.textKey), self.isSelected ? XText("Accessibility.State.Selected") : XText("Accessibility.State.NotSelected")))
    }
}

// MARK: - {Name}FilterChipGroup
public struct {Name}FilterChipGroup: View {
    public let options: [String]
    @Binding public var selectedOptions: Set<String>
    public var allowMultiple: Bool = true

    public init(options: [String], selectedOptions: Binding<Set<String>>, allowMultiple: Bool = true) {
        self.options = options
        self._selectedOptions = selectedOptions
        self.allowMultiple = allowMultiple
    }

    public var body: some View {
        FlowLayout(items: self.options, spacing: TTSize.P_S) { option in
            {Name}Chip(
                textKey: option,
                style: .outlined,
                isSelected: self.selectedOptions.contains(option)
            ) {
                if self.allowMultiple {
                    if self.selectedOptions.contains(option) {
                        self.selectedOptions.remove(option)
                    } else {
                        self.selectedOptions.insert(option)
                    }
                } else {
                    self.selectedOptions = [option]
                }
            }
        }
    }
}

// MARK: - FlowLayout (iOS 14+ compatible using LazyVGrid)
public struct FlowLayout<Content: View>: View {
    public let items: [String]
    public let spacing: CGFloat
    public let content: (String) -> Content

    public init(
        items: [String],
        spacing: CGFloat = 8,
        @ViewBuilder content: @escaping (String) -> Content
    ) {
        self.items = items
        self.spacing = spacing
        self.content = content
    }

    public var body: some View {
        LazyVGrid(
            columns: [GridItem(.adaptive(minimum: 80, maximum: .infinity), spacing: spacing)],
            alignment: .leading,
            spacing: spacing
        ) {
            ForEach(self.items, id: \.self) { item in
                self.content(item)
            }
        }
    }
}

// MARK: - Preview
struct {Name}Chip_Previews: PreviewProvider {
    @State static var selected1 = false
    @State static var selectedOptions: Set<String> = ["iOS", "Swift"]

    static var previews: some View {
        VStack(spacing: TTSize.P_XL) {
            HStack(spacing: TTSize.P_S) {
                {Name}Chip("Default", isSelected: false) { }
                {Name}Chip("Selected", isSelected: true) { }
            }

            HStack(spacing: TTSize.P_S) {
                {Name}Chip("Outlined", style: .outlined, isSelected: false) { }
                {Name}Chip("Outlined", style: .outlined, isSelected: true) { }
            }

            HStack(spacing: TTSize.P_S) {
                {Name}Chip("Soft", style: .soft, isSelected: false) { }
                {Name}Chip("Soft", style: .soft, isSelected: true) { }
            }

            HStack(spacing: TTSize.P_S) {
                {Name}Chip("iOS", style: .outlined, isSelected: true, iconName: "apple.logo") { }
                {Name}Chip("Swift", style: .outlined, isSelected: true, iconName: "swift") { }
            }

            {Name}FilterChipGroup(
                options: ["All", "iOS", "Android", "Web", "Desktop"],
                selectedOptions: $selectedOptions
            )
        }
        .pAll(TTSize.P_L)
        .bg(byDef: TTView.viewBgColor.toColor())
    }
}
```

## Rules

1. **100% native SwiftUI primitives** — no `TTBaseSUI*`, `SUIBaseView`, or `TTBaseNavigationLink` wrappers in `/native-*` components
2. **TTBaseUIKit tokens + chainable modifiers**: `TTView.*.toColor()`, `TTSize.*`, `TTFont.*`, `.pAll()`, `.bg()`, `.corner()`, `.baseShadow()`, `.size()`
3. **Shapes**: `.clipShape(Capsule())` for pill-shaped chips
4. **Styles**: `.filled` (solid bg), `.outlined` (border), `.soft` (light bg)
5. **FlowLayout**: custom `Layout` protocol implementation for wrap
6. **FilterChipGroup**: multi-select with `Set<String>`, single-select with `allowMultiple: false`
7. **Accessibility**: `.accessibilityLabel()` on all chips
8. **PreviewProvider** at bottom
9. **MARKER COMMENT** at top
10. **FlowLayout**: `Layout` protocol is iOS 16+. For iOS 14+, use `LazyVGrid` with `AdaptiveGridItem` pattern or manual `VStack` wrapping.

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
