---
description: "Build native SwiftUI empty state component with illustration, title, message, and action button. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-empty-state — Native SwiftUI Empty State Component Builder

Build reusable empty state native SwiftUI components using TTBaseUIKit design tokens.

## When

User says: "native empty state", "empty view", "no data", "no results", "placeholder"

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

## Empty State Component Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  Components/EmptyState/{Name}EmptyState.swift
//  {AppName}
//

import SwiftUI
import TTBaseUIKit

// MARK: - {Name}EmptyState
public struct {Name}EmptyState: View {
    public enum IllustrationStyle {
        case icon(String)
    }

    public var illustration: IllustrationStyle = .icon("tray")
    public var titleKey: String
    public var messageKey: String
    public var actionTitleKey: String?
    public var actionIcon: String?
    public var onAction: (() -> Void)?

    public init(
        titleKey: String,
        messageKey: String,
        illustration: IllustrationStyle = .icon("tray"),
        actionTitleKey: String? = nil,
        actionIcon: String? = nil,
        onAction: (() -> Void)? = nil
    ) {
        self.titleKey = titleKey
        self.messageKey = messageKey
        self.illustration = illustration
        self.actionTitleKey = actionTitleKey
        self.actionIcon = actionIcon
        self.onAction = onAction
    }

    public var body: some View {
        VStack(spacing: TTSize.P_L) {
            self.illustrationView
                .frame(width: 80, height: 80)

            VStack(spacing: TTSize.P_S) {
                Text(XText(self.titleKey))
                    .font(.system(size: TTFont.HEADER_H, weight: .bold))
                    .foregroundColor(TTView.textHeaderColor.toColor())
                    .multilineTextAlignment(.center)

                Text(XText(self.messageKey))
                    .font(.system(size: TTFont.TITLE_H, weight: .regular))
                    .foregroundColor(TTView.textSubTitleColor.toColor())
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if let actionTitleKey = self.actionTitleKey {
                Button(action: { self.onAction?() }) {
                    HStack(spacing: TTSize.P_S) {
                        if let actionIcon = self.actionIcon {
                            Image(systemName: actionIcon)
                                .font(.system(size: TTFont.TITLE_H))
                        }
                        Text(XText(actionTitleKey))
                            .font(.system(size: TTFont.TITLE_H, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: TTSize.H_BUTTON)
                    .bg(byDef: TTView.buttonBgDef.toColor())
                    .corner(byDef: TTSize.CORNER_BUTTON)
                }
                .accessibilityLabel(XText(actionTitleKey))
            }
        }
        .pHorizontal(TTSize.P_XL)
    }

    @ViewBuilder
    private var illustrationView: some View {
        switch self.illustration {
        case .icon(let name):
            Image(systemName: name)
                .font(.system(size: 40))
                .foregroundColor(TTView.iconColor.toColor())
        }
    }
}

// MARK: - Preset Empty States
public extension {Name}EmptyState {
    static func noData(onAction: (() -> Void)? = nil) -> {Name}EmptyState {
        {Name}EmptyState(
            titleKey: "Empty.NoData.Title",
            messageKey: "Empty.NoData.Message",
            illustration: .icon("doc.text"),
            actionTitleKey: "Common.Action.Refresh",
            actionIcon: "arrow.clockwise",
            onAction: onAction
        )
    }

    static func noResults(onAction: (() -> Void)? = nil) -> {Name}EmptyState {
        {Name}EmptyState(
            titleKey: "Empty.NoResults.Title",
            messageKey: "Empty.NoResults.Message",
            illustration: .icon("magnifyingglass"),
            actionTitleKey: "Search.Action.Clear",
            actionIcon: "xmark",
            onAction: onAction
        )
    }

    static func error(messageKey: String = "Empty.Error.Message", onAction: (() -> Void)? = nil) -> {Name}EmptyState {
        {Name}EmptyState(
            titleKey: "Empty.Error.Title",
            messageKey: messageKey,
            illustration: .icon("exclamationmark.triangle"),
            actionTitleKey: "Common.Action.TryAgain",
            actionIcon: "arrow.clockwise",
            onAction: onAction
        )
    }

    static func noFavorites(onAction: (() -> Void)? = nil) -> {Name}EmptyState {
        {Name}EmptyState(
            titleKey: "Empty.Favorites.Title",
            messageKey: "Empty.Favorites.Message",
            illustration: .icon("heart"),
            actionTitleKey: "Common.Action.Browse",
            actionIcon: "magnifyingglass",
            onAction: onAction
        )
    }

    static func noNotifications(onAction: (() -> Void)? = nil) -> {Name}EmptyState {
        {Name}EmptyState(
            titleKey: "Empty.Notifications.Title",
            messageKey: "Empty.Notifications.Message",
            illustration: .icon("bell.slash"),
            onAction: onAction
        )
    }
}

// MARK: - Preview
struct {Name}EmptyState_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: TTSize.P_XL) {
            {Name}EmptyState(
                titleKey: "Empty.NoData.Title",
                messageKey: "Empty.NoData.Message",
                actionTitleKey: "Common.Action.Refresh",
                actionIcon: "arrow.clockwise"
            ) { }

            {Name}EmptyState.noResults() { }
            {Name}EmptyState.error(messageKey: "Empty.Error.Network") { }
            {Name}EmptyState.noFavorites() { }
            {Name}EmptyState.noNotifications() { }
        }
        .pVertical(TTSize.P_XL)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .bg(byDef: TTView.viewBgColor.toColor())
    }
}
```

## Rules

1. **100% native SwiftUI primitives** — no `TTBaseSUI*`, `SUIBaseView`, or `TTBaseNavigationLink` wrappers in `/native-*` components
2. **TTBaseUIKit tokens + chainable modifiers**: `TTView.*.toColor()`, `TTSize.*`, `TTFont.*`, `.pAll()`, `.bg()`, `.corner()`, `.baseShadow()`, `.size()`
3. **Layout**: VStack with icon (80x80) → title → message → optional action button
4. **Icon**: SF Symbol, 40pt font size, `TTView.iconColor`
5. **Title**: TTFont.HEADER_H bold, centered, `TTView.textHeaderColor`
6. **Message**: TTFont.TITLE_H regular, centered, `TTView.textSubTitleColor`
7. **Action**: Primary button style with optional icon
8. **Preset factories**: `.noData()`, `.noResults()`, `.error()`, `.noFavorites()`, `.noNotifications()`
9. **PreviewProvider** at bottom
10. **MARKER COMMENT** at top

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
