# SwiftUI — Dựng Toàn Bộ Tính Năng Mới (UI + API + ViewModel + Flow)

> **Phạm vi:** Dựng TOÀN BỘ một tính năng mới từ A→Z bằng SwiftUI: Model, API (dùng chung), ViewModel (ObservableObject), Screen View, Sub Views, Bridge UIKit, Coordinator.  
> **Nền tảng:** SwiftUI, tuân thủ tuyệt đối TTBaseUIKit SwiftUI layer (`TTBaseSUI*`).

---

## 1. Cấu Trúc Thư Mục

```
Model/
└── {Feature}Model.swift                       # Codable struct (dùng chung)
API/
└── {Feature}API.swift                          # Singleton API (dùng chung)

SUIViews/Modules/{Feature}/
├── {Feature}SUIView.swift                      # Screen chính
├── ViewModel/
│   └── {Feature}SUIViewModel.swift             # ObservableObject
├── SubViews/
│   ├── {Feature}RowView.swift
│   └── {Feature}HeaderView.swift
└── CustomView/                                  # Feature-specific views
    └── ...
```

---

## 2. Quy Trình Từng Bước

### Bước 1 — Data Model

```swift
// Model/{Feature}Model.swift
struct {Feature}Model: Codable, Identifiable {
    var id:          String?
    var title:       String?
    var description: String?
}
```

> `Identifiable` bắt buộc nếu model dùng trong `ForEach`.

---

### Bước 2 — API Service (dùng chung UIKit pattern)

```swift
// API/{Feature}API.swift
import Foundation

class {Feature}API {
    static let share = {Feature}API()
    fileprivate init() {}
    fileprivate let API: RequestAPI = RequestAPI()
}

extension {Feature}API {

    func getList(callback: @escaping (_ obj: [{Feature}Model]?, _ res: ResponseMessage) -> Void) {
        var item = RequestAPIDataItem(
            service: .NONE, platform: .SERVER, serviceType: .NONE,
            dataRequest: RequestData(), httpMethod: .GET, isAuthorization: true)
        item.param = "/feature-endpoint/"
        API.sendAsSynToCodable(item) { (res: BaseResponse<{Feature}Model>?, msg) in
            callback(res?.data, msg)
        }
    }
}
```

> API layer dùng chung giữa UIKit và SwiftUI — KHÔNG duplicate.

---

### Bước 3 — ViewModel (ObservableObject)

```swift
// SUIViews/Modules/{Feature}/ViewModel/{Feature}SUIViewModel.swift
import Foundation
import TTBaseUIKit
import Combine

class {Feature}SUIViewModel: ObservableObject {

    // MARK: - Published State
    @Published var dataList: [{Feature}Model] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    // MARK: - Private
    private var isFetching: Bool = false

    // MARK: - Computed
    var isEmpty: Bool { self.dataList.isEmpty && !self.isLoading }

    // MARK: - Actions
    func fetchData() {
        guard !self.isFetching else { return }
        self.isFetching = true
        self.isLoading = true

        {Feature}API.share.getList { [weak self] data, res in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isFetching = false
                self.isLoading = false
                if res.isSuccess {
                    self.dataList = data ?? []
                } else {
                    self.errorMessage = res.getDes()
                }
            }
        }
    }
}
```

**Quy tắc ViewModel SwiftUI:**

| Quy tắc | Chi tiết |
|---|---|
| Pattern | `ObservableObject` + `@Published` |
| Khởi tạo trong View | `@StateObject` |
| Truyền từ ngoài | `@ObservedObject` |
| Thread | Mọi update `@Published` phải trên `DispatchQueue.main` |
| Memory | `[weak self]` trong mọi closure |
| API | Dùng chung class với UIKit — KHÔNG duplicate |

---

### Bước 4 — Screen View

