# TTBaseUIKit — Tạo BaseView Mới Kế Thừa Từ SwiftUI Base

> **Phạm vi:** Tạo một **primitive base view mới** bổ sung vào lớp `SwiftUIView/BaseViews/` của TTBaseUIKit.  
> View mới phải wrap native SwiftUI container/control, tuân thủ toàn bộ naming convention, dùng token config thư viện, cung cấp đủ `init` overloads, và có `PreviewProvider`.  
> **Nền tảng:** SwiftUI, TTBaseUIKit internal layer. Chỉ dành cho việc bổ sung vào thư viện — KHÔNG phải app-level feature view.

---

## 1. Phân Biệt Loại BaseView

Trước khi tạo, xác định view thuộc loại nào:

| Loại | Generic? | Native Wrap | Ví dụ có sẵn |
|---|---|---|---|
| **Container** (chứa content bên ngoài inject vào) | `<Content: View>` | `VStack`, `HStack`, `ZStack`, `ScrollView`, `LazyVStack`, `LazyHStack` | `TTBaseSUIVStack`, `TTBaseSUIHStack`, `TTBaseSUIScroll` |
| **Display** (tự quản lý content nội tại) | Không cần generic | `Text`, `Image`, `Divider` | `TTBaseSUIText`, `TTBaseSUIImage`, `BaseHorizontalDivider` |
| **Interactive** (có action bên ngoài inject vào) | `<Content: View>` | `Button`, `NavigationLink` | `TTBaseSUIButton`, `TTBaseNavigationLink` |
| **Decorator / Effect** (wraps content + thêm hiệu ứng) | `<Content: View>` | Wrap bất kỳ primitive nào + modifier | `TTBaseSUIShadowView` |

---

## 2. Cấu Trúc File

```
Sources/TTBaseUIKit/SwiftUIView/BaseViews/
└── BaseSUI{Name}.swift       ← File mới đặt tại đây
```

**Naming convention bắt buộc:**
- File: `BaseSUI{Name}.swift`
- Struct: `TTBaseSUI{Name}` (prefix `TTBaseSUI` không được bỏ)
- `public` access modifier cho tất cả `struct`, `init`, `var`, `func` công khai

---

## 3. Quy Trình Từng Bước

### Bước 1 — Header File Chuẩn

```swift
//
//  BaseSUI{Name}.swift
//  TTBaseUIKit
//
//  Created by {Author} on {Date}.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
```

> Không `import UIKit` trừ khi bắt buộc (ví dụ cần `UIFont`, `UIColor`).  
> Không `import Foundation` riêng lẻ — `SwiftUI` đã bao gồm.

---

### Bước 2 — Khai Báo Struct & Stored Properties

#### 2a. Container View (generic `<Content: View>`)

```swift
public struct TTBaseSUI{Name}<Content: View>: View {

    // MARK: - Stored Properties (dùng token TTBaseUIKitConfig)
    public var spacing: CGFloat           = TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF
    public var viewDefBgColor: Color      = TTBaseUIKitConfig.getViewConfig().viewStackDefBgColor
    public var viewDefCornerRadius: CGFloat = TTBaseUIKitConfig.getSizeConfig().CORNER_RADIUS
    public var align: HorizontalAlignment = .leading    // ← hoặc VerticalAlignment, Alignment tuỳ loại

    public var content: () -> Content
}
```

#### 2b. Display View (không generic)

```swift
public struct TTBaseSUI{Name}: View {

    // MARK: - Stored Properties
    public var textDefColor: Color = Color(TTBaseUIKitConfig.getViewConfig().textDefColor)
    public var fontDef: UIFont    = TTBaseUIKitConfig.getFontConfig().FONT
    // ... các property mô tả nội dung
}
```

> **Quy tắc property:**
> - Luôn có giá trị default từ `TTBaseUIKitConfig.*` — KHÔNG hardcode literal số/màu.
> - `public var` (không phải `let`) để cho phép mutate sau init nếu cần.
> - Tên property follow pattern hiện có: `viewDefBgColor`, `viewDefCornerRadius`, `spacing`, `align`.

---

### Bước 3 — Init Overloads (tối thiểu 3)

Pattern chuẩn: từ **đơn giản nhất** → **đầy đủ nhất**. Mỗi init phức tạp hơn chỉ thêm 1–2 tham số so với init trước.

#### Cho Container View:

