---
description: "Scaffold a reusable TTBaseUIKit custom UIView (simple or shadow card pattern)."
---

# ttb-skill-customview -- UIKit CustomView Builder

Scaffold a reusable custom UIView using TTBaseUIKit.

## Mandatory Preflight Execution Gate

Before generating code or modifying files, run `ttb-skill-shared/fragments/ttb-preflight-execution-gate.frag.md`.

Required checks:

- Analyze intent, task type, scope, impacted files/modules, dependencies, architecture constraints, coding standards, and project-specific rules.
- Validate required inputs such as target module, screen/component name, file location, navigation flow, expected output, API contract, state management, routing, localization, naming, and reusable component requirements.
- Detect ambiguity, conflicting requirements, incomplete business logic, unclear UX/navigation, unclear module ownership, and unclear architecture direction.
- Score confidence from `0-100`: execute at `90-100`, execute with warning assumptions at `70-89`, and ask a survey below `70` using `ttb-skill-shared/templates/ttb-clarification-survey.md`.
- Support English, Vietnamese, mixed-language, diacritic-free Vietnamese, and light typo prompts.

## When

User says: "build custom view", "reusable component", "custom UIView"

## Pattern A -- Simple TTBaseUIView

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  {Name}View.swift
//  {AppName}
//

import TTBaseUIKit

class {Name}View: TTBaseUIView {

    // MARK: - UI Components
    private let titleLbl = TTBaseUILabel(withType: .HEADER, text: "", align: .left)
    private let subtitleLbl = TTBaseUILabel(withType: .SUB_TITLE, text: "", align: .left)

    var didTouchHandle: (() -> Void)?

    // MARK: - Init
    public override init(frame: CGRect) {
        super.init()
        self.setupUI()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup
    private func setupUI() {
        self.addSubviews(views: [self.titleLbl, self.subtitleLbl])

        self.titleLbl.setVerticalContentHuggingPriority()
            .setLeadingAnchor(constant: TTSize.P_CONS_DEF)
            .setTopAnchor(constant: TTSize.P_CONS_DEF)
            .setTrailingAnchor(constant: TTSize.P_CONS_DEF)
            .done()

        self.subtitleLbl.setTopAnchorWithAboveView(nextToView: self.titleLbl, constant: TTSize.P_S)
            .setLeadingAnchor(constant: TTSize.P_CONS_DEF)
            .setTrailingAnchor(constant: TTSize.P_CONS_DEF)
            .setBottomAnchor(constant: TTSize.P_CONS_DEF)
            .done()

        self.setTouchHandler()
        self.onTouchHandler = { [weak self] _ in
            self?.didTouchHandle?()
        }
    }

    // MARK: - Data
    func setData(title: String, subtitle: String) {
        self.titleLbl.setText(text: title)
        self.subtitleLbl.setText(text: subtitle)
    }
}
```

## Pattern B -- Shadow Card (TTBaseShadowPanelView)

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  {Name}CardView.swift
//  {AppName}
//

import TTBaseUIKit

class {Name}CardView: TTBaseShadowPanelView {

    // MARK: - UI Components
    private let titleLbl = TTBaseUILabel(withType: .TITLE, text: "", align: .left)
    private let rightIcon = TTBaseUIImageFontView(
        withFontIconRegularSize: AwesomePro.Regular.chevronRight,
        colorIcon: UIColor(red: 18, green: 18, blue: 18, alpha: 0.3),
        contendMode: .scaleToFill
    )

    var didTouchHandle: (() -> Void)?

    // MARK: - Init
    public override init(frame: CGRect) {
        super.init()
        self.setupUI()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup
    private func setupUI() {
        self.panelShadowView.addSubviews(views: [self.titleLbl, self.rightIcon])

        self.titleLbl.setLeadingAnchor(constant: TTSize.P_CONS_DEF)
            .setTrailingWithNextToView(view: self.rightIcon, constant: TTSize.P_CONS_DEF)
            .setcenterYAnchor(constant: 0)
            .done()

        self.rightIcon.setTrailingAnchor(constant: TTSize.P_CONS_DEF)
            .setcenterYAnchor(constant: 0)
            .done()

        self.panelShadowView.setHeightAnchor(constant: 60)

        self.panelShadowView.setTouchHandler()
        self.panelShadowView.onTouchHandler = { [weak self] _ in
            self?.didTouchHandle?()
        }
    }

    // MARK: - Data
    func setData(title: String) {
        self.titleLbl.setText(text: title)
    }
}
```

## Rules

1. Extend `TTBaseUIView` (or `TTBaseShadowPanelView` for cards)
2. UI components as `private let`
3. Data binding via `setData(...)` public methods
4. Callbacks as `var didTouchHandle: (() -> Void)?`
5. Use `TTSize.P_CONS_DEF`, `TTSize.getPadding()` -- never hardcode padding
6. Card: use `TTBaseShadowPanelView.panelShadowView` for shadow container
7. Place in `CustomViews/` folder
8. Always end constraint chains with `.done()`

## Real Constraint Methods

```swift
// Available constraint helpers (from ContraintHelpers.swift):
view.setLeadingAnchor(constant: 8)
view.setTrailingAnchor(constant: 8)
view.setTopAnchor(constant: 8)
view.setBottomAnchor(constant: 8)
view.setWidthAnchor(constant: 100)
view.setHeightAnchor(constant: 50)
view.setcenterYAnchor(constant: 0)
view.setCenterXAnchor(constant: 0)
view.setTopAnchorWithAboveView(nextToView: aboveView, constant: 8)
view.setBottomAnchorWithBelowView(view: belowView, constant: 8)
view.setTrailingWithNextToView(view: siblingView, constant: 8)
view.setLeadingWithNextToView(view: siblingView, constant: 8)
view.setFullContraints(constant: 0)
view.setFullContraints(view: parentView, constant: 0)
// Always end chain with .done()
```

### TTBaseUILabel / TTBaseUIButton Priority Helpers
```swift
lbl.setVerticalContentHuggingPriority()   // exists on TTBaseUILabel
lbl.setFullContentHuggingPriority()      // exists on TTBaseUILabel
```

## Non-Existent APIs (DO NOT USE)

```swift
// ❌ These do NOT exist:
.setTopAnchorWithBelowView(...)     // → .setBottomAnchorWithBelowView(view:, constant:)
.newPanelView                       // → .panelShadowView
```

## Post-Implementation Verification (MANDATORY)

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
4. **Skill is complete only when** `BUILD SUCCEEDED`

**Anti-Loop**: Max 3 build attempts. 3 failures — STOP, document errors.

For full FCR 7-Dimension scoring, see `ttb-skill-shared/phases/ttb-phase-verify.md`.
