---
description: "Scaffold a UIKit form screen with TTBaseUITextField, validation, and submit button using TTBaseUIKit."
---

# ttb-skill-form -- UIKit Form Screen Builder

Build a production-ready UIKit form screen with text fields, validation, and submit using TTBaseUIKit.

## When

User says: "build form", "input screen", "form with validation", "registration screen"

## Steps

### 1. Clarify
Ask if not provided:
- Form fields (name, email, phone, password, etc.)
- Validation rules
- Submit action (API call, navigation)

### 2. Generate

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  {Name}FormViewController.swift
//  {AppName}
//

import TTBaseUIKit

class {Name}FormViewController: TTBaseUIViewController<TTBaseUIView> {

    private let viewmodel = {Name}FormViewModel()
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let card = TTBaseShadowPanelView()

    // MARK: - Form Fields
    private let nameField = TTBaseUITextField(withPlaceholder: "", type: .ONLY_BOTTOM, isSetHeight: true)
    private let emailField = TTBaseUITextField(withPlaceholder: "", type: .ONLY_BOTTOM, isSetHeight: true)
    private let submitBtn = TTBaseUIButton(textString: "", type: .DEFAULT, isSetHeight: true)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleNav(XTextU("App.{Name}.Nav.Title"))
        self.setupData()
        self.setupUI()
        self.setupStyles()
        self.setupConstraints()
        self.bindComponents()
        self.bindViewModel()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        TTBaseFunc.shared.printLog(object: "Deinit: {Name}FormViewController")
    }
}

extension {Name}FormViewController: TTViewCodable {

    func setupCustomView() {}

    func setupData() {
        self.nameField.placeholder = XText("App.{Name}.Field.Name")
        self.emailField.placeholder = XText("App.{Name}.Field.Email")
        self.submitBtn.setText(text: XText("App.{Name}.Button.Submit"))
    }

    func setupUI() {
        self.emailField.setKeyboardStyleByEmail()

        self.nameField.onTextEditChangedHandler = { [weak self] _, text in
            self?.viewmodel.name = text
        }
        self.emailField.onTextEditChangedHandler = { [weak self] _, text in
            self?.viewmodel.email = text
        }

        self.submitBtn.onTouchHandler = { [weak self] _ in
            self?.onSubmitTapped()
        }

        self.contentView.addSubviews(views: [self.scrollView])
        self.scrollView.addSubview(self.stackView)

        self.stackView.axis = .vertical
        self.stackView.spacing = TTSize.P_CONS_DEF

        self.card.panelShadowView.addSubviews(views: [self.nameField, self.emailField])
        self.stackView.addArrangedSubview(self.card)
        self.stackView.addArrangedSubview(self.submitBtn)
    }

    func setupStyles() {
        self.view.backgroundColor = TTView.viewBgColor
        self.nameField.setTextFieldStyle(hasUnderline: true)
        self.emailField.setTextFieldStyle(hasUnderline: true)
    }

    func setupConstraints() {
        self.scrollView.setFullContraints(view: self.contentView, constant: 0)

        self.stackView.setFullContraints(view: self.scrollView, constant: TTSize.P_CONS_DEF)
        self.stackView.layoutMargins = UIEdgeInsets(
            top: TTSize.P_CONS_DEF, left: TTSize.P_CONS_DEF,
            bottom: TTSize.P_CONS_DEF, right: TTSize.P_CONS_DEF
        )

        self.nameField.setHeightAnchor(constant: TTSize.H_TEXTFIELD)
        self.emailField.setHeightAnchor(constant: TTSize.H_TEXTFIELD)

        self.submitBtn.setHeightAnchor(constant: TTSize.H_BUTTON)
    }

    func bindComponents() {}

    func bindViewModel() {
        self.viewmodel.onShowError = { [weak self] msg in
            self?.showAlert(msg)
        }
        self.viewmodel.onShowLoading = { [weak self] in
            self?.showLoadingView(type: .VIEW_CENTER)
        }
        self.viewmodel.onHideLoading = { [weak self] in
            self?.removeLoading()
        }
        self.viewmodel.onSuccess = { [weak self] in
            self?.pop()
        }
        self.viewmodel.onFieldError = { [weak self] field, msg in
            self?.showFieldError(field: field, message: msg)
        }
    }
}

extension {Name}FormViewController {
    private func onSubmitTapped() {
        self.clearFieldErrors()
        self.viewmodel.submit()
    }

    private func showFieldError(field: {Name}FormViewModel.Field, message: String) {
        switch field {
        case .name:
            self.nameField.onDetectPositionForValidation()
        case .email:
            self.emailField.onDetectPositionForValidation()
        case .none:
            break
        }
    }

    private func clearFieldErrors() {}
}
```

## Verify

- [ ] All fields use `TTBaseUITextField`
- [ ] `onTextEditChangedHandler` to bind to ViewModel
- [ ] `setKeyboardStyleByEmail()` for email fields
- [ ] Validation in ViewModel
- [ ] Visual feedback in VC
- [ ] Loading/error on both success AND error paths
- [ ] `[weak self]` in all closures

## Real TTBaseUIKit APIs

### TTBaseUITextField
```swift
TTBaseUITextField(withPlaceholder: String, type: .DEFAULT, isSetHeight: Bool)
TTBaseUITextField(withPlaceholder: String, type: .ONLY_BOTTOM, isSetHeight: Bool)
field.placeholder = String  // assign directly
field.setKeyboardStyleByEmail()
field.onTextEditChangedHandler = { [weak self] _, text in }
```

### TTBaseShadowPanelView
```swift
class TTBaseShadowPanelView: TTBaseUIView {
    var panelShadowView: TTBaseUIView  // The content container inside the shadow
}
```

### Non-Existent APIs (DO NOT USE)
```swift
// ❌ These do NOT exist:
XPrint("...")                  // → TTBaseFunc.shared.printLog(...)
BaseShadowPanelView()           // → TTBaseShadowPanelView()
.setTextString(...)           // → .setText(...) or direct assignment to .placeholder
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
