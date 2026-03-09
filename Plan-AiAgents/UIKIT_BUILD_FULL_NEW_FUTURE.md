# UIKit — Dựng Toàn Bộ Tính Năng Mới (UI + API + ViewModel + Flow)

> **Phạm vi:** Dựng TOÀN BỘ một tính năng mới từ A→Z: Model, API, ViewModel, ViewController, Cell, CustomView, Coordinator.  
> **Nền tảng:** UIKit, kiến trúc MVVM, tuân thủ tuyệt đối TTBaseUIKit.

---

## 1. Chọn Base VC — Decision Tree

### 1.1 Bảng quyết định

| Khi nào | Dùng | Lý do |
|---|---|---|
| Danh sách đơn giản (list-only, có thể có header) | **`BaseUITableViewController`** | Đã có sẵn `tableView`, delegate, pull-to-refresh, header/footer API |
| Danh sách + bottom panel (button save/confirm) | **`BaseUIViewController`** | Cần tự layout `tblView` + `bottomPanel` linh hoạt |
| Màn hình chi tiết / form scroll dọc | **`BaseUIScrollStackViewController`** | Đã có sẵn `bodyScrollStackView` |
| Màn hình phức tạp: mix table + collection + custom | **`BaseUIViewController`** | Tự do layout mọi thứ |
| Bottom sheet / slide-up | **`BaseCoverVerticalViewController`** | Đã có present/dismiss animation |

### 1.2 So sánh chi tiết

| Điểm | `BaseUIViewController` | `BaseUITableViewController` |
|---|---|---|
| TableView | `self.tblView` (tự khai báo) | `self.tableView` (có sẵn) |
| Add tableView | `setupViewCodable(with: [tblView, ...])` | Đã add sẵn — **KHÔNG add lại** |
| Layout tableView | Tự layout trong `setupConstraints` | Đã fills view tự động |
| Delegate | Tự set `tblView.delegate = self` | Đã set sẵn |
| DataSource | Tự set `tblView.dataSource = self` | **Cần set** `tableView.dataSource = self` |
| Pull-to-refresh | Tự implement | `isPullToRequest = true` + `didPullToRequestDataHandle` |
| Header API | `tblView.addHeaderView(withView:)` | `self.addHeaderViewNew(with:)` |
| Ẩn tab bar | `override var isSetHiddenTabar: Bool` | `override var isHidenTabar: Bool` ← **tên khác!** |
| Nav type generic | `TTBaseUIViewController<DarkBaseUIView>.NAV_STYLE` | `TTBaseUIViewController<TTBaseUIView>.NAV_STYLE` ← **generic khác!** |
| Bottom panel | ✅ Dễ thêm (layout tự do) | ⚠️ Phức tạp (tableView fills toàn bộ) |

---

## 2. Cấu Trúc Thư Mục

```
{Feature}/
├── API/
│   └── {Feature}API.swift                    # Singleton API service
├── Model/
│   └── {Feature}Model.swift                  # Codable struct
└── Views/
    └── {Feature}/
        ├── {Feature}VC.swift                  # ViewController chính
        ├── ViewModel/
        │   └── {Feature}ViewModel.swift       # kế thừa BaseViewModel
        ├── Cell/
        │   └── {Feature}TableViewCell.swift
        ├── CustomView/                        # Sub-views tái sử dụng
        │   └── {Feature}HeaderView.swift
        └── Popup/                             # (tùy chọn)
            ├── {Feature}PopupVC.swift
            └── ViewModel/
                └── {Feature}PopupViewModel.swift
```

---

## 3. Quy Trình Từng Bước

### Bước 1 — Data Model

```swift
// Model/{Feature}Model.swift
struct {Feature}Model: Codable {
    var id:          String?
    var title:       String?
    var description: String?
}
```

> Field dùng `var` + `Optional`. Struct conform `Codable`.

---

### Bước 2 — API Service

