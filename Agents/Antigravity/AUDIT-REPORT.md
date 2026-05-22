---
name: "antigravity-audit-report"
description: "Audit and upgrade report for TTBaseUIKit Antigravity skills, workflows, routing, metadata, multilingual triggers, and cleanup."
version: "2.2.0"
date_updated: "2026-05-22"
risk: "safe"
source: "internal"
tags: ["audit", "routing", "skills", "workflows", "cleanup", "migration"]
---

# Antigravity Skills + Workflows Audit Report

**Date**: 2026-05-22
**Scope**: `Agents/Antigravity/` only
**Result**: Upgraded to semantic routing architecture with backward-compatible `/ttb-*` commands and legacy `/tts-*` alias support.

## Executive Summary

The system now has a canonical registry, machine-readable intent manifest, multilingual alias normalization, routing confidence policy, reusable workflow contract, and metadata validation script.

Key issues found:

- Root README/registry used `/tts-*` commands while active skills use `/ttb-*`.
- Registry content was duplicated between root and `ttb-skill-shared/`.
- Routing depended mostly on command/keyword matching.
- Vietnamese/English/mixed-language triggers were scattered.
- Skill metadata lacked a consistent routing contract, input/output schema, anti-patterns, and fallback strategy.
- Some SwiftUI examples still used deprecated `XView/XSize/XFont` aliases.

## Classification

| Category | Files / Directories |
|----------|---------------------|
| Skills | `SKILL.md`, `ttb-skill-*/SKILL.md` |
| Workflows | `ttb-skill-shared/phases/*.md`, `ttb-skill-shared/workflows/ttb-workflow-standard.md` |
| Shared resources | `ttb-skill-shared/rules/`, `refs/`, `fragments/`, `scripts/`, `templates/` |
| Prompts | `*.prompt.md` across skill directories |
| Routers | `ttb-skill-shared/routing/` |
| Configs / installers | `Installation/`, `export.sh`, `VERSION.md` |

## Changed Files

### New Files

| File | Purpose |
|------|---------|
| `ttb-skill-shared/routing/intent-manifest.json` | Machine-readable semantic routing, dependencies, aliases, chains |
| `ttb-skill-shared/routing/multilingual-aliases.json` | English/Vietnamese normalization, typos, shorthand, synonyms |
| `ttb-skill-shared/routing/intent-router.md` | Human-readable routing contract and confidence policy |
| `ttb-skill-shared/routing/router-examples.md` | Routing regression examples |
| `ttb-skill-shared/workflows/ttb-workflow-standard.md` | Shared state/context/retry/fallback/verification contract |
| `ttb-skill-shared/scripts/ttb-routing-validate.sh` | Validates routing JSON and required SKILL metadata |

### Updated Files

| File | Change |
|------|--------|
| `SKILL.md` | v2.2.0, auto-routing contract, EN/VI examples, routing source links |
| `README.md`, `README-VI.md` | v2.2.0, fixed `/tts-*` to `/ttb-*`, added auto-routing section |
| `ttb-skill-registry.md` | Rewritten as canonical v2.2.0 registry |
| `ttb-skill-shared/ttb-skill-registry.md` | Converted stale duplicate registry into compatibility shim |
| `ttb-skill-shared/SKILL.md` | Added routing/workflow directories and validation script |
| `ttb-skill-*/SKILL.md` | Added metadata, routing contracts, schemas, aliases, anti-patterns, fallback strategies |
| `ttb-skill-shared/templates/*.template` | Added standardized metadata, routing schema, retry/fallback guidance |
| `ttb-skill-swiftui/*.prompt.md` | Normalized generated SwiftUI examples from `XView/XSize/XFont` to `TTView/TTSize/TTFont` |
| `ttb-skill-shared/refs/ttb-ref-ttbasesui.md`, `ttb-ref-navigation.md` | Normalized example tokens |

## New Architecture

```text
Agents/Antigravity/
├── SKILL.md
├── README.md
├── README-VI.md
├── ttb-skill-registry.md                 # canonical registry
├── ttb-skill-*/                          # domain skills
└── ttb-skill-shared/
    ├── ttb-skill-registry.md             # compatibility shim
    ├── routing/
    │   ├── intent-manifest.json
    │   ├── multilingual-aliases.json
    │   ├── intent-router.md
    │   └── router-examples.md
    ├── workflows/
    │   └── ttb-workflow-standard.md
    ├── phases/
    ├── rules/
    ├── refs/
    ├── fragments/
    ├── scripts/
    │   ├── ttb-precheck.sh
    │   ├── ttb-compliance-check.sh
    │   ├── ttb-verify.sh
    │   └── ttb-routing-validate.sh
    └── templates/
```

## Upgraded Routing Logic

Routing now follows this order:

1. Exact `/ttb-*` command.
2. Legacy `/tts-*` alias mapped to `/ttb-*`.
3. Normalize prompt: lowercase, trim, strip Vietnamese diacritics, collapse whitespace, map typo/shorthand aliases.
4. Classify by semantic intent: artifact type, framework, lifecycle stage, quality/risk intent, dependencies.
5. Score route confidence.
6. Auto-route, clarify, or fallback based on threshold.

| Confidence | Action |
|------------|--------|
| `>= 0.78` | Auto-route |
| `0.55-0.77` | Ask one focused clarification |
| `< 0.55` | Load shared resources and ask for goal/framework/artifact |

## Examples Covered

| Prompt | Route |
|--------|-------|
| `tạo api` / `tao api` / `generate api` / `build endpoint` | `/ttb-uikit-api` |
| `api login` / `generate auth api` | `/ttb-uikit-api` |
| `tạo màn hình SwiftUI` / `tao man hinh swiftui` | `/ttb-sui-screen` |
| `fix crash khi tap button` / `sửa lỗi UI không update` | `/ttb-bugfix` |
| `kiểm tra hiệu năng` / `performance audit` | `/ttb-audit-performance` |

## Cleanup

Removed or neutralized:

- Duplicate registry logic in `ttb-skill-shared/ttb-skill-registry.md`; path preserved as a shim.
- Stale `/tts-*` primary command references in READMEs; legacy aliases remain supported.
- Deprecated `XView/XSize/XFont` usage from SwiftUI generation examples.

Not removed:

- Installation tarballs under `Installation/` remain because they are packaging artifacts.
- Existing prompt files remain to preserve command compatibility.

## Compatibility Notes

- All existing `/ttb-*` commands are preserved.
- Legacy `/tts-*` aliases still map to canonical `/ttb-*` commands.
- `ttb-skill-shared/ttb-skill-registry.md` still exists for older references.
- No files outside `Agents/Antigravity/` were modified.

## Migration Notes

For future skill additions:

1. Add metadata to `ttb-skill-registry.md`.
2. Add route to `ttb-skill-shared/routing/intent-manifest.json`.
3. Add EN/VI aliases to `ttb-skill-shared/routing/multilingual-aliases.json`.
4. Add examples to `ttb-skill-shared/routing/router-examples.md`.
5. Use `ttb-skill-shared/templates/SKILL.md.template`.
6. Run `bash ttb-skill-shared/scripts/ttb-routing-validate.sh`.

## Recommended Future Improvements

- Add a router CLI that returns `selectedSkill`, `selectedCommand`, and `confidence`.
- Add CI validation for `ttb-routing-validate.sh`.
- Regenerate installer tarballs after this upgrade.
- Normalize frontmatter across all `*.prompt.md` files.
- Add route coverage tests for all native component aliases.