```swift
// Init 1: Chỉ content (dùng toàn bộ default)
public init(@ViewBuilder content: @escaping () -> Content) {
    self.content = content
}

// Init 2: Thêm alignment + spacing
public init(
    alignment: HorizontalAlignment = .center,
    spacing: CGFloat,
    @ViewBuilder content: @escaping () -> Content
) {
    self.content = content
    self.align   = alignment
    self.spacing = spacing
}

// Init 3: Thêm bg color
public init(
    alignment: HorizontalAlignment = .center,
    spacing: CGFloat,
    bg: Color,
    @ViewBuilder content: @escaping () -> Content
) {
    self.content          = content
    self.align            = alignment
    self.spacing          = spacing
    self.viewDefBgColor   = bg
}

// Init 4 (nếu cần): Thêm cornerRadius
public init(
    alignment: HorizontalAlignment = .center,
    spacing: CGFloat,
    bg: Color,
    radius: CGFloat,
    @ViewBuilder content: @escaping () -> Content
) {
    self.content                = content
    self.align                  = alignment
    self.spacing                = spacing
    self.viewDefBgColor         = bg
    self.viewDefCornerRadius    = radius
}
```

> **Quan trọng:** `@ViewBuilder content` **luôn là tham số cuối cùng** để Swift cho phép trailing closure syntax.

#### Cho Display View:

```swift
// Init 1: Tối thiểu
public init(text: String) {
    self.text = text
}

// Init 2: Thêm color
public init(text: String, color: Color = Color(TTBaseUIKitConfig.getViewConfig().textDefColor)) {
    self.text          = text
    self.textDefColor  = color
}

// Init 3: Đầy đủ
public init(text: String, color: Color, font: UIFont) {
    self.text          = text
    self.textDefColor  = color
    self.fontDef       = font
}
```

---

### Bước 4 — Implement `body`

#### Pattern cho Container View:

```swift
public var body: some View {
    // Wrap native SwiftUI container
    {NativeContainer}(alignment: self.align, spacing: self.spacing, content: self.content)
        .background(self.viewDefBgColor)
        .cornerRadius(self.viewDefCornerRadius)
}
```

**Ví dụ thực tế — `TTBaseSUIVStack`:**
```swift
public var body: some View {
    VStack(alignment: self.align, spacing: self.spacing, content: self.content)
        .background(self.viewDefBgColor)
        .cornerRadius(self.viewDefCornerRadius)
}
```

#### Pattern cho View có iOS version guard:

```swift
public var body: some View {
    if #available(iOS 16.0, *) {
        self.setupBase()
            .scrollIndicators(self.showIndicators ? .visible : .hidden, axes: self.align)
            .background(self.viewDefBgColor)
            .cornerRadius(self.viewDefCornerRadius)
    } else {
        self.createBaseLowVersion()
            .background(self.viewDefBgColor)
            .cornerRadius(self.viewDefCornerRadius)
    }
}
```

> Tách logic vào `private func setupBase()` / `private func createBaseLowVersion()` khi `body` trở nên phức tạp — theo pattern `TTBaseSUIScroll`.

---

### Bước 5 — Extension Helper (tuỳ chọn)

Nếu cần expose thêm helper function mà không cần thêm init:

```swift
extension TTBaseSUI{Name} {
    /// Áp dụng corner radius và trả về some View
    public func setCorner(radius: CGFloat = TTSize.CORNER_RADIUS) -> some View {
        return self.body.cornerRadius(radius)
    }
}
```

> **Lưu ý:** Extension này chỉ phù hợp khi helper return `some View`. Nếu cần mutate stored property trước khi render, thêm init overload mới thay vì dùng extension.

---

### Bước 6 — Preview

#### Dùng `#Preview` (iOS 17+ / Xcode 15+) — ưu tiên:

```swift
#Preview {
    TTBaseSUIView(bg: .gray) {
        TTBaseSUI{Name}(alignment: .center, spacing: 8, bg: .white) {
            TTBaseSUIText(withType: .TITLE, text: "Preview content", align: .center, color: .black)
            TTBaseSUIText(withType: .SUB_TITLE, text: "Sub text", align: .center, color: .gray)
        }
        .padding()
    }
}
```

#### Dùng `PreviewProvider` (tương thích iOS 13+) — khi cần backward compat:

```swift
struct BaseSUI{Name}_Previews: PreviewProvider {
    static var previews: some View {
        TTBaseSUIView(bg: .gray) {
            TTBaseSUI{Name}(alignment: .center, spacing: 8, bg: .white) {
                TTBaseSUIText(withType: .TITLE, text: "Preview content", align: .center, color: .black)
            }
            .padding()
        }
    }
}
```

> **Quy tắc Preview:**
> - Luôn wrap ngoài bằng `TTBaseSUIView` (hoặc `.background(Color.gray)`) để thấy contrast.
> - Preview struct/macro phải là `fileprivate` hoặc `internal` — KHÔNG `public`.
> - Tên Preview struct: `BaseSUI{Name}_Previews` (không prefix `TTBase`).

