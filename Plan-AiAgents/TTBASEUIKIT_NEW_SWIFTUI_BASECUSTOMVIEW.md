# TTBaseUIKit — Tạo Custom View Từ SwiftUI

> **Phạm vi:** Tạo một **Custom View SwiftUI tái sử dụng** ở app-level hoặc feature-level.  
> Custom View được compose hoàn toàn từ `TTBaseSUI*` primitives — KHÔNG dùng native SwiftUI `Text`, `VStack`, `HStack`, `Image`, `Button`, `Divider`, `Spacer` trực tiếp.  
> Custom View **KHÔNG hold ViewModel**, **KHÔNG wrap bằng `SUIBaseView`** (đó là cho screen-level).  
> **Nền tảng:** SwiftUI, tuân thủ tuyệt đối TTBaseUIKit SwiftUI layer.

---

## 1. Phân Biệt Custom View vs BaseView vs Screen View

| Loại | Nơi tạo | Mục đích | Hold ViewModel? | Wrap SUIBaseView? |
|---|---|---|---|---|
| **BaseView** (`TTBaseSUI*`) | `SwiftUIView/BaseViews/` | Primitive tái sử dụng trong **thư viện** | ❌ | ❌ |
| **Custom View** (plan này) | `SUIViews/CustomView/` hoặc `Modules/{Feature}/CustomView/` | UI component tái sử dụng ở **app-level** | ❌ | ❌ |
| **Screen View** | `SUIViews/Modules/{Feature}/` | Màn hình đầy đủ | ✅ (`@StateObject`) | ✅ |

> Nếu bạn đang tạo một **màn hình đầy đủ** → dùng plan `SWIFTUI_BUILD_FUTURE_UI_ONLY` hoặc `SWIFTUI_BUILD_FULL_NEW_FUTURE`.  
> Nếu bạn đang tạo một **primitive base** cho thư viện → dùng plan `TTBASEUIKIT_NEW_SWIFTUI_BASEVIEW`.

---

## 2. Cấu Trúc File

```
SUIViews/CustomView/
└── SUI{ViewName}View.swift               # Custom view dùng chung toàn app

Hoặc feature-specific:
SUIViews/Modules/{FeatureName}/CustomView/
└── {FeatureName}{ViewName}View.swift     # Custom view dùng riêng cho feature
```

**Naming convention:**
- File: `SUI{ViewName}View.swift` (prefix `SUI`, không phải `TTBaseSUI`)
- Struct: `SUI{ViewName}View` (nhất quán với tên file)
- `internal` access modifier (mặc định) — chỉ `public` nếu share giữa module

---

## 3. Quy Trình Từng Bước

### Bước 1 — Xác Định Input / Output

Trước khi viết code, liệt kê rõ ràng:

| Yếu tố | Loại khai báo | Mô tả |
|---|---|---|
| **Data bất biến** | `let` | Title, image name, model data |
| **State nội bộ** | `@State private var` | Toggle, expand, animation trigger |
| **Data có thể thay đổi từ ngoài** | `var` với default | isSelected, isLoading |
| **Callbacks** | `var on{Action}: (() -> Void)? = nil` | onTap, onSelect, onDelete |
| **KHÔNG có** | `@StateObject`, `@ObservedObject` | Custom view không hold ViewModel |

---

### Bước 2 — Vẽ ASCII Layout Diagram

**Bắt buộc** đặt ngay trên khai báo `struct` dưới dạng doc comment:

```swift
/// ┌─ SUI{ViewName}View ─────────────────────────────────────────────┐
/// │  P_S (top/bottom)                                               │
/// │  ┌─ HStack ─────────────────────────────────────────────────┐   │
/// │  │  ┌─ icon (H_SMALL_ICON × H_SMALL_ICON) ─┐  SP           │   │
/// │  │  │                                        │               │   │
/// │  │  └────────────────────────────────────────┘               │   │
/// │  │  ┌─ VStack (.leading) ─────────────────────┐              │   │
/// │  │  │  titleLabel (TITLE, bold)                │              │   │
/// │  │  │  subLabel (SUB_TITLE)                    │              │   │
/// │  │  └─────────────────────────────────────────┘  maxWidth    │   │
/// │  │  ┌─ arrowIcon (H_SMALL_SMALL_ICON) ──────┐                │   │
/// │  │  └────────────────────────────────────────┘                │   │
/// │  └──────────────────────────────────────────────────────────┘   │
/// │  P_S (leading/trailing)                                         │
/// └─────────────────────────────────────────────────────────────────┘
```

