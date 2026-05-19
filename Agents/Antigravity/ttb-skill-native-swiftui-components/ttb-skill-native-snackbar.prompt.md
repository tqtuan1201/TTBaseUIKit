---
description: "Build native SwiftUI snackbar/toast notification component. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-snackbar — Native SwiftUI Snackbar Component Builder

Build reusable snackbar/toast native SwiftUI components using TTBaseUIKit design tokens.

## When

User says: "native snackbar", "toast", "notification bar", "bottom toast", "snack message"

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
            case .default:  return Color(hex: "333333")
            case .success:  return TTView.notificationBgSuccess.toColor()
            case .warning:  return TTView.notificationBgWarning.toColor()
            case .error:    return TTView.notificationBgError.toColor()
            }
        }
    }

    public let message: String
    public var style: Style = .default
    public var actionTitle: String?
    public var action: (() -> Void)?
    public var dismissAction: (() -> Void)?

    public init(
        message: String,
        style: Style = .default,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil,
        dismissAction: (() -> Void)? = nil
    ) {
        self.message = message
        self.style = style
        self.actionTitle = actionTitle
        self.action = action
        self.dismissAction = dismissAction
    }

    public var body: some View {
        HStack(spacing: TTSize.P_CONS_DEF) {
            Text(self.message)
                .font(.system(size: TTFont.TITLE_H, weight: .medium))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            if let actionTitle = self.actionTitle, let action = self.action {
                Button(action: action) {
                    Text(actionTitle.uppercased())
                        .font(.system(size: TTFont.SUB_TITLE_H, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.leading, TTSize.P_CONS_DEF)
                }
            }

            if self.actionTitle == nil {
                Button {
                    self.dismissAction?()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: TTFont.SUB_TITLE_H, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.leading, TTSize.P_CONS_DEF)
                }
            }
        }
        .padding(.horizontal, TTSize.P_L)
        .padding(.vertical, TTSize.P_CONS_DEF)
        .background(self.style.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: TTSize.CORNER_RADIUS))
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        .padding(.horizontal, TTSize.P_CONS_DEF)
        .accessibilityLabel("\(self.styleAccessibilityLabel): \(self.message)")
    }

    private var styleAccessibilityLabel: String {
        switch self.style {
        case .default:  return "Notification"
        case .success:  return "Success"
        case .warning:  return "Warning"
        case .error:    return "Error"
        }
    }
}

// MARK: - {Name}SnackbarModifier
public struct {Name}SnackbarModifier: ViewModifier {
    @Binding public var isPresented: Bool
    public let message: String
    public var style: {Name}Snackbar.Style = .default
    public var duration: Double = 3.0
    public var actionTitle: String?
    public var action: (() -> Void)?

    public init(
        isPresented: Binding<Bool>,
        message: String,
        style: {Name}Snackbar.Style = .default,
        duration: Double = 3.0,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self._isPresented = isPresented
        self.message = message
        self.style = style
        self.duration = duration
        self.actionTitle = actionTitle
        self.action = action
    }

    public func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content

            if self.isPresented {
                {Name}Snackbar(
                    message: self.message,
                    style: self.style,
                    actionTitle: self.actionTitle,
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
        message: String,
        style: {Name}Snackbar.Style = .default,
        duration: Double = 3.0,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) -> some View {
        modifier(
            {Name}SnackbarModifier(
                isPresented: isPresented,
                message: message,
                style: style,
                duration: duration,
                actionTitle: actionTitle,
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
            Button("Show Success") { showSuccess = true }
            Button("Show Error") { showError = true }
            Button("Show With Action") { showDefault = true }
        }
        .padding(TTSize.P_L)
        .snackbar(isPresented: $showSuccess, message: "Changes saved successfully!", style: .success)
        .snackbar(isPresented: $showError, message: "Failed to save changes.", style: .error, duration: 5.0)
        .snackbar(
            isPresented: $showDefault,
            message: "Undo this action?",
            actionTitle: "UNDO",
            action: { }
        )
        .background(TTView.viewBgColor.toColor())
    }
}
```

## Rules

1. **100% native SwiftUI** — no TTBaseSUI* wrappers
2. **TTBaseUIKit tokens**: `TTView.*.toColor()`, `TTSize.*`, `TTFont.*`
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
