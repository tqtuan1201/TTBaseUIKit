---
name: "antigravity-readme"
description: "English README — overview of TTBaseUIKit Antigravity agent system v2.0.0. Vietnamese version: README-VI.md."
version: "2.0.0"
---

# TTBaseUIKit Antigravity Agent System

**Version**: 2.0.0 | **Min iOS**: 14+ | **Architecture**: MVVM-C

## Overview

Antigravity is an AI agent skill system for building iOS apps with **TTBaseUIKit** (UIKit) and **TTBaseSUI** (SwiftUI wrapper). It enforces a strict development workflow with 7 phases, 11 Iron Laws, and FCR 7-Dimension compliance scoring.

## Quick Start

1. Read the root `SKILL.md` for system overview
2. Choose a skill based on your task:
   - **New Project**: `/tts-init` → `ttb-skill-init`
   - **UIKit Feature**: `/tts-uikit` → `ttb-skill-uikit`
   - **SwiftUI Feature**: `/tts-swiftui` → `ttb-skill-swiftui`
   - **Native SwiftUI Components**: `/tts-native` → `ttb-skill-native-swiftui-components`
   - **Bug Fix**: `/tts-bugfix` → `ttb-skill-bugfix`
   - **Refactor**: `/tts-refactor` → `ttb-skill-refactor`
   - **Audit**: `/tts-audit` → `ttb-skill-audit`

3. Follow the skill's workflow through its phases
4. **Always run post-build verification** (Phase 6) — `BUILD SUCCEEDED` is mandatory

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│  Antigravity Agent System                               │
├─────────────────────────────────────────────────────────┤
│  Core Skills (always loaded)                            │
│  ├── ttb-skill-init    — Project setup                 │
│  ├── ttb-skill-uikit  — UIKit feature dev             │
│  ├── ttb-skill-swiftui — SwiftUI feature dev           │
│  └── ttb-skill-bugfix — Bug fixing                     │
│                                                         │
│  Domain Skills (loaded when skill activates)            │
│  ├── ttb-skill-refactor        — Code migration        │
│  └── ttb-skill-native-swiftui   — Native SwiftUI       │
│                                                         │
│  On-Demand Skills (loaded when requested)               │
│  └── ttb-skill-audit   — Performance, a11y, l10n       │
├─────────────────────────────────────────────────────────┤
│  Shared Resources (all skills use)                      │
│  ├── 11 Iron Laws                                      │
│  ├── 5 Phases (Research → Spec → Impl → Review → Ver)  │
│  ├── 5 Rules (coding, anti-patterns, memory, etc.)      │
│  ├── 7 References (TTBaseUIKit, TTBaseSUI, tokens…)    │
│  └── 3 Scripts (precheck, compliance, verify)           │
└─────────────────────────────────────────────────────────┘
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

## Three-Tier SwiftUI Approach

| Tier | When to Use | Components |
|------|-------------|------------|
| **Tier 1 — TTBaseSUI** | Component already exists | `TTBaseSUI*` wrappers → `/ttb-sui-*` |
| **Tier 2 — SUIBaseView + TTBaseNavigationLink** | Navigation between screens | Mandatory wrapper + link pattern |
| **Tier 3 — Native SwiftUI + tokens** | TTBaseSUI lacks component | `Text`, `Button`, `VStack` + TTView/TTSize/TTFont |

**Rule: Prefer TTBaseSUI. Only fallback to Native SwiftUI when TTBaseSUI has no equivalent.**

## Navigation Patterns

### SwiftUI (MANDATORY)

Every SwiftUI screen **MUST** use `SUIBaseView` as the root wrapper.
Every navigation between screens **MUST** use `TTBaseNavigationLink`.

```swift
// Every SwiftUI screen — Iron Law #5
struct HomeScreen: View {
    var body: some View {
        SUIBaseView(
            titleNav: XTextU("App.Home.Nav.Title"),
            isShowBack: true,
            backType: .SWIFTUI,
            isHiddenTabbar: false
        ) {
            content
        }
        .onAppear { /* fetch data */ }
    }

    private var content: some View {
        ScrollView {
            LazyVStack(spacing: TTSize.P_CONS_DEF) {
                ForEach(items) { item in
                    TTBaseNavigationLink(
                        destination: DetailScreen(item: item),
                        label: { ItemCardView(item: item) }
                    )
                }
            }
            .padding(TTSize.P_CONS_DEF)
        }
        .background(TTView.viewBgColor.toColor())
    }
}

// TTBaseNavigationLink variants
// Variant 1: Simple navigation with label closure
TTBaseNavigationLink(destination: { DetailScreen(vm: vm) }, label: { CardView() })

// Variant 2: Active binding for programmatic navigation
TTBaseNavigationLink(isActive: $vm.isShowingDetail) {
    DetailScreen(vm: vm)
}
```

