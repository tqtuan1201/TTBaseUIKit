# UIKit — Dựng Custom View (TTBaseUIView Subclass)

> **Phạm vi:** Tạo MỘT custom view duy nhất kế thừa `TTBaseUIView`. Dùng làm sub-view tái sử dụng trong VC, Cell, hoặc Popup.  
> **Nền tảng:** UIKit, tuân thủ tuyệt đối TTBaseUIKit.

---

## 1. Kiến Trúc

```
TTBaseUIView  (TTBaseUIKit)
   └── YourCustomView
         ├── override updateBaseUIView()     ← entry point (KHÔNG phải updateUI)
         │     ├── super.updateBaseUIView()
         │     └── setupViewCodable(with: [])
         ├── func configure(...)             ← public API để set data
         └── extension TTViewCodable
               ├── setupCustomView()         ← addSubviews
               ├── setupConstraints()        ← chainable API
               └── setupStyles()             ← màu, font, corner
```

---

## 2. Quy Trình Từng Bước

### Bước 1 — Vẽ ASCII Layout Diagram

Bắt buộc đặt ngay trên khai báo `class`:

```swift
/// ┌─ MyCustomView ────────────────────────────────────────────────┐
/// │  LP                                                       LP  │
/// │  ┌─ iconView (40×40) ──┐  SP  ┌─ titleLabel (TITLE) ─────┐  │
/// │  │                      │      │                           │  │
/// │  │                      │      ├─ subLabel (SUB_TITLE) ───┤  │
/// │  └──────────────────────┘      └───────────────────────────┘  │
/// │  SP                                                       SP  │
/// └───────────────────────────────────────────────────────────────┘
```

---

### Bước 2 — Khai báo Class

```swift
final class MyCustomView: TTBaseUIView {

    // MARK: - UI Components
    private let iconView:   TTBaseUIImageView = TTBaseUIImageView(imageName: "ic_icon", contentMode: .scaleAspectFit)
    private let titleLabel: TTBaseUILabel     = TTBaseUILabel(withType: .TITLE, align: .left)
    private let subLabel:   TTBaseUILabel     = TTBaseUILabel(withType: .SUB_TITLE, align: .left)

    // MARK: - Layout Constants
    private let iconSize: CGFloat = 40

    // MARK: - Entry Point
    // ⚠️ LUÔN override updateBaseUIView — KHÔNG phải updateUI
    override func updateBaseUIView() {
        super.updateBaseUIView()
        self.setupViewCodable(with: [])   // ← truyền [] rỗng, add subviews trong setupCustomView
    }

    // MARK: - Public API
    func configure(title: String, sub: String) {
        self.titleLabel.setText(text: title).done()
        self.subLabel.setText(text: sub).done()
    }
}
```

**Quy tắc:**
- `final class` — trừ khi cần kế thừa tiếp.
- `setupViewCodable(with: [])` — luôn truyền mảng rỗng `[]`. Tự quản lý subviews trong `setupCustomView`.
- KHÔNG override `updateUI()` — method đó thuộc `TTBaseUITableViewCell`, không thuộc `TTBaseUIView`.

---

### Bước 3 — Implement TTViewCodable

```swift
// MARK: - TTViewCodable
extension MyCustomView: TTViewCodable {

    // 1. Hierarchy
    func setupCustomView() {
        self.addSubviews(views: [self.iconView, self.titleLabel, self.subLabel])
    }

    // 2. Constraints — CHỈ dùng chainable API
    func setupConstraints() {
        self.iconView
            .setLeadingAnchor(constant: XSize.LP())
            .setcenterYAnchor(constant: 0)
            .setSquareSize(with: self.iconSize)

        self.titleLabel
            .setLeadingWithNextToView(view: self.iconView, constant: XSize.SP())
            .setTopAnchor(constant: XSize.SP())
            .setTrailingAnchor(constant: XSize.LP())

        self.subLabel
            .setLeadingWithNextToView(view: self.iconView, constant: XSize.SP())
            .setTopAnchorWithAboveView(nextToView: self.titleLabel, constant: XSize.P_CONS_DEF / 2)
            .setTrailingAnchor(constant: XSize.LP())
            .setBottomAnchor(constant: XSize.SP())
    }

    // 3. Styles
    func setupStyles() {
        self.setBgColor(.white)
        self.setConerRadius(with: XSize.CORNER_RADIUS)
        self.titleLabel.setBold()
        self.subLabel.setTextColor(color: .appLabelVeryLightGray)
        self.subLabel.numberOfLines = 0
    }
}
```

