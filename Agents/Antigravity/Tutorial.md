---
name: "antigravity-tutorial"
description: "Comprehensive tutorial for TTBaseUIKit Antigravity agents: when to use each skill, what prompts to use, and practical examples. English version."
version: "2.0.0"
---

# Antigravity Agent System — Tutorial

**Version**: 2.0.0 | **Prerequisite**: Read `README.md` first

This tutorial explains **when to use** each skill, **which prompt to activate**, and **how to write effective prompts** for each scenario.

---

## Table of Contents

1. [Skill Selection Decision Tree](#1-skill-selection-decision-tree)
2. [/ttb-init — New Project Setup](#2-ttb-init--new-project-setup)
3. [/ttb-uikit — UIKit Development](#3-ttb-uikit--uikit-development)
4. [/ttb-swiftui — SwiftUI Development](#4-ttb-swiftui--swiftui-development)
5. [/ttb-native-* — Native SwiftUI Components](#5-ttb-native---native-swiftui-components)
6. [/ttb-bugfix — Bug Fixing](#6-ttb-bugfix--bug-fixing)
7. [/ttb-refactor — Code Refactoring](#7-ttb-refactor--code-refactoring)
8. [/ttb-audit — Code Auditing](#8-ttb-audit--code-auditing)
9. [Prompt Writing Best Practices](#9-prompt-writing-best-practices)
10. [Workflow Summary](#10-workflow-summary)

---

## 1. Skill Selection Decision Tree

```
What do you need to do?
│
├── ① Create a NEW PROJECT from scratch
│   └── → /ttb-init
│
├── ② Add a NEW FEATURE
│   │
│   ├── Using UIKit (ViewController)?
│   │   └── → /ttb-uikit
│   │
│   └── Using SwiftUI?
│       │
│       ├── Does the current app have a UIKit navigation stack?
│       │   ├── YES → SwiftUI screens use backType = .POP
│       │   └── NO → Pure SwiftUI, use backType = .SWIFTUI
│       │
│       ├── Is there a TTBaseSUI component available?
│       │   ├── YES → /ttb-sui-screen, /ttb-sui-view, /ttb-sui-list
│       │   └── NO → Check /ttb-native-*
│       │
│       ├── Need an atomic component?
│       │   └── → /native-{component-name} (18 types)
│       │
│       └── Need a full screen/view?
│           └── → /ttb-native-screen, /ttb-native-view
│
├── ③ Fix a BUG
│   └── → /ttb-bugfix
│
├── ④ Improve EXISTING CODE
│   │
│   ├── Raw UIKit → TTBaseUIKit
│   │   └── → /ttb-refactor-uikit
│   │
│   └── Native SwiftUI → TTBaseSUI
│       └── → /ttb-refactor-swiftui
│
└── ⑤ Audit CODE
    ├── Performance
    │   └── → /ttb-audit-performance
    ├── Accessibility
    │   └── → /ttb-audit-accessibility
    └── Localization
        └── → /ttb-audit-localization
```

---

## 2. /ttb-init — New Project Setup

### When to Use

- **First time** setting up a new iOS project with TTBaseUIKit
- **Migrate** an existing project to TTBaseUIKit architecture
- **Reconfigure** an existing TTBaseUIKit project (add localization, update config)

### Prompts Available

| Prompt | Use When |
|--------|----------|
| `/ttb-init` | Full project initialization (all phases) |
| `/ttb-init-structure` | Only MVVM-C folder structure setup |
| `/ttb-init-config` | Only TTBaseUIKitConfig + dependency setup |
| `/ttb-init-l10n` | Only localization (XText/XTextU) setup |
| `/ttb-init-debug` | Only TTBDebugPlus integration |

### How to Prompt

```
# Basic
"/ttb-init — init a new iOS project called MyApp with TTBaseUIKit"

# Specific phases only
"/ttb-init — set up MVVM-C folder structure for MyApp"
"/ttb-init — configure TTBaseUIKit with SPM for MyApp"
"/ttb-init — set up localization with XText/XTextU for MyApp"
```

### What Gets Created

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

### Prompts Output

After `/ttb-init`, the agent will:

1. Create MVVM-C folder structure
2. Configure `TTBaseUIKitConfig` with design tokens
3. Set up `Localizable.strings` with `XText`/`XTextU`
4. Integrate `TTBDebugPlus` (optional)
5. Run `xcodebuild` to verify — must succeed

---

## 3. /ttb-uikit — UIKit Development

### When to Use

- Building **new screens** using UIKit `ViewController`
- Building **lists** (`UITableView`, `UICollectionView`)
- Building **forms** with text inputs and validation
- Building **custom cells** and **custom views**
- Creating **API services** and **coordinators**

### Prompts Available

| Prompt | Use When |
|--------|----------|
| `/ttb-uikit-screen` | Full screen: ViewController + ViewModel + TTViewCodable |
| `/ttb-uikit-list` | UITableView / UICollectionView screen |
| `/ttb-uikit-form` | Form with text fields + validation |
| `/ttb-uikit-cell` | UITableViewCell or UICollectionViewCell |
| `/ttb-uikit-customview` | Reusable custom UIView component |
| `/ttb-uikit-api` | API service singleton |
| `/ttb-uikit-coordinator` | Navigation coordinator |
| `/ttb-uikit-viewmodel` | ViewModel with callbacks |

### How to Prompt

```
# Full screen
"/ttb-uikit-screen — create a ProductDetail screen with image, title, price, add-to-cart button"

# List screen
"/ttb-uikit-list — create a ProductList screen with pull-to-refresh, pagination, search bar"

# Cell
"/ttb-uikit-cell — create a ProductCell with image (56x56), title (2 lines), subtitle, price"

# API
"/ttb-uikit-api — create ProductAPI service for getProducts, getProduct(id), createOrder"

# Coordinator
"/ttb-uikit-coordinator — create ProductCoordinator that navigates to ProductList and ProductDetail"
```

### UIKit Screen Template

Every UIKit screen follows this pattern:

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
        setupStyles()
        setupConstraints()
        setupData()
        bindComponents()
        viewModel.loadProduct()
    }

    // MARK: - TTViewCodable
    func setupUI() { /* addSubview + constraints */ }
    func setupData() { /* set initial data */ }
    func setupStyles() { /* colors from tokens */ }
    func setupConstraints() { /* TTBaseUIKit chains ending .done() */ }
    func bindComponents() {
        viewModel.onProductLoaded = { [weak self] product in
            self?.updateUI(with: product)
        }
    }
}
```

### Key Rules for UIKit

- ✅ Every VC must implement `TTViewCodable` (6 methods)
- ✅ Use `TTBaseUI*` components (TTBaseUILabel, TTBaseUIButton, etc.)
- ✅ ViewModel never imports UIKit
- ✅ Every closure uses `[weak self]`
- ✅ All strings use `XText("key")` or `XTextU("key")`
- ✅ Every constraint chain ends with `.done()`
- ✅ Every `RequestData` calls `super.encode(to:)`

### ⚠️ Anti-pattern: Non-Existent APIs

**NEVER use these fake APIs:**

```swift
// ❌ Wrong — does NOT exist:
TTBaseFunc.shared.printLog(with: "...", object: nil)                  // → TTBaseFunc.shared.printLog(...)
BaseShadowPanelView()         // → TTBaseShadowPanelView()
BaseUIViewController           // → TTBaseUIViewController<TTBaseUIView>
lbl.setTextString(...)        // → lbl.setText(...)
.btn.setTextString(...)       // → btn.setText(...)

// ✅ Correct:
TTBaseFunc.shared.printLog(...)
TTBaseShadowPanelView()
TTBaseUIViewController<TTBaseUIView>
lbl.setText(text: "...")
btn.setText(text: "...")
```

---

## 4. /ttb-swiftui — SwiftUI Development

### When to Use

- Building **new screens** using SwiftUI
- Building **reusable SwiftUI views**
- Building **SwiftUI lists** with TTBaseSUI components
- Building **SwiftUI ViewModels**

### Three-Tier Approach

| Tier | When to Use | Commands |
|------|-------------|----------|
| **Tier 1 — TTBaseSUI** | TTBaseSUI component exists | `/ttb-sui-screen`, `/ttb-sui-view`, `/ttb-sui-list` |
| **Tier 2 — Chainable Modifiers** | Styling, layout, spacing, effects | `.pAll()`, `.bg()`, `.corner()`, `.baseShadow()`, etc. |
| **Tier 3 — Native SwiftUI** | TTBaseSUI has no equivalent | `/ttb-native-screen`, `/ttb-native-view` |

### Prompts Available

| Prompt | Use When |
|--------|----------|
| `/ttb-sui-screen` | SwiftUI screen with SUIBaseView wrapper |
| `/ttb-sui-view` | Reusable TTBaseSUI view |
| `/ttb-sui-list` | SwiftUI list with TTBaseSUILazyVStack |
| `/ttb-sui-viewmodel` | SwiftUI ViewModel with @Published |
| `/ttb-native-screen` | Native SwiftUI screen (fallback when TTBaseSUI lacks component) |
| `/ttb-native-view` | Native SwiftUI reusable view (fallback) |

### How to Prompt

```
# TTBaseSUI screen
"/ttb-sui-screen — create a HomeScreen with banner carousel, product grid (2 columns), and a bottom tab bar"

# TTBaseSUI view
"/ttb-sui-view — create a ProductCardView with image, title, price, and add-to-cart button"

# SwiftUI list
"/ttb-sui-list — create a ProductListScreen with pull-to-refresh, lazy loading, and search bar"

# ViewModel
"/ttb-sui-viewmodel — create a ProductListViewModel with search, filter, and pagination"

# Native SwiftUI (fallback)
"/ttb-native-screen — create a ChartScreen with a custom bar chart using only native SwiftUI"
```

### SwiftUI Screen Template (MANDATORY)

**Every SwiftUI screen MUST use `SUIBaseView` as wrapper.**

```swift
// ProductDetailScreen.swift
struct ProductDetailScreen: View {
    @StateObject private var viewModel = ProductDetailViewModel()
    let productId: Int

    var body: some View {
        SUIBaseView(
            backType: .SWIFTUI,
            title: XText("Product.Detail.Nav.Title"),
            type: .DEFAULT,
            isHiddenTabbar: true,
            backAction: {}
        ) {
            TTBaseSUIVStack(alignment: .center, spacing: TTSize.P_CONS_DEF) {
                TTBaseSUIAsyncImage(urlString: viewModel.product?.imageUrl)
                    .frame(height: TTSize.W * 0.6)
                    .corner(byDef: TTSize.CORNER_PANEL)

                TTBaseSUIText(
                    withType: .HEADER,
                    text: viewModel.product?.title ?? ""
                )

                TTBaseSUIText(
                    withType: .TITLE,
                    text: viewModel.product?.price ?? ""
                )
                .foregroundColor(TTView.buttonBgWar.toColor())

                TTBaseSUIButton(type: .DEFAULT, title: XText("Product.Detail.AddToCart")) {
                    viewModel.addToCart()
                }
            }
        }
        .onAppear { viewModel.loadProduct(id: productId) }
    }
}
```

### SUIBaseView Parameters (MANDATORY)

```swift
SUIBaseView(
    backType: BACK_TYPE,       // .SWIFTUI | .POP | .POP_TO_ROOT | .DISMISS | .DISMISS_ALL | .CLOSE_FLOW
    title: String,             // Navigation bar title
    type: TYPE,                // .DEFAULT | .INFO | .NO_NAV
    isHiddenTabbar: Bool,      // Hide/show tabbar on screen
    backAction: (() -> Void)?, // Callback on back press
    titleAction: (() -> Void)?, // Callback on title press
    rightAction: (() -> Void)?, // Callback on right button press
    bg: Color,                 // Background color
    @ViewBuilder content: () -> Content
)
```

### TTBaseSUI Component Reference (Complete)

#### Text Components

```swift
TTBaseSUIText(withType: .HEADER_SUPER, text: "...", align: .center)
TTBaseSUIText(withType: .HEADER, text: "...", align: .leading)
TTBaseSUIText(withType: .TITLE, text: "...", align: .leading)
TTBaseSUIText(withType: .SUB_TITLE, text: "...", align: .leading)
TTBaseSUIText(withType: .SUB_SUB_TITLE, text: "...", align: .leading)

TTBaseSUIText(withBold: .HEADER, text: "...", align: .center, color: .white)
```

#### Button Component

```swift
TTBaseSUIButton(type: .DEFAULT, title: "CONFIRM")
TTBaseSUIButton(type: .DEFAULT_COLOR(color: .systemBlue, textColor: .white), title: "CUSTOM")
TTBaseSUIButton(type: .WARRING, title: .DELETE")
TTBaseSUIButton(type: .DISABLE, title: "DISABLED")
TTBaseSUIButton(type: .NO_BG_COLOR, title: "LINK")
TTBaseSUIButton(type: .BORDER, title: "OUTLINE")
```

#### Stack Components

```swift
TTBaseSUIVStack(alignment: .center, spacing: TTSize.P_CONS_DEF) { }
TTBaseSUIVStack(alignment: .center, spacing: TTSize.P_CONS_DEF, bg: .clear) { }
TTBaseSUIVStack(alignment: .center, spacing: TTSize.P_CONS_DEF, bg: .clear, radius: 8) { }
TTBaseSUIHStack(alignment: .center, spacing: TTSize.P_CONS_DEF) { }
TTBaseSUIZStack(alignment: .center, bg: .clear) { }
```

#### Scroll Components

```swift
TTBaseSUIScroll(alignment: .vertical, showIndicators: false) { }
TTBaseSUIScroll(alignment: .vertical, bg: .clear, isEnablePullToRefresh: true) {
    // content
} pullToRefresh: {
    viewModel.fetch()
}

TTBaseSUILazyVStack(alignment: .leading, spacing: TTSize.P_CONS_DEF, bg: .clear) { }
TTBaseSUILazyHStack(alignment: .center, spacing: TTSize.P_CONS_DEF) { }
TTBaseSUILazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) { }
TTBaseSUILazyHGrid(rows: [GridItem(.fixed(60)), GridItem(.fixed(60))], spacing: 8) { }
```

#### Grid Components

```swift
let columns = [GridItem(.flexible()), GridItem(.flexible())]
TTBaseEqualHeightGridView(items: products, columns: columns) { product in
    ProductCard(product: product)
}
```

#### Image Components

```swift
TTBaseSUIImage(withname: "icon_name")
TTBaseSUIImage(withname: "icon_name", conner: TTSize.CORNER_RADIUS)
TTBaseSUIImage(withSystemName: "star.fill", iconColor: .orange, contentMode: .fit)
TTBaseSUICircleImage(withname: "avatar")
TTBaseSUICircleImage(withname: "avatar", conner: TTSize.CORNER_IMAGE)
TTBaseSUIAsyncImage(urlString: product.avatarUrl)
TTBaseSUIAsyncImage(urlString: product.avatarUrl, type: .CIRCLE).sizeSquare(width: 60)
```

#### Divider Components

```swift
TTBaseSUIHorizontalDividerView(noConner: .LINE)           // Thin line
TTBaseSUIHorizontalDividerView(noConner: .SPACE)         // Spacer
TTBaseSUIHorizontalDividerView(withConner: 4, type: .SPACE)
TTBaseSUIVerticalDividerView(noConner: .LINE)             // Vertical thin line
TTBaseSUIVerticalDividerView(noConner: .SPACE)            // Vertical spacer
```

#### Spacer

```swift
TTBaseSUISpacer()                           // Fill available space
TTBaseSUISpacer(maxHeight: 20)              // Fixed height spacer
TTBaseSUISpacer(maxWidth: 50)               // Fixed width spacer
TTBaseSUISpacer(withBg: .green, radius: 8)  // Colored spacer fill
```

#### Container View

```swift
TTBaseSUIView(withCornerRadius: 0) { }
TTBaseSUIView(withCornerRadius: TTSize.CORNER_PANEL, bg: .white) { }
```

#### Form Components

```swift
TTBaseSUITextField(placeholder: "Enter name", text: $name)
TTBaseSUITextField(placeholder: "Password", text: $password, isSecure: true)
TTBaseSUITextField(placeholder: "Search...", text: $query, type: .SEARCH)
TTBaseSUITextField(placeholder: "Email", text: $email, type: .BORDER)
TTBaseSUITextField(placeholder: "Phone", text: $phone, type: .UNDERLINE)
TTBaseSUIToggle(label: "Enable notifications", isOn: $isEnabled)
TTBaseSUIToggle(label: "Dark mode", isOn: $isDark, type: .ICON(name: "moon.fill"))
TTBaseSUISlider(value: $volume)
TTBaseSUISlider(value: $brightness, in: 0...100, step: 5)
TTBaseSUISlider(value: $size, in: 0...1, type: .WITH_LABELS(min: "0%", max: "100%"))
```

#### List Components

```swift
TTBaseSUIList(type: .PLAIN) {
    ForEach(items) { item in RowView(item: item) }
}
TTBaseSUIList(type: .GROUPED, isEnablePullToRefresh: true) {
    ForEach(items) { item in RowView(item: item) }
} pullToRefresh: {
    viewModel.reload()
}
```

#### Tab Components

```swift
TTBaseSUITabView(selection: $currentPage, type: .PAGE) {
    ForEach(pages) { page in PageView(page: page).tag(page.id) }
}
TTBaseSUITabView(selection: $idx, type: .PAGE_HIDDEN_DOTS) { ... }
TTBaseSUITabView(type: .DEFAULT) {
    HomeView().tabItem { Label("Home", systemImage: "house") }.tag(0)
    SettingsView().tabItem { Label("Settings", systemImage: "gear") }.tag(1)
}
```

#### Group Component

```swift
TTBaseSUIGroup { }                              // Transparent group
TTBaseSUIGroup(bg: .white, radius: 8) { }      // Group with bg + radius
TTBaseSUIGroup(bg: .white, radius: 8, padding: TTSize.P_CONS_DEF) { }
```

### Chainable Modifiers (MANDATORY)

**Always use chainable extensions in modifier chains. They return `some View` and chain correctly.**

#### Padding Extensions

```swift
.pAll(TTSize.P_CONS_DEF)                // all sides padding
.pAll(.horizontal, TTSize.P_CONS_DEF)    // horizontal only
.pAll(.vertical, TTSize.P_CONS_DEF)      // vertical only
.pHorizontal(TTSize.P_CONS_DEF)          // horizontal only (default: 8pt)
.pVertical(TTSize.P_CONS_DEF)            // vertical only (default: 8pt)
.pTop(TTSize.P_CONS_DEF)                // top only (default: 8pt)
.pBottom(TTSize.P_CONS_DEF)             // bottom only (default: 8pt)
.pLeading(TTSize.P_CONS_DEF)             // leading only (default: 8pt)
.pTrailing(TTSize.P_CONS_DEF)            // trailing only (default: 8pt)
```

#### Background & Corner Extensions

```swift
.bg(byDef: TTView.viewBgCellColor.toColor())  // background from token
.bg(byUIColor: TTView.viewBgColor)           // UIColor version
.corner(byDef: TTSize.CORNER_PANEL)         // corner radius from token
```

#### Shadow & Border Extensions

```swift
.baseShadow()                                      // default card shadow
.baseShadow(corner: 8, color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
.baseBorder(color: TTView.lineDefColor.toColor(), width: TTSize.H_LINEVIEW, radius: TTSize.CORNER_RADIUS)
```

#### Size Extensions

```swift
.size(width: 120)                         // set width
.size(height: 40)                         // set height
.size(width: 100, height: 40)           // set both
.sizeSquare(width: 50)                    // square frame
.maxWidth()                               // fill width
.maxWidth(alignment: .leading)            // fill width, align left
.maxHeight()                               // fill height
```

#### Interactive Extensions

```swift
.onTapHandle { action() }                // tap gesture (DO NOT use onTapGesture for buttons)
.skeleton(active: true)                   // shimmer loading
.skeleton(active: true, isShimmering: false)
.disabled(true)
.opacity(0.5)
.hidden(someCondition)                    // conditional hide
.showNoticeView(title: "Error", body: "Something went wrong", style: .ERROR)
```

#### Layout Extensions

```swift
.fixedByHorizontal()                     // fixed width, free height
.fixedByVertical()                        // fixed height, free width
.fixedByAutoSize()                       // fixed both
.layoutPriority(1)
```

#### Skeleton + Glass Effects

```swift
.skeleton(active: isLoading)
.enableGlassEffectV2(isClear: false, cornerRadius: 16) { WhiteLiquidGlassBackground(cornerRadius: 16) }
.enableGlassEffect(cornerRadius: 16) { BlackLiquidGlassBackground(cornerRadius: 16) }
```

#### Keyboard & Navigation Helpers

```swift
.hideKeyboardOnScroll()
.hiddenNavigationBar()
```

### Key Rules for SwiftUI

- ✅ Every screen MUST wrap in `SUIBaseView`
- ✅ Navigation between screens MUST use `TTBaseNavigationLink`
- ✅ Use `TTView`, `TTSize`, `TTFont` for all tokens
- ✅ ViewModel never imports SwiftUI
- ✅ Every closure uses `[weak self]`
- ✅ All strings use `XText("key")` or `XTextU("key")`
- ✅ iOS 14+ APIs only
- ✅ Chainable extensions: prefer `.pAll()`, `.bg()`, `.corner()`
- ✅ Body < 40 lines — extract subviews if longer
- ✅ TTBaseSUI FIRST — only Native SwiftUI when no equivalent exists

---

## 5. /ttb-native-* — Native SwiftUI Components

### When to Use

TTBaseSUI **lacks** a component for your need. Examples:
- Custom charts and graphs
- Advanced shapes and paths
- Custom animations
- Complex gesture recognizers
- Third-party SwiftUI libraries

### Two Command Groups

#### Group 1: Atomic Components (`/native-*`)

Use when building **reusable atomic component** not available in TTBaseSUI.

| Prompt | Component | Use When |
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
| `/native-icon` | Icon | SF Symbol with color/size |
| `/native-bottom-sheet` | Bottom sheet | Slide-up panel |
| `/native-empty-state` | Empty state | Illustration + message + action |
| `/native-loading` | Loading | Spinner, shimmer, skeleton |
| `/native-chip` | Chip/tag | With states |
| `/native-avatar` | Avatar | Image, initials, status |
| `/native-rating` | Rating | Star rating, interactive/display |
| `/native-section-header` | Section header | With optional action |
| `/native-snackbar` | Snackbar/toast | Bottom notification |
| `/native-alert` | Alert | Confirmation dialog |

#### Group 2: Screen-Level Fallback (`/ttb-native-*`)

Use when building **entire screen** where TTBaseSUI doesn't provide enough layout primitives.

| Prompt | Use When |
|--------|----------|
| `/ttb-native-screen` | Full screen with custom layout, complex animations |
| `/ttb-native-view` | Reusable view with custom layout not in TTBaseSUI |

### Comparison: `/native-*` vs `/ttb-native-*`

| | `/native-*` | `/ttb-native-*` |
|--|-------------|----------------|
| Scope | Reusable atomic component | Full screen/view |
| Usage | Inside TTBaseSUI views or screens | Entire screen layout |
| Example | Custom badge, chip, chart | Complex screen with custom animation |
| SUIBaseView | Not needed | Needs SUIBaseView wrapper |

### How to Prompt

```
# Text
"/native-text — create a BadgeText component that displays a colored label with rounded corners"

# Button
"/native-button — create a PrimaryButton with 40pt height, corner radius 4, background color from TTView.buttonBgDef"

# Card
"/native-card — create a TappableCard that shows product image, title, price, and highlights on press"

# Rating
"/native-rating — create a StarRating component with 5 stars, half-star support, and tap to change"

# Empty state
"/native-empty-state — create an EmptyStateView with illustration, message, and optional action button"
```

### Native SwiftUI Template

```swift
// BadgeText.swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  BadgeText.swift
//  AppName
//  ⚠️ NATIVE SWIFTUI: Use when TTBaseSUI has no component
//
import SwiftUI
import TTBaseUIKit

// MARK: - BadgeTextComponent
public struct BadgeText: View {
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

    public var body: some View {
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

### Key Rules for Native SwiftUI

- ✅ Use `TTView`, `TTSize`, `TTFont` tokens for all styling
- ✅ iOS 14+ APIs only (no `.foregroundStyle()`, no `NavigationStack`, etc.)
- ✅ Always include `PreviewProvider` for iOS 14-16 compatibility
- ✅ Include marker comment at top of file
- ✅ When TTBaseSUI has the component → use `/ttb-sui-*` instead
- ✅ Use `Button` for tappable views — DO NOT use `onTapGesture`
- ✅ Minimum 44×44 tap target for interactive elements
- ✅ Body < 40 lines — extract sub-views

---

## 6. /ttb-bugfix — Bug Fixing

### When to Use

- App **crashes** on a specific screen
- **Logic error** — app doesn't behave as expected
- **Memory leak** — app crashes after extended use
- **UI glitch** — layout is broken or element is missing
- **API error** — network call fails or returns wrong data

### How to Prompt

```
# Crash
"/ttb-bugfix — app crashes when tapping the Add-to-Cart button on ProductDetail screen. Crash log attached."

# Logic error
"/ttb-bugfix — cart badge count doesn't update after adding item. It only updates after pulling to refresh."

# Memory leak
"/ttb-bugfix — memory usage grows from 50MB to 300MB after navigating between ProductList and ProductDetail 10 times."

# UI glitch
"/ttb-bugfix — the price label on ProductCell overlaps the buy button on iPhone SE (small screen)."

# API error
"/ttb-bugfix — the ProductList screen shows empty state even when API returns data. Console shows 'decoding error'."
```

### Bug Fix Workflow

```
1. Root Cause Analysis (5 Whys)
   Why → Why → Why → Why → Why

2. Fix Strategy Decision
   - Minimal fix (change as little as possible)
   - Avoid creating new patterns
   - Avoid breaking existing code

3. Implement Fix
   - Change only the root cause
   - No refactoring unless necessary

4. Verify Fix
   - xcodebuild must succeed
   - Regression check — existing features still work

5. Document
   - Root cause
   - Fix applied
   - Verification result
```

### Key Rules for Bug Fixing

- ✅ **Root cause first** — never patch symptoms
- ✅ **Minimal fix** — change as little as possible
- ✅ **Zero regression** — existing code still works
- ✅ **xcodebuild** after every fix
- ✅ **Anti-loop: max 3 attempts** — if 3 builds fail, escalate

---

## 7. /ttb-refactor — Code Refactoring

### When to Use

- Migrating **raw UIKit** to TTBaseUIKit components
- Migrating **raw UIKit ViewController** to `TTViewCodable`
- Migrating **native SwiftUI** to TTBaseSUI components
- Improving **MVVM separation** (ViewModel has business logic but imports UIKit)
- Reducing **code duplication** across features

### Prompts Available

| Prompt | Use When |
|--------|----------|
| `/ttb-refactor-uikit` | UIKit → TTViewCodable, TTBaseUIKit migration |
| `/ttb-refactor-swiftui` | Native SwiftUI → TTBaseSUI migration |

### How to Prompt

```
# UIKit refactor
"/ttb-refactor-uikit — migrate the old ProductDetailViewController that uses UILabel() and UIButton() to TTBaseUIKit components and TTViewCodable"

# SwiftUI refactor
"/ttb-refactor-swiftui — migrate the ProductListScreen that uses native SwiftUI Text and Button to TTBaseSUI components"

# MVVM separation
"/ttb-refactor — the ProductViewModel imports UIKit and has view-related logic. Separate concerns."
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
   - xcodebuild must succeed
   - All features still work
```

### Key Rules for Refactoring

- ✅ **One change at a time** — verify after each
- ✅ **Don't rewrite everything** — migrate incrementally
- ✅ **Preserve existing behavior** — no new features during refactor
- ✅ **xcodebuild** after every migration step
- ✅ **FCR compliance** — migrated code must score ≥ 85%

---

## 8. /ttb-audit — Code Auditing

### When to Use

- **Before release** — verify code quality
- **After major feature** — catch issues early
- **Performance issues** — app is slow or battery drain
- **Accessibility issues** — app not usable with VoiceOver
- **Localization issues** — missing strings, inconsistent keys

### Prompts Available

| Prompt | Use When |
|--------|----------|
| `/ttb-audit-performance` | Rendering speed, memory, CPU, main thread blocking |
| `/ttb-audit-accessibility` | VoiceOver, Dynamic Type, color contrast, touch targets |
| `/ttb-audit-localization` | Hardcoded strings, missing keys, naming violations |

### How to Prompt

```
# Performance audit
"/ttb-audit-performance — audit the ProductList screen for performance issues. App scrolls at 30fps instead of 60fps."

# Accessibility audit
"/ttb-audit-accessibility — full accessibility audit of all screens. Focus on ProductList and ProductDetail."

# Localization audit
"/ttb-audit-localization — find all hardcoded strings in the codebase that should use XText/XTextU."
```

### Audit Workflow

```
1. Define Scope
   - All code or specific features?
   - Specific issue or general audit?

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

### FCR 7-Dimension Compliance Score

| Dimension | Weight | Check |
|-----------|--------|-------|
| iOS 14+ API | 15% | No iOS 15+/16+/17+ APIs |
| TTBaseUIKit Compliance | 20% | All components, no raw UIKit |
| Config Tokens | 15% | TTView/TTSize/TTFont everywhere |
| MVVM Separation | 15% | ViewModel pure, VC thin |
| Closure Safety | 15% | [weak self] everywhere |
| Localization | 10% | XText/XTextU with Localizable.strings |
| Code Quality | 10% | MARK sections, naming, style |

### Key Rules for Auditing

- ✅ **Comprehensive** — check all dimensions
- ✅ **Evidence-based** — cite specific files and lines
- ✅ **Actionable** — each issue has a fix
- ✅ **FCR scoring** — must document score
- ✅ **Post-fix verification** — `BUILD SUCCEEDED` after fixes

---

## 9. Prompt Writing Best Practices

### ✅ Good Prompt Structure

```
/{command} — {WHAT} {SCREEN/FEATURE NAME} with {KEY FEATURES}
```

### ✅ Good Prompt Examples

```
/ttb-uikit-screen — create a UserProfile screen with avatar, name, email, edit button, and logout

/ttb-sui-screen — create a ShoppingCartScreen with item list, quantity stepper, subtotal, and checkout button

/ttb-native-card — create a ProductCard with image (120x120), title (2 lines), price, and add-to-cart icon

/ttb-bugfix — the checkout button does nothing when tapped. No crash, but the cart total never advances.

/ttb-audit-performance — the HomeScreen loads in 3 seconds on iPhone 11. Find and fix bottlenecks.
```

### ❌ Bad Prompt Examples

```
# Too vague
"/ttb-uikit — make a screen"
"/ttb-sui — do something with products"

# Too long without structure
"/ttb-uikit-screen — I need to create a product detail screen for my iOS app using TTBaseUIKit. This screen should display the product image at the top, followed by the product title in large bold text..."

# Missing context
"/ttb-sui-screen — create a list"  (what list? products? users? orders?)
```

### Context Tips

| Information | Why It Helps |
|-------------|-------------|
| Screen/feature name | Agent knows what to name files |
| Key UI elements | Agent knows what components to use |
| User interaction | Agent knows what callbacks to wire |
| Data source | Agent knows if API or local DB |
| Navigation context | Agent knows where screen fits in flow |
| Constraints | Screen size, localization, accessibility needs |

---

## 10. Workflow Summary

### Feature Development Flow

```
┌──────────────────────────────────────────────────────────┐
│  1. INIT (one-time)                                      │
│     /ttb-init                                           │
│     └── Set up project, TTBaseUIKitConfig, localization │
└──────────────────────────────────────────────────────────┘
                          ↓
┌──────────────────────────────────────────────────────────┐
│  2. FEATURE RESEARCH (Phase 1)                           │
│     Analyze existing code, find patterns, assess scope   │
│     └── Feature Research Report                         │
└──────────────────────────────────────────────────────────┘
                          ↓
┌──────────────────────────────────────────────────────────┐
│  3. FEATURE SPEC (Phase 2)                              │
│     Define data model, files, navigation, API contract   │
│     └── Approved Spec                                   │
└──────────────────────────────────────────────────────────┘
                          ↓
┌──────────────────────────────────────────────────────────┐
│  4. IMPLEMENTATION (Phase 3)                            │
│     Generate files one-by-one → xcodebuild each          │
│     └── Generated Files                                  │
└──────────────────────────────────────────────────────────┘
                          ↓
┌──────────────────────────────────────────────────────────┐
│  5. CODE REVIEW (Phase 4)                               │
│     FCR 7-Dimension audit across all files               │
│     └── Issues List                                     │
└──────────────────────────────────────────────────────────┘
                          ↓
┌──────────────────────────────────────────────────────────┐
│  6. VERIFICATION (Phase 5) ← MANDATORY                  │
│     xcodebuild + compliance + regression + FCR score     │
│     └── ✅ BUILD SUCCEEDED + FCR ≥ 85% → COMPLETE      │
└──────────────────────────────────────────────────────────┘
```

### Skill Command Cheat Sheet

| Task | Command | Prompt Example |
|------|---------|----------------|
| New project | `/ttb-init` | "Init MyApp with TTBaseUIKit" |
| UIKit screen | `/ttb-uikit-screen` | "ProductDetail with image, title, price" |
| UIKit list | `/ttb-uikit-list` | "ProductList with pull-to-refresh" |
| UIKit cell | `/ttb-uikit-cell` | "ProductCell with 56x56 image" |
| UIKit API | `/ttb-uikit-api` | "ProductAPI for getProducts" |
| UIKit coordinator | `/ttb-uikit-coordinator` | "ProductCoordinator" |
| SwiftUI screen | `/ttb-sui-screen` | "HomeScreen with banner + grid" |
| SwiftUI view | `/ttb-sui-view` | "ProductCardView" |
| SwiftUI list | `/ttb-sui-list` | "ProductListScreen lazy loading" |
| SwiftUI ViewModel | `/ttb-sui-viewmodel` | "ProductListViewModel" |
| Native atomic | `/native-{component}` | "/native-rating — 5 stars" |
| Native screen | `/ttb-native-screen` | "/ttb-native-screen — complex chart" |
| Native view | `/ttb-native-view` | "/ttb-native-view — custom card layout" |
| Bug fix | `/ttb-bugfix` | "Cart badge doesn't update" |
| UIKit refactor | `/ttb-refactor-uikit` | "Migrate to TTViewCodable" |
| SwiftUI refactor | `/ttb-refactor-swiftui` | "Migrate to TTBaseSUI" |
| Performance audit | `/ttb-audit-performance` | "HomeScreen loads in 3s" |
| Accessibility audit | `/ttb-audit-accessibility` | "VoiceOver on ProductList" |
| Localization audit | `/ttb-audit-localization` | "Find hardcoded strings" |

---

**Next**: Read `SKILL.md` for the complete skill documentation, or `README.md` for the system overview.