### backType Decision Matrix

| Scenario | backType |
|----------|----------|
| Pure SwiftUI app, navigating between screens | `.SWIFTUI` |
| Hybrid app (UIKit nav stack), push onto nav controller | `.POP` |
| Dismiss modal / sheet | `.DISMISS` |
| Pop back to root view controller | `.POP_TO_ROOT` |
| Close entire flow / tab | `.CLOSE_FLOW` |

### UIKit

```swift
// Coordinator pattern — Iron Law #7
class DetailCoordinator: TTCoordinator {
    var childCoordinators: [TTCoordinator] = []

    func start() {
        let vc = DetailViewController()
        vc.onDismiss = { [weak self] in self?.dismiss() }
        navigationController.pushViewController(vc, animated: true)
    }
}
```

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

| Score | Status |
|-------|--------|
| ≥ 85% | ✅ READY — Report success |
| 70–84% | ⚠️ NEEDS FIX — Fix issues → re-verify |
| < 70% | ❌ BLOCKED — STOP, escalate |

## ⚠️ Critical Token Warnings

The following tokens **DO NOT EXIST** in TTBaseUIKit:

| ❌ DO NOT USE | ✅ USE INSTEAD |
|--------------|----------------|
| `XView` | `TTView` |
| `XSize` | `TTSize` |
| `XFont` | `TTFont` |
| `TTView.colorSuccess` | `TTView.notificationBgSuccess` |
| `TTView.colorWarning` | `TTView.notificationBgWarning` |
| `TTView.colorError` | `TTView.notificationBgError` |
| `TTView.buttonBgHighlight` | Calculate manually |
| `TTView.buttonBgWarring` | `TTView.buttonBgWar` |
| `TTView.buttonBgDisable` | `TTView.buttonBgDis` |
| `TTView.textThirdTitleColor` | `TTView.textSubTitleColor` |
| `TTView.viewBgSecondaryColor` | `TTView.viewBgColor` |
| `TTView.separatorColor` | `TTView.lineDefColor` |
| `TTView.iconPrimaryColor` | `TTView.iconColor` |
| `TTSize.P_XXL` | `TTSize.P_CONS_DEF * 4` (32pt) |
| `TTSize.SIZE_SUPER_HEADER` | `TTFont.HEADER_SUPER_H` |

## Post-Build Verification (MANDATORY)

After every skill workflow completes, run Phase 6 verification:

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
| Layer 5 | FCR 7-Dimension Score — ≥ 85% to pass |

**Anti-Loop**: Max 3 build attempts. 3 failures → STOP, document errors.

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

## Directory Structure

