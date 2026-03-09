# UIKit — Dựng UI Tính Năng Mới (UI ONLY)

> **Phạm vi:** Chỉ dựng giao diện (ViewController + Cell + CustomView). KHÔNG bao gồm API, ViewModel logic, Coordinator.  
> **Nền tảng:** UIKit, tuân thủ tuyệt đối TTBaseUIKit.

---

## 1. Chọn Base VC — Decision Tree

### 1.1 Bảng quyết định

| Khi nào | Dùng | Lý do |
|---|---|---|
| Danh sách đơn giản (list-only, có thể có header) | **`BaseUITableViewController`** | Đã có sẵn `tableView`, delegate, pull-to-refresh, header/footer API. Không cần tự tạo table. |
| Danh sách + bottom panel (button save/confirm) | **`BaseUIViewController`** | Cần tự layout `tblView` + `bottomPanel` linh hoạt — `BaseUITableViewController` không hỗ trợ overlay panel. |
| Màn hình chi tiết / form scroll dọc (không phải list) | **`BaseUIScrollStackViewController`** | Đã có sẵn `bodyScrollStackView` (ScrollView + StackView vertical). Chỉ cần `addArrangedSubview`. |
| Màn hình phức tạp: mix table + collection + custom layout | **`BaseUIViewController`** | Tự do layout mọi thứ. |
| Bottom sheet / slide-up panel | **`BaseCoverVerticalViewController`** | Đã có present animation, dismiss swipe, panelView, round top corners. |

### 1.2 So sánh chi tiết `BaseUIViewController` vs `BaseUITableViewController`

```
┌───────────────────────────────┬──────────────────────────────────────┐
│    BaseUIViewController       │    BaseUITableViewController         │
│    (tự do hoàn toàn)          │    (table-centric)                   │
├───────────────────────────────┼──────────────────────────────────────┤
│ Kế thừa:                      │ Kế thừa:                             │
│   TTBaseUIViewController      │   TTBaseUITableViewController        │
│   <DarkBaseUIView>            │   (→ TTBaseUIViewController)         │
├───────────────────────────────┼──────────────────────────────────────┤
│ tableView: ❌ Không có sẵn    │ tableView: ✅ Có sẵn self.tableView  │
│   → Tự khai báo               │   → Đã add vào view, đã layout      │
│   private let tblView =       │   → Đã set delegate = self           │
│     TTBaseUITableView()       │   → Đã config separator, insets      │
├───────────────────────────────┼──────────────────────────────────────┤
│ Pull-to-refresh: Tự implement │ Pull-to-refresh: ✅ override         │
│                                │   isPullToRequest → true             │
│                                │   didPullToRequestDataHandle = { }   │
├───────────────────────────────┼──────────────────────────────────────┤
│ Header/Footer: Tự implement   │ Header: ✅ addHeaderViewNew(with:)   │
│                                │ Footer: ✅ addFooterView(withView:)  │
├───────────────────────────────┼──────────────────────────────────────┤
│ Layout: Tự layout ALL views   │ Layout: tableView fills view auto    │
│   trong TTViewCodable          │   → Chỉ layout views phụ (nếu có)   │
├───────────────────────────────┼──────────────────────────────────────┤
│ setupViewCodable(with:        │ setupViewCodable(with:               │
│   [tblView, bottomPanel])     │   []) ← thường trống, tableView     │
│                                │   đã có sẵn                          │
├───────────────────────────────┼──────────────────────────────────────┤
│ DataSource: Tự conform        │ DataSource: Tự conform               │
│   UITableViewDataSource       │   UITableViewDataSource              │
│   + set tblView.dataSource    │   (delegate đã set sẵn)              │
├───────────────────────────────┼──────────────────────────────────────┤
│ Bottom panel: ✅ Dễ thêm      │ Bottom panel: ⚠️ Phức tạp            │
│   (layout tự do)              │   (tableView fills toàn bộ view)     │
├───────────────────────────────┼──────────────────────────────────────┤
│ Phù hợp:                      │ Phù hợp:                             │
│ • List + button dưới           │ • List đơn giản (settings, menu)     │
│ • Mix table + custom views     │ • List + header/footer               │
│ • Complex layout               │ • List + pull-to-refresh             │
└───────────────────────────────┴──────────────────────────────────────┘
```

