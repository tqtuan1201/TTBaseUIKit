---
name: "ttb-skill-bugfix"
description: "Systematic bug fixing workflow for TTBaseUIKit apps: root cause analysis, fix strategy, xcodebuild verify, zero regression."
version: "2.2.0"
date_updated: "2026-05-22"
risk: "safe"
source: "internal"
loadLevel: "domain"
tags: ["bugfix", "debug", "crash", "root-cause-analysis", "regression", "routing"]
---

# ttb-skill-bugfix

> Enterprise-grade bug fixing workflow for TTBaseUIKit apps.
> Root Cause Analysis | Minimal Fix | Zero Regression | xcodebuild CLI

## When to Use

- "fix bug", "debug", "sửa lỗi", "crash", "error"
- "app crashes", "wrong behavior", "regression"
- "memory leak", "performance issue", "ui not updating"

## Routing Contract

```yaml
input:
  required: [symptom, affected_area_or_files, expected_behavior]
  optional: [crash_log, reproduction_steps, recent_changes, device_or_ios_version]
output:
  artifacts: [root_cause, fix_strategy, changed_files, verification_report, residual_risk]
  completion_gate: "bug fixed with zero regression or blocker documented"
confidence:
  auto_route: ">= 0.78 for crash/debug/fix/regression/memory leak/wrong behavior intents"
  clarify: "0.55-0.77 when symptom lacks reproduction or affected area"
fallback:
  default: "Collect evidence first. Do not refactor until the failing behavior is understood."
```

Multilingual aliases: `fix bug`, `debug crash`, `regression`, `sửa lỗi`, `sua loi`, `crash khi tap`, `UI không cập nhật`, `loi logic`.

Anti-patterns: do not patch symptoms without root cause; do not mix broad refactor with urgent bugfix; do not exceed three verification attempts without reporting blockers.

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

**Version**: 2.2.0 | **Date**: 2026-05-22
**Changelog**: v2.2.0 — Added standardized routing contract, EN/VI bug aliases, input/output schema, confidence guidance, and fallback strategy. v2.0.0 — Version bump, Iron Laws, critical token warnings, and shared resource alignment.
