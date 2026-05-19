---
name: "ttb-rule-anti-patterns"
description: "Comprehensive anti-pattern guide for TTBaseUIKit apps: SwiftUI TTBaseSUI vs Native SwiftUI, UIKit components, config tokens, navigation patterns, and localization anti-patterns."
version: "2.0.0"
---

# ttb-rule-anti-patterns — Anti-Patterns

Comprehensive anti-pattern guide for TTBaseUIKit apps.

## Three-Tier SwiftUI Approach

| Tier | When | Components |
|------|-------|-----------|
| **Tier 1 — TTBaseSUI** | Component already exists | `TTBaseSUI*` → `/ttb-sui-*` |
| **Tier 2 — SUIBaseView + TTBaseNavigationLink** | Navigation | Mandatory pattern |
| **Tier 3 — Native SwiftUI + tokens** | TTBaseSUI lacks component | `Text`, `Button`, `VStack` + tokens → `/ttb-native-*` |

**Rule: Prefer TTBaseSUI. Only fallback to Native SwiftUI when TTBaseSUI has no equivalent.**

---

## SwiftUI Anti-Patterns

### Navigation Anti-Patterns

| ❌ Never | ✅ Use Instead |
|---------|---------------|
| `NavigationView` directly as screen wrapper | `SUIBaseView(backType:title:type:isHiddenTabbar:backAction:)` |
| `NavigationLink` directly | `TTBaseNavigationLink(destination:label:)` |
| Missing `backType` when dismiss behavior matters | `.SWIFTUI` for pure SwiftUI, `.POP` for hybrid |
| `TTBaseNavigationLink` outside `TTBaseSUIScroll` | Wrap inside `TTBaseSUIScroll` or `TTBaseSUILazyVStack` |

### Component Anti-Patterns

| ❌ Never | ✅ Use Instead |
|---------|---------------|
| Native `Text("...")` | `TTBaseSUIText(withType:)` |
| Native `Button(...)` | `TTBaseSUIButton(type:title:)` |
| Native `VStack {}` | `TTBaseSUIVStack(alignment:spacing:)` |
| Native `HStack {}` | `TTBaseSUIHStack(alignment:spacing:)` |
| Native `ZStack {}` | `TTBaseSUIZStack(alignment:bg:)` |
| Native `Spacer()` | `TTBaseSUISpacer()` |
| Native `ScrollView {}` | `TTBaseSUIScroll {}` |
| Native `LazyVStack {}` | `TTBaseSUILazyVStack {}` |
| Native `LazyVGrid {}` | `TTBaseSUILazyVGrid {}` |
| Native `Divider()` | `TTBaseSUIHorizontalDividerView(noConner: .LINE)` |
| Native `AsyncImage {}` | `TTBaseSUIAsyncImage(urlString:)` |
| Native `TextField {}` | `TTBaseSUITextField(placeholder:text:)` |
| Native `Toggle {}` | `TTBaseSUIToggle(label:isOn:)` |
| Native `Slider {}` | `TTBaseSUISlider(value:)` |
| Native `List {}` | `TTBaseSUIList(type:)` |
| Native `TabView {}` | `TTBaseSUITabView(type:)` |
| Native `Group {}` | `TTBaseSUIGroup(bg:radius:)` |

### SwiftUI Performance Anti-Patterns

| ❌ Never | ✅ Use Instead |
|---------|---------------|
| `ForEach(array)` without stable ID | Always use `.id(\.id)` — NEVER `UUID()` |
| `UUID()` in `ForEach` ID | Use model's actual stable identifier |
| `@Published var model: BigModel` | Publish only changed fields |
| `.onTapGesture { }` for buttons | Use `TTBaseSUIButton` or `Button {} label:` |
| View body > 40 lines | Extract subviews to `private var` computed properties |
| `AnyView` type erasure | Use `@ViewBuilder` or `Group` |
| `ForEach(0..<10)` in scroll | Use `LazyVStack` with stable data |
| Heavy computation in View init | Move to `.onAppear` or ViewModel |

### iOS Version Anti-Patterns

| ❌ Never (iOS) | ✅ Use Instead (iOS 14+) |
|-----------------|------------------------|
| `.foregroundStyle()` (15+) | `.foregroundColor()` |
| `NavigationStack { }` (16+) | `NavigationView { }` (via SUIBaseView) |
| `#Preview { }` (17+) | `PreviewProvider` protocol |
| `.task { }` (15+) | `.onAppear { Task { } }` |
| `@Observable` (17+) | `ObservableObject` + `@Published` |
| `.clipShape(.rect())` (16+) | `.clipShape(RoundedRectangle())` |
| `.scrollIndicators(.hidden)` (16+) | `ScrollView(showsIndicators: false)` |
| `.topBarLeading` (15+) | `.navigationBarLeading` |

