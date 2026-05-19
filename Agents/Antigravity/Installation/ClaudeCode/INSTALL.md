# Antigravity Skills — Claude Code Installation Guide

## Overview

This package contains the full Antigravity TTBaseUIKit skill set for **Claude Code** AI agents.

**Version 2.0.0** — 11 Iron Laws, SUIBaseView + TTBaseNavigationLink mandatory, navigation reference, token warnings, three-tier SwiftUI approach, FCR 7-Dimension scoring.

## Contents

```
ClaudeCode/
├── antigravity-claude-code-skills.tar.gz    ← Portable archive (v2.0.0)
├── install.sh                                ← Installation script
└── INSTALL.md                                ← This file
```

## Quick Install — Claude Code

1. Open terminal, navigate to this folder:

```bash
cd path/to/TTBaseUIKit/Agents/Antigravity/Installation/ClaudeCode
```

2. Run the installer:

```bash
bash install.sh
```

3. Verify:

```bash
claude skills list
```

## What Gets Installed

Skills land in `~/.claude/skills/`:

```
~/.claude/skills/
├── ttb-skill-init/              Project initialization (RUN FIRST)
├── ttb-skill-uikit/            UIKit: screen, list, form, cell, customview, api, coordinator, viewmodel
├── ttb-skill-swiftui/           SwiftUI: TTBaseSUI + native screens, views, viewmodels
├── ttb-skill-native-swiftui-components/  20 Native SwiftUI components
├── ttb-skill-bugfix/           Systematic bug fix workflow
├── ttb-skill-refactor/           Clean architecture refactoring
├── ttb-skill-audit/              Performance, accessibility, localization audits
├── ttb-skill-shared/             Shared rules, phases, references, scripts
├── antigravity-SKILL.md           Root skill entry point (v2.1.0)
├── antigravity-README.md         Overview (EN)
├── antigravity-README-VI.md      Overview (VI)
├── antigravity-Tutorial.md       Tutorial (EN) — when to use, prompt examples
├── antigravity-Tutorial-vi.md     Tutorial (VI)
└── antigravity-VERSION.md        Version history
```

## Skill Activation Commands

| Command | Skill |
|---------|-------|
| `/ttb-init` | Project initialization (RUN FIRST) |
| `/ttb-uikit` | Build UIKit screens with TTViewCodable |
| `/ttb-swiftui` | Build SwiftUI screens with TTBaseSUI |
| `/ttb-native` | 20 Native SwiftUI components |
| `/ttb-bugfix` | Systematic bug fixing |
| `/ttb-refactor` | Clean architecture refactoring |
| `/ttb-audit` | Performance, accessibility, localization audits |

## Architecture

```
AppCoordinator
  └── FeatureCoordinator
        └── ViewController / Screen
              ├── TTViewCodable / SUIBaseView
              ├── ViewModel (BaseViewModel)
              │     ├── API Service
              │     └── RequestData
              └── TTBaseUIKit / TTBaseSUI Components
```

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
| **Tier 1 — TTBaseSUI** | Component already exists | `TTBaseSUI*` wrappers → `/ttb-suit-*` |
| **Tier 2 — SUIBaseView + TTBaseNavigationLink** | Navigation between screens | Mandatory wrapper + link pattern |
| **Tier 3 — Native SwiftUI + tokens** | TTBaseSUI lacks component | `Text`, `Button`, `VStack` + TTView/TTSize/TTFont |

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

- **Claude Code CLI** (latest version)
- macOS with Bash 4+

## Regenerate Archives

If you modify any skill file, re-export the archives:

```bash
cd path/to/TTBaseUIKit
bash Agents/Antigravity/export.sh
```

## Troubleshooting

### Skills not appearing

1. Restart Claude Code terminal session.
2. Run `claude skills list` to verify installation.
3. Check that `~/.claude/skills/` exists and contains the skill directories.

### Permission denied

```bash
chmod +x install.sh
```

### Remove all installed skills

```bash
rm -rf ~/.claude/skills/ttb-skill-init
rm -rf ~/.claude/skills/ttb-skill-uikit
rm -rf ~/.claude/skills/ttb-skill-swiftui
rm -rf ~/.claude/skills/ttb-skill-native-swiftui-components
rm -rf ~/.claude/skills/ttb-skill-bugfix
rm -rf ~/.claude/skills/ttb-skill-refactor
rm -rf ~/.claude/skills/ttb-skill-audit
rm -rf ~/.claude/skills/ttb-skill-shared
rm -f  ~/.claude/skills/antigravity-*
```

## See Also

- [Cursor Installation Guide](../INSTALL.md) — for Cursor IDE
- [Codex Installation Guide](../Codex/INSTALL.md) — for Codex CLI
