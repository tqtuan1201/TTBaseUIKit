# Antigravity Skill Registry

> Single source of truth for all TTBaseUIKit skill metadata.
> Used by AI agents to dynamically load only the skills needed for a given task.
> Version: 1.1.0 | Updated: 2026-05-15

---

## How to Use

When a user activates a skill (e.g., `/ttb-init`, `/ttb-uikit`), the AI agent reads this registry
to determine:

1. Which skill file to load
2. What `loadLevel` applies (always / domain / on-demand)
3. What shared resources are required
4. What dependencies/predecessors must be loaded first
5. What commands/triggers activate the skill

**Progressive Loading Strategy:**

| loadLevel | When to Load | Example |
|-----------|-------------|---------|
| `always` | Load on every session start | Root SKILL.md, shared rules |
| `domain` | Load when domain is detected | UIKit, SwiftUI, Bugfix skills |
| `on-demand` | Load only when explicitly triggered | Audit, Refactor, Native Components |

---

## Skill Index

### Core Skills

| Command | Skill | Load | Description |
|---------|-------|------|-------------|
| `/ttb-init` | `ttb-skill-init` | `always` | Project initialization, MVVM-C scaffold, TTBaseUIKitConfig |
| `/ttb-uikit` | `ttb-skill-uikit` | `domain` | UIKit full-stack: screen, list, form, cell, customview, api, coordinator, viewmodel |
| `/ttb-swiftui` | `ttb-skill-swiftui` | `domain` | SwiftUI full-stack: TTBaseSUI screens/views and Native SwiftUI screens/views |
| `/ttb-native-components` | `ttb-skill-native-swiftui-components` | `on-demand` | 20 native SwiftUI UI components with TTBaseUIKit design tokens |
| `/ttb-refactor` | `ttb-skill-refactor` | `on-demand` | Migrate to TTViewCodable, replace raw UIKit with TTBaseUIKit |
| `/ttb-bugfix` | `ttb-skill-bugfix` | `domain` | Systematic bug fixing: root cause analysis, fix strategy, xcodebuild verify |
| `/ttb-audit` | `ttb-skill-audit` | `on-demand` | Code audits: performance, accessibility, localization, FCR scoring |

### Shared Resources

| Command | Resource | Load | Description |
|---------|----------|------|-------------|
| — | `ttb-skill-shared` | `always` | Shared resources: rules, phases, references |
| — | `ttb-iron-laws` | `always` | Fragment: 10 mandatory Iron Laws |
| — | `ttb-marker` | `always` | Fragment: Code generation marker |
| — | `ttb-verify` | `on-demand` | Shell script: post-build verification |
| — | `ttb-compliance` | `on-demand` | Shell script: grep-based compliance check |

---

## Skill Details

### ttb-skill-init

```yaml
name: ttb-skill-init
loadLevel: always
version: 1.1.0
command: /ttb-init
alias:
  - /ttb-init-project
  - /ttb-new-project
priority: 1
mustLoadBefore:
  - ttb-skill-uikit
  - ttb-skill-swiftui
  - ttb-skill-bugfix
  - ttb-skill-refactor
prompts:
  - prompts/ttb-skill-init.prompt.md
  - prompts/ttb-skill-init-debug.prompt.md
  - prompts/ttb-skill-init-localization.prompt.md
  - prompts/ttb-skill-init-structure.prompt.md
  - prompts/ttb-skill-init-ttbaseui-kit.prompt.md
sharedResources:
  - fragments/ttb-iron-laws.frag.md
  - fragments/ttb-marker.frag.md
  - rules/ttb-rule-coding-standards.md
  - rules/ttb-rule-anti-patterns.md
  - rules/ttb-rule-memory-leaks.md
  - refs/ttb-ref-ttbaseuikit.md
  - refs/ttb-ref-config-tokens.md
  - refs/ttb-ref-ios14-compatibility.md
```

### ttb-skill-uikit

