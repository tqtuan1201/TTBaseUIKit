---
name: "ttb-skill-audit"
description: "Code audits for TTBaseUIKit apps: performance, accessibility, localization. FCR compliance scoring."
version: "2.2.0"
date_updated: "2026-05-22"
risk: "safe"
source: "internal"
loadLevel: "on-demand"
tags: ["audit", "performance", "accessibility", "localization", "fcr", "routing"]
---

# ttb-skill-audit

> Code audit skill set for TTBaseUIKit apps.
> Performance | Accessibility | Localization | FCR Compliance

## Mandatory Preflight Execution Gate

Before this skill generates code, refactors, migrates, modifies files, creates architecture, updates UI/navigation, changes dependencies, updates workflows, or changes business logic, run the shared gate:

- `ttb-skill-shared/fragments/ttb-preflight-execution-gate.frag.md`
- `ttb-skill-shared/templates/ttb-clarification-survey.md` when confidence is below threshold

Required phase order: Requirement Analysis -> Context Validation -> Ambiguity Detection -> Missing Information Detection -> Survey / Clarification -> Confidence Evaluation -> Execution Approval.

Execution thresholds:

| Confidence | Action |
|------------|--------|
| `90-100` | Execute directly and state key assumptions |
| `70-89` | Execute only with documented low-risk assumptions |
| `<70` | Do not execute; ask a concise survey first |

Cap confidence at `69` when target module, architecture direction, UIKit/SwiftUI choice, navigation behavior, API/business logic, localization format, state management, dependency info, or ownership is unclear. Parse English, Vietnamese, mixed-language, diacritic-free Vietnamese, and light typos before scoring.

## Skills in This Set

| Command | Description |
|---------|-------------|
| `/ttb-audit-performance` | Performance: rendering, memory, CPU, main thread |
| `/ttb-audit-accessibility` | VoiceOver, Dynamic Type, touch targets, color contrast |
| `/ttb-audit-localization` | Hardcoded strings, missing keys, naming violations |

## Routing Contract

```yaml
input:
  required: [audit_type, scope]
  optional: [target_score, known_risks, files_or_modules, fix_requested]
output:
  artifacts: [findings, fcr_score, prioritized_recommendations, optional_fix_plan]
  completion_gate: "findings reported before fixes unless user explicitly requests fixes"
confidence:
  auto_route: ">= 0.78 for audit/review/performance/accessibility/localization/FCR/compliance intents"
  clarify: "0.55-0.77 when audit type or scope is unclear"
fallback:
  default: "Run general FCR audit if user asks broad code audit; chain to bugfix/refactor only when fixes are requested."
```

Multilingual aliases: `audit code`, `performance audit`, `accessibility audit`, `localization check`, `kiểm tra hiệu năng`, `kiem tra ngon ngu`, `chấm điểm FCR`, `danh gia compliance`.

Anti-patterns: do not hide findings behind summaries; do not fix before reporting audit results unless explicitly requested; do not score without stating evidence.

## FCR 7-Dimension Compliance Score

| Dimension | Weight | Check |
|-----------|--------|-------|
| iOS 14+ API | 15% | No iOS 15+/16+/17+ APIs |
| TTBaseUIKit Compliance | 20% | All components, no raw UIKit |
| Config Tokens | 15% | TTView/TTSize/TTFont everywhere |
| MVVM Separation | 15% | ViewModel pure, VC thin |
| Closure Safety | 15% | [weak self] everywhere |
| Localization | 10% | XText/XTextU with Localizable.strings |
| Code Quality | 10% | MARK sections, naming, style |

```
Score >= 85: READY
Score 70-84: NEEDS FIX
Score < 70: BLOCKED
```

## Shared Audit Checklist

### Component Compliance
| ❌ Issue | ✅ Fix |
|---------|------|
| Raw `UILabel()` | `TTBaseUILabel` |
| Raw `UIButton()` | `TTBaseUIButton` |
| Raw `Text("...")` | `TTBaseSUIText` or native `Text` with tokens |
| Raw `Button(...)` | `TTBaseSUIButton` or native `Button` |

### Config Token Compliance
| ❌ Hardcoded | ✅ Token |
|-------------|---------|
| `UIColor(hex: "#555")` | `TTView.textDefColor` |
| `Color.blue` | `TTView.buttonBgDef.toColor()` |
| `8` (padding) | `TTSize.P_CONS_DEF` |
| `16` (padding) | `TTSize.P_CONS_DEF * 2` |
| `UIFont.systemFont(ofSize: 14)` | `TTFont.TITLE_H` |

### Closure Safety
| ❌ Issue | ✅ Fix |
|---------|------|
| Missing `[weak self]` | `[weak self]` + `self?.` |
| Strong self in API callback | `[weak self]` + guard |
| `NotificationCenter` observer without weak | `{ [weak self] _ in self?.reload() }` |

### Lifecycle
| ❌ Issue | ✅ Fix |
|---------|------|
| Missing `deinit` | Add with `removeObserver` + `XPrint` |
| Missing `super.viewDidLoad()` | Call `super` first |
| Subviews on `self.view` | `self.contentView` |

## Files in This Skill Set

| File | Purpose |
|------|---------|
| `ttb-skill-audit-performance.prompt.md` | Performance audit |
| `ttb-skill-audit-accessibility.prompt.md` | Accessibility audit |
| `ttb-skill-audit-localization.prompt.md` | Localization audit |

## Post-Audit Verification (MANDATORY)

After audit fixes are applied, run Phase 6 from `ttb-phase-verify.md`:

**Step 1 — xcodebuild Build**
```bash
cd /path/to/TTBaseUIKitExample
xcodebuild -project TTBaseUIKitExample.xcodeproj \
  -scheme TTBaseUIKitExample \
  -destination 'platform=iOS Simulator,name=iPhone 11' \
  build 2>&1 | tail -50
```
| Result | Action |
|--------|--------|
| `BUILD SUCCEEDED` | ✅ Proceed |
| `BUILD FAILED` | Fix errors → re-run (max 3 attempts) |

**Step 2 — Output Verification Report**
Report layers 1-5 from `ttb-phase-verify.md`. Audit is complete only when `✅ BUILD SUCCEEDED`.

---

**Version**: 2.2.0 | **Date**: 2026-05-22
**Changelog**: v2.2.0 — Added standardized routing contract, EN/VI audit aliases, input/output schema, confidence guidance, and fallback strategy. v2.0.0 — Version bump, Iron Laws, critical token warnings, and shared resource alignment.
