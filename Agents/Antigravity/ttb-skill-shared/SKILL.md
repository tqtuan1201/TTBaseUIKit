---
name: "ttb-skill-shared"
description: "Shared resources for all TTBaseUIKit skills: routing, workflows, rules, phases, references, anti-patterns, coding standards, and verification."
version: "2.2.0"
date_updated: "2026-05-22"
risk: "safe"
source: "internal"
loadLevel: "always"
tags: ["shared", "routing", "workflow", "rules", "phases", "refs", "verification", "antigravity"]
---

# ttb-skill-shared

> Shared resources referenced by ALL TTBaseUIKit skill sets.
> Rules | Phases | References | Anti-Patterns | Standards | Scripts

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

## Directory Structure

```
ttb-skill-shared/
├── SKILL.md                              ← This file
├── ttb-skill-registry.md                 ← compatibility shim to ../ttb-skill-registry.md
├── routing/
│   ├── intent-manifest.json              ← machine-readable semantic routing
│   ├── multilingual-aliases.json         ← EN/VI aliases, typos, shorthand
│   ├── intent-router.md                  ← human-readable routing contract
│   └── router-examples.md                ← routing regression examples
├── workflows/
│   └── ttb-workflow-standard.md          ← preflight, state, retry, fallback, verification contract
├── rules/
│   ├── ttb-rule-anti-patterns.md        ← Component, pattern, performance anti-patterns
│   ├── ttb-rule-coding-standards.md        ← File header, imports, MARK, naming
│   ├── ttb-rule-memory-leaks.md          ← Retain cycle & memory detection
│   └── ttb-rule-comments.md             ← Doc comments, inline comments, SwiftUI MARK
├── phases/
│   ├── ttb-phase-feature-research.md        ← Phase 1: Research & validation
│   ├── ttb-phase-feature-spec.md            ← Phase 2: PRD, data model, BDD
│   ├── ttb-phase-implementation.md            ← Phase 4: Build with xcodebuild
│   ├── ttb-phase-code-review.md              ← Phase 5: FCR 7-Dimension audit
│   └── ttb-phase-verify.md                  ← Phase 6: Post-build verification (MANDATORY)
├── refs/
│   ├── ttb-ref-ttbasesui.md              ← TTBaseSUI component reference
│   ├── ttb-ref-ttbaseuikit.md             ← TTBaseUIKit API reference
│   ├── ttb-ref-config-tokens.md            ← Colors, sizes, fonts
│   ├── ttb-ref-ios14-compatibility.md      ← iOS 14 API compatibility guide
│   ├── ttb-ref-swiftui-performance.md      ← SwiftUI performance optimization
│   ├── ttb-ref-swiftui-architecture.md      ← Clean Architecture for SwiftUI
│   └── ttb-ref-navigation.md             ← Navigation pattern reference (NEW)
├── fragments/
│   ├── ttb-preflight-execution-gate.frag.md ← requirement/context/ambiguity/confidence gate
│   ├── ttb-iron-laws.frag.md            ← 11 mandatory Iron Laws
│   └── ttb-marker.frag.md               ← Code generation marker
├── templates/
│   ├── SKILL.md.template                ← new skill template
│   ├── prompt.md.template               ← new prompt template
│   └── ttb-clarification-survey.md      ← standardized clarification surveys
└── scripts/
    ├── ttb-verify.sh                     ← Post-build verification
    ├── ttb-compliance-check.sh             ← grep-based compliance checks
    ├── ttb-precheck.sh                    ← Pre-skill prerequisite gate
    └── ttb-routing-validate.sh            ← Routing metadata validation
```

## 11 Iron Laws (All Skills)

