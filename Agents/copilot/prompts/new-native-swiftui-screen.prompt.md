---
description: "Scaffold a native SwiftUI screen with SUIBaseView wrapper, MVVM, and TTBaseUIKit design tokens — no TTBaseSUI* content wrappers"
---

# Create New Native SwiftUI Screen

Scaffold a native SwiftUI screen using standard SwiftUI components with TTBaseUIKit design tokens.

> ⚠️ This prompt creates **native SwiftUI** screens using `SUIBaseView` for navigation + native SwiftUI content (Text, VStack, ScrollView, etc.). For TTBaseSUI* component screens, use `new-swiftui-screen` instead.

## Rules

- Wrap screen in `SUIBaseView` for navigation (title, back button, tab bar control)
- Use **100% standard SwiftUI** for content: `Text`, `VStack`, `HStack`, `Button`, `Image`, `ScrollView`, `LazyVStack`, etc.
- Design tokens only: `XView.*.toColor()`, `XSize.*`, `XFont.*`
- iOS 14+ API only — see API table below
- Localization: `XTextU("Key")` for nav titles, `XText("Key")` for content
- `.onAppear { Task { await ... } }` for async work (NOT `.task { }`)

### iOS 14+ API (MANDATORY)
| ❌ Avoid | ✅ Use Instead (iOS 14+) |
|---|---|
| `NavigationStack { }` (iOS 16+) | `SUIBaseView` (for screens) |
| `foregroundStyle()` (iOS 15+) | `foregroundColor()` |
| `clipShape(.rect(cornerRadius:))` (iOS 16+) | `clipShape(RoundedRectangle(cornerRadius:))` |
| `navigationDestination(for:)` (iOS 16+) | `NavigationLink(destination:)` |
| `.scrollIndicators(.hidden)` (iOS 16+) | `ScrollView(showsIndicators: false)` |
| `#Preview { }` (iOS 17+) | `PreviewProvider` protocol |
| `.topBarLeading/.topBarTrailing` (iOS 15+) | `.navigationBarLeading/.navigationBarTrailing` |
| `.task { }` (iOS 15+) | `.onAppear { Task { } }` |
| `@Observable` (iOS 17+) | `ObservableObject` + `@Published` + `@StateObject` |
| `overlay { content }` (iOS 15+ closure) | `overlay(content)` (iOS 14 view param) |
| `onChange` (0-param, iOS 17+) | `onChange(of:) { newValue in }` |
| `contentTransition()` (iOS 16+) | `.animation(.default, value:)` |
| `sensoryFeedback()` (iOS 17+) | `UIImpactFeedbackGenerator` |
| `containerRelativeFrame()` (iOS 17+) | `GeometryReader` or `.frame()` |

### View Composition (from swiftui-pro)
- Extract subviews → separate `View` structs in own files, NOT computed properties
- `body` should be < 40 lines — extract if longer
- Button actions → separate methods, not inline closures
- Business logic out of `body` / `onAppear`
- Each type (struct, class, enum) in its own Swift file

### Folder Structure (MANDATORY)
Extracted sub-views MUST go into a `CustomViews/` folder within the feature directory:
```
{Feature}/
├── {Name}Screen.swift          ← Main screen (SUIBaseView wrapper)
├── {Name}ViewModel.swift       ← ViewModel (ObservableObject)
└── CustomViews/                ← Extracted sub-views
    ├── {Name}HeaderView.swift
    ├── {Name}CardView.swift
    ├── {Name}ActionBar.swift
    └── ...
```
- Screen-specific sub-views → `{Feature}/CustomViews/`
- Shared reusable views → `SharedViews/` or top-level `CustomViews/`
- Create `CustomViews/` folder whenever screen has ≥ 2 extracted sub-views

### Performance
- Ternary > if/else for modifier toggling (avoids `_ConditionalContent`)
- No `AnyView` — use `@ViewBuilder`, `Group`, or generics
- `@ViewBuilder let content: Content` not `() -> Content`
- Large data → `LazyVStack` / `LazyHStack` in `ScrollView`
- View initializers: small and simple, no heavy work

