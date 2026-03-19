---
applyTo: "plans/**"
---

# Plan Generation — Conventions & Templates

## When to Generate a Plan

Every time a prompt or agent **creates, modifies, or fixes** files in this project, it **must** generate a plan file to record the work for future context.

## Directory Convention

```
plans/
└── YYYY-MM-DD-feature-name/
    ├── plan.md                 # required — overview
    ├── phase-01-xxx.md         # optional — for multi-phase work
    ├── phase-02-xxx.md
    ├── research/               # optional — analysis, references
    └── reports/                # optional — completion reports
```

- **Date prefix**: `YYYY-MM-DD` of the work date
- **Feature name**: kebab-case, descriptive (e.g., `new-profile-screen`, `fix-card-layout`, `refactor-api-service`)
- If a plan already exists for the same feature on the same date, **append** to it rather than creating a new directory

## plan.md Template

```markdown
# {Feature Title}

## Date
YYYY-MM-DD

## Goal
Brief description of what was built/changed/fixed and why.

## Files

| Action | File | Description |
|--------|------|-------------|
| NEW    | `path/to/NewFile.swift` | What this file does |
| MODIFY | `path/to/ExistingFile.swift` | What was changed |
| DELETE | `path/to/OldFile.swift` | Why it was removed |

## Patterns & Tokens Used
- Design tokens: XView/XSize/XFont references used
- Architecture: MVVM, Coordinator, SUIBaseView, etc.
- Components: TTBaseSUI*, native SwiftUI, UIKit

## Context for Future Upgrades
Key decisions, constraints, or dependencies that future developers should know.

## Status
- [x] Completed / [ ] In Progress
```

## phase-*.md Template (Multi-Phase Work Only)

```markdown
# Phase {N} — {Phase Title}

## Context
- Parent plan: [plan.md](plan.md)
- Dependencies: {list any phase dependencies}

## Overview
- **Date**: YYYY-MM-DD
- **Status**: `[ ]` Not started / `[/]` In progress / `[x]` Complete

## Requirements
What needs to be done in this phase.

## Files Changed

| Action | File | Description |
|--------|------|-------------|
| NEW | `path/to/file` | description |

## Todo
- [ ] Task 1
- [ ] Task 2

## Success Criteria
How to verify this phase is complete.
```

## Auto-Add to Xcode (MANDATORY)

After creating any plan `.md` file, run:
```bash
ruby .agent/skills/ttbase-swiftui/scripts/add_to_xcode_project.rb "{plan_file_path}"
```

This adds the `.md` file to the Xcode project navigator as a resource, so the plan is visible alongside the codebase.
