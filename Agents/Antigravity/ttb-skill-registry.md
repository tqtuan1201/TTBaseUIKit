---
name: "ttb-skill-registry"
description: "Canonical registry for TTBaseUIKit Antigravity skills, workflows, routing, cross-functional analysis, phases, rules, references, scripts, and templates."
version: "2.3.0"
date_updated: "2026-05-30"
risk: "safe"
source: "internal"
tags: ["registry", "routing", "skills", "workflows", "ttbaseuikit", "antigravity"]
---

# TTBaseUIKit Antigravity Skill Registry

**Version**: 2.3.0 | **Date**: 2026-05-30

This is the canonical registry for the Antigravity agent system. It preserves every existing `/ttb-*` command while adding semantic routing metadata for English, Vietnamese, mixed-language prompts, typo-tolerant matching, and workflow chaining.

## System Map

| Type | Location | Purpose |
|------|----------|---------|
| Root skill | `SKILL.md` | High-level activation, Iron Laws, architecture |
| Canonical registry | `ttb-skill-registry.md` | Source of truth for skill/workflow inventory |
| Shared registry shim | `ttb-skill-shared/ttb-skill-registry.md` | Backward-compatible pointer to this file |
| Intent manifest | `ttb-skill-shared/routing/intent-manifest.json` | Machine-readable routing source |
| Multilingual aliases | `ttb-skill-shared/routing/multilingual-aliases.json` | Vietnamese/English normalization |
| Intent router | `ttb-skill-shared/routing/intent-router.md` | Human-readable routing contract |
| Workflow contract | `ttb-skill-shared/workflows/ttb-workflow-standard.md` | Reusable preflight/state/retry pattern |
| Preflight gate | `ttb-skill-shared/fragments/ttb-preflight-execution-gate.frag.md` | Requirement analysis, ambiguity detection, confidence gating |
| Cross-functional analysis gate | `ttb-skill-shared/fragments/ttb-cross-functional-analysis-gate.frag.md` | Product/BA/UX/architecture/dev/QA analysis, option exploration, question gates |
| Clarification survey | `ttb-skill-shared/templates/ttb-clarification-survey.md` | Standard survey blocks for missing critical information |

## Canonical Commands

| Command | Skill | Intent | Load | Backward-Compatible Aliases |
|---------|-------|--------|------|-----------------------------|
| `/ttb-init` | `ttb-skill-init` | Project foundation, MVVM-C scaffold, config, localization, debug | `always` | `/ttb-init-project`, `/ttb-new-project`, legacy `/tts-init` |
| `/ttb-uikit` | `ttb-skill-uikit` | UIKit screen/list/form/cell/API/coordinator/viewmodel | `domain` | `/ttb-uikit-*`, legacy `/tts-uikit` |
| `/ttb-swiftui` | `ttb-skill-swiftui` | SwiftUI screen/view/list/viewmodel with SUIBaseView/TTBaseSUI | `domain` | `/ttb-sui-*`, `/ttb-native-screen`, `/ttb-native-view`, legacy `/tts-swiftui` |
| `/ttb-native-components` | `ttb-skill-native-swiftui-components` | Native SwiftUI reusable components with TTBaseUIKit tokens | `on-demand` | `/ttb-native-*`, legacy `/tts-native` |
| `/ttb-bugfix` | `ttb-skill-bugfix` | Bug/crash/debug/regression/root-cause workflow | `domain` | `/ttb-debug`, `/ttb-fix-crash`, legacy `/tts-bugfix` |
| `/ttb-refactor` | `ttb-skill-refactor` | Zero-behavior-change migration and cleanup | `on-demand` | `/ttb-refactor-uikit`, `/ttb-refactor-swiftui`, legacy `/tts-refactor` |
| `/ttb-audit` | `ttb-skill-audit` | Performance/accessibility/localization/FCR audits | `on-demand` | `/ttb-audit-*`, legacy `/tts-audit` |

## Intent Routing Summary

Routing must follow `ttb-skill-shared/routing/intent-manifest.json`.