```
Agents/Antigravity/
├── SKILL.md                              # Root skill (start here)
├── ttb-skill-registry.md                 # All skills index
├── README.md / README-VI.md              # Documentation
├── VERSION.md                            # Version history
├── AUDIT-REPORT.md                       # Optimization audit
├── export.sh                             # Archive builder
│
├── ttb-skill-init/                       # Project setup (RUN FIRST)
│   ├── SKILL.md
│   └── prompts/
│       ├── ttb-skill-init.prompt.md
│       ├── ttb-skill-init-structure.prompt.md
│       ├── ttb-skill-init-ttbaseui-kit.prompt.md
│       ├── ttb-skill-init-localization.prompt.md
│       └── ttb-skill-init-debug.prompt.md
│
├── ttb-skill-uikit/                      # UIKit skill (8 commands)
│   ├── SKILL.md
│   └── ttb-skill-*.prompt.md
│
├── ttb-skill-swiftui/                    # SwiftUI skill (6 commands)
│   ├── SKILL.md
│   ├── ttb-skill-sui-screen.prompt.md
│   ├── ttb-skill-sui-view.prompt.md
│   ├── ttb-skill-sui-list.prompt.md
│   ├── ttb-skill-sui-viewmodel.prompt.md
│   ├── ttb-skill-native-screen.prompt.md
│   ├── ttb-skill-native-view.prompt.md
│   └── ttb-ref-ttbasesui.md
│
├── ttb-skill-native-swiftui-components/  # Native SwiftUI (20 commands)
│   ├── SKILL.md
│   ├── refs/
│   │   └── ttb-ref-native-design-tokens.md
│   └── ttb-skill-native-*.prompt.md
│
├── ttb-skill-bugfix/                     # Bug fix workflow
│   ├── SKILL.md
│   └── ttb-skill-bugfix.prompt.md
│
├── ttb-skill-refactor/                   # Refactor workflow
│   ├── SKILL.md
│   └── ttb-skill-refactor.prompt.md
│
├── ttb-skill-audit/                      # Audit workflows (3 commands)
│   ├── SKILL.md
│   ├── ttb-skill-audit-performance.prompt.md
│   ├── ttb-skill-audit-accessibility.prompt.md
│   └── ttb-skill-audit-localization.prompt.md
│
└── ttb-skill-shared/                     # Shared resources
    ├── SKILL.md                          # Shared resources index
    ├── ttb-skill-registry.md             # Skill index + progressive loading
    ├── scripts/
    │   ├── ttb-verify.sh                 # 5-layer post-build verification
    │   ├── ttb-compliance-check.sh        # grep-based compliance checks
    │   └── ttb-precheck.sh               # Pre-skill prerequisite gate
    ├── fragments/
    │   ├── ttb-iron-laws.frag.md         # 11 mandatory Iron Laws
    │   └── ttb-marker.frag.md            # Code generation marker
    ├── rules/
    │   ├── ttb-rule-coding-standards.md
    │   ├── ttb-rule-anti-patterns.md
    │   ├── ttb-rule-memory-leaks.md
    │   └── ttb-rule-comments.md
    ├── phases/
    │   ├── ttb-phase-feature-research.md
    │   ├── ttb-phase-feature-spec.md
    │   ├── ttb-phase-implementation.md
    │   ├── ttb-phase-code-review.md
    │   └── ttb-phase-verify.md           # MANDATORY post-build verification
    └── refs/
        ├── ttb-ref-ttbaseuikit.md
        ├── ttb-ref-ttbasesui.md
        ├── ttb-ref-config-tokens.md
        ├── ttb-ref-swiftui-architecture.md
        ├── ttb-ref-swiftui-performance.md
        ├── ttb-ref-ios14-compatibility.md
        └── ttb-ref-navigation.md          # Navigation pattern reference
```

## Development Workflow

```
User Request
    ↓
[1] Feature Research (Phase 1)
    Research scope, UI patterns, API → Report
    ↓
[2] Feature Spec (Phase 2)
    Data model, file structure, navigation, API contract → Approved spec
    ↓
[3] Design (Skill-specific)
    Select component patterns → Design decisions
    ↓
[4] Implementation (Phase 4)
    Generate files one-by-one → xcodebuild verify each
    ↓
[5] Code Review (Phase 5)
    FCR 7-Dimension audit → Issues list
    ↓
[6] Verification (Phase 6) ← MANDATORY
    xcodebuild CLI → Compliance check → Regression guard → FCR score
    ↓
✅ BUILD SUCCEEDED + FCR ≥ 85% → COMPLETE
❌ BUILD FAILED / FCR < 85% → Fix and re-verify
```

## Installation

See `Installation/INSTALL.md` for installation instructions.

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 2.0.0 | 2026-05-19 | Full upgrade: 11 Iron Laws, SUIBaseView + TTBaseNavigationLink mandatory, navigation ref added, token warnings, three-tier SwiftUI approach, FCR scoring, progressive loading |
| 1.x | 2026 | Initial release |

## Resources

- [Antigravity SKILL.md](SKILL.md) — Full system documentation
- [Tutorial.md](Tutorial.md) — When to use each skill, prompt examples, practical guide
- [Skill Registry](ttb-skill-registry.md) — All skills index
- [Shared Resources](ttb-skill-shared/SKILL.md) — Phases, rules, refs
- [Installation Guide](Installation/INSTALL.md) — Setup instructions
