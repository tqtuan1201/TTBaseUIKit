# UIKit Controller Template

```swift
final class <#ScreenView#>: TTBaseUIView, TTViewCodable {
    private let titleLabel = TTBaseUILabel(withType: .HEADER)

    override func updateBaseUIView() {
        setupViewCodable(with: [titleLabel])
    }

    func setupConstraints() {
        titleLabel.setLeadingAnchor(constant: TTSize.P_S)
            .setTopAnchor(constant: TTSize.P_S)
            .done()
    }
}

final class <#ScreenController#>: TTBaseUIViewController<<#ScreenView#>> {
    override func updateBaseUI() {
        navType = .STATUS_NAV
    }
}
```