### 1.3 Quick Reference — Khác biệt Property

| Điểm | `BaseUIViewController` | `BaseUITableViewController` |
|---|---|---|
| TableView property | `self.tblView` (tự khai báo) | `self.tableView` (có sẵn) |
| Add tableView | `setupViewCodable(with: [tblView, ...])` | Đã add sẵn — **KHÔNG add lại** |
| Layout tableView | Tự layout trong `setupConstraints` | Đã layout fills view tự động |
| Delegate | Tự set `tblView.delegate = self` | Đã set sẵn |
| DataSource | Tự set `tblView.dataSource = self` | **Cần set** `tableView.dataSource = self` |
| Pull-to-refresh | Tự implement | `isPullToRequest = true` + `didPullToRequestDataHandle` |
| Header API | `tblView.addHeaderView(withView:)` | `self.addHeaderViewNew(with:)` |
| Ẩn tab bar | `override var isSetHiddenTabar: Bool` | `override var isHidenTabar: Bool` ← **tên khác!** |
| Nav type generic | `TTBaseUIViewController<DarkBaseUIView>.NAV_STYLE` | `TTBaseUIViewController<TTBaseUIView>.NAV_STYLE` ← **generic khác!** |

---

## 2. Cấu Trúc Thư Mục

```
Views/{FeatureName}/
├── {FeatureName}VC.swift                    # ViewController chính
├── Cell/
│   └── {FeatureName}TableViewCell.swift     # Cell
└── CustomView/
    └── {FeatureName}HeaderView.swift        # Sub-view tái sử dụng
```

---

## 3. Quy Trình Từng Bước

### Bước 1 — Vẽ ASCII Layout Diagram

Đặt ngay trên khai báo `class` dưới dạng doc-comment `///`. Bắt buộc cho **mọi** VC, Cell, CustomView.

---

### Bước 2A — Tạo VC dùng `BaseUIViewController` (List + Bottom Panel)

> Dùng khi cần **bottom button/panel**, hoặc layout phức tạp ngoài tableView.

