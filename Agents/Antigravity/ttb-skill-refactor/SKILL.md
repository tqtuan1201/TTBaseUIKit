---
name: "ttb-skill-refactor"
description: "Refactor TTBaseUIKit code: migrate to TTViewCodable, replace raw UIKit with TTBaseUIKit, TTBaseSUI adoption, clean MVVM separation."
version: "2.2.0"
date_updated: "2026-05-22"
risk: "safe"
source: "internal"
loadLevel: "domain"
tags: ["refactor", "migration", "ttviewcodable", "ttbasesui", "cleanup", "routing"]
---

# ttb-skill-refactor

> Enterprise-grade refactoring workflow for TTBaseUIKit apps.
> Zero Functional Change | TTViewCodable | TTBaseSUI | MVVM-C

## When to Use

- "refactor", "clean up code", "restructure"
- "migrate to TTViewCodable"
- "replace raw UIKit with TTBaseUIKit"
- "migrate native SwiftUI to TTBaseSUI"

## Routing Contract

```yaml
input:
  required: [refactor_goal, affected_files_or_module, behavior_to_preserve]
  optional: [target_pattern, migration_constraints, verification_command]
output:
  artifacts: [migration_plan, changed_files, before_after_notes, verification_report]
  completion_gate: "zero behavior change + build/compliance verification"
confidence:
  auto_route: ">= 0.78 for refactor/cleanup/migration/raw UIKit replacement intents"
  clarify: "0.55-0.77 when prompt mixes bugfix and cleanup"
fallback:
  default: "If behavior is broken, run ttb-skill-bugfix first. If user only wants scoring, route to audit."
```

Multilingual aliases: `refactor`, `clean up code`, `migrate to TTViewCodable`, `replace raw UIKit`, `dọn code`, `don code`, `tái cấu trúc`, `giam trung lap`.

Anti-patterns: do not add new features during refactor; do not change behavior silently; do not migrate across unrelated modules in one step.

## Scope

| Command | Scope |
|---------|-------|
| `/ttb-refactor-uikit` | UIKit → TTViewCodable, TTBaseUIKit |
| `/ttb-refactor-swiftui` | Native SwiftUI → TTBaseSUI |

## Workflow Overview

### UIKit Refactoring (5 Phases)

See `ttb-skill-refactor.prompt.md` for detailed steps:

| Phase | Focus |
|-------|-------|
| 1 | MVVM Separation — ViewModel purity |
| 2 | TTViewCodable Adoption |
| 3 | Component Replacement — TTBaseUIKit |
| 4 | Constraint Refactoring — token usage |
| 5 | Handler Refactoring — closures |

### SwiftUI Refactoring (4 Phases)

See `ttb-skill-refactor.prompt.md` for detailed steps:

| Phase | Focus |
|-------|-------|
| 1 | Component Migration — TTBaseSUI wrappers |
| 2 | Modifier Migration — token-based styling |
| 3 | iOS 14+ Compliance — API compatibility |
| 4 | View Composition — extract subviews |

## Rules

1. **ZERO behavioral change** — refactoring must not alter functionality
2. **One change at a time** — don't mix architecture with style changes
3. **Verify compilation** — ensure xcodebuild succeeds after each phase
4. **No new features** — refactoring does not add functionality
5. **Preserve git history** — commit each phase separately if possible

## Shared Resources

- `ttb-skill-shared/rules/ttb-rule-anti-patterns.md` — Full anti-pattern reference
- `ttb-skill-shared/rules/ttb-rule-coding-standards.md` — Coding conventions
- `ttb-skill-shared/rules/ttb-rule-memory-leaks.md` — Memory leak detection
- `ttb-skill-shared/refs/ttb-ref-ttbaseuikit.md` — TTBaseUIKit API reference
- `ttb-skill-shared/refs/ttb-ref-ttbasesui.md` — TTBaseSUI component reference
- `ttb-skill-shared/refs/ttb-ref-ios14-compatibility.md` — iOS 14 API guide

## Output Format

See `ttb-skill-refactor.prompt.md` for the complete REFACTOR REPORT template.

---

**Version**: 2.2.0 | **Date**: 2026-05-22
**Changelog**: v2.2.0 — Added standardized routing contract, EN/VI refactor aliases, input/output schema, confidence guidance, and fallback strategy. v2.0.0 — Version bump, Iron Laws, critical token warnings, and shared resource alignment.
