---
description: "Scaffold a new TTBaseUIKit UIKit screen (ViewController + ViewModel)"
---

# Create New UIKit Screen

Create a new UIKit screen following TTBaseUIKit and MVVM standards for this iOS project.

## Rules

- **iOS 14+ APIs only** — no `UIButtonConfiguration` (iOS 15+), `UISheetPresentationController` (iOS 15+), or other iOS 15+/16+/17+ APIs
- ViewController extends `BaseUIViewController` (NOT plain UIViewController)
- Add subviews to `self.contentView` (NOT `self.view`)
- All UI components: `TTBaseUILabel`, `TTBaseUIButton`, `TTBaseUITextField`, `TTBaseUIView`
- Never use: `UILabel()`, `UIButton()`, `UITextField()`, `UIView()` as containers
- Navigation: `self.push(vc)`, `self.pop()`, `self.close()` — NOT `navigationController?.pushViewController`
- Constraints: always chain `.setLeadingAnchor().setTopAnchorWithAboveView(nextToView:, constant:).setTrailingAnchor().done()`
- Always `[weak self]` in closures

## Steps

1. Ask for screen name and purpose (if not given)
2. Create `{Name}ViewController.swift`:

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
class {Name}ViewController: BaseUIViewController {

    override var navBaseStype: BaseUINavigationView.TYPE { return .DEFAULT }

    private let viewModel = {Name}ViewModel()
    // UI components here

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleNav("{Name}")
        self.bindViewModel()
        self.setupUI()
        self.setupConstraints()
    }

    private func bindViewModel() {
        viewModel.onShowError = { [weak self] msg in self?.showAlert(msg) }
        viewModel.onSuccess   = { [weak self] in self?.pop() }
    }

    private func setupUI() {
        self.contentView.addSubviews(views: [...])
    }

    private func setupConstraints() {
        // TTBaseUIKit constraint chain
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        XPrint("Deinit: {Name}ViewController")
    }
}
```

3. Create `{Name}ViewModel.swift`:

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
class {Name}ViewModel {
    var onUpdateUI: (() -> Void)?
    var onShowError: ((_ message: String) -> Void)?
    var onSuccess: (() -> Void)?
}
```

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
