# UIKit Component Template

```swift
final class <#ComponentName#>: TTBaseUIView, TTViewCodable {
    private let titleLabel = TTBaseUILabel(withType: .TITLE)
    private let iconView = TTBaseUIImageView()

    override func updateBaseUIView() {
        setupViewCodable(with: [iconView, titleLabel])
    }

    func setupConstraints() {
        iconView.setLeadingAnchor(constant: TTSize.P_S)
            .setCenterXAnchor(constant: 0)
            .setSquareSize(with: TTSize.H_SMALL_ICON)
        titleLabel.setLeadingWithNextToView(view: iconView, constant: TTSize.P_S)
            .setCenterXAnchor(constant: 0)
    }
}
```