> Diagram giúp AI và developer hiểu layout trước khi đọc code. Không được bỏ qua bước này.

---

### Bước 3 — Khai Báo Struct

```swift
import SwiftUI
import TTBaseUIKit

/// ASCII Diagram ở đây (xem Bước 2)

struct SUI{ViewName}View: View {

    // MARK: - Properties (Data Input)
    let iconName: String
    let title: String
    let subtitle: String

    // MARK: - Configurable State
    var isSelected: Bool = false

    // MARK: - Callbacks
    var onTap: (() -> Void)? = nil

    // MARK: - Internal State (nếu có)
    @State private var isExpanded: Bool = false

    // MARK: - Body
    var body: some View {
        // → Xem Bước 4
    }
}
```

**Quy tắc khai báo:**
- `let` cho data bất biến truyền vào — không thể reassign sau init
- `var` với default value cho optional config
- `@State private var` chỉ cho local UI state (toggle, animation) — không leak ra ngoài
- Không có `@StateObject` / `@ObservedObject` / `@EnvironmentObject` trong custom view

---

### Bước 4 — Implement Body

#### Template đầy đủ:

```swift
var body: some View {
    TTBaseSUIView(withCornerRadius: XSize.CORNER_RADIUS, bg: .white) {
        TTBaseSUIHStack(alignment: .center, spacing: XSize.P_CONS_DEF) {

            // 1. Icon / Left element
            TTBaseSUIImage(withname: self.iconName, contentMode: .fit)
                .setIcon(color: self.isSelected
                    ? XView.buttonBgDef.toColor()
                    : XView.iconColor.toColor())
                .sizeSquare(width: XSize.H_SMALL_ICON)

            // 2. Text content
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

            // 3. Right indicator
            TTBaseSUIImage(withname: "icon_arrowRight", contentMode: .fit)
                .setIcon(color: XView.iconColor.toColor())
                .size(width: XSize.H_SMALL_SMALL_ICON, height: XSize.H_SMALL_SMALL_ICON)
        }
        .padding(XSize.getPadding())
    }
    .baseBorder(
        color: self.isSelected ? XView.buttonBgDef.toColor() : XView.lineDefColor.toColor(),
        width: self.isSelected ? 1.5 : TTSize.H_LINEVIEW,
        radius: XSize.CORNER_RADIUS)
    .onTapHandle { self.onTap?() }
}
```

---

### Bước 5 — Style Rules

#### 5a. Colors — dùng token app (XView.*) hoặc thư viện (TTView.*)

```swift
// ✅ Đúng
color: XView.textTitleColor.toColor()
bg:    XView.viewBgColor.toColor()
color: TTView.textDefColor.toColor()          // nếu chưa có XView alias

// ❌ Sai
color: .black
bg:    Color(#colorLiteral(...))
color: Color(UIColor(red: 0.3, ...))
```

#### 5b. Sizes — dùng token app (XSize.*) hoặc thư viện (TTSize.*)

```swift
// ✅ Đúng
spacing:  XSize.P_CONS_DEF
padding:  XSize.getPadding()
height:   TTSize.H_BUTTON
iconSize: TTSize.H_SMALL_ICON

// ❌ Sai
spacing:  8
padding:  .padding(16)
height:   40
```

#### 5c. Strings — dùng XText hoặc localize key

```swift
// ✅ Đúng
text: XText("App.NoData")
text: "App.Feature.Title".localize()

// ❌ Sai
text: "No data available"
text: "Loading..."
```

#### 5d. View Modifiers — dùng extension TTBaseUIKit

```swift
// ✅ Đúng
.maxWidth(alignment: .leading)
.pAll(XSize.P_CONS_DEF)
.pHorizontal(XSize.getPadding())
.corner(byDef: TTSize.CORNER_RADIUS)
.baseShadow()
.baseBorder()
.onTapHandle { action() }
.skeleton(active: isLoading)

// ❌ Sai (dùng native)
.frame(maxWidth: .infinity)
.padding(16)
.cornerRadius(8)
.shadow(radius: 4)
.onTapGesture { action() }
```

