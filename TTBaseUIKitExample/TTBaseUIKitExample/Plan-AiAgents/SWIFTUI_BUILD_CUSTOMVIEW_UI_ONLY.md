# SwiftUI — Dựng Custom View (Reusable Sub-View)

> **Phạm vi:** Tạo MỘT custom SwiftUI view tái sử dụng. Dùng làm sub-view bên trong Screen, Row, hoặc Popup.  
> **Nền tảng:** SwiftUI, tuân thủ tuyệt đối TTBaseUIKit SwiftUI layer (`TTBaseSUI*`).

---

## 1. Kiến Trúc

```
SUIViews/CustomView/
└── SUI{ViewName}View.swift       # Reusable sub-view

Hoặc feature-specific:
SUIViews/Modules/{FeatureName}/CustomView/
└── {FeatureName}{ViewName}View.swift
```

Custom view SwiftUI = 1 struct conform `View`, build body bằng `TTBaseSUI*` components. KHÔNG cần `SUIBaseView` wrapper (đó chỉ dành cho screen-level).

---

## 2. Quy Trình Từng Bước

### Bước 1 — Xác định Input / Output

| Yếu tố | Mô tả |
|---|---|
| **Properties** | `let` cho data truyền vào (title, image name, isSelected...) |
| **Callbacks** | Closure optional cho interaction (`var onTap: (() -> Void)? = nil`) |
| **Không có** | `@StateObject`, `@ObservedObject` — custom view KHÔNG hold ViewModel |

---

### Bước 2 — Tạo View

```swift
import SwiftUI
import TTBaseUIKit

struct SUICardView: View {

    // MARK: - Properties
    let iconName: String
    let title: String
    let subtitle: String
    var isSelected: Bool = false
    var onTap: (() -> Void)? = nil

    // MARK: - Body
    var body: some View {
        TTBaseSUIView(withCornerRadius: XSize.CORNER_RADIUS, bg: .white) {
            TTBaseSUIHStack(alignment: .center, spacing: XSize.P_CONS_DEF) {

                // Icon
                TTBaseSUIImage(withname: self.iconName, contentMode: .fit)
                    .setIcon(color: self.isSelected
                        ? XView.buttonBgDef.toColor()
                        : XView.iconColor.toColor())
                    .sizeSquare(width: XSize.H_SMALL_ICON)

                // Text content
                TTBaseSUIVStack(alignment: .leading, spacing: XSize.P_CONS_DEF / 2) {
                    TTBaseSUIText(
                        withBold: .TITLE,
                        text: self.title,
                        align: .leading,
                        color: self.isSelected
                            ? XView.buttonBgDef.toColor()
                            : XView.textTitleColor.toColor())
                    TTBaseSUIText(
                        withType: .SUB_TITLE,
                        text: self.subtitle,
                        align: .leading,
                        color: XView.textSubTitleColor.toColor())
                        .lineLimit(2)
                }
                .maxWidth(alignment: .leading)

                // Right indicator
                TTBaseSUIImage(withname: "icon_arrowRight", contentMode: .fit)
                    .setIcon(color: XView.iconColor.toColor())
                    .size(width: XSize.H_SMALL_SMALL_ICON, height: XSize.H_SMALL_SMALL_ICON)
            }
            .padding(XSize.getPadding())
        }
        .setBorder(
            WithRadius: XSize.CORNER_RADIUS,
            color: self.isSelected ? XView.buttonBgDef.toColor() : Color(XView.lineDefColor),
            lineWidth: self.isSelected ? 1.5 : 1)
        .onTapHandle { self.onTap?() }
    }
}
```

---

### Bước 3 — Sử dụng trong Screen

```swift
// Trong {FeatureName}SUIView:
ForEach(0..<items.count, id: \.self) { index in
    SUICardView(
        iconName: "icon.item",
        title: items[index].title ?? "",
        subtitle: items[index].description ?? "",
        isSelected: self.selectedIndex == index,
        onTap: { self.selectedIndex = index }
    )
}
```

---

## 3. Patterns Thường Gặp

### 3a. Icon + Label Row