```swift
// SUIViews/Modules/{Feature}/{Feature}SUIView.swift
import SwiftUI
import TTBaseUIKit

// MARK: - Main View
struct {Feature}SUIView: View {

    @StateObject private var viewModel = {Feature}SUIViewModel()

    var body: some View {
        SUIBaseView(
            backType: .POP,
            title: XText("App.{Feature}.Title"),
            type: .DEFAULT,
            isHiddenTabbar: true
        ) {
            self.bodyContent()
        }
    }
}

// MARK: - Body Content
extension {Feature}SUIView {

    @ViewBuilder
    private func bodyContent() -> some View {
        TTBaseSUIVStack(alignment: .leading, spacing: XSize.P_CONS_DEF,
                        bg: Color(XView.viewBgColor)) {
            if self.viewModel.isLoading {
                self.skeletonContent()
            } else if self.viewModel.isEmpty {
                self.emptyContent()
            } else {
                self.listContent()
            }
        }
        .maxWidth()
        .maxHeight()
        .onAppear {
            self.viewModel.fetchData()
        }
    }
}

// MARK: - Sub Views
extension {Feature}SUIView {

    @ViewBuilder
    private func listContent() -> some View {
        TTBaseSUIScroll(alignment: .vertical) {
            TTBaseSUILazyVStack(alignment: .leading, spacing: XSize.P_CONS_DEF) {
                ForEach(self.viewModel.dataList) { item in
                    {Feature}RowView(item: item)
                        .onTapHandle {
                            self.onSelectItem(item)
                        }
                }
            }
            .padding([.leading, .trailing], XSize.getPadding())
            .padding(.top, XSize.P_CONS_DEF)
        }
    }

    @ViewBuilder
    private func emptyContent() -> some View {
        TTBaseSUIVStack(alignment: .center, spacing: XSize.getPadding()) {
            TTBaseSUIImage(withname: "icon.noData", contentMode: .fit)
                .sizeSquare(width: XSize.H_CELL * 2)
            TTBaseSUIText(withType: .TITLE, text: XText("App.NoData"),
                         align: .center, color: XView.textSubTitleColor.toColor())
        }
        .maxWidth()
        .maxHeight()
    }

    @ViewBuilder
    private func skeletonContent() -> some View {
        TTBaseSUIVStack(alignment: .leading, spacing: XSize.P_CONS_DEF) {
            ForEach(0..<5, id: \.self) { _ in
                TTBaseSUIView(withCornerRadius: XSize.CORNER_RADIUS, bg: .white) {
                    TTBaseSUIVStack(alignment: .leading, spacing: XSize.P_CONS_DEF) {
                        TTBaseSUIText(withType: .TITLE, text: "Placeholder text loading")
                        TTBaseSUIText(withType: .SUB_TITLE, text: "Sub placeholder")
                    }.padding(XSize.getPadding())
                }
                .skeleton(active: true)
            }
        }
        .padding([.leading, .trailing], XSize.getPadding())
        .padding(.top, XSize.P_CONS_DEF)
    }
}

// MARK: - Actions
extension {Feature}SUIView {
    private func onSelectItem(_ item: {Feature}Model) {
        // Navigate to detail or handle selection
    }
}

// MARK: - Preview
struct {Feature}SUIView_Previews: PreviewProvider {
    static var previews: some View {
        {Feature}SUIView()
    }
}
```

---

### Bước 5 — Row View

```swift
// SUIViews/Modules/{Feature}/SubViews/{Feature}RowView.swift
import SwiftUI
import TTBaseUIKit

struct {Feature}RowView: View {

    let item: {Feature}Model

    var body: some View {
        TTBaseSUIView(withCornerRadius: XSize.CORNER_RADIUS, bg: .white) {
            TTBaseSUIHStack(alignment: .center, spacing: XSize.P_CONS_DEF) {
                TTBaseSUIImage(withname: "icon.default", contentMode: .fit)
                    .setIcon(color: XView.buttonBgDef.toColor())
                    .sizeSquare(width: XSize.H_SMALL_ICON)

                TTBaseSUIVStack(alignment: .leading, spacing: XSize.P_CONS_DEF / 2) {
                    TTBaseSUIText(withBold: .TITLE, text: self.item.title ?? "",
                                 align: .leading, color: XView.textTitleColor.toColor())
                    TTBaseSUIText(withType: .SUB_TITLE, text: self.item.description ?? "",
                                 align: .leading, color: XView.textSubTitleColor.toColor())
                        .lineLimit(2)
                }
                .maxWidth(alignment: .leading)

                TTBaseSUIImage(withname: "icon_arrowRight", contentMode: .fit)
                    .setIcon(color: XView.iconColor.toColor())
                    .size(width: XSize.H_SMALL_SMALL_ICON, height: XSize.H_SMALL_SMALL_ICON)
            }
            .padding(XSize.getPadding())
        }
    }
}
```

---

### Bước 6 — Bridge UIKit (Push / Present)

#### Push từ UIKit Coordinator:
```swift
let suiView = {Feature}SUIView()
let hostingVC = suiView.embeddedInHostingController(isHiddenTabbar: true)
currentVC?.push(hostingVC)
```

#### Present popup:
```swift
let popup = {Feature}PopupSUIView()
let hostingVC = popup.embeddedInHostingController(isHiddenTabbar: false)
hostingVC.view.backgroundColor = UIColor.clear
UIApplication.topViewController()?.presentDef(
    vc: hostingVC, type: .overCurrentContext,
    transitionStyle: .coverVertical, isAnimation: true)
DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
    UIView.animate(withDuration: 0.3) {
        hostingVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
}
```

