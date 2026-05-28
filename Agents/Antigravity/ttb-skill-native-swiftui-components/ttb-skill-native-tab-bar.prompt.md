---
description: "Build native SwiftUI tab bar item and custom tab bar components. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-tab-bar — Native SwiftUI Tab Bar Component Builder

Build reusable tab bar native SwiftUI components using TTBaseUIKit design tokens.

## Mandatory Preflight Execution Gate

Before generating code or modifying files, run `ttb-skill-shared/fragments/ttb-preflight-execution-gate.frag.md`.

Required checks:

- Analyze intent, task type, scope, impacted files/modules, dependencies, architecture constraints, coding standards, and project-specific rules.
- Validate required inputs such as target module, screen/component name, file location, navigation flow, expected output, API contract, state management, routing, localization, naming, and reusable component requirements.
- Detect ambiguity, conflicting requirements, incomplete business logic, unclear UX/navigation, unclear module ownership, and unclear architecture direction.
- Score confidence from `0-100`: execute at `90-100`, execute with warning assumptions at `70-89`, and ask a survey below `70` using `ttb-skill-shared/templates/ttb-clarification-survey.md`.
- Support English, Vietnamese, mixed-language, diacritic-free Vietnamese, and light typo prompts.

## When

User says: "native tab bar", "tab bar item", "bottom navigation", "tab"

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
    public let titleKey: String
    public var isSelected: Bool
    public var onTap: (() -> Void)?

    public init(
        iconName: String,
        titleKey: String,
        isSelected: Bool,
        onTap: (() -> Void)? = nil
    ) {
        self.iconName = iconName
        self.titleKey = titleKey
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

                Text(XText(self.titleKey))
                    .font(.system(size: TTFont.SUB_SUB_TITLE_H, weight: self.isSelected ? .semibold : .regular))
                    .foregroundColor(self.isSelected ? TTView.buttonBgDef.toColor() : TTView.iconColor.toColor())
            }
            .frame(maxWidth: .infinity)
            .pTop(TTSize.P_S)
            .padding(.bottom, TTSize.P_S)
        }
        .accessibilityLabel(String(format: XText("Accessibility.Tab.Format"), XText(self.titleKey)))
    }
}

// MARK: - {Name}CustomTabBar
public struct {Name}CustomTabBar: View {
    public struct TabItem: Identifiable {
        public let id: String
        public let iconName: String
        public let titleKey: String

        public init(id: String, iconName: String, titleKey: String) {
            self.id = id
            self.iconName = iconName
            self.titleKey = titleKey
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
                    titleKey: item.title,
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
                .baseShadow(corner: TTSize.CORNER_PANEL, color: .black.opacity(0.08), radius: 8, x: 0, y: -2)
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
                    {Name}CustomTabBar.TabItem(id: "home", iconName: "house.fill", titleKey: "Home"),
                    {Name}CustomTabBar.TabItem(id: "search", iconName: "magnifyingglass", titleKey: "Search"),
                    {Name}CustomTabBar.TabItem(id: "notifications", iconName: "bell.fill", titleKey: "Alerts"),
                    {Name}CustomTabBar.TabItem(id: "profile", iconName: "person.fill", titleKey: "Profile")
                ],
                selectedId: $selectedTab
            )
        }
        .ignoresSafeArea(.keyboard)
        .bg(byDef: TTView.viewBgColor.toColor())
    }
}
```

## Rules

1. **100% native SwiftUI primitives** — no `TTBaseSUI*`, `SUIBaseView`, or `TTBaseNavigationLink` wrappers in `/native-*` components
2. **TTBaseUIKit tokens + chainable modifiers**: `TTView.*.toColor()`, `TTSize.*`, `TTFont.*`, `.pAll()`, `.bg()`, `.corner()`, `.baseShadow()`, `.size()`
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
