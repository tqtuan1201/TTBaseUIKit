# SwiftUI — Dựng UI Tính Năng Mới (UI ONLY)

> **Phạm vi:** Chỉ dựng giao diện SwiftUI (Screen View + Sub Views). KHÔNG bao gồm API, ViewModel logic, Coordinator.  
> **Nền tảng:** SwiftUI, tuân thủ tuyệt đối TTBaseUIKit SwiftUI layer (`TTBaseSUI*`).

---

## 1. Cấu Trúc Thư Mục

```
SUIViews/Modules/{FeatureName}/
├── {FeatureName}SUIView.swift            # Screen chính (wrap SUIBaseView)
└── SubViews/
    ├── {FeatureName}RowView.swift         # Row/item view
    └── {FeatureName}HeaderView.swift      # Header view (nếu có)
```

---

## 2. Quy Trình Từng Bước

### Bước 1 — Chọn loại màn hình

| Loại | Base View | Khi nào |
|---|---|---|
| Màn hình standard | `SUIBaseView` type `.DEFAULT` | Có back + title + content |
| Popup / Bottom sheet | `TTBaseSUIZStack` overlay | Không cần nav bar |
| View con (nested) | Không cần `SUIBaseView` | Compose vào screen cha |

---

### Bước 2 — Tạo Screen View

```swift
import SwiftUI
import TTBaseUIKit

// MARK: - Main View
struct {FeatureName}SUIView: View {

    // MARK: - State (UI state only — no ViewModel)
    @State private var selectedIndex: Int? = nil

    // MARK: - Body
    var body: some View {
        SUIBaseView(
            backType: .POP,
            title: XText("App.{FeatureName}.Title"),
            type: .DEFAULT,
            isHiddenTabbar: true
        ) {
            self.bodyContent()
        }
    }
}

// MARK: - Body Content
extension {FeatureName}SUIView {

    @ViewBuilder
    private func bodyContent() -> some View {
        TTBaseSUIVStack(alignment: .leading, spacing: XSize.P_CONS_DEF,
                        bg: Color(XView.viewBgColor)) {
            self.listContent()
        }
        .maxWidth()
        .maxHeight()
    }
}

// MARK: - Sub Views
extension {FeatureName}SUIView {

    @ViewBuilder
    private func listContent() -> some View {
        TTBaseSUIScroll(alignment: .vertical) {
            TTBaseSUILazyVStack(alignment: .leading, spacing: XSize.P_CONS_DEF) {
                ForEach(0..<10, id: \.self) { index in
                    {FeatureName}RowView(
                        title: "Item \(index)",
                        sub: "Description",
                        isSelected: self.selectedIndex == index
                    )
                    .onTapHandle {
                        self.selectedIndex = index
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
}

// MARK: - Preview
struct {FeatureName}SUIView_Previews: PreviewProvider {
    static var previews: some View {
        {FeatureName}SUIView()
    }
}
```

---

### Bước 3 — Tạo Row / Item View

```swift
import SwiftUI
import TTBaseUIKit

struct {FeatureName}RowView: View {

    // MARK: - Properties
    let title: String
    let sub: String
    var isSelected: Bool = false

    // MARK: - Body
    var body: some View {
        TTBaseSUIView(withCornerRadius: XSize.CORNER_RADIUS, bg: .white) {
            TTBaseSUIHStack(alignment: .center, spacing: XSize.P_CONS_DEF) {
                // Icon
                TTBaseSUIImage(withname: "icon.default", contentMode: .fit)
                    .setIcon(color: XView.buttonBgDef.toColor())
                    .sizeSquare(width: XSize.H_SMALL_ICON)

                // Text
                TTBaseSUIVStack(alignment: .leading, spacing: XSize.P_CONS_DEF / 2) {
                    TTBaseSUIText(withBold: .TITLE, text: self.title,
                                 align: .leading, color: XView.textTitleColor.toColor())
                    TTBaseSUIText(withType: .SUB_TITLE, text: self.sub,
                                 align: .leading, color: XView.textSubTitleColor.toColor())
                        .lineLimit(2)
                }
                .maxWidth(alignment: .leading)

                // Right arrow
                TTBaseSUIImage(withname: "icon_arrowRight", contentMode: .fit)
                    .setIcon(color: XView.iconColor.toColor())
                    .size(width: XSize.H_SMALL_SMALL_ICON, height: XSize.H_SMALL_SMALL_ICON)
            }
            .padding(XSize.getPadding())
        }
        .setBorder(WithRadius: XSize.CORNER_RADIUS,
                   color: self.isSelected ? XView.buttonBgDef.toColor() : Color(XView.lineDefColor),
                   lineWidth: self.isSelected ? 1.5 : 1)
    }
}
```

---

### Bước 4 — Popup / Bottom Sheet (nếu cần)