1. **iOS 14+ ONLY** — never use iOS 15+/16+/17+ APIs without `@available`
2. **TTBaseUIKit COMPONENTS** — never use raw UIKit when TTBaseUIKit exists
3. **TTViewCodable MVVM** — UIKit views must use TTViewCodable protocol
4. **TTBaseSUI FOR SWIFTUI** — use TTBaseSUI* wrappers for SwiftUI
5. **SUIBaseView WRAPPER** — every SwiftUI screen must use `SUIBaseView`
6. **TTBaseNavigationLink** — every navigation between screens uses `TTBaseNavigationLink`
7. **MVVM SEPARATION** — ViewModel never imports UIKit/SwiftUI
8. **xcodebuild CLI IS LAW** — use `xcodebuild` command, not Cmd+B
9. **ZERO REGRESSION** — every change verified against existing code
10. **ANTI-LOOP: MAX 3 ROUNDS** — 3 build failures → stop
11. **POST-BUILD VERIFICATION IS MANDATORY** — after every skill: `BUILD SUCCEEDED`

## Code Generation Marker

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  {FileName}.swift
//  {AppName}
//
```

## Plan Generation

After completing any work:
1. Create `plans/YYYY-MM-DD-{feature-name}/plan.md`
2. Include: date, goal, files table (NEW/MODIFY/DELETE), patterns & tokens, context for future upgrades, status
3. Auto-add to Xcode:
```bash
ruby .agent/skills/ttbase-swiftui/scripts/add_to_xcode_project.rb "{plan_file_path}"
```

## Preflight Execution Gate (All Skills)

Every Antigravity skill and prompt must run `fragments/ttb-preflight-execution-gate.frag.md` before code generation, refactor, migration, file modification, architecture creation, workflow update, UI update, navigation update, or business logic change.

Required phases:

1. Requirement Analysis
2. Context Validation
3. Ambiguity Detection
4. Missing Information Detection
5. Survey / Clarification Phase
6. Confidence Evaluation
7. Execution Approval

Execution thresholds:

| Confidence | Action |
|------------|--------|
| `90-100` | Execute directly and state assumptions |
| `70-89` | Execute only with low-risk warning assumptions |
| `<70` | Stop and ask a survey from `templates/ttb-clarification-survey.md` |

The gate must understand English, Vietnamese, mixed-language prompts, diacritic-free Vietnamese, and light typos such as `tao man login`, `create login screen`, `màn login có api chưa`, and `push qua detail screen`.

## Shared Resources

Referenced by ALL skill sets. Load once per session:

| Resource | Location | Tokens | Purpose |
|----------|----------|--------|---------|
| Intent Router | `routing/intent-router.md` | ~600 | Semantic routing contract |
| Intent Manifest | `routing/intent-manifest.json` | runtime | Machine-readable routes and chains |
| Multilingual Aliases | `routing/multilingual-aliases.json` | runtime | EN/VI normalization, typos, synonyms |
| Workflow Standard | `workflows/ttb-workflow-standard.md` | ~500 | Shared state/retry/fallback contract |
| Preflight Execution Gate | `fragments/ttb-preflight-execution-gate.frag.md` | ~900 | Requirement validation, ambiguity detection, confidence scoring, execution gate |
| Clarification Survey Template | `templates/ttb-clarification-survey.md` | ~700 | Standard multiple-choice survey patterns |
| Iron Laws | `fragments/ttb-iron-laws.frag.md` | ~240 | 11 mandatory laws |
| Marker | `fragments/ttb-marker.frag.md` | ~40 | File header template |
| Verify Script | `scripts/ttb-verify.sh` | — | Post-build verification |
| Compliance Script | `scripts/ttb-compliance-check.sh` | — | grep-based checks |
| Precheck Script | `scripts/ttb-precheck.sh` | — | Pre-skill prerequisite gate |
| Routing Validation Script | `scripts/ttb-routing-validate.sh` | — | Validate manifest and skill metadata |
| Skill Registry | `../ttb-skill-registry.md` | — | Canonical skill → route mapping |
| Verification Phase | `phases/ttb-phase-verify.md` | ~800 | Mandatory post-build phase |
| Coding Standards | `rules/ttb-rule-coding-standards.md` | ~400 | File headers, MARK sections, naming |
| Comments Standard | `rules/ttb-rule-comments.md` | ~400 | Doc comments, inline comments |
| Anti-Patterns | `rules/ttb-rule-anti-patterns.md` | ~600 | Component, pattern, performance anti-patterns |
| Memory Leaks | `rules/ttb-rule-memory-leaks.md` | ~400 | Retain cycle detection |
| SwiftUI Performance | `refs/ttb-ref-swiftui-performance.md` | ~200 | LazyVStack, stable identity |
| SwiftUI Architecture | `refs/ttb-ref-swiftui-architecture.md` | ~200 | Clean Architecture, modularization |
| Navigation Reference | `refs/ttb-ref-navigation.md` | ~300 | Navigation pattern reference |

## Token Budget

- Session limit: ~50,000 tokens
- Context > 60% → Archive old JOURNAL entries
- Context > 80% → Start new session
- Progressive loading: metadata (always) → instructions (on-demand) → resources (as needed)
- Router manifest and aliases are available before heavy skill loading.

## Routing And Workflow Rules

1. Route exact `/ttb-*` commands first.
2. Normalize English, Vietnamese, mixed-language, diacritic-free Vietnamese, common typos, and shorthand.
3. Use confidence thresholds from `routing/intent-router.md`.
4. Preserve legacy `/tts-*` aliases by mapping them to canonical `/ttb-*` commands.
5. Pass execution state using `workflows/ttb-workflow-standard.md`.
6. Run the preflight execution gate before any implementation or file modification.
7. Ask a focused survey when execution confidence is below `70`, critical requirements are missing, or ambiguity is high.

## Routing Contract

```yaml
input:
  required: [user_prompt_or_command]
  optional: [current_files, project_state, language_hint]
