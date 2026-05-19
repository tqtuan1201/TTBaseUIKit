---
name: "ttb-rule-memory-leaks"
description: "Memory leak detection and prevention for TTBaseUIKit apps: closure retain cycles, delegates, NotificationCenter, timers, and SwiftUI state."
version: "2.0.0"
---

# ttb-rule-memory-leaks — Memory Leak Detection

Memory leak detection and prevention for TTBaseUIKit apps.

## Closure Retain Cycles

### The Problem
```swift
// ❌ BAD: self is strongly captured
self.viewModel.onSuccess = { self.pop() }
self.viewModel.onShowError = { self.showAlert(msg) }
```

### The Fix
```swift
// ✅ GOOD: weak self, guard, then use
self.viewModel.onSuccess = { [weak self] in self?.pop() }
self.viewModel.onShowError = { [weak self] msg in
    guard let self = self else { return }
    self.showAlert(msg)
}
```

## Delegate Retain Cycles

### The Problem
```swift
// ❌ BAD: delegate is strong by default
class MyView: UIView {
    var delegate: MyViewDelegate?  // Strong!
}
```

### The Fix
```swift
// ✅ GOOD: delegate is weak
class MyView: UIView {
    weak var delegate: MyViewDelegate?
}
```

## NotificationCenter Retain Cycles

### The Problem
```swift
// ❌ BAD: observer not removed
override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(
        self,
        selector: #selector(handleNotification),
        name: .someNotification,
        object: nil
    )
}
// deinit does NOT remove observer
```

### The Fix
```swift
// ✅ GOOD: remove in deinit
override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(
        self,
        selector: #selector(handleNotification),
        name: .someNotification,
        object: nil
    )
}

deinit {
    NotificationCenter.default.removeObserver(self)
    TTBaseFunc.shared.printLog(with: "Deinit: ", object: "ClassName")
}
```

## Timer Retain Cycles

### The Problem
```swift
// ❌ BAD: timer retains self strongly
Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
    self.updateUI()  // self retained!
}
```

### The Fix
```swift
// ✅ GOOD: weak self + invalidate in deinit
private var timer: Timer?

override func viewDidLoad() {
    super.viewDidLoad()
    self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
        self?.updateUI()
    }
}

deinit {
    self.timer?.invalidate()
    self.timer = nil
    NotificationCenter.default.removeObserver(self)
    TTBaseFunc.shared.printLog(with: "Deinit: ", object: "ClassName")
}
```

## SwiftUI @StateObject / @ObservedObject

### The Problem
```swift
// ❌ BAD: @StateObject for passed-in VM
struct MyScreen: View {
    @StateObject var vm: MyViewModel  // Should not create @StateObject here
}
```

### The Fix
```swift
// ✅ GOOD: @StateObject for owned, @ObservedObject for passed
struct ParentScreen: View {
    @StateObject private var vm = MyViewModel()  // @StateObject for owned
    var body: some View {
        ChildScreen(vm: vm)  // Pass to child
    }
}

struct ChildScreen: View {
    @ObservedObject var vm: MyViewModel  // @ObservedObject for passed
}
```

## Checklist

| # | Check | Pattern |
|---|-------|---------|
| 1 | All closures have `[weak self]` | API, handlers, animations |
| 2 | All `guard let self = self` after weak capture | Before any `self` usage |
| 3 | All delegates are `weak` | Protocol delegates |
| 4 | `deinit` removes all observers | `removeObserver(self)` |
| 5 | `deinit` invalidates all timers | `timer?.invalidate()` |
| 6 | `deinit` has `TTBaseFunc.shared.printLog` | Confirm cleanup |
| 7 | `@StateObject` for owned VM | SwiftUI screens |
| 8 | `@ObservedObject` for passed VM | SwiftUI sub-views |

## Detection

1. **Xcode Memory Graph**: Debug → Memory Graph Debugger
2. **Instruments → Leaks**: Profile for memory leaks
3. **Instruments → Allocations**: Track object lifecycles
4. **Deinit logs**: `TTBaseFunc.shared.printLog` in deinit confirms cleanup

---

**Version**: 2.0.0 | **Date**: 2026-05-19
**Changelog**: v2.0.0 — Fixed XPrint → TTBaseFunc.shared.printLog. Fixed deinit log format. Version bumped.
