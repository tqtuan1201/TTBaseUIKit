---
description: "Systematic bug fixing workflow: triage, root cause analysis, fix strategy, xcodebuild verify, zero regression."
---

# ttb-skill-bugfix -- Bug Fix Workflow

Systematic bug diagnosis and fixing for TTBaseUIKit apps.

## Mandatory Preflight Execution Gate

Before generating code or modifying files, run `ttb-skill-shared/fragments/ttb-preflight-execution-gate.frag.md`.

Required checks:

- Analyze intent, task type, scope, impacted files/modules, dependencies, architecture constraints, coding standards, and project-specific rules.
- Validate required inputs such as target module, screen/component name, file location, navigation flow, expected output, API contract, state management, routing, localization, naming, and reusable component requirements.
- Detect ambiguity, conflicting requirements, incomplete business logic, unclear UX/navigation, unclear module ownership, and unclear architecture direction.
- Score confidence from `0-100`: execute at `90-100`, execute with warning assumptions at `70-89`, and ask a survey below `70` using `ttb-skill-shared/templates/ttb-clarification-survey.md`.
- Support English, Vietnamese, mixed-language, diacritic-free Vietnamese, and light typo prompts.

## When

User says: "fix bug", "debug", "sửa lỗi", "crash", "app crashes", "wrong behavior"

## Workflow

### Phase 1 -- Triage
1. Gather evidence: error message, crash log, file, steps to reproduce
2. Classify severity: CRITICAL / HIGH / MEDIUM / LOW
3. Map dependency graph

### Phase 2 -- Root Cause Analysis

#### UIKit Checklist
| Check | Issue |
|-------|-------|
| `[weak self]` | All closures: `onTouchHandler`, API, NotificationCenter, Timer |
| Thread | API callback not dispatching to `DispatchQueue.main.async` |
| `super` | `viewDidLoad`, `viewWillAppear` without `super` |
| Container | Subviews added to `self.view` instead of `self.contentView` |
| `.done()` | Constraint chain without terminal `.done()` |
| Force unwrap | `!` on optionals that can be nil |
| `onCheckSuccess()` | API response processed without check |
| `removeObserver` | `deinit` without `NotificationCenter.default.removeObserver(self)` |
| Navigation | `navigationController?.pushViewController` instead of `self.push(vc)` |
| ViewModel | ViewModel importing UIKit |
| `super.encode` | `RequestData` without `super.encode(to:)` |
| `BaseViewModel` | Missing `beginFetching()` / `endFetching()` |

#### SwiftUI Checklist
| Check | Issue |
|-------|-------|
| `[weak self]` | Closures in View |
| `@ObservedObject` | Should be `@StateObject` for owned VM |
| `.onAppear` data | No `.onAppear { }` for data fetch |
| `.task { }` | Use `.onAppear { Task { } }` on iOS 14 |
| `NavigationStack` | Use `SUIBaseView` |
| `NavigationView` | Replace direct screen wrapper with `SUIBaseView(backType:title:type:isHiddenTabbar:backAction:)` |
| `NavigationLink` | Replace direct navigation with `TTBaseNavigationLink(destination:label:isAnimation:)` |
| Broad `@Published` | Publishing entire model object |

### Phase 3 -- Fix Strategy
- Minimal change: fix only the root cause
- Preserve architecture: use existing patterns
- Check blast radius: what else might break

### Phase 4 -- Implementation
- Apply fix
- xcodebuild verify
- Anti-Loop: max 3 attempts

### Phase 5 -- Verification
- Check all callers of modified function
- Check navigation flow still works
- Check memory management
- Check loading/error handling both covered

## Post-Fix Verification (MANDATORY)

After all fixes are applied, **run Phase 6 verification**:

1. **Run verification**:
   ```bash
   bash ttb-skill-shared/scripts/ttb-verify.sh
   ```
2. **Check compliance**:
   ```bash
   bash ttb-skill-shared/scripts/ttb-compliance-check.sh
   ```
3. **Fix is complete only when** `BUILD SUCCEEDED`

**Anti-Loop**: Max 3 build attempts. 3 failures — STOP, document errors.

For full FCR 7-Dimension scoring, see `ttb-skill-shared/phases/ttb-phase-verify.md`.

## Anti-Loop Protocol
- Max 3 build attempts per fix
- 3 failures → STOP, document errors, escalate

## Severity Levels

| Level | Criteria | Timeline |
|-------|---------|----------|
| 🔴 CRITICAL | App crash, data loss, security | < 2 hours |
| 🟡 HIGH | Feature broken, major UX blocked | < 8 hours |
| 🟢 MEDIUM | Partially broken, workaround exists | < 3 days |
| 🔵 LOW | Cosmetic, minor annoyance | Backlog |