```yaml
name: ttb-skill-uikit
loadLevel: domain
version: 1.1.0
command: /ttb-uikit
alias:
  - /ttb-uikit-screen
  - /ttb-uikit-list
  - /ttb-uikit-form
  - /ttb-uikit-cell
  - /ttb-uikit-customview
  - /ttb-uikit-api
  - /ttb-uikit-coordinator
  - /ttb-uikit-viewmodel
priority: 2
mustLoadBefore: []
requires:
  - ttb-skill-init
prompts:
  - ttb-skill-screen.prompt.md
  - ttb-skill-list.prompt.md
  - ttb-skill-form.prompt.md
  - ttb-skill-cell.prompt.md
  - ttb-skill-customview.prompt.md
  - ttb-skill-api.prompt.md
  - ttb-skill-coordinator.prompt.md
  - ttb-skill-viewmodel.prompt.md
sharedResources:
  - fragments/ttb-iron-laws.frag.md
  - fragments/ttb-marker.frag.md
  - rules/ttb-rule-coding-standards.md
  - rules/ttb-rule-anti-patterns.md
  - rules/ttb-rule-memory-leaks.md
  - phases/ttb-phase-implementation.md
  - phases/ttb-phase-verify.md
keywords:
  - screen
  - view controller
  - list
  - table
  - form
  - cell
  - api
  - coordinator
  - viewmodel
  - MVVM
  - UIKit
  - tạo màn hình
```

### ttb-skill-swiftui

```yaml
name: ttb-skill-swiftui
loadLevel: domain
version: 2.0.0
command: /ttb-swiftui
alias:
  - /ttb-sui-screen
  - /ttb-sui-view
  - /ttb-sui-list
  - /ttb-sui-viewmodel
  - /ttb-native-view
  - /ttb-native-screen
priority: 2
mustLoadBefore: []
requires:
  - ttb-skill-init
prompts:
  - ttb-skill-sui-screen.prompt.md
  - ttb-skill-sui-view.prompt.md
  - ttb-skill-sui-list.prompt.md
  - ttb-skill-sui-viewmodel.prompt.md
  - ttb-skill-native-screen.prompt.md
  - ttb-skill-native-view.prompt.md
sharedResources:
  - fragments/ttb-iron-laws.frag.md
  - fragments/ttb-marker.frag.md
  - rules/ttb-rule-coding-standards.md
  - rules/ttb-rule-anti-patterns.md
  - refs/ttb-ref-ttbasesui.md
  - refs/ttb-ref-config-tokens.md
  - refs/ttb-ref-ios14-compatibility.md
keywords:
  - SwiftUI
  - TTBaseSUI
  - SUIBaseView
  - TTBaseNavigationLink
  - screen
  - view
  - list
  - viewmodel
  - tạo màn hình SwiftUI
  - navigation swiftui
```

### ttb-skill-native-swiftui-components

```yaml
name: ttb-skill-native-swiftui-components
loadLevel: on-demand
version: 1.1.0
command: /ttb-native-components
alias:
  - /ttb-native-button
  - /ttb-native-card
  - /ttb-native-alert
  - /ttb-native-input
  - /ttb-native-avatar
  - /ttb-native-chip
  - /ttb-native-selector
  - /ttb-native-snackbar
  - /ttb-native-loading
  - /ttb-native-progress
  - /ttb-native-rating
  - /ttb-native-divider
  - /ttb-native-text
  - /ttb-native-icon
  - /ttb-native-tab-bar
  - /ttb-native-bottom-sheet
  - /ttb-native-list-row
  - /ttb-native-section-header
  - /ttb-native-display
  - /ttb-native-empty-state
priority: 3
mustLoadBefore: []
requires:
  - ttb-skill-init
prompts:
  - ttb-skill-native-button.prompt.md
  - ttb-skill-native-alert.prompt.md
  - ttb-skill-native-card.prompt.md
  - ttb-skill-native-chip.prompt.md
  - ttb-skill-native-selector.prompt.md
  - ttb-skill-native-snackbar.prompt.md
  - ttb-skill-native-loading.prompt.md
  - ttb-skill-native-progress.prompt.md
  - ttb-skill-native-rating.prompt.md
  - ttb-skill-native-divider.prompt.md
  - ttb-skill-native-text.prompt.md
  - ttb-skill-native-icon.prompt.md
  - ttb-skill-native-tab-bar.prompt.md
  - ttb-skill-native-bottom-sheet.prompt.md
  - ttb-skill-native-list-row.prompt.md
  - ttb-skill-native-section-header.prompt.md
  - ttb-skill-native-display.prompt.md
  - ttb-skill-native-empty-state.prompt.md
  - ttb-skill-native-avatar.prompt.md
  - ttb-skill-native-input.prompt.md
sharedResources:
  - fragments/ttb-iron-laws.frag.md
  - fragments/ttb-marker.frag.md
  - refs/ttb-ref-config-tokens.md
  - phases/ttb-phase-verify.md
keywords:
  - button
  - card
  - alert
  - input
  - avatar
  - chip
  - selector
  - snackbar
  - loading
  - spinner
  - progress
  - rating
  - divider
  - text
  - icon
  - tab bar
  - bottom sheet
  - list row
  - section header
  - display
  - empty state
  - native SwiftUI component
  - component SwiftUI
```