---

### Bước 6 — Patterns Thường Gặp

#### 6a. Row View (Icon + Title + Subtitle + Arrow)

```swift
struct SUIItemRowView: View {
    let title: String
    let subtitle: String
    var iconName: String = "icon.default"
    var isSelected: Bool = false
    var onTap: (() -> Void)? = nil

    var body: some View {
        TTBaseSUIView(withCornerRadius: XSize.CORNER_RADIUS, bg: .white) {
            TTBaseSUIHStack(alignment: .center, spacing: XSize.P_CONS_DEF) {
                TTBaseSUIImage(withname: self.iconName, contentMode: .fit)
                    .setIcon(color: XView.buttonBgDef.toColor())
                    .sizeSquare(width: TTSize.H_SMALL_ICON)
                TTBaseSUIVStack(alignment: .leading, spacing: XSize.P_CONS_DEF / 2) {
                    TTBaseSUIText(withBold: .TITLE, text: self.title, align: .leading, color: XView.textTitleColor.toColor())
                    TTBaseSUIText(withType: .SUB_TITLE, text: self.subtitle, align: .leading, color: XView.textSubTitleColor.toColor())
                        .lineLimit(2)
                }
                .maxWidth(alignment: .leading)
                TTBaseSUISpacer()
                TTBaseSUIImage(withSystemName: "chevron.right", iconColor: XView.iconColor.toColor())
                    .sizeSquare(width: TTSize.H_SMALL_SMALL_ICON)
            }
            .pAll(XSize.getPadding())
        }
        .onTapHandle { self.onTap?() }
    }
}
```

#### 6b. Icon + Label (Horizontal)

```swift
struct SUIIconLabelView: View {
    let iconName: String
    let text: String
    var iconColor: Color = XView.buttonBgDef.toColor()
    var textColor: Color = XView.textDefColor.toColor()

    var body: some View {
        TTBaseSUIHStack(alignment: .center, spacing: XSize.P_CONS_DEF) {
            TTBaseSUIImage(withname: self.iconName, contentMode: .fit)
                .setIcon(color: self.iconColor)
                .sizeSquare(width: TTSize.H_SMALL_ICON)
            TTBaseSUIText(withType: .TITLE, text: self.text, align: .leading, color: self.textColor)
                .maxWidth(alignment: .leading)
        }
    }
}
```

#### 6c. Card View (Background + Shadow + Border)

```swift
struct SUICardView<Content: View>: View {
    var bg: Color = .white
    var radius: CGFloat = XSize.CORNER_PANEL
    var hasBorder: Bool = false
    var onTap: (() -> Void)? = nil
    let content: () -> Content

    init(bg: Color = .white, radius: CGFloat = XSize.CORNER_PANEL, hasBorder: Bool = false, onTap: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.bg = bg
        self.radius = radius
        self.hasBorder = hasBorder
        self.onTap = onTap
        self.content = content
    }

    var body: some View {
        TTBaseSUIView(withCornerRadius: self.radius, bg: self.bg) {
            self.content()
        }
        .baseShadow(corner: self.radius)
        .if(self.hasBorder) { $0.baseBorder(radius: self.radius) }
        .onTapHandle { self.onTap?() }
    }
}
```

#### 6d. Empty State View

```swift
struct SUIEmptyStateView: View {
    var iconName: String = "icon.noData"
    var message: String = XText("App.NoData")
    var subMessage: String? = nil

    var body: some View {
        TTBaseSUIVStack(alignment: .center, spacing: XSize.getPadding()) {
            TTBaseSUIImage(withname: self.iconName, contentMode: .fit)
                .sizeSquare(width: XSize.H_CELL * 2)
            TTBaseSUIText(withBold: .TITLE, text: self.message, align: .center, color: XView.textTitleColor.toColor())
            if let sub = self.subMessage {
                TTBaseSUIText(withType: .SUB_TITLE, text: sub, align: .center, color: XView.textSubTitleColor.toColor())
            }
        }
        .maxWidth()
        .maxHeight()
    }
}
```

