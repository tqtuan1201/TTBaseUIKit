---
description: "Scaffold a reusable native SwiftUI view component with TTBaseUIKit design tokens — no TTBaseSUI* wrappers"
---

# Create New Native SwiftUI View Component

Scaffold a reusable native SwiftUI view using standard SwiftUI with TTBaseUIKit design tokens.

> ⚠️ This prompt creates **native SwiftUI** views using 100% standard SwiftUI. For TTBaseSUI* component views, use `new-swiftui-view` instead.

## Pattern — Composed View (tappable, use Button)

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
import SwiftUI
import TTBaseUIKit

struct {Name}View: View {

    // MARK: - Properties
    let title: String
    let subtitle: String
    var onTapAction: (() -> Void)? = nil

    // MARK: - Body
    var body: some View {
        Button {
            onTapAction?()
        } label: {
            VStack(alignment: .leading, spacing: XSize.P_CONS_DEF / 2) {
                Text(title)
                    .font(.system(size: XFont.TITLE_H, weight: .bold))
                    .foregroundColor(XView.textDefColor.toColor())
                Text(subtitle)
                    .font(.system(size: XFont.SUB_TITLE_H))
                    .foregroundColor(XView.textSubTitleColor.toColor())
            }
            .padding(XSize.P_CONS_DEF)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: XSize.CORNER_RADIUS))
        }
        .buttonStyle(.plain)
    }
}

struct {Name}View_Previews: PreviewProvider {
    static var previews: some View {
        {Name}View(title: "Title", subtitle: "Subtitle")
            .padding()
    }
}
```

## Pattern — Static Display View (non-tappable)

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
import SwiftUI
import TTBaseUIKit

struct {Name}InfoView: View {

    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: XSize.P_CONS_DEF / 2) {
            Text(title)
                .font(.system(size: XFont.TITLE_H, weight: .bold))
                .foregroundColor(XView.textDefColor.toColor())
            Text(subtitle)
                .font(.system(size: XFont.SUB_TITLE_H))
                .foregroundColor(XView.textSubTitleColor.toColor())
        }
        .padding(XSize.P_CONS_DEF)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: XSize.CORNER_RADIUS))
    }
}

struct {Name}InfoView_Previews: PreviewProvider {
    static var previews: some View {
        {Name}InfoView(title: "Title", subtitle: "Subtitle")
            .padding()
    }
}
```

## Shadow Card Variant

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
struct {Name}CardView: View {

    let iconName: String
    let title: String
    var onTapAction: (() -> Void)? = nil

    var body: some View {
        Button {
            onTapAction?()
        } label: {
            HStack(spacing: XSize.P_CONS_DEF) {
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(XView.iconColor.toColor())

                Text(title)
                    .font(.system(size: XFont.TITLE_H, weight: .bold))
                    .foregroundColor(XView.textDefColor.toColor())

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: XFont.SUB_TITLE_H))
                    .foregroundColor(XView.textSubTitleColor.toColor())
            }
            .padding(XSize.P_CONS_DEF)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: XSize.CORNER_RADIUS))
            .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

struct {Name}CardView_Previews: PreviewProvider {
    static var previews: some View {
        {Name}CardView(iconName: "star.fill", title: "Card Title")
            .padding()
    }
}
```

## Rules
- Use **100% standard SwiftUI** — no `TTBaseSUI*` wrappers, no `SUIBaseView` (views ≠ screens)
- Data via `let` properties, callbacks via `var` closures
- `XView.*`, `XSize.*`, `XFont.*` tokens — never hardcode colors/sizes
- iOS 14+: `foregroundColor()`, `clipShape(RoundedRectangle())`, `PreviewProvider`
- **Use `Button` for tappable views** — never `onTapGesture` as substitute for `Button`
- Minimum 44×44 tap area for interactive elements
- Each subview in its own file
- `body` should be < 40 lines — extract subviews if longer
- Accessibility: `.accessibilityLabel()` on images, Dynamic Type preferred

### View Composition (swiftui-pro)
- Extract subviews → separate `View` structs in own files, NOT computed properties
- Button actions → separate methods for complex logic
- Each type (struct, class, enum) in its own Swift file
- `PreviewProvider` at bottom of every file

### Folder Placement (MANDATORY)
- If view is a **sub-view of a screen** → place in `{Feature}/CustomViews/{Name}View.swift`
- If view is a **shared reusable component** → place in `SharedViews/` or top-level `CustomViews/`
```
{Feature}/
├── {Name}Screen.swift
├── {Name}ViewModel.swift
└── CustomViews/              ← Screen-specific sub-views
    ├── {Name}HeaderView.swift
    └── {Name}CardView.swift
```

### Performance
- Ternary > if/else for modifier toggling
- No `AnyView` — `@ViewBuilder`, `Group`, or generics
- `@ViewBuilder let content: Content` not `() -> Content`
- Large data → `LazyVStack` / `LazyHStack`

## Localization (MANDATORY)
When generating code with `XText("key")` or `XTextU("key")`:
1. Add each key to `TTBaseUIKitExample/en.lproj/Localizable.strings`
2. Format: `"App.{Module}.{Context}" = "Default English Value";`
3. Do NOT duplicate existing keys

## Auto-Add to Xcode Project (MANDATORY)
After creating any new Swift file:
```bash
ruby .agent/skills/ttbase-swiftui/scripts/add_to_xcode_project.rb "{file_path}"
```

## Steps
1. Ask for view name, purpose, and components needed
2. Determine placement: screen-specific → `{Feature}/CustomViews/`, shared → `SharedViews/`
3. Recommend tappable (Button) or static display pattern
4. Generate complete view file with `PreviewProvider`
5. Confirm file location
6. Auto-add to Xcode project

## Plan Output (MANDATORY)

After completing any work, generate a plan file for future context:

1. Create `plans/YYYY-MM-DD-{feature-name}/plan.md`
2. Include: date, goal, files table (NEW/MODIFY/DELETE), patterns & tokens used, context for future upgrades
3. Auto-add plan file to Xcode:
```bash
ruby .agent/skills/ttbase-swiftui/scripts/add_to_xcode_project.rb "{plan_file_path}"
```

> See `instructions/plan-generation.instructions.md` for full templates.