```swift
struct SUIIconLabelView: View {
    let iconName: String
    let text: String
    var iconColor: Color = XView.buttonBgDef.toColor()

    var body: some View {
        TTBaseSUIHStack(alignment: .center, spacing: XSize.P_CONS_DEF) {
            TTBaseSUIImage(withname: self.iconName, contentMode: .fit)
                .setIcon(color: self.iconColor)
                .sizeSquare(width: 20)
            TTBaseSUIText(withType: .TITLE, text: self.text,
                         align: .leading, color: XView.textDefColor.toColor())
                .maxWidth(alignment: .leading)
        }
    }
}
```

### 3b. Empty State View

```swift
struct SUIEmptyStateView: View {
    var iconName: String = "icon.noData"
    var message: String = XText("App.NoData")

    var body: some View {
        TTBaseSUIVStack(alignment: .center, spacing: XSize.getPadding()) {
            TTBaseSUIImage(withname: self.iconName, contentMode: .fit)
                .sizeSquare(width: XSize.H_CELL * 2)
            TTBaseSUIText(withType: .TITLE, text: self.message,
                         align: .center, color: XView.textSubTitleColor.toColor())
        }
        .maxWidth()
        .maxHeight()
    }
}
```

### 3c. Section Header

```swift
struct SUISectionHeaderView: View {
    let title: String

    var body: some View {
        TTBaseSUIText(withBold: .HEADER, text: self.title,
                     align: .leading, color: XView.textTitleColor.toColor())
            .maxWidth(alignment: .leading)
            .padding([.leading, .trailing], XSize.getPadding())
            .padding(.top, XSize.getPadding())
            .padding(.bottom, XSize.P_CONS_DEF)
    }
}
```

---

## 4. Components — Chỉ dùng TTBaseSUI*

| Cần | Dùng | KHÔNG dùng |
|---|---|---|
| Container | `TTBaseSUIView(withCornerRadius:bg:)` | Raw view |
| Text | `TTBaseSUIText(withType:)` / `TTBaseSUIText(withBold:)` | `Text()` |
| Image | `TTBaseSUIImage(withname:)` | `Image()` |
| VStack | `TTBaseSUIVStack(alignment:spacing:)` | `VStack` |
| HStack | `TTBaseSUIHStack(alignment:spacing:)` | `HStack` |
| Spacer | `TTBaseSUISpacer()` | `Spacer()` |
| Divider | `TTBaseSUIHorizontalDividerView(noConner:)` | `Divider()` |

---

## 5. Style & Assets — KHÔNG hardcode

| Loại | Dùng |
|---|---|
| Colors | `XView.buttonBgDef.toColor()`, `XView.textDefColor.toColor()` |
| Sizes | `XSize.P_CONS_DEF`, `XSize.getPadding()`, `XSize.H_SMALL_ICON` |
| Strings | `XText("key")` |
| Fonts | `TTBaseSUIText` TYPE tự set — không `.font()` thủ công |

---

## 6. Gotcha List

| # | ❌ Sai | ✅ Đúng |
|---|---|---|
| 1 | `Text("label")` | `TTBaseSUIText(withType: .TITLE, text: "label")` |
| 2 | `Image("icon")` | `TTBaseSUIImage(withname: "icon")` |
| 3 | `VStack { }` | `TTBaseSUIVStack { }` |
| 4 | `Color.blue` | `XView.buttonBgDef.toColor()` |
| 5 | `.padding(16)` | `.padding(XSize.getPadding())` |
| 6 | `"Hardcoded"` | `XText("App.Key")` |
| 7 | `.font(.system(size: 14))` | Dùng `TTBaseSUIText` TYPE |
| 8 | Quên `.maxWidth(alignment: .leading)` | Text block cần fill width |

---

## 7. Checklist

- [ ] File đặt đúng: `SUIViews/CustomView/` hoặc `Modules/{Feature}/CustomView/`
- [ ] KHÔNG wrap bằng `SUIBaseView` (đó là cho screen-level)
- [ ] Tất cả subviews dùng `TTBaseSUI*` — KHÔNG có `Text`/`Image`/`VStack` native
- [ ] Properties dùng `let` cho data, `var` cho optional callback
- [ ] KHÔNG có `@StateObject` / `@ObservedObject` — custom view không hold ViewModel
- [ ] Colors dùng `XView.*.toColor()`, sizes dùng `XSize.*`, strings dùng `XText()`
- [ ] Có Preview struct phía dưới
