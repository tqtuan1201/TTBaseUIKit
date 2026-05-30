# Antigravity TTBaseUIKit Skills — Codex Installation Guide

## Overview

This package contains the full Antigravity TTBaseUIKit skill set for **Codex** AI agents.

**Version 2.3.0** — cross-functional analysis gate, value-expansion questions, ambiguity clarification gate, semantic routing, Vietnamese/English aliases, workflow standard, 11 Iron Laws, SUIBaseView + TTBaseNavigationLink mandatory, navigation reference, token warnings, FCR 7-Dimension scoring, progressive loading.

## Codex Skill Locations

Codex reads skills from multiple locations. Skills installed here land in the **USER** level:

| Scope | Location | Purpose |
|-------|----------|---------|
| USER | `~/.agents/skills/` | Personal skills — available across all repos |
| REPO | `$CWD/.agents/skills/` | Repo-specific skills — checked into source control |
| ADMIN | `/etc/codex/skills/` | Machine/container-level skills |

Skills in `~/.agents/skills/` apply to every repository you work in.

## Contents

```
Codex/
├── antigravity-codex-skills.tar.gz    ← Portable archive (v2.3.0)
├── install.sh                         ← Installation script
└── INSTALL.md                        ← This file
```

## Quick Install — Codex

1. Open terminal, navigate to this folder:

```bash
cd path/to/TTBaseUIKit/Agents/Antigravity/Installation/Codex
```

2. Run the installer:

```bash
bash install.sh
```

3. Restart Codex to load new skills.

4. Verify:

```bash
ls ~/.agents/skills/
```

## What Gets Installed

Skills land in `~/.agents/skills/`:

```
~/.agents/skills/
├── ttb-skill-init/
│   └── SKILL.md               Project initialization: MVVM-C structure, TTBaseUIKitConfig, localization, TTBDebugPlus
├── ttb-skill-uikit/
│   └── SKILL.md               UIKit: screen, list, form, cell, customview, api, coordinator, viewmodel
├── ttb-skill-swiftui/
│   └── SKILL.md               SwiftUI: TTBaseSUI + native screens, views, viewmodels (v2.0 — SUIBaseView + TTBaseNavigationLink)
├── ttb-skill-native-swiftui-components/
│   └── SKILL.md               20 native SwiftUI components with TTBaseUIKit tokens (v2.0)
├── ttb-skill-bugfix/
│   └── SKILL.md               Systematic bug fix workflow
├── ttb-skill-refactor/
│   └── SKILL.md               Clean architecture refactoring
├── ttb-skill-audit/
│   └── SKILL.md               Performance, accessibility, localization audits
├── ttb-skill-shared/
│   ├── SKILL.md               Shared rules, phases, reference documentation
│   ├── phases/               5 workflow phases
│   │   ├── ttb-phase-feature-research.md
│   │   ├── ttb-phase-feature-spec.md
│   │   ├── ttb-phase-implementation.md
│   │   ├── ttb-phase-code-review.md
│   │   └── ttb-phase-verify.md          ← MANDATORY post-build verification
│   ├── rules/                5 coding rules
│   │   ├── ttb-rule-anti-patterns.md    ← Component + performance anti-patterns (v2.0)
│   │   ├── ttb-rule-coding-standards.md   ← MARK sections, SwiftUI naming (v2.0)
│   │   ├── ttb-rule-comments.md           ← Doc comments, inline comments (v2.0)
│   │   └── ttb-rule-memory-leaks.md      ← Retain cycle detection (v2.0)
│   ├── refs/                 7 reference documents
│   │   ├── ttb-ref-ttbasesui.md
│   │   ├── ttb-ref-ttbaseuikit.md
│   │   ├── ttb-ref-config-tokens.md     ← Token warnings (v2.0)
│   │   ├── ttb-ref-ios14-compatibility.md
│   │   ├── ttb-ref-swiftui-performance.md
│   │   ├── ttb-ref-swiftui-architecture.md
│   │   └── ttb-ref-navigation.md         ← NEW: Navigation patterns (v2.0)
│   ├── scripts/               3 build scripts
│   │   ├── ttb-verify.sh                  ← 5-layer post-build verification
│   │   ├── ttb-compliance-check.sh          ← grep-based compliance checks
│   │   └── ttb-precheck.sh                ← Pre-skill prerequisite gate
│   ├── fragments/             3 inline fragments
│   │   ├── ttb-preflight-execution-gate.frag.md
│   │   ├── ttb-cross-functional-analysis-gate.frag.md
│   │   ├── ttb-iron-laws.frag.md         ← 11 mandatory Iron Laws (v2.0)
│   │   └── ttb-marker.frag.md             ← Code generation marker (v2.0)
│   └── ttb-skill-registry.md   Skill index + progressive loading
├── antigravity-SKILL.md/
│   └── SKILL.md               Root skill entry point (v2.1.0)
├── antigravity-README.md/
│   └── SKILL.md               Overview and quick reference (v2.3.0)
├── antigravity-README-VI.md/
│   └── SKILL.md               Vietnamese overview (v2.3.0)
├── antigravity-Tutorial.md/
│   └── SKILL.md               Tutorial: when to use each skill, prompt examples (v1.0.0)
├── antigravity-Tutorial-vi.md/
│   └── SKILL.md               Vietnamese tutorial (v1.0.0)
└── antigravity-VERSION.md/
    └── SKILL.md               Version history (v2.3.0)
```

