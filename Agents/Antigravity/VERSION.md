# Antigravity TTBaseUIKit Skills — Version History

## v2.3.0 — 2026-05-30

### Cross-Functional Analysis + Question Gate Upgrade

- Added reusable cross-functional analysis gate:
  - `ttb-skill-shared/fragments/ttb-cross-functional-analysis-gate.frag.md`
- Upgraded preflight/workflow/survey resources to require Product Owner, Business Analyst, UX/UI Designer, Solution Architect, Senior Developer, and QA analysis for feature updates, new features, and bug fixes.
- Added option exploration across business value, architecture, UI/UX, performance, scalability, maintainability, security, testing, and operations.
- Added mandatory value-expansion questions: at least 5 questions after analysis to improve flows, interactions, adjacent value, observability, accessibility, and QA coverage.
- Added ambiguity clarification gate: at least 6 blocker questions before design/development when requirements are unclear or incomplete.
- Updated root, shared, UIKit, SwiftUI, native SwiftUI component, bugfix, refactor, audit, and init skill metadata to reference the new gate.

## v2.2.0 — 2026-05-22

### Skills + Workflows Routing Upgrade

- Added semantic routing architecture:
  - `ttb-skill-shared/routing/intent-manifest.json`
  - `ttb-skill-shared/routing/multilingual-aliases.json`
  - `ttb-skill-shared/routing/intent-router.md`
  - `ttb-skill-shared/routing/router-examples.md`
- Added reusable workflow contract:
  - `ttb-skill-shared/workflows/ttb-workflow-standard.md`
- Added metadata validation script:
  - `ttb-skill-shared/scripts/ttb-routing-validate.sh`
- Rewrote `ttb-skill-registry.md` as canonical registry v2.2.0.
- Converted `ttb-skill-shared/ttb-skill-registry.md` into a backward-compatible shim.
- Added routing contracts, input/output schemas, confidence guidance, fallback strategies, anti-patterns, and EN/VI aliases to all core `SKILL.md` files.
- Fixed README quick-start commands from `/tts-*` to canonical `/ttb-*`; legacy `/tts-*` aliases remain supported in the routing manifest.
- Normalized SwiftUI generation examples from deprecated `XView/XSize/XFont` aliases to `TTView/TTSize/TTFont`.

## v2.1.0 — 2026-05-19

### Root SKILL.md & Shared Resources — Full v2.0.0 Alignment

- **SKILL.md (root)**: Upgraded to v2.1.0. Added SUIBaseView + TTBaseNavigationLink as Iron Laws #5-#6. Added critical token warnings section. Added three-tier SwiftUI approach. Fixed `XView` → `TTView` in code example.
- **ttb-skill-shared/SKILL.md**: Upgraded to v2.0.0. Added `ttb-ref-navigation.md` to refs and directory structure. Updated 11 Iron Laws with new navigation mandates.
- **ttb-skill-registry.md**: Upgraded to v2.0.0. Complete rewrite with all skills, phases, rules, refs, scripts indexed with progressive loading levels.
- **ttb-iron-laws.frag.md**: Upgraded to v2.0.0. Complete rewrite with all 11 Iron Laws. Added Iron Law #5 (SUIBaseView Wrapper) and #6 (TTBaseNavigationLink). Added Three-Tier SwiftUI Approach section.
- **ttb-marker.frag.md**: Upgraded to v2.0.0. Added full marker block template with architecture and framework info.

### Rules — Full v2.0.0 Upgrade

- **ttb-rule-coding-standards.md**: Upgraded to v2.0.0. Added explicit token usage tables (XView/XSize/XFont → TTView/TTSize/TTFont). Updated SwiftUI example with SUIBaseView + TTBaseNavigationLink. Added non-existent APIs table.
- **ttb-rule-anti-patterns.md**: Upgraded to v2.0.0. Added Three-Tier SwiftUI Approach table. Added navigation anti-patterns for SUIBaseView and TTBaseNavigationLink. Comprehensive token warnings section.
- **ttb-rule-memory-leaks.md**: Upgraded to v2.0.0. Fixed `XPrint` → `TTBaseFunc.shared.printLog` in all examples and checklists.
- **ttb-rule-comments.md**: Upgraded to v2.0.0. Version bump for consistency.

