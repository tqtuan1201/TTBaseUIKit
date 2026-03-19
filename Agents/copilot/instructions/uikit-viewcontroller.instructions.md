---
applyTo: "**/*ViewController.swift"
---

# UIKit ViewController Rules — TTBaseUIKit

## Class Declaration
Always extend `BaseUIViewController` (project base, extends `TTBaseUIViewController<DarkBaseUIView>`).

```swift
class {{Name}}ViewController: BaseUIViewController {
    override var navBaseStype: BaseUINavigationView.TYPE { return .DEFAULT }
    // Override to hide tab bar when pushed: override var isHidenTabar: Bool { return true }
}
```

## Initialization
```swift
// Standard inits (use convenience inits from BaseUIViewController)
let vc = MyViewController()
let vc = MyViewController(withTitleNav: "Title")
let vc = MyViewController(backType: .BACK_POP)
```

Never use `UINavigationController?.pushViewController` — use:
```swift
self.push(vc)             // push
self.pop()                // back
self.close()              // pop or dismiss (smart)
self.presentDef(vc: vc)  // modal
```

## Lifecycle Order
```swift
override func viewDidLoad() {
    super.viewDidLoad()   // ← always first
    self.setTitleNav("Title")
    self.bindViewModel()
    self.setupUI()
    self.setupConstraints()
    self.loadData()
}
override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated) }
override func viewDidAppear(_ animated: Bool)  { super.viewDidAppear(animated) }
override func viewWillDisappear(_ animated: Bool) { super.viewWillDisappear(animated) }
deinit {
    NotificationCenter.default.removeObserver(self)
    XPrint("Deinit: \(self.description)")
}
```

## NavBar Themes
```swift
// .DEFAULT — back button + title
// .COLOR   — colored nav bar with white title + back icon
// .SHADOW  — adds shadow line under nav bar
var navTheme: BaseUINavigationView.THEME { return .NONE }
```

## Navigation Bar Title + Buttons
```swift
self.setTitleNav("Screen Title")

// Right button: override navDidTouchUpRightButton in BaseUINavigationViewDelegate extension
extension MyVC: BaseUINavigationViewDelegate {
    func navDidTouchUpRightButton(withNavView nav: BaseUINavigationView) { ... }
}
```

## Content View
Add all subviews to `self.contentView` (not `self.view`):
```swift
self.contentView.addSubviews(views: [view1, view2])
```

## Loading
```swift
self.showLoadingView(type: .VIEW_CENTER)    // spinner overlay
self.showLoadingView(type: .NAV_BUTTOM)     // progress bar
self.removeLoading()                          // always call on completion
```

## Alerts & Notifications
```swift
self.showAlert("Message")
self.showAlert("Title", "Subtitle")
self.showNotification(type: .ERROR, message: "Failed")
self.showNotification(type: .SUCCESS, message: "Saved")
```
