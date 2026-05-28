---
description: "Scaffold a UIKit list screen with UITableView or UICollectionView, using TTBaseUITableView, TTBaseUICollectionViewCell, and MVVM."
---

# ttb-skill-list  --  UIKit List Screen Builder

Build a production-ready UIKit list screen using TTBaseUITableView / TTBaseUICollectionView + MVVM.

## Mandatory Preflight Execution Gate

Before generating code or modifying files, run `ttb-skill-shared/fragments/ttb-preflight-execution-gate.frag.md`.

Required checks:

- Analyze intent, task type, scope, impacted files/modules, dependencies, architecture constraints, coding standards, and project-specific rules.
- Validate required inputs such as target module, screen/component name, file location, navigation flow, expected output, API contract, state management, routing, localization, naming, and reusable component requirements.
- Detect ambiguity, conflicting requirements, incomplete business logic, unclear UX/navigation, unclear module ownership, and unclear architecture direction.
- Score confidence from `0-100`: execute at `90-100`, execute with warning assumptions at `70-89`, and ask a survey below `70` using `ttb-skill-shared/templates/ttb-clarification-survey.md`.
- Support English, Vietnamese, mixed-language, diacritic-free Vietnamese, and light typo prompts.

## When

User says: "build list", "tableview screen", "collection view", "list screen"

## Steps

### 1. Clarify
Ask if not provided:
- List type: UITableView or UICollectionView?
- Cell layout (icon+title+subtitle, card, etc.)
- Data source (API, local)
- Pull-to-refresh needed?
- Pagination needed?

### 2. Generate

#### TableViewCell
```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  {Name}Cell.swift
//  {AppName}
//

import TTBaseUIKit

class {Name}Cell: TTBaseUITableViewCell {
    static let cellId = "{Name}Cell"

    private let iconImg = TTBaseUIImageFontView(
        withFontIconLightSize: AwesomePro.Light.user,
        sizeIcon: CGSize(width: 24, height: 24),
        colorIcon: TTView.iconColor
    )
    private let titleLbl = TTBaseUILabel(withType: .TITLE, text: "", align: .left)
    private let subtitleLbl = TTBaseUILabel(withType: .SUB_TITLE, text: "", align: .left)
    private let rightIcon = TTBaseUIImageFontView(
        withFontIconRegularSize: AwesomePro.Regular.chevronRight,
        sizeIcon: CGSize(width: 12, height: 12),
        colorIcon: TTView.textSubTitleColor
    )

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        self.contentView.addSubviews(views: [self.iconImg, self.titleLbl, self.subtitleLbl, self.rightIcon])

        self.iconImg.setLeadingAnchor(constant: TTSize.P_CONS_DEF)
            .setCenterYAnchor(constant: 0)
            .setWidthAnchor(constant: 40)
            .setHeightAnchor(constant: 40)
            .done()

        self.titleLbl.setLeadingWithNextToView(view: self.iconImg, constant: TTSize.P_S)
            .setTopAnchor(constant: TTSize.P_CONS_DEF)
            .setTrailingWithNextToView(view: self.rightIcon, constant: TTSize.P_S)
            .done()

        self.subtitleLbl.setLeadingWithNextToView(view: self.iconImg, constant: TTSize.P_S)
            .setTopAnchorWithAboveView(nextToView: self.titleLbl, constant: 4)
            .setTrailingWithNextToView(view: self.rightIcon, constant: TTSize.P_S)
            .setBottomAnchor(constant: TTSize.P_CONS_DEF)
            .done()

        self.rightIcon.setTrailingAnchor(constant: TTSize.P_CONS_DEF)
            .setCenterYAnchor(constant: 0)
            .setWidthAnchor(constant: 12)
            .setHeightAnchor(constant: 12)
            .done()
    }

    func configure(with model: {Name}Model) {
        self.titleLbl.setText(text: model.title ?? "")
        self.subtitleLbl.setText(text: model.subtitle ?? "")
    }
}
```

#### ViewController
```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  {Name}ListViewController.swift
//  {AppName}
//

import TTBaseUIKit

class {Name}ListViewController: TTBaseUITableViewController {

    private let viewmodel = {Name}ListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleNav(XTextU("App.{Name}.Nav.Title"))
        self.setupUI()
        self.setupConstraints()
        self.bindViewModel()
        self.viewmodel.fetchData()
    }

    override func setupUI() {
        super.setupUI()
        self.tableView.register({Name}Cell.self, forCellReuseIdentifier: {Name}Cell.cellId)
        self.tableView.rowHeight = TTSize.H_CELL
        self.tableView.separatorColor = TTView.lineDefColor
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: TTSize.P_CONS_DEF, bottom: 0, right: TTSize.P_CONS_DEF)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        TTBaseFunc.shared.printLog(object: "Deinit: {Name}ListViewController")
    }
}

extension {Name}ListViewController {
    override func tableView(_ tv: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewmodel.items.count
    }

    override func tableView(_ tv: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCell(withIdentifier: {Name}Cell.cellId, for: indexPath) as! {Name}Cell
        cell.configure(with: self.viewmodel.items[indexPath.row])
        return cell
    }

    override func tableView(_ tv: UITableView, didSelectRowAt indexPath: IndexPath) {
        tv.deselectRow(at: indexPath, animated: true)
        let detailVC = {Detail}ViewController(model: self.viewmodel.items[indexPath.row])
        self.push(detailVC)
    }
}

extension {Name}ListViewController {
    private func bindViewModel() {
        self.viewmodel.onShowError = { [weak self] msg in self?.showAlert(msg) }
        self.viewmodel.onShowLoading = { [weak self] in self?.showLoadingView(type: .VIEW_CENTER) }
        self.viewmodel.onHideLoading = { [weak self] in self?.removeLoading() }
        self.viewmodel.onUpdateUI = { [weak self] in
            self?.tableView.reloadData()
            self?.updateEmptyState()
        }
    }
    private func updateEmptyState() {
        self.tableView.isHidden = self.viewmodel.items.isEmpty
    }
}
```

### 3. Verify

- [ ] Cell extends `TTBaseUITableViewCell`
- [ ] `static let cellId`
- [ ] `selectionStyle = .none`
- [ ] `dequeueReusableCell` for cell creation
- [ ] `[weak self]` in all closures
- [ ] Config tokens
- [ ] XText/XTextU

## Real TTBaseUIKit APIs

### TTBaseUITableViewController
```swift
class TTBaseUITableViewController: TTBaseUIViewController<TTBaseUIView>, UITableViewDelegate {
    var tableView: TTBaseUITableView  // pre-initialized
    // Override setupUI() / setupConstraints() to customize
}
```

### Constraint Helpers (Real)
```swift
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
// Always end chain with .done()
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