### ttb-skill-bugfix

```yaml
name: ttb-skill-bugfix
loadLevel: domain
version: 1.1.0
command: /ttb-bugfix
alias:
  - /ttb-fix
  - /ttb-debug
priority: 2
mustLoadBefore: []
requires:
  - ttb-skill-init
prompts:
  - ttb-skill-bugfix.prompt.md
sharedResources:
  - fragments/ttb-iron-laws.frag.md
  - rules/ttb-rule-coding-standards.md
  - rules/ttb-rule-memory-leaks.md
  - phases/ttb-phase-verify.md
keywords:
  - bug
  - fix
  - crash
  - error
  - debug
  - sửa lỗi
  - fix bug
```

### ttb-skill-refactor

```yaml
name: ttb-skill-refactor
loadLevel: on-demand
version: 1.1.0
command: /ttb-refactor
alias:
  - /ttb-migrate
  - /ttb-clean
priority: 3
mustLoadBefore: []
requires:
  - ttb-skill-init
prompts:
  - ttb-skill-refactor.prompt.md
sharedResources:
  - fragments/ttb-iron-laws.frag.md
  - rules/ttb-rule-coding-standards.md
  - rules/ttb-rule-anti-patterns.md
  - phases/ttb-phase-verify.md
keywords:
  - refactor
  - migrate
  - TTViewCodable
  - TTBaseUIKit
  - clean code
  - restructure
```

### ttb-skill-audit

```yaml
name: ttb-skill-audit
loadLevel: on-demand
version: 1.1.0
command: /ttb-audit
alias:
  - /ttb-audit-performance
  - /ttb-audit-accessibility
  - /ttb-audit-localization
priority: 3
mustLoadBefore: []
requires:
  - ttb-skill-init
prompts:
  - ttb-skill-audit-performance.prompt.md
  - ttb-skill-audit-accessibility.prompt.md
  - ttb-skill-audit-localization.prompt.md
sharedResources:
  - fragments/ttb-iron-laws.frag.md
  - rules/ttb-rule-coding-standards.md
keywords:
  - audit
  - performance
  - accessibility
  - a11y
  - localization
  - i18n
  - kiểm tra
  - review
```

---

## Shared Resources Index