| Prompt Family | Examples | Route |
|---------------|----------|-------|
| API/service/endpoint | `tạo api`, `tao api`, `viet api`, `generate api`, `build endpoint`, `api login`, `generate auth api` | `/ttb-uikit-api` |
| UIKit screen/list/form/cell | `tạo màn hình UIKit`, `build view controller`, `create table view`, `tao cell` | `/ttb-uikit-*` |
| SwiftUI screen/view/list | `tạo màn hình SwiftUI`, `make SUIBaseView screen`, `SwiftUI list` | `/ttb-sui-*` |
| Native SwiftUI component | `native SwiftUI button`, `tao card component`, `rating view` | `/ttb-native-*` |
| Bugfix | `sửa lỗi`, `fix crash`, `debug`, `UI không update`, `decoding error` | `/ttb-bugfix` |
| Refactor | `dọn code`, `refactor`, `migrate to TTViewCodable`, `replace raw UIKit` | `/ttb-refactor` |
| Audit | `audit`, `kiểm tra hiệu năng`, `localization check`, `FCR score` | `/ttb-audit-*` |

Confidence thresholds:

| Confidence | Action |
|------------|--------|
| `>= 0.78` | Auto-route |
| `0.55-0.77` | Ask one focused clarification |
| `< 0.55` | Load shared resources and ask for goal/framework/artifact |

Execution confidence thresholds:

| Confidence | Action |
|------------|--------|
| `90-100` | Execute directly and state key assumptions |
| `70-89` | Execute only with documented low-risk assumptions |
| `<70` | Stop and ask a survey before editing |

Every command must run the preflight gate before code generation, refactor, migration, file modification, architecture creation, workflow update, UI/navigation update, dependency update, or business logic change.

For feature updates, new feature development, and bug fixes, every command must also apply `ttb-cross-functional-analysis-gate.frag.md`: analyze as Product Owner, Business Analyst, UX/UI Designer, Solution Architect, Senior Developer, and QA; compare alternatives across business, architecture, UI/UX, performance, scalability, maintainability, security, testing, and operations; ask at least 5 value-expansion questions after analysis; and ask at least 6 blocker clarification questions when requirements are ambiguous or incomplete.

## Skill Inventory

### Core Development

| Skill | Path | Commands | Dependencies | Outputs |
|-------|------|----------|--------------|---------|
| `ttb-skill-init` | `ttb-skill-init/` | `/ttb-init`, `/ttb-init-structure`, `/ttb-init-config`, `/ttb-init-l10n`, `/ttb-init-debug` | none | MVVM-C structure, config, localization, debug setup, xcodebuild validation |
| `ttb-skill-uikit` | `ttb-skill-uikit/` | `/ttb-uikit-screen`, `/ttb-uikit-list`, `/ttb-uikit-form`, `/ttb-uikit-cell`, `/ttb-uikit-customview`, `/ttb-uikit-api`, `/ttb-uikit-coordinator`, `/ttb-uikit-viewmodel` | `ttb-skill-init` foundation | TTViewCodable UIKit artifacts, RequestAPI services, coordinators, ViewModels |
| `ttb-skill-swiftui` | `ttb-skill-swiftui/` | `/ttb-sui-screen`, `/ttb-sui-view`, `/ttb-sui-list`, `/ttb-sui-viewmodel`, `/ttb-native-screen`, `/ttb-native-view` | `ttb-skill-init` foundation | SUIBaseView screens, TTBaseSUI views/lists, SwiftUI ViewModels |
| `ttb-skill-native-swiftui-components` | `ttb-skill-native-swiftui-components/` | `/ttb-native-*` | `ttb-skill-init`, `ttb-skill-swiftui` | Reusable native SwiftUI components with TTBaseUIKit tokens |

### Quality And Maintenance

| Skill | Path | Commands | Dependencies | Outputs |
|-------|------|----------|--------------|---------|
| `ttb-skill-bugfix` | `ttb-skill-bugfix/` | `/ttb-bugfix` | affected app context | Root cause analysis, minimal fix, verification report |
| `ttb-skill-refactor` | `ttb-skill-refactor/` | `/ttb-refactor-uikit`, `/ttb-refactor-swiftui` | affected app context | Zero-behavior-change migration plan and implementation |
| `ttb-skill-audit` | `ttb-skill-audit/` | `/ttb-audit-performance`, `/ttb-audit-accessibility`, `/ttb-audit-localization` | affected app context | Findings, FCR score, recommended fixes |

## Shared Resources

