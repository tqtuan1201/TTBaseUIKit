---
description: "Scaffold a form screen with text fields, validation, and submit button using TTBaseUIKit"
---

# Create Form Screen

Create a UIKit form screen with input validation following TTBaseUIKit patterns.

## Rules
- All text fields: `TTBaseUITextField(withPlaceholder:, type: .ONLY_BOTTOM, isSetHeight: true)`
- Use `onTextEditChangedHandler` to bind to ViewModel
- Validation in ViewModel, visual feedback in VC
- Submit button: `TTBaseUIButton(textString:, type: .DEFAULT, isSetHeight: true)`
- Use `BaseShadowPanelView` to group related fields
- Wrap in `UIScrollView` or `BaseScrollViewController` for long forms

## Steps

1. Ask for form name, fields needed, and validation rules
2. Create ViewController:

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
class {Name}FormViewController: BaseUIViewController {
    override var navBaseStype: BaseUINavigationView.TYPE { return .DEFAULT }

    private let viewModel = {Name}FormViewModel()
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let card = BaseShadowPanelView()

    // Fields
    private let nameField = TTBaseUITextField(withPlaceholder: "Full Name", type: .ONLY_BOTTOM, isSetHeight: true)
    private let emailField = TTBaseUITextField(withPlaceholder: "Email", type: .ONLY_BOTTOM, isSetHeight: true)
    private let submitBtn = TTBaseUIButton(textString: "SUBMIT", type: .DEFAULT, isSetHeight: true)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleNav("Form Title")
        self.setupUI()
        self.setupConstraints()
        self.bindViewModel()
    }

    private func setupUI() {
        emailField.setKeyboardStyleByEmail()
        nameField.onTextEditChangedHandler = { [weak self] _, v in self?.viewModel.name = v }
        emailField.onTextEditChangedHandler = { [weak self] _, v in self?.viewModel.email = v }
        submitBtn.onTouchHandler = { [weak self] _ in self?.viewModel.submit() }
        self.contentView.addSubviews(views: [scrollView])
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(card)
        card.addSubviews(views: [nameField, emailField, submitBtn])
    }

    private func bindViewModel() {
        viewModel.onShowError = { [weak self] msg in self?.showAlert(msg) }
        viewModel.onShowLoading = { [weak self] in self?.showLoadingView(type: .VIEW_CENTER) }
        viewModel.onHideLoading = { [weak self] in self?.removeLoading() }
        viewModel.onSuccess = { [weak self] in self?.pop() }
    }

    deinit { NotificationCenter.default.removeObserver(self); XPrint("Deinit: {Name}FormVC") }
}
```

3. Create ViewModel with validation logic
4. Confirm file locations before writing
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