```swift
// API/{Feature}API.swift
import Foundation

class {Feature}API {
    static let share = {Feature}API()
    fileprivate init() {}
    fileprivate let API: RequestAPI = RequestAPI()
}

extension {Feature}API {

    // GET list → objRes?.data ([T])
    func getList(callback: @escaping (_ obj: [{Feature}Model]?, _ res: ResponseMessage) -> Void) {
        var item = RequestAPIDataItem(
            service: .NONE, platform: .SERVER, serviceType: .NONE,
            dataRequest: RequestData(), httpMethod: .GET, isAuthorization: true)
        item.param = "/feature-endpoint/"
        API.sendAsSynToCodable(item) { (res: BaseResponse<{Feature}Model>?, msg) in
            callback(res?.data, msg)
        }
    }

    // GET detail → objRes?.value (T?)
    func getDetail(id: String, callback: @escaping (_ obj: {Feature}Model?, _ res: ResponseMessage) -> Void) {
        var item = RequestAPIDataItem(
            service: .NONE, platform: .SERVER, serviceType: .NONE,
            dataRequest: RequestData(), httpMethod: .GET, isAuthorization: true)
        item.param = "/feature-endpoint/\(id)"
        API.sendAsSynToCodable(item) { (res: BaseResponse<{Feature}Model>?, msg) in
            callback(res?.value, msg)
        }
    }
}
```

**Pattern:** Singleton `share` + `RequestAPIDataItem` + `sendAsSynToCodable`. Callback: `(_ obj: T?, _ res: ResponseMessage)`.

---

### Bước 3 — ViewModel

```swift
// Views/{Feature}/ViewModel/{Feature}ViewModel.swift
import TTBaseUIKit

class {Feature}ViewModel: BaseViewModel {

    // MARK: - State
    var dataList: [{Feature}Model] = []

    // MARK: - Actions
    func fetchData() {
        guard !self.isFetching else { return }
        self.isFetching = true
        self.willShowloading?()

        {Feature}API.share.getList { [weak self] data, res in
            guard let self = self else { return }
            self.isFetching = false
            self.willRemoveloading?()
            if res.isSuccess {
                self.dataList = data ?? []
                self.willRefreshData?()
            } else {
                self.willShowMessage?(res)
            }
        }
    }
}
```

**Quy tắc ViewModel:**
- Kế thừa `BaseViewModel` — đã có sẵn: `isFetching`, `willRefreshData`, `willShowloading`, `willRemoveloading`, `willShowMessage`.
- Dùng `ViewModelListPresenter<T>` nếu cần pagination.
- Guard `!isFetching` trước khi fetch.
- Text cho UI dùng `XText("key")`.

---

### Bước 4A — VC dùng `BaseUIViewController` (List + Bottom Panel)

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
class {Feature}VC: BaseUIViewController {

    // MARK: - ViewController Config
    override var navBaseStype:     BaseUINavigationView.TYPE                        { .DEFAULT }
    override var navType:          TTBaseUIViewController<DarkBaseUIView>.NAV_STYLE { .STATUS_NAV }
    override var isSetHiddenTabar: Bool                                             { true }
    override var bgView:           UIColor                                          { .appBackgroundView }

    // MARK: - UI Components
    private let tblView:      TTBaseUITableView = TTBaseUITableView()   // ← TỰ khai báo
    private let bottomPanel:  TTBaseUIView      = TTBaseUIView()
    private let actionButton: TTBaseUIButton    = TTBaseUIButton(textString: "", type: .DEFAULT, isSetHeight: true)

    // MARK: - ViewModel
    private var viewModel: {Feature}ViewModel = {Feature}ViewModel()

    // MARK: - Constants
    private let rowHeight: CGFloat = 72

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewCodable(with: [self.tblView, self.bottomPanel])  // ← add cả 2 container
        self.viewModel.fetchData()
    }

    override func navDidTouchUpBackButton(withNavView nav: BaseUINavigationView) {
        self.pop()
    }
}
```

**TTViewCodable cho `BaseUIViewController`:**

```swift
// MARK: - TTViewCodable
extension {Feature}VC: TTViewCodable {