| Category | Path | Load | Purpose |
|----------|------|------|---------|
| Shared index | `ttb-skill-shared/SKILL.md` | `always` | Shared resource overview |
| Router | `ttb-skill-shared/routing/intent-router.md` | `always` | Human-readable routing contract |
| Manifest | `ttb-skill-shared/routing/intent-manifest.json` | `always` | Machine-readable routing contract |
| Aliases | `ttb-skill-shared/routing/multilingual-aliases.json` | `always` | EN/VI synonym and typo normalization |
| Router examples | `ttb-skill-shared/routing/router-examples.md` | `on-demand` | Routing regression examples |
| Workflow standard | `ttb-skill-shared/workflows/ttb-workflow-standard.md` | `domain` | State, retry, fallback, verification contract |
| Preflight gate | `ttb-skill-shared/fragments/ttb-preflight-execution-gate.frag.md` | `always` | Requirement validation, ambiguity detection, confidence scoring, execution approval |
| Cross-functional analysis gate | `ttb-skill-shared/fragments/ttb-cross-functional-analysis-gate.frag.md` | `always` | Multi-role analysis, option comparison, value-expansion and clarification question gates |
| Clarification survey | `ttb-skill-shared/templates/ttb-clarification-survey.md` | `on-demand` | Multiple-choice clarification patterns |
| Iron Laws | `ttb-skill-shared/fragments/ttb-iron-laws.frag.md` | `always` | 11 mandatory laws |
| Marker | `ttb-skill-shared/fragments/ttb-marker.frag.md` | `always` | Generated file header |
| Rules | `ttb-skill-shared/rules/*.md` | `domain` | Coding standards, anti-patterns, memory leaks, comments |
| Phases | `ttb-skill-shared/phases/*.md` | `domain` | Research/spec/implementation/review/verify |
| References | `ttb-skill-shared/refs/*.md` | `on-demand` | TTBaseUIKit, TTBaseSUI, tokens, iOS 14, navigation, performance |
| Scripts | `ttb-skill-shared/scripts/*.sh` | `on-demand` | Precheck, compliance, xcodebuild verification |
| Templates | `ttb-skill-shared/templates/*` | `on-demand` | New skill and prompt templates |

## Workflow Chains

| Chain | Trigger | Steps |
|-------|---------|-------|
| `new_feature_full` | Feature request with unknown foundation | `init validation` -> selected domain skill -> `ttb-phase-verify` |
| `api_login` | `api login`, `generate auth api`, `tạo api login` | `/ttb-uikit-api` -> `/ttb-uikit-viewmodel` -> `ttb-phase-verify` |
| `bug_then_refactor` | Bug request with cleanup language | `/ttb-bugfix` -> optional `/ttb-refactor` -> `ttb-phase-verify` |
| `audit_then_fix` | Audit request also asks to resolve findings | `/ttb-audit-*` -> selected fix workflow -> `ttb-phase-verify` |

## Dependency Rules

1. `ttb-skill-init` is the only foundation skill and has no dependencies.
2. Feature generation skills require a validated TTBaseUIKit foundation.
3. `ttb-skill-swiftui` prefers TTBaseSUI. Native SwiftUI is fallback only.
4. `ttb-skill-native-swiftui-components` is for reusable components, not full app flows.
5. Bugfix runs before refactor when both intents appear.
6. Audit reports findings before applying fixes unless the user explicitly asks to fix.

## Deprecated Or Compatibility Items

| Item | Status | Compatibility Action |
|------|--------|----------------------|
| `/tts-*` command aliases | deprecated typo family | Keep as legacy aliases that map to `/ttb-*` |
| `ttb-skill-shared/ttb-skill-registry.md` duplicate registry | deprecated duplicate | Kept as shim pointing to canonical root registry |
| `.DS_Store` files | dead local artifacts | Safe to remove from packages/source tree |
| Exact-keyword-only routing | deprecated | Replaced by semantic manifest + multilingual aliases |

## Validation Checklist

- Every core skill has frontmatter: `name`, `description`, `version`, `date_updated`, `risk`, `source`, `tags`, `loadLevel`.
- Every skill documents aliases, routing hints, input/output, anti-patterns, fallback strategy, and confidence guidance.
- Every workflow documents state/context passing, retry/fallback, dependency validation, and verification gates.
- Every skill, prompt, workflow, phase, and template references the preflight execution gate before file edits.
- The router examples keep Vietnamese, English, mixed-language, typo, and shorthand prompts stable.
- Backward compatibility is preserved for all existing `/ttb-*` commands and legacy `/tts-*` aliases.

Run routing validation:

```bash
bash ttb-skill-shared/scripts/ttb-routing-validate.sh
```