### SwiftUI Data Flow Anti-Patterns

| ❌ Never | ✅ Use Instead |
|---------|---------------|
| `@ObservedObject` for owned VM | `@StateObject` for owned VM |
| No loading state | `.skeleton(active: viewModel.isLoading)` |
| Inline business logic in View | Move to ViewModel |
| Missing `DispatchQueue.main.async` | Wrap UI updates in `DispatchQueue.main.async` |
| Missing `[weak self]` in closures | Every closure must have `[weak self]` |

### SwiftUI Screen Anti-Patterns

| ❌ Never | ✅ Use Instead |
|---------|---------------|
| SUIBaseView without correct `backType` | Choose correct `.SWIFTUI` / `.POP` / `.DISMISS` |
| `TTBaseNavigationLink` outside Scroll | Always place inside `TTBaseSUIScroll` |
| `textFieldStyle(PlainTextFieldStyle())` in native TextField | Use `TTBaseSUITextField` instead |
| `onTapGesture` for button-like elements | Use `TTBaseSUIButton` or `Button {} label:` |
| Custom shadow when `TTBaseSUI` exists | Use `.baseShadow()` |

---

## UIKit Anti-Patterns

### Component Anti-Patterns

| ❌ Never | ✅ Use Instead |
|---------|---------------|
| `UILabel()` | `TTBaseUILabel(withType:text:align:)` |
| `UIButton()` | `TTBaseUIButton(textString:type:isSetHeight:)` |
| `UITextField()` | `TTBaseUITextField(withPlaceholder:type:)` |
| `UITextView()` | `TTBaseUITextView(frame:)` |
| `UIImageView()` | `TTBaseUIImageView()` or `TTBaseUIImageFontView` |
| `UIView()` container | `TTBaseUIView()` or `TTBaseShadowPanelView()` |
| `UITableView()` | `TTBaseUITableView(frame:style:)` |
| `UICollectionView()` | `TTBaseUICollectionView(...)` |
| `UIScrollView()` | `BaseScrollViewController` or `BaseScrollUIStackView` |
| `UIStackView()` | `TTBaseUIStackView()` |
| `UIActivityIndicatorView()` | `TTBaseUIActivityIndicator()` |
| `UIRefreshControl()` | `TTBaseUIRefreshControl()` |
| `UIViewController()` | `TTBaseUIViewController<TTBaseUIView>` |

### Constraint Anti-Patterns

| ❌ Never | ✅ Use Instead |
|---------|---------------|
| `NSLayoutConstraint.activate([])` | `view.setLeadingAnchor()...done()` |
| `translatesAutoresizingMaskIntoConstraints = false` | TTBaseUIKit handles this |
| Hardcoded `8`, `16`, `24` | `TTSize.P_CONS_DEF`, `TTSize.P_L` |
| Hardcoded `44`, `40` | `TTSize.H_BUTTON`, `TTSize.H_TEXTFIELD` |
| Missing `.done()` | Every chain ends with `.done()` |

### Navigation Anti-Patterns

| ❌ Never | ✅ Use Instead |
|---------|---------------|
| `navigationController?.pushViewController` | `self.push(vc)` |
| `navigationController?.popViewController` | `self.pop()` |
| `present(vc, animated:)` | `self.presentDef(vc:type:)` |
| `dismiss(animated:)` | `self.close()` |
| `self.view.addSubview(vc.view)` | Use proper VC containment |
| Subviews on `self.view` | `self.contentView` |

### Closure Anti-Patterns

| ❌ Never | ✅ Use Instead |
|---------|---------------|
| Missing `[weak self]` | All closures use `[weak self]` |
| Strong self retained | `guard let self = self` before use |
| Inline API call in VC | Route through ViewModel |

### ViewModel Anti-Patterns

| ❌ Never | ✅ Use Instead |
|---------|---------------|
| `import UIKit` in ViewModel | `import Foundation` only |
| `import SwiftUI` in ViewModel | `import Foundation` only |
| Business logic in VC | Move to ViewModel |
| Direct API calls in VC | Route through ViewModel |
| UIKit types in VM | Use Foundation types only |

### Memory Anti-Patterns

| ❌ Never | ✅ Use Instead |
|---------|---------------|
| Missing `deinit` | Add `deinit` with `removeObserver` + `TTBaseFunc.shared.printLog` |
| `NotificationCenter` without removal | Remove in `deinit` |
| Timer without invalidation | Invalidate in `deinit` |
| Delegate without weak | `weak var delegate: Protocol?` |

### Lifecycle Anti-Patterns