    // 1. Hierarchy
    func setupCustomView() {
        self.bottomPanel.addSubviews(views: [self.actionButton])
    }

    // 2. Constraints — TỰ layout tblView + bottomPanel
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
            .setLeadingAnchor(constant: 0).setTrailingAnchor(constant: 0)
            .setBottomAnchor(constant: 0).setHeightAnchor(constant: bottomH)

        self.actionButton
            .setLeadingAnchor(constant: XSize.LP()).setTrailingAnchor(constant: XSize.LP())
            .setTopAnchor(constant: XSize.SP()).setHeightAnchor(constant: XSize.H_BUTTON)
    }

    // 3. Styles
    func setupStyles() {
        self.bottomPanel.setBgColor(.white)
        self.bottomPanel.addShadow(
            shadowColor: UIColor.black.withAlphaComponent(0.08),
            offset: CGSize(width: 0, height: -2),
            shadowRadius: 6, cornerRadius: 0, shadowOpacity: 1)
        self.actionButton.setConerRadius(with: XSize.CORNER_RADIUS)
    }

    // 4. Interactions
    func bindComponents() {
        self.actionButton.onTouchHandler = { [weak self] _ in
            // Handle action
        }
    }

    // 5. Bind ViewModel
    func bindViewModel() {
        self.viewModel.willShowloading = { [weak self] in
            DispatchQueue.main.async {
                self?.showLoadingView(type: .NAV_BUTTOM, padding: XSize.getHeightNavWithStatus())
            }
        }
        self.viewModel.willRemoveloading = { [weak self] in
            DispatchQueue.main.async { self?.removeLoading() }
        }
        self.viewModel.willShowMessage = { [weak self] mess in
            let style: TTBaseNotificationViewConfig.NOTIFICATION_TYPE = mess.onCheckSuccess() ? .SUCCESS : .ERROR
            DispatchQueue.main.async { self?.showNoticeView(body: mess.getDes(), style: style) }
        }
        self.viewModel.willRefreshData = { [weak self] in
            DispatchQueue.main.async { self?.onRefreshUI() }
        }
    }

    // 6. Data tĩnh
    func setupData() {
        self.setTitleNav(XText("App.{Feature}.Title"))
        self.actionButton.setText(text: XText("App.Button.Save"))
    }

    // 7. Delegate / DataSource
    func setupBaseDelegate() {
        // ⚠️ TỰ set dataSource + delegate
        self.tblView.dataSource = self
        self.tblView.delegate   = self
        self.tblView.separatorStyle = .none
        self.tblView.resetContentInset()
        self.tblView.contentInset = UIEdgeInsets(
            top: XSize.SP(), left: 0,
            bottom: XSize.H_BUTTON + XSize.LP() * 3, right: 0)
        self.tblView.register({Feature}TableViewCell.self)
    }
}

// MARK: - Private helpers
private extension {Feature}VC {
    func onRefreshUI() {
        self.tblView.reloadData()
    }
}
```

---

### Bước 4B — VC dùng `BaseUITableViewController` (List đơn giản)

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
class {Feature}VC: BaseUITableViewController {

    // MARK: - Config
    // ⚠️ navType generic dùng TTBaseUIView (KHÔNG phải DarkBaseUIView)
    override var navBaseStype: BaseUINavigationView.TYPE                       { .DEFAULT }
    override var navType:      TTBaseUIViewController<TTBaseUIView>.NAV_STYLE  { .STATUS_NAV }
    override var isHidenTabar: Bool                                            { true }
    // ⚠️ Property tên là isHidenTabar (KHÔNG phải isSetHiddenTabar)

    // ── Pull-to-refresh ──
    override var isPullToRequest: Bool { true }

    // MARK: - UI Components (chỉ khai báo views PHỤ — tableView đã có sẵn)
    private let headerView: {Feature}HeaderView = {Feature}HeaderView()

    // MARK: - ViewModel
    private var viewModel: {Feature}ViewModel = {Feature}ViewModel()

    // MARK: - Constants
    private let rowHeight: CGFloat = 72

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewCodable(with: [])   // ← mảng rỗng, tableView đã add sẵn
        self.viewModel.fetchData()
    }

    override func navDidTouchUpBackButton(withNavView nav: BaseUINavigationView) {
        self.pop()
    }
}
```