```swift
/// ┌─ view ──────────────────────────────────────────────────────────┐
/// │  ┌─ statusBar (H_STATUS) ───────────────────────────────────┐  │
/// │  ┌─ navBar (H_NAV · DEFAULT · ← back + title) ─────────────┐  │
/// │                                                                │
/// │  ┌─ tblView (TTBaseUITableView) ───────────────────────────┐  │
/// │  │  top = getHeightNavWithStatus()                          │  │
/// │  │  ┌─ Cell × N ──────────────────────────────────────────┐│  │
/// │  │  └─────────────────────────────────────────────────────┘│  │
/// │  └──────────────────────────────────────────────────────────┘  │
/// │                                                                │
/// │  ┌─ bottomPanel (white · shadow · pin bottom) ─────────────┐  │
/// │  │  ┌─ actionButton (TTBaseUIButton .DEFAULT) ───────────┐ │  │
/// │  │  └────────────────────────────────────────────────────┘ │  │
/// │  └──────────────────────────────────────────────────────────┘  │
/// └────────────────────────────────────────────────────────────────┘
class {FeatureName}VC: BaseUIViewController {

    // MARK: - ViewController Config
    override var navBaseStype:     BaseUINavigationView.TYPE                        { .DEFAULT }
    override var navType:          TTBaseUIViewController<DarkBaseUIView>.NAV_STYLE { .STATUS_NAV }
    override var isSetHiddenTabar: Bool                                             { true }
    override var bgView:           UIColor                                          { .appBackgroundView }

    // MARK: - UI Components
    private let tblView:      TTBaseUITableView = TTBaseUITableView()   // ← TỰ khai báo
    private let bottomPanel:  TTBaseUIView      = TTBaseUIView()
    private let actionButton: TTBaseUIButton    = TTBaseUIButton(textString: "", type: .DEFAULT, isSetHeight: true)

    // MARK: - Constants
    private let rowHeight: CGFloat = 72

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewCodable(with: [self.tblView, self.bottomPanel])  // ← add cả 2 container
    }

    override func navDidTouchUpBackButton(withNavView nav: BaseUINavigationView) {
        self.pop()
    }
}

// MARK: - TTViewCodable
extension {FeatureName}VC: TTViewCodable {

    func setupCustomView() {
        self.bottomPanel.addSubviews(views: [self.actionButton])
    }

    func setupConstraints() {
        let safeBottom = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets.bottom ?? 0
        let bottomH    = XSize.H_BUTTON + XSize.SP() * 2 + safeBottom

        // ⚠️ TỰ layout tableView — BaseUIViewController không layout tự động
        self.tblView
            .setTopAnchor(constant: XSize.getHeightNavWithStatus())
            .setLeadingAnchor(constant: 0)
            .setTrailingAnchor(constant: 0)
            .setBottomAnchor(constant: 0)

        self.bottomPanel
            .setLeadingAnchor(constant: 0)
            .setTrailingAnchor(constant: 0)
            .setBottomAnchor(constant: 0)
            .setHeightAnchor(constant: bottomH)

        self.actionButton
            .setLeadingAnchor(constant: XSize.LP())
            .setTrailingAnchor(constant: XSize.LP())
            .setTopAnchor(constant: XSize.SP())
            .setHeightAnchor(constant: XSize.H_BUTTON)
    }

    func setupStyles() {
        self.bottomPanel.setBgColor(.white)
        self.bottomPanel.addShadow(
            shadowColor: UIColor.black.withAlphaComponent(0.08),
            offset: CGSize(width: 0, height: -2),
            shadowRadius: 6, cornerRadius: 0, shadowOpacity: 1)
        self.actionButton.setConerRadius(with: XSize.CORNER_RADIUS)
    }

    func bindComponents() {
        self.actionButton.onTouchHandler = { [weak self] _ in
            // TODO: handle action
        }
    }

    func setupData() {
        self.setTitleNav(XText("App.{FeatureName}.Title"))
        self.actionButton.setText(text: XText("App.Button.Save"))
    }

    func setupBaseDelegate() {
        // ⚠️ TỰ set dataSource + delegate — BaseUIViewController không set tự động
        self.tblView.dataSource = self
        self.tblView.delegate   = self
        self.tblView.separatorStyle = .none
        self.tblView.resetContentInset()
        self.tblView.contentInset = UIEdgeInsets(
            top: XSize.SP(), left: 0,
            bottom: XSize.H_BUTTON + XSize.LP() * 3, right: 0)
        self.tblView.register({FeatureName}TableViewCell.self)
    }
}
```

---

### Bước 2B — Tạo VC dùng `BaseUITableViewController` (List đơn giản)

> Dùng khi **list đơn giản**, có thể có header/footer, pull-to-refresh. **KHÔNG có bottom panel**.

