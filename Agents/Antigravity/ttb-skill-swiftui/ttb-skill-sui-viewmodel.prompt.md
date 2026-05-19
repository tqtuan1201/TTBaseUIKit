---
description: "Scaffold a SwiftUI ViewModel with @Published properties, ObservableObject, and API integration."
---

# ttb-skill-sui-viewmodel — SwiftUI ViewModel Builder

Scaffold a SwiftUI ViewModel with `@Published` properties and API integration.

## When

User says: "swiftui viewmodel", "observable viewmodel", "swiftui vm", "list viewmodel"

## Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  {Name}ViewModel.swift
//  {AppName}
//

import Foundation

// MARK: - {Name}ViewModel
@MainActor
final class {Name}ViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var items: [{Name}Model] = []
    @Published var isLoading = false
    @Published var selectedItem: {Name}Model?
    @Published var errorMessage: String?
    @Published var searchText: String = ""

    // MARK: - Computed Properties
    var isEmpty: Bool { items.isEmpty }
    var filteredItems: [{Name}Model] {
        guard !searchText.isEmpty else { return items }
        return items.filter { $0.name?.localizedCaseInsensitiveContains(searchText) == true }
    }

    // MARK: - Data Fetching
    func fetchData() {
        beginFetching()
        {Name}API.share.getAll { [weak self] objects, resMess in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.endFetching()
                if resMess.onCheckSuccess(), let objs = objects {
                    self.items = objs
                } else {
                    self.errorMessage = resMess.message
                }
            }
        }
    }

    func fetchById(id: String) {
        beginFetching()
        {Name}API.share.getById(id: id) { [weak self] object, resMess in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.endFetching()
                if resMess.onCheckSuccess(), let obj = object {
                    self.selectedItem = obj
                }
            }
        }
    }

    // MARK: - Actions
    func selectItem(_ item: {Name}Model) {
        self.selectedItem = item
    }

    func clearSelection() {
        self.selectedItem = nil
    }

    // MARK: - Helpers
    private func beginFetching() {
        self.isLoading = true
        self.errorMessage = nil
    }

    private func endFetching() {
        self.isLoading = false
    }
}
```

## List ViewModel Pattern (with search)

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  {Name}ViewModel.swift
//  {AppName}
//

import Foundation

// MARK: - {Name}ViewModel
@MainActor
final class {Name}ViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var items: [{Name}Model] = []
    @Published var isLoading = false
    @Published var searchText: String = ""
    @Published var selectedCategory: ProductCategoryItem?

    // MARK: - Computed Properties
    var isEmpty: Bool { filteredItems.isEmpty }

    var filteredItems: [{Name}Model] {
        var result = items

        if let cat = selectedCategory, !cat.isSelectAll() {
            result = result.filter { $0.categoryId == cat.id }
        }

        if !searchText.isEmpty {
            result = result.filter {
                $0.name?.localizedCaseInsensitiveContains(searchText) == true
            }
        }

        return result
    }

    // MARK: - Init
    init() {
        fetchData()
    }

    // MARK: - Data Fetching
    func fetchData() {
        beginFetching()
        {Name}API.share.getAll { [weak self] objects, resMess in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.endFetching()
                if resMess.onCheckSuccess(), let objs = objects {
                    self.items = objs
                }
            }
        }
    }

    func reload() {
        fetchData()
    }

    // MARK: - Actions
    func selectCategory(_ category: ProductCategoryItem) {
        self.selectedCategory = category
    }

    // MARK: - Helpers
    private func beginFetching() {
        self.isLoading = true
    }

    private func endFetching() {
        self.isLoading = false
    }
}
```

## Detail ViewModel Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  {Name}DetailViewModel.swift
//  {AppName}
//

import Foundation

// MARK: - {Name}DetailViewModel
@MainActor
final class {Name}DetailViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var item: {Name}Model?
    @Published var isLoading = false
    @Published var isSaving = false
    @Published var errorMessage: String?

    // MARK: - Init
    init(item: {Name}Model? = nil) {
        self.item = item
    }

    // MARK: - Data Fetching
    func fetchById(id: String) {
        beginFetching()
        {Name}API.share.getById(id: id) { [weak self] object, resMess in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.endFetching()
                if resMess.onCheckSuccess(), let obj = object {
                    self.item = obj
                } else {
                    self.errorMessage = resMess.message
                }
            }
        }
    }

    // MARK: - Actions
    func save() {
        guard let item = item else { return }
        beginSaving()
        {Name}API.share.update(item) { [weak self] resMess in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.endSaving()
                if !resMess.onCheckSuccess() {
                    self.errorMessage = resMess.message
                }
            }
        }
    }

    // MARK: - Helpers
    private func beginFetching() { self.isLoading = true }
    private func endFetching() { self.isLoading = false }
    private func beginSaving() { self.isSaving = true }
    private func endSaving() { self.isSaving = false }
}
```

## Rules

1. **`@MainActor`** on class for main thread safety
2. **`ObservableObject`** — NOT `@Observable` (iOS 17+)
3. **`@Published`** for reactive state
4. **`@StateObject`** in View for owned VMs, **`@ObservedObject`** for passed VMs
5. **`[weak self]`** in every closure
6. **Dispatch to main** before UI updates
7. **`resMess.onCheckSuccess()`** check before processing
8. **ViewModel NEVER imports UIKit or SwiftUI**
9. **Separate `beginFetching` / `endFetching`** for loading guard
10. **Computed `isEmpty`** — always provide for empty state handling

## Post-Implementation Verification (MANDATORY)

After all files are generated, **run Phase 6 verification**:

1. **Add files to Xcode project** — ensure each `.swift` is registered in `project.pbxproj`
2. **Run verification**:
   ```bash
   bash ttb-skill-shared/scripts/ttb-verify.sh
   ```
3. **Check compliance**:
   ```bash
   bash ttb-skill-shared/scripts/ttb-compliance-check.sh
   ```
4. **Skill is complete only when** `BUILD SUCCEEDED`

**Anti-Loop**: Max 3 build attempts. 3 failures — STOP, document errors.

For full FCR 7-Dimension scoring, see `ttb-skill-shared/phases/ttb-phase-verify.md`.
