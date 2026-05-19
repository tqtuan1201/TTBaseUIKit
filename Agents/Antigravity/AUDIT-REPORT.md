# Antigravity Skills v1.2.0 — Audit Report

> **Date**: 2026-05-18 | **Auditors**: Claude Code (multi-agent audit)
> **Scope**: TTBaseUIKit Antigravity skill system v1.1.0 → v1.2.0 upgrade
> **Result**: All Phase 0-5 items completed. Phase 6 = this document.

---

## Summary of Changes by Phase

| Phase | Item | Status | Files Changed |
|-------|------|--------|--------------|
| 0 | SizeConfig typo fix | ✅ Done | `SizeConfig.swift` |
| 0 | `#if compiler(>=6.2)` → `#if swift(>=6.2)` | ✅ Done | `View+LiquidGlass+Extension.swift` |
| 0 | `BlackLiquidGlassBackground` availability | ✅ Already had `@available` | — |
| 1 | Iron Laws deduplication (5 SKILL.md files) | ✅ Done | Root, shared, init, uikit, swiftui SKILL.md |
| 1 | `prepareForReuse()` added to cell/list prompts | ✅ Done | `ttb-skill-cell.prompt.md`, `ttb-skill-list.prompt.md` |
| 1 | `deinit` RCA checklist added | ✅ Done | `ttb-skill-bugfix.prompt.md` |
| 1 | Localization check added to compliance script | ✅ Done | `ttb-compliance-check.sh` |
| 1 | `H_LINEVIEW` documented as border thickness (2pt) | ✅ Done | `ttb-skill-native-button.prompt.md` |
| 1 | BaseShadowView naming clarified | ✅ Done | `ttb-skill-customview.prompt.md`, `ttb-rule-anti-patterns.md` |
| 1 | AwesomePro dependency documented | ✅ Done | `ttb-skill-cell.prompt.md`, `ttb-skill-customview.prompt.md` |
| 2 | `setBorder` deprecated, `baseBorder` kept | ✅ Done | `View+Style.swift`, `NewSupportSUIView.swift` |
| 2 | `shared` vs `getConfig()` documented | ✅ Done | `ttb-ref-config-tokens.md` |
| 2 | LiquidGlass Swift version check fixed | ✅ Done | (see Phase 0) |
| 2 | `ttb-ref-swiftui-extensions.md` created | ✅ Done | New file in `refs/` |
| 3 | Init skill bumped to v1.1.0 | ✅ Done | `ttb-skill-init/SKILL.md` |
| 3 | Ruby script path marked optional | ✅ Done | 3 files |
| 4 | FCR canonical formula defined | ✅ Done | `ttb-skill-registry.md`, `ttb-phase-verify.md` |
| 5 | `version`/`risk`/`tags` added to all 7 skills | ✅ Done | All 7 SKILL.md files |
| 5 | Rationalizations tables added | ✅ Done | `ttb-skill-bugfix.prompt.md`, `ttb-skill-refactor.prompt.md` |
| 5 | Quality Gate Checklists added | ✅ Done | `ttb-skill-native-swiftui-components/SKILL.md` |

---

## Known Issues Not Fixed

These issues were identified during audit but deferred due to scope:

### 1. `navBaseStype` override — not documented

**File**: `ttb-skill-list.prompt.md`
**Issue**: The list ViewController template uses `override var navBaseStype: BaseUINavigationView.TYPE { return .DEFAULT }` but this property and its usage are never documented in the TTBaseUIKit API reference or the anti-patterns rules.
**Impact**: Low — the pattern works but agents won't understand it.
**Recommended fix**: Document in `ttb-ref-ttbaseuikit.md`.

### 2. `AwesomePro` font icon — no SF Symbols fallback in anti-patterns

**File**: `ttb-rule-anti-patterns.md`
**Issue**: The anti-patterns rule lists component replacements but never mentions the AwesomePro font icon alternative (SF Symbols).
**Impact**: Medium — agents may not know to offer SF Symbols as an alternative.
**Recommended fix**: Add a "Font Icon Alternatives" section to `ttb-rule-anti-patterns.md`.

### 3. `newPanelView` property — inconsistent access pattern

**File**: `ttb-skill-customview.prompt.md`
**Issue**: `BaseShadowPanelView.newPanelView` is accessed via `self.newPanelView` in the template code but `BaseShadowView` is referenced by name. After consolidation to `BaseShadowPanelView`, the access pattern is now consistent, but `newPanelView` is not documented in `ttb-ref-ttbaseuikit.md`.
**Impact**: Low — pattern is now consistent in prompts.
**Recommended fix**: Document `newPanelView` property in `ttb-ref-ttbaseuikit.md`.

