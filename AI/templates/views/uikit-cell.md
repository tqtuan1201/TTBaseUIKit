# UIKit Cell Template

```swift
final class <#CellName#>: TTBaseUITableViewCell, TTViewCodable {
    private let titleLabel = TTBaseUILabel(withType: .TITLE)

    override func updateUI() {
        setupViewCodable(with: [titleLabel])
    }

    func setupConstraints() {
        titleLabel.setLeadingAnchor(constant: TTSize.P_S)
            .setTopAnchor(constant: TTSize.P_S)
            .setTrailingAnchor(constant: TTSize.P_S)
            .setBottomAnchor(constant: TTSize.P_S)
            .done()
    }
}
```
