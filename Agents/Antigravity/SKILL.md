---
name: "antigravity-root"
description: "Enterprise-grade iOS development workflow for TTBaseUIKit-powered apps. MVVM-C Architecture | UIKit + SwiftUI | TTViewCodable | TTBaseSUI | xcodebuild CLI Verification | Zero Regression | iOS 14+"
version: "2.1.0"
date_updated: "2026-05-19"
risk: "safe"
source: "internal"
tags: ["ttbaseuikit", "ios", "mvvm-c", "uikit", "swiftui", "ttbasesui", "antigravity"]
---

# Antigravity — TTBaseUIKit AI Agents

> Enterprise-grade iOS development skill set for TTBaseUIKit-powered apps.
> MVVM-C Architecture | UIKit + SwiftUI | TTViewCodable | TTBaseSUI | SUIBaseView Navigation
> xcodebuild CLI Verification | Zero Regression | iOS 14+

## Skill Sets

| Skill | Description | Commands |
|-------|-------------|----------|
| `/ttb-init` | Project initialization: MVVM-C structure, TTBaseUIKitConfig, localization, TTBDebugPlus. **Run FIRST.** | 5 |
| `/ttb-uikit` | UIKit full-stack: screen, list, form, cell, customview, api, coordinator, viewmodel | 8 |
| `/ttb-swiftui` | SwiftUI full-stack: TTBaseSUI screens/views and Native SwiftUI screens/views | 6 |
| `/ttb-native-swiftui-components` | Native SwiftUI reusable components: 20 components with TTBaseUIKit tokens. 100% standard SwiftUI. No TTBaseSUI wrappers. | 20 |
| `/ttb-bugfix` | Systematic bug fixing: root cause analysis, minimal fix, zero regression | 1 |
| `/ttb-refactor` | Migrate raw UIKit to TTBaseUIKit, TTViewCodable adoption, TTBaseSUI adoption, clean MVVM separation | 2 |
| `/ttb-audit` | Performance, accessibility, localization audits with FCR compliance scoring | 3 |
| `/ttb-shared` | Shared resources: rules, phases, references, scripts, fragments, templates, registry | — |

## Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                     AppCoordinator                               │
│  ┌─────────────┬─────────────┬─────────────┬──────────┐   │
│  │TabCoordinator│TabCoordinator│TabCoordinator│          │   │
│  └──────┬──────┴──────┬──────┴──────┬──────┘          │   │
│         │               │              │                   │   │
│  ┌──────▼──────┐ ┌────▼────┐ ┌─────▼─────┐            │   │
│  │ Feature      │ │ Feature  │ │ Feature   │            │   │
│  │ Coordinator   │ │Coordinator│ │ Coordinator│            │   │
│  └──────┬──────┘ └────┬─────┘ └─────┬─────┘            │   │
│         │               │              │                    │   │
│  ┌──────▼──────────────▼──────────────▼─────┐              │   │
│  │     ViewController (UIKit)               │              │   │
│  │     or SwiftUI Screen                     │              │   │
│  │     + TTViewCodable / SUIBaseView         │              │   │
│  └──────┬──────────────────┬──────────────────┘              │   │
│         │                  │                               │   │
│  ┌──────▼──────┐ ┌───────▼──────────┐                    │   │
│  │  ViewModel   │ │  TTBaseUIKit     │                    │   │
│  │  (MVVM)      │ │  Components      │                    │   │
│  └──────┬──────┘ └───────┬──────────┘                    │   │
│         │                  │                                │   │
│  ┌──────▼─────────────────▼─────┐                          │   │
│  │        RequestAPI              │                          │   │
│  │  (URLSession + Codable)       │                          │   │
│  └───────────────────────────────┘                          │   │
└──────────────────────────────────────────────────────────────┘

TTBaseUIKit Design System:
┌─────────────┬────────────────┬────────────┬──────────────────┐
│   TTView    │    TTSize      │   TTFont  │ TTBaseUIKitConfig │
│  (UIColor)  │   (CGFloat)    │ (CGFloat) │    (singleton)   │
└─────────────┴────────────────┴────────────┴──────────────────┘
```

## SwiftUI Navigation Pattern (MANDATORY)

All SwiftUI screens **MUST** use `SUIBaseView` as the screen wrapper and `TTBaseNavigationLink` for navigation between screens. This is non-negotiable for TTBaseUIKit apps.

```swift
// Every SwiftUI screen
struct HomeScreen: View {
    @StateObject private var vm = HomeViewModel()