**TTViewCodable cho `BaseUITableViewController`:**

```swift
// MARK: - TTViewCodable
extension {Feature}VC: TTViewCodable {

    func setupCustomView() {
        // KHÔNG cần add tableView — đã có sẵn
    }

    func setupConstraints() {
        // KHÔNG cần layout tableView — đã fills view tự động
    }

    func setupStyles() {
        // tableView style nếu cần
    }

    func bindComponents() {
        // Pull-to-refresh callback
        self.didPullToRequestDataHandle = { [weak self] in
            self?.viewModel.fetchData()
        }
    }

    // ⚠️ bindViewModel — GIỐNG BaseUIViewController
    func bindViewModel() {
        self.viewModel.willShowloading = { [weak self] in
            DispatchQueue.main.async {
                self?.showLoadingView(type: .NAV_BUTTOM, padding: XSize.getHeightNavWithStatus())
            }
        }
        self.viewModel.willRemoveloading = { [weak self] in
            DispatchQueue.main.async {
                self?.removeLoading()
                self?.refreshControl.endRefreshing()   // ← kết thúc pull-to-refresh
            }
        }
        self.viewModel.willShowMessage = { [weak self] mess in
            let style: TTBaseNotificationViewConfig.NOTIFICATION_TYPE = mess.onCheckSuccess() ? .SUCCESS : .ERROR
            DispatchQueue.main.async { self?.showNoticeView(body: mess.getDes(), style: style) }
        }
        self.viewModel.willRefreshData = { [weak self] in
            DispatchQueue.main.async { self?.onRefreshUI() }
        }
    }

    func setupData() {
        self.setTitleNav(XText("App.{Feature}.Title"))
        // Add header nếu cần:
        // self.addHeaderViewNew(with: self.headerView)
    }

    func setupBaseDelegate() {
        // ⚠️ delegate đã set sẵn bởi TTBaseUITableViewController
        // ⚠️ CHỈ cần set dataSource
        self.tableView.dataSource = self    // ← self.tableView, KHÔNG phải self.tblView
        self.tableView.register({Feature}TableViewCell.self)
    }
}

// MARK: - Private helpers
private extension {Feature}VC {
    func onRefreshUI() {
        self.tableView.reloadData()    // ← self.tableView
    }
}
```

---

### Bước 5 — Cell

