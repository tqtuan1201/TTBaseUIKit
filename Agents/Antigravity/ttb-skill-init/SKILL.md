---
name: "ttb-skill-init"
description: "TTBaseUIKit project initialization skill: scaffold MVVM-C folder structure, setup TTBaseUIKitConfig, configure localization, integrate TTBDebugPlus. Run BEFORE any other TTBaseUIKit skill."
version: "2.0.0"
loadLevel: "always"
---

# ttb-skill-init

> TTBaseUIKit project initialization skill.
> Run FIRST before any other TTBaseUIKit skill (uikit, swiftui, bugfix, refactor, audit).
> MVVM-C Structure | TTBaseUIKitConfig | Localization | TTBDebugPlus | iOS 14+

## Skills in This Set

| Command | Description |
|---------|-------------|
| `/ttb-init` | Full project initialization (all phases) |
| `/ttb-init-structure` | MVVM-C folder structure + coordinators |
| `/ttb-init-config` | TTBaseUIKitConfig + dependency setup (SPM/CocoaPods) |
| `/ttb-init-l10n` | Localizable.strings + XText/XTextU setup |
| `/ttb-init-debug` | TTBDebugPlus integration |

## When to Use

Activate **FIRST** when user:
- "init project", "khởi tạo dự án", "setup project", "new TTBaseUIKit project"
- "cấu trúc dự án", "project structure", "project scaffold"
- "configure TTBaseUIKit", "setup TTBaseUIKit"
- "add TTBaseUIKit to existing project"
- Starting a new iOS/macOS app with TTBaseUIKit
- Existing project missing proper TTBaseUIKit foundation

## Why This Skill Exists

Every existing TTBaseUIKit skill (uikit, swiftui, bugfix, refactor, audit) **assumes** the project already has:

| Assumption | Will Fail Without |
|-----------|-------------------|
| `TTBaseUIKit` dependency installed | `error: cannot find module 'TTBaseUIKit'` |
| `TTBaseUIKitConfig` initialized | Runtime crash, config tokens return nil |
| `Localizable.strings` exists | `XText`/`XTextU` return empty strings |
| MVVM-C folder structure | Cannot create files in expected paths |
| Coordinators scaffolded | Navigation flow breaks |
| Xcode project registered files | xcodebuild fails with "file not found" |
| iOS 14+ deployment target | iOS 15+/16+/17+ API calls crash |

This skill creates the **correct foundation** so all other skills work without errors.

## Quick Start

1. Ask clarifying questions (dependency manager, architecture, navigation style)
2. Run `/ttb-init` for full setup, or specific command for partial setup
3. Verify with xcodebuild
4. Project is **READY FOR BUILDING** with other skills

## 12 Iron Laws (All Skills)

1. **iOS 14+ ONLY** — no iOS 15+/16+/17+ APIs without `@available`
2. **TTBaseUIKit COMPONENTS** — never use raw UIKit when TTBaseUIKit exists
3. **TTViewCodable MVVM** — UIKit views must use TTViewCodable protocol
4. **TTBaseSUI FOR SWIFTUI** — use TTBaseSUI* wrappers for SwiftUI
5. **MVVM SEPARATION** — ViewModel never imports UIKit/SwiftUI
6. **xcodebuild CLI IS LAW** — use `xcodebuild` command, not Cmd+B
7. **ZERO REGRESSION** — every change verified against existing code
8. **INHERIT ARCHITECTURE** — do not create new patterns
9. **ANTI-LOOP: MAX 3 ROUNDS** — 3 build failures → stop
10. **CODE GENERATION MARKER** — every generated file must have the marker comment
11. **POST-BUILD VERIFICATION IS MANDATORY** — after every skill: xcodebuild must succeed + FCR compliance verified
12. **ASK BEFORE ASSUME** — if context insufficient, ask. Do not guess.

## Code Generation Marker

Every generated file must include:

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  {FileName}.swift
//  {AppName}
//
```

## Phase Overview

```
Phase 0: Pre-Init Assessment       → Ask clarifying questions
Phase 1: Project Folder Structure  → MVVM-C directories + base classes
Phase 2: Dependency Setup          → SPM or CocoaPods integration
Phase 3: TTBaseUIKitConfig         → Initialize TTBaseUIKitConfig
Phase 4: Localization Setup       → Localizable.strings + XText/XTextU
Phase 5: Navigation Architecture  → BaseTabBarController + AppCoordinator
Phase 6: TTBDebugPlus Integration  → TTBaseDebugKit + debug bridge
Phase 7: Resources                → Info.plist, Assets, Xcode project
Phase 8: xcodebuild Verification  → BUILD SUCCEEDED → READY FOR BUILDING
```

## Files in This Skill Set

| File | Purpose |
|------|---------|
| `ttb-skill-init.prompt.md` | Full 8-phase init workflow |
| `ttb-skill-init-structure.prompt.md` | MVVM-C folder structure + coordinators |
| `ttb-skill-init-ttbaseui-kit.prompt.md` | TTBaseUIKitConfig + dependency setup |
| `ttb-skill-init-localization.prompt.md` | Localizable.strings + XText/XTextU setup |
| `ttb-skill-init-debug.prompt.md` | TTBDebugPlus integration |

## Shared Resources

- `ttb-skill-shared/rules/ttb-rule-coding-standards.md` — File header, MARK sections, naming
- `ttb-skill-shared/rules/ttb-rule-anti-patterns.md` — Component anti-patterns
- `ttb-skill-shared/rules/ttb-rule-memory-leaks.md` — Memory leak detection
- `ttb-skill-shared/phases/ttb-phase-verify.md` — 5-layer post-build verification
- `ttb-skill-shared/refs/ttb-ref-ttbaseuikit.md` — TTBaseUIKit API reference
- `ttb-skill-shared/refs/ttb-ref-config-tokens.md` — TTView/TTSize/TTFont tokens
- `ttb-skill-shared/refs/ttb-ref-ios14-compatibility.md` — iOS 14 API guide

## Integration with Other Skills

This skill is the **foundation**. After init completes, proceed with:

| Scenario | Use Next |
|----------|---------|
| Building UIKit screens | **TTB UIKit Skill** (`/ttb-uikit-*`) |
| Building SwiftUI screens | **TTB SwiftUI Skill** (`/ttb-sui-*`) |
| Fixing bugs in existing code | **TTB Bugfix Skill** (`/ttb-bug-*`) |
| Refactoring old code | **TTB Refactor Skill** (`/ttb-refactor-*`) |
| Running quality audit | **TTB Audit Skill** (`/ttb-audit-*`) |
| Starting from scratch (new app) | **TTS Product Workflow** (`/tts-product-*`) |
| Adding features to existing app | **TTS Function Workflow** (`/tts-function-*`) |

All skills share `ttb-skill-shared/` rules and phases.

---

**Version**: 2.0.0 | **Date**: 2026-05-19
**Changelog**: v2.0.0 — Version bump. Added 11 Iron Laws. Added critical token warnings. Updated shared resources to v2.0.0. v1.4.0 — Updated ttb-rule-coding-standards.md and ttb-rule-anti-patterns.md with chainable extensions.
