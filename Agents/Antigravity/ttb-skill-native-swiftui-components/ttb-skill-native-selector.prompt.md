---
description: "Build native SwiftUI selector components: toggle, checkbox, radio, segmented control. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-selector — Native SwiftUI Selector Component Builder

Build reusable selector native SwiftUI components using TTBaseUIKit design tokens.

## When

User says: "native selector", "toggle", "checkbox", "radio", "segmented", "picker"

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

## Selector Component Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  Components/Selector/{Name}Selector.swift
//  {AppName}
//

import SwiftUI
import TTBaseUIKit

// MARK: - {Name}Checkbox
public struct {Name}Checkbox: View {
    public let labelKey: String
    @Binding public var isChecked: Bool
    public var isDisabled: Bool = false

    public init(labelKey: String, isChecked: Binding<Bool>, isDisabled: Bool = false) {
        self.labelKey = labelKey
        self._isChecked = isChecked
        self.isDisabled = isDisabled
    }

    public var body: some View {
        Button {
            guard !self.isDisabled else { return }
            self.isChecked.toggle()
        } label: {
            HStack(spacing: TTSize.P_CONS_DEF) {
                Image(systemName: self.isChecked ? "checkmark.square.fill" : "square")
                    .font(.system(size: TTSize.H_SMALL_ICON * 0.7))
                    .foregroundColor(self.isChecked ? TTView.buttonBgDef.toColor() : TTView.iconColor.toColor())

                Text(XText(self.labelKey))
                    .font(.system(size: TTFont.TITLE_H, weight: .regular))
                    .foregroundColor(TTView.textDefColor.toColor())

                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(self.isDisabled)
        .opacity(self.isDisabled ? 0.5 : 1.0)
        .accessibilityLabel(String(format: XText("Accessibility.Checkbox.State.Format"), XText(self.labelKey), self.isChecked ? XText("Accessibility.State.Checked") : XText("Accessibility.State.Unchecked")))
    }
}

// MARK: - {Name}Radio
public struct {Name}Radio: View {
    public struct Option: Identifiable, Equatable {
        public let id: String
        public let labelKey: String

        public init(id: String, labelKey: String) {
            self.id = id
            self.labelKey = labelKey
        }
    }

    public let options: [Option]
    @Binding public var selectedId: String?
    public var isDisabled: Bool = false

    public init(options: [Option], selectedId: Binding<String?>, isDisabled: Bool = false) {
        self.options = options
        self._selectedId = selectedId
        self.isDisabled = isDisabled
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: TTSize.P_CONS_DEF) {
            ForEach(self.options) { option in
                Button {
                    guard !self.isDisabled else { return }
                    self.selectedId = option.id
                } label: {
                    HStack(spacing: TTSize.P_CONS_DEF) {
                        ZStack {
                            Circle()
                                .stroke(self.selectedId == option.id ? TTView.buttonBgDef.toColor() : TTView.iconColor.toColor(), lineWidth: TTSize.H_LINEVIEW)
                                .frame(width: 20, height: 20)

                            if self.selectedId == option.id {
                                Circle()
                                    .fill(TTView.buttonBgDef.toColor())
                                    .frame(width: 12, height: 12)
                            }
                        }

                        Text(XText(option.labelKey))
                            .font(.system(size: TTFont.TITLE_H, weight: .regular))
                            .foregroundColor(TTView.textDefColor.toColor())

                        Spacer()
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .disabled(self.isDisabled)
            }
        }
        .opacity(self.isDisabled ? 0.5 : 1.0)
        .accessibilityLabel(XText("Accessibility.Radio.SelectOne"))
    }
}

// MARK: - {Name}SegmentedControl
public struct {Name}SegmentedControl: View {
    public let segmentKeys: [String]
    @Binding public var selectedIndex: Int
    public var isDisabled: Bool = false

    public init(segmentKeys: [String], selectedIndex: Binding<Int>, isDisabled: Bool = false) {
        self.segmentKeys = segmentKeys
        self._selectedIndex = selectedIndex
        self.isDisabled = isDisabled
    }

    public var body: some View {
        GeometryReader { geometry in
            let segmentWidth = geometry.size.width / CGFloat(self.segmentKeys.count)

            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: TTSize.CORNER_RADIUS)
                    .fill(TTView.viewBgCellColor.toColor())
                    .overlay(
                        RoundedRectangle(cornerRadius: TTSize.CORNER_RADIUS)
                            .stroke(TTView.buttonBorderColor.toColor(), lineWidth: TTSize.H_LINEVIEW)
                    )

                // Selection indicator
                RoundedRectangle(cornerRadius: TTSize.CORNER_RADIUS)
                    .fill(TTView.buttonBgDef.toColor().opacity(0.15))
                    .frame(width: segmentWidth)
                    .offset(x: CGFloat(self.selectedIndex) * segmentWidth)
                    .animation(.easeInOut(duration: 0.2))

                // Segments
                HStack(spacing: 0) {
                    ForEach(Array(self.segmentKeys.enumerated()), id: \.offset) { index, segmentKey in
                        Button {
                            guard !self.isDisabled else { return }
                            self.selectedIndex = index
                        } label: {
                            Text(XText(segmentKey))
                                .font(.system(size: TTFont.SUB_TITLE_H, weight: self.selectedIndex == index ? .semibold : .regular))
                                .foregroundColor(self.selectedIndex == index ? TTView.buttonBgDef.toColor() : TTView.textDefColor.toColor())
                                .frame(width: segmentWidth)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .disabled(self.isDisabled)
                    }
                }
            }
        }
        .frame(height: TTSize.H_SEG)
        .opacity(self.isDisabled ? 0.5 : 1.0)
        .accessibilityLabel(XText("Accessibility.SegmentedControl"))
    }
}

// MARK: - Preview
struct {Name}Selector_Previews: PreviewProvider {
    @State static var isOn = false
    @State static var isChecked1 = false
    @State static var isChecked2 = false
    @State static var selectedSegment = 0
    @State static var selectedRadio: String? = "a"

    static var previews: some View {
        VStack(spacing: TTSize.P_XL) {
            {Name}Checkbox(labelKey: "Settings.Terms.Accept", isChecked: $isChecked1)
            {Name}Checkbox(labelKey: "Settings.Newsletter.Subscribe", isChecked: $isChecked2, isDisabled: true)

            {Name}SegmentedControl(segmentKeys: ["Segment.Option.One", "Segment.Option.Two", "Segment.Option.Three"], selectedIndex: $selectedSegment)

            {Name}Radio(
                options: [
                    {Name}Radio.Option(id: "a", labelKey: "Radio.Option.A"),
                    {Name}Radio.Option(id: "b", labelKey: "Radio.Option.B"),
                    {Name}Radio.Option(id: "c", labelKey: "Radio.Option.C")
                ],
                selectedId: $selectedRadio
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
3. **Toggle**: use `SwitchToggleStyle(tint:)` for native toggle
4. **Checkbox**: use SF Symbols `checkmark.square.fill` / `square`
5. **Radio**: custom ZStack circle with 20pt diameter
6. **Segmented**: GeometryReader + animation for sliding indicator
7. **Disabled state**: `.opacity(0.5)` + `.disabled(true)`
8. **Accessibility**: `.accessibilityLabel()` on all selectors
9. **`.contentShape(Rectangle())`** for full-row tap targets
10. **PreviewProvider** at bottom
11. **MARKER COMMENT** at top

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