### Accessibility
- Dynamic Type: `.font(.body)`, `.font(.headline)`, or `@ScaledMetric`
- Use `Button` for tappable elements (never `onTapGesture` as substitute)
- Minimum 44×44 tap area
- VoiceOver: text labels on icon-only buttons, `.accessibilityLabel()` on images
- Respect `@Environment(\.accessibilityReduceMotion)` for animations

## Localization (MANDATORY)
When generating code with `XText("key")` or `XTextU("key")`:
1. Add each key to `TTBaseUIKitExample/en.lproj/Localizable.strings`
2. Format: `"App.{Module}.{Context}.{Element}" = "Default English Value";`
3. Do NOT duplicate existing keys

## Steps

1. Ask for screen name, purpose, and whether it needs a ViewModel
2. Plan folder structure — if screen has sub-views, create `CustomViews/` folder
3. Create `{Name}Screen.swift`:

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
import SwiftUI
import TTBaseUIKit

struct {Name}Screen: View {

    @StateObject private var viewModel = {Name}ViewModel()

    var body: some View {
        SUIBaseView(
            backType: .POP,
            title: XTextU("App.{Name}.Nav.Title"),
            isHiddenTabbar: true
        ) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: XSize.P_CONS_DEF) {
                    // Content — use 100% standard SwiftUI
                    Text(XText("App.{Name}.Header"))
                        .font(.system(size: XFont.HEADER_H, weight: .bold))
                        .foregroundColor(XView.textDefColor.toColor())

                    Text(XText("App.{Name}.Subtitle"))
                        .font(.system(size: XFont.SUB_TITLE_H))
                        .foregroundColor(XView.textSubTitleColor.toColor())

                    Button {
                        viewModel.performAction()
                    } label: {
                        Text("ACTION")
                            .font(.system(size: XFont.TITLE_H, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: XSize.H_BUTTON)
                            .background(XView.buttonBgDef.toColor())
                            .clipShape(RoundedRectangle(cornerRadius: XSize.CORNER_BUTTON))
                    }
                }
                .padding(XSize.P_CONS_DEF * 2)
            }
            .background(XView.viewBgColor.toColor())
        }
        .onAppear {
            Task { await viewModel.fetchData() }
        }
    }
}

struct {Name}Screen_Previews: PreviewProvider {
    static var previews: some View {
        {Name}Screen()
    }
}
```

3. If screen needs data, create `{Name}ViewModel.swift`:

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
import Foundation

class {Name}ViewModel: ObservableObject {
    @Published var items: [{Model}] = []
    @Published var isLoading = false

    @MainActor
    func fetchData() async {
        isLoading = true
        defer { isLoading = false }
        // API call...
    }

    func performAction() {
        // Handle action
    }
}
```

5. If body > 40 lines or screen has distinct sections, extract sub-views into `{Feature}/CustomViews/`
6. Confirm file location before writing

## Auto-Add to Xcode Project (MANDATORY)
After creating any new Swift file:
```bash
ruby .agent/skills/ttbase-swiftui/scripts/add_to_xcode_project.rb "{file_path}"
```

## Token Quick Reference
```swift
// Colors
XView.textDefColor.toColor()     XView.buttonBgDef.toColor()
XView.viewBgColor.toColor()      XView.lineDefColor.toColor()
XView.textHeaderColor.toColor()  XView.iconColor.toColor()
// Sizes
XSize.P_CONS_DEF (8pt)           XSize.P_CONS_DEF * 2 (16pt)
XSize.CORNER_RADIUS (4pt)        XSize.CORNER_BUTTON
XSize.H_BUTTON (40pt)            XSize.W / XSize.H
// Fonts
XFont.HEADER_H (16pt)  XFont.TITLE_H (14pt)  XFont.SUB_TITLE_H (12pt)
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
