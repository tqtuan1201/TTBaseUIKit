---
name: "ttb-ref-swiftui-performance"
description: "SwiftUI performance optimization guide for TTBaseUIKit apps: stable view identity, LazyVStack, Equatable, @Published optimization, and StateObject."
version: "2.0.0"
---

# ttb-ref-swiftui-performance — SwiftUI Performance Optimization

Performance optimization guidelines for SwiftUI in TTBaseUIKit apps.

## Stable View Identity

### Problem
SwiftUI recreates views unnecessarily when identity changes.

### Solution
- Use stable types (struct, not class) for View state
- Use `Identifiable` with stable `id` (not index)
- Use `@State` for local state, `@StateObject`/`@ObservedObject` for shared state

```swift
// Bad — index as id causes unnecessary redraws
ForEach(0..<items.count, id: \.self) { index in
    ItemRow(item: items[index])
}

// Good — stable id
ForEach(items) { item in
    ItemRow(item: item)  // item.id is stable
}
```

## LazyVStack for Large Lists

### Problem
Eager loading renders all items at once, causing slow scroll.

### Solution
Use `LazyVStack`/`LazyVGrid` for lists > 20 items.

```swift
// Bad
VStack {
    ForEach(items) { item in
        ItemRow(item: item)
    }
}

// Good — lazy loading
ScrollView {
    LazyVStack(spacing: TTSize.P_CONS_DEF) {
        ForEach(items) { item in
            ItemRow(item: item)
        }
    }
}
```

## Equatable for View Body

### Problem
SwiftUI re-renders view body on every parent update even when data hasn't changed.

### Solution
Conform view to `Equatable`, implement `==` to compare only relevant state.

```swift
struct ItemRow: View, Equatable {
    let item: Item

    static func == (lhs: ItemRow, rhs: ItemRow) -> Bool {
        lhs.item.id == rhs.item.id && lhs.item.title == rhs.item.title
    }

    var body: some View {
        HStack {
            TTBaseSUIView(image: item.image)
            TTBaseSUText(text: item.title)
        }
    }
}
```

## @Published Optimization

### Problem
Unnecessary view updates when `@Published` property changes but UI doesn't need to update.

### Solution
- Only publish what the view needs
- Use `willSet` to filter unnecessary updates
- Separate published properties by view dependency

```swift
// Bad — too many publishes
class ItemListViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var isLoading: Bool = false
    @Published var selectedId: Int?
    @Published var searchText: String = ""
}

// Good — separate concerns
class ItemListViewModel: ObservableObject {
    @Published private(set) var items: [Item] = []
    @Published private(set) var isLoading: Bool = false
    var selectedId: Int? {
        didSet { fetchDetail(id: selectedId) }
    }
    var searchText: String = "" {
        didSet { search() }
    }
}
```

## StateObject vs ObservedObject

### When StateObject (Owner)
Use `@StateObject` when the view **creates** the object.

```swift
struct DetailScreen: View {
    @StateObject private var viewModel = DetailViewModel()

    var body: some View {
        SUIBaseView(titleNav: XTextU("Detail.Title")) {
            DetailContent(viewModel: viewModel)
        }
    }
}
```

### When ObservedObject (Passed)
Use `@ObservedObject` when the view **receives** the object from parent.

```swift
struct DetailContent: View {
    @ObservedObject var viewModel: DetailViewModel

    var body: some View {
        TTBaseSUIButton(title: XText("Detail.Button.Submit")) {
            viewModel.submit()
        }
    }
}
```

## TTBaseSUI Performance

### TTBaseSUIButton
- Avoid creating new closures on every render
- Store button action in ViewModel

```swift
// Bad — new closure each render
Button(action: { viewModel.submit() }) {
    TTBaseSUIButton(title: XText("Submit"))
}

// Good — stable action
Button(action: viewModel.submitAction) {
    TTBaseSUIButton(title: XText("Submit"))
}
```

### Image Loading
- Use `TTBaseSUIAsyncImage` for remote images
- Set fixed size to prevent layout shifts

```swift
TTBaseSUIAsyncImage(url: item.imageUrl)
    .frame(width: TTSize.H_ICON, height: TTSize.H_ICON)
    .clipShape(Circle())
```

## Memory Considerations

- Use `Equatable` on views to prevent unnecessary renders
- Avoid capturing large objects in closures
- Use `[weak self]` in all closures
- Nil out `@ObservedObject` references when not needed

---

**Version**: 2.0.0 | **Date**: 2026-05-19
**Changelog**: v2.0.0 — Version bump. Added TTBaseSUIButton performance tip. Minor formatting improvements.
