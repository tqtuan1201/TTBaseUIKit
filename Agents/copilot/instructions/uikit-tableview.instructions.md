---
applyTo: "**/*TableView*.swift,**/*Cell.swift,**/*TableViewCell.swift"
---

# UIKit TableView & Cell Rules — TTBaseUIKit

## TableView Setup
```swift
private lazy var tableView: TTBaseUITableView = {
    let tv = TTBaseUITableView(frame: .zero, style: .plain)
    tv.register(MyCell.self, forCellReuseIdentifier: MyCell.cellId)
    tv.delegate      = self
    tv.dataSource    = self
    tv.rowHeight     = TTSize.H_CELL              // standard height
    tv.separatorStyle  = .singleLine
    tv.separatorColor  = TTView.lineDefColor
    tv.separatorInset  = UIEdgeInsets(top: 0, left: TTSize.P_CONS_DEF, bottom: 0, right: TTSize.P_CONS_DEF)
    return tv
}()
```

## Cell Declaration
Extend `TTBaseUITableViewCell` (not UITableViewCell directly):
```swift
class MyCell: TTBaseUITableViewCell {
    static let cellId = "MyCell"

    let titleLbl = TTBaseUILabel(withType: .TITLE, text: "", align: .left)
    let subLbl   = TTBaseUILabel(withType: .SUB_TITLE, text: "", align: .left)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupUI()
    }
    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        self.contentView.addSubviews(views: [titleLbl, subLbl])
        titleLbl.setLeadingAnchor(constant: TTSize.P_CONS_DEF)
                .setTopAnchor(constant: TTSize.P_CONS_DEF)
                .setTrailingAnchor(constant: TTSize.P_CONS_DEF)
                .done()
        subLbl.setLeadingAnchor(constant: TTSize.P_CONS_DEF)
              .setTopAnchorWithAboveView(nextToView: titleLbl, constant: 4)
              .setTrailingAnchor(constant: TTSize.P_CONS_DEF)
              .setBottomAnchor(constant: TTSize.P_CONS_DEF)
              .done()
    }

    func configure(with model: MyModel) {
        titleLbl.setText(text: model.title)
        subLbl.setText(text: model.subtitle)
    }
}
```

## DataSource + Delegate Extension
```swift
extension MyViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tv: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }

    func tableView(_ tv: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCell(withIdentifier: MyCell.cellId, for: indexPath) as! MyCell
        cell.configure(with: viewModel.items[indexPath.row])
        return cell
    }

    func tableView(_ tv: UITableView, didSelectRowAt indexPath: IndexPath) {
        tv.deselectRow(at: indexPath, animated: true)
        let detailVC = DetailViewController(model: viewModel.items[indexPath.row])
        self.push(detailVC)
    }

    // Optional: section header
    func tableView(_ tv: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = TableHeaderFooterView()
        header.titleLbl.setText(text: "Section Title")
        return header
    }
    func tableView(_ tv: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return TTSize.H_CELL / 2
    }
}
```

## TableView Constraint in VC
```swift
// Always pin below navBar, above safeArea bottom
tableView.setLeadingAnchor(constant: 0)
         .setTopAnchorWithAboveView(nextToView: navBar, constant: 0)
         .setTrailingAnchor(constant: 0)
         .setBottomSafeAnchor(constant: 0)
         .done()
```

## Empty State
```swift
private func updateEmptyState() {
    let isEmpty = viewModel.items.isEmpty
    emptyView.isHidden  = !isEmpty
    tableView.isHidden  = isEmpty
    if !isEmpty { tableView.reloadData() }
}
```

## CollectionView Cell
Extend `TTBaseUICollectionViewCell` (same pattern as table cell):
```swift
class MyCollectionCell: TTBaseUICollectionViewCell {
    static let cellId = "MyCollectionCell"
    // same pattern as TTBaseUITableViewCell
}
```
