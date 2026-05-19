---
name: "ttb-ref-navigation"
description: "Complete navigation pattern reference for TTBaseUIKit apps: SUIBaseView wrapper, TTBaseNavigationLink variants, UIKit navigation, backType meanings, and hybrid app navigation."
version: "1.0.0"
---

# ttb-ref-navigation — Navigation Pattern Reference

Complete navigation reference for TTBaseUIKit apps. Covers SwiftUI (`SUIBaseView`), UIKit (`TTCoordinator`), and hybrid patterns.

---

## SwiftUI Navigation: SUIBaseView + TTBaseNavigationLink

All SwiftUI screens **must** use `SUIBaseView` as the screen wrapper and `TTBaseNavigationLink` for navigation between screens.

### SUIBaseView — Screen Wrapper (MANDATORY)

```swift
SUIBaseView(
    backType: .SWIFTUI,
    title: XText("App.Module.Nav.Title"),
    type: .DEFAULT,
    isHiddenTabbar: true,
    backAction: {}
) {
    // Screen content
}
```

#### SUIBaseView Parameters

| Parameter | Type | Default | Description |
|----------|------|---------|-------------|
| `backType` | `BACK_TYPE` | — | How back button behaves (see below) |
| `title` | `String` | — | Navigation bar title |
| `type` | `TYPE` | `.DEFAULT` | `.DEFAULT` \| `.INFO` \| `.NO_NAV` |
| `isHiddenTabbar` | `Bool` | — | Hide tabbar when entering screen |
| `backAction` | `(() -> Void)?` | `nil` | Custom back button handler |
| `titleAction` | `(() -> Void)?` | `nil` | Title tap handler |
| `rightAction` | `(() -> Void)?` | `nil` | Right bar button handler |
| `bg` | `Color` | `.clear` | Screen background color |

#### backType Meanings

| Value | When to Use |
|-------|-------------|
| `.SWIFTUI` | Pure SwiftUI app — uses `presentationMode.dismiss()` |
| `.POP` | UIKit navigation — calls `currentVC.pop()` |
| `.POP_TO_ROOT` | Pop back to root of navigation stack |
| `.DISMISS` | Dismiss a presented view controller |
| `.DISMISS_ALL` | Dismiss all presented view controllers |
| `.CLOSE_FLOW` | Pop to root + dismiss (complete flow close) |

#### TYPE Meanings

| Value | When to Use |
|-------|-------------|
| `.DEFAULT` | Standard navigation bar with title + back button |
| `.INFO` | Info-style navigation (for detail screens) |
| `.NO_NAV` | No navigation bar (modal sheets, full-screen views) |

### TTBaseNavigationLink — Navigation Between Screens (MANDATORY)

Navigation links **must** be placed **inside** `TTBaseSUIScroll` or `TTBaseSUILazyVStack`.

#### Simple Navigation

```swift
TTBaseNavigationLink(destination: {
    ProductDetailScreen(product: product)
}, label: {
    ProductCardView(product: product)
        .pAll(TTSize.P_CONS_DEF)
        .bg(byDef: XView.viewBgCellColor.toColor())
        .corner(byDef: TTSize.CORNER_PANEL)
        .baseShadow()
})
```

#### Navigation with Active Binding

```swift
@State private var isShowingDetail = false

TTBaseNavigationLink(
    isActive: $isShowingDetail,
    destination: { DetailScreen(item: item) },
    label: { ItemRow(item: item) }
)
```

#### Navigation without Animation

```swift
TTBaseNavigationLink(destination: {
    HeavyDetailScreen(item: item)
}, label: {
    ItemRow(item: item)
}, isAnimation: false)
```

#### TTBaseNavigationLink Parameters

| Parameter | Type | Default | Description |
|----------|------|---------|-------------|
| `destination` | `() -> Content` | — | Screen to navigate to |
| `label` | `() -> Label` | — | The tappable element |
| `isActive` | `Binding<Bool>?` | `nil` | Programmatic control binding |
| `isForceBarHidden` | `Bool` | `true` | Hide nav bar in destination |
| `isAnimation` | `Bool` | `true` | Enable/disable push animation |

---

## SwiftUI Navigation Patterns

### Pattern 1: List → Detail

```swift
struct ProductListScreen: View {
    @StateObject private var vm = ProductListViewModel()

    var body: some View {
        SUIBaseView(
            backType: .SWIFTUI,
            title: XText("App.ProductList.Nav.Title"),
            type: .DEFAULT,
            isHiddenTabbar: true,
            backAction: {}
        ) {
            TTBaseSUIScroll(alignment: .vertical) {
                TTBaseSUILazyVStack(alignment: .center, spacing: TTSize.P_CONS_DEF) {
                    ForEach(vm.products) { product in
                        TTBaseNavigationLink(destination: {
                            ProductDetailScreen(product: product)
                        }, label: {
                            ProductCardView(product: product)
                                .pAll(TTSize.P_CONS_DEF)
                                .bg(byDef: XView.viewBgCellColor.toColor())
                                .corner(byDef: TTSize.CORNER_PANEL)
                                .baseShadow()
                        })
                    }
                }
                .pAll(TTSize.P_CONS_DEF)
                .pBottom(TTSize.H_BUTTON)
            }
            .skeleton(active: vm.isLoading)
            .maxHeight()
        }
        .onAppear { vm.fetchProducts() }
    }
}
```

