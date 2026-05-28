---
description: "Scaffold a TTBaseUITableViewCell or TTBaseUICollectionViewCell with TTBaseUIKit components."
---

# ttb-skill-cell -- UIKit Cell Builder

Scaffold a reusable TTBaseUITableViewCell or TTBaseUICollectionViewCell.

## Mandatory Preflight Execution Gate

Before generating code or modifying files, run `ttb-skill-shared/fragments/ttb-preflight-execution-gate.frag.md`.

Required checks:

- Analyze intent, task type, scope, impacted files/modules, dependencies, architecture constraints, coding standards, and project-specific rules.
- Validate required inputs such as target module, screen/component name, file location, navigation flow, expected output, API contract, state management, routing, localization, naming, and reusable component requirements.
- Detect ambiguity, conflicting requirements, incomplete business logic, unclear UX/navigation, unclear module ownership, and unclear architecture direction.
- Score confidence from `0-100`: execute at `90-100`, execute with warning assumptions at `70-89`, and ask a survey below `70` using `ttb-skill-shared/templates/ttb-clarification-survey.md`.
- Support English, Vietnamese, mixed-language, diacritic-free Vietnamese, and light typo prompts.

## When

User says: "build cell", "table cell", "collection cell", "list item"

## UITableViewCell

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  {Name}Cell.swift
//  {AppName}
//

import TTBaseUIKit

class {Name}Cell: TTBaseUITableViewCell {
    static let cellId = "{Name}Cell"

    // MARK: - UI Components
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

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup
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

    // MARK: - Configure
    func configure(with model: {Name}Model) {
        self.titleLbl.setText(text: model.title ?? "")
        self.subtitleLbl.setText(text: model.subtitle ?? "")
    }
}
```

## UICollectionViewCell

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  {Name}CollectionCell.swift
//  {AppName}
//

import TTBaseUIKit

class {Name}CollectionCell: TTBaseUICollectionViewCell {
    static let cellId = "{Name}CollectionCell"

    private let containerView = TTBaseUIView()
    private let titleLbl = TTBaseUILabel(withType: .TITLE, text: "", align: .center)
    private let iconImg = TTBaseUIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        self.contentView.addSubviews(views: [self.containerView])
        self.containerView.addSubviews(views: [self.titleLbl, self.iconImg])

        self.containerView.setFullContraints(view: self.contentView, constant: TTSize.P_CONS_DEF)
        self.containerView.setCorner(withCornerRadius: TTSize.CORNER_PANEL)
        self.containerView.setBgColor(TTView.viewBgCellColor)

        self.iconImg.setCenterXAnchor(constant: 0)
            .setTopAnchor(constant: TTSize.P_CONS_DEF)
            .setWidthAnchor(constant: 50)
            .setHeightAnchor(constant: 50)
            .done()

        self.titleLbl.setTopAnchorWithAboveView(nextToView: self.iconImg, constant: TTSize.P_S)
            .setFullContraints(view: self.containerView, lead: TTSize.P_S, trail: TTSize.P_S, top: 0, bottom: TTSize.P_S)
    }

    func configure(with model: {Name}Model) {
        self.titleLbl.setText(text: model.title ?? "")
    }
}
```

## Rules

1. Extend `TTBaseUITableViewCell` (not UITableViewCell)
2. Extend `TTBaseUICollectionViewCell` (not UICollectionViewCell)
3. Always declare `static let cellId = "{Name}Cell"`
4. `selectionStyle = .none` by default
5. UI components as `private let`
6. Constraints use TTBaseUIKit chain ending `.done()`
7. `configure(with:)` for data binding
8. No business logic in cell

## Real Constraint Methods

```swift
// Available constraint helpers (from ContraintHelpers.swift):
view.setLeadingAnchor(constant: 8)
view.setTrailingAnchor(constant: 8)
view.setTopAnchor(constant: 8)
view.setBottomAnchor(constant: 8)
view.setTopAnchorWithAboveView(nextToView: aboveView, constant: 8)
view.setBottomAnchorWithBelowView(view: belowView, constant: 8)
view.setLeadingWithNextToView(view: siblingView, constant: 8)   // ← correct
view.setTrailingWithNextToView(view: siblingView, constant: 8)
view.setWidthAnchor(constant: 100)
view.setHeightAnchor(constant: 50)
view.setCenterXAnchor(constant: 0)
view.setcenterYAnchor(constant: 0)
view.setFullContraints(view: parent, constant: 0)
view.setFullContraints(view: parent, lead:, trail:, top:, bottom:)
// Always end chain with .done()
```

## Non-Existent APIs (DO NOT USE)

```swift
// ❌ These do NOT exist:
.setLeadingAnchorWithSiblingView(...)   // → .setLeadingWithNextToView(view:, constant:)
.setTrailingAnchorWithNextToView(...)    // → .setTrailingWithNextToView(view:, constant:)
.setTopWithBelowView(...)               // → .setTopAnchorWithAboveView(nextToView:, constant:)
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
