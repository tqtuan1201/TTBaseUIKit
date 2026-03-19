---
description: "Scaffold a TTBaseUIKit TableView screen with Cell + ViewController + ViewModel"
---

# Create New TableView Screen

Scaffold a full UIKit TableView screen following TTBaseUIKit standards.

## Rules

- TableView: `TTBaseUITableView(frame: .zero, style: .plain)`
- Cell extends `TTBaseUITableViewCell` (NOT UITableViewCell)
- Register cell with static `cellId`
- Row height: `TTSize.H_CELL`
- Separator color: `TTView.lineDefColor`
- DataSource + Delegate in a separate `extension`
- Constraints: pin tableView below `navBar` → `.setTopAnchorWithAboveView(nextToView: navBar, constant: 0)`

## Steps

1. Ask for screen name and model type (if not given)
2. Create Cell:

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
class {Name}Cell: TTBaseUITableViewCell {
    static let cellId = "{Name}Cell"

    let titleLbl = TTBaseUILabel(withType: .TITLE, text: "", align: .left)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupUI()
    }
    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        self.contentView.addSubviews(views: [titleLbl])
        titleLbl.setLeadingAnchor(constant: TTSize.P_CONS_DEF)
                .setTopAnchor(constant: TTSize.P_CONS_DEF)
                .setTrailingAnchor(constant: TTSize.P_CONS_DEF)
                .setBottomAnchor(constant: TTSize.P_CONS_DEF)
                .done()
    }

    func configure(with model: {Model}) {
        titleLbl.setText(text: model.title)
    }
}
```

3. Create ViewController with lazy tableView, DataSource/Delegate extension
4. Create ViewModel with `items: [{Model}]`, `onUpdateUI`, `onShowError`, `fetchData()`
5. Confirm file locations before writing

## Plan Output (MANDATORY)

After completing any work, generate a plan file for future context:

1. Create `plans/YYYY-MM-DD-{feature-name}/plan.md`
2. Include: date, goal, files table (NEW/MODIFY/DELETE), patterns & tokens used, context for future upgrades
3. Auto-add plan file to Xcode:
```bash
ruby .agent/skills/ttbase-swiftui/scripts/add_to_xcode_project.rb "{plan_file_path}"
```

> See `instructions/plan-generation.instructions.md` for full templates.