    var body: some View {
        SUIBaseView(
            backType: .SWIFTUI,          // or .POP for UIKit hybrid
            title: XText("App.Home.Nav.Title"),
            type: .DEFAULT,
            isHiddenTabbar: true,
            backAction: {}
        ) {
            // Screen content
        }
        .onAppear { vm.fetchData() }
    }
}

// Navigation between screens
TTBaseNavigationLink(destination: {
    DetailScreen(item: item)
}, label: {
    ItemCardView(item: item)
        .pAll(TTSize.P_CONS_DEF)
        .bg(byDef: TTView.viewBgCellColor.toColor())
        .corner(byDef: TTSize.CORNER_PANEL)
        .baseShadow()
})
```

## Three-Tier SwiftUI Approach

| Tier | When | Components |
|------|-------|-----------|
| **Tier 1 — TTBaseSUI** | Component already exists | `TTBaseSUI*` wrappers → `/ttb-sui-*` |
| **Tier 2 — SUIBaseView + TTBaseNavigationLink** | Navigation between screens | Mandatory pattern |
| **Tier 3 — Native SwiftUI + tokens** | TTBaseSUI lacks component | `Text`, `Button`, `VStack` + tokens → `/ttb-native-*` |

**Rule: Prefer TTBaseSUI. Only fallback to Native SwiftUI when TTBaseSUI has no equivalent.**

## Activation

Activate by saying:

| Scenario | Activate |
|----------|----------|
| Init project, setup project | `/ttb-init` — **Run FIRST** |
| Build UIKit screen, list, form, cell | `/ttb-uikit-*` |
| Build SwiftUI screen (TTBaseSUI or native) | `/ttb-sui-*` or `/ttb-native-*` |
| Build native SwiftUI reusable component | `/ttb-native-*` |
| Fix bug, debug, crash | `/ttb-bugfix` |
| Refactor, clean up code | `/ttb-refactor` |
| Audit performance, accessibility, localization | `/ttb-audit-*` |
| Rules, phases, references | `/ttb-shared` |

## Quick Start

```
1. Activate: "init project"   → /ttb-init           ← Run FIRST
2. Activate: "build a UIKit screen" → /ttb-uikit
3. Activate: "build a SwiftUI screen" → /ttb-sui-screen
4. Activate: "build a native SwiftUI component" → /ttb-native-button
5. Activate: "fix bug" → /ttb-bugfix
6. Activate: "refactor" → /ttb-refactor
7. Activate: "audit" → /ttb-audit
```

## 11 Iron Laws (MANDATORY)

1. **iOS 14+ ONLY** — never use iOS 15+/16+/17+ APIs without `@available`
2. **TTBaseUIKit COMPONENTS** — never use raw UIKit when TTBaseUIKit exists
3. **TTViewCodable MVVM** — UIKit views must use TTViewCodable protocol
4. **TTBaseSUI FOR SWIFTUI** — use TTBaseSUI* wrappers for SwiftUI
5. **SUIBaseView WRAPPER** — every SwiftUI screen must use `SUIBaseView`
6. **TTBaseNavigationLink** — every navigation between screens uses `TTBaseNavigationLink`
7. **MVVM SEPARATION** — ViewModel never imports UIKit/SwiftUI
8. **xcodebuild CLI IS LAW** — use `xcodebuild` command, not Cmd+B
9. **ZERO REGRESSION** — every change verified against existing code
10. **ANTI-LOOP: MAX 3 ROUNDS** — 3 build failures → stop, document errors
11. **POST-BUILD VERIFICATION IS MANDATORY** — after every skill workflow: `BUILD SUCCEEDED`

> Full Iron Laws: `ttb-skill-shared/fragments/ttb-iron-laws.frag.md`

## Code Generation Marker

Every generated file must have this marker comment:

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  {FileName}.swift
//  {AppName}
//
```

> Full marker template: `ttb-skill-shared/fragments/ttb-marker.frag.md`

## Post-Build Verification (MANDATORY)

After every skill workflow completes, **run Phase 6 verification**:

```bash
bash ttb-skill-shared/scripts/ttb-verify.sh
bash ttb-skill-shared/scripts/ttb-compliance-check.sh
```

### 5-Layer Verification Stack

| Layer | Check |
|-------|-------|
| Layer 1 | Xcode Project Integrity — all `.swift` files in `project.pbxproj` |
| Layer 2 | xcodebuild CLI — `BUILD SUCCEEDED` |
| Layer 3 | Rules Compliance — iOS 14+, TTBaseUIKit, tokens, closures |
| Layer 4 | Regression Guard — existing code not broken |
| Layer 5 | FCR 7-Dimension Score — ≥ 85 to pass |

