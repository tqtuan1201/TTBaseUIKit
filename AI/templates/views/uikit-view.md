# UIKit View Template

```swift
final class <#ViewName#>: TTBaseUIView, TTViewCodable {
    private let titleLabel = TTBaseUILabel(withType: .TITLE)

    override func updateBaseUIView() {
        setupViewCodable(with: [titleLabel])
    }

    func setupConstraints() {
        titleLabel.setLeadingAnchor(constant: TTSize.P_S)
            .setTopAnchor(constant: TTSize.P_S)
            .setTrailingAnchor(constant: TTSize.P_S)
            .done()
    }

    func setupStyles() {
        backgroundColor = TTView.viewDefColor
    }

    func setupData() {
        titleLabel.setText(text: "Title")
    }
}
```