---

## 4. Token Reference — KHÔNG Hardcode

| Cần | Token | Ví dụ |
|---|---|---|
| Spacing / Padding | `TTSize.P_S`, `TTSize.P_CONS_DEF`, `TTSize.getPadding()` | `spacing: TTSize.P_CONS_DEF` |
| Corner radius | `TTSize.CORNER_RADIUS`, `TTSize.CORNER_PANEL`, `TTSize.CORNER_BUTTON` | `.cornerRadius(TTSize.CORNER_RADIUS)` |
| Background color | `TTView.viewDefColor.toColor()`, `TTView.viewBgColor.toColor()` | `bg: TTView.viewDefColor.toColor()` |
| Stack background | `TTBaseUIKitConfig.getViewConfig().viewStackDefBgColor` | Mặc định `.clear` |
| Text color | `Color(TTView.textDefColor)`, `Color(TTView.textTitleColor)` | `color: Color(TTView.textDefColor)` |
| Font | `TTBaseUIKitConfig.getFontConfig().FONT` | `font: TTFont.TITLE_H` |
| Button height | `TTSize.H_BUTTON` | `.frame(height: TTSize.H_BUTTON)` |
| Icon size | `TTSize.H_SMALL_ICON`, `TTSize.H_ICON` | `.sizeSquare(width: TTSize.H_SMALL_ICON)` |

> **Alias nhanh:** `TTView` = `TTBaseUIKitConfig.getViewConfig()`, `TTSize` = `TTBaseUIKitConfig.getSizeConfig()`, `TTFont` = `TTBaseUIKitConfig.getFontConfig()`.

---

## 5. Checklist Hoàn Thành

### Naming & File
- [ ] File đặt đúng: `Sources/TTBaseUIKit/SwiftUIView/BaseViews/BaseSUI{Name}.swift`
- [ ] Struct tên: `TTBaseSUI{Name}` (prefix `TTBaseSUI` không được thiếu)
- [ ] Tất cả `struct`, `init`, `var body`, `var` property công khai đều có `public`

### Stored Properties
- [ ] Tất cả default value dùng `TTBaseUIKitConfig.*` / `TTSize.*` / `TTView.*` — KHÔNG literal
- [ ] Khai báo `public var` (không phải `let`) cho mọi configurable property

### Init Overloads
- [ ] Tối thiểu 3 inits: đơn giản → đầy đủ
- [ ] `@ViewBuilder content` luôn là tham số cuối cùng
- [ ] Default values trong signature tái sử dụng token config

### Body
- [ ] Wrap đúng native SwiftUI primitive
- [ ] Apply `.background(self.viewDefBgColor)` + `.cornerRadius(self.viewDefCornerRadius)` nếu là container
- [ ] Dùng `if #available(iOS X.0, *)` guard nếu dùng API mới
- [ ] Tách logic phức tạp ra `private func setupBase()`

### Preview
- [ ] Có `#Preview` hoặc `PreviewProvider` ở cuối file
- [ ] Preview struct là `internal` / `fileprivate` — KHÔNG `public`
- [ ] Preview wrap ngoài bằng `TTBaseSUIView` hoặc background màu tương phản

### Tổng quát
- [ ] `import SwiftUI` (không `import UIKit` trừ khi bắt buộc)
- [ ] Không có hardcode string, màu, size, font
- [ ] Không có `private` stored property — tất cả `public var` để cho phép config từ ngoài
- [ ] File chỉ chứa 1 struct + extension của nó + preview

---

## 6. Ví Dụ Đầy Đủ — `TTBaseSUICardView` (Container + Decorator)

```swift
//
//  BaseSUICardView.swift
//  TTBaseUIKit
//
//  Created by {Author} on {Date}.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import SwiftUI

/// Card container: wrap content với background, border, và shadow.
///
/// ```
/// ┌─ TTBaseSUICardView ──────────────────────────────────────┐
/// │  padding(P_S)                                            │
/// │  ┌── content ──────────────────────────────────────────┐ │
/// │  │                                                      │ │
/// │  └──────────────────────────────────────────────────────┘ │
/// │  shadow / border                                          │
/// └───────────────────────────────────────────────────────────┘
/// ```
public struct TTBaseSUICardView<Content: View>: View {

    // MARK: - Stored Properties
    public var viewDefBgColor: Color        = Color(TTBaseUIKitConfig.getViewConfig().viewDefColor)
    public var viewDefCornerRadius: CGFloat = TTBaseUIKitConfig.getSizeConfig().CORNER_PANEL
    public var padding: CGFloat             = TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF
    public var shadowColor: Color           = TTView.viewPanelShadowColor
    public var shadowRadius: CGFloat        = 4.0
    public var hasBorder: Bool              = false
    public var borderColor: Color           = TTView.lineDefColor.toColor()
    public var borderWidth: CGFloat         = TTSize.H_LINEVIEW