### Phases — Full v2.0.0 Upgrade

- **ttb-phase-feature-research.md**: Upgraded to v2.0.0. Added navigation ref check and SUIBaseView requirement to validation steps.
- **ttb-phase-feature-spec.md**: Upgraded to v2.0.0. Added SUIBaseView wrapper plan and TTBaseNavigationLink navigation plan to each screen spec.
- **ttb-phase-implementation.md**: Upgraded to v2.0.0. Added SUIBaseView verification, TTBaseNavigationLink usage, XView/XSize/XFont grep checks to verification checklist.
- **ttb-phase-code-review.md**: Upgraded to v2.0.0. Complete rewrite with detailed 7-dimension audit checklist. Added SwiftUI-specific dimension checks. Full output report format.
- **ttb-phase-verify.md**: Upgraded to v2.0.0. Complete rewrite. Added XView/XSize/XFont grep check to Layer 3. Fixed grep pattern for UIView() to exclude TTBaseUI. Full 5-layer verification stack with anti-loop protocol.

### References — New & Upgraded

- **ttb-ref-navigation.md**: NEW — Comprehensive navigation pattern reference. Covers SUIBaseView parameters and backType meanings, TTBaseNavigationLink variants, UIKit TTCoordinator patterns, hybrid app navigation. Includes decision tree for backType selection.
- **ttb-ref-config-tokens.md**: Upgraded to v2.0.0. Added critical token warnings table at top. Added P_CONS_DEF * 4 calculation. Fixed all non-existent token references.
- **ttb-ref-swiftui-architecture.md**: Upgraded to v2.0.0. Updated all code examples to use TTView/TTSize/TTFont tokens. Added SUIBaseView + TTBaseNavigationLink patterns (mandatory). Added TTBaseNavigationLink variants.
- **ttb-ref-swiftui-performance.md**: Upgraded to v2.0.0. Added TTBaseSUIButton performance tip. Minor formatting improvements.
- **ttb-ref-ios14-compatibility.md**: Upgraded to v2.0.0. Version bump for alignment.

### Documentation — Full Upgrade

- **README.md**: Upgraded to v2.0.0. Complete rewrite. Added navigation patterns section with SUIBaseView + TTBaseNavigationLink examples. Updated directory structure. Fixed all token references.
- **VERSION.md**: Added v2.0.0 changelog entry.

---

## v2.0.0 — 2026-05-19

### ttb-skill-swiftui — Complete Rewrite

- **SKILL.md**: Complete rewrite with SUIBaseView as mandatory screen wrapper. Added TTBaseNavigationLink as mandatory navigation component. 3-tier SwiftUI approach (TTBaseSUI → SUIBaseView + NavigationLink → Native SwiftUI fallback).
- **ttb-skill-sui-screen.prompt.md**: Complete rewrite with SUIBaseView + TTBaseNavigationLink patterns. Added SUIBaseView parameters reference. Added all navigation variants (simple, active binding, no animation).
- **ttb-skill-sui-view.prompt.md**: Added new patterns: Action Row, Product/Card Grid Item, Empty State, Badge/Tag.
- **ttb-skill-sui-list.prompt.md**: Added Grid List (TTBaseEqualHeightGridView), Horizontal Banner, Paged Carousel (TTBaseSUITabView), Section Header List patterns.
- **ttb-skill-sui-viewmodel.prompt.md**: Added List ViewModel pattern (with search + filter) and Detail ViewModel pattern.
- **ttb-skill-native-screen.prompt.md**: Updated as strict fallback. Added SUIBaseView wrapper. Added "Document the gap" rule.
- **ttb-skill-native-view.prompt.md**: Updated as strict fallback. Added SUIBaseView wrapper. Added "Document the gap" rule.

### ttb-ref-ttbasesui.md — Complete Rewrite

