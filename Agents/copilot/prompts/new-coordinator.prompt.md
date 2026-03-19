---
description: "Create a new Coordinator for multi-step navigation flow"
---

# Create New Coordinator

Scaffold a TTCoordinator for a multi-step navigation flow.

## Template

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
import Foundation
import TTBaseUIKit
import UIKit

class {Name}Coordinator: TTCoordinator {
    fileprivate var currVC: UIViewController?
    fileprivate var someId: Int = -1

    init(withCurrentVC vc: UIViewController, id: Int = -1) {
        self.currVC = vc
        self.someId = id
    }
}

extension {Name}Coordinator {
    func start() {
        DispatchQueue.main.async {
            self.currVC?.onCheckAndPushLoginCompleteOnlyFlow {
                self.startFlow()
            }
        }
    }

    fileprivate func startFlow() {
        let vc = {Step1}ViewController()
        vc.onComplete = { [weak self] result in
            self?.goToStep2(with: result)
        }
        self.currVC?.presentDef(vc: UINavigationController(rootViewController: vc), type: .overFullScreen)
    }

    fileprivate func goToStep2(with data: SomeData) {
        let vc = {Step2}ViewController(data: data)
        vc.onComplete = { [weak self] in
            self?.finish()
        }
        self.currVC?.push(vc)
    }

    fileprivate func finish() {
        self.currVC?.closeAll(animated: true) {}
    }
}
```

## Steps
1. Ask for coordinator name, flow steps, and data passed between steps
2. Generate Coordinator with appropriate step methods
3. Confirm file location in `Coordinators/`

## Plan Output (MANDATORY)

After completing any work, generate a plan file for future context:

1. Create `plans/YYYY-MM-DD-{feature-name}/plan.md`
2. Include: date, goal, files table (NEW/MODIFY/DELETE), patterns & tokens used, context for future upgrades
3. Auto-add plan file to Xcode:
```bash
ruby .agent/skills/ttbase-swiftui/scripts/add_to_xcode_project.rb "{plan_file_path}"
```

> See `instructions/plan-generation.instructions.md` for full templates.
