# Incorrect Example: Raw UIKit

```swift
final class BadView: UIView {
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.red
        label.font = UIFont.systemFont(ofSize: 16)
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }
}
```

Issues
- Uses raw UIKit instead of TTBaseUIKit wrappers
- Hard-coded colors and fonts
- Uses NSLayoutConstraint.activate
