# Antigravity Skills — Installation Guide

## Overview

This package contains the full Antigravity TTBaseUIKit skill set for Cursor AI, Claude Code, and Codex agents.

**Version 2.0.0** — 11 Iron Laws, SUIBaseView + TTBaseNavigationLink mandatory, navigation reference, token warnings, three-tier SwiftUI approach, FCR 7-Dimension scoring.

## Contents

```
Installation/
├── antigravity-skills.tar.gz              ← Cursor package
├── install.sh                               ← Cursor installer
├── INSTALL.md                              ← This file
├── VERSION.md                              ← Version history
├── ClaudeCode/
│   ├── antigravity-claude-code-skills.tar.gz  ← Claude Code package
│   ├── install.sh                              ← Claude Code installer
│   └── INSTALL.md                              ← Claude Code guide
└── Codex/
    ├── antigravity-codex-skills.tar.gz         ← Codex package
    ├── install.sh                               ← Codex installer
    └── INSTALL.md                               ← Codex guide
```

## Quick Install — Cursor

1. Open terminal, navigate to this folder:

```bash
cd path/to/TTBaseUIKit/Agents/Antigravity/Installation
```

2. Run the installer:

```bash
bash install.sh
```

3. Restart Cursor (Cmd+Q) or refresh Skills in Cursor Settings.

## Quick Install — Claude Code

1. Navigate to the Claude Code folder:

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

## Quick Install — Codex

1. Navigate to the Codex folder:

```bash
cd path/to/TTBaseUIKit/Agents/Antigravity/Installation/Codex
```

2. Run the installer:

```bash
bash install.sh
```

3. Restart Codex to load new skills.

Skills land in `~/.agents/skills/` (USER level — available across all repos).

## What Gets Installed

**Cursor:** skills land in `~/.cursor/skills/`
**Claude Code:** skills land in `~/.claude/skills/`
**Codex:** skills land in `~/.agents/skills/`

All three receive the same skill sets:

```
├── ttb-skill-init/              Project initialization (RUN FIRST)
├── ttb-skill-uikit/            UIKit: screen, list, form, cell, customview, api, coordinator, viewmodel
├── ttb-skill-swiftui/           SwiftUI: TTBaseSUI + native screens, views, viewmodels
├── ttb-skill-native-swiftui-components/  20 Native SwiftUI components
├── ttb-skill-bugfix/            Systematic bug fix workflow
├── ttb-skill-refactor/          Clean architecture refactoring
├── ttb-skill-audit/             Performance, accessibility, localization audits
├── ttb-skill-shared/            Shared rules, phases, references, scripts, fragments
├── antigravity-SKILL.md          Root skill entry point (v2.1.0)
├── antigravity-README.md        Overview (EN)
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
5. **SUIBaseView WRAPPER** — every SwiftUI screen must use `SUIBaseView` (v2.0)
6. **TTBaseNavigationLink** — every navigation between screens uses `TTBaseNavigationLink` (v2.0)
7. **MVVM SEPARATION** — ViewModel never imports UIKit/SwiftUI
8. **xcodebuild CLI IS LAW** — use `xcodebuild` command, not Cmd+B
9. **ZERO REGRESSION** — every change verified against existing code
10. **ANTI-LOOP: MAX 3 ROUNDS** — 3 build failures → stop, document errors
11. **POST-BUILD VERIFICATION IS MANDATORY** — after every skill workflow: `BUILD SUCCEEDED`

## Requirements

- **Cursor IDE** (latest version) — for the Cursor package
- **Claude Code CLI** (latest version) — for the Claude Code package
- **Codex CLI** (latest version) — for the Codex package
- macOS with Bash 4+

## Regenerate Archives

If you modify any skill file, re-export the archives:

```bash
cd path/to/TTBaseUIKit
bash Agents/Antigravity/export.sh
```

This regenerates all three platform packages (Cursor, Claude Code, Codex).

## Troubleshooting

### Cursor — Skills not appearing

1. Quit Cursor fully (Cmd+Q), not just close the window.
2. Check that `~/.cursor/skills/` exists and contains the skill directories.
3. In Cursor Settings > Skills, click the refresh/sync button.

### Claude Code — Skills not appearing

1. Restart Claude Code terminal session.
2. Run `claude skills list` to verify.

### Permission denied

```bash
chmod +x install.sh
chmod +x ../ClaudeCode/install.sh
chmod +x ../Codex/install.sh
```

### Remove all installed skills

**Cursor:**
```bash
rm -rf ~/.cursor/skills/ttb-skill-*
rm -rf ~/.cursor/skills/antigravity-*
```

**Claude Code:**
```bash
rm -rf ~/.claude/skills/ttb-skill-*
rm -rf ~/.claude/skills/antigravity-*
```

**Codex:**
```bash
rm -rf ~/.agents/skills/ttb-skill-*
rm -rf ~/.agents/skills/antigravity-*
```
