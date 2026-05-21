---
description: "Build native SwiftUI snackbar/toast notification component. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-snackbar — Native SwiftUI Snackbar Component Builder

Build reusable snackbar/toast native SwiftUI components using TTBaseUIKit design tokens.

## When

User says: "native snackbar", "toast", "notification bar", "bottom toast", "snack message"

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

## Snackbar Component Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  Components/Snackbar/{Name}Snackbar.swift
//  {AppName}
//

import SwiftUI
import TTBaseUIKit

// MARK: - {Name}Snackbar
public struct {Name}Snackbar: View {
    public enum Style {
        case `default`
        case success
        case warning
        case error

        var backgroundColor: Color {
            switch self {
            case .default:  return TTView.textHeaderColor.toColor()
            case .success:  return TTView.notificationBgSuccess.toColor()
            case .warning:  return TTView.notificationBgWarning.toColor()
            case .error:    return TTView.notificationBgError.toColor()
            }
        }
    }

    public let messageKey: String
    public var style: Style = .default
    public var actionTitleKey: String?
    public var action: (() -> Void)?
    public var dismissAction: (() -> Void)?

    public init(
        messageKey: String,
        style: Style = .default,
        actionTitleKey: String? = nil,
        action: (() -> Void)? = nil,
        dismissAction: (() -> Void)? = nil
    ) {
        self.messageKey = messageKey
        self.style = style
        self.actionTitleKey = actionTitleKey
        self.action = action
        self.dismissAction = dismissAction
    }

    public var body: some View {
        HStack(spacing: TTSize.P_CONS_DEF) {
            Text(XText(self.messageKey))
                .font(.system(size: TTFont.TITLE_H, weight: .medium))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            if let actionTitleKey = self.actionTitleKey, let action = self.action {
                Button(action: action) {
                    Text(XText(actionTitleKey).uppercased())
                        .font(.system(size: TTFont.SUB_TITLE_H, weight: .bold))
                        .foregroundColor(.white)
                        .pLeading(TTSize.P_CONS_DEF)
                }
            }

            if self.actionTitleKey == nil {
                Button {
                    self.dismissAction?()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: TTFont.SUB_TITLE_H, weight: .bold))
                        .foregroundColor(.white)
                        .pLeading(TTSize.P_CONS_DEF)
                }
            }
        }
        .pHorizontal(TTSize.P_L)
        .pVertical(TTSize.P_CONS_DEF)
        .bg(byDef: self.style.backgroundColor)
        .corner(byDef: TTSize.CORNER_RADIUS)
        .baseShadow(corner: TTSize.CORNER_RADIUS, color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        .pHorizontal(TTSize.P_CONS_DEF)
        .accessibilityLabel(String(format: XText("Accessibility.Snackbar.Format"), XText(self.styleAccessibilityKey), XText(self.messageKey)))
    }

    private var styleAccessibilityKey: String {
        switch self.style {
        case .default:  return "Accessibility.Notification"
        case .success:  return "Accessibility.Success"
        case .warning:  return "Accessibility.Warning"
        case .error:    return "Accessibility.Error"
        }
    }
}

// MARK: - {Name}SnackbarModifier
public struct {Name}SnackbarModifier: ViewModifier {
    @Binding public var isPresented: Bool
    public let messageKey: String
    public var style: {Name}Snackbar.Style = .default
    public var duration: Double = 3.0
    public var actionTitleKey: String?
    public var action: (() -> Void)?

    public init(
        isPresented: Binding<Bool>,
        messageKey: String,
        style: {Name}Snackbar.Style = .default,
        duration: Double = 3.0,
        actionTitleKey: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self._isPresented = isPresented
        self.messageKey = messageKey
        self.style = style
        self.duration = duration
        self.actionTitleKey = actionTitleKey
        self.action = action
    }

    public func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content

            if self.isPresented {
                {Name}Snackbar(
                    messageKey: self.messageKey,
                    style: self.style,
                    actionTitleKey: self.actionTitleKey,
                    action: self.action,
                    dismissAction: { self.isPresented = false }
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.duration) {
                        withAnimation { self.isPresented = false }
                    }
                }
            }
        }
    }
}

public extension View {
    func snackbar(
        isPresented: Binding<Bool>,
        messageKey: String,
        style: {Name}Snackbar.Style = .default,
        duration: Double = 3.0,
        actionTitleKey: String? = nil,
        action: (() -> Void)? = nil
    ) -> some View {
        modifier(
            {Name}SnackbarModifier(
                isPresented: isPresented,
                messageKey: messageKey,
                style: style,
                duration: duration,
                actionTitleKey: actionTitleKey,
                action: action
            )
        )
    }
}

// MARK: - Preview
struct {Name}Snackbar_Previews: PreviewProvider {
    @State static var showSuccess = false
    @State static var showError = false
    @State static var showDefault = false

    static var previews: some View {
        VStack(spacing: TTSize.P_L) {
            Button(action: { showSuccess = true }) { Text(XText("Preview.Snackbar.ShowSuccess")) }
            Button(action: { showError = true }) { Text(XText("Preview.Snackbar.ShowError")) }
            Button(action: { showDefault = true }) { Text(XText("Preview.Snackbar.ShowAction")) }
        }
        .pAll(TTSize.P_L)
        .snackbar(isPresented: $showSuccess, messageKey: "Preview.Snackbar.Success", style: .success)
        .snackbar(isPresented: $showError, messageKey: "Preview.Snackbar.Error", style: .error, duration: 5.0)
        .snackbar(
            isPresented: $showDefault,
            messageKey: "Preview.Snackbar.Undo",
            actionTitleKey: "Preview.Snackbar.Undo.Action",
            action: { }
        )
        .bg(byDef: TTView.viewBgColor.toColor())
    }
}
```

## Rules

1. **100% native SwiftUI primitives** — no `TTBaseSUI*`, `SUIBaseView`, or `TTBaseNavigationLink` wrappers in `/native-*` components
2. **TTBaseUIKit tokens + chainable modifiers**: `TTView.*.toColor()`, `TTSize.*`, `TTFont.*`, `.pAll()`, `.bg()`, `.corner()`, `.baseShadow()`, `.size()`
3. **Background**: dark gray (#333333) default, TTBaseUIKit status colors for other styles
4. **Text**: white, medium weight, leading alignment
5. **Corner radius = TTSize.CORNER_RADIUS (4pt)**
6. **Shadow: opacity 0.15, radius 8, y 4**
7. **Auto-dismiss**: `DispatchQueue.main.asyncAfter` with configurable duration
8. **Transition**: `.move(edge: .bottom).combined(with: .opacity)`
9. **Accessibility**: `.accessibilityLabel()` with style prefix
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