## Skill Activation

Codex supports two invocation modes:

**Explicit invocation** — Mention the skill in your prompt:

```
$ttb-skill-uikit
/build a UIKit screen for user login
```

**Implicit invocation** — Describe the task naturally; Codex triggers skills by matching descriptions:

```
"init a new TTBaseUIKit project"
"build a UIKit login screen"
"build a SwiftUI screen with SUIBaseView"
"fix the crash on startup"
```

### Skill Commands

| Command | Skill |
|---------|-------|
| `$ttb-skill-init` | Project initialization (RUN FIRST) |
| `$ttb-skill-uikit` | Build UIKit screens with TTViewCodable |
| `$ttb-skill-swiftui` | Build SwiftUI screens with TTBaseSUI |
| `$ttb-skill-native-swiftui-components` | 20 Native SwiftUI components |
| `$ttb-skill-bugfix` | Systematic bug fixing |
| `$ttb-skill-refactor` | Clean architecture refactoring |
| `$ttb-skill-audit` | Performance, accessibility, localization audits |
| `$ttb-skill-shared` | Rules, phases, reference documentation |

## Skill Format

Codex skills use the **Agent Skills** open standard. Each skill is a directory containing:

```
skill-name/
├── SKILL.md          # Required: YAML frontmatter + instructions
├── scripts/          # Optional: executable helper scripts
├── references/       # Optional: long-form docs (loaded on demand)
└── assets/          # Optional: templates, resources
```

The `SKILL.md` must include:

```yaml
---
name: skill-name
description: What the skill does and when Codex should use it.
---

# Instructions follow...
```

Progressive disclosure: Codex loads `name` + `description` for discovery, the full `SKILL.md` body only when the skill triggers.

## 11 Iron Laws (v2.0)

1. **iOS 14+ ONLY** — never use iOS 15+/16+/17+ APIs without `@available`
2. **TTBaseUIKit COMPONENTS** — never use raw UIKit when TTBaseUIKit exists
3. **TTViewCodable MVVM** — UIKit views must use TTViewCodable protocol
4. **TTBaseSUI FOR SWIFTUI** — use TTBaseSUI* wrappers for SwiftUI
5. **SUIBaseView WRAPPER** — every SwiftUI screen must use `SUIBaseView` (v2.0 — NEW)
6. **TTBaseNavigationLink** — every navigation between screens uses `TTBaseNavigationLink` (v2.0 — NEW)
7. **MVVM SEPARATION** — ViewModel never imports UIKit/SwiftUI
8. **xcodebuild CLI IS LAW** — use `xcodebuild` command, not Cmd+B
9. **ZERO REGRESSION** — every change verified against existing code
10. **ANTI-LOOP: MAX 3 ROUNDS** — 3 build failures → stop, document errors
11. **POST-BUILD VERIFICATION IS MANDATORY** — after every skill workflow: `BUILD SUCCEEDED`

## Three-Tier SwiftUI Approach (v2.0)

| Tier | When to Use | Components |
|------|-------------|------------|
| **Tier 1 — TTBaseSUI** | Component already exists | `TTBaseSUI*` wrappers → `$ttb-skill-swiftui` |
| **Tier 2 — SUIBaseView + TTBaseNavigationLink** | Navigation between screens | Mandatory wrapper + link pattern |
| **Tier 3 — Native SwiftUI + tokens** | TTBaseSUI lacks component | `Text`, `Button`, `VStack` + TTView/TTSize/TTFont |

## Navigation Patterns (v2.0)

### SwiftUI (MANDATORY)

Every SwiftUI screen **MUST** use `SUIBaseView` as the root wrapper.

```swift
struct HomeScreen: View {
    var body: some View {
        SUIBaseView(
            backType: .SWIFTUI,
            title: XText("Screen.Title"),
            type: .DEFAULT,
            isHiddenTabbar: true,
            backAction: {}
        ) {
            content
        }
    }
}
```