    public let content: () -> Content

    // MARK: - Init Overloads

    /// Init 1: Chỉ content
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    /// Init 2: bg + cornerRadius
    public init(bg: Color, radius: CGFloat = TTSize.CORNER_PANEL, @ViewBuilder content: @escaping () -> Content) {
        self.viewDefBgColor       = bg
        self.viewDefCornerRadius  = radius
        self.content              = content
    }

    /// Init 3: bg + radius + shadow
    public init(bg: Color, radius: CGFloat = TTSize.CORNER_PANEL, shadowRadius: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.viewDefBgColor       = bg
        self.viewDefCornerRadius  = radius
        self.shadowRadius         = shadowRadius
        self.content              = content
    }

    /// Init 4: đầy đủ
    public init(
        bg: Color = Color(TTBaseUIKitConfig.getViewConfig().viewDefColor),
        radius: CGFloat = TTSize.CORNER_PANEL,
        padding: CGFloat = TTSize.P_CONS_DEF,
        shadowRadius: CGFloat = 4.0,
        hasBorder: Bool = false,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.viewDefBgColor      = bg
        self.viewDefCornerRadius = radius
        self.padding             = padding
        self.shadowRadius        = shadowRadius
        self.hasBorder           = hasBorder
        self.content             = content
    }

    // MARK: - Body
    public var body: some View {
        self.content()
            .padding(self.padding)
            .background(
                RoundedRectangle(cornerRadius: self.viewDefCornerRadius, style: .continuous)
                    .fill(self.viewDefBgColor)
                    .shadow(color: self.shadowColor, radius: 8, x: 0, y: self.shadowRadius)
            )
            .overlay(
                Group {
                    if self.hasBorder {
                        RoundedRectangle(cornerRadius: self.viewDefCornerRadius, style: .continuous)
                            .stroke(self.borderColor, lineWidth: self.borderWidth)
                    }
                }
            )
    }
}

// MARK: - Preview
struct TTBaseSUICardView_Previews: PreviewProvider {
    static var previews: some View {
        TTBaseSUIView(bg: Color(TTView.viewBgColor)) {
            TTBaseSUIVStack(alignment: .center, spacing: TTSize.P_CONS_DEF) {
                TTBaseSUICardView(bg: .white, radius: TTSize.CORNER_PANEL, shadowRadius: 4.0) {
                    TTBaseSUIVStack(alignment: .leading, spacing: TTSize.P_CONS_DEF / 2) {
                        TTBaseSUIText(withBold: .TITLE, text: "Card Title", align: .leading, color: Color(TTView.textTitleColor))
                        TTBaseSUIText(withType: .SUB_TITLE, text: "Card subtitle text here", align: .leading, color: Color(TTView.textSubTitleColor))
                    }
                }
                TTBaseSUICardView(bg: .white, radius: TTSize.CORNER_PANEL, shadowRadius: 4.0, hasBorder: true) {
                    TTBaseSUIText(withType: .TITLE, text: "Card with Border", align: .center, color: Color(TTView.textDefColor))
                }
            }
            .padding(TTSize.P_CONS_DEF)
        }
        .previewLayout(.sizeThatFits)
    }
}
```

---

## 7. Gotcha List

| # | ❌ Sai | ✅ Đúng |
|---|---|---|
| 1 | `struct MyView: View` (thiếu prefix) | `struct TTBaseSUIMyView: View` |
| 2 | `var spacing: CGFloat = 8` (hardcode) | `var spacing: CGFloat = TTSize.P_CONS_DEF` |
| 3 | `private var content` | `public var content` |
| 4 | `let content: () -> Content` | `public var content: () -> Content` (cho phép reassign nếu cần) |
| 5 | Chỉ có 1 init | Tối thiểu 3 inits (đơn giản → đầy đủ) |
| 6 | `@ViewBuilder content` ở đầu danh sách tham số | `@ViewBuilder content` luôn là tham số **cuối cùng** |
| 7 | `Color.blue` làm default | `TTBaseUIKitConfig.getViewConfig().viewStackDefBgColor` |
| 8 | `import UIKit` không cần thiết | Chỉ `import SwiftUI` trừ khi thực sự cần `UIFont`/`UIColor` |
| 9 | Preview struct đặt tên `TTBaseSUI{Name}_Previews` | Preview struct là `BaseSUI{Name}_Previews` (không prefix `TT`) |
| 10 | File đặt ở `CustomView/` | File đặt ở `SwiftUIView/BaseViews/` |
