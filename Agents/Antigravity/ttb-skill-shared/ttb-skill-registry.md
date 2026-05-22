---
name: "ttb-skill-shared-registry"
description: "Backward-compatible registry shim. The canonical Antigravity skill registry now lives at ../ttb-skill-registry.md."
version: "2.2.0"
date_updated: "2026-05-22"
risk: "safe"
source: "internal"
tags: ["registry", "compatibility", "shim", "antigravity"]
---

# Shared Registry Shim

The canonical registry is:

```text
../ttb-skill-registry.md
```

This file remains for backward compatibility because older skills and installers reference `ttb-skill-shared/ttb-skill-registry.md`.

## What Changed

| Old Behavior | New Behavior |
|--------------|--------------|
| Duplicate registry content inside `ttb-skill-shared/` | Single source of truth at root `ttb-skill-registry.md` |
| Stale versions and `10 Iron Laws` wording | Canonical registry references 11 Iron Laws |
| Keyword-oriented trigger lists | Semantic routing through `routing/intent-manifest.json` |
| English/Vietnamese examples scattered across docs | Central multilingual aliases in `routing/multilingual-aliases.json` |

## Load These Instead

| Need | File |
|------|------|
| Skill inventory | `../ttb-skill-registry.md` |
| Machine-readable routing | `routing/intent-manifest.json` |
| Human-readable routing | `routing/intent-router.md` |
| EN/VI aliases | `routing/multilingual-aliases.json` |
| Routing examples | `routing/router-examples.md` |
| Workflow state/retry/fallback | `workflows/ttb-workflow-standard.md` |

## Compatibility Note

Do not add new registry entries here. Add them to `../ttb-skill-registry.md` and `routing/intent-manifest.json`, then keep this shim unchanged unless the compatibility path itself changes.
