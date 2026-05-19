---
name: "ttb-skill-uikit"
description: "UIKit full-stack development: screen, list, form, cell, customview, api, coordinator, viewmodel. Built on TTBaseUIKit + TTViewCodable + MVVM-C. iOS 14+."
version: "2.0.0"
loadLevel: "domain"
---

# ttb-skill-uikit

> UIKit development skill set for TTBaseUIKit apps.
> TTViewCodable | MVVM-C | TTBaseUIKit Components | iOS 14+

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

## 10 Iron Laws (UIKit)

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
XPrint("...")                  // → TTBaseFunc.shared.printLog(...)
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

**Version**: 2.0.0 | **Date**: 2026-05-19
**Changelog**: v2.0.0 — Version bump. Added 11 Iron Laws (SUIBaseView + TTBaseNavigationLink). Added critical token warnings. Updated all shared resources to v2.0.0. v1.4.0 — Added real TTBaseUIKit API reference section.
