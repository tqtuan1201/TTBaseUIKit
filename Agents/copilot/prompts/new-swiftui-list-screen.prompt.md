---
description: "Scaffold a SwiftUI list/scroll screen with TTBaseSUIScroll + TTBaseSUILazyVStack"
---

# Create New SwiftUI List Screen

Scaffold a scrollable list screen using TTBaseSUIScroll and TTBaseSUILazyVStack.

## Template

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
import SwiftUI
import TTBaseUIKit

struct {Name}ListScreen: View {

    @StateObject private var viewModel = {Name}ListViewModel()

    var body: some View {
        SUIBaseView(backType: .POP, title: XTextU("App.{Name}.Nav.Title"), isHiddenTabbar: true) {
            TTBaseSUIView(withCornerRadius: 0, bg: XView.viewBgColor.toColor()) {
                TTBaseSUIVStack(alignment: .center, spacing: 0) {
                    // Scroll + Lazy list
                    TTBaseSUIScroll(alignment: .vertical) {
                        TTBaseSUILazyVStack(alignment: .center, spacing: XSize.P_CONS_DEF, bg: .clear) {
                            ForEach(viewModel.items, id: \.id) { item in
                                {Name}ItemView(item: item)
                                    .skeleton(active: viewModel.isLoading)
                                    .onTapHandle {
                                        // Navigate to detail
                                    }
                            }
                        }.padding(.all, XSize.P_CONS_DEF)
                    }
                }
            }
        }
        .onAppear { viewModel.fetchData() }
    }
}

// MARK: - Item View
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
struct {Name}ItemView: View {
    let item: {Name}Model

    var body: some View {
        TTBaseSUIHStack(alignment: .center, spacing: XSize.P_CONS_DEF) {
            TTBaseSUIImage(withname: "icon", conner: XSize.CORNER_RADIUS)
                .sizeSquare(width: 50)
            TTBaseSUIVStack(alignment: .leading, spacing: 4) {
                TTBaseSUIText(withBold: .TITLE, text: item.title ?? "",
                              align: .leading, color: XView.textDefColor.toColor())
                TTBaseSUIText(withType: .SUB_TITLE, text: item.subtitle ?? "",
                              align: .leading)
            }
            TTBaseSUISpacer()
        }
        .pAll()
        .bg(byDef: .white)
        .corner()
        .baseShadow()
    }
}

// MARK: - ViewModel
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
class {Name}ListViewModel: ObservableObject {
    @Published var items: [{Name}Model] = []
    @Published var isLoading: Bool = false

    func fetchData() {
        isLoading = true
        {Name}API.share.getAll { [weak self] objects, resMess in
            DispatchQueue.main.async {
                self?.isLoading = false
                if resMess.onCheckSuccess(), let objs = objects {
                    self?.items = objs
                } else {
                    // Handle error
                }
            }
        }
    }
}
```

## Rules
- **iOS 14+ APIs only** — no `.task{}`, `NavigationStack`, `#Preview`, `.foregroundStyle()`, or any iOS 15+/16+/17+ API
- Use `TTBaseSUIScroll` + `TTBaseSUILazyVStack` for long lists
- Use `ForEach` with model's `id` property
- Apply `.skeleton(active: viewModel.isLoading)` for loading state
- Item views as separate structs with card pattern: `.pAll().bg().corner().baseShadow()`
- ViewModel with `@Published` properties (NOT `@Observable`)
- Use `PreviewProvider`, NOT `#Preview`

## Localization Auto-Generation (MANDATORY)
When generating code with `XText("key")` or `XTextU("key")`:
1. List all localization keys used in generated code
2. Add each key to `TTBaseUIKitExample/en.lproj/Localizable.strings`
3. Format: `"App.{Module}.{Context}" = "Default English Value";`
4. Do NOT duplicate existing keys

## Steps
1. Ask for list name and model type
2. Generate screen, item view, and ViewModel
3. Confirm file locations

## Plan Output (MANDATORY)

After completing any work, generate a plan file for future context:

1. Create `plans/YYYY-MM-DD-{feature-name}/plan.md`
2. Include: date, goal, files table (NEW/MODIFY/DELETE), patterns & tokens used, context for future upgrades
3. Auto-add plan file to Xcode:
```bash
ruby .agent/skills/ttbase-swiftui/scripts/add_to_xcode_project.rb "{plan_file_path}"
```

> See `instructions/plan-generation.instructions.md` for full templates.
