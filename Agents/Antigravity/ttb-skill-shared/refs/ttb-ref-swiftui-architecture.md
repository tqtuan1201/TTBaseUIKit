---
name: "ttb-ref-swiftui-architecture"
description: "SwiftUI architecture guide for TTBaseUIKit apps: Clean Architecture layers, feature-based modularization, SwiftUI + MVVM + Coordinator pattern, and SPM packaging."
version: "2.0.0"
---

# ttb-ref-swiftui-architecture — SwiftUI Architecture for TTBaseUIKit

SwiftUI architecture guide for TTBaseUIKit apps. Covers Clean Architecture layers, feature modularization, and the dual-stack architecture.

---

## 1. Dual-Stack Architecture Overview

TTBaseUIKit provides **two parallel UI stacks** that coexist in the same app:

```
┌─────────────────────────────────────────┐
│              Your App                    │
│                                          │
│  ┌──────────────┐   ┌────────────────┐    │
│  │   UIKit      │   │   SwiftUI      │    │
│  │   Stack      │   │   Stack        │    │
│  │              │   │                │    │
│  │ TTBaseUIView │   │ TTBaseSUI*,    │    │
│  │ TTViewCodable│   │ SUIBaseView    │    │
│  │ SnapKit      │   │ View Modifiers │    │
│  └──────────────┘   └────────────────┘    │
│                                          │
│  ┌──────────────────────────────────┐    │
│  │  Shared Foundation               │    │
│  │  TTBaseUIKitConfig (TTView,     │    │
│  │  TTSize, TTFont tokens)         │    │
│  │  ViewModels (shared)             │    │
│  │  API Services                    │    │
│  └──────────────────────────────────┘    │
└─────────────────────────────────────────┘
```

### When to Use Each Stack

| Scenario | Stack | Reasoning |
|----------|-------|-----------|
| Standard screens (list, form, card) | **SwiftUI** | Faster development with TTBaseSUI |
| Custom complex views, animations | **SwiftUI** | Full SwiftUI power + TTBaseUIKit tokens |
| Existing UIKit codebase | **UIKit** | Gradual migration, maintain investment |
| Complex scroll performance tuning | **UIKit** | UICollectionView with compositional layout |
| Platform-specific (iOS 14 only) | **SwiftUI** | No AppKit considerations |

---

## 2. Clean Architecture Layers (SwiftUI)

### Three Layers

```
┌──────────────────────────────────────────────────┐
│         PRESENTATION LAYER (SwiftUI)              │
│                                                   │
│  ┌─────────────────┐  ┌─────────────────────┐   │
│  │  SwiftUI Views  │  │   ViewModels         │   │
│  │  (TTBaseSUI or  │  │   (@Published,      │   │
│  │   Native SUI,    │  │    @MainActor)      │   │
│  │   SUIBaseView)  │  │                     │   │
│  └────────┬────────┘  └──────────┬────────────┘   │
│           │                         │              │
│  ┌────────▼────────────────────────▼────────────┐ │
│  │         Coordinators (TTBaseCoordinator)      │ │
│  └────────────────────┬──────────────────────────┘ │
└──────────────────────┼─────────────────────────────┘
                       │ depends on
┌──────────────────────▼─────────────────────────────┐
│            DOMAIN LAYER (Shared)                   │
│                                                       │
│  ┌─────────────────┐  ┌─────────────────────────┐   │
│  │   Models        │  │    Use Cases            │   │
│  │   (Codable,     │  │    (pure logic)        │   │
│  │    Identifiable)│  │                         │   │
│  └─────────────────┘  └─────────────────────────┘   │
│                                                       │
│  ┌───────────────────────────────────────────────┐   │
│  │         Repository Protocols                   │   │
│  │    (ProductRepository, UserRepository)         │   │
│  └──────────────────────┬────────────────────────┘   │
└─────────────────────────┼─────────────────────────────┘
                          │ implements
┌─────────────────────────▼─────────────────────────────┐
│               DATA LAYER (Shared)                    │
│                                                           │
│  ┌──────────────────────┐  ┌─────────────────────────┐  │
│  │   API Services       │  │   Repository Impls      │  │
│  │   (URLSession,       │  │   (network, local DB)  │  │
│  │    Codable)          │  │                        │  │
│  └──────────────────────┘  └─────────────────────────┘  │
└───────────────────────────────────────────────────────────┘
```

### Layer Responsibilities

| Layer | Responsibility | TTBaseUIKit Role |
|-------|---------------|------------------|
| **Presentation** | SwiftUI Views, ViewModels, Navigation | `TTBaseSUI*`, `SUIBaseView`, ViewModels |
| **Domain** | Business logic, Entities, Use Cases | Shared models, pure Swift |
| **Data** | Network, persistence, repository implementations | `TTBaseAPIService`, `TTBaseSharedData` |

### SwiftUI File Organization

```
Features/
└── ProductCatalog/
    ├── Views/                    ← Presentation Layer
    │   ├── ProductCatalogScreen.swift      (SUIBaseView wrapper)
    │   ├── ProductCardView.swift           (Reusable component)
    │   └── ProductFilterView.swift         (Sub-component)
    │
    ├── ViewModels/               ← Presentation Layer
    │   └── ProductCatalogViewModel.swift   (@MainActor, @Published)
    │
    ├── Models/                  ← Domain Layer
    │   └── ProductModels.swift            (Codable, no dependencies)
    │
    ├── Services/                ← Data Layer
    │   └── ProductService.swift           (API calls)
    │
    └── Coordinator/             ← Navigation
        └── ProductCatalogCoordinator.swift
```

---

