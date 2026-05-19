---
description: "Build native SwiftUI chip and tag components: selectable chip, filter tag, status tag. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-chip — Native SwiftUI Chip Component Builder

Build reusable chip/tag native SwiftUI components using TTBaseUIKit design tokens.

## When

User says: "native chip", "tag", "filter chip", "selectable tag", "category tag"

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

    public let text: String
    public var style: Style = .filled
    public var isSelected: Bool = false
    public var iconName: String?
    public var onTap: (() -> Void)?

    public init(
        text: String,
        style: Style = .filled,
        isSelected: Bool = false,
        iconName: String? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.text = text
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
                Text(self.text)
                    .font(.system(size: TTFont.SUB_TITLE_H, weight: .medium))
            }
            .foregroundColor(self.foregroundColor)
            .padding(.horizontal, TTSize.P_CONS_DEF)
            .padding(.vertical, TTSize.P_S)
            .background(self.backgroundColor)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(self.borderColor, lineWidth: TTSize.H_LINEVIEW)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(self.text), \(self.isSelected ? "selected" : "not selected")")
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
                text: option,
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
        .padding(TTSize.P_L)
        .background(TTView.viewBgColor.toColor())
    }
}
```

## Rules

1. **100% native SwiftUI** — no TTBaseSUI* wrappers
2. **TTBaseUIKit tokens**: `TTView.*.toColor()`, `TTSize.*`, `TTFont.*`
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