- Added SUIBaseView navigation wrapper reference with all parameters and backType meanings table.
- Added TTBaseNavigationLink reference with all variants (simple, active binding, no animation).
- Added full TTBaseSUI inventory: TextField (4 types), Toggle (3 types), Slider (3 types), List (3 styles), TabView (3 types), Group, AsyncImage (iOS 15+), EqualHeightGridView.
- Strengthened chainable modifier rules.

### ttb-rule-anti-patterns.md — Major Update

- Added Navigation anti-patterns: SUIBaseView wrapper, TTBaseNavigationLink, backType selection.
- Added Form component anti-patterns: TextField, Toggle, Slider, List, TabView.
- Added full TTBaseSUI vs Native SwiftUI decision matrix with 3 tiers.
- Removed incorrect "SUIBaseView does not exist" from non-existent components list.
- Updated iOS version anti-patterns table.

### ttb-rule-coding-standards.md — Updated

- Added SUIBaseView naming convention.
- Added TTBaseNavigationLink convention.
- Added SwiftUI-specific MARK sections.
- Added chainable modifier order guide.
- Updated SwiftUI View body limit example with SUIBaseView pattern.

### ttb-skill-native-swiftui-components — Updated

- Added 3-tier SwiftUI approach clarification at top.
- Added `/native-*` vs `/ttb-native-screen` comparison table.
- Native SwiftUI now strictly a fallback tier.

### ttb-skill-registry.md — Updated

- Updated ttb-skill-swiftui to v2.0.0.
- Added TTBaseNavigationLink to keywords.
- Added navigation swiftui to keywords.

### Full TTBaseSUI Component Inventory

TTBaseSUI now has 25+ components across 12 categories:
- Text: TTBaseSUIText (5 variants)
- Button: TTBaseSUIButton (6 types)
- Stacks: TTBaseSUIVStack, TTBaseSUIHStack, TTBaseSUIZStack, TTBaseSUIGroup
- Scroll: TTBaseSUIScroll, TTBaseSUILazyVStack, TTBaseSUILazyHStack
- Grid: TTBaseSUILazyVGrid, TTBaseSUILazyHGrid, TTBaseEqualHeightGridView
- Images: TTBaseSUIImage, TTBaseSUICircleImage, TTBaseSUIAsyncImage
- Dividers: TTBaseSUIHorizontalDividerView, TTBaseSUIVerticalDividerView
- Spacer: TTBaseSUISpacer
- Container: TTBaseSUIView
- Form: TTBaseSUITextField (4 types), TTBaseSUIToggle (3 types), TTBaseSUISlider (3 types)
- List: TTBaseSUIList (3 styles)
- Tab: TTBaseSUITabView (3 types)
- Navigation: TTBaseNavigationLink (3 variants)

---

## v1.3.0 — 2026-05-18

### Critical API Corrections

- **`XView`/`XSize`/`XFont` → `TTView`/`TTSize`/`TTFont`** — All skills now use the canonical global variable names. The incorrect `XView`/`XSize`/`XFont` aliases have been replaced throughout all 80+ skill/workflow files.
- **`TTView.colorSuccess/Warning/Error/Info`** — Added as computed aliases on `ViewConfig` pointing to `notificationBgSuccess/Warning/Error` and `buttonBgDef`. Skills no longer reference non-existent color tokens.
- **Invalid token aliases removed** — Tokens like `viewBgSecondaryColor`, `textThirdTitleColor`, `iconPrimaryColor`, `buttonBgHighlight`, `buttonBgDisable`, `buttonTextDef`, `buttonTextWarring`, `separatorColor` were added as computed aliases on `ViewConfig` to match what skills referenced.
- **`TTSize.P_XXL`** — Added to `SizeConfig` (32pt = P_CONS_DEF * 4) so skills referencing it compile correctly.
- **`TTSize.ICON_SIZE_SMALL/DEFAULT/LARGE`** — Added to `SizeConfig` as aliases to `H_SMALL_SMALL_ICON`, `H_SMALL_ICON`, `H_ICON` respectively.
- **`TTFont.SIZE_SUPER_HEADER/SIZE_HEADER/SIZE_TITLE/SIZE_CONTENT/SIZE_SUBTITLE/SIZE_NOTE/HEADER_H_H/CONTENT_H_H`** — Added as computed aliases on `FontConfig` to match design system naming used in skills.
- **`TTSize.H_BORDER`** — Corrected: `H_BORDER` (2pt) EXISTS in `SizeConfig`. `H_LINEVIEW` (1.5pt) also exists. Both are valid. Previous claim that `H_BORDER` does not exist was incorrect.