#### 6e. Section Header

```swift
struct SUISectionHeaderView: View {
    let title: String
    var subtitle: String? = nil

    var body: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: XSize.P_CONS_DEF / 2) {
            TTBaseSUIText(withBold: .HEADER, text: self.title, align: .leading, color: XView.textTitleColor.toColor())
            if let sub = self.subtitle {
                TTBaseSUIText(withType: .SUB_TITLE, text: sub, align: .leading, color: XView.textSubTitleColor.toColor())
            }
        }
        .maxWidth(alignment: .leading)
        .pHorizontal(XSize.getPadding())
        .pTop(XSize.getPadding())
        .pBottom(XSize.P_CONS_DEF)
    }
}
```

#### 6f. Loading / Skeleton Placeholder

```swift
struct SUISkeletonRowView: View {
    var body: some View {
        TTBaseSUIView(withCornerRadius: XSize.CORNER_RADIUS, bg: .white) {
            TTBaseSUIVStack(alignment: .leading, spacing: XSize.P_CONS_DEF) {
                TTBaseSUIText(withType: .TITLE, text: "Placeholder text loading")
                TTBaseSUIText(withType: .SUB_TITLE, text: "Sub placeholder")
            }
            .pAll(XSize.getPadding())
        }
        .skeleton(active: true)
    }
}
```

#### 6g. LiquidGlass Background (iOS 15+)

```swift
struct SUIGlassCardView<Content: View>: View {
    var cornerRadius: CGFloat = XSize.CORNER_PANEL
    let content: () -> Content

    var body: some View {
        ZStack {
            // Dùng sẵn từ TTBaseUIKit — KHÔNG tự implement
            if #available(iOS 15.0, *) {
                BlackLiquidGlassBackground(cornerRadius: self.cornerRadius)
            } else {
                WhiteLiquidGlassBackground(cornerRadius: self.cornerRadius)
            }
            self.content()
                .pAll(XSize.P_CONS_DEF)
        }
    }
}
```

---

### Bước 7 — Preview

```swift
// MARK: - Preview
#Preview {
    TTBaseSUIVStack(alignment: .center, spacing: XSize.P_CONS_DEF, bg: XView.viewBgColor.toColor()) {
        SUI{ViewName}View(
            iconName: "icon.default",
            title: "Preview Title",
            subtitle: "Preview subtitle text",
            isSelected: false
        )
        SUI{ViewName}View(
            iconName: "icon.default",
            title: "Selected State",
            subtitle: "This one is selected",
            isSelected: true
        )
    }
    .padding(XSize.getPadding())
}
```

> Nếu cần hỗ trợ iOS 13+, thay `#Preview` bằng `PreviewProvider`:

```swift
struct SUI{ViewName}View_Previews: PreviewProvider {
    static var previews: some View {
        TTBaseSUIVStack(alignment: .center, spacing: XSize.P_CONS_DEF, bg: XView.viewBgColor.toColor()) {
            SUI{ViewName}View(
                iconName: "icon.default",
                title: "Preview Title",
                subtitle: "Preview subtitle"
            )
        }
        .padding(XSize.getPadding())
        .previewLayout(.sizeThatFits)
    }
}
```

---

## 4. Components — Bảng Mapping TTBaseSUI*