**Anti-Loop**: Max 3 build attempts. 3 failures → STOP, document errors.

### FCR 7-Dimension Compliance Score

| Dimension | Weight | Check |
|-----------|--------|-------|
| iOS 14+ API | 15% | No iOS 15+/16+/17+ APIs |
| TTBaseUIKit Compliance | 20% | All components, no raw UIKit |
| Config Tokens | 15% | TTView/TTSize/TTFont everywhere |
| MVVM Separation | 15% | ViewModel pure, VC thin |
| Closure Safety | 15% | [weak self] everywhere |
| Localization | 10% | XText/XTextU with Localizable.strings |
| Code Quality | 10% | MARK sections, naming, style |

```
Score >= 85: READY
Score 70-84: NEEDS FIX
Score < 70: BLOCKED
```

## Token Budget

| Category | Tokens/Session |
|----------|----------------|
| Root + Shared SKILL.md | ~1,500 |
| Iron Laws fragment | ~240 |
| Marker fragment | ~40 |
| Domain skill (UIKit/SwiftUI) | ~3,000 |
| On-demand prompts | ~500-2,000 each |
| Verify scripts (runtime, zero tokens) | 0 |
| **Total per session** | **~5,000-7,000** |
| **Before optimization (v1.0)** | **~12,000-15,000** |
| **Savings** | **~50-55%** |

## Progressive Loading

Skills use `loadLevel` metadata to minimize context bloat:

| loadLevel | When | Examples |
|-----------|------|---------|
| `always` | Load on every session start | Root SKILL.md, shared rules |
| `domain` | Load when domain is detected | UIKit, SwiftUI, Bugfix skills |
| `on-demand` | Load only when explicitly triggered | Audit, Refactor, Native Components |

See full registry: `ttb-skill-shared/ttb-skill-registry.md`

## Directory Structure

```
Agents/Antigravity/
├── SKILL.md                                  ← Root workflow
├── README.md / README-VI.md / VERSION.md
├── AUDIT-REPORT.md                           ← Optimization audit
├── export.sh                                 ← Archive builder
│
├── ttb-skill-init/                          ← Project initialization (RUN FIRST)
│   ├── SKILL.md
│   └── prompts/
│       ├── ttb-skill-init.prompt.md
│       ├── ttb-skill-init-structure.prompt.md
│       ├── ttb-skill-init-ttbaseui-kit.prompt.md
│       ├── ttb-skill-init-localization.prompt.md
│       └── ttb-skill-init-debug.prompt.md
│
├── ttb-skill-uikit/                         ← UIKit skill set (8 commands)
│   ├── SKILL.md
│   └── ttb-skill-*.prompt.md
│
├── ttb-skill-swiftui/                       ← SwiftUI skill set (6 commands)
│   ├── SKILL.md
│   ├── ttb-skill-sui-screen.prompt.md
│   ├── ttb-skill-sui-view.prompt.md
│   ├── ttb-skill-sui-list.prompt.md
│   ├── ttb-skill-sui-viewmodel.prompt.md
│   ├── ttb-skill-native-screen.prompt.md
│   ├── ttb-skill-native-view.prompt.md
│   └── ttb-ref-ttbasesui.md
│
├── ttb-skill-native-swiftui-components/     ← Native SwiftUI components (20 commands)
│   ├── SKILL.md
│   ├── refs/
│   │   └── ttb-ref-native-design-tokens.md
│   └── ttb-skill-native-*.prompt.md         ← 20 component files
│
├── ttb-skill-bugfix/                        ← Bug fix workflow
│   ├── SKILL.md
│   └── ttb-skill-bugfix.prompt.md
│
├── ttb-skill-refactor/                      ← Refactor workflow
│   ├── SKILL.md
│   └── ttb-skill-refactor.prompt.md
│
├── ttb-skill-audit/                         ← Audit workflows (3 commands)
│   ├── SKILL.md
│   ├── ttb-skill-audit-performance.prompt.md
│   ├── ttb-skill-audit-accessibility.prompt.md
│   └── ttb-skill-audit-localization.prompt.md
│
└── ttb-skill-shared/                        ← Shared resources
    ├── SKILL.md
    ├── ttb-skill-registry.md
    ├── scripts/
    │   ├── ttb-verify.sh
    │   ├── ttb-compliance-check.sh
    │   └── ttb-precheck.sh
    ├── fragments/
    │   ├── ttb-iron-laws.frag.md
    │   └── ttb-marker.frag.md
    ├── rules/
    │   ├── ttb-rule-anti-patterns.md
    │   ├── ttb-rule-coding-standards.md
    │   ├── ttb-rule-memory-leaks.md
    │   └── ttb-rule-comments.md
    ├── phases/
    │   ├── ttb-phase-feature-research.md
    │   ├── ttb-phase-feature-spec.md
    │   ├── ttb-phase-implementation.md
    │   ├── ttb-phase-code-review.md
    │   └── ttb-phase-verify.md
    └── refs/
        ├── ttb-ref-ttbaseuikit.md
        ├── ttb-ref-ttbasesui.md
        ├── ttb-ref-config-tokens.md
        ├── ttb-ref-ios14-compatibility.md
        ├── ttb-ref-swiftui-performance.md
        ├── ttb-ref-swiftui-architecture.md
        └── ttb-ref-navigation.md         ← NEW: Navigation pattern reference
```