```swift
import SwiftUI
import TTBaseUIKit

struct {FeatureName}PopupSUIView: View {

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        TTBaseSUIZStack(alignment: .bottom, bg: Color.clear) {
            Color.clear.onTapHandle { self.onClose() }
            TTBaseSUIVStack(alignment: .center, spacing: XSize.getPadding(), bg: .white) {
                // Header
                TTBaseSUIHStack(alignment: .top, spacing: XSize.getPadding(), bg: .clear) {
                    TTBaseSUISpacer(maxHeight: 1).layoutPriority(0)
                    TTBaseSUIText(withBold: .TITLE, text: XText("App.Popup.Title"),
                                 align: .center, color: XView.textDefColor.toColor())
                        .padding(.leading, XSize.H_SMALL_ICON + XSize.P_CONS_DEF)
                        .layoutPriority(1)
                    TTBaseSUISpacer(maxHeight: 1).layoutPriority(0)
                    TTBaseSUIImage(withname: "close1", contentMode: .fit)
                        .sizeSquare(width: XSize.H_SMALL_ICON - XSize.P_CONS_DEF)
                        .padding(.trailing, XSize.getPadding())
                        .onTapHandle { self.onClose() }
                }.padding(.top, XSize.getPadding())

                // Content
                TTBaseSUIVStack(alignment: .leading, spacing: XSize.P_CONS_DEF, bg: .clear) {
                    // ... nội dung
                }
                .padding([.leading, .trailing], XSize.getPadding())
                .padding(.bottom, XSize.getPadding() * 2)
            }.clipShape(RoundedTopCorners(radius: 20))
        }
    }

    func onClose() {
        DispatchQueue.main.async { self.presentationMode.wrappedValue.dismiss() }
    }
}
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

| Loại | Dùng | Ví dụ |
|---|---|---|
| Colors | `XView.*.toColor()` | `XView.buttonBgDef.toColor()`, `XView.textDefColor.toColor()` |
| Sizes | `XSize.*` | `XSize.P_CONS_DEF`, `XSize.getPadding()`, `XSize.H_BUTTON` |
| Strings | `XText("key")` | `XText("App.{FeatureName}.Title")` |
| Fonts | `TTBaseSUIText` TYPE tự set | `.HEADER_SUPER`, `.HEADER`, `.TITLE`, `.SUB_TITLE` |

---

## 5. View Modifiers — Tham chiếu nhanh

| Modifier | Mô tả |
|---|---|
| `.maxWidth(alignment:)` | Fill width |
| `.maxHeight(alignment:)` | Fill height |
| `.sizeSquare(width:)` | Square frame |
| `.size(width:height:)` | Fixed frame |
| `.onTapHandle { }` | Tap gesture |
| `.skeleton(active:)` | Skeleton loading |
| `.hidden(bool)` | Conditional hide |
| `.setBorder(WithRadius:color:lineWidth:)` | Border overlay |
| `.clipShape(RoundedTopCorners(radius:))` | Clip top corners |

---

## 6. Gotcha List

| # | ❌ Sai | ✅ Đúng |
|---|---|---|
| 1 | `Text("Hello")` | `TTBaseSUIText(withType: .TITLE, text: "Hello")` |
| 2 | `Button("Tap") { }` | `TTBaseSUIButton(type: .DEFAULT, title: "Tap") { }` |
| 3 | `VStack { }` | `TTBaseSUIVStack { }` |
| 4 | `HStack { }` | `TTBaseSUIHStack { }` |
| 5 | `ScrollView { }` | `TTBaseSUIScroll { }` |
| 6 | `Color.blue` cho primary | `XView.buttonBgDef.toColor()` |
| 7 | `.padding(16)` | `.padding(XSize.getPadding())` |
| 8 | `"Hard coded string"` | `XText("App.Key")` |
| 9 | `Divider()` | `TTBaseSUIHorizontalDividerView(noConner: .LINE)` |
| 10 | `Image("name")` | `TTBaseSUIImage(withname: "name")` |
| 11 | Quên `.maxWidth()` cho text | `.maxWidth(alignment: .leading)` |
| 12 | Present popup bằng `.sheet { }` | `embeddedInHostingController` + `presentDef` |

---

## 7. Checklist

- [ ] Screen view wrap bằng `SUIBaseView`
- [ ] MARK sections: State → Body → Sub Views → Actions → Preview
- [ ] KHÔNG có `Text` / `Button` / `VStack` / `HStack` / `ZStack` / `ScrollView` / `Image` / `Divider` / `Spacer` native
- [ ] KHÔNG có hardcode string — dùng `XText("key")`
- [ ] KHÔNG có hardcode color — dùng `XView.*.toColor()`
- [ ] KHÔNG có hardcode size — dùng `XSize.*`
- [ ] Popup dùng `TTBaseSUIZStack` overlay, `RoundedTopCorners`, tap-to-dismiss
- [ ] Mọi tap dùng `.onTapHandle { }`, KHÔNG dùng `.onTapGesture { }`
