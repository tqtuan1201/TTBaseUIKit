---
name: "ttb-skill-registry"
description: "Central registry of all TTBaseUIKit Antigravity skills, workflows, phases, rules, and references. Maps activation commands to capabilities."
version: "2.0.0"
---

# TTBaseUIKit Antigravity Skill Registry

**Version**: 2.0.0 | **Date**: 2026-05-19

Central registry of all skills, workflows, phases, rules, references, scripts, templates, and fragments for TTBaseUIKit Antigravity agent system.

---

## Quick Navigation

| Command | Skill | Purpose |
|---------|-------|---------|
| `/tts-init` | `ttb-skill-init` | New project setup |
| `/tts-uikit` | `ttb-skill-uikit` | UIKit feature development |
| `/tts-swiftui` | `ttb-skill-swiftui` | SwiftUI feature development |
| `/tts-native` | `ttb-skill-native-swiftui-components` | Native SwiftUI components |
| `/tts-bugfix` | `ttb-skill-bugfix` | Bug fixing workflow |
| `/tts-refactor` | `ttb-skill-refactor` | Code migration & refactoring |
| `/tts-audit` | `ttb-skill-audit` | Performance, accessibility, localization |
| `/tts-verify` | `tts-verify` | Research & quality audit |

---

## Skill Sets

### 1. Core Development Skills

| Skill | Path | Load | Purpose |
|-------|------|------|---------|
| `ttb-skill-init` | `ttb-skill-init/` | `always` | New project setup, TTBaseUIKitConfig, localization, MVVM-C folder structure |
| `ttb-skill-uikit` | `ttb-skill-uikit/` | `always` | UIKit feature development: screen, list, form, cell, customview, api, coordinator, viewmodel |
| `ttb-skill-swiftui` | `ttb-skill-swiftui/` | `always` | SwiftUI feature development: TTBaseSUI screens/views, Native SwiftUI, SUI lists, viewmodels |

### 2. Quality & Maintenance Skills

| Skill | Path | Load | Purpose |
|-------|------|------|---------|
| `ttb-skill-bugfix` | `ttb-skill-bugfix/` | `always` | Systematic bug fixing: root cause analysis, 5 Whys, fix strategy, xcodebuild verify |
| `ttb-skill-refactor` | `ttb-skill-refactor/` | `domain` | Migrate to TTViewCodable, replace raw UIKit, TTBaseSUI adoption, MVVM separation |
| `ttb-skill-audit` | `ttb-skill-audit/` | `on-demand` | Performance, accessibility, localization audits with FCR compliance scoring |

### 3. SwiftUI Components Skill

| Skill | Path | Load | Purpose |
|-------|------|------|---------|
| `ttb-skill-native-swiftui-components` | `ttb-skill-native-swiftui-components/` | `domain` | Build native SwiftUI components using TTBaseUIKit design tokens, 100% standard SwiftUI, iOS 14+ |

---

## Phases (Shared)

All feature, bugfix, and refactor workflows use these shared phases:

| Phase | Path | Purpose |
|-------|------|---------|
| `ttb-phase-feature-research` | `ttb-skill-shared/phases/ttb-phase-feature-research.md` | Research feature scope, UI patterns, API |
| `ttb-phase-feature-spec` | `ttb-skill-shared/phases/ttb-phase-feature-spec.md` | Generate spec: data model, file structure, navigation, API contract |
| `ttb-phase-implementation` | `ttb-skill-shared/phases/ttb-phase-implementation.md` | Build feature according to spec with xcodebuild verification |
| `ttb-phase-code-review` | `ttb-skill-shared/phases/ttb-phase-code-review.md` | FCR 7-Dimension audit across all modified files |
| `ttb-phase-verify` | `ttb-skill-shared/phases/ttb-phase-verify.md` | Post-build verification: 5-layer stack, xcodebuild CLI, regression guard |

---

## Rules (Shared)

| Rule | Path | Purpose |
|------|------|---------|
| `ttb-iron-laws` | `ttb-skill-shared/fragments/ttb-iron-laws.frag.md` | 11 mandatory Iron Laws |
| `ttb-rule-coding-standards` | `ttb-skill-shared/rules/ttb-rule-coding-standards.md` | Coding style, naming, SwiftUI conventions, chainable modifiers |
| `ttb-rule-anti-patterns` | `ttb-skill-shared/rules/ttb-rule-anti-patterns.md` | Common pitfalls in SwiftUI and UIKit, Three-Tier SwiftUI Approach |
| `ttb-rule-memory-leaks` | `ttb-skill-shared/rules/ttb-rule-memory-leaks.md` | Prevent retain cycles in closures, delegates, NotificationCenter, timers |
| `ttb-rule-comments` | `ttb-skill-shared/rules/ttb-rule-comments.md` | Code comments and documentation standards |

