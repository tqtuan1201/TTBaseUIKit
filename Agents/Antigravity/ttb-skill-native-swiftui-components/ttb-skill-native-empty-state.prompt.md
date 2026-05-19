---
description: "Build native SwiftUI empty state component with illustration, title, message, and action button. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-empty-state — Native SwiftUI Empty State Component Builder

Build reusable empty state native SwiftUI components using TTBaseUIKit design tokens.

## When

User says: "native empty state", "empty view", "no data", "no results", "placeholder"

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
        case custom(AnyView)
    }

    public var illustration: IllustrationStyle = .icon("tray")
    public var title: String
    public var message: String
    public var actionTitle: String?
    public var actionIcon: String?
    public var onAction: (() -> Void)?

    public init(
        title: String,
        message: String,
        illustration: IllustrationStyle = .icon("tray"),
        actionTitle: String? = nil,
        actionIcon: String? = nil,
        onAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.illustration = illustration
        self.actionTitle = actionTitle
        self.actionIcon = actionIcon
        self.onAction = onAction
    }

    public var body: some View {
        VStack(spacing: TTSize.P_L) {
            self.illustrationView
                .frame(width: 80, height: 80)

            VStack(spacing: TTSize.P_S) {
                Text(self.title)
                    .font(.system(size: TTFont.HEADER_H, weight: .bold))
                    .foregroundColor(TTView.textHeaderColor.toColor())
                    .multilineTextAlignment(.center)

                Text(self.message)
                    .font(.system(size: TTFont.TITLE_H, weight: .regular))
                    .foregroundColor(TTView.textSubTitleColor.toColor())
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if let actionTitle = self.actionTitle {
                Button(action: { self.onAction?() }) {
                    HStack(spacing: TTSize.P_S) {
                        if let actionIcon = self.actionIcon {
                            Image(systemName: actionIcon)
                                .font(.system(size: TTFont.TITLE_H))
                        }
                        Text(actionTitle)
                            .font(.system(size: TTFont.TITLE_H, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: TTSize.H_BUTTON)
                    .background(TTView.buttonBgDef.toColor())
                    .clipShape(RoundedRectangle(cornerRadius: TTSize.CORNER_BUTTON))
                }
                .accessibilityLabel(actionTitle)
            }
        }
        .padding(.horizontal, TTSize.P_XXL)
    }

    @ViewBuilder
    private var illustrationView: some View {
        switch self.illustration {
        case .icon(let name):
            Image(systemName: name)
                .font(.system(size: 40))
                .foregroundColor(TTView.iconColor.toColor())
        case .custom(let view):
            view
        }
    }
}

// MARK: - Preset Empty States
public extension {Name}EmptyState {
    static func noData(onAction: (() -> Void)? = nil) -> {Name}EmptyState {
        {Name}EmptyState(
            title: "No Data",
            message: "There's no data to display at the moment. Please try again later.",
            illustration: .icon("doc.text"),
            actionTitle: "Refresh",
            actionIcon: "arrow.clockwise",
            onAction: onAction
        )
    }

    static func noResults(searchQuery: String = "", onAction: (() -> Void)? = nil) -> {Name}EmptyState {
        {Name}EmptyState(
            title: "No Results",
            message: searchQuery.isEmpty
                ? "We couldn't find any results."
                : "We couldn't find any results for \"\(searchQuery)\".",
            illustration: .icon("magnifyingglass"),
            actionTitle: "Clear Search",
            actionIcon: "xmark",
            onAction: onAction
        )
    }

    static func error(message: String = "Something went wrong.", onAction: (() -> Void)? = nil) -> {Name}EmptyState {
        {Name}EmptyState(
            title: "Oops!",
            message: message,
            illustration: .icon("exclamationmark.triangle"),
            actionTitle: "Try Again",
            actionIcon: "arrow.clockwise",
            onAction: onAction
        )
    }

    static func noFavorites(onAction: (() -> Void)? = nil) -> {Name}EmptyState {
        {Name}EmptyState(
            title: "No Favorites Yet",
            message: "Items you favorite will appear here for easy access.",
            illustration: .icon("heart"),
            actionTitle: "Browse",
            actionIcon: "magnifyingglass",
            onAction: onAction
        )
    }

    static func noNotifications(onAction: (() -> Void)? = nil) -> {Name}EmptyState {
        {Name}EmptyState(
            title: "All Caught Up!",
            message: "You have no new notifications.",
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
                title: "No Data",
                message: "There's no data to display at the moment.",
                actionTitle: "Refresh",
                actionIcon: "arrow.clockwise"
            ) { }

            {Name}EmptyState.noResults() { }
            {Name}EmptyState.error(message: "Unable to load data. Please check your connection.") { }
            {Name}EmptyState.noFavorites() { }
            {Name}EmptyState.noNotifications() { }
        }
        .padding(.vertical, TTSize.P_XXL)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(TTView.viewBgColor.toColor())
    }
}
```

## Rules

1. **100% native SwiftUI** — no TTBaseSUI* wrappers
2. **TTBaseUIKit tokens**: `TTView.*.toColor()`, `TTSize.*`, `TTFont.*`
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