### 4. `ttb-phase-feature-research.md` — not verified

**File**: `ttb-skill-shared/phases/ttb-phase-feature-research.md`
**Issue**: The phase file was not read during this audit. Potential inconsistencies with other phases are unknown.
**Recommended fix**: Audit this file against `ttb-phase-implementation.md`, `ttb-phase-code-review.md`, and `ttb-phase-verify.md`.

### 5. `awesome-cursorrules` reference not integrated

**Finding**: GitHub research identified `awesome-cursorrules` as the top repository for .cursorrules patterns. The Antigravity skills don't currently provide a `.cursorrules` file for Cursor IDE enforcement.
**Recommended fix**: Create `.cursorrules` at the workspace root enforcing the Iron Laws, anti-patterns, and FCR scoring thresholds.

### 6. Ruby script still referenced (but marked optional)

**Files**: 3 locations in skill system
**Issue**: The ruby script `add_to_xcode_project.rb` at `.agent/skills/ttbase-swiftui/scripts/` is still referenced (now marked as optional) but does not exist in the codebase.
**Recommended fix**: Either create the script or remove all references entirely.

---

## Skill Version Reference

| Skill | v1.1.0 | v1.2.0 |
|-------|---------|---------|
| `ttb-skill-init` | 1.1.0 | **1.2.0** |
| `ttb-skill-shared` | 1.1.0 | 1.1.0 |
| `ttb-skill-uikit` | 1.1.0 | **1.2.0** |
| `ttb-skill-swiftui` | 1.1.0 | **1.2.0** |
| `ttb-skill-native-swiftui-components` | 1.1.0 | **1.2.0** |
| `ttb-skill-bugfix` | 1.1.0 | **1.2.0** |
| `ttb-skill-refactor` | 1.1.0 | **1.2.0** |
| `ttb-skill-audit` | 1.1.0 | **1.2.0** |

| Shared Resource | Version |
|----------------|---------|
| `ttb-iron-laws.frag.md` | 1.0.0 |
| `ttb-marker.frag.md` | 1.0.0 |
| `ttb-phase-verify.md` | 1.1.0 |
| `ttb-phase-code-review.md` | 1.0.0 |
| `ttb-phase-implementation.md` | 1.0.0 |
| `ttb-phase-feature-research.md` | Not audited |
| `ttb-phase-feature-spec.md` | Not audited |
| `ttb-rule-anti-patterns.md` | 1.0.0 |
| `ttb-rule-coding-standards.md` | 1.0.0 |
| `ttb-rule-memory-leaks.md` | 1.0.0 |
| `ttb-ref-ttbaseuikit.md` | 1.0.0 |
| `ttb-ref-ttbasesui.md` | 1.0.0 |
| `ttb-ref-config-tokens.md` | 1.0.0 |
| `ttb-ref-ios14-compatibility.md` | 1.0.0 |
| `ttb-ref-swiftui-extensions.md` | **NEW 1.0.0** |
| `ttb-skill-registry.md` | **1.2.0** |
| `ttb-compliance-check.sh` | Modified |
| `ttb-verify.sh` | Not modified |

---

## FCR 7-Dimension Scoring — Canonical Reference

```
FCR Score = (dim1 × 0.15 + dim2 × 0.20 + dim3 × 0.15 + dim4 × 0.15
           + dim5 × 0.15 + dim6 × 0.10 + dim7 × 0.10) × 10
```

| # | Dimension | Weight | Must Pass |
|---|-----------|--------|-----------|
| 1 | iOS 14+ API | 15% | No iOS 15+/16+/17+ APIs |
| 2 | TTBaseUIKit Compliance | 20% | All components, no raw UIKit |
| 3 | Config Tokens | 15% | TTView/TTSize/TTFont everywhere |
| 4 | MVVM Separation | 15% | ViewModel pure, VC thin |
| 5 | Closure Safety | 15% | [weak self] everywhere |
| 6 | Localization | 10% | XText/XTextU with keys |
| 7 | Code Quality | 10% | MARK, naming, style |

**Thresholds**: ≥ 85 = READY | 70–84 = NEEDS FIX | < 70 = BLOCKED

---

## Skill Dependency Graph

