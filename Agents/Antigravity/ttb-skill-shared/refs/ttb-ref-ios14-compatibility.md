---
name: "ttb-ref-ios14-compatibility"
description: "Strict iOS 14+ compatibility guide for TTBaseUIKit apps: SwiftUI and UIKit APIs to avoid, replacements, and verification commands."
version: "2.0.0"
---

# ttb-ref-ios14-compatibility — iOS 14+ Compatibility Guide

Strict iOS 14+ compatibility requirements for TTBaseUIKit apps.

## SwiftUI Compatibility

### Navigation

| ❌ Do Not Use | ✅ Use Instead (iOS 14+) |
|---|---|
| `NavigationStack { }` (iOS 16+) | `NavigationView { }` |
| `NavigationLink(value:)` (iOS 16+) | `NavigationLink(destination:)` (iOS 13+) |
| `navigationDestination(for:)` (iOS 16+) | Navigation via `NavigationView` push/pop |
| `.topBarLeading` (iOS 15+) | `.navigationBarLeading` (iOS 13+) |
| `.topBarTrailing` (iOS 15+) | `.navigationBarTrailing` (iOS 13+) |
| `.navigationBarTitleDisplayMode(.large)` (iOS 14+) | OK — this is iOS 14+ |

### Text & Fonts

| ❌ Do Not Use | ✅ Use Instead (iOS 14+) |
|---|---|
| `.fontWeight(.semibold)` (iOS 15+) | `.font(.system(size:weight:))` |
| `.font(.title.bold())` (iOS 16+) | `.font(.system(size:weight: .bold))` |
| `.font(.system(.body, design: .rounded))` (iOS 16+) | `.font(.system(size:))` |

### Modifiers

| ❌ Do Not Use | ✅ Use Instead (iOS 14+) |
|---|---|
| `.foregroundStyle()` (iOS 15+) | `.foregroundColor()` |
| `.backgroundStyle()` (iOS 15+) | `.background()` |
| `.clipShape(.rect(cornerRadius:))` (iOS 16+) | `.clipShape(RoundedRectangle(cornerRadius:))` |
| `.contentShape(.rect)` (iOS 15+) | `.contentShape(Rectangle())` |
| `.scrollIndicators(.hidden)` (iOS 16+) | `ScrollView(showsIndicators: false)` |
| `.safeAreaInset()` (iOS 15+) | Custom safe area handling |
| `.searchable()` (iOS 15+) | Custom search implementation |
| `.refreshable()` (iOS 15+) | Custom refresh implementation |

### Layout

| ❌ Do Not Use | ✅ Use Instead (iOS 14+) |
|---|---|
| `.layoutPriority()` (iOS 16+) | `.layoutPriority(Double)` — available iOS 13+ but verify |
| `.containerRelativeFrame()` (iOS 17+) | `GeometryReader` or `.frame()` |
| `.grid(columnAlignment:)` (iOS 16+) | `LazyVGrid` or custom layout |
| `.layout` (iOS 16+) | VStack/HStack |

### Animation & Transitions

| ❌ Do Not Use | ✅ Use Instead (iOS 14+) |
|---|---|
| `.contentTransition()` (iOS 16+) | `.animation(.default, value:)` |
| `.sensoryFeedback()` (iOS 17+) | `UIImpactFeedbackGenerator` |
| `.animation(.interactiveSpring())` (iOS 17+) | `.animation(.spring())` |
| `.transition(.asymmetric(...))` (iOS 16+) | `.transition(.scale)` |

### Lifecycle

| ❌ Do Not Use | ✅ Use Instead (iOS 14+) |
|---|---|
| `.task { }` (iOS 15+) | `.onAppear { Task { } }` |
| `.task(id:)` (iOS 15+) | `.onAppear` + manual cancellation |
| `.task(priority:_:)` (iOS 15+) | `.onAppear` |
| `.onSubmit()` (iOS 15+) | Button-based submission |
| `.onChange(of:)` (0-param, iOS 17+) | `.onChange(of:perform:)` (iOS 14+) |
| `.taskBarItem()` (iOS 17+) | Not available |

### Data & State

| ❌ Do Not Use | ✅ Use Instead (iOS 14+) |
|---|---|
| `@Observable` (iOS 17+) | `ObservableObject` + `@Published` |
| `@State` with struct (iOS 17+) | `@State` with struct — OK on iOS 14+ |
| `@Bindable` (iOS 17+) | `@StateObject` / `@ObservedObject` |
| `@Environment(\.dismiss)` (iOS 15+) | Manual dismiss via Coordinator |

### Previews

| ❌ Do Not Use | ✅ Use Instead (iOS 14+) |
|---|---|
| `#Preview { }` (iOS 17+) | `PreviewProvider` protocol |
| `#Preview("Name") { }` (iOS 17+) | `static var previews: some View` |

### Overlays & Sheets

| ❌ Do Not Use | ✅ Use Instead (iOS 14+) |
|---|---|
| `.sheet(item:)` (iOS 15+) | `.sheet(isPresented:)` |
| `.overlay { content }` (closure, iOS 15+) | `.overlay(content)` (view param) |
| `.fullScreenCover()` (iOS 15+) | `presentDef` via TTBaseUIKit |

## UIKit Compatibility

### Views

| ❌ Do Not Use | ✅ Use Instead (iOS 14+) |
|---|---|
| `UICollectionLayoutList` (iOS 14+) | OK — but prefer TTBaseUICollectionView |
| `UISheetPresentationController` (iOS 15+) | `presentDef` via TTBaseUIKit |
| `UIButton.Configuration` (iOS 15+) | `TTBaseUIButton` |
| `UITextField.textContentType = .oneTimeCode` (iOS 15+) | Use other `.textContentType` options |

### SnapKit (if used)

| ❌ Do Not Use | ✅ Use Instead (iOS 14+) |
|---|---|
| `.priority(.must)` (iOS 15+) | `.priority(.high)` |
| `.activate(constraints)` (iOS 15+) | `.snp.makeConstraints` |

## Verification Commands

```bash
# Check for iOS 15+ APIs in generated code
grep -rn "\.task {" Sources/
grep -rn "NavigationStack" Sources/
grep -rn "#Preview" Sources/
grep -rn "\.foregroundStyle" Sources/

# Check for iOS 16+ APIs
grep -rn "\.clipShape(.rect" Sources/
grep -rn "\.scrollIndicators" Sources/
grep -rn "@Observable" Sources/

# Check for iOS 17+ APIs
grep -rn "#Preview {" Sources/
grep -rn "sensoryFeedback" Sources/
```

## Quick Check

Before shipping any feature:
1. Search generated code for iOS 15+/16+/17+ patterns above
2. Build on iOS 14 simulator to catch runtime issues
3. Use Availability checks where iOS 15+ is truly necessary

---

**Version**: 2.0.0 | **Date**: 2026-05-19
**Changelog**: v2.0.0 — Version bump to align with shared resources v2.0.0.
