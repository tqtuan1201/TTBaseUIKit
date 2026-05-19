---
description: "Build native SwiftUI alert and confirmation dialog components. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-alert — Native SwiftUI Alert Component Builder

Build reusable alert and confirmation dialog native SwiftUI components using TTBaseUIKit design tokens.

## When

User says: "native alert", "confirmation dialog", "alert dialog", "prompt"

## Alert Component Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  Components/Alert/{Name}Alert.swift
//  {AppName}
//

import SwiftUI
import TTBaseUIKit

// MARK: - {Name}AlertModifier
public struct {Name}AlertModifier: ViewModifier {
    @Binding public var isPresented: Bool
    public let title: String
    public var message: String?
    public var primaryButtonTitle: String
    public var primaryAction: () -> Void
    public var secondaryButtonTitle: String?
    public var secondaryAction: (() -> Void)?
    public var dismissAction: (() -> Void)?

    public init(
        isPresented: Binding<Bool>,
        title: String,
        message: String? = nil,
        primaryButtonTitle: String,
        primaryAction: @escaping () -> Void,
        secondaryButtonTitle: String? = nil,
        secondaryAction: (() -> Void)? = nil,
        dismissAction: (() -> Void)? = nil
    ) {
        self._isPresented = isPresented
        self.title = title
        self.message = message
        self.primaryButtonTitle = primaryButtonTitle
        self.primaryAction = primaryAction
        self.secondaryButtonTitle = secondaryButtonTitle
        self.secondaryAction = secondaryAction
        self.dismissAction = dismissAction
    }

    public func body(content: Content) -> some View {
        ZStack {
            content

            if self.isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        self.dismiss()
                    }

                self.alertView
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: self.isPresented)
    }

    private func dismiss() {
        self.dismissAction?()
        self.isPresented = false
    }

    private var alertView: some View {
        VStack(spacing: TTSize.P_L) {
            VStack(spacing: TTSize.P_S) {
                Text(self.title)
                    .font(.system(size: TTFont.HEADER_H, weight: .bold))
                    .foregroundColor(TTView.textHeaderColor.toColor())
                    .multilineTextAlignment(.center)

                if let message = self.message {
                    Text(message)
                        .font(.system(size: TTFont.TITLE_H, weight: .regular))
                        .foregroundColor(TTView.textDefColor.toColor())
                        .multilineTextAlignment(.center)
                }
            }

            VStack(spacing: TTSize.P_CONS_DEF) {
                Button {
                    self.primaryAction()
                    self.isPresented = false
                } label: {
                    Text(self.primaryButtonTitle)
                        .font(.system(size: TTFont.TITLE_H, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: TTSize.H_BUTTON)
                        .background(TTView.buttonBgDef.toColor())
                        .clipShape(RoundedRectangle(cornerRadius: TTSize.CORNER_BUTTON))
                }
                .accessibilityLabel(self.primaryButtonTitle)

                if let secondaryTitle = self.secondaryButtonTitle {
                    Button {
                        self.secondaryAction?()
                        self.isPresented = false
                    } label: {
                        Text(secondaryTitle)
                            .font(.system(size: TTFont.TITLE_H, weight: .semibold))
                            .foregroundColor(TTView.buttonBgDef.toColor())
                            .frame(maxWidth: .infinity)
                            .frame(height: TTSize.H_BUTTON)
                            .background(Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: TTSize.CORNER_BUTTON))
                    }
                    .accessibilityLabel(secondaryTitle)
                }
            }
        }
        .padding(TTSize.P_L)
        .frame(maxWidth: 280)
        .background(TTView.viewBgCellColor.toColor())
        .clipShape(RoundedRectangle(cornerRadius: TTSize.CORNER_PANEL))
        .shadow(color: .black.opacity(0.2), radius: 16, x: 0, y: 8)
    }
}

public extension View {
    func {Name}Alert(
        isPresented: Binding<Bool>,
        title: String,
        message: String? = nil,
        primaryButtonTitle: String,
        primaryAction: @escaping () -> Void,
        secondaryButtonTitle: String? = nil,
        secondaryAction: (() -> Void)? = nil,
        dismissAction: (() -> Void)? = nil
    ) -> some View {
        modifier(
            {Name}AlertModifier(
                isPresented: isPresented,
                title: title,
                message: message,
                primaryButtonTitle: primaryButtonTitle,
                primaryAction: primaryAction,
                secondaryButtonTitle: secondaryButtonTitle,
                secondaryAction: secondaryAction,
                dismissAction: dismissAction
            )
        )
    }
}

// MARK: - Preview
struct {Name}Alert_Previews: PreviewProvider {
    @State static var showAlert = false
    @State static var showConfirm = false

    static var previews: some View {
        ZStack {
            Color.gray.opacity(0.3).ignoresSafeArea()

            VStack(spacing: TTSize.P_L) {
                Button("Show Alert") { showAlert = true }
                Button("Show Confirmation") { showConfirm = true }
            }
            .padding()

            Color.clear
                .{Name}Alert(
                    isPresented: $showAlert,
                    title: "Error",
                    message: "Unable to connect to the server. Please check your internet connection."
                ) {
                    print("OK tapped")
                }

            Color.clear
                .{Name}Alert(
                    isPresented: $showConfirm,
                    title: "Delete Item?",
                    message: "This action cannot be undone.",
                    primaryButtonTitle: "Delete",
                    primaryAction: { print("Delete") },
                    secondaryButtonTitle: "Cancel",
                    secondaryAction: { print("Cancel") }
                )
        }
    }
}
```

## Rules

1. **100% native SwiftUI** — no TTBaseSUI* wrappers
2. **TTBaseUIKit tokens**: `TTView.*.toColor()`, `TTSize.*`, `TTFont.*`
3. **Width**: max 280pt, centered
4. **Corner radius = TTSize.CORNER_PANEL (8pt)**
5. **Shadow**: opacity 0.2, radius 16, y: 8
6. **Primary button**: brand blue bg, white text
7. **Secondary button**: transparent bg, brand blue text
8. **Transition**: `.scale.combined(with: .opacity)`
9. **Animation**: `.easeInOut(duration: 0.2)`
10. **Dimming overlay**: 0.4 opacity black, tap to dismiss
11. **Accessibility**: `.accessibilityLabel()` on all buttons
12. **PreviewProvider** at bottom
13. **MARKER COMMENT** at top

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
