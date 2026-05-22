---
name: "ttb-intent-router"
description: "Semantic routing contract for TTBaseUIKit Antigravity skills and workflows. Supports English, Vietnamese, mixed-language prompts, typo-tolerant aliases, confidence scoring, and workflow chaining."
version: "1.0.0"
date_updated: "2026-05-22"
risk: "safe"
source: "internal"
tags: ["routing", "intent-classification", "multilingual", "semantic-matching", "antigravity"]
---

# Antigravity Intent Router

This document is the routing contract for the Antigravity skill system. It keeps command compatibility while allowing agents to route natural language prompts by semantic intent instead of brittle keyword matching.

## Routing Inputs

```yaml
input:
  userPrompt: string
  currentFiles: string[]
  knownProjectState:
    hasTTBaseUIKit: boolean | unknown
    hasTTBaseSUI: boolean | unknown
    appArchitecture: "MVVM-C" | "unknown"
  languageHints:
    detected: "en" | "vi" | "mixed" | "unknown"
    vietnameseDiacriticsPresent: boolean
```

## Routing Output

```yaml
output:
  selectedSkill: string
  selectedCommand: string
  confidence: number
  matchedIntent: string
  loadLevel: "always" | "domain" | "on-demand"
  promptsToLoad: string[]
  sharedResourcesToLoad: string[]
  chain: string[]
  fallbackAction: string | null
  reason: string
```

## Decision Order

1. **Exact command**: `/ttb-*` wins immediately. Legacy `/tts-*` aliases map to `/ttb-*`.
2. **Normalize prompt**: lowercase, trim, collapse whitespace, strip Vietnamese diacritics, map known typo/shorthand aliases.
3. **Classify intent**: infer artifact type, lifecycle stage, framework, quality/risk intent, and requested output.
4. **Score candidates**: combine semantic match, explicit framework mention, artifact type, and dependency readiness.
5. **Apply tie-breakers**: explicit command, framework mention, artifact type, lifecycle stage, risk intent, dependencies, user language.
6. **Route or clarify**: auto-route at confidence >= 0.78; ask a focused question at 0.55-0.77; fallback to shared guidance below 0.55.

## Confidence Scoring

| Signal | Weight | Example |
|--------|--------|---------|
| Explicit command | 1.00 | `/ttb-uikit-api` |
| Exact alias | 0.95 | `generate auth api` |
| Strong semantic alias | 0.85 | `tạo api login` |
| Framework mention | 0.20 bonus | `SwiftUI`, `UIKit`, `TTBaseSUI` |
| Artifact mention | 0.20 bonus | `screen`, `api`, `cell`, `viewmodel` |
| Negative signal | -0.35 | "not SwiftUI", "no refactor" |
| Missing dependency | -0.15 | project foundation unknown |

Recommended thresholds:

| Confidence | Action |
|------------|--------|
| `>= 0.78` | Auto-route and state the selected skill briefly |
| `0.55-0.77` | Ask one clarifying question or choose the least destructive default |
| `< 0.55` | Load `ttb-skill-shared` and ask for goal/artifact/framework |

## Canonical Routes

| Intent | Command | Skill | Notes |
|--------|---------|-------|-------|
| Project setup | `/ttb-init` | `ttb-skill-init` | Must run before new app work |
| UIKit screen/list/form/cell/API/coordinator/viewmodel | `/ttb-uikit-*` | `ttb-skill-uikit` | API routes here unless backend-only tooling exists |
| SwiftUI screen/view/list/viewmodel | `/ttb-sui-*` | `ttb-skill-swiftui` | Prefer TTBaseSUI |
| Native SwiftUI component | `/ttb-native-*` | `ttb-skill-native-swiftui-components` | Components only, not full flows |
| Bug/debug/crash/regression | `/ttb-bugfix` | `ttb-skill-bugfix` | Root cause first |
| Refactor/migration/cleanup | `/ttb-refactor` | `ttb-skill-refactor` | Zero behavior change |
| Audit/review/FCR/performance/accessibility/localization | `/ttb-audit-*` | `ttb-skill-audit` | Findings first, fixes only when requested |

## Multilingual Handling

Vietnamese prompts can be written with or without diacritics. Mixed prompts are valid.

| Prompt | Normalized | Route |
|--------|------------|-------|
| `tạo api` | `tao api` | `/ttb-uikit-api` |
| `generate api` | `generate api` | `/ttb-uikit-api` |
| `build endpoint` | `build endpoint` | `/ttb-uikit-api` |
| `api login` | `api login` | `/ttb-uikit-api` |
| `tạo màn hình SwiftUI` | `tao man hinh swiftui` | `/ttb-sui-screen` |
| `sửa crash khi tap button` | `sua crash khi tap button` | `/ttb-bugfix` |
| `kiểm tra localization` | `kiem tra localization` | `/ttb-audit-localization` |

## Conflict Resolution

| Conflict | Resolution |
|----------|------------|
| `screen` without framework | Inspect existing file context. If none, ask UIKit or SwiftUI. |
| `native SwiftUI screen` vs component | Route full screens to `ttb-skill-swiftui`; route reusable atomic components to native component skill. |
| `bug + refactor` | Run bugfix first. Refactor only after behavior is stable. |
| `audit + fix` | Audit first, then chain to bugfix/refactor based on findings. |
| `api` without platform | Route to `/ttb-uikit-api` because Antigravity owns iOS RequestAPI patterns, not server backend generation. |
| missing TTBaseUIKit foundation | Run `ttb-skill-init` validation step before domain work. |

## Fallback Strategy

When the route is unclear, ask one concise question:

```text
Bạn muốn triển khai bằng UIKit/TTViewCodable hay SwiftUI/SUIBaseView?
```

If the user requested a bugfix or audit, do not ask framework first. Start by collecting evidence and affected files.

## References

- `intent-manifest.json` is the machine-readable routing source.
- `multilingual-aliases.json` stores language normalization and semantic aliases.
- `router-examples.md` contains tested routing examples and expected confidence bands.