| Cần | Dùng | KHÔNG dùng |
|---|---|---|
| Container có background + corner | `TTBaseSUIView(withCornerRadius:bg:)` | `RoundedRectangle` + `.background` tự build |
| Text thường | `TTBaseSUIText(withType: .TITLE, text:)` | `Text("...")` |
| Text bold | `TTBaseSUIText(withBold: .TITLE, text:)` | `Text("...").bold()` |
| Image từ asset | `TTBaseSUIImage(withname:)` | `Image("name")` |
| Icon system | `TTBaseSUIImage(withSystemName:iconColor:)` | `Image(systemName: "...")` |
| Icon tinted | `TTBaseSUIImage(withname:).setIcon(color:)` | `Image("").renderingMode(.template).foregroundColor(...)` |
| Vertical stack | `TTBaseSUIVStack(alignment:spacing:)` | `VStack` |
| Horizontal stack | `TTBaseSUIHStack(alignment:spacing:)` | `HStack` |
| Depth stack | `TTBaseSUIZStack(alignment:bg:)` | `ZStack` |
| Scroll vertical | `TTBaseSUIScroll(alignment: .vertical)` | `ScrollView(.vertical)` |
| Scroll horizontal | `TTBaseSUIScroll(alignment: .horizontal)` | `ScrollView(.horizontal)` |
| Lazy vertical list | `TTBaseSUILazyVStack(alignment:spacing:)` | `LazyVStack` |
| Lazy grid | `TTBaseSUILazyVGrid(columns:spacing:)` | `LazyVGrid` |
| Spacer | `TTBaseSUISpacer()` | `Spacer()` |
| Horizontal divider | `BaseHorizontalDivider(noConner:)` | `Divider()` |
| Button | `TTBaseSUIButton(type:title:action:)` | `Button("title") {}` |
| Navigation link | `TTBaseNavigationLink(destination:label:)` | `NavigationLink { } label: { }` |
| Shadow card | `TTBaseSUIShadowView(content:)` | `.shadow(...)` tự build |

---

## 5. View Extensions — Shorthand Modifier

| Extension | Tác dụng | Ví dụ |
|---|---|---|
| `.maxWidth(alignment:)` | `frame(maxWidth: .infinity)` | `.maxWidth(alignment: .leading)` |
| `.maxHeight(alignment:)` | `frame(maxHeight: .infinity)` | `.maxHeight()` |
| `.pAll(_ size:)` | `padding(size)` | `.pAll(XSize.P_CONS_DEF)` |
| `.pHorizontal(_ size:)` | `padding(.horizontal, size)` | `.pHorizontal(XSize.getPadding())` |
| `.pVertical(_ size:)` | `padding(.vertical, size)` | `.pVertical(XSize.P_CONS_DEF)` |
| `.pTop(_ size:)` | `padding(.top, size)` | `.pTop(XSize.P_CONS_DEF)` |
| `.pBottom(_ size:)` | `padding(.bottom, size)` | `.pBottom(XSize.P_CONS_DEF)` |
| `.pLeading(_ size:)` | `padding(.leading, size)` | `.pLeading(XSize.getPadding())` |
| `.pTrailing(_ size:)` | `padding(.trailing, size)` | `.pTrailing(XSize.getPadding())` |
| `.corner(byDef:)` | `cornerRadius(byDef)` | `.corner(byDef: TTSize.CORNER_RADIUS)` |
| `.bg(byDef:)` | `background(def)` | `.bg(byDef: XView.viewBgColor.toColor())` |
| `.bg(byUIColor:)` | `background(color.toColor())` | `.bg(byUIColor: TTView.viewBgColor)` |
| `.size(width:height:)` | `frame(width:height:)` | `.size(width: 40, height: 40)` |
| `.sizeSquare(width:)` | `frame(width:height:)` | `.sizeSquare(width: TTSize.H_SMALL_ICON)` |
| `.baseShadow(corner:color:radius:x:y:)` | Shadow preset | `.baseShadow()` |
| `.baseBorder(color:width:radius:)` | Border preset | `.baseBorder()` |
| `.onTapHandle(action:)` | `gesture(TapGesture())` | `.onTapHandle { onTap?() }` |
| `.skeleton(active:isShimmering:)` | Skeleton loading | `.skeleton(active: isLoading)` |
| `.hidden(_ shouldHide:)` | Conditional hide | `.hidden(isLoading)` |
| `.detectSize(onChange:)` | Measure view size | `.detectSize { size in ... }` |

---

## 6. State Management trong Custom View

### Khi nào dùng gì:

```swift
// ✅ Local UI toggle — @State
@State private var isExpanded: Bool = false
@State private var isAnimating: Bool = false

// ✅ Data từ parent — let / var
let item: ItemModel
var isSelected: Bool = false

// ✅ Callback lên parent — closure
var onTap: (() -> Void)? = nil
var onSelect: ((ItemModel) -> Void)? = nil

// ❌ KHÔNG dùng trong custom view
@StateObject private var viewModel = SomeViewModel()   // → Chỉ dùng ở Screen View
@ObservedObject var viewModel: SomeViewModel            // → Chỉ dùng ở Screen View
@EnvironmentObject var store: AppStore                  // → Tuỳ trường hợp, thường không cần
```

