---
description: "Scaffold a complete UIKit screen with TTViewCodable, MVVM, and TTBaseUIKit components."
---

# ttb-skill-screen -- UIKit Screen Builder

Build a production-ready UIKit screen using TTBaseUIKit + TTViewCodable + MVVM-C.

## When

User says: "build screen", "create view controller", "new UIKit screen", "tạo màn hình UIKit"

## Steps

### 1. Clarify
Ask if not provided:
- Screen name and purpose
- UI components needed (labels, buttons, forms, lists, etc.)
- Data source (API, local, static)
- Navigation (push, modal, tab)
- Whether a Coordinator is needed

### 2. Plan Files
```
{Feature}/
├── Coordinators/
│   └── {Name}Coordinator.swift
├── ViewControllers/
│   └── {Name}ViewController.swift
├── ViewModels/
│   └── {Name}ViewModel.swift
├── Models/
│   └── {Name}Model.swift
└── CustomViews/
    └── {Name}CustomView.swift
```

### 3. Generate

#### ViewController
```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  {Name}ViewController.swift
//  {AppName}
//

import TTBaseUIKit

class {Name}ViewController: TTBaseUIViewController<TTBaseUIView> {

    // MARK: - Properties
    private let viewmodel = {Name}ViewModel()

    // MARK: - UI Components
    private let titleLbl = TTBaseUILabel(withType: .HEADER, text: "", align: .left)
    private let descLbl = TTBaseUILabel(withType: .SUB_TITLE, text: "", align: .left)
    private let actionBtn = TTBaseUIButton(textString: "", type: .DEFAULT, isSetHeight: true)
    private let cardView = TTBaseShadowPanelView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleNav(XTextU("App.{Name}.Nav.Title"))
        self.setupViewCodable(with: [])
        self.viewmodel.fetchData()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        TTBaseFunc.shared.printLog(with: "Release memory: ", object: "{Name}ViewController")
    }
}

// MARK: - TTViewCodable
extension {Name}ViewController: TTViewCodable {

    func setupCustomView() {
        // Add additional custom views here
    }

    func setupData() {
        self.titleLbl.setText(text: XText("App.{Name}.Title"))
        self.descLbl.setText(text: XText("App.{Name}.Description"))
        self.actionBtn.setText(text: XText("App.{Name}.Button.Action"))
    }

    func setupStyles() {
        self.titleLbl.setTextColor(color: TTView.textHeaderColor)
    }

    func setupConstraints() {
        self.cardView.setFullContraints(view: self.contentView, constant: TTSize.P_CONS_DEF)

        self.titleLbl.setLeadingAnchor(constant: TTSize.P_CONS_DEF)
            .setTopAnchor(constant: TTSize.P_CONS_DEF)
            .setTrailingAnchor(constant: TTSize.P_CONS_DEF)
            .done()

        self.descLbl.setLeadingAnchor(constant: TTSize.P_CONS_DEF)
            .setTopAnchorWithAboveView(nextToView: self.titleLbl, constant: TTSize.P_S)
            .setTrailingAnchor(constant: TTSize.P_CONS_DEF)
            .done()

        self.actionBtn.setLeadingAnchor(constant: TTSize.P_CONS_DEF)
            .setTopAnchorWithAboveView(nextToView: self.descLbl, constant: TTSize.P_L)
            .setTrailingAnchor(constant: TTSize.P_CONS_DEF)
            .setBottomAnchor(constant: TTSize.P_CONS_DEF)
            .done()
    }

    func bindComponents() {
        self.actionBtn.onTouchHandler = { [weak self] _ in
            self?.onActionTapped()
        }
    }

    func bindViewModel() {
        self.viewmodel.onShowError = { [weak self] msg in self?.showAlert(msg) }
        self.viewmodel.onShowLoading = { [weak self] in self?.showLoadingView(type: .VIEW_CENTER) }
        self.viewmodel.onHideLoading = { [weak self] in self?.removeLoading() }
        self.viewmodel.onSuccess = { [weak self] in self?.onActionSuccess() }
        self.viewmodel.onUpdateUI = { [weak self] in self?.updateUI() }
    }
}

// MARK: - Actions
extension {Name}ViewController {
    private func onActionTapped() {
        self.viewmodel.submitData()
    }
    private func onActionSuccess() {
        self.pop()
    }
    private func updateUI() {
        self.titleLbl.setText(text: self.viewmodel.data?.title ?? "")
    }
}
```

### 4. Verify Checklist

- [ ] iOS 14+ APIs only
- [ ] All TTBaseUIKit components used (`TTBaseUIView`, `TTBaseUILabel`, `TTBaseUIButton`, etc.)
- [ ] `TTBaseUIViewController<TTBaseUIView>` — generic base class
- [ ] `[weak self]` in ALL closures
- [ ] Constraint chain ending `.done()`
- [ ] ViewModel has NO UIKit import
- [ ] `deinit` with `removeObserver` + `TTBaseFunc.shared.printLog`
- [ ] XText/XTextU for all user-facing strings
- [ ] Config tokens (TTView, TTSize, TTFont)
- [ ] Plan `.md` generated

### 5. Plan

Create `plans/YYYY-MM-DD-{feature}/plan.md` with date, goal, files table, patterns, status.

## Real TTBaseUIKit APIs

### TTBaseUIViewController (Generic)
```swift
class TTBaseUIViewController<BaseView: TTBaseUIView>: UIViewController {
    var contentView: BaseView { get }  // The main view
    var navBar: TTBaseUINavigationView { get }
    var statusBar: TTBaseUIView { get }
    var navType: NAV_STYLE { get }  // .ONLY_STATUS, .STATUS_NAV, .NO_VIEW
}
```

### Constraint Helpers (Real)
```swift
view.setFullContraints(view: self.contentView, constant: 8)
view.setLeadingAnchor(constant: 8)
view.setTopAnchor(constant: 8)
view.setTrailingAnchor(constant: 8)
view.setBottomAnchor(constant: 8)
view.setTopAnchorWithAboveView(nextToView: aboveView, constant: 8)
view.setLeadingWithNextToView(view: sibling, constant: 8)
view.setTrailingWithNextToView(view: sibling, constant: 8)
view.setWidthAnchor(constant: 100)
view.setHeightAnchor(constant: 50)
view.setcenterYAnchor(constant: 0)
view.setCenterXAnchor(constant: 0)
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
// ❌ Fake — does NOT exist in TTBaseUIKit:
XPrint("...")                  // → TTBaseFunc.shared.printLog(with:..., object:...)
TTBaseShadowPanelView() named // → TTBaseShadowPanelView() — EXISTS but use property panelShadowView
BaseUIViewController          // → TTBaseUIViewController<TTBaseUIView>
navBaseStype                  // → navType (override var navType: NAV_STYLE)
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
