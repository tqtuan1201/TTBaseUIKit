---
description: "Scaffold a complete MVVM feature module: ViewController + ViewModel + API + Model"
---

# Create Full Feature Module

Scaffold an entire MVVM feature module with all required files.

## Generated Files
1. `{Name}ViewController.swift` — UI screen with TTBaseUIKit components
2. `{Name}ViewModel.swift` — business logic + API integration
3. `{Name}API.swift` — API singleton (if new endpoint needed)
4. `{Name}Model.swift` — Codable response model
5. `{Name}RequestData.swift` — request body (if POST/PUT needed)

## Steps

1. **Clarify**: Ask for feature name, screen type (list/form/detail), API endpoints, model fields
2. **Plan**: List all files to create with locations
3. **Generate Model**: `struct {Name}Model: Codable { ... }`
4. **Generate API**: Singleton with GET/POST methods
5. **Generate ViewModel**: Business logic, API calls, closure callbacks
6. **Generate ViewController**: BaseUIViewController with TTBaseUIKit components
7. **Verify Checklist**:
   - ✅ **iOS 14+ APIs only** — no iOS 15+/16+/17+ APIs
   - ✅ All TTBaseUIKit components (no raw UIKit)
   - ✅ `[weak self]` everywhere
   - ✅ Constraint chain `.done()`
   - ✅ ViewModel has no UIKit import
   - ✅ RequestData subclass calls `super.encode`
   - ✅ `deinit` in ViewController
   - ✅ Loading/error handling

## Architecture
```
ProjectRoot/
├── API/{Name}API.swift              ← singleton API service
├── Model/{Name}Model.swift          ← Codable response model
└── Views/{Name}/
    ├── {Name}ViewController.swift   ← UI + layout
    └── {Name}ViewModel.swift        ← business logic
```

## Plan Output (MANDATORY)

After completing any work, generate a plan file for future context:

1. Create `plans/YYYY-MM-DD-{feature-name}/plan.md`
2. Include: date, goal, files table (NEW/MODIFY/DELETE), patterns & tokens used, context for future upgrades
3. Auto-add plan file to Xcode:
```bash
ruby .agent/skills/ttbase-swiftui/scripts/add_to_xcode_project.rb "{plan_file_path}"
```

> See `instructions/plan-generation.instructions.md` for full templates.

---

## 🚩 Code Generation Comment (MANDATORY)
All generated Swift code MUST include:
```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
```