```swift
/// ┌─ contentView ─────────────────────────────────────────┐
/// │  ┌─ panel (padding) ────────────────────────────────┐ │
/// │  │  ┌─ cardView (border · rounded) ───────────────┐ │ │
/// │  │  │  [iconView 40×40]  [titleLabel]  [rightIcon] │ │ │
/// │  │  │                    [subLabel]                 │ │ │
/// │  │  └──────────────────────────────────────────────┘ │ │
/// │  └───────────────────────────────────────────────────┘ │
/// └────────────────────────────────────────────────────────┘
class {Feature}TableViewCell: TTBaseUITableViewCell {

    override var padding: (CGFloat, CGFloat, CGFloat, CGFloat) { (XSize.LP(), XSize.SP() / 2, XSize.LP(), XSize.SP() / 2) }
    override var isSetBgSelected: Bool { false }

    private let cardView:   TTBaseUIView      = TTBaseUIView(withCornerRadius: XSize.CORNER_RADIUS)
    private let iconView:   TTBaseUIImageView = TTBaseUIImageView(imageName: "icon.default", contentMode: .scaleAspectFit)
    private let titleLabel: TTBaseUILabel     = TTBaseUILabel(withType: .TITLE, align: .left)
    private let subLabel:   TTBaseUILabel     = TTBaseUILabel(withType: .SUB_TITLE, align: .left)

    override func updateUI() {
        super.updateUI()
        self.setupViewCodable(with: [])
    }

    func configure(item: {Feature}Model) {
        self.titleLabel.setText(text: item.title ?? "").done()
        self.subLabel.setText(text: item.description ?? "").done()
    }
}

extension {Feature}TableViewCell: TTViewCodable {
    func setupCustomView() {
        self.panel.addSubview(self.cardView)
        self.cardView.addSubviews(views: [self.iconView, self.titleLabel, self.subLabel])
    }
    func setupConstraints() {
        self.cardView.setFullContraints(constant: 0)
        self.iconView
            .setLeadingAnchor(constant: XSize.LP()).setcenterYAnchor(constant: 0).setSquareSize(with: XSize.H_ICON)
        self.titleLabel
            .setLeadingWithNextToView(view: self.iconView, constant: XSize.SP())
            .setTopAnchor(constant: XSize.SP()).setTrailingAnchor(constant: XSize.LP())
        self.subLabel
            .setLeadingWithNextToView(view: self.iconView, constant: XSize.SP())
            .setTopAnchorWithAboveView(nextToView: self.titleLabel, constant: XSize.P_CONS_DEF / 2)
            .setTrailingAnchor(constant: XSize.LP()).setBottomAnchor(constant: XSize.SP())
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

### Bước 6 — UITableView DataSource / Delegate

```swift
// MARK: - UITableViewDataSource & UITableViewDelegate
extension {Feature}VC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.dataList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: {Feature}TableViewCell.self, indexPath: indexPath)
        let item = self.viewModel.dataList[indexPath.row]
        cell.configure(item: item)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.rowHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.viewModel.dataList[indexPath.row]
        // Navigate to detail
    }
}
```

> **Lưu ý:** Nếu dùng `BaseUITableViewController`, chỉ cần conform `UITableViewDataSource` (không cần `UITableViewDelegate` — đã conform sẵn).

---

### Bước 7 — Coordinator

```swift
// Coordinators/ScreenCoordinator.swift

// 1. Thêm case vào SCREEN_NAME
case .MY_NEW_FEATURE

// 2. Handle trong onCoordinatorHandle()
case .MY_NEW_FEATURE:
    let vc = {Feature}VC()
    currentVC?.push(vc)
