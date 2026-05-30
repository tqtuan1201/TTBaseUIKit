---
name: "ttb-skill-uikit"
description: "UIKit full-stack development: screen, list, form, cell, customview, api, coordinator, viewmodel. Built on TTBaseUIKit + TTViewCodable + MVVM-C. iOS 14+."
version: "2.3.0"
date_updated: "2026-05-30"
risk: "safe"
source: "internal"
loadLevel: "domain"
tags: ["uikit", "ttviewcodable", "mvvm-c", "api", "screen", "list", "form", "cell", "routing"]
---

# ttb-skill-uikit

> UIKit development skill set for TTBaseUIKit apps.
> TTViewCodable | MVVM-C | TTBaseUIKit Components | iOS 14+

## Mandatory Preflight Execution Gate

Before this skill generates code, refactors, migrates, modifies files, creates architecture, updates UI/navigation, changes dependencies, updates workflows, or changes business logic, run the shared gate:

- `ttb-skill-shared/fragments/ttb-preflight-execution-gate.frag.md`
- `ttb-skill-shared/fragments/ttb-cross-functional-analysis-gate.frag.md` for feature updates, new features, and bug fixes
- `ttb-skill-shared/templates/ttb-clarification-survey.md` when confidence is below threshold

Required phase order: Requirement Analysis -> Context Validation -> Ambiguity Detection -> Missing Information Detection -> Survey / Clarification -> Confidence Evaluation -> Execution Approval.

Execution thresholds:

| Confidence | Action |
|------------|--------|
| `90-100` | Execute directly and state key assumptions |
| `70-89` | Execute only with documented low-risk assumptions |
| `<70` | Do not execute; ask a concise survey first |

Cap confidence at `69` when target module, architecture direction, UIKit/SwiftUI choice, navigation behavior, API/business logic, localization format, state management, dependency info, or ownership is unclear. Parse English, Vietnamese, mixed-language, diacritic-free Vietnamese, and light typos before scoring.

For feature updates, new feature development, and bug fixes, analyze as Product Owner, Business Analyst, UX/UI Designer, Solution Architect, Senior Developer, and QA. Compare options across business value, architecture, UI/UX, performance, scalability, maintainability, security, testing, and operations; ask at least 5 value-expansion questions after analysis. If requirements are ambiguous/incomplete, ask at least 6 clarification questions before design/development.

## Skills in This Set

| Command | Description |
|---------|-------------|
| `/ttb-uikit-screen` | Build UIKit screen with TTViewCodable |
| `/ttb-uikit-list` | Build UITableView / UICollectionView screen |
| `/ttb-uikit-form` | Build form screen with validation |
| `/ttb-uikit-cell` | Build UITableViewCell / UICollectionViewCell |
| `/ttb-uikit-customview` | Build reusable custom UIView |
| `/ttb-uikit-api` | Build API service singleton |
| `/ttb-uikit-coordinator` | Build navigation coordinator |
| `/ttb-uikit-viewmodel` | Build ViewModel with MVVM callbacks |

## When to Use

- "build screen", "tạo màn hình UIKit", "new UIKit screen"
- "build list", "tableview screen", "collection view"
- "build form", "input screen", "form with validation"
- "build cell", "table cell", "collection cell"
- "build custom view", "reusable component"
- "build API", "new service endpoint"
- "build coordinator", "navigation flow"
- "build viewmodel", "business logic"

## Routing Contract

```yaml
input:
  required: [artifact_type, feature_name, data_source_or_static_content]
  optional: [navigation_flow, localization_keys, api_contract, validation_rules, empty_loading_error_states]
output:
  artifacts: [viewcontroller_or_view, viewmodel, api_or_requestdata_when_needed, coordinator_when_needed, verification_report]
  completion_gate: "TTViewCodable + TTBaseUIKit + xcodebuild verification"
confidence:
  auto_route: ">= 0.78 for UIKit, ViewController, API, endpoint, service, cell, form, list, coordinator, viewmodel intents"
  clarify: "0.55-0.77 when artifact is screen/view but framework is not stated"
fallback:
  default: "API/service/endpoint prompts route to /ttb-uikit-api because Antigravity owns iOS RequestAPI services."
```

