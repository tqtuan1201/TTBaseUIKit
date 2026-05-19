---
name: "ttb-rule-comments"
description: "Code comment and documentation standards for TTBaseUIKit apps: doc comments, inline comments, MARK sections, and SwiftUI-specific documentation guidelines."
version: "2.0.0"
---

# ttb-rule-comments — Code Comment & Documentation Standards

Code comment and documentation standards for TTBaseUIKit apps. Applies to all generated and modified code.

## Philosophy

Comments should explain **why**, not **what**. The code itself documents the what. Comments explain intent, trade-offs, constraints, and non-obvious decisions.

**Never narrate what the code does:**
```swift
// ❌ WRONG — obvious, adds no value
let count = items.count // Get the count of items
incrementCounter() // Increment the counter

// ✅ CORRECT — explains non-obvious intent
let count = items.count // Use count instead of isEmpty to enable animation progress calculation
incrementCounter() // Compensates for pre-increment in configureCell closure
```

## Doc Comments (Swift DocC Format)

Every public type and method **must** have a doc comment (`///`):

```swift
/// A card component that displays a product with image, title, and price.
///
/// Use this component inside `TTBaseSUILazyVStack` for scrollable product grids.
/// It automatically applies the card shadow and corner radius from `TTBaseUIKitConfig`.
///
/// - Parameters:
///   - product: The product model containing image URL, title, and price.
///   - onTap: Closure invoked when the card is tapped.
///
public struct ProductCardView: View {
    public let product: ProductModel
    public var onTap: (() -> Void)?
}
```

### When Doc Comments Are Required

| Element | Doc Comment Required |
|---------|---------------------|
| `public struct/class` | Always |
| `public func` | Always |
| `public enum` | Always |
| `internal func` with complex logic | Yes |
| `private func` | No (unless non-obvious) |

## Inline Comments

Use inline `//` comments for:

### Non-Obvious Intent
```swift
// Use `false` here — true causes layout cycle with parent LazyVStack
let forceSync = false
```

### Trade-off Explanations
```swift
// Intentionally using @State instead of @StateObject for simple toggle.
// @StateObject overhead is not justified for a single boolean.
@State private var isExpanded = false
```

### Platform-Specific Workarounds
```swift
// iOS 14: .glassEffect() not available, fall back to solid background
#if canImport(UIKit)
self.background(Color.white.opacity(0.85))
#endif
```

### Magic Numbers
```swift
// 0.85 matches the overlay opacity in Figma design token "glass-frost"
Color.white.opacity(0.85)
```

## MARK Sections

### SwiftUI View

```swift
// MARK: - Properties
@StateObject private var viewmodel: ProductListViewModel
let product: ProductModel
var onTap: (() -> Void)?

// MARK: - Body
var body: some View {
    cardContent
        .pAll()
        .bg(byDef: .white)
        .corner()
        .baseShadow()
        .onTapHandle { onTap?() }
}

// MARK: - Subviews
private var cardContent: some View {
    TTBaseSUIHStack(alignment: .center, spacing: TTSize.P_CONS_DEF) {
        TTBaseSUIImage(withname: product.imageName, conner: TTSize.CORNER_RADIUS)
            .sizeSquare(width: 60)
        titleAndPrice
        Spacer()
        chevron
    }
}

// MARK: - Actions
private func handleTap() {
    onTap?()
}
```

### SwiftUI ViewModel

```swift
// MARK: - Published Properties
@Published var products: [ProductModel] = []
@Published var isLoading = false
@Published var errorMessage: String?

// MARK: - Init
init(productService: ProductService = .shared) {
    self.productService = productService
}

// MARK: - Data Fetching
func fetchProducts() {
    isLoading = true
    productService.getProducts { [weak self] objects, resMess in
        DispatchQueue.main.async {
            guard let self = self else { return }
            self.isLoading = false
            if resMess.onCheckSuccess(), let objs = objects {
                self.products = objs
            } else {
                self.errorMessage = resMess.getDes()
            }
        }
    }
}

// MARK: - Actions
func deleteProduct(_ product: ProductModel) {
    products.removeAll { $0.id == product.id }
}

// MARK: - Helpers
private func sortByDate() {
    products.sort { $0.createdAt > $1.createdAt }
}
```

### UIKit ViewController

```swift
// MARK: - Properties
// MARK: - UI Components
private let titleLabel = TTBaseUILabel()

// MARK: - Lifecycle
override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupConstraints()
    setupStyles()
    bindViewModel()
}

// MARK: - TTViewCodable
extension HomeViewController: TTViewCodable {
    func setupData() { }
    func setupUI() { }
    func setupConstraints() { view.snp.makeConstraints { $0.height.equalTo(100).done() } }
    func setupStyles() { }
    func bindComponents() { }
    func bindViewModel() { }
}

// MARK: - Actions
@objc private func didTapSubmit() {
    viewModel.submit()
}
```

### Model

```swift
// MARK: - Codable Keys
enum CodingKeys: String, CodingKey {
    case id
    case title
    case price
    case isActive
}
// MARK: - Properties
let id: String
let title: String
let price: Double
let isActive: Bool

// MARK: - Methods
var priceText: String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter.string(from: NSNumber(value: price)) ?? "\(price)"
}
```

## Spacing Rules

- One blank line between MARK sections
- No blank line between related code lines
- No trailing whitespace
- Comment text aligned at 2 spaces after `//`

## Language

- All comments in **English**
- Industry-standard terminology
- Vietnamese comments only in user-facing educational materials

## Accessibility of Comments

- Comments should help future maintainers understand decisions, not replace readable code
- If you need a paragraph to explain what code does, the code is poorly named — rename it first
- Comments that contradict the code are worse than no comments — keep them in sync

---

**Version**: 2.0.0 | **Date**: 2026-05-19
**Changelog**: v2.0.0 — Version bumped to v2.0.0.
