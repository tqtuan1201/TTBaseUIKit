---
description: "Build native SwiftUI tab bar item and custom tab bar components. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-tab-bar — Native SwiftUI Tab Bar Component Builder

Build reusable tab bar native SwiftUI components using TTBaseUIKit design tokens.

## When

User says: "native tab bar", "tab bar item", "bottom navigation", "tab"

## Tab Bar Component Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  Components/TabBar/{Name}TabBar.swift
//  {AppName}
//

import SwiftUI
import TTBaseUIKit

// MARK: - {Name}TabItem
public struct {Name}TabItem: View {
    public let iconName: String
    public let title: String
    public var isSelected: Bool
    public var onTap: (() -> Void)?

    public init(
        iconName: String,
        title: String,
        isSelected: Bool,
        onTap: (() -> Void)? = nil
    ) {
        self.iconName = iconName
        self.title = title
        self.isSelected = isSelected
        self.onTap = onTap
    }

    public var body: some View {
        Button {
            self.onTap?()
        } label: {
            VStack(spacing: TTSize.P_S / 2) {
                Image(systemName: self.iconName)
                    .font(.system(size: 22))
                    .foregroundColor(self.isSelected ? TTView.buttonBgDef.toColor() : TTView.iconColor.toColor())

                Text(self.title)
                    .font(.system(size: TTFont.SUB_SUB_TITLE_H, weight: self.isSelected ? .semibold : .regular))
                    .foregroundColor(self.isSelected ? TTView.buttonBgDef.toColor() : TTView.iconColor.toColor())
            }
            .frame(maxWidth: .infinity)
            .padding(.top, TTSize.P_S)
            .padding(.bottom, TTSize.P_S)
        }
        .accessibilityLabel("\(self.title) tab")
    }
}

// MARK: - {Name}CustomTabBar
public struct {Name}CustomTabBar: View {
    public struct TabItem: Identifiable {
        public let id: String
        public let iconName: String
        public let title: String

        public init(id: String, iconName: String, title: String) {
            self.id = id
            self.iconName = iconName
            self.title = title
        }
    }

    public let items: [TabItem]
    @Binding public var selectedId: String
    public var onTabChanged: ((String) -> Void)?

    public init(
        items: [TabItem],
        selectedId: Binding<String>,
        onTabChanged: ((String) -> Void)? = nil
    ) {
        self.items = items
        self._selectedId = selectedId
        self.onTabChanged = onTabChanged
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(self.items) { item in
                {Name}TabItem(
                    iconName: item.iconName,
                    title: item.title,
                    isSelected: self.selectedId == item.id
                ) {
                    self.selectedId = item.id
                    self.onTabChanged?(item.id)
                }
            }
        }
        .frame(height: TTSize.H_TAB + (UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0))
        .background(
            TTView.viewBgCellColor.toColor()
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: -2)
        )
    }
}

// MARK: - Preview
struct {Name}TabBar_Previews: PreviewProvider {
    @State static var selectedTab = "home"

    static var previews: some View {
        VStack {
            Spacer()
            {Name}CustomTabBar(
                items: [
                    {Name}CustomTabBar.TabItem(id: "home", iconName: "house.fill", title: "Home"),
                    {Name}CustomTabBar.TabItem(id: "search", iconName: "magnifyingglass", title: "Search"),
                    {Name}CustomTabBar.TabItem(id: "notifications", iconName: "bell.fill", title: "Alerts"),
                    {Name}CustomTabBar.TabItem(id: "profile", iconName: "person.fill", title: "Profile")
                ],
                selectedId: $selectedTab
            )
        }
        .ignoresSafeArea(.keyboard)
        .background(TTView.viewBgColor.toColor())
    }
}
```

## Rules

1. **100% native SwiftUI** — no TTBaseSUI* wrappers
2. **TTBaseUIKit tokens**: `TTView.*.toColor()`, `TTSize.*`, `TTFont.*`
3. **Tab height = TTSize.H_TAB + safe area bottom**
4. **Icon size**: 22pt, centered
5. **Text**: SUB_SUB_TITLE_H, semibold when selected
6. **Selected color**: `TTView.buttonBgDef` (brand blue)
7. **Unselected color**: `TTView.iconColor` (gray)
8. **Accessibility**: `.accessibilityLabel()` on each item
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
