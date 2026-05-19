---
description: "Build native SwiftUI input components: text field, secure field, search bar. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-input — Native SwiftUI Input Component Builder

Build reusable input native SwiftUI components using TTBaseUIKit design tokens.

## When

User says: "native input", "text field", "search bar", "secure field", "input component"

## Input Component Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  Components/Input/{Name}Input.swift
//  {AppName}
//

import SwiftUI
import TTBaseUIKit

// MARK: - {Name}TextField
public struct {Name}TextField: View {
    public enum Style {
        case plain
        case bordered
        case underlined
    }

    public let placeholder: String
    @Binding public var text: String
    public var style: Style = .bordered
    public var isDisabled: Bool = false
    public var keyboardType: UIKeyboardType = .default
    public var returnKeyType: UIReturnKeyType = .done
    public var onCommit: (() -> Void)?

    public init(
        placeholder: String,
        text: Binding<String>,
        style: Style = .bordered,
        isDisabled: Bool = false,
        keyboardType: UIKeyboardType = .default,
        returnKeyType: UIReturnKeyType = .done,
        onCommit: (() -> Void)? = nil
    ) {
        self.placeholder = placeholder
        self._text = text
        self.style = style
        self.isDisabled = isDisabled
        self.keyboardType = keyboardType
        self.returnKeyType = returnKeyType
        self.onCommit = onCommit
    }

    public var body: some View {
        Group {
            switch self.style {
            case .underlined:
                self.underlinedField
            default:
                self.borderedField
            }
        }
        .disabled(self.isDisabled)
        .opacity(self.isDisabled ? 0.5 : 1.0)
    }

    private var borderedField: some View {
        HStack(spacing: TTSize.P_CONS_DEF) {
            TextField(self.placeholder, text: self.$text)
                .font(.system(size: TTFont.TITLE_H))
                .foregroundColor(TTView.textDefColor.toColor())
                .keyboardType(self.keyboardType)
                .returnKeyType(self.returnKeyType)
                .onSubmit { self.onCommit?() }
        }
        .padding(.horizontal, TTSize.P_CONS_DEF)
        .frame(height: TTSize.H_TEXTFIELD)
        .background(TTView.viewBgCellColor.toColor())
        .clipShape(RoundedRectangle(cornerRadius: TTSize.CORNER_RADIUS))
        .overlay(
            RoundedRectangle(cornerRadius: TTSize.CORNER_RADIUS)
                .stroke(TTView.buttonBorderColor.toColor(), lineWidth: TTSize.H_LINEVIEW)
        )
    }

    private var underlinedField: some View {
        VStack(spacing: 0) {
            TextField(self.placeholder, text: self.$text)
                .font(.system(size: TTFont.TITLE_H))
                .foregroundColor(TTView.textDefColor.toColor())
                .keyboardType(self.keyboardType)
                .returnKeyType(self.returnKeyType)
                .onSubmit { self.onCommit?() }
                .padding(.horizontal, TTSize.P_S)

            Color(TTView.lineDefColor)
                .frame(height: TTSize.H_LINEVIEW)
        }
    }
}

// MARK: - {Name}SecureField
public struct {Name}SecureField: View {
    public let placeholder: String
    @Binding public var text: String
    public var isDisabled: Bool = false
    public var onCommit: (() -> Void)?

    public init(
        placeholder: String,
        text: Binding<String>,
        isDisabled: Bool = false,
        onCommit: (() -> Void)? = nil
    ) {
        self.placeholder = placeholder
        self._text = text
        self.isDisabled = isDisabled
        self.onCommit = onCommit
    }