Multilingual aliases: `generate api`, `build endpoint`, `create service`, `tạo api`, `tao api`, `viết api`, `viet api`, `api login`, `tạo màn hình UIKit`, `tao cell`, `tao viewmodel`.

Anti-patterns: do not use raw UIKit when TTBaseUIKit exists; do not put UIKit/SwiftUI imports in ViewModel; do not omit `[weak self]`; do not skip `.done()` in constraint chains.

## Architecture

```
ViewController (TTViewCodable)
  └── ViewModel (BaseViewModel)
        └── API ({Name}API singleton)
              └── RequestData ({Name}RequestData)
```

## Quick Start

1. Identify which skill to use based on the component type
2. Ask clarifying questions (name, components, data source, navigation)
3. Generate code following the pattern
4. Verify: iOS 14+ API, TTBaseUIKit components, `[weak self]`, tokens, `.done()`
5. Generate plan file

## Core Patterns

### TTViewCodable (UIKit)
```swift
extension MyVC: TTViewCodable {
    func setupData() { ... }      // Initialize text content
    func setupUI() { ... }        // Add subviews to contentView
    func setupStyles() { ... }    // Colors from tokens
    func setupConstraints() { ... } // TTBaseUIKit chain ending .done()
    func bindComponents() { ... }   // onTouchHandler, etc.
}
```

### ViewModel (MVVM)
```swift
class MyVM: BaseViewModel {
    func fetchData() {
        guard beginFetching() else { return }
        MyAPI.share.getItems { [weak self] objects, resMess in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.endFetching()
                if resMess.onCheckSuccess(), let objs = objects {
                    self.items = objs
                    self.onUpdateUI?()
                } else {
                    self.onShowError?(resMess.getDes())
                }
            }
        }
    }
}
```

### API Singleton
```swift
class MyAPI {
    static let share = MyAPI()
    fileprivate init() {}
    func getItems(callback: @escaping ...) { ... }
}
```

### RequestData (POST body)
```swift
class MyRequestData: RequestData {
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)  // Always call super first
        // encode fields...
    }
}
```

### Coordinator
```swift
class MyCoordinator: TTCoordinator {
    fileprivate var currVC: UIViewController?
    func start() {
        DispatchQueue.main.async {
            self.showScreen()
        }
    }
}
```

## 11 Iron Laws (UIKit)

1. **iOS 14+ ONLY** — no `UIButtonConfiguration`, `UISheetPresentationController`
2. **TTBaseUIKit COMPONENTS** — no raw `UILabel`, `UIButton`, etc.
3. **TTViewCodable MVVM** — implement all 6 protocol methods
4. **MVVM SEPARATION** — ViewModel never imports UIKit
5. **xcodebuild CLI** — verify builds with command line
6. **ZERO REGRESSION** — verify existing code still works
7. **[weak self]** — in every closure
8. **.done()** — every constraint chain ends with `.done()`
9. **super.encode(to:)** — in every RequestData
10. **MARKER COMMENT** — every generated file has the Antigravity marker
11. **POST-BUILD VERIFICATION IS MANDATORY** — after every skill: `BUILD SUCCEEDED`

## Real TTBaseUIKit APIs (Quick Reference)

### ViewController Base Classes
```swift
TTBaseUIViewController<TTBaseUIView>     // Generic base — preferred
TTBaseUITableViewController              // Already has tableView property
TTBaseUICollectionViewController        // Already has collectionView property
TTBaseScrollViewController              // For scrollable content
TTBaseStackScrollViewController         // For stack + scroll content
```

### UIKit Components
```swift
TTBaseUIView                           // Base view
TTBaseUILabel(withType:.HEADER,...)    // Styled label
TTBaseUIButton(textString:, type:, isSetHeight:)  // Styled button
TTBaseUITextField(withPlaceholder:, type:, isSetHeight:)  // Styled text field
TTBaseUIImageFontView                  // Font icon image
TTBaseUITableView(frame:, style:)     // Table view
TTBaseUICollectionView(...)            // Collection view
TTBaseShadowPanelView                  // Shadow card container
TTBaseStackShadowPanelView             // Stack-based shadow card
```

