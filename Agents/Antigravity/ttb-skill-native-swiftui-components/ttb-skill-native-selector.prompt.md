---
description: "Build native SwiftUI selector components: toggle, checkbox, radio, segmented control. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-selector — Native SwiftUI Selector Component Builder

Build reusable selector native SwiftUI components using TTBaseUIKit design tokens.

## When

User says: "native selector", "toggle", "checkbox", "radio", "segmented", "picker"

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
    public let label: String
    @Binding public var isChecked: Bool
    public var isDisabled: Bool = false

    public init(label: String, isChecked: Binding<Bool>, isDisabled: Bool = false) {
        self.label = label
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

                Text(self.label)
                    .font(.system(size: TTFont.TITLE_H, weight: .regular))
                    .foregroundColor(TTView.textDefColor.toColor())

                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(self.isDisabled)
        .opacity(self.isDisabled ? 0.5 : 1.0)
        .accessibilityLabel("\(self.label), \(self.isChecked ? "checked" : "unchecked")")
    }
}

// MARK: - {Name}Radio
public struct {Name}Radio: View {
    public struct Option: Identifiable, Equatable {
        public let id: String
        public let label: String

        public init(id: String, label: String) {
            self.id = id
            self.label = label
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

                        Text(option.label)
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
        .accessibilityLabel("Select one option")
    }
}

// MARK: - {Name}SegmentedControl
public struct {Name}SegmentedControl: View {
    public let segments: [String]
    @Binding public var selectedIndex: Int
    public var isDisabled: Bool = false

    public init(segments: [String], selectedIndex: Binding<Int>, isDisabled: Bool = false) {
        self.segments = segments
        self._selectedIndex = selectedIndex
        self.isDisabled = isDisabled
    }

    public var body: some View {
        GeometryReader { geometry in
            let segmentWidth = geometry.size.width / CGFloat(self.segments.count)

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
                    .animation(.easeInOut(duration: 0.2), value: self.selectedIndex)

                // Segments
                HStack(spacing: 0) {
                    ForEach(Array(self.segments.enumerated()), id: \.offset) { index, segment in
                        Button {
                            guard !self.isDisabled else { return }
                            self.selectedIndex = index
                        } label: {
                            Text(segment)
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
        .accessibilityLabel("Segmented control: \(self.segments.joined(separator: ", "))")
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
            {Name}Checkbox(label: "Accept terms and conditions", isChecked: $isChecked1)
            {Name}Checkbox(label: "Subscribe to newsletter", isChecked: $isChecked2, isDisabled: true)

            {Name}SegmentedControl(segments: ["Option 1", "Option 2", "Option 3"], selectedIndex: $selectedSegment)

            {Name}Radio(
                options: [
                    {Name}Radio.Option(id: "a", label: "Option A"),
                    {Name}Radio.Option(id: "b", label: "Option B"),
                    {Name}Radio.Option(id: "c", label: "Option C")
                ],
                selectedId: $selectedRadio
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
