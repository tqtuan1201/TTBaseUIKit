---
applyTo: "**/*ViewModel.swift"
---

# ViewModel File Rules — MVVM

## Base Structure
```swift
import Foundation  // ← NEVER import UIKit in ViewModel

class MyViewModel {
    // MARK: - UI Callbacks
    var onUpdateUI: (() -> Void)?
    var onShowError: ((_ message: String) -> Void)?
    var onSuccess: (() -> Void)?
    var onShowLoading: (() -> Void)?
    var onHideLoading: (() -> Void)?
    var onReloadData: (() -> Void)?

    // MARK: - Data
    var items: [ItemModel] = []
    var selectedItem: ItemModel?

    // MARK: - API
    func fetchData() {
        onShowLoading?()
        MyAPI.share.getItems { [weak self] objects, resMess in
            DispatchQueue.main.async {
                self?.onHideLoading?()
                if resMess.onCheckSuccess(), let objs = objects {
                    self?.items = objs
                    self?.onUpdateUI?()
                } else {
                    self?.onShowError?(resMess.getDes())
                }
            }
        }
    }

    func submitData() {
        let request = MyRequestData()
        request.name = selectedItem?.name
        onShowLoading?()
        MyAPI.share.create(requestData: request) { [weak self] resMess in
            DispatchQueue.main.async {
                self?.onHideLoading?()
                if resMess.onCheckSuccess() {
                    self?.onSuccess?()
                } else {
                    self?.onShowError?(resMess.getDes())
                }
            }
        }
    }
}
```

## Rules
- NEVER import UIKit — ViewModel is UI-independent
- Use closure callbacks (not delegates) for VC communication
- Always dispatch to main thread before calling UI callbacks
- Always `[weak self]` in API callbacks
- Check `resMess.onCheckSuccess()` before accessing data
- Get error message: `resMess.getDes()`
- Data validation logic lives HERE, not in ViewController
- Business logic lives HERE, not in ViewController