## 3. SwiftUI + MVVM + Coordinator

### SUIBaseView + TTBaseNavigationLink (Required)

Every SwiftUI screen MUST use `SUIBaseView` as the root wrapper.
Every navigation between screens MUST use `TTBaseNavigationLink`.

```swift
// Screen with SUIBaseView wrapper (REQUIRED)
struct ProductCatalogScreen: View {
    @StateObject private var viewModel = ProductCatalogViewModel()

    var body: some View {
        SUIBaseView(
            titleNav: XTextU("App.ProductCatalog.Title"),
            isShowBack: true,
            backType: .SWIFTUI,
            isShowRightNav: true,
            titleRightNav: XText("Common.Add")
        ) {
            content
        }
        .onAppear { viewModel.loadProducts() }
    }

    private var content: some View {
        ScrollView {
            LazyVStack(spacing: TTSize.P_CONS_DEF) {
                ForEach(viewModel.products) { product in
                    TTBaseNavigationLink(
                        destination: ProductDetailScreen(product: product, viewModel: viewModel),
                        label: { ProductCardView(product: product) }
                    )
                }
            }
            .padding(TTSize.P_CONS_DEF)
        }
        .background(TTView.viewBgColor.toColor())
    }
}
```

### TTBaseNavigationLink Variants

```swift
// Variant 1: Navigation link with label closure
TTBaseNavigationLink(
    destination: DetailScreen(viewModel: vm),
    label: { ProductCardView(product: product) }
)

// Variant 2: Navigation link with active binding
TTBaseNavigationLink(isActive: $vm.isShowingDetail) {
    DetailScreen(viewModel: vm)
}

// Variant 3: Full configuration
TTBaseNavigationLink(
    destination: DetailScreen(viewModel: vm),
    isActive: $vm.isActive,
    label: { CardView(item: item) }
)
```

### Coordinator Pattern for SwiftUI

```swift
// Coordinator protocol
protocol ProductCatalogCoordinating {
    func start()
    func showProductDetail(_ product: ProductModel)
    func showProductEdit(_ product: ProductModel)
}

// Coordinator implementation
@MainActor
class ProductCatalogCoordinator: ProductCatalogCoordinating {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let screen = ProductCatalogScreen()
        let hostingVC = UIHostingController(rootView: screen)
        navigationController?.pushViewController(hostingVC, animated: true)
    }

    func showProductDetail(_ product: ProductModel) {
        let detailScreen = ProductDetailScreen(product: product)
        let hostingVC = UIHostingController(rootView: detailScreen)
        navigationController?.pushViewController(hostingVC, animated: true)
    }
}
```

### ViewModel — Clean MVVM

```swift
@MainActor
class ProductCatalogViewModel: ObservableObject {
    @Published var products: [ProductModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let productService: ProductService

    init(productService: ProductService = .shared) {
        self.productService = productService
    }

    func loadProducts() {
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
}
```

---

## 4. Feature-Based Modularization

### Principles

1. **Each feature is self-contained** — owns its Views, ViewModels, Models, Services, and Coordinator
2. **Feature-to-feature communication via protocols** — no direct imports between features
3. **Shared code in a Core module** — design tokens, API services, base classes
4. **Feature is the unit of build** — faster incremental builds

### Module Structure

```
Core/                           ← Shared foundation (TTBaseUIKit lives here)
├── TTBaseUIKit/               ← UI component library
├── Models/                    ← Shared models (UserModel, ProductModel)
├── Services/                 ← Shared services (AuthService, NetworkService)
└── Extensions/               ← Shared extensions

Features/
├── ProductCatalog/           ← Feature module
│   ├── Views/
│   ├── ViewModels/
│   ├── Models/
│   ├── Services/
│   └── Coordinator/
│
├── UserProfile/              ← Feature module
│   ├── Views/
│   ├── ViewModels/
│   ├── Models/
│   └── Coordinator/
│
└── Settings/                ← Feature module
    ├── Views/
    └── ViewModels/
```

---

## 5. TTBaseUIKit as Presentation Layer

TTBaseUIKit is the **Presentation Layer component library** for TTBaseUIKit-powered apps:

```
┌─────────────────────────────────────┐
│     Your App (Presentation)          │
│                                       │
│  TTBaseUIKit (Component Library)     │
│  ├── UIKit Stack: TTBaseUIView      │
│  ├── SwiftUI Stack: TTBaseSUI*      │
│  ├── Tokens: TTBaseUIKitConfig      │
│  │   (TTView, TTSize, TTFont)       │
│  └── Extensions: View+*.swift       │
│                                       │
│  TTBaseUIKit wrapped in SPM or       │
│  CocoaPods dependency                │
└─────────────────────────────────────┘
```

---

## 6. TTViewCodable (UIKit) vs View Protocol (SwiftUI)

| Aspect | UIKit | SwiftUI |
|--------|-------|---------|
| Protocol | `TTViewCodable` | `View` (SwiftUI) |
| Lifecycle | `viewDidLoad`, `setupData`, `bindViewModel` | `body` computed property |
| Data flow | ViewModel → VC callbacks | `@Published` → view re-render |
| Layout | SnapKit chains with `.done()` | ViewBuilder DSL |
| Navigation | Coordinator pattern | `TTBaseNavigationLink`, `SUIBaseView` |

Both share the same ViewModel and API service layers.

---

**Version**: 2.0.0 | **Date**: 2026-05-19
**Changelog**: v2.0.0 — Updated all code examples to use TTView/TTSize/TTFont tokens. Added SUIBaseView + TTBaseNavigationLink patterns (mandatory). Added TTBaseNavigationLink variants. Version bumped.