#### Truy cập UIKit VC từ SwiftUI:
```swift
@EnvironmentObject var hostingProvider: ViewControllerProvider
// Pop:
self.hostingProvider.getCurrentVC()?.pop()
// Push UIKit VC:
self.hostingProvider.getCurrentVC()?.push(someUIKitVC)
```

> `ViewControllerProvider` được inject tự động bởi `embeddedInHostingController()`.

---

### Bước 7 — Coordinator

```swift
// Coordinators/ScreenCoordinator.swift

// 1. Thêm case
case .MY_SWIFTUI_FEATURE

// 2. Handle
case .MY_SWIFTUI_FEATURE:
    let suiView = {Feature}SUIView()
    let hostingVC = suiView.embeddedInHostingController(isHiddenTabbar: true)
    currentVC?.push(hostingVC)
```

---

## 3. Components — Chỉ dùng TTBaseSUI*

| Cần | Dùng | KHÔNG dùng |
|---|---|---|
| Container | `TTBaseSUIView` | Raw `View` |
| Text | `TTBaseSUIText(withType:)` | `Text()` |
| Button | `TTBaseSUIButton(type:)` | `Button()` |
| Image | `TTBaseSUIImage(withname:)` | `Image()` |
| VStack | `TTBaseSUIVStack` | `VStack` |
| HStack | `TTBaseSUIHStack` | `HStack` |
| ZStack | `TTBaseSUIZStack` | `ZStack` |
| ScrollView | `TTBaseSUIScroll` | `ScrollView` |
| LazyVStack | `TTBaseSUILazyVStack` | `LazyVStack` |
| Spacer | `TTBaseSUISpacer` | `Spacer()` |
| Divider | `TTBaseSUIHorizontalDividerView` | `Divider()` |

---

## 4. Style & Assets — KHÔNG hardcode

| Loại | Dùng |
|---|---|
| Colors | `XView.*.toColor()` |
| Sizes | `XSize.P_CONS_DEF`, `XSize.getPadding()`, `XSize.H_BUTTON` |
| Strings | `XText("key")` |
| Fonts | `TTBaseSUIText` TYPE tự set |

---

## 5. Gotcha List

| # | ❌ Sai | ✅ Đúng |
|---|---|---|
| 1 | `Text("Hello")` | `TTBaseSUIText(withType: .TITLE, text: "Hello")` |
| 2 | `Button("Tap") { }` | `TTBaseSUIButton(type: .DEFAULT, title: "Tap") { }` |
| 3 | `VStack { }` / `HStack { }` | `TTBaseSUIVStack { }` / `TTBaseSUIHStack { }` |
| 4 | `Color.blue` | `XView.buttonBgDef.toColor()` |
| 5 | `.padding(16)` | `.padding(XSize.getPadding())` |
| 6 | `"Hard coded"` | `XText("App.Key")` |
| 7 | `@ObservedObject var vm = VM()` | `@StateObject var vm = VM()` khi tạo mới |
| 8 | Quên `DispatchQueue.main.async` | Luôn dispatch main khi update `@Published` |
| 9 | `Divider()` | `TTBaseSUIHorizontalDividerView(noConner: .LINE)` |
| 10 | `Image("name")` | `TTBaseSUIImage(withname: "name")` |
| 11 | Present popup bằng `.sheet { }` | `embeddedInHostingController` + `presentDef` |
| 12 | Quên `[weak self]` | Luôn dùng trong closure capture |

---

## 6. Checklist

**Model & API**
- [ ] Struct `Codable` + `Identifiable`, field `var` + `Optional`
- [ ] API Singleton `share`, `RequestAPIDataItem` + `sendAsSynToCodable`
- [ ] API layer dùng chung — không duplicate

**ViewModel**
- [ ] `ObservableObject` + `@Published`
- [ ] Khởi tạo bằng `@StateObject` trong View
- [ ] Guard `!isFetching` trước fetch
- [ ] `DispatchQueue.main.async` khi update `@Published`
- [ ] `[weak self]` trong mọi closure
- [ ] Text dùng `XText("key")`

**Screen View**
- [ ] Wrap bằng `SUIBaseView`
- [ ] MARK sections: State → Body → Sub Views → Actions → Preview
- [ ] Loading state (`.skeleton(active:)`)
- [ ] Empty state khi data rỗng
- [ ] `.onAppear { viewModel.fetchData() }`

**Components**
- [ ] KHÔNG có `Text` / `Button` / `VStack` / `HStack` / `ZStack` / `ScrollView` / `Image` / `Divider` / `Spacer` native
- [ ] KHÔNG có hardcode string/color/size
- [ ] Tap dùng `.onTapHandle { }`

**Bridge & Coordinator**
- [ ] Push qua `embeddedInHostingController()`
- [ ] Case mới trong `SCREEN_NAME`
- [ ] Handle trong `onCoordinatorHandle()`
- [ ] `ViewControllerProvider` khi cần access UIKit VC