Every navigation **MUST** use `TTBaseNavigationLink`.

```swift
TTBaseNavigationLink(destination: {
    DetailScreen(viewModel: vm)
}, label: {
    ItemCardView(item: item)
}, isAnimation: true)
```

### backType Decision Matrix

| Scenario | backType |
|----------|----------|
| Pure SwiftUI app | `.SWIFTUI` |
| Hybrid app (UIKit nav stack) | `.POP` |
| Dismiss modal | `.DISMISS` |
| Pop to root | `.POP_TO_ROOT` |
| Close entire flow | `.CLOSE_FLOW` |

## FCR 7-Dimension Compliance

| # | Dimension | Weight | Must Pass |
|---|-----------|--------|-----------|
| 1 | iOS 14+ API | 15% | No iOS 15+/16+/17+ APIs |
| 2 | TTBaseUIKit Compliance | 20% | All components, no raw UIKit |
| 3 | Config Tokens | 15% | TTView/TTSize/TTFont everywhere |
| 4 | MVVM Separation | 15% | ViewModel pure, VC thin |
| 5 | Closure Safety | 15% | [weak self] everywhere |
| 6 | Localization | 10% | XText/XTextU with keys |
| 7 | Code Quality | 10% | MARK sections, naming, style |

**Pass Threshold**: ≥ 85% (≥ 8.5/10 avg)

## Critical Token Warnings (v2.0)

The following tokens **DO NOT EXIST** in TTBaseUIKit:

| ❌ DO NOT USE | ✅ USE INSTEAD |
|--------------|----------------|
| `XView` | `TTView` |
| `XSize` | `TTSize` |
| `XFont` | `TTFont` |
| `TTView.colorSuccess` | `TTView.notificationBgSuccess` |
| `TTView.buttonBgWarring` | `TTView.buttonBgWar` |
| `TTView.buttonBgDisable` | `TTView.buttonBgDis` |
| `TTView.textThirdTitleColor` | `TTView.textSubTitleColor` |
| `TTView.viewBgSecondaryColor` | `TTView.viewBgColor` |
| `TTView.separatorColor` | `TTView.lineDefColor` |
| `TTView.iconPrimaryColor` | `TTView.iconColor` |
| `TTSize.P_XXL` | `TTSize.P_CONS_DEF * 4` (32pt) |
| `TTSize.SIZE_SUPER_HEADER` | `TTFont.HEADER_SUPER_H` |

## Requirements

- **Codex CLI** (latest version) — [Install guide](https://developers.openai.com/codex)
- macOS with Bash 4+

## Regenerate Archives

If you modify any skill file, re-export all archives:

```bash
cd path/to/TTBaseUIKit
bash Agents/Antigravity/export.sh
```

## Troubleshooting

### Skills not appearing

1. Restart Codex (new terminal session or `codex restart`).
2. Verify skills directory exists:

```bash
ls ~/.agents/skills/
```

3. Check skill folder structure:

```bash
ls ~/.agents/skills/ttb-skill-uikit/
# Should show: SKILL.md (and optionally scripts/, references/)
```

4. Codex auto-detects skill changes. If issues persist, restart Codex.

### Permission denied

```bash
chmod +x install.sh
```

### Verify skill metadata

```bash
head ~/.agents/skills/ttb-skill-uikit/SKILL.md
# Should show YAML frontmatter with name + description
```

### Remove all installed skills

```bash
rm -rf ~/.agents/skills/ttb-skill-init
rm -rf ~/.agents/skills/ttb-skill-uikit
rm -rf ~/.agents/skills/ttb-skill-swiftui
rm -rf ~/.agents/skills/ttb-skill-native-swiftui-components
rm -rf ~/.agents/skills/ttb-skill-bugfix
rm -rf ~/.agents/skills/ttb-skill-refactor
rm -rf ~/.agents/skills/ttb-skill-audit
rm -rf ~/.agents/skills/ttb-skill-shared
rm -rf ~/.agents/skills/antigravity-*
```

### Disable a skill without deleting

Add to `~/.codex/config.toml`:

```toml
[[skills.config]]
path = "/Users/<you>/.agents/skills/ttb-skill-audit/SKILL.md"
enabled = false
```

Then restart Codex.

## See Also

- [Cursor Installation Guide](../INSTALL.md) — for Cursor IDE
- [Claude Code Installation Guide](../ClaudeCode/INSTALL.md) — for Claude Code CLI
- [Codex Skills Documentation](https://developers.openai.com/codex/skills)
- [Customization Guide](https://developers.openai.com/codex/concepts/customization)
- [awesome-codex-skills](https://github.com/ComposioHQ/awesome-codex-skills) — curated community skills