### Pattern 2: Tab Bar Navigation

```swift
// Root app structure
struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeScreen()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)

            ProfileScreen()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(1)
        }
    }
}

// Screen inside tab — hide tabbar when navigating
struct HomeScreen: View {
    @StateObject private var vm = HomeViewModel()

    var body: some View {
        SUIBaseView(
            backType: .SWIFTUI,
            title: XText("App.Home.Nav.Title"),
            type: .DEFAULT,
            isHiddenTabbar: false,    // Show tabbar
            backAction: {}
        ) {
            TTBaseSUIScroll {
                TTBaseSUILazyVStack { /* content */ }
            }
        }
        .onAppear { vm.loadData() }
    }
}
```

### Pattern 3: Modal Presentation

```swift
// Using backType.DISMISS for modals
struct LoginScreen: View {
    var body: some View {
        SUIBaseView(
            backType: .DISMISS,
            title: XText("App.Login.Nav.Title"),
            type: .DEFAULT,
            isHiddenTabbar: true,
            backAction: { /* dismiss */ }
        ) {
            // Modal content
        }
    }
}
```

---

## UIKit Navigation: TTCoordinator

UIKit screens use `TTCoordinator` for navigation.

### Coordinator Pattern

```swift
class ProductCoordinator: TTCoordinator {
    fileprivate var currVC: UIViewController?

    func start() {
        DispatchQueue.main.async {
            self.showList()
        }
    }

    func showList() {
        let vm = ProductListViewModel()
        let vc = ProductListViewController(viewModel: vm)
        vm.onNavigateToDetail = { [weak self] product in
            self?.showDetail(product: product)
        }
        self.currVC = vc

        if let nav = findNavigationController() {
            nav.setViewControllers([vc], animated: false)
        }
    }

    func showDetail(product: ProductModel) {
        let vm = ProductDetailViewModel(product: product)
        let vc = ProductDetailViewController(viewModel: vm)
        self.currVC = vc

        if let nav = findNavigationController() {
            nav.pushViewController(vc, animated: true)
        }
    }

    private func findNavigationController() -> UINavigationController? {
        return currVC?.navigationController
            ?? tabBarController?.selectedViewController as? UINavigationController
    }
}
```

### UIKit Navigation Helpers

```swift
// Push
self.push(vc)

// Pop
self.pop()

// Dismiss modal
self.close()

// Present modal
self.presentDef(vc: vc, type: .overFullScreen)

// Set nav title
self.setTitleNav(XTextU("App.Module.Nav.Title"))
```

---

## Hybrid App Navigation (UIKit ↔ SwiftUI)

### SwiftUI Screen in UIKit Navigation Stack

```swift
// Wrap SwiftUI screen in UIHostingController
let swiftUIScreen = ProductListScreen()
let hostingVC = UIHostingController(rootView: swiftUIScreen)
self.push(hostingVC)
```

### SwiftUI Screen Calling UIKit Navigation

```swift
// SwiftUI screen uses backType.POP for hybrid apps
struct ProductDetailScreen: View {
    var body: some View {
        SUIBaseView(
            backType: .POP,           // Calls currentVC.pop() for UIKit hybrid
            title: XText("App.ProductDetail.Nav.Title"),
            type: .DEFAULT,
            isHiddenTabbar: true,
            backAction: {}
        ) {
            // Content
        }
    }
}
```

### backType Decision Matrix

```
┌────────────────────────────────────────────────────┐
│ Cần navigate giữa các màn hình?                      │
│  ↓                                                  │
│ App có UIKit navigation stack?                       │
│  ├── CÓ (Hybrid app) → backType = .POP            │
│  └── KHÔNG (Pure SwiftUI) → backType = .SWIFTUI  │
│                                                    │
│ Cần dismiss modal?                                 │
│  └── backType = .DISMISS                           │
│                                                    │
│ Cần pop về root?                                  │
│  └── backType = .POP_TO_ROOT                       │
│                                                    │
│ Cần close entire flow?                             │
│  └── backType = .CLOSE_FLOW                       │
└────────────────────────────────────────────────────┘
```

---

## Navigation Checklist

- [ ] Every SwiftUI screen wrapped in `SUIBaseView`
- [ ] Every `SUIBaseView` has correct `backType` (`.SWIFTUI` vs `.POP`)
- [ ] Every navigation between screens uses `TTBaseNavigationLink`
- [ ] `TTBaseNavigationLink` placed inside `TTBaseSUIScroll` or `TTBaseSUILazyVStack`
- [ ] UIKit screens use `TTCoordinator` pattern
- [ ] No direct `NavigationView` usage outside `SUIBaseView`
- [ ] No direct `NavigationLink` usage outside `TTBaseNavigationLink`
- [ ] Hybrid apps use `.POP` for UIKit navigation, `.SWIFTUI` for pure SwiftUI
- [ ] `isHiddenTabbar` set correctly for tab bar apps

---

**Version**: 1.0.0 | **Date**: 2026-05-19
