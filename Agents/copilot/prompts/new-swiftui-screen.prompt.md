---
description: "Scaffold a new TTBaseUIKit SwiftUI screen with SUIBaseView wrapper, navigation, and TTBaseSUI components"
---

# Create New SwiftUI Screen

Scaffold a SwiftUI screen following TTBaseUIKit conventions.

## Rules

- **iOS 14+ APIs only** — no `.task{}`, `NavigationStack`, `#Preview`, `.foregroundStyle()`, or any iOS 15+/16+/17+ API
- Wrap screen in `SUIBaseView` (NOT NavigationView directly)
- All components: `TTBaseSUIText`, `TTBaseSUIButton`, `TTBaseSUIVStack`, etc.
- Never use: `Text()`, `Button()`, `VStack {}`, `Spacer()` — use TTBaseSUI equivalents
- Config tokens: `XView.*.toColor()`, `XSize.*`, `XFont.*`
- View modifiers: `.bg()`, `.corner()`, `.pAll()`, `.baseShadow()` — NOT raw SwiftUI modifiers
- Localization: `XTextU("Key")` for nav titles, `XText("Key")` for content
- Use `PreviewProvider`, NOT `#Preview`
- Use `.onAppear { }` for lifecycle, NOT `.task { }`

## Localization Auto-Generation (MANDATORY)
When generating code with `XText("key")` or `XTextU("key")`:
1. List all localization keys used in generated code
2. Add each key to `TTBaseUIKitExample/en.lproj/Localizable.strings`
3. Format: `"App.{Module}.{Context}.{Element}" = "Default English Value";`
4. Do NOT duplicate existing keys
5. Use `XTextU("key")` for navigation titles, `XText("key")` for content

## Folder Structure (MANDATORY)
Extracted sub-views MUST go into a `CustomViews/` folder within the feature directory:
```
{Feature}/
├── {Name}Screen.swift          ← Main screen (SUIBaseView wrapper)
├── {Name}ViewModel.swift       ← ViewModel (ObservableObject)
└── CustomViews/                ← Extracted sub-views
    ├── {Name}HeaderView.swift
    ├── {Name}CardView.swift
    └── ...
```
- Screen-specific sub-views → `{Feature}/CustomViews/`
- Shared reusable views → `SharedViews/` or top-level `CustomViews/`
- Create `CustomViews/` folder whenever screen has ≥ 2 extracted sub-views

## Steps

1. Ask for screen name, purpose, and back type (if not given)
2. Plan folder structure — if screen has sub-views, create `CustomViews/` folder
3. Create `{Name}Screen.swift`:

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
import SwiftUI
import TTBaseUIKit

struct {Name}Screen: View {

    var body: some View {
        SUIBaseView(
            backType: .POP,
            title: XTextU("App.{Name}.Nav.Title"),
            isHiddenTabbar: true
        ) {
            TTBaseSUIView(withCornerRadius: 0, bg: XView.viewBgColor.toColor()) {
                TTBaseSUIScroll {
                    TTBaseSUIVStack(alignment: .center, spacing: XSize.P_CONS_DEF, bg: .clear) {
                        // Content here
                        TTBaseSUIText(withBold: .HEADER, text: "Title",
                                      align: .center, color: XView.textDefColor.toColor())
                            .pAll().bg(byDef: .white).corner()

                        TTBaseSUIButton(type: .DEFAULT, title: "ACTION")

                    }.padding(.all, XSize.P_CONS_DEF)
                }
            }
        }
        .onAppear { }
    }
}

struct {Name}Screen_Previews: PreviewProvider {
    static var previews: some View {
        {Name}Screen()
    }
}
```

3. If screen needs data, create `{Name}ViewModel` (ObservableObject or closure-based):

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
import Foundation

class {Name}ViewModel: ObservableObject {
    @Published var items: [{Model}] = []
    @Published var isLoading: Bool = false

    func fetchData() {
        isLoading = true
        // API call...
    }
}
```

4. Confirm file location before writing
5. Auto-add to Xcode project:
```bash
ruby .agent/skills/ttbase-swiftui/scripts/add_to_xcode_project.rb "{file_path}"
```

## Plan Output (MANDATORY)

After completing any work, generate a plan file for future context:

1. Create `plans/YYYY-MM-DD-{feature-name}/plan.md`
2. Include: date, goal, files table (NEW/MODIFY/DELETE), patterns & tokens used, context for future upgrades
3. Auto-add plan file to Xcode:
```bash
ruby .agent/skills/ttbase-swiftui/scripts/add_to_xcode_project.rb "{plan_file_path}"
```

> See `instructions/plan-generation.instructions.md` for full templates.