### Bug Fixes

- **`SizeConfig.swift`** — Fixed typo: `P_CONS_TOP_H` assigned twice, ignoring `botom` parameter
- **`View+LiquidGlass+Extension.swift`** — Fixed `#if compiler(>=6.2)` → `#if swift(>=6.2)` (Swift version, not iOS version)
- **`BlackLiquidGlassBackground`** — Already had `@available(iOS 15.0, *)` — no fix needed

### Consistency Fixes

- **Iron Laws deduplication** — Removed duplicate laws from 5 SKILL.md files; now references `ttb-iron-laws.frag.md` as single source of truth
- **`prepareForReuse()`** — Added to cell and list prompt templates with `super` call and property reset
- **`deinit` RCA checklist** — Added to bugfix checklist; rewrote entire file to fix broken markdown tables
- **BaseShadowView naming** — Clarified that both `BaseShadowView` and `BaseShadowPanelView` exist; updated prompts to use canonical `BaseShadowPanelView`
- **AwesomePro dependency** — Documented in cell and customview prompts with SF Symbols fallback
- **Token reference tables corrected** — All token values (colors, sizes, fonts) now match actual `TTBaseUIKit` source values exactly

### Bug Fixes

- **`SizeConfig.swift`** — Fixed typo: `P_CONS_TOP_H` assigned twice, ignoring `botom` parameter
- **`View+LiquidGlass+Extension.swift`** — Fixed `#if compiler(>=6.2)` → `#if swift(>=6.2)` (Swift version, not iOS version)
- **`BlackLiquidGlassBackground`** — Already had `@available(iOS 15.0, *)` — no fix needed

### Consistency Fixes

- **Iron Laws deduplication** — Removed duplicate laws from 5 SKILL.md files; now references `ttb-iron-laws.frag.md` as single source of truth
- **`prepareForReuse()`** — Added to cell and list prompt templates with `super` call and property reset
- **`deinit` RCA checklist** — Added to bugfix checklist; rewrote entire file to fix broken markdown tables
- **`TTSize.H_BORDER`** — Replaced with `TTSize.H_LINEVIEW` in native button prompt (H_BORDER does not exist)
- **BaseShadowView naming** — Clarified that both `BaseShadowView` and `BaseShadowPanelView` exist; updated prompts to use canonical `BaseShadowPanelView`
- **AwesomePro dependency** — Documented in cell and customview prompts with SF Symbols fallback

### New Features

- **`ttb-ref-swiftui-extensions.md`** — New 400+ line reference cataloging all 9 SwiftUI extension files, 20+ methods, TTBaseUIKit API dependencies, and iOS 14 compatibility notes
- **`ttb-compliance-check.sh`** — Added grep-based localization compliance check (hardcoded strings warning)
- **Quality Gate Checklists** — Added to native SwiftUI components SKILL.md
- **Common Rationalizations tables** — Added to bugfix and refactor prompts
- **Canonical FCR formula** — Defined in `ttb-skill-registry.md` and `ttb-phase-verify.md`
- **`shared` vs `getConfig()` pattern** — Documented in `ttb-ref-config-tokens.md`

### GitHub Best Practices

- **Frontmatter fields** — Added `version`, `date_updated`, `risk: "safe"`, `source`, `tags` to all 7 core skill SKILL.md files
- **All skills bumped to v1.2.0**

### Deprecations

- **`setBorder(WithRadius:color:lineWidth:)`** — Deprecated in `View+Style.swift`. Use `baseBorder(color:width:radius:)` instead. Note: default values differ between the two methods.