```
(ttb-skill-init) ← always loaded
(ttb-skill-shared) ← always loaded
 │
 ├── ttb-iron-laws.frag.md (always)
 ├── ttb-marker.frag.md (always)
 ├── ttb-rule-anti-patterns.md (domain)
 ├── ttb-rule-coding-standards.md (domain)
 ├── ttb-rule-memory-leaks.md (domain)
 ├── ttb-ref-ttbaseuikit.md (domain)
 ├── ttb-ref-ttbasesui.md (domain)
 ├── ttb-ref-config-tokens.md (domain)
 ├── ttb-ref-ios14-compatibility.md (domain)
 ├── ttb-ref-swiftui-extensions.md (on-demand) ← NEW
 ├── ttb-phase-feature-research.md (domain)
 ├── ttb-phase-feature-spec.md (domain)
 ├── ttb-phase-implementation.md (domain)
 ├── ttb-phase-code-review.md (domain)
 ├── ttb-phase-verify.md (domain)
 ├── ttb-verify.sh (on-demand)
 └── ttb-compliance-check.sh (on-demand)

(ttb-skill-uikit) ← domain
(ttb-skill-swiftui) ← domain
(ttb-skill-native-swiftui-components) ← on-demand
(ttb-skill-bugfix) ← domain
(ttb-skill-refactor) ← on-demand
(ttb-skill-audit) ← on-demand
```

---

## Design Tokens Quick Reference

### Accessors

| Alias | Maps To |
|-------|---------|
| `TTView` | `TTBaseUIKitConfig.getViewConfig()` |
| `TTSize` | `TTBaseUIKitConfig.getSizeConfig()` |
| `TTFont` | `TTBaseUIKitConfig.getFontConfig()` |

**Rule**: Use `TTView`/`TTSize`/`TTFont` in generated code. Use `TTBaseUIKitConfig.shared` in init-time code only.

### Key Size Tokens

| Token | Value | Usage |
|-------|-------|-------|
| `TTSize.P_CONS_DEF` | 8pt | Default padding |
| `TTSize.P_L` | 16pt | Large spacing |
| `TTSize.H_LINEVIEW` | 1.5pt | Divider/border thickness |
| `TTSize.CORNER_RADIUS` | 4pt | Default corner radius |
| `TTSize.H_BUTTON` | 40pt | Button height |
| `TTSize.CORNER_BUTTON` | 4pt | Button corner |

| `TTSize.H_BORDER` = 2pt and `TTSize.H_LINEVIEW` = 1.5pt — both valid |

---

## Extension Files Reference

New reference document: `ttb-skill-shared/refs/ttb-ref-swiftui-extensions.md`

| File | Methods | iOS 14 |
|-------|---------|--------|
| `View+Style.swift` | `baseBorder`, `setBorder` (deprecated) | ✅ |
| `View+LiquidGlass+Extension.swift` | `enableGlassEffect`, `enableGlassEffectV2`, `WhiteLiquidGlassBackground`, `BlackLiquidGlassBackground` | ⚠️ `BlackLiquidGlassBackground` = iOS 15+ |
| `View+Config+Extension.swift` | `bgByView`, `bgByDef`, `textByDef`, `cardBg` | ✅ |
| `HostingController+Configs+Extension.swift` | 2 initializers | ✅ |
| `View+Spacing.swift` | `pAll`, `pTop`, `pBottom`, `pLeft`, `pRight`, `pVertical` | ✅ |
| `View+Swipe.swift` | `swipeLeading`, `swipeTrailing` | ✅ |
| `View+LayoutPriority.swift` | `maxWidth`, `maxHeight`, `maxHW` | ✅ |
| `TTBaseUIKit+SwiftUI.swift` | `TTBaseSUIView` struct | ✅ |
| `UITabBar+Config+Extension.swift` | `configTabBar` (UIKit) | ✅ |

---

## GitHub Benchmarking Summary

Based on research of top repositories (antigravity-awesome-skills 37.8k stars, addyosmani/agent-skills 20k stars, Claude SwiftUI Agent Skill 3.9k stars):

### Patterns Adopted in v1.2.0
- **Standard frontmatter**: `name`, `description`, `version`, `date_updated`, `risk`, `source`, `tags` across all 7 skills
- **Single source of truth**: Fragment files for Iron Laws and Marker, referenced from all SKILL.md files
- **Common rationalizations**: Tables in bugfix and refactor skills
- **Quality gate checklists**: In native components skill
- **Canonical formula in registry**: FCR scoring defined once in `ttb-skill-registry.md`

### Patterns Not Yet Adopted
- **`.cursorrules` file**: No Cursor-specific rules file at workspace root
- **Automated localization checks**: Added to compliance script (warning-level only) — GitHub patterns use stricter enforcement
- **Skill changelog per-file**: Most files at v1.0.0, only SKILL.md files updated to v1.2.0

---

**End of Audit Report — TTBaseUIKit Antigravity Skills v1.2.0**
