---
description: "Scaffold a SwiftUI ViewModel using @MainActor, ObservableObject, @Published state, API integration, and TTBaseUIKit project conventions. Supports English and Vietnamese prompt intents."
---

# ttb-skill-sui-viewmodel - SwiftUI ViewModel Builder

## Mandatory Preflight Execution Gate

Before generating code or modifying files, run `ttb-skill-shared/fragments/ttb-preflight-execution-gate.frag.md`.

Required checks:

- Analyze intent, task type, scope, impacted files/modules, dependencies, architecture constraints, coding standards, and project-specific rules.
- Validate required inputs such as target module, screen/component name, file location, navigation flow, expected output, API contract, state management, routing, localization, naming, and reusable component requirements.
- Detect ambiguity, conflicting requirements, incomplete business logic, unclear UX/navigation, unclear module ownership, and unclear architecture direction.
- Score confidence from `0-100`: execute at `90-100`, execute with warning assumptions at `70-89`, and ask a survey below `70` using `ttb-skill-shared/templates/ttb-clarification-survey.md`.
- Support English, Vietnamese, mixed-language, diacritic-free Vietnamese, and light typo prompts.

Build a SwiftUI ViewModel for TTBaseUIKit SwiftUI screens.

## Trigger

Use this prompt when the request means: SwiftUI ViewModel, ObservableObject ViewModel, `@Published` state, list ViewModel, detail ViewModel, loading/error state, API-backed SwiftUI state, `tạo ViewModel SwiftUI`, `tao ViewModel SwiftUI`, `viewmodel danh sách`, or `viewmodel man hinh`.

## Input Fidelity

Derive state from the requested screen, image, or description:

- Loading, empty, error, and success states.
- Search/filter/sort selections.
- Selected item or detail state.
- Form values and validation state.
- API calls, pagination, pull-to-refresh, and save/delete actions.

Do not scaffold unused state that is unrelated to the requested UI.

## Base Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active
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
    @Published var searchText = ""

    // MARK: - Computed Properties
    var isEmpty: Bool {
        filteredItems.isEmpty
    }

    var filteredItems: [{Name}Model] {
        guard !searchText.isEmpty else { return items }
        return items.filter { item in
            item.name?.localizedCaseInsensitiveContains(searchText) == true
        }
    }

    // MARK: - Data Fetching
    func fetchData() {
        beginFetching()

        {Name}API.share.getAll { [weak self] objects, resMess in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.endFetching()

                if resMess.onCheckSuccess(), let objects = objects {
                    self.items = objects
                } else {
                    self.errorMessage = resMess.message
                }
            }
        }
    }

    func reload() {
        fetchData()
    }

    // MARK: - Actions
    func selectItem(_ item: {Name}Model) {
        selectedItem = item
    }

    func clearSelection() {
        selectedItem = nil
    }

    // MARK: - Helpers
    private func beginFetching() {
        isLoading = true
        errorMessage = nil
    }

    private func endFetching() {
        isLoading = false
    }
}
```

## Detail Pattern

```swift
@MainActor
final class {Name}DetailViewModel: ObservableObject {

    @Published var item: {Name}Model?
    @Published var isLoading = false
    @Published var isSaving = false
    @Published var errorMessage: String?

    init(item: {Name}Model? = nil) {
        self.item = item
    }

    func fetchById(id: String) {
        beginFetching()

        {Name}API.share.getById(id: id) { [weak self] object, resMess in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.endFetching()

                if resMess.onCheckSuccess(), let object = object {
                    self.item = object
                } else {
                    self.errorMessage = resMess.message
                }
            }
        }
    }

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

    private func beginFetching() { isLoading = true }
    private func endFetching() { isLoading = false }
    private func beginSaving() { isSaving = true }
    private func endSaving() { isSaving = false }
}
```

## Rules

1. Add `@MainActor` to the ViewModel class.
2. Use `ObservableObject`; do not use iOS 17 `@Observable`.
3. Use `@Published` for reactive screen state.
4. Use `@StateObject` in the owning view and `@ObservedObject` for injected ViewModels.
5. Use `[weak self]` in every escaping closure.
6. Dispatch to the main queue before UI state updates when callbacks are not guaranteed to be main-threaded.
7. Check `resMess.onCheckSuccess()` before processing API responses.
8. Do not import UIKit or SwiftUI in ViewModels unless the existing project pattern explicitly requires it.
9. Keep loading helpers explicit: `beginFetching`, `endFetching`, `beginSaving`, `endSaving`.
10. Provide computed state needed by the screen, such as `isEmpty`, `filteredItems`, and validation flags.
11. Keep state aligned with the provided image or written requirements.

## Verification

After implementation:

1. Register new Swift files in the Xcode target.
2. Run the repository build verification command or shared `ttb-verify.sh` script when present.
3. Run the shared compliance check script when present.
4. Complete only when the build succeeds, or report exact blockers after three repair attempts.
