---
description: "Scaffold a TTBaseUIKit UITableViewCell or UICollectionViewCell"
---

# Create New TTBaseUIKit Cell

Scaffold a UITableViewCell or UICollectionViewCell following TTBaseUIKit standards.

## Rules

- TableView cell extends `TTBaseUITableViewCell`
- CollectionView cell extends `TTBaseUICollectionViewCell`
- Always declare `static let cellId = "{Name}Cell"`
- `selectionStyle = .none` by default
- UI components declared as `let` at class level — NOT inside setupUI()
- Constraints use TTBaseUIKit chain ending with `.done()`
- `configure(with:)` method for data binding

## For UITableViewCell

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
class {Name}Cell: TTBaseUITableViewCell {
    static let cellId = "{Name}Cell"

    // Declare TTBaseUIKit components
    let titleLbl  = TTBaseUILabel(withType: .TITLE, text: "", align: .left)
    let subLbl    = TTBaseUILabel(withType: .SUB_TITLE, text: "", align: .left)
    let iconView  = TTBaseUIImageFontView(withFontIconLightSize: .circle,
                                          sizeIcon: CGSize(width: 20, height: 20),
                                          colorIcon: TTView.iconColor)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupUI()
    }
    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        self.contentView.addSubviews(views: [iconView, titleLbl, subLbl])

        iconView.setLeadingAnchor(constant: TTSize.P_CONS_DEF)
                .setCenterYAnchor(constant: 0)
                .setWidthAnchor(constant: 24).setHeightAnchor(constant: 24)
                .done()

        titleLbl.setLeadingAnchorWithSiblingView(nextToView: iconView, constant: 8)
                .setTopAnchor(constant: TTSize.P_CONS_DEF)
                .setTrailingAnchor(constant: TTSize.P_CONS_DEF)
                .done()

        subLbl.setLeadingAnchorWithSiblingView(nextToView: iconView, constant: 8)
              .setTopAnchorWithAboveView(nextToView: titleLbl, constant: 4)
              .setTrailingAnchor(constant: TTSize.P_CONS_DEF)
              .setBottomAnchor(constant: TTSize.P_CONS_DEF)
              .done()
    }

    func configure(with model: {Model}) {
        titleLbl.setText(text: model.title)
        subLbl.setText(text: model.subtitle)
    }
}
```

## Steps

1. Ask for cell name, whether TableView or CollectionView, and fields needed
2. Generate cell with appropriate TTBaseUIKit components
3. Ask for file location before writing
4. Auto-add to Xcode project:
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