---

## v1.1.1 — 2026-05-15

### Refactoring (Token Optimization)

- **NEW: Shell scripts** (`ttb-skill-shared/scripts/`)
  - `ttb-verify.sh` — Post-build verification (5-Layer stack, Anti-Loop protocol)
  - `ttb-compliance-check.sh` — grep-based compliance checks (iOS 14+, TTBaseUIKit, MVVM, closure safety)
  - **Impact**: Eliminates ~150-200 lines of inline verification code per prompt file

- **NEW: Fragment files** (`ttb-skill-shared/fragments/`)
  - `ttb-iron-laws.frag.md` — 10 Iron Laws as reusable fragment (~240 tokens)
  - `ttb-marker.frag.md` — Code generation marker as reusable fragment (~40 tokens)
  - **Impact**: Single source of truth, no more copy-paste duplication

- **NEW: Templates** (`ttb-skill-shared/templates/`)
  - `SKILL.md.template` — Template for new skill SKILL.md files
  - `prompt.md.template` — Template for new prompt files
  - `README.md` — Template guidelines and naming conventions

- **NEW: Skill Registry** (`ttb-skill-shared/ttb-skill-registry.md`)
  - Complete YAML-based registry of all skills with `loadLevel`, dependencies, keywords
  - Dependency graph, token budget summary, progressive loading strategy

- **UPDATED: Progressive loading metadata**
  - All SKILL.md files now have `loadLevel: always|domain|on-demand`
  - Reduces context bloat by loading only needed skills

- **DEDUPLICATED: 20+ prompt files**
  - All inline verification blocks replaced with script references
  - All `Step 4 — Output Verification Report` replaced with script calls
  - All unicode dashes/em-dashes normalized to ASCII

- **UPDATED: Export script** (`export.sh`)
  - Now includes `ttb-skill-native-swiftui-components`
  - Documents new directories: `scripts/`, `fragments/`, `templates/`, registry

- **UPDATED: Root README/SKILL.md**
  - Shared resources table referencing new scripts and fragments

### Token Savings Estimate

| Before | After | Savings |
|--------|-------|---------|
| ~12,000-15,000 tokens/session | ~5,000-7,000 tokens/session | ~50-55% |

---

## v1.1.0 — 2026-05-13

### What's New

- **Phase 6 — Post-Build Verification** (`ttb-skill-shared/phases/ttb-phase-verify.md`)
  - Mandatory verification after every skill workflow
  - 5-Layer Verification Stack: Xcode Project Integrity → xcodebuild → Rules Compliance → Regression Guard → FCR 7-Dimension Score
  - Anti-Loop protocol (max 3 build attempts)

- **11th Iron Law** — "POST-BUILD VERIFICATION IS MANDATORY"
  - Every skill workflow output MUST end with `BUILD SUCCEEDED`
  - xcodebuild CLI verification required after every skill

### Skill Sets (7)

| Skill | Description | Prompt Files |
|-------|-------------|-------------|
| `ttb-skill-init/` | Project initialization | 5 |
| `ttb-skill-uikit/` | UIKit: screen, list, form, cell, customview, api, coordinator, viewmodel | 8 |
| `ttb-skill-swiftui/` | SwiftUI: TTBaseSUI + native screens, views, viewmodels | 6 |
| `ttb-skill-native-swiftui-components/` | 20 native SwiftUI components | 20 |
| `ttb-skill-bugfix/` | Systematic bug fixing workflow | 1 |
| `ttb-skill-refactor/` | Clean architecture refactoring | 1 |
| `ttb-skill-audit/` | Performance, accessibility, localization audits | 3 |

### Root Documentation

- `SKILL.md` — Root skill entry point (11 Iron Laws)
- `README.md` — Overview and quick reference
- `README-VI.md` — Vietnamese version
- `VERSION.md` — This file
- `AUDIT-REPORT.md` — Comprehensive audit report
- `export.sh` — Export script
- `SKILL.md` files across all skill sets updated to v1.1.0
