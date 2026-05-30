---
name: "ttb-workflow-standard"
description: "Reusable workflow contract for Antigravity skills: preflight validation, cross-functional analysis, context passing, retry/fallback handling, verification gates, and output shape."
version: "1.2.0"
date_updated: "2026-05-30"
risk: "safe"
source: "internal"
tags: ["workflow", "standard", "preflight", "state", "fallback", "verification"]
---

# Antigravity Standard Workflow Contract

All Antigravity skills should follow this modular workflow unless a skill-specific prompt overrides a step for a documented reason.

Before any code generation, refactor, migration, file modification, architecture creation, workflow update, UI update, navigation update, or business logic change, skills must pass `ttb-skill-shared/fragments/ttb-preflight-execution-gate.frag.md`.

## State Object

```yaml
state:
  preflight:
    intent: string
    taskType: "generate" | "feature update" | "new feature" | "refactor" | "migration" | "fix" | "architecture update" | "UI update" | "navigation update" | "backend update" | "dependency update" | "workflow update"
    scope: "small" | "medium" | "large"
    language: "en" | "vi" | "mixed" | "unknown"
    impactedFiles: string[]
    impactedModules: string[]
    dependencies: string[]
    architectureConstraints: string[]
    missingInformation: string[]
    ambiguities: string[]
    assumptions: string[]
    confidence: number
    gateDecision: "execute" | "execute-with-assumptions" | "survey-required"
  crossFunctionalAnalysis:
    required: boolean
    lenses: ["Product Owner", "Business Analyst", "UX/UI Designer", "Solution Architect", "Senior Developer", "QA"]
    optionsConsidered: string[]
    recommendedOption: string
    valueExpansionQuestions: string[]
    clarificationQuestions: string[]
  route:
    selectedSkill: string
    command: string
    confidence: number
    reason: string
  context:
    userGoal: string
    language: "en" | "vi" | "mixed" | "unknown"
    affectedFiles: string[]
    projectState: "ready" | "needs-init-validation" | "unknown"
  dependencies:
    requiredSkills: string[]
    sharedResources: string[]
    scripts: string[]
  execution:
    phase: string
    attempt: number
    maxAttempts: 3
    blockers: string[]
  output:
    changedFiles: string[]
    verification: string
    followUps: string[]
```

## Standard Steps

0. **Preflight Execution Gate**
   - Run the seven phases from `fragments/ttb-preflight-execution-gate.frag.md`: requirement analysis, context validation, ambiguity detection, missing information detection, survey/clarification, confidence evaluation, execution approval.
   - Validate multilingual prompts in English, Vietnamese, mixed language, diacritic-free Vietnamese, and light typos.
   - For feature updates, new feature development, and bug fixes, run `fragments/ttb-cross-functional-analysis-gate.frag.md`.
   - Score confidence from `0-100`.
   - `90-100`: execute directly and record assumptions.
   - `70-89`: execute only with explicit low-risk assumptions.
   - `<70`: stop and ask a survey using `templates/ttb-clarification-survey.md`.

1. **Route**
   - Use `routing/intent-manifest.json`.
   - Preserve exact `/ttb-*` commands.
   - Normalize Vietnamese, English, mixed-language, typo, and shorthand prompts.

2. **Validate Dependencies**
   - Confirm TTBaseUIKit foundation when feature work starts.
   - Load required shared refs/rules lazily.
   - If dependency state is unknown, run a validation/precheck step before code generation.

3. **Collect Context**
   - Identify target platform, framework, artifact type, data source, navigation, localization keys, and verification command.
   - For bugfixes, collect failing behavior before proposing changes.
   - Identify impacted files/modules, dependencies, project conventions, architecture constraints, and reusable components before editing.

4. **Plan Minimal Execution**
   - Reuse existing architecture, prompts, phases, refs, and scripts.
   - Avoid new abstractions unless they remove real duplication.
   - Compare implementation options across business value, architecture, UI/UX, performance, scalability, maintainability, testing, security, and operations for non-trivial feature/update/bug work.
   - Ask at least 5 value-expansion questions after analysis; if requirements are ambiguous/incomplete, ask at least 6 clarification questions and stop before design/development.

5. **Execute**
   - Apply skill-specific prompt.
   - Pass state between substeps using the state object fields above.
   - Keep changes scoped to the selected skill and affected app files.
   - Do not execute if `state.preflight.gateDecision` is `survey-required`.

6. **Retry/Fallback**
   - Retry build or validation failures at most 3 times.
   - If a dependency is missing, stop and report the missing prerequisite.
   - If route confidence drops below threshold during execution, ask one focused clarification.

7. **Verify**
   - Run `ttb-skill-shared/scripts/ttb-verify.sh` when project context allows.
   - Run `ttb-skill-shared/scripts/ttb-compliance-check.sh` for modified Swift files.
   - Report `BUILD SUCCEEDED` or the exact blocker.

8. **Report**
   - Return changed files, selected route, verification result, compatibility notes, and migration notes.

## Chainable Workflows

| Chain | Steps |
|-------|-------|
| New feature | `init validation` -> `domain skill` -> `implementation phase` -> `verify phase` |
| API login | `/ttb-uikit-api` -> `/ttb-uikit-viewmodel` -> `verify phase` |
| Bug with cleanup | `/ttb-bugfix` -> optional `/ttb-refactor` -> `verify phase` |
| Audit with fixes | `/ttb-audit-*` -> selected fix workflow -> `verify phase` |

## Anti-Patterns

- Do not route by exact keyword alone.
- Do not load every prompt for every task.
- Do not ask broad clarification questions when a safe route and a safe execution gate are above threshold.
- Do not refactor while fixing an untriaged bug.
- Do not create a new workflow if a shared phase already covers the step.
- Do not create architecture, navigation, business logic, or dependency changes from assumptions when preflight confidence is below `70`.