```swift
/// ┌─ view ──────────────────────────────────────────────────────────┐
/// │  ┌─ navBar (BaseUINavigationView · DEFAULT) ────────────────┐  │
/// │  └──────────────────────────────────────────────────────────┘  │
/// │                                                                │
/// │  ┌─ tableView (có sẵn · fills view) ───────────────────────┐  │
/// │  │  ┌─ headerView (optional) ─────────────────────────────┐│  │
/// │  │  └─────────────────────────────────────────────────────┘│  │
/// │  │  ┌─ Cell × N ──────────────────────────────────────────┐│  │
/// │  │  └─────────────────────────────────────────────────────┘│  │
/// │  └──────────────────────────────────────────────────────────┘  │
/// └────────────────────────────────────────────────────────────────┘
class {FeatureName}VC: BaseUITableViewController {

    // MARK: - Config
    // ⚠️ navType generic dùng TTBaseUIView (KHÔNG phải DarkBaseUIView)
    override var navBaseStype: BaseUINavigationView.TYPE                       { .DEFAULT }
    override var navType:      TTBaseUIViewController<TTBaseUIView>.NAV_STYLE  { .STATUS_NAV }
    override var isHidenTabar: Bool                                            { true }
    // ⚠️ Property tên là isHidenTabar (KHÔNG phải isSetHiddenTabar)

    // ── Pull-to-refresh (override nếu cần) ──
    override var isPullToRequest: Bool { true }

    // MARK: - UI Components (chỉ khai báo views PHỤ — tableView đã có sẵn)
    private let headerView: {FeatureName}HeaderView = {FeatureName}HeaderView()

    // MARK: - Constants
    private let rowHeight: CGFloat = 72

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewCodable(with: [])   // ← mảng rỗng, tableView đã add sẵn
    }

    override func navDidTouchUpBackButton(withNavView nav: BaseUINavigationView) {
        self.pop()
    }
}

// MARK: - TTViewCodable
extension {FeatureName}VC: TTViewCodable {

    func setupCustomView() {
        // KHÔNG cần add tableView — đã có sẵn trong BaseUITableViewController
    }

    func setupConstraints() {
        // KHÔNG cần layout tableView — đã fills view tự động
    }

    func setupStyles() {
        // tableView style nếu cần
    }

    func bindComponents() {
        // Pull-to-refresh callback (nếu isPullToRequest = true)
        self.didPullToRequestDataHandle = { [weak self] in
            // TODO: refresh data
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self?.refreshControl.endRefreshing()
            }
        }
    }

    func setupData() {
        self.setTitleNav(XText("App.{FeatureName}.Title"))
        // Add header nếu cần:
        // self.addHeaderViewNew(with: self.headerView)
    }

    func setupBaseDelegate() {
        // ⚠️ delegate đã set sẵn bởi TTBaseUITableViewController
        // ⚠️ CHỈ cần set dataSource
        self.tableView.dataSource = self    // ← self.tableView, KHÔNG phải self.tblView
        self.tableView.register({FeatureName}TableViewCell.self)
    }
}
```

---

### Bước 3 — Tạo Cell

```swift
/// ┌─ contentView ────────────────────────────────────────────────┐
/// │  ┌─ panel (padding=0) ─────────────────────────────────────┐│
/// │  │  ┌─ cardView (rounded · border) ──────────────────────┐ ││
/// │  │  │  [iconView]   [titleLabel]           [rightView]   │ ││
/// │  │  │               [subLabel]                           │ ││
/// │  │  └────────────────────────────────────────────────────┘ ││
/// │  └─────────────────────────────────────────────────────────┘│
/// └──────────────────────────────────────────────────────────────┘
class {FeatureName}TableViewCell: TTBaseUITableViewCell {

    // MARK: - Overrides
    override var padding: (CGFloat, CGFloat, CGFloat, CGFloat) { (XSize.LP(), XSize.SP() / 2, XSize.LP(), XSize.SP() / 2) }
    override var isSetBgSelected: Bool { false }

    // MARK: - UI Components
    private let cardView:   TTBaseUIView       = TTBaseUIView(withCornerRadius: XSize.CORNER_RADIUS)
    private let iconView:   TTBaseUIImageView  = TTBaseUIImageView(imageName: "icon.default", contentMode: .scaleAspectFit)
    private let titleLabel: TTBaseUILabel       = TTBaseUILabel(withType: .TITLE, align: .left)
    private let subLabel:   TTBaseUILabel       = TTBaseUILabel(withType: .SUB_TITLE, align: .left)

    // MARK: - Lifecycle (gọi setupViewCodable trong updateUI, KHÔNG trong init)
    override func updateUI() {
        super.updateUI()
        self.setupViewCodable(with: [])
    }

    // MARK: - Public API
    func configure(title: String, sub: String) {
        self.titleLabel.setText(text: title).done()
        self.subLabel.setText(text: sub).done()
    }
}

// MARK: - TTViewCodable
extension {FeatureName}TableViewCell: TTViewCodable {

    func setupCustomView() {
        self.panel.addSubview(self.cardView)
        self.cardView.addSubviews(views: [self.iconView, self.titleLabel, self.subLabel])
    }

    func setupConstraints() {
        self.cardView.setFullContraints(constant: 0)

        self.iconView
            .setLeadingAnchor(constant: XSize.LP())
            .setcenterYAnchor(constant: 0)
            .setSquareSize(with: XSize.H_ICON)

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

    func setupStyles() {
        self.cardView.setBgColor(.white)
        self.cardView.setBorder(with: 1, color: .appThinLightGray, coner: XSize.CORNER_RADIUS)
        self.titleLabel.setBold()
        self.subLabel.setTextColor(color: .appLabelVeryLightGray)
    }
}
```

