---
description: "Scaffold a new UIKit ViewModel with BaseViewModel, callbacks, API integration, and MVVM pattern."
---

# ttb-skill-viewmodel -- UIKit ViewModel Builder

Scaffold a new ViewModel with BaseViewModel, MVVM callbacks, and API integration.

## When

User says: "build viewmodel", "business logic", "MVVM viewmodel"

## Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  {Name}ViewModel.swift
//  {AppName}
//

import Foundation  // ← NEVER import UIKit

class {Name}ViewModel: BaseViewModel {

    // MARK: - Data
    var data: {Name}Model?
    var items: [{Name}Model] = []
    var selectedItem: {Name}Model?

    // MARK: - Fetch
    func fetchData() {
        guard beginFetching() else { return }
        {Name}API.share.getAll { [weak self] objects, resMess in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.endFetching()
                if resMess.onCheckSuccess(), let objs = objects {
                    self.items = objs
                    self.onUpdateUI?()
                } else {
                    self.onShowError?(resMess.getDes())
                }
            }
        }
    }

    func fetchById(id: Int) {
        guard beginFetching() else { return }
        {Name}API.share.getById(id: id) { [weak self] object, resMess in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.endFetching()
                if resMess.onCheckSuccess(), let obj = object {
                    self.data = obj
                    self.onUpdateUI?()
                } else {
                    self.onShowError?(resMess.getDes())
                }
            }
        }
    }

    // MARK: - Submit
    func submit() {
        guard beginFetching() else { return }
        let request = {Name}RequestData()
        request.fieldA = self.data?.fieldA
        {Name}API.share.create(requestData: request) { [weak self] resMess in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.endFetching()
                if resMess.onCheckSuccess() {
                    self.onSuccess?()
                } else {
                    self.onShowError?(resMess.getDes())
                }
            }
        }
    }

    // MARK: - Helpers
    func selectItem(_ item: {Name}Model) {
        self.selectedItem = item
    }
}
```

## Rules

1. **NEVER import UIKit** -- ViewModel is UI-framework-independent
2. **Always `[weak self]`** in API callbacks
3. **Always `DispatchQueue.main.async`** before calling UI callbacks
4. **Always `guard let self = self`** in async callbacks
5. **Always `resMess.onCheckSuccess()`** before processing data
6. **Get error message**: `resMess.getDes()`
7. **Access response data**: `object?.value`
8. **Use `beginFetching()` / `endFetching()`** for loading state guard
9. **Use `BaseViewModel`** for standard callbacks

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
