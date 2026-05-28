---
name: "ttb-phase-feature-research"
description: "Phase 1 of TTBaseUIKit feature workflow: validate request, analyze existing code, assess complexity and risk."
version: "2.0.0"
---

# ttb-phase-feature-research — Feature Research Phase

## Purpose

Validate feature request, analyze existing code, assess complexity and risk.

This phase owns the first pass of `fragments/ttb-preflight-execution-gate.frag.md`. It must produce requirement analysis, context validation, ambiguity detection, missing information, confidence score, and execution gate recommendation before any implementation phase starts.

## Input
- Feature description from user
- Existing codebase

## Steps

### 1. Understand Feature Request
- Clarify: What does the feature do? What is the user goal?
- Clarify: Who are the users? What are the edge cases?
- Clarify: What existing code is related?
- Clarify: Is this UIKit or SwiftUI (or both)?
- Classify task type: generate, refactor, migration, fix, architecture update, UI update, navigation update, backend update, dependency update, or workflow update.
- Normalize English, Vietnamese, mixed-language, diacritic-free Vietnamese, and light typo prompts.

### 2. Analyze Existing Code
- Find similar features: search for existing ViewControllers/Screens
- Find existing Models/RequestData for same domain
- Find existing Coordinators/ViewModels
- Check existing API endpoints
- Identify shared components (cells, custom views)

### 3. Check TTBaseUIKit Resources
- Review `ttb-ref-ttbaseuikit.md` for UIKit components
- Review `ttb-ref-ttbasesui.md` for SwiftUI components
- Review `ttb-ref-config-tokens.md` for design tokens
- Review `ttb-ref-ios14-compatibility.md` for API limits
- Review `ttb-ref-navigation.md` for navigation patterns

### 4. Assess Complexity
- Low: 1-2 files, no new API, existing patterns
- Medium: 3-5 files, new API, needs Coordinator
- High: 6+ files, complex flows, multiple screens

### 5. Validate Architecture Fit
- Does feature fit MVVM-C pattern?
- Does it need a new Coordinator?
- Does it need new API endpoints?
- Can existing cells/views be reused?
- Does it need SwiftUI with SUIBaseView wrapper?

### 6. Preflight Gate Decision
- Score execution confidence from `0-100`.
- `90-100`: proceed.
- `70-89`: proceed only with documented low-risk assumptions.
- `<70`: stop and ask a survey from `templates/ttb-clarification-survey.md`.
- Cap confidence at `69` when target module, architecture direction, navigation behavior, API/business logic, localization format, state management, or ownership is unclear.

## Output

```
## Feature Research — {FeatureName}

### Summary
{1-paragraph description}

### Classification
- Type: UIKit / SwiftUI (TTBaseSUI) / Native SwiftUI / Hybrid
- Complexity: LOW / MEDIUM / HIGH
- Platform: iOS 14+

### Existing Code References
- Related VCs/Screens: [list]
- Related Models: [list]
- Related APIs: [list]
- Reusable Components: [list]

### Risk Assessment
- Dependency: [what it depends on]
- Blocking: [any blockers]
- Compatibility: [iOS 14+ assessment]

### Recommendation
[PROCEED / CLARIFY / REJECT] with reason

### Preflight
- Intent:
- Task Type:
- Missing Information:
- Ambiguities:
- Assumptions:
- Confidence:
- Gate Decision:
```

## Rules
- Always check existing code before generating new
- Always use existing components before creating new
- Always classify complexity before starting
- Always validate architecture fit
- Always run the preflight execution gate before implementation
- SwiftUI screens MUST use SUIBaseView wrapper
- Navigation MUST use TTBaseNavigationLink (SwiftUI)