output:
  artifacts: [selected_skill, selected_command, confidence, prompts_to_load, shared_resources_to_load, fallback_action]
  completion_gate: "route selected or one focused clarification requested"
confidence:
  auto_route: ">= 0.78"
  clarify: "0.55-0.77"
  fallback: "< 0.55"
executionConfidence:
  execute: "90-100"
  execute_with_assumptions: "70-89"
  survey_required: "<70"
fallback:
  default: "Load shared resources and ask for goal/framework/artifact."
```

Multilingual aliases and typo handling live in `routing/multilingual-aliases.json`.

Anti-patterns: do not duplicate registry entries in this shared shim; do not route by exact keyword only; do not load every prompt when a domain route is enough.

## ⚠️ Critical Token Warnings

The following tokens **DO NOT EXIST** in TTBaseUIKit:

| ❌ DO NOT USE | ✅ USE INSTEAD |
|--------------|----------------|
| `XView` | `TTView` |
| `XSize` | `TTSize` |
| `XFont` | `TTFont` |
| `TTView.colorSuccess` | `TTView.notificationBgSuccess` |
| `TTView.colorWarning` | `TTView.notificationBgWarning` |
| `TTView.colorError` | `TTView.notificationBgError` |
| `TTView.buttonBgHighlight` | Calculate manually |
| `TTView.buttonBgWarring` | `TTView.buttonBgWar` |
| `TTView.buttonBgDisable` | `TTView.buttonBgDis` |
| `TTView.textThirdTitleColor` | `TTView.textSubTitleColor` |
| `TTView.viewBgSecondaryColor` | `TTView.viewBgColor` |
| `TTView.separatorColor` | `TTView.lineDefColor` |
| `TTView.iconPrimaryColor` | `TTView.iconColor` |
| `TTSize.P_XXL` | `TTSize.P_CONS_DEF * 4` (32pt) |
| `TTSize.SIZE_SUPER_HEADER` | `TTFont.HEADER_SUPER_H` |

---

**Version**: 2.2.0 | **Date**: 2026-05-22
**Changelog**: v2.2.0 — Added routing and workflow directories, canonical registry shim, semantic EN/VI routing contract, aliases, examples, and shared state/retry/fallback workflow. v2.0.0 — Added ttb-ref-navigation.md to refs. Added Iron Law #5 (SUIBaseView) and #6 (TTBaseNavigationLink). Added critical token warnings. Added ttb-rule-comments.md to index.