### Constraint Helpers (on UIView, chainable)
```swift
view.setFullContraints(view: parent, constant: 8)
view.setFullContraints(view: parent, lead:, trail:, top:, bottom:)
view.setLeadingAnchor(constant: 8)
view.setTrailingAnchor(constant: 8)
view.setTopAnchor(constant: 8)
view.setBottomAnchor(constant: 8)
view.setTopAnchorWithAboveView(nextToView: aboveView, constant: 8)
view.setLeadingWithNextToView(view: sibling, constant: 8)
view.setTrailingWithNextToView(view: sibling, constant: 8)
view.setWidthAnchor(constant: 100)
view.setHeightAnchor(constant: 50)
view.setCenterXAnchor(constant: 0)
view.setcenterYAnchor(constant: 0)
view.setFullCenterAnchor(view: parent, constant: 0)
// Always end chain with .done()
```

### TTBaseUILabel Methods (Real)
```swift
lbl.setText(text: "")
lbl.setTextColor(color: TTView.textHeaderColor)
lbl.setBold()
lbl.setMutilLine(numberOfLine: 0)
lbl.setAlign(align: .left)
lbl.setBgColor(.clear)
```

### TTBaseUIButton Methods (Real)
```swift
btn.setText(text: "")
btn.setTextColor(color: .white)
btn.setBgColor(color: TTView.buttonBgDef)
btn.onTouchHandler = { [weak self] _ in }
```

### Non-Existent APIs (DO NOT USE)
```swift
// ❌ Fake — does NOT exist:
TTBaseFunc.shared.printLog(with: "...", object: nil)                  // → TTBaseFunc.shared.printLog(...)
BaseShadowPanelView()          // → TTBaseShadowPanelView()
BaseUIViewController           // → TTBaseUIViewController<TTBaseUIView>
lbl.setTextString(...)        // → lbl.setText(...)
.btn.setTextString(...)       // → btn.setText(...)
```

## Files in This Skill Set

| File | Purpose |
|------|---------|
| `ttb-skill-screen.prompt.md` | Full UIKit screen with TTViewCodable |
| `ttb-skill-list.prompt.md` | UITableView / UICollectionView screen |
| `ttb-skill-form.prompt.md` | Form with text fields and validation |
| `ttb-skill-cell.prompt.md` | Table / Collection cell |
| `ttb-skill-customview.prompt.md` | Reusable custom UIView |
| `ttb-skill-api.prompt.md` | API service singleton |
| `ttb-skill-coordinator.prompt.md` | Navigation coordinator |
| `ttb-skill-viewmodel.prompt.md` | ViewModel with callbacks |

## Shared Resources

- `ttb-skill-shared/rules/ttb-rule-anti-patterns.md` — Component anti-patterns
- `ttb-skill-shared/rules/ttb-rule-coding-standards.md` — Coding conventions
- `ttb-skill-shared/rules/ttb-rule-memory-leaks.md` — Memory leak detection
- `ttb-skill-shared/refs/ttb-ref-ttbaseuikit.md` — API quick reference
- `ttb-skill-shared/refs/ttb-ref-config-tokens.md` — Color/size/font tokens
- `ttb-skill-shared/refs/ttb-ref-ios14-compatibility.md` — iOS 14 API guide
- `ttb-skill-shared/phases/` — Feature research, spec, implementation, code review

---

**Version**: 2.3.0 | **Date**: 2026-05-30
**Changelog**: v2.3.0 — Added cross-functional product analysis gate, option exploration, 5 value-expansion questions, and 6-question ambiguity clarification gate. v2.2.0 — Added standardized routing contract, EN/VI API/screen aliases, input/output schema, confidence guidance, and fallback strategy. v2.0.0 — Version bump, Iron Laws, critical token warnings, and shared resource alignment.
