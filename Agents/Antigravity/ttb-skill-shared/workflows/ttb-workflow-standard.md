---
name: "ttb-workflow-standard"
description: "Reusable workflow contract for Antigravity skills: validation, context passing, retry/fallback handling, verification gates, and output shape."
version: "1.0.0"
date_updated: "2026-05-22"
risk: "safe"
source: "internal"
tags: ["workflow", "standard", "state", "fallback", "verification"]
---

# Antigravity Standard Workflow Contract

All Antigravity skills should follow this modular workflow unless a skill-specific prompt overrides a step for a documented reason.

## State Object

```yaml
state:
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

4. **Plan Minimal Execution**
   - Reuse existing architecture, prompts, phases, refs, and scripts.
   - Avoid new abstractions unless they remove real duplication.

5. **Execute**
   - Apply skill-specific prompt.
   - Pass state between substeps using the state object fields above.
   - Keep changes scoped to the selected skill and affected app files.

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
- Do not ask broad clarification questions when a safe route is above threshold.
- Do not refactor while fixing an untriaged bug.
- Do not create a new workflow if a shared phase already covers the step.
