---
name: "ttb-skill-refactor"
description: "Refactor TTBaseUIKit code: migrate to TTViewCodable, replace raw UIKit with TTBaseUIKit, TTBaseSUI adoption, clean MVVM separation."
version: "2.0.0"
loadLevel: "domain"
---

# ttb-skill-refactor

> Enterprise-grade refactoring workflow for TTBaseUIKit apps.
> Zero Functional Change | TTViewCodable | TTBaseSUI | MVVM-C

## When to Use

- "refactor", "clean up code", "restructure"
- "migrate to TTViewCodable"
- "replace raw UIKit with TTBaseUIKit"
- "migrate native SwiftUI to TTBaseSUI"

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

**Version**: 2.0.0 | **Date**: 2026-05-19
**Changelog**: v2.0.0 — Version bump. Added 11 Iron Laws. Added critical token warnings. Updated shared resources to v2.0.0. v1.4.0 — Updated ttb-rule-coding-standards.md and ttb-rule-anti-patterns.md with chainable extensions.