---

### Bước 4 — UITableView DataSource / Delegate

```swift
// MARK: - UITableViewDataSource & UITableViewDelegate
extension {FeatureName}VC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 // TODO: replace with data count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: {FeatureName}TableViewCell.self, indexPath: indexPath)
        cell.configure(title: "Item \(indexPath.row)", sub: "Description")
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.rowHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: handle selection
    }
}
```

> **Lưu ý:** Nếu dùng `BaseUITableViewController`, chỉ cần conform `UITableViewDataSource` (không cần `UITableViewDelegate` — đã conform sẵn bởi `TTBaseUITableViewController`).

---

## 4. Constraint API — Tham chiếu nhanh

| Method | Mô tả |
|---|---|
| `.setLeadingAnchor(constant:)` | Cách lề trái superview |
| `.setTrailingAnchor(constant:)` | Cách lề phải superview |
| `.setTopAnchor(constant:)` | Cách lề trên superview |
| `.setBottomAnchor(constant:)` | Cách lề dưới superview |
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

> **⚠️** `setCenterXAnchor` (C hoa) vs `setcenterYAnchor` (c thường). `nextToView:` (KHÔNG phải `toView:`).

---

## 5. UI Components — Chỉ dùng TTBaseUIKit

| Cần | Dùng | KHÔNG dùng |
|---|---|---|
| View container | `TTBaseUIView` | `UIView` |
| Label | `TTBaseUILabel(withType:)` | `UILabel` |
| Button | `TTBaseUIButton(textString:, type:)` | `UIButton` |
| ImageView | `TTBaseUIImageView(imageName:)` | `UIImageView` |
| TableView | `TTBaseUITableView` | `UITableView` |
| Cell | kế thừa `TTBaseUITableViewCell` | `UITableViewCell` |
| StackView | `TTBaseUIStackView(axis:)` | `UIStackView` |
| ScrollView | `TTBaseScrollPanelView` | `UIScrollView` |

---

## 6. Style & Assets — KHÔNG hardcode

| Loại | Dùng | Ví dụ |
|---|---|---|
| Colors | `UIColor.app*` / `UIColor.primary` | `.appBlack`, `.appBackgroundView`, `.appLabelVeryLightGray` |
| Fonts | `XFont.*` | `XFont.HEADER_H` (16pt), `XFont.TITLE_H` (14pt), `XFont.SUB_TITLE_H` (12pt) |
| Sizes | `XSize.*` | `XSize.SP()`, `XSize.LP()`, `XSize.H_BUTTON`, `XSize.CORNER_RADIUS` |
| Strings | `XText("key")` | `XText("App.MyFeature.Title")` |

---

## 7. Gotcha List