## Config Tokens

```swift
// Colors (UIColor → SwiftUI Color)
TTView.viewBgColor          // Background
TTView.textDefColor         // Default text
TTView.buttonBgDef          // Button background
TTView.iconColor            // Icon color
TTView.notificationBgSuccess // Success green
TTView.notificationBgWarning // Warning yellow
TTView.notificationBgError  // Error red

// Sizes (CGFloat)
TTSize.P_CONS_DEF           // 8pt — default padding
TTSize.P_L                 // 16pt — standard padding
TTSize.CORNER_RADIUS       // 4pt — corner radius
TTSize.CORNER_PANEL        // 8pt — card radius
TTSize.H_BUTTON            // 40pt — button height

// Fonts (use with .system(size:weight:))
TTFont.HEADER_H            // ~16pt — header
TTFont.TITLE_H             // ~14pt — title
TTFont.SUB_TITLE_H         // ~12pt — subtitle
```

## ⚠️ Critical Token Warnings

The following tokens **DO NOT EXIST** in TTBaseUIKit. Always use alternatives:

| ❌ DO NOT USE | ✅ USE INSTEAD |
|--------------|----------------|
| `XView` | `TTView` |
| `XSize` | `TTSize` |
| `XFont` | `TTFont` |
| `TTView.colorSuccess` | `TTView.notificationBgSuccess` |
| `TTView.colorWarning` | `TTView.notificationBgWarning` |
| `TTView.colorError` | `TTView.notificationBgError` |
| `TTView.buttonBgHighlight` | Calculate manually (`.withAlphaComponent`) |
| `TTView.buttonBgWarring` | `TTView.buttonBgWar` |
| `TTView.buttonBgDisable` | `TTView.buttonBgDis` |
| `TTView.textThirdTitleColor` | `TTView.textSubTitleColor` |
| `TTView.viewBgSecondaryColor` | `TTView.viewBgColor` |
| `TTView.separatorColor` | `TTView.lineDefColor` |
| `TTView.iconPrimaryColor` | `TTView.iconColor` |
| `TTSize.P_XXL` | `TTSize.P_CONS_DEF * 4` (32pt) |
| `TTSize.SIZE_SUPER_HEADER` | `TTFont.HEADER_SUPER_H` |

---

## Resources

- [SKILL.md](SKILL.md) — Root workflow (start here)
- [Tutorial.md](Tutorial.md) — When to use each skill, prompt examples, practical guide
- [README.md](README.md) — English overview
- [README-VI.md](README-VI.md) — Vietnamese overview
- [Skill Registry](ttb-skill-registry.md) — All skills index
- [Installation](Installation/INSTALL.md) — Setup instructions

---

**Version**: 2.1.0 | **Date**: 2026-05-19
**Changelog**: v2.1.0 — Added mandatory SUIBaseView + TTBaseNavigationLink as Iron Laws #5-#6. Added critical token warnings section. Added three-tier SwiftUI approach. Added navigation ref to directory structure. Fixed XView/XSize/XFont references throughout. Added ttb-rule-comments to shared resources. Bumped all skill versions to v2.0.0 for consistency. v2.0.0 — ttb-skill-swiftui complete rewrite: SUIBaseView navigation, TTBaseNavigationLink, full TTBaseSUI inventory. v1.3.0 — Critical API corrections: all XView→TTView, XSize→TTSize, XFont→TTFont.