```

---

## 4. Tóm Tắt Quy Tắc TTBaseUIKit

### UI Components

| Cần | Dùng | KHÔNG dùng |
|---|---|---|
| View | `TTBaseUIView` | `UIView` |
| Label | `TTBaseUILabel(withType:)` | `UILabel` |
| Button | `TTBaseUIButton(textString:, type:)` | `UIButton` |
| ImageView | `TTBaseUIImageView(imageName:)` | `UIImageView` |
| TableView | `TTBaseUITableView` | `UITableView` |
| Cell | kế thừa `TTBaseUITableViewCell` | `UITableViewCell` |
| StackView | `TTBaseUIStackView(axis:)` | `UIStackView` |
| ScrollView | `TTBaseScrollPanelView` | `UIScrollView` |

### Constraint API

| Method | Mô tả |
|---|---|
| `.setLeadingAnchor(constant:)` | Lề trái |
| `.setTrailingAnchor(constant:)` | Lề phải |
| `.setTopAnchor(constant:)` | Lề trên |
| `.setBottomAnchor(constant:)` | Lề dưới |
| `.setHeightAnchor(constant:)` / `.setWidthAnchor(constant:)` | Kích thước cố định |
| `.setSquareSize(with:)` | Width = Height |
| `.setFullContraints(constant:)` | Fill superview |
| `.setCenterXAnchor(constant:)` | Giữa X (**C** hoa) |
| `.setcenterYAnchor(constant:)` | Giữa Y (**c** thường) |
| `.setTopAnchorWithAboveView(nextToView:, constant:)` | Đặt dưới view khác |
| `.setBottomAnchorWithBelowView(view:, constant:)` | Đặt trên view khác |
| `.setLeadingWithNextToView(view:, constant:)` | Đặt bên phải view khác |

### Style & Assets

| Loại | Dùng |
|---|---|
| Colors | `UIColor.app*` / `UIColor.primary` |
| Fonts | `XFont.HEADER_H`, `XFont.TITLE_H`, `XFont.SUB_TITLE_H` |
| Sizes | `XSize.SP()`, `XSize.LP()`, `XSize.H_BUTTON`, `XSize.CORNER_RADIUS` |
| Strings | `XText("key")` |

---

## 5. Gotcha List

| # | ❌ Sai | ✅ Đúng |
|---|---|---|
| 1 | `override func updateUI()` trong TTBaseUIView | `override func updateBaseUIView()` |
| 2 | `.setcenterXAnchor(constant:)` | `.setCenterXAnchor(constant:)` |
| 3 | `.setTopAnchorWithAboveView(toView:)` | `nextToView:` |
| 4 | `label.setBoldTitle()` | `label.setBold()` |
| 5 | `NSLayoutConstraint.activate([...])` | Chainable API |
| 6 | `button.addTarget(self, action:)` | `button.onTouchHandler = { }` |
| 7 | Quên `DispatchQueue.main.async` khi update UI từ VM callback | Luôn dispatch main |
| 8 | Quên `[weak self]` trong closure | Luôn dùng `[weak self]` |
| 9 | Quên `self.` trong extension | Luôn dùng `self.` |
| 10 | `setupViewCodable(with: [subview])` trong CustomView | `setupViewCodable(with: [])` |
| 11 | Dùng `isSetHiddenTabar` trong `BaseUITableViewController` | `isHidenTabar` — tên property khác! |
| 12 | Dùng `self.tblView` trong `BaseUITableViewController` | `self.tableView` — property có sẵn |
| 13 | Add `tableView` vào `setupViewCodable` khi dùng `BaseUITableViewController` | `setupViewCodable(with: [])` — tableView đã add sẵn |
| 14 | `TTBaseUIViewController<DarkBaseUIView>.NAV_STYLE` trong `BaseUITableViewController` | `TTBaseUIViewController<TTBaseUIView>.NAV_STYLE` — generic type khác! |

---

## 6. Checklist

**Model & API**
- [ ] Struct `Codable`, field `var` + `Optional`
- [ ] API Singleton `share`, `RequestAPIDataItem` + `sendAsSynToCodable`
- [ ] Callback: `(_ obj: T?, _ res: ResponseMessage)`

**ViewModel**
- [ ] Kế thừa `BaseViewModel`
- [ ] Guard `!isFetching` trước khi fetch
- [ ] `willRefreshData` / `willShowMessage` gọi đúng chỗ
- [ ] Text dùng `XText("key")`

**ViewController (chung)**
- [ ] Đã chọn đúng base VC theo Decision Tree (mục 1.1)
- [ ] ASCII Layout Diagram trên `class`
- [ ] `setupViewCodable(with:)` trong `viewDidLoad()`
- [ ] TTViewCodable extension riêng, đúng thứ tự
- [ ] `self.` trong mọi extension
- [ ] KHÔNG có `NSLayoutConstraint.activate`
- [ ] `onTouchHandler` cho button, KHÔNG `addTarget`
- [ ] `[weak self]` + `DispatchQueue.main.async` trong mọi VM binding
- [ ] Không hardcode string/color/size/font

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
- [ ] Kết thúc refresh: `refreshControl.endRefreshing()` trong `willRemoveloading`
- [ ] Header: dùng `addHeaderViewNew(with:)`

**Cell**
- [ ] Kế thừa `TTBaseUITableViewCell`
- [ ] Override `padding` + `isSetBgSelected` nếu card layout
- [ ] `setupViewCodable(with: [])` trong `updateUI()` (KHÔNG trong `init`)

**Coordinator**
- [ ] Case mới trong `SCREEN_NAME`
- [ ] Handle trong `onCoordinatorHandle()`