---

## 3. Sử Dụng CustomView Làm Table Header

```swift
// Trong VC:
private let headerView: MyCustomView = MyCustomView()
private var isHeaderAdded: Bool = false

override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    guard !self.isHeaderAdded, self.tblView.bounds.width > 0 else { return }
    self.isHeaderAdded = true
    self.tblView.addHeaderView(withView: self.headerView)
}
```

> **⚠️** `addHeaderView(withView:)` là method của TTBaseUIKit tự tính `systemLayoutSizeFitting`. Gọi trong `viewDidLayoutSubviews` để đảm bảo bounds đã có.

---

## 4. Constraint API — Tham chiếu nhanh

| Method | Mô tả |
|---|---|
| `.setLeadingAnchor(constant:)` | Lề trái superview |
| `.setTrailingAnchor(constant:)` | Lề phải superview |
| `.setTopAnchor(constant:)` | Lề trên superview |
| `.setBottomAnchor(constant:)` | Lề dưới superview |
| `.setHeightAnchor(constant:)` | Chiều cao cố định |
| `.setWidthAnchor(constant:)` | Chiều rộng cố định |
| `.setSquareSize(with:)` | Width = Height |
| `.setFullContraints(constant:)` | Fill superview |
| `.setCenterXAnchor(constant:)` | Giữa trục X (**C** hoa) |
| `.setcenterYAnchor(constant:)` | Giữa trục Y (**c** thường) |
| `.setFullCenterAnchor(view, constant:)` | Giữa cả X + Y |
| `.setTopAnchorWithAboveView(nextToView:, constant:)` | Đặt dưới view khác |
| `.setBottomAnchorWithBelowView(view:, constant:)` | Đặt trên view khác |
| `.setLeadingWithNextToView(view:, constant:)` | Đặt bên phải view khác |
| `.setTrailingWithNextToView(view:, constant:)` | Đặt bên trái view khác |

---

## 5. Gotcha List

| # | ❌ Sai | ✅ Đúng |
|---|---|---|
| 1 | `override func updateUI()` | `override func updateBaseUIView()` |
| 2 | `setupViewCodable(with: [subview1, subview2])` | `setupViewCodable(with: [])` rồi tự add trong `setupCustomView` |
| 3 | `.setcenterXAnchor(constant:)` | `.setCenterXAnchor(constant:)` — **C** hoa |
| 4 | `.setTopAnchorWithAboveView(toView:)` | `.setTopAnchorWithAboveView(nextToView:)` |
| 5 | `label.setBoldTitle()` | `label.setBold()` |
| 6 | `.setFontSizeTitle(with:isBold:)` | `.setFontSize(size:).setBold()` |
| 7 | `UIColor.appGrayColor` | `UIColor.appGray` |
| 8 | `frame.height = h` | `frame.size.height = h` — `CGRect.height` là get-only |
| 9 | Khai báo `UIImageView` rồi dùng API của `TTBaseUIImageView` | Chỉ dùng một loại — không trộn |
| 10 | `NSLayoutConstraint.activate([...])` | Dùng chainable API |

---

## 6. Checklist

- [ ] ASCII Layout Diagram trên `class`
- [ ] Kế thừa `TTBaseUIView`, override `updateBaseUIView()` (KHÔNG `updateUI`)
- [ ] Gọi `super.updateBaseUIView()` rồi `setupViewCodable(with: [])`
- [ ] TTViewCodable trong **extension riêng**
- [ ] Đúng thứ tự: `setupCustomView` → `setupConstraints` → `setupStyles`
- [ ] Mọi property trong extension dùng `self.`
- [ ] KHÔNG có `NSLayoutConstraint.activate`
- [ ] `setCenterXAnchor` (C hoa), `setcenterYAnchor` (c thường) — đúng casing
- [ ] `setTopAnchorWithAboveView(nextToView:)` — đúng label
- [ ] `.setBold()` (không phải `setBoldTitle()`), `.setFontSize(size:)` (không phải `setFontSizeTitle`)
- [ ] Không hardcode color/size/font/string
- [ ] Nếu làm tableHeaderView: gọi `addHeaderView(withView:)` trong `viewDidLayoutSubviews`