| # | ❌ Sai | ✅ Đúng |
|---|---|---|
| 1 | `override func updateUI()` trong TTBaseUIView | `override func updateBaseUIView()` |
| 2 | `.setcenterXAnchor(constant:)` | `.setCenterXAnchor(constant:)` — C hoa |
| 3 | `.setTopAnchorWithAboveView(toView:)` | `.setTopAnchorWithAboveView(nextToView:)` |
| 4 | `label.setBoldTitle()` | `label.setBold()` |
| 5 | `.setFontSizeTitle(with:isBold:)` | `.setFontSize(size:).setBold()` |
| 6 | `UIColor.appGrayColor` | `UIColor.appGray` |
| 7 | `NSLayoutConstraint.activate([...])` | Dùng chainable API |
| 8 | `button.addTarget(self, action:)` | `button.onTouchHandler = { }` |
| 9 | `setupViewCodable(with: [subview])` trong CustomView | `setupViewCodable(with: [])` rồi tự add trong `setupCustomView` |
| 10 | Quên `self.` trong extension | Luôn dùng `self.` trong mọi extension |
| 11 | Dùng `isSetHiddenTabar` trong `BaseUITableViewController` | `isHidenTabar` — tên property khác! |
| 12 | Dùng `self.tblView` trong `BaseUITableViewController` | `self.tableView` — property có sẵn |
| 13 | Add `tableView` vào `setupViewCodable` khi dùng `BaseUITableViewController` | `setupViewCodable(with: [])` — tableView đã add sẵn |
| 14 | `TTBaseUIViewController<DarkBaseUIView>.NAV_STYLE` trong `BaseUITableViewController` | `TTBaseUIViewController<TTBaseUIView>.NAV_STYLE` — generic type khác! |

---

## 8. Checklist

- [ ] Đã chọn đúng base VC theo Decision Tree (mục 1.1)
- [ ] Có ASCII Layout Diagram trên mỗi class (VC, Cell, CustomView)
- [ ] `setupViewCodable(with:)` gọi trong `viewDidLoad()` (VC) hoặc `updateUI()` (Cell) hoặc `updateBaseUIView()` (CustomView)
- [ ] TTViewCodable trong **extension riêng**, đúng thứ tự: setupCustomView → setupConstraints → setupStyles → bindComponents → setupData → setupBaseDelegate
- [ ] Mọi property trong extension dùng `self.`
- [ ] KHÔNG có `NSLayoutConstraint.activate` — chỉ dùng chainable API
- [ ] KHÔNG có hardcode string/color/size/font
- [ ] Button action dùng `onTouchHandler` closure, KHÔNG `addTarget`
- [ ] `[weak self]` trong mọi closure

**Nếu dùng `BaseUIViewController`:**
- [ ] Tự khai báo `tblView` và thêm vào `setupViewCodable(with: [tblView, ...])`
- [ ] Tự layout `tblView` trong `setupConstraints`
- [ ] Tự set `tblView.dataSource` + `tblView.delegate`
- [ ] Override `isSetHiddenTabar`
- [ ] NavType generic: `TTBaseUIViewController<DarkBaseUIView>.NAV_STYLE`

**Nếu dùng `BaseUITableViewController`:**
- [ ] KHÔNG khai báo tableView mới — dùng `self.tableView` có sẵn
- [ ] `setupViewCodable(with: [])` — mảng rỗng
- [ ] KHÔNG layout tableView trong `setupConstraints`
- [ ] CHỈ set `tableView.dataSource = self` (delegate đã set sẵn)
- [ ] Override `isHidenTabar` (KHÔNG phải `isSetHiddenTabar`)
- [ ] NavType generic: `TTBaseUIViewController<TTBaseUIView>.NAV_STYLE`
- [ ] Pull-to-refresh: `isPullToRequest = true` + `didPullToRequestDataHandle`
- [ ] Header: dùng `addHeaderViewNew(with:)`
