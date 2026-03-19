---
description: "Scaffold a reusable TTBaseSUI composed view component"
---

# Create New SwiftUI View Component

Scaffold a reusable SwiftUI view using TTBaseSUI* components.

## Pattern — Composed View (most common)

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
        TTBaseSUIVStack(alignment: .leading, spacing: XSize.P_CONS_DEF / 2) {
            TTBaseSUIText(withBold: .TITLE, text: title,
                          align: .leading, color: XView.textDefColor.toColor())
                .setVerticalContentHuggingPriority()
            TTBaseSUIText(withType: .SUB_TITLE, text: subtitle, align: .leading)
        }
        .pAll()
        .bg(byDef: .white)
        .corner()
        .onTapHandle { onTapAction?() }
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
        TTBaseSUIHStack(alignment: .center, spacing: XSize.P_CONS_DEF) {
            TTBaseSUIImage(withname: iconName, conner: XSize.CORNER_RADIUS)
                .sizeSquare(width: 40)
            TTBaseSUIText(withBold: .TITLE, text: title, align: .leading,
                          color: XView.textDefColor.toColor())
            TTBaseSUISpacer()
            TTBaseSUIImage(withname: "chevron.right", color: .gray, contentMode: .fit)
                .sizeSquare(width: 16)
        }
        .pAll()
        .bg(byDef: .white)
        .corner()
        .baseShadow()
        .onTapHandle { onTapAction?() }
    }
}
```

## Component Quick Reference
```swift
// Text
TTBaseSUIText(withType: .HEADER/.TITLE/.SUB_TITLE, text: "", align: .left)
TTBaseSUIText(withBold: .TITLE, text: "", align: .leading, color: XView.textDefColor.toColor())

// Button
TTBaseSUIButton(type: .DEFAULT/.WARRING/.BORDER/.NO_BG_COLOR, title: "")

// Image
TTBaseSUIImage(withname: "", conner: XSize.CORNER_RADIUS)

// Container stacks
TTBaseSUIVStack(alignment: .center, spacing: XSize.P_CONS_DEF) { }
TTBaseSUIHStack(alignment: .center, spacing: XSize.P_CONS_DEF) { }

// Spacer
TTBaseSUISpacer()

// Divider
BaseHorizontalDivider()
```

## Rules
- **iOS 14+ APIs only** — no `.task{}`, `NavigationStack`, `#Preview`, `.foregroundStyle()`, or any iOS 15+/16+/17+ API
- Use `TTBaseSUI*` components exclusively — no native `Text`, `Button`, `Image`, `Spacer`
- Data via `let` properties, callbacks via `var` closures
- Use `XView.*`, `XSize.*`, `XFont.*` tokens — never hardcode
- Chain: `.pAll()` → `.bg()` → `.corner()` → `.baseShadow()`
- Preview struct with `PreviewProvider` at bottom

### Folder Placement (MANDATORY)
- If view is a **sub-view of a screen** → place in `{Feature}/CustomViews/{Name}View.swift`
- If view is a **shared reusable component** → place in `SharedViews/` or top-level `CustomViews/`

## Localization Auto-Generation (MANDATORY)
When generating code with `XText("key")` or `XTextU("key")`:
1. List all localization keys used in generated code
2. Add each key to `TTBaseUIKitExample/en.lproj/Localizable.strings`
3. Format: `"App.{Module}.{Context}" = "Default English Value";`
4. Do NOT duplicate existing keys

## Auto-Add to Xcode Project (MANDATORY)
After creating any new Swift file:
```bash
ruby .agent/skills/ttbase-swiftui/scripts/add_to_xcode_project.rb "{file_path}"
```

## Steps
1. Ask for view name, purpose, and components needed
2. Determine placement: screen-specific → `{Feature}/CustomViews/`, shared → `SharedViews/`
3. Recommend simple or card variant
4. Generate complete view file
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