    public var body: some View {
        HStack(spacing: TTSize.P_CONS_DEF) {
            SecureField(self.placeholder, text: self.$text)
                .font(.system(size: TTFont.TITLE_H))
                .foregroundColor(TTView.textDefColor.toColor())
                .returnKeyType(.done)
                .onSubmit { self.onCommit?() }
        }
        .padding(.horizontal, TTSize.P_CONS_DEF)
        .frame(height: TTSize.H_TEXTFIELD)
        .background(TTView.viewBgCellColor.toColor())
        .clipShape(RoundedRectangle(cornerRadius: TTSize.CORNER_RADIUS))
        .overlay(
            RoundedRectangle(cornerRadius: TTSize.CORNER_RADIUS)
                .stroke(TTView.buttonBorderColor.toColor(), lineWidth: TTSize.H_LINEVIEW)
        )
        .disabled(self.isDisabled)
        .opacity(self.isDisabled ? 0.5 : 1.0)
        .accessibilityLabel(self.placeholder)
    }
}

// MARK: - {Name}SearchBar
public struct {Name}SearchBar: View {
    public let placeholder: String
    @Binding public var text: String
    public var onSubmit: (() -> Void)?
    public var onClear: (() -> Void)?

    public init(
        placeholder: String = "Search...",
        text: Binding<String>,
        onSubmit: (() -> Void)? = nil,
        onClear: (() -> Void)? = nil
    ) {
        self.placeholder = placeholder
        self._text = text
        self.onSubmit = onSubmit
        self.onClear = onClear
    }

    public var body: some View {
        HStack(spacing: TTSize.P_S) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: TTFont.SUB_TITLE_H))
                .foregroundColor(TTView.iconColor.toColor())

            TextField(self.placeholder, text: self.$text)
                .font(.system(size: TTFont.TITLE_H))
                .foregroundColor(TTView.textDefColor.toColor())
                .returnKeyType(.search)
                .onSubmit {
                    self.onSubmit?()
                }
                .accessibilityLabel(self.placeholder)

            if !self.text.isEmpty {
                Button {
                    self.text = ""
                    self.onClear?()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: TTFont.SUB_TITLE_H))
                        .foregroundColor(TTView.iconColor.toColor())
                }
                .accessibilityLabel("Clear search")
            }
        }
        .padding(.horizontal, TTSize.P_CONS_DEF)
        .frame(height: TTSize.H_TEXTFIELD)
        .background(TTView.viewBgCellColor.toColor())
        .clipShape(RoundedRectangle(cornerRadius: TTSize.CORNER_RADIUS))
        .overlay(
            RoundedRectangle(cornerRadius: TTSize.CORNER_RADIUS)
                .stroke(TTView.buttonBorderColor.toColor(), lineWidth: TTSize.H_LINEVIEW)
        )
    }
}

// MARK: - Preview
struct {Name}Input_Previews: PreviewProvider {
    @State static var name = ""
    @State static var password = ""
    @State static var search = ""

    static var previews: some View {
        VStack(spacing: TTSize.P_L) {
            {Name}TextField(placeholder: "Full name", text: $name)

            {Name}TextField(placeholder: "Email address", text: $name, style: .underlined)

            {Name}SecureField(placeholder: "Password", text: $password)

            {Name}SearchBar(placeholder: "Search...", text: $search)
        }
        .padding(TTSize.P_L)
        .background(TTView.viewBgColor.toColor())
    }
}
```

## Rules

1. **100% native SwiftUI** — no TTBaseSUI* wrappers
2. **TTBaseUIKit tokens**: `TTView.*.toColor()`, `TTSize.*`, `TTFont.*`
3. **Height = TTSize.H_TEXTFIELD (35pt)** — consistent input height
4. **Corner radius = TTSize.CORNER_RADIUS (4pt)** — default corner
5. **Border = TTSize.H_LINEVIEW (1.5pt)** — line thickness
6. **Keyboard types**: pass `UIKeyboardType` for appropriate keyboard
7. **Return key**: use `returnKeyType` and `.onSubmit` for form handling
8. **Search bar**: clear button with `.isEmpty` check
9. **Accessibility**: `.accessibilityLabel()` on all fields
10. **PreviewProvider** at bottom
11. **MARKER COMMENT** at top

## Input Style Guide

| Style | Border | Bottom Line | Usage |
|-------|--------|-------------|-------|
| .bordered | Full border | None | Default input |
| .underlined | None | Bottom line only | Minimalist form |
| .plain | None | None | Inline search |

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
