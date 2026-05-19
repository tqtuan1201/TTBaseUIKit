---
name: "antigravity-tutorial-vi"
description: "Hướng dẫn sử dụng toàn diện TTBaseUIKit Antigravity agents: khi nào dùng skill nào, prompt mô tả như thế nào, và ví dụ thực tế. Vietnamese version."
version: "1.0.0"
---

# Antigravity Agent System — Hướng dẫn sử dụng

**Version**: 1.0.0 | **Prerequisite**: Đọc `README-VI.md` trước

Hướng dẫn này giải thích **khi nào dùng** mỗi skill, **prompt nào để kích hoạt**, và **cách viết prompt hiệu quả** cho từng kịch bản.

---

## Mục lục

1. [Cây quyết định chọn Skill](#1-cây-quyết-định-chọn-skill)
2. [/ttb-init — Khởi tạo Dự án](#2-ttb-init--khởi-tạo-dự-án-mới)
3. [/ttb-uikit — Phát triển UIKit](#3-ttb-uikit--phát-triển-uikit)
4. [/ttb-swiftui — Phát triển SwiftUI](#4-ttb-swiftui--phát-triển-swiftui)
5. [/ttb-native-* — Native SwiftUI Components](#5-ttb-native---native-swiftui-components)
6. [/ttb-bugfix — Sửa Bug](#6-ttb-bugfix--sửa-bug)
7. [/ttb-refactor — Refactoring Code](#7-ttb-refactor--refactoring-code)
8. [/ttb-audit — Kiểm tra Code](#8-ttb-audit--kiểm-tra-code)
9. [Cách viết Prompt hiệu quả](#9-cách-viết-prompt-hiệu-quả)
10. [Tổng kết Workflow](#10-tổng-kết-workflow)

---

## 1. Cây quyết định chọn Skill

```
Bạn cần làm gì?
│
├── ① Tạo DỰ ÁN MỚI từ đầu
│   └── → /ttb-init
│
├── ② Thêm FEATURE MỚI
│   │
│   ├── App hiện tại có UIKit navigation stack?
│   │   ├── CÓ → SwiftUI screens dùng backType = .POP
│   │   └── KHÔNG → Pure SwiftUI, dùng backType = .SWIFTUI
│   │
│   ├── Dùng UIKit (ViewController)?
│   │   └── → /ttb-uikit
│   │
│   └── Dùng SwiftUI?
│       │
│       ├── Có sẵn TTBaseSUI component?
│       │   ├── CÓ → /ttb-sui-screen, /ttb-sui-view, /ttb-sui-list
│       │   └── KHÔNG → Kiểm tra /ttb-native-*
│       │
│       └── Cần native SwiftUI component?
│           └── → /ttb-native-{component-name}
│
├── ③ Sửa BUG
│   └── → /ttb-bugfix
│
├── ④ Cải thiện CODE HIỆN CÓ
│   │
│   ├── Raw UIKit → TTBaseUIKit
│   │   └── → /ttb-refactor-uikit
│   │
│   └── Native SwiftUI → TTBaseSUI
│       └── → /ttb-refactor-swiftui
│
└── ⑤ Kiểm tra CODE
    ├── Performance
    │   └── → /ttb-audit-performance
    ├── Accessibility
    │   └── → /ttb-audit-accessibility
    └── Localization
        └── → /ttb-audit-localization
```

---

## 2. /ttb-init — Khởi tạo Dự án mới

### Khi nào dùng

- **Lần đầu** setup dự án iOS mới với TTBaseUIKit
- **Migrate** dự án hiện tại sang TTBaseUIKit architecture
- **Cấu hình lại** dự án TTBaseUIKit đã có (thêm localization, cập nhật config)

### Prompts có sẵn

| Prompt | Dùng khi |
|--------|----------|
| `/ttb-init` | Khởi tạo đầy đủ (tất cả phases) |
| `/ttb-init-structure` | Chỉ setup cấu trúc thư mục MVVM-C |
| `/ttb-init-config` | Chỉ setup TTBaseUIKitConfig + dependency |
| `/ttb-init-l10n` | Chỉ setup localization (XText/XTextU) |
| `/ttb-init-debug` | Chỉ tích hợp TTBDebugPlus |

### Cách viết Prompt

```bash
# Cơ bản
"/ttb-init — khởi tạo dự án iOS mới tên MyApp với TTBaseUIKit"

# Chỉ phần cụ thể
"/ttb-init — setup cấu trúc thư mục MVVM-C cho MyApp"
"/ttb-init — configure TTBaseUIKit với SPM cho MyApp"
"/ttb-init — setup localization với XText/XTextU cho MyApp"
```

### Kết quả

```
MyApp/
├── AppDelegate.swift
├── SceneDelegate.swift
├── Core/
│   ├── Base/
│   ├── Coordinators/
│   ├── Extensions/
│   └── Configs/
├── Features/
│   └── ModuleName/
│       ├── Coordinators/
│       ├── ViewControllers/
│       ├── ViewModels/
│       ├── Models/
│       ├── APIs/
│       ├── CustomViews/
│       └── Resources/
│           └── Localizable.strings
└── Resources/
    ├── Info.plist
    └── Assets.xcassets
```

---

## 3. /ttb-uikit — Phát triển UIKit

### Khi nào dùng

- Xây dựng **màn hình mới** sử dụng UIKit `ViewController`
- Xây dựng **lists** (`UITableView`, `UICollectionView`)
- Xây dựng **forms** với text inputs và validation
- Xây dựng **custom cells** và **custom views**
- Tạo **API services** và **coordinators**

### Prompts có sẵn

| Prompt | Dùng khi |
|--------|----------|
| `/ttb-uikit-screen` | Full screen: ViewController + ViewModel + TTViewCodable |
| `/ttb-uikit-list` | UITableView / UICollectionView screen |
| `/ttb-uikit-form` | Form với text fields + validation |
| `/ttb-uikit-cell` | UITableViewCell hoặc UICollectionViewCell |
| `/ttb-uikit-customview` | Reusable custom UIView component |
| `/ttb-uikit-api` | API service singleton |
| `/ttb-uikit-coordinator` | Navigation coordinator |
| `/ttb-uikit-viewmodel` | ViewModel với callbacks |

### Cách viết Prompt

```bash
# Full screen
"/ttb-uikit-screen — tạo màn hình ProductDetail với ảnh, tiêu đề, giá, nút thêm vào giỏ hàng"

# List screen
"/ttb-uikit-list — tạo màn hình ProductList với pull-to-refresh, phân trang, thanh tìm kiếm"

# Cell
"/ttb-uikit-cell — tạo ProductCell với ảnh (56x56), tiêu đề (2 dòng), phụ đề, giá"

# API
"/ttb-uikit-api — tạo ProductAPI service cho getProducts, getProduct(id), createOrder"

# Coordinator
"/ttb-uikit-coordinator — tạo ProductCoordinator để navigate đến ProductList và ProductDetail"
```

### Template màn hình UIKit

Mỗi màn hình UIKit tuân theo pattern này:

```swift
// ProductDetailViewController.swift
class ProductDetailViewController: TTBaseUIViewController, TTViewCodable {

    // MARK: - UI Components
    private lazy var imageView = TTBaseUIImageView()
    private lazy var titleLabel = TTBaseUILabel(withType: .HEADER)
    private lazy var priceLabel = TTBaseUILabel(withType: .TITLE)
    private lazy var addButton = TTBaseUIButton()

    // MARK: - Properties
    var viewModel: ProductDetailViewModel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.loadProduct()
    }

    // MARK: - TTViewCodable
    func setupUI() { /* addSubview + SnapKit constraints */ }
    func setupData() { /* set initial data */ }
    func bindViewModel() {
        viewModel.onProductLoaded = { [weak self] product in
            self?.updateUI(with: product)
        }
    }
}
```

### Luật quan trọng cho UIKit

- ✅ Mọi VC phải implement `TTViewCodable`
- ✅ Dùng `TTBaseUI*` components (TTBaseUILabel, TTBaseUIButton, etc.)
- ✅ ViewModel không bao giờ import UIKit
- ✅ Mọi closure sử dụng `[weak self]`
- ✅ Mọi string dùng `XText("key")` hoặc `XTextU("key")`

---

## 4. /ttb-swiftui — Phát triển SwiftUI

### Khi nào dùng

- Xây dựng **màn hình mới** sử dụng SwiftUI
- Xây dựng **reusable SwiftUI views**
- Xây dựng **SwiftUI lists** với TTBaseSUI components
- Xây dựng **SwiftUI ViewModels**

### Prompts có sẵn

| Prompt | Dùng khi |
|--------|----------|
| `/ttb-sui-screen` | SwiftUI screen với SUIBaseView wrapper |
| `/ttb-sui-view` | Reusable TTBaseSUI view |
| `/ttb-sui-list` | SwiftUI list với TTBaseSUILazyVStack |
| `/ttb-sui-viewmodel` | SwiftUI ViewModel với @Published |
| `/ttb-native-screen` | Native SwiftUI screen (fallback khi TTBaseSUI thiếu) |
| `/ttb-native-view` | Native SwiftUI reusable view (fallback) |

### Cách viết Prompt

```bash
# TTBaseSUI screen
"/ttb-sui-screen — tạo HomeScreen với banner carousel, lưới sản phẩm (2 cột), và bottom tab bar"

# TTBaseSUI view
"/ttb-sui-view — tạo ProductCardView với ảnh, tiêu đề, giá, và nút thêm vào giỏ hàng"

# SwiftUI list
"/ttb-sui-list — tạo ProductListScreen với pull-to-refresh, lazy loading, và thanh tìm kiếm"

# ViewModel
"/ttb-sui-viewmodel — tạo ProductListViewModel với search, filter, và pagination"

# Native SwiftUI (fallback)
"/ttb-native-screen — tạo ChartScreen với biểu đồ cột tùy chỉnh dùng native SwiftUI"
```

### Template màn hình SwiftUI (BẮT BUỘC)

**Mọi màn hình SwiftUI PHẢI wrap trong `SUIBaseView`.**

```swift
// ProductDetailScreen.swift
struct ProductDetailScreen: View {
    @StateObject private var viewModel = ProductDetailViewModel()
    let productId: Int

    var body: some View {
        SUIBaseView(
            titleNav: XTextU("Product.Detail.Nav.Title"),
            isShowBack: true,
            backType: .SWIFTUI
        ) {
            content
        }
        .onAppear { viewModel.loadProduct(id: productId) }
    }

    private var content: some View {
        ScrollView {
            LazyVStack(spacing: TTSize.P_CONS_DEF) {
                TTBaseSUIAsyncImage(url: viewModel.product?.imageUrl)
                    .frame(height: TTSize.W * 0.6)
                    .clipShape(RoundedRectangle(cornerRadius: TTSize.CORNER_PANEL))

                TTBaseSUIText(
                    text: viewModel.product?.title ?? "",
                    type: .HEADER
                )

                TTBaseSUIText(
                    text: viewModel.product?.price ?? "",
                    type: .TITLE
                )
                .foregroundColor(TTView.buttonBgWar.toColor())

                TTBaseSUIButton(title: XText("Product.Detail.AddToCart")) {
                    viewModel.addToCart()
                }
            }
            .padding(TTSize.P_CONS_DEF)
        }
        .background(TTView.viewBgColor.toColor())
    }
}
```

### Hướng dẫn chọn Three-Tier

```
Có TTBaseSUI component cho thứ bạn cần không?
│
├── CÓ — Dùng /ttb-sui-* prompts
│   ├── TTBaseSUIText        → hiển thị text
│   ├── TTBaseSUIButton      → buttons
│   ├── TTBaseSUIImage       → ảnh tĩnh
│   ├── TTBaseSUIAsyncImage  → ảnh từ xa
│   ├── TTBaseSUITextField   → text inputs
│   ├── TTBaseSUIToggle      → toggle switches
│   ├── TTBaseSUISlider      → sliders
│   ├── TTBaseSUITabView     → tab navigation
│   ├── TTBaseSUILazyVStack  → scrollable lists
│   └── TTBaseNavigationLink  → navigation giữa các màn hình
│
└── KHÔNG — Dùng /ttb-native-* prompts (Native SwiftUI + TTBaseUIKit tokens)
    ├── Charts, graphs
    ├── Custom shapes
    ├── Advanced gestures
    └── Components không có trong TTBaseSUI
```

### Luật quan trọng cho SwiftUI

- ✅ Mọi màn hình PHẢI wrap trong `SUIBaseView`
- ✅ Navigation giữa các màn hình PHẢI dùng `TTBaseNavigationLink`
- ✅ Dùng `TTView`, `TTSize`, `TTFont` cho tất cả tokens
- ✅ ViewModel không bao giờ import SwiftUI
- ✅ Mọi closure sử dụng `[weak self]`
- ✅ Mọi string dùng `XText("key")` hoặc `XTextU("key")`
- ✅ Chỉ dùng iOS 14+ APIs

---

## 5. /ttb-native-* — Native SwiftUI Components

### Khi nào dùng

TTBaseSUI **không có** component cho nhu cầu của bạn. Ví dụ:
- Custom charts và graphs
- Advanced shapes và paths
- Custom animations
- Complex gesture recognizers
- Third-party SwiftUI libraries

### Prompts có sẵn

| Prompt | Component | Dùng khi |
|--------|-----------|----------|
| `/native-text` | Text variants | Title, body, caption, badge |
| `/native-button` | Button variants | Primary, secondary, destructive, link |
| `/native-card` | Card variants | Tappable card, static card |
| `/native-list-row` | List row variants | Icon row, switch row, stepper row |
| `/native-input` | Input variants | Text field, secure field, search bar |
| `/native-selector` | Selector variants | Toggle, checkbox, radio, segmented |
| `/native-display` | Display variants | Avatar, badge, chip, tag, rating |
| `/native-progress` | Progress variants | Linear bar, circular, skeleton |
| `/native-divider` | Divider variants | Horizontal, vertical, section spacer |
| `/native-tab-bar` | Tab bar | Icon + label tabs |
| `/native-icon` | Icon | SF Symbol với color/size |
| `/native-bottom-sheet` | Bottom sheet | Slide-up panel |
| `/native-empty-state` | Empty state | Illustration + message + action |
| `/native-loading` | Loading | Spinner, shimmer, skeleton |
| `/native-chip` | Chip/tag | With states |
| `/native-avatar` | Avatar | Image, initials, status |
| `/native-rating` | Rating | Star rating, interactive/display |
| `/native-section-header` | Section header | With optional action |
| `/native-alert` | Alert | Confirmation dialog |

### Cách viết Prompt

```bash
# Text
"/native-text — tạo BadgeText component hiển thị label màu với góc bo tròn"

# Button
"/native-button — tạo PrimaryButton với chiều cao 40pt, corner radius 4, background color từ TTView.buttonBgDef"

# Card
"/native-card — tạo TappableCard hiển thị ảnh sản phẩm, tiêu đề, giá, và highlight khi bấm"

# Rating
"/native-rating — tạo StarRating với 5 sao, hỗ trợ nửa sao, tap để thay đổi"

# Empty state
"/native-empty-state — tạo EmptyStateView với illustration, message, và optional action button"
```

### Native SwiftUI Template

```swift
// BadgeText.swift
//
//  BadgeText.swift
//  AppName
//
//  Generated by TTBaseUIKit Antigravity Agent System
//  DO NOT EDIT manually — changes will be overwritten
//
//  Version: 2026-05-19
//  Skill: ttb-skill-native-swiftui-components v1.0.0
//
//  Architecture: MVVM-C | Framework: TTBaseUIKit | Min iOS: 14
//

import SwiftUI

struct BadgeText: View {
    let text: String
    let backgroundColor: Color
    let textColor: Color

    init(
        text: String,
        backgroundColor: Color = TTView.buttonBgDef.toColor(),
        textColor: Color = TTView.viewDefColor.toColor()
    ) {
        self.text = text
        self.backgroundColor = backgroundColor
        self.textColor = textColor
    }

    var body: some View {
        Text(text)
            .font(.system(size: TTFont.SUB_SUB_TITLE_H, weight: .medium))
            .foregroundColor(textColor)
            .padding(.horizontal, TTSize.P_S)
            .padding(.vertical, TTSize.P_XS)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: TTSize.CORNER_RADIUS))
    }
}

struct BadgeText_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: TTSize.P_CONS_DEF) {
            BadgeText(text: "NEW", backgroundColor: TTView.notificationBgSuccess.toColor())
            BadgeText(text: "SALE", backgroundColor: TTView.notificationBgWarning.toColor())
            BadgeText(text: "HOT", backgroundColor: TTView.notificationBgError.toColor())
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
```

### Luật quan trọng cho Native SwiftUI

- ✅ Dùng `TTView`, `TTSize`, `TTFont` tokens cho tất cả styling
- ✅ Chỉ dùng iOS 14+ APIs (không `.foregroundStyle()`, không `NavigationStack`, etc.)
- ✅ Luôn include `PreviewProvider` cho iOS 14-16 compatibility
- ✅ Include generation marker comment ở đầu file
- ✅ Khi TTBaseSUI có component → dùng `/ttb-sui-*` thay vì `/ttb-native-*`

---

## 6. /ttb-bugfix — Sửa Bug

### Khi nào dùng

- App **crash** ở màn hình cụ thể
- **Logic error** — app không hoạt động đúng như mong đợi
- **Memory leak** — app crash sau khi sử dụng lâu
- **UI glitch** — layout bị hỏng hoặc thiếu phần tử
- **API error** — network call thất bại hoặc trả về data sai

### Cách viết Prompt

```bash
# Crash
"/ttb-bugfix — app crash khi bấm nút Thêm vào giỏ hàng ở màn hình ProductDetail. Crash log đính kèm."

# Logic error
"/ttb-bugfix — số badge của cart không cập nhật sau khi thêm sản phẩm. Chỉ cập nhật sau khi pull to refresh."

# Memory leak
"/ttb-bugfix — memory usage tăng từ 50MB lên 300MB sau khi navigate giữa ProductList và ProductDetail 10 lần."

# UI glitch
"/ttb-bugfix — nhãn giá ở ProductCell chồng lên nút mua trên iPhone SE (màn hình nhỏ)."

# API error
"/ttb-bugfix — màn hình ProductList hiển thị empty state dù API trả về data. Console hiển thị 'decoding error'."
```

### Bug Fix Workflow

```
1. Root Cause Analysis (5 Whys)
   Why → Why → Why → Why → Why

2. Fix Strategy Decision
   - Minimal fix (thay đổi ít nhất có thể)
   - Tránh tạo pattern mới
   - Tránh break code hiện có

3. Implement Fix
   - Chỉ thay đổi root cause
   - Không refactor trừ khi cần thiết

4. Verify Fix
   - xcodebuild phải thành công
   - Regression check — features hiện có vẫn hoạt động

5. Document
   - Root cause
   - Fix đã áp dụng
   - Kết quả verification
```

### Luật quan trọng cho Bug Fixing

- ✅ **Root cause trước** — không bao giờ patch symptoms
- ✅ **Minimal fix** — thay đổi ít nhất có thể
- ✅ **Zero regression** — code hiện có vẫn hoạt động
- ✅ **xcodebuild** sau mỗi fix
- ✅ **Anti-loop: max 3 attempts** — nếu 3 builds fail, escalate

---

## 7. /ttb-refactor — Refactoring Code

### Khi nào dùng

- Migrating **raw UIKit** sang TTBaseUIKit components
- Migrating **raw UIKit ViewController** sang `TTViewCodable`
- Migrating **native SwiftUI** sang TTBaseSUI components
- Cải thiện **MVVM separation** (ViewModel có business logic nhưng import UIKit)
- Giảm **code duplication** giữa các features

### Prompts có sẵn

| Prompt | Dùng khi |
|--------|----------|
| `/ttb-refactor-uikit` | UIKit → TTViewCodable, TTBaseUIKit migration |
| `/ttb-refactor-swiftui` | Native SwiftUI → TTBaseSUI migration |

### Cách viết Prompt

```bash
# UIKit refactor
"/ttb-refactor-uikit — migrate ProductDetailViewController cũ dùng UILabel() và UIButton() sang TTBaseUIKit components và TTViewCodable"

# SwiftUI refactor
"/ttb-refactor-swiftui — migrate ProductListScreen dùng native SwiftUI Text và Button sang TTBaseSUI components"

# MVVM separation
"/ttb-refactor — ProductViewModel import UIKit và có view-related logic. Tách biệt concerns."
```

### Refactor Workflow

```
1. Analyze Code
   - Identify raw UIKit usage
   - Identify missing TTViewCodable
   - Identify MVVM violations

2. Plan Migration
   - Map raw components → TTBaseUIKit equivalents
   - Plan TTViewCodable implementation
   - Plan file structure

3. Implement Migration
   - One file at a time
   - Verify after each file

4. Verify
   - xcodebuild phải thành công
   - Tất cả features vẫn hoạt động
```

### Luật quan trọng cho Refactoring

- ✅ **Một thay đổi tại một thời điểm** — verify sau mỗi lần
- ✅ **Không rewrite tất cả** — migrate từ từ
- ✅ **Giữ nguyên behavior hiện tại** — không thêm features mới trong refactor
- ✅ **xcodebuild** sau mỗi bước migration
- ✅ **FCR compliance** — code đã migrate phải đạt ≥ 85%

---

## 8. /ttb-audit — Kiểm tra Code

### Khi nào dùng

- **Trước khi release** — verify code quality
- **Sau khi thêm feature lớn** — catch issues sớm
- **Performance issues** — app chậm hoặc tốn pin
- **Accessibility issues** — app không dùng được với VoiceOver
- **Localization issues** — thiếu strings, inconsistent keys

### Prompts có sẵn

| Prompt | Dùng khi |
|--------|----------|
| `/ttb-audit-performance` | Rendering speed, memory, CPU, main thread blocking |
| `/ttb-audit-accessibility` | VoiceOver, Dynamic Type, color contrast, touch targets |
| `/ttb-audit-localization` | Hardcoded strings, missing keys, naming violations |

### Cách viết Prompt

```bash
# Performance audit
"/ttb-audit-performance — audit màn hình ProductList về performance issues. App scroll ở 30fps thay vì 60fps."

# Accessibility audit
"/ttb-audit-accessibility — full accessibility audit của tất cả màn hình. Tập trung vào ProductList và ProductDetail."

# Localization audit
"/ttb-audit-localization — tìm tất cả hardcoded strings trong codebase nên dùng XText/XTextU."
```

### Audit Workflow

```
1. Define Scope
   - Toàn bộ code hay specific features?
   - Specific issue hay general audit?

2. Run Audit Checks
   - Performance: Instruments, code analysis
   - Accessibility: VoiceOver, size classes
   - Localization: grep for hardcoded strings

3. Score with FCR 7-Dimension
   - ≥ 85% → READY
   - 70-84% → NEEDS FIX
   - < 70% → BLOCKED

4. Apply Fixes
   - Fix issues found
   - Re-verify

5. Report
   - Issues found
   - FCR score
   - Recommendation
```

### Luật quan trọng cho Auditing

- ✅ **Comprehensive** — check tất cả dimensions
- ✅ **Evidence-based** — cite specific files và lines
- ✅ **Actionable** — mỗi issue có một fix
- ✅ **FCR scoring** — phải document score
- ✅ **Post-fix verification** — `BUILD SUCCEEDED` sau khi fix

---

## 9. Cách viết Prompt hiệu quả

### ✅ Cấu trúc Prompt tốt

```
/{command} — {WHAT} {SCREEN/FEATURE NAME} with {KEY FEATURES}
```

### ✅ Ví dụ Prompt tốt

```bash
/ttb-uikit-screen — tạo màn hình UserProfile với avatar, tên, email, nút edit, và nút logout

/ttb-sui-screen — tạo ShoppingCartScreen với danh sách items, quantity stepper, subtotal, và nút checkout

/ttb-native-card — tạo ProductCard với ảnh (120x120), tiêu đề (2 dòng), giá, và icon thêm vào giỏ

/ttb-bugfix — nút checkout không hoạt động khi bấm. Không crash, nhưng tổng tiền cart không tăng.

/ttb-audit-performance — HomeScreen load trong 3 giây trên iPhone 11. Tìm và fix bottlenecks.
```

### ❌ Ví dụ Prompt tệ

```bash
# Quá mơ hồ
"/ttb-uikit — làm một màn hình"
"/ttb-sui — làm cái gì đó với sản phẩm"

# Quá dài mà không có cấu trúc
"/ttb-uikit-screen — tôi cần tạo một màn hình chi tiết sản phẩm cho app iOS của tôi dùng TTBaseUIKit. Màn hình này nên hiển thị ảnh sản phẩm ở trên cùng, rồi tiêu đề sản phẩm bằng chữ đậm lớn..."

# Thiếu context
"/ttb-sui-screen — tạo một danh sách"  (danh sách gì? sản phẩm? người dùng? đơn hàng?)
```

### Tips về Context

| Thông tin | Tại sao cần |
|-----------|-------------|
| Tên screen/feature | Agent biết đặt tên file |
| Các UI elements chính | Agent biết dùng components nào |
| User interaction | Agent biết wire callbacks nào |
| Data source | Agent biết là API hay local DB |
| Navigation context | Agent biết screen nằm ở đâu trong flow |
| Constraints | Screen size, localization, accessibility needs |

---

## 10. Tổng kết Workflow

### Feature Development Flow

```
┌──────────────────────────────────────────────────────────┐
│  1. INIT (một lần)                                       │
│     /ttb-init                                           │
│     └── Setup project, TTBaseUIKitConfig, localization  │
└──────────────────────────────────────────────────────────┘
                          ↓
┌──────────────────────────────────────────────────────────┐
│  2. FEATURE RESEARCH (Phase 1)                          │
│     Analyze existing code, find patterns, assess scope   │
│     └── Feature Research Report                          │
└──────────────────────────────────────────────────────────┘
                          ↓
┌──────────────────────────────────────────────────────────┐
│  3. FEATURE SPEC (Phase 2)                              │
│     Define data model, files, navigation, API contract   │
│     └── Approved Spec                                   │
└──────────────────────────────────────────────────────────┘
                          ↓
┌──────────────────────────────────────────────────────────┐
│  4. IMPLEMENTATION (Phase 4)                            │
│     Generate files one-by-one → xcodebuild each          │
│     └── Generated Files                                  │
└──────────────────────────────────────────────────────────┘
                          ↓
┌──────────────────────────────────────────────────────────┐
│  5. CODE REVIEW (Phase 5)                               │
│     FCR 7-Dimension audit across all files              │
│     └── Issues List                                     │
└──────────────────────────────────────────────────────────┘
                          ↓
┌──────────────────────────────────────────────────────────┐
│  6. VERIFICATION (Phase 6) ← BẮT BUỘC                  │
│     xcodebuild + compliance + regression + FCR score     │
│     └── ✅ BUILD SUCCEEDED + FCR ≥ 85% → COMPLETE      │
└──────────────────────────────────────────────────────────┘
```

### Skill Command Cheat Sheet

| Task | Command | Prompt Example |
|------|---------|----------------|
| Dự án mới | `/ttb-init` | "Khởi tạo MyApp với TTBaseUIKit" |
| UIKit screen | `/ttb-uikit-screen` | "ProductDetail với ảnh, tiêu đề, giá" |
| UIKit list | `/ttb-uikit-list` | "ProductList với pull-to-refresh" |
| UIKit cell | `/ttb-uikit-cell` | "ProductCell với ảnh 56x56" |
| UIKit API | `/ttb-uikit-api` | "ProductAPI cho getProducts" |
| UIKit coordinator | `/ttb-uikit-coordinator` | "ProductCoordinator" |
| SwiftUI screen | `/ttb-sui-screen` | "HomeScreen với banner + grid" |
| SwiftUI view | `/ttb-sui-view` | "ProductCardView" |
| SwiftUI list | `/ttb-sui-list` | "ProductListScreen lazy loading" |
| SwiftUI ViewModel | `/ttb-sui-viewmodel` | "ProductListViewModel" |
| Native SwiftUI | `/native-{component}` | "/native-chart — biểu đồ cột" |
| Sửa bug | `/ttb-bugfix` | "Số badge cart không cập nhật" |
| UIKit refactor | `/ttb-refactor-uikit` | "Migrate sang TTViewCodable" |
| SwiftUI refactor | `/ttb-refactor-swiftui` | "Migrate sang TTBaseSUI" |
| Performance audit | `/ttb-audit-performance` | "HomeScreen load trong 3s" |
| Accessibility audit | `/ttb-audit-accessibility` | "VoiceOver trên ProductList" |
| Localization audit | `/ttb-audit-localization` | "Tìm hardcoded strings" |

---

**Bước tiếp theo**: Đọc `SKILL.md` để xem complete skill documentation, hoặc `README.md` để xem system overview.
