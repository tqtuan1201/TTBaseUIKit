---
description: "Scaffold a new TTBaseUIKit Coordinator for multi-step navigation flow."
---

# ttb-skill-coordinator -- UIKit Coordinator Builder

Scaffold a new Coordinator for multi-step navigation flow.

## When

User says: "build coordinator", "navigation flow", "multi-step flow"

## Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  {Name}Coordinator.swift
//  {AppName}
//

import Foundation
import TTBaseUIKit

class {Name}Coordinator: TTCoordinator {
    fileprivate var currVC: UIViewController?
    fileprivate var itemId: Int = -1

    init(withCurrentVC vc: UIViewController, itemId: Int = -1) {
        self.currVC = vc
        self.itemId = itemId
    }
}

extension {Name}Coordinator {
    func start() {
        DispatchQueue.main.async {
            self.currVC?.onCheckAndPushLoginCompleteOnlyFlow {
                self.showStepOne()
            }
        }
    }

    private func showStepOne() {
        let vc = {StepOne}ViewController()
        vc.onComplete = { [weak self] result in
            self?.showStepTwo(with: result)
        }
        self.currVC?.presentDef(
            vc: UINavigationController(rootViewController: vc),
            type: .overFullScreen
        )
    }

    private func showStepTwo(with data: StepOneData) {
        let vc = {StepTwo}ViewController(data: data, itemId: self.itemId)
        vc.onComplete = { [weak self] in
            self?.finish()
        }
        self.currVC?.push(vc)
    }

    private func finish() {
        self.currVC?.closeAll(animated: true) {}
    }
}
```

## Deep Linking

```swift
// For notification-triggered or deep-link navigation:
let model = ScreenNotiModel()
model.screenName = .{SCREEN_ENUM}
model.serviceScreenId = itemId
ScreenCoordinator(withCurrentVC: self.currVC!, model: model).start()
```

## Rules

1. Extend `TTCoordinator`
2. Hold `currVC: UIViewController?`
3. Wrap `start()` in `DispatchQueue.main.async`
4. Use `[weak self]` in all completion handlers
5. Login-guarded: `onCheckAndPushLoginCompleteOnlyFlow`
6. Call `start()` to begin the flow
7. Prefer `import Foundation` + `import TTBaseUIKit` (UIKit is re-exported by TTBaseUIKit)

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
