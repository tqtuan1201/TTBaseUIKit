---
name: "ttb-phase-implementation"
description: "Phase 4 of TTBaseUIKit feature workflow: build feature according to spec, following TTBaseUIKit patterns with xcodebuild verification."
version: "2.0.0"
---

# ttb-phase-implementation — Implementation Phase

## Purpose

Build the feature according to spec, following TTBaseUIKit patterns, with xcodebuild verification.

Implementation is blocked unless `fragments/ttb-preflight-execution-gate.frag.md` has produced `execute` or `execute-with-assumptions`.

## Input
- Feature Spec output
- Approved spec
- Preflight gate decision with confidence `>=70`

## Steps

### 1. Build in Order
Before writing any file, verify that target module, file locations, architecture pattern, navigation flow, API/business logic, localization format, state management, dependency impact, and ownership are known or safely documented as assumptions.

Build files in dependency order:
1. **Models** — no dependencies
2. **RequestData** — depends on Models
3. **API** — depends on Models, RequestData
4. **ViewModel** — depends on API
5. **Coordinator** — depends on ViewController
6. **ViewController/Screen** — depends on ViewModel, Coordinator
7. **CustomViews/Cells** — depends on Models
8. **Update Localizable.strings** — add new keys

### 2. Follow Pattern Strictly
- UIKit: TTViewCodable with all protocol methods
- SwiftUI: TTBaseSUI or Native + **SUIBaseView** wrapper
- ViewModel: BaseViewModel with callbacks
- API: Singleton with `static let share`
- Config: `TTView`/`TTSize`/`TTFont` tokens only

### 3. xcodebuild Verification
After each file:
```bash
cd /path/to/project
xcodebuild -project Project.xcodeproj -scheme Scheme -destination 'platform=iOS Simulator,name=iPhone 11' build 2>&1 | grep -E "(error:|BUILD SUCCEEDED|BUILD FAILED)"
```

### 4. Anti-Loop Protocol
- Max 3 build attempts
- 3 failures → STOP, document errors

### 5. Generate Plan File
After completion:
```
plans/YYYY-MM-DD-{feature}/plan.md
```

## Files to Create

### Required Per Screen
- `{Name}ViewController.swift` (UIKit)
- `{Name}Screen.swift` (SwiftUI with SUIBaseView)
- `{Name}ViewModel.swift`
- `{Name}Model.swift`
- `{Name}Coordinator.swift` (if multi-step)
- `{Name}API.swift` (if new endpoints)
- `{Name}RequestData.swift` (if POST/PUT)
- `{Name}Cell.swift` (if list)
- `{Name}CustomView.swift` (if reusable)

### Optional
- `CustomViews/` folder for sub-views
- `plans/YYYY-MM-DD-{feature}/plan.md`

## Verification Checklist
- [ ] iOS 14+ APIs only
- [ ] All TTBaseUIKit components used
- [ ] TTViewCodable implemented (UIKit)
- [ ] SUIBaseView wrapper (SwiftUI)
- [ ] TTBaseNavigationLink for navigation (SwiftUI)
- [ ] MVVM separation (VM no UIKit import)
- [ ] `[weak self]` in all closures
- [ ] Config tokens (`TTView`/`TTSize`/`TTFont`)
- [ ] XText/XTextU for all strings
- [ ] xcodebuild succeeds
- [ ] Plan file generated

## Rules
- Generate complete files, not snippets
- One file at a time, verify each
- Never skip xcodebuild verification
- Never commit broken code
- Never implement when preflight confidence is below `70`
- Never invent architecture, navigation, or business logic that was not validated by the spec or existing project conventions

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
