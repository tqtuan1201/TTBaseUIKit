---
description: "Build native SwiftUI input components: text field, secure field, search bar. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-input — Native SwiftUI Input Component Builder

Build reusable input native SwiftUI components using TTBaseUIKit design tokens.

## Mandatory Preflight Execution Gate

Before generating code or modifying files, run `ttb-skill-shared/fragments/ttb-preflight-execution-gate.frag.md`.

Required checks:

- Analyze intent, task type, scope, impacted files/modules, dependencies, architecture constraints, coding standards, and project-specific rules.
- Validate required inputs such as target module, screen/component name, file location, navigation flow, expected output, API contract, state management, routing, localization, naming, and reusable component requirements.
- Detect ambiguity, conflicting requirements, incomplete business logic, unclear UX/navigation, unclear module ownership, and unclear architecture direction.
- Score confidence from `0-100`: execute at `90-100`, execute with warning assumptions at `70-89`, and ask a survey below `70` using `ttb-skill-shared/templates/ttb-clarification-survey.md`.
- Support English, Vietnamese, mixed-language, diacritic-free Vietnamese, and light typo prompts.

## When

User says: "native input", "text field", "search bar", "secure field", "input component"

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
        textKey: Binding<String>,
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
            TextField(self.placeholder, textKey: self.$text)
                .font(.system(size: TTFont.TITLE_H))
                .foregroundColor(TTView.textDefColor.toColor())
                .keyboardType(self.keyboardType)
                .returnKeyType(self.returnKeyType)
                .onSubmit { self.onCommit?() }
        }
        .pHorizontal(TTSize.P_CONS_DEF)
        .frame(height: TTSize.H_TEXTFIELD)
        .bg(byDef: TTView.viewBgCellColor.toColor())
        .corner(byDef: TTSize.CORNER_RADIUS)
        .overlay(
            RoundedRectangle(cornerRadius: TTSize.CORNER_RADIUS)
                .stroke(TTView.buttonBorderColor.toColor(), lineWidth: TTSize.H_LINEVIEW)
        )
    }

    private var underlinedField: some View {
        VStack(spacing: 0) {
            TextField(self.placeholder, textKey: self.$text)
                .font(.system(size: TTFont.TITLE_H))
                .foregroundColor(TTView.textDefColor.toColor())
                .keyboardType(self.keyboardType)
                .returnKeyType(self.returnKeyType)
                .onSubmit { self.onCommit?() }
                .pHorizontal(TTSize.P_S)

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
        textKey: Binding<String>,
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
            SecureField(self.placeholder, textKey: self.$text)
                .font(.system(size: TTFont.TITLE_H))
                .foregroundColor(TTView.textDefColor.toColor())
                .returnKeyType(.done)
                .onSubmit { self.onCommit?() }
        }
        .pHorizontal(TTSize.P_CONS_DEF)
        .frame(height: TTSize.H_TEXTFIELD)
        .bg(byDef: TTView.viewBgCellColor.toColor())
        .corner(byDef: TTSize.CORNER_RADIUS)
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
        textKey: Binding<String>,
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

            TextField(self.placeholder, textKey: self.$text)
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
                .accessibilityLabel(XText("Accessibility.Search.Clear"))
            }
        }
        .pHorizontal(TTSize.P_CONS_DEF)
        .frame(height: TTSize.H_TEXTFIELD)
        .bg(byDef: TTView.viewBgCellColor.toColor())
        .corner(byDef: TTSize.CORNER_RADIUS)
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
            {Name}TextField(placeholder: "Full name", textKey: $name)

            {Name}TextField(placeholder: "Email address", textKey: $name, style: .underlined)

            {Name}SecureField(placeholder: "Password", textKey: $password)

            {Name}SearchBar(placeholder: "Search...", textKey: $search)
        }
        .pAll(TTSize.P_L)
        .bg(byDef: TTView.viewBgColor.toColor())
    }
}
```

## Rules

1. **100% native SwiftUI primitives** — no `TTBaseSUI*`, `SUIBaseView`, or `TTBaseNavigationLink` wrappers in `/native-*` components
2. **TTBaseUIKit tokens + chainable modifiers**: `TTView.*.toColor()`, `TTSize.*`, `TTFont.*`, `.pAll()`, `.bg()`, `.corner()`, `.baseShadow()`, `.size()`
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
