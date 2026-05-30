---
name: "ttb-preflight-execution-gate"
description: "Reusable preflight validation, cross-functional analysis, ambiguity detection, survey, confidence scoring, and execution approval gate for every Antigravity skill."
version: "1.1.0"
date_updated: "2026-05-30"
risk: "safe"
source: "internal"
tags: ["preflight", "requirements", "clarification", "confidence", "architecture", "multilingual"]
---

# Antigravity Preflight Execution Gate

This gate is mandatory before any AI action that generates code, refactors, migrates, modifies files, creates architecture, updates workflows, updates UI/navigation, or changes business logic.

## Mandatory Phase Order

1. **Requirement Analysis**
   - Detect the real user intent, requested output, and business goal.
   - Classify task type: `generate`, `feature update`, `new feature`, `refactor`, `migration`, `fix`, `architecture update`, `UI update`, `navigation update`, `backend update`, `dependency update`, `workflow update`.
   - Identify impacted files, modules, dependencies, architecture constraints, framework conventions, coding standards, and project-specific rules.
   - For feature updates, new feature development, and bug fixes, also run `ttb-skill-shared/fragments/ttb-cross-functional-analysis-gate.frag.md`.

2. **Context Validation**
   - Inspect local project context before implementation when files/modules may be affected.
   - Confirm existing architecture, folder structure, navigation pattern, dependency injection style, localization format, state management pattern, reusable components, and verification command.
   - Prefer current project conventions over new patterns.

3. **Ambiguity Detection**
   - Detect vague requests, multiple valid interpretations, conflicting requirements, incomplete business logic, unclear architecture direction, missing UX flow, unclear navigation behavior, and unclear module ownership.
   - Examples that are ambiguous by default: `create login screen`, `tao man login`, `update navigation`, `refactor module`, `migrate UI`.

4. **Missing Information Detection**
   - Required information depends on task type, but check for missing screen name, target module, navigation flow, expected output, API structure, architecture convention, dependency info, file location, UI expectation, state management, routing expectation, naming convention, localization format, and reusable component requirements.
   - Do not execute when missing information is architecture-critical or business-critical.

5. **Survey / Clarification Phase**
   - If confidence is low, requirements are incomplete, or ambiguity is high, ask a concise survey before implementation.
   - Prefer grouped multiple-choice questions.
   - Ask only architecture-critical, behavior-critical, or UX-critical questions that cannot be safely inferred from the codebase.
   - After analysis for feature/update/bug tasks, ask at least 5 value-expansion questions unless the user explicitly constrained scope to a mechanical edit.
   - If the request is ambiguous or incomplete, stop before design/development and ask at least 6 clarification questions covering business, UX, data, API, security, performance, edge cases, and real production scenarios.

6. **Confidence Evaluation**
   - Score confidence from 0 to 100 using the rubric below.
   - Cap the final score at `100` after adding positive signals and subtracting risks.
   - Include the score and assumptions in the plan or execution notes.

7. **Execution Approval**
   - `90-100`: execute directly and state key assumptions.
   - `70-89`: execute only if assumptions are low-risk; state warning assumptions first.
   - `<70`: do not execute; survey is mandatory.
   - Any business logic, architecture, navigation, or data persistence uncertainty that can cause wrong behavior caps confidence at `69`.

## Confidence Rubric

| Signal | Points |
|--------|--------|
| Clear task type and artifact | +20 |
| Target module/files identified | +15 |
| Existing architecture and framework convention validated | +15 |
| UI/navigation/state/API behavior specified or discoverable | +15 |
| Cross-functional impacts evaluated for feature/update/bug work | +10 |
| Localization/naming/reusable component rules known | +10 |
| Dependencies and verification path known | +10 |
| No conflicting requirements | +10 |
| Multilingual/typo intent confidently normalized | +5 |

Subtract points:

| Risk | Penalty |
|------|---------|
| Missing target module or file location | -15 |
| Unclear navigation or ownership | -15 |
| Incomplete API/business logic | -20 |
| Missing cross-functional analysis for feature/update/bug work | -15 |
| Ambiguous UIKit vs SwiftUI vs Native SwiftUI | -15 |
| Unknown project convention after inspection | -10 |
| Conflicting requirements | -25 |

## Architecture-Aware Execution Rules

- Detect existing architecture before implementation.
- Reuse existing components, services, coordinators, view models, routing, localization, tokens, naming, folder structure, and dependency injection style.
- Evaluate implementation options across business value, architecture, UI/UX, performance, scalability, maintainability, security, testing, and operations before recommending a solution for non-trivial feature/update/bug work.
- Do not invent a new architecture or replace a project convention without explicit user confirmation.
- Do not generate code that violates TTBaseUIKit, TTViewCodable, TTBaseSUI, SUIBaseView, TTBaseNavigationLink, iOS 14, localization, or verification rules.
- Large refactors, migrations, navigation changes, and business logic changes require a scoped impact summary before editing files.

## Multilingual Requirement Parsing

Treat English, Vietnamese, mixed-language prompts, diacritic-free Vietnamese, and light typos as equivalent intent signals.

Examples:

| User phrase | Normalized intent |
|-------------|-------------------|
| `tao man login` | create login screen |
| `create login screen` | create login screen |
| `màn login có api chưa` | login screen/API readiness question |
| `push qua detail screen` | navigation push to detail screen |
| `sua loi crash khi tap` | bugfix crash on tap |

If the normalized intent is clear but implementation details are not, keep the route and ask only the missing execution questions.

## Required Preflight Output Shape

Before implementation, produce or internally track:

```yaml
preflight:
  intent: string
  taskType: string
  scope: "small" | "medium" | "large"
  language: "en" | "vi" | "mixed" | "unknown"
  impactedFiles: string[]
  impactedModules: string[]
  dependencies: string[]
  architectureConstraints: string[]
  missingInformation: string[]
  ambiguities: string[]
  assumptions: string[]
  crossFunctionalAnalysisRequired: boolean
  optionsConsidered: string[]
  valueExpansionQuestions: string[]
  clarificationQuestions: string[]
  confidence: 0-100
  gateDecision: "execute" | "execute-with-assumptions" | "survey-required"
```

If `gateDecision` is `survey-required`, stop before file edits and ask the survey.