---

## References (Shared)

| Reference | Path | Purpose |
|-----------|------|---------|
| `ttb-ref-ttbaseuikit` | `ttb-skill-shared/refs/ttb-ref-ttbaseuikit.md` | TTBaseUIKit framework overview, TTViewCodable, MVVM-C |
| `ttb-ref-ttbasesui` | `ttb-skill-shared/refs/ttb-ref-ttbasesui.md` | TTBaseSUI SwiftUI wrapper components |
| `ttb-ref-config-tokens` | `ttb-skill-shared/refs/ttb-ref-config-tokens.md` | TTView/TTSize/TTFont design tokens (CRITICAL: token warnings) |
| `ttb-ref-swiftui-architecture` | `ttb-skill-shared/refs/ttb-ref-swiftui-architecture.md` | Clean Architecture, feature-based modularization, SwiftUI + MVVM + Coordinator |
| `ttb-ref-swiftui-performance` | `ttb-skill-shared/refs/ttb-ref-swiftui-performance.md` | Stable view identity, LazyVStack, Equatable, @Published optimization |
| `ttb-ref-ios14-compatibility` | `ttb-skill-shared/refs/ttb-ref-ios14-compatibility.md` | iOS 14+ API usage guidelines |
| `ttb-ref-navigation` | `ttb-skill-shared/refs/ttb-ref-navigation.md` | Navigation patterns: SUIBaseView, TTBaseNavigationLink, UIKit TTCoordinator |

---

## Scripts (Shared)

| Script | Path | Purpose |
|--------|------|---------|
| `ttb-precheck.sh` | `ttb-skill-shared/scripts/ttb-precheck.sh` | Pre-build check: project state, dependencies, workspace validity |
| `ttb-compliance-check.sh` | `ttb-skill-shared/scripts/ttb-compliance-check.sh` | Compliance check: Iron Laws, TTBaseUIKit patterns, API usage |
| `ttb-verify.sh` | `ttb-skill-shared/scripts/ttb-verify.sh` | Full verification: xcodebuild, file registration, regression |

---

## Fragments (Shared)

| Fragment | Path | Purpose |
|----------|------|---------|
| `ttb-iron-laws` | `ttb-skill-shared/fragments/ttb-iron-laws.frag.md` | Inline the 11 Iron Laws |
| `ttb-marker` | `ttb-skill-shared/fragments/ttb-marker.frag.md` | Code generation marker comments |

---

## Templates (Shared)

| Template | Path | Purpose |
|----------|------|---------|
| `prompt.md.template` | `ttb-skill-shared/templates/prompt.md.template` | Template for new prompt files |
| `SKILL.md.template` | `ttb-skill-shared/templates/SKILL.md.template` | Template for new SKILL files |

---

## Progressive Loading Strategy

To manage agent context window efficiently:

| Level | Name | When Loaded | Contents |
|-------|------|------------|----------|
| `always` | Core | Every session | Root SKILL.md, ttb-iron-laws, ttb-rule-coding-standards, ttb-rule-anti-patterns |
| `domain` | Skill-Specific | When skill activates | Selected skill SKILL.md, phases, relevant refs |
| `on-demand` | Reference | When needed | Deep references, scripts, templates |

### Context Budget
- **Token Budget**: ~8K tokens per task
- **Target**: 11 Iron Laws + critical patterns = ~2K tokens
- **Strategy**: Load references lazily, phases on demand

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 2.0.0 | 2026-05-19 | Full upgrade: frontmatter on all files, version alignment, navigation ref added, token warnings on all critical files, anti-patterns updated, marker fragments updated, three-tier SwiftUI approach documented |
| 1.x | 2026 | Initial release |

---

## Metadata

- **Root Skill**: `Agents/Antigravity/SKILL.md`
- **Shared Resources**: `Agents/Antigravity/ttb-skill-shared/SKILL.md`
- **Registry**: `Agents/Antigravity/ttb-skill-registry.md`
- **Tutorial (EN)**: `Agents/Antigravity/Tutorial.md`
- **Tutorial (VI)**: `Agents/Antigravity/Tutorial-vi.md`
- **Version**: 2.0.0
- **Date**: 2026-05-19
- **Repository**: TTBaseUIKit
- **Architecture**: MVVM-C (TTBaseUIKit + TTBaseSUI)
- **Min iOS**: iOS 14+