---

## 7. Gotcha List

| # | ❌ Sai | ✅ Đúng |
|---|---|---|
| 1 | `Text("Title")` | `TTBaseSUIText(withType: .TITLE, text: "Title")` |
| 2 | `Image("icon")` | `TTBaseSUIImage(withname: "icon")` |
| 3 | `VStack { }` | `TTBaseSUIVStack { }` |
| 4 | `HStack { }` | `TTBaseSUIHStack { }` |
| 5 | `ZStack { }` | `TTBaseSUIZStack { }` |
| 6 | `ScrollView { }` | `TTBaseSUIScroll { }` |
| 7 | `Spacer()` | `TTBaseSUISpacer()` |
| 8 | `Divider()` | `BaseHorizontalDivider(noConner: .LINE)` |
| 9 | `Button("OK") { }` | `TTBaseSUIButton(type: .DEFAULT, title: "OK") { }` |
| 10 | `Color.blue` hardcode | `XView.buttonBgDef.toColor()` |
| 11 | `.padding(16)` hardcode | `.pAll(XSize.P_CONS_DEF)` |
| 12 | `"Hard coded string"` | `XText("App.Key")` |
| 13 | `.shadow(radius: 4)` tự build | `.baseShadow()` |
| 14 | `.cornerRadius(8)` hardcode | `.corner(byDef: TTSize.CORNER_RADIUS)` |
| 15 | `.onTapGesture { }` | `.onTapHandle { }` |
| 16 | `.frame(maxWidth: .infinity)` | `.maxWidth(alignment: .leading)` |
| 17 | `@ObservedObject` trong custom view | Custom view không hold ViewModel |
| 18 | Wrap bằng `SUIBaseView` | Custom view KHÔNG dùng `SUIBaseView` |
| 19 | Không có ASCII layout diagram | Bắt buộc có diagram trước khai báo struct |
| 20 | Không có `#Preview` / `PreviewProvider` | Bắt buộc có preview ở cuối file |

---

## 8. Checklist Hoàn Thành

### File & Naming
- [ ] File đặt đúng: `SUIViews/CustomView/SUI{ViewName}View.swift` hoặc `Modules/{Feature}/CustomView/`
- [ ] Struct tên: `SUI{ViewName}View` (nhất quán với file)
- [ ] KHÔNG prefix `TTBaseSUI` (đó là cho thư viện, không phải app custom view)

### Khai Báo
- [ ] `let` cho data bất biến truyền vào
- [ ] `var` với default cho config tuỳ chọn
- [ ] `@State private var` chỉ cho local UI state
- [ ] KHÔNG có `@StateObject` / `@ObservedObject` / `@EnvironmentObject`
- [ ] Callbacks khai báo `var on{Action}: (() -> Void)? = nil`

### Body & Components
- [ ] KHÔNG có `Text`, `Image`, `VStack`, `HStack`, `ZStack`, `ScrollView`, `Spacer`, `Divider`, `Button` native
- [ ] Tất cả components dùng `TTBaseSUI*`
- [ ] Interaction dùng `.onTapHandle { }` (không phải `.onTapGesture`)
- [ ] ASCII layout diagram đặt ngay trên khai báo struct

### Style & Tokens
- [ ] KHÔNG hardcode màu — dùng `XView.*.toColor()` hoặc `TTView.*.toColor()`
- [ ] KHÔNG hardcode size — dùng `XSize.*` hoặc `TTSize.*`
- [ ] KHÔNG hardcode string — dùng `XText("key")` hoặc `.localize()`
- [ ] Padding dùng `.pAll()`, `.pHorizontal()`, `.pVertical()`, `.pTop()`, `.pBottom()`
- [ ] Corner dùng `.corner(byDef:)` hoặc `TTSize.CORNER_*`
- [ ] Shadow dùng `.baseShadow()` khi cần

### Preview
- [ ] Có `#Preview` hoặc `struct ..._Previews: PreviewProvider` ở cuối file
- [ ] Preview hiển thị ít nhất 2 trạng thái (default + một trạng thái biến thể)
- [ ] Preview wrap ngoài có background tương phản để thấy rõ view
