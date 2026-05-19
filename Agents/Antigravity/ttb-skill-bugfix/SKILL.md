---
name: "ttb-skill-bugfix"
description: "Systematic bug fixing workflow for TTBaseUIKit apps: root cause analysis, fix strategy, xcodebuild verify, zero regression."
version: "2.0.0"
loadLevel: "domain"
---

# ttb-skill-bugfix

> Enterprise-grade bug fixing workflow for TTBaseUIKit apps.
> Root Cause Analysis | Minimal Fix | Zero Regression | xcodebuild CLI

## When to Use

- "fix bug", "debug", "sửa lỗi", "crash", "error"
- "app crashes", "wrong behavior", "regression"
- "memory leak", "performance issue", "ui not updating"

## Bug Classification

| Symptom | Category | Primary Files to Check |
|---------|----------|----------------------|
| Crash on load | Startup / lifecycle | ViewController, AppDelegate, Coordinator |
| Crash when tapping | UI interaction | VC, CustomView, Handler |
| Blank screen | Data flow | ViewModel, API, TTViewCodable |
| UI not updating | Binding / thread | VM callbacks, main thread |
| Memory growth | Retain cycle | Closures, delegates, VC |
| Slow performance | CPU / layout | viewDidLoad, constraints |
| Navigation broken | Flow / coordinator | Coordinator, push/pop calls |
| API error | Network / parsing | API service, RequestData, Model |

## Workflow

### Phase 1 — Triage
Gather evidence, classify severity, map dependency graph.
See `ttb-skill-bugfix.prompt.md` for detailed steps.

### Phase 2 — Root Cause Analysis
TTBaseUIKit anti-pattern checklists (UIKit + SwiftUI).
See `ttb-skill-bugfix.prompt.md` for full checklists.

### Phase 3 — Fix Strategy
Minimal change, preserve architecture, RICE scoring.
See `ttb-skill-bugfix.prompt.md` for strategy details.

### Phase 4 — Implementation
Apply fix, xcodebuild verify, Anti-Loop (max 3 attempts).

### Phase 5 — Verification
Check callers, navigation, memory management, error handling.

## Detailed Workflow

See `ttb-skill-bugfix.prompt.md` for the complete workflow including:
- Dependency graph mapping
- UIKit anti-pattern checklist (10 items)
- SwiftUI anti-pattern checklist (7 items)
- Output format template
- Anti-Loop Protocol

## Severity Levels

| Level | Criteria | Timeline |
|-------|---------|----------|
| CRITICAL | App crash, data loss, security | < 2 hours |
| HIGH | Feature broken, major UX blocked | < 8 hours |
| MEDIUM | Partially broken, workaround exists | < 3 days |
| LOW | Cosmetic, minor annoyance | Backlog |

## Shared Resources

- `ttb-skill-shared/rules/ttb-rule-anti-patterns.md` — Full anti-pattern reference
- `ttb-skill-shared/rules/ttb-rule-memory-leaks.md` — Memory leak detection
- `ttb-skill-shared/rules/ttb-rule-coding-standards.md` — Code quality rules

## Output Format

See `ttb-skill-bugfix.prompt.md` for the complete BUG FIX REPORT template.

---

**Version**: 2.0.0 | **Date**: 2026-05-19
**Changelog**: v2.0.0 — Version bump. Added 11 Iron Laws. Added critical token warnings. Updated shared resources to v2.0.0. v1.4.0 — Updated ttb-rule-coding-standards.md and ttb-rule-anti-patterns.md with chainable extensions.
