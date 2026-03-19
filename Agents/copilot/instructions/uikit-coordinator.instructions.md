---
applyTo: "**/*Coordinator.swift,**/Coordinators/**/*.swift"
---

# Coordinator File Rules — Flow Navigation

## Base Pattern
```swift
class MyFlowCoordinator: TTCoordinator {
    fileprivate var currVC: UIViewController?

    init(withCurrentVC vc: UIViewController) {
        self.currVC = vc
    }

    init(withCurrentVC vc: UIViewController, someId: Int) {
        self.currVC = vc
        // store additional params
    }
}

extension MyFlowCoordinator {
    func start() {
        DispatchQueue.main.async {
            self.handleNavigation()
        }
    }
}
```

## Navigation Patterns in Coordinators
```swift
// Present with nav controller (most common for flows)
let vc = StepOneViewController()
self.currVC?.presentDef(vc: UINavigationController(rootViewController: vc), type: .overFullScreen)

// Push onto existing nav stack
self.currVC?.push(someVC)

// Using ScreenCoordinator for deep linking
let model = ScreenNotiModel()
model.screenName = .DETAIL_PROVIDER
model.serviceScreenId = id
ScreenCoordinator(withCurrentVC: self.currVC!, model: model).start()
```

## Login Guard
```swift
self.currVC?.onCheckAndPushLoginCompleteOnlyFlow {
    // Only executes if user is authenticated
    self.startActualFlow()
}
```

## Multi-Step Flow
```swift
func startStep1() {
    let vc = Step1ViewController()
    vc.onComplete = { [weak self] result in self?.startStep2(with: result) }
    self.currVC?.presentDef(vc: UINavigationController(rootViewController: vc), type: .overFullScreen)
}

func startStep2(with data: SomeData) {
    let vc = Step2ViewController(data: data)
    vc.onComplete = { [weak self] in self?.finish() }
    self.currVC?.push(vc)
}

func finish() {
    self.currVC?.closeAll(animated: true) {}
}
```

## Tab Switching
```swift
self.currVC?.setSelectTab(with: .HOME)
self.currVC?.setSelectTab(with: .APPOINEMT)
self.currVC?.setSelectTab(with: .PAYMENT)
```

## Rules
- Extend `TTCoordinator`
- Hold `currVC: UIViewController?`
- Always call `start()` to begin flow, wrapped in `DispatchQueue.main.async`
- Use `[weak self]` in completion handlers
- Login-guarded flows wrap in `onCheckAndPushLoginCompleteOnlyFlow`
