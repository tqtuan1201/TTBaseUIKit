# Correct Example: UIKit Card

```swift
final class SummaryCardView: TTBaseUIView, TTViewCodable {
    private let titleLabel = TTBaseUILabel(withType: .HEADER)
    private let valueLabel = TTBaseUILabel(withType: .TITLE)

    override func updateBaseUIView() {
        setupViewCodable(with: [titleLabel, valueLabel])
    }

    func setupConstraints() {
        titleLabel.setLeadingAnchor(constant: TTSize.P_S)
            .setTopAnchor(constant: TTSize.P_S)
            .done()
        valueLabel.setLeadingAnchor(constant: TTSize.P_S)
            .setTopAnchorWithAboveView(nextToView: titleLabel, constant: TTSize.P_XS)
            .setBottomAnchor(constant: TTSize.P_S)
            .done()
    }

    func setupStyles() {
        backgroundColor = TTView.viewDefColor
        setConerRadius(with: TTSize.CORNER_PANEL)
    }
}
```