| Resource | Path | Tokens | Load | Description |
|----------|------|--------|------|-------------|
| Iron Laws | `ttb-skill-shared/fragments/ttb-iron-laws.frag.md` | ~240 | `always` | 10 mandatory laws for all skills |
| Marker | `ttb-skill-shared/fragments/ttb-marker.frag.md` | ~40 | `always` | Code generation file header |
| Verify Script | `ttb-skill-shared/scripts/ttb-verify.sh` | — | `on-demand` | Post-build verification |
| Compliance Script | `ttb-skill-shared/scripts/ttb-compliance-check.sh` | — | `on-demand` | grep-based compliance |
| Coding Standards | `ttb-skill-shared/rules/ttb-rule-coding-standards.md` | ~300 | `domain` | File headers, MARK sections |
| Anti-Patterns | `ttb-skill-shared/rules/ttb-rule-anti-patterns.md` | ~500 | `domain` | Component & pattern anti-patterns |
| Memory Leaks | `ttb-skill-shared/rules/ttb-rule-memory-leaks.md` | ~400 | `domain` | Retain cycle detection |
| Implementation Phase | `ttb-skill-shared/phases/ttb-phase-implementation.md` | ~600 | `domain` | Feature implementation phase |
| Verify Phase | `ttb-skill-shared/phases/ttb-phase-verify.md` | ~800 | `on-demand` | 5-Layer verification |
| Feature Spec Phase | `ttb-skill-shared/phases/ttb-phase-feature-spec.md` | ~400 | `on-demand` | Feature spec template |
| Feature Research Phase | `ttb-skill-shared/phases/ttb-phase-feature-research.md` | ~300 | `on-demand` | Research phase |
| Code Review Phase | `ttb-skill-shared/phases/ttb-phase-code-review.md` | ~200 | `on-demand` | Review phase |
| TTBaseUIKit Ref | `ttb-skill-shared/refs/ttb-ref-ttbaseuikit.md` | ~200 | `domain` | TTBaseUIKit API reference |
| Config Tokens Ref | `ttb-skill-shared/refs/ttb-ref-config-tokens.md` | ~150 | `always` | TTView, TTSize, TTFont tokens |
| iOS 14+ Ref | `ttb-skill-shared/refs/ttb-ref-ios14-compatibility.md` | ~100 | `always` | iOS version compatibility |
| TTBaseSUI Ref | `ttb-skill-shared/refs/ttb-ref-ttbasesui.md` | ~150 | `domain` | TTBaseSUI API reference |

---

## Dependency Graph

```
(ttb-skill-shared)
         |
         +-- ttb-iron-laws.frag.md (always)
         +-- ttb-marker.frag.md (always)
         +-- rules/ (domain)
         +-- phases/ (domain)
         +-- refs/ (domain)
         +-- scripts/ (on-demand)
         +-- templates/ (on-demand)
         |
(ttb-skill-init) -----> must load before ALL others
         |
         +-- ttb-skill-uikit (domain)
         |         +-- screen, list, form, cell, customview, api, coordinator, viewmodel
         |
         +-- ttb-skill-swiftui (domain)
         |         +-- TTBaseSUI screens/views + Native SwiftUI
         |
         +-- ttb-skill-native-swiftui-components (on-demand)
         |         +-- 20 native component prompts
         |
         +-- ttb-skill-bugfix (domain)
         |
         +-- ttb-skill-refactor (on-demand)
         |
         +-- ttb-skill-audit (on-demand)
                   +-- performance, accessibility, localization
```

---

## Token Budget Summary

| Category | Estimated Tokens/Session |
|----------|------------------------|
| Root + Shared SKILL.md | ~1,500 |
| Iron Laws fragment | ~240 |
| Marker fragment | ~40 |
| Domain skill (UIKit/SwiftUI) | ~3,000 |
| On-demand prompts | ~500-2,000 each |
| Verify script (zero tokens, runtime) | 0 |
| **Total per session** | **~5,000-7,000** |
| **Before optimization** | **~12,000-15,000** |
| **Savings** | **~50-55%** |

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 2.0.0 | 2026-05-19 | ttb-skill-swiftui: Complete rewrite with SUIBaseView navigation, TTBaseNavigationLink, full TTBaseSUI inventory (TextField, Toggle, Slider, List, TabView, Group, AsyncImage, EqualHeightGrid). ttb-skill-native-swiftui-components: Added 3-tier SwiftUI approach clarification. ttb-ref-ttbasesui: Full rewrite with navigation patterns. ttb-rule-anti-patterns: Added SUIBaseView + TTBaseNavigationLink anti-patterns, form component patterns. ttb-rule-coding-standards: Added SwiftUI conventions. |
| 1.1.0 | 2026-05-15 | Added loadLevel metadata, progressive loading, scripts, fragments |
| 1.0.0 | 2026-05-14 | Initial registry |