| ❌ Never | ✅ Use Instead |
|---------|---------------|
| Missing `super.viewDidLoad()` | Call `super` first |
| Missing `super.viewWillAppear()` | Call `super` when overriding |
| Heavy work in `viewDidLoad` | Move to async, show skeleton |

### API Anti-Patterns

| ❌ Never | ✅ Use Instead |
|---------|---------------|
| Missing `super.encode(to:)` | Call `super.encode` first in RequestData |
| Missing `onCheckSuccess()` | Always check `resMess.onCheckSuccess()` |
| Missing `DispatchQueue.main.async` | Main thread before UI callbacks |
| No error handling | Handle both success and failure |
| Missing `beginFetching/endFetching` | Use in ViewModel for loading guard |

---

## Config Token Anti-Patterns

| ❌ Never | ✅ Use Instead |
|---------|---------------|
| `UIColor(hex: "#555")` | `TTView.textDefColor` |
| `Color.blue` | `TTView.buttonBgDef.toColor()` |
| Hardcoded `8`, `16`, `24` | `TTSize.P_CONS_DEF`, `TTSize.P_L` |
| Hardcoded `44`, `40` | `TTSize.H_BUTTON`, `TTSize.H_TEXTFIELD` |
| `UIFont.systemFont(ofSize: 14)` | `TTFont.TITLE_H` |
| `UIFont.boldSystemFont(ofSize: 16)` | `TTFont.HEADER_H` |

### Token Warning: Non-Existent Tokens

The following **DO NOT EXIST** in TTBaseUIKit:

| ❌ DO NOT USE | ✅ USE INSTEAD |
|--------------|----------------|
| `XView` | `TTView` |
| `XSize` | `TTSize` |
| `XFont` | `TTFont` |
| `TTView.colorSuccess` | `TTView.notificationBgSuccess` |
| `TTView.colorWarning` | `TTView.notificationBgWarning` |
| `TTView.colorError` | `TTView.notificationBgError` |
| `TTView.buttonBgHighlight` | Calculate manually |
| `TTView.buttonBgWarring` | `TTView.buttonBgWar` |
| `TTView.buttonBgDisable` | `TTView.buttonBgDis` |
| `TTSize.P_XXL` | `TTSize.P_CONS_DEF * 4` (32pt) |
| `TTFont.SIZE_SUPER_HEADER` | `TTFont.HEADER_SUPER_H` |

---

## Localization Anti-Patterns

| ❌ Never | ✅ Use Instead |
|---------|---------------|
| `Text("Hardcoded string")` | `XText("App.Module.Context")` |
| Nav title with `XText` | `XTextU("App.Module.Nav.Title")` |
| Button text with `XTextU` | `XText("App.Module.Button.Action")` |
| Hardcoded "OK", "Cancel" | Localization keys |

---

## Decision Matrix: TTBaseSUI vs Native SwiftUI

**Rule: Prefer TTBaseSUI, fall back to Native SwiftUI when TTBaseSUI lacks a component.**

| Scenario | Recommended | Command |
|----------|------------|---------|
| Standard list, form, card screen | **TTBaseSUI** | `/ttb-sui-screen` |
| Reusable card/row/button component | **TTBaseSUI** | `/ttb-sui-view` |
| Scrollable list with many items | **TTBaseSUI** | `/ttb-sui-list` |
| Navigation between screens | **TTBaseNavigationLink** | pattern in skill |
| Horizontal scroll/banner/carousel | **TTBaseSUI + TTBaseSUITabView** | `/ttb-sui-list` |
| Custom layout, custom shapes | **Native SwiftUI** | `/ttb-native-view` |
| Charts, graphs, complex visualizations | **Native SwiftUI** | `/ttb-native-view` |
| Complex animations | **Native SwiftUI** | `/ttb-native-view` |
| TTBaseSUI lacks a component | **Native SwiftUI + tokens** | `/ttb-native-view` |

**Anti-Pattern — Mixed Framework Usage:**
Do NOT use TTBaseSUI components AND native SwiftUI primitives in the same file. Choose one approach per file.

**When TTBaseSUI lacks a component:** Use Native SwiftUI with TTBaseUIKit tokens, then document the gap in the skill registry.

---

**Version**: 2.0.0 | **Date**: 2026-05-19
**Changelog**: v2.0.0 — Complete rewrite. Added Three-Tier SwiftUI Approach table. Added SUIBaseView + TTBaseNavigationLink anti-patterns. Added full TTBaseSUI vs Native SwiftUI decision matrix. Added token warning section. Strengthened navigation anti-patterns. v1.4.0 — Fixed SUIBaseView anti-patterns. v1.3.0 — Added SwiftUI anti-patterns.
