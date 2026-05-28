---
name: "antigravity-preflight-upgrade-report"
description: "Upgrade report for mandatory requirement analysis, validation, survey, confidence gating, and architecture-aware execution across Antigravity skills."
version: "1.0.0"
date_updated: "2026-05-22"
risk: "safe"
source: "internal"
tags: ["report", "preflight", "survey", "confidence", "architecture", "multilingual"]
---

# Antigravity Preflight Upgrade Report

## Summary

Added a mandatory pre-execution gate across Antigravity source skills, prompts, shared workflows, templates, routing metadata, and workflow phases.

The new policy blocks execution before code generation, refactor, migration, file modification, architecture creation, workflow update, UI update, navigation update, dependency update, or business logic change unless requirement analysis, context validation, ambiguity detection, missing information detection, clarification/survey, confidence evaluation, and execution approval have completed.

## Updated Skills

- Root skill: `SKILL.md`
- Shared skill: `ttb-skill-shared/SKILL.md`
- UIKit skill: `ttb-skill-uikit/SKILL.md`
- SwiftUI skill: `ttb-skill-swiftui/SKILL.md`
- Native SwiftUI components skill: `ttb-skill-native-swiftui-components/SKILL.md`
- Init skill: `ttb-skill-init/SKILL.md`
- Bugfix skill: `ttb-skill-bugfix/SKILL.md`
- Refactor skill: `ttb-skill-refactor/SKILL.md`
- Audit skill: `ttb-skill-audit/SKILL.md`

All 44 source `.prompt.md` files under Antigravity skill folders now include the mandatory preflight gate.

## Added Survey Logic

Added reusable survey template:

- `ttb-skill-shared/templates/ttb-clarification-survey.md`

Survey behavior:

- Ask short grouped questions.
- Prefer multiple choice.
- Avoid asking information that can be discovered from local code.
- Prioritize architecture-critical, behavior-critical, and UX-critical gaps.
- Support Vietnamese, English, and mixed-language clarification output.

Survey blocks now cover:

- Screen / UI work
- API / backend call work
- Navigation work
- Refactor / migration work
- Bugfix work

## Added Confidence Logic

Added reusable confidence scoring in:

- `ttb-skill-shared/fragments/ttb-preflight-execution-gate.frag.md`
- `ttb-skill-shared/workflows/ttb-workflow-standard.md`
- `ttb-skill-shared/routing/intent-router.md`
- `ttb-skill-shared/routing/intent-manifest.json`

Execution thresholds:

| Confidence | Action |
|------------|--------|
| `90-100` | Execute directly and state assumptions |
| `70-89` | Execute only with documented low-risk assumptions |
| `<70` | Stop and ask a survey before editing |

Confidence is capped at `69` when architecture-critical or business-critical uncertainty exists, including unclear target module, UIKit vs SwiftUI ambiguity, missing API contract, unclear navigation behavior, incomplete business logic, or unknown ownership.

## Added Ambiguity Detection

The preflight gate now requires detection of:

- Vague requests
- Multiple possible interpretations
- Conflicting requirements
- Incomplete business logic
- Unclear architecture direction
- Missing UX flow
- Unclear navigation behavior
- Unclear ownership/module

Examples such as `tao man login`, `create login screen`, `màn login có api chưa`, and `push qua detail screen` are explicitly handled as valid multilingual intent signals that still require execution-critical clarification when details are missing.

## Added Architecture Validation

The shared gate and implementation phases now require validation of:

- Existing architecture
- Folder structure
- Navigation architecture
- Dependency injection style
- Localization style
- State management pattern
- Reusable components
- Naming convention
- TTBaseUIKit / TTViewCodable / TTBaseSUI / SUIBaseView / TTBaseNavigationLink rules
- iOS 14 compatibility

The policy explicitly blocks inventing new architecture, navigation, or business logic without confirmation.

## Added Multilingual Support

Updated routing and aliases for:

- Vietnamese with diacritics
- Vietnamese without diacritics
- English
- Mixed-language prompts
- Light typos and shorthand

Updated files:

- `ttb-skill-shared/routing/multilingual-aliases.json`
- `ttb-skill-shared/routing/intent-router.md`
- `ttb-skill-shared/routing/intent-manifest.json`

## Updated Workflows And Templates

Updated:

- `ttb-skill-shared/workflows/ttb-workflow-standard.md`
- `ttb-skill-shared/templates/SKILL.md.template`
- `ttb-skill-shared/templates/prompt.md.template`
- `ttb-skill-shared/templates/README.md`
- `ttb-skill-shared/phases/ttb-phase-feature-research.md`
- `ttb-skill-shared/phases/ttb-phase-feature-spec.md`
- `ttb-skill-shared/phases/ttb-phase-implementation.md`
- `ttb-skill-shared/phases/ttb-phase-code-review.md`
- `ttb-skill-shared/phases/ttb-phase-verify.md`

## Remaining Gaps

- Installer archives under `Installation/` were not regenerated because the request limited the change to source skills in the Antigravity folder.
- Existing generated package artifacts may not contain the new gate until export/package scripts are run intentionally.
- This update adds skill/workflow policy and templates; it does not enforce runtime behavior in external AI tools that ignore skill text.
- README/Tutorial copy may still need a separate documentation refresh if distribution docs should advertise the new gate.
