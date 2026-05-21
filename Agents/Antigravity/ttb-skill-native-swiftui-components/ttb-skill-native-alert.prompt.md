---
description: "Build native SwiftUI alert and confirmation dialog components. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-alert — Native SwiftUI Alert Component Builder

Build reusable alert and confirmation dialog native SwiftUI components using TTBaseUIKit design tokens.

## When

User says: "native alert", "confirmation dialog", "alert dialog", "prompt"

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
    public let titleKey: String
    public var messageKey: String?
    public var primaryButtonTitleKey: String
    public var primaryAction: () -> Void
    public var secondaryButtonTitleKey: String?
    public var secondaryAction: (() -> Void)?
    public var dismissAction: (() -> Void)?

    public init(
        isPresented: Binding<Bool>,
        titleKey: String,
        messageKey: String? = nil,
        primaryButtonTitleKey: String,
        primaryAction: @escaping () -> Void,
        secondaryButtonTitleKey: String? = nil,
        secondaryAction: (() -> Void)? = nil,
        dismissAction: (() -> Void)? = nil
    ) {
        self._isPresented = isPresented
        self.titleKey = titleKey
        self.messageKey = messageKey
        self.primaryButtonTitleKey = primaryButtonTitleKey
        self.primaryAction = primaryAction
        self.secondaryButtonTitleKey = secondaryButtonTitleKey
        self.secondaryAction = secondaryAction
        self.dismissAction = dismissAction
    }

    public func body(content: Content) -> some View {
        ZStack {
            content

            if self.isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapHandle {
                        self.dismiss()
                    }

                self.alertView
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2))
    }

    private func dismiss() {
        self.dismissAction?()
        self.isPresented = false
    }

    private var alertView: some View {
        VStack(spacing: TTSize.P_L) {
            VStack(spacing: TTSize.P_S) {
                Text(XText(self.titleKey))
                    .font(.system(size: TTFont.HEADER_H, weight: .bold))
                    .foregroundColor(TTView.textHeaderColor.toColor())
                    .multilineTextAlignment(.center)

                if let messageKey = self.messageKey {
                    Text(XText(messageKey))
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
                    Text(XText(self.primaryButtonTitleKey))
                        .font(.system(size: TTFont.TITLE_H, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: TTSize.H_BUTTON)
                        .bg(byDef: TTView.buttonBgDef.toColor())
                        .corner(byDef: TTSize.CORNER_BUTTON)
                }
                .accessibilityLabel(XText(self.primaryButtonTitleKey))

                if let secondaryButtonTitleKey = self.secondaryButtonTitleKey {
                    Button {
                        self.secondaryAction?()
                        self.isPresented = false
                    } label: {
                        Text(XText(secondaryButtonTitleKey))
                            .font(.system(size: TTFont.TITLE_H, weight: .semibold))
                            .foregroundColor(TTView.buttonBgDef.toColor())
                            .frame(maxWidth: .infinity)
                            .frame(height: TTSize.H_BUTTON)
                            .background(Color.clear)
                            .corner(byDef: TTSize.CORNER_BUTTON)
                    }
                    .accessibilityLabel(XText(secondaryButtonTitleKey))
                }
            }
        }
        .pAll(TTSize.P_L)
        .frame(maxWidth: 280)
        .bg(byDef: TTView.viewBgCellColor.toColor())
        .corner(byDef: TTSize.CORNER_PANEL)
        .baseShadow(corner: TTSize.CORNER_PANEL, color: .black.opacity(0.2), radius: 16, x: 0, y: 8)
    }
}

public extension View {
    func {Name}Alert(
        isPresented: Binding<Bool>,
        titleKey: String,
        messageKey: String? = nil,
        primaryButtonTitleKey: String,
        primaryAction: @escaping () -> Void,
        secondaryButtonTitleKey: String? = nil,
        secondaryAction: (() -> Void)? = nil,
        dismissAction: (() -> Void)? = nil
    ) -> some View {
        modifier(
            {Name}AlertModifier(
                isPresented: isPresented,
                titleKey: titleKey,
                messageKey: messageKey,
                primaryButtonTitleKey: primaryButtonTitleKey,
                primaryAction: primaryAction,
                secondaryButtonTitleKey: secondaryButtonTitleKey,
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
                Button(action: { showAlert = true }) { Text(XText("Preview.Alert.Show")) }
                Button(action: { showConfirm = true }) { Text(XText("Preview.Alert.ShowConfirmation")) }
            }
            .pAll(TTSize.P_CONS_DEF)

            Color.clear
                .{Name}Alert(
                    isPresented: $showAlert,
                    titleKey: "Preview.Alert.Error.Title",
                    messageKey: "Preview.Alert.Error.ConnectionMessage",
                    primaryButtonTitleKey: "Common.Action.OK",
                    primaryAction: { print("OK tapped") }
                )

            Color.clear
                .{Name}Alert(
                    isPresented: $showConfirm,
                    titleKey: "Preview.Alert.Delete.Title",
                    messageKey: "Preview.Alert.Delete.Message",
                    primaryButtonTitleKey: "Common.Action.Delete",
                    primaryAction: { print("Delete") },
                    secondaryButtonTitleKey: "Common.Action.Cancel",
                    secondaryAction: { print("Cancel") }
                )
        }
    }
}
```

## Rules

1. **100% native SwiftUI primitives** — no `TTBaseSUI*`, `SUIBaseView`, or `TTBaseNavigationLink` wrappers in `/native-*` components
2. **TTBaseUIKit tokens + chainable modifiers**: `TTView.*.toColor()`, `TTSize.*`, `TTFont.*`, `.pAll()`, `.bg()`, `.corner()`, `.baseShadow()`, `.size()`
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
