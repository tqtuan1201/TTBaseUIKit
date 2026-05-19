# Antigravity TTBaseUIKit Skills — Version History

## v1.2.0 — 2026-05-18

### What's New

- **Bug fixes**: SizeConfig padding typo, LiquidGlass Swift version check
- **Consistency**: Iron Laws deduplication, `prepareForReuse()` templates, `deinit` RCA checklist, BaseShadowView naming, AwesomePro docs
- **New ref**: `ttb-ref-swiftui-extensions.md` — catalog of all 9 SwiftUI extension files
- **GitHub patterns**: `risk`/`version` frontmatter, rationalizations tables, quality gate checklists
- **All skills**: Bumped to v1.2.0

### Skill Sets (8)

| Skill | Description | Prompt Files |
|-------|-------------|-------------|
| `ttb-skill-init/` | Project initialization | 5 |
| `ttb-skill-uikit/` | UIKit: screen, list, form, cell, customview, api, coordinator, viewmodel | 8 |
| `ttb-skill-swiftui/` | SwiftUI: TTBaseSUI + native screens, views, viewmodels | 6 |
| `ttb-skill-native-swiftui-components/` | 20 native SwiftUI components | 20 |
| `ttb-skill-bugfix/` | Systematic bug fixing workflow | 1 |
| `ttb-skill-refactor/` | Clean architecture refactoring | 1 |
| `ttb-skill-audit/` | Performance, accessibility, localization audits | 3 |
| `ttb-skill-shared/` | Shared resources | 17 |

### Total: **47 files**

---

## v1.1.0 — 2026-05-13

### What's New

- **NEW: Phase 6 — Post-Build Verification** (`ttb-skill-shared/phases/ttb-phase-verify.md`)
  - Mandatory verification after every skill workflow
  - 5-Layer Verification Stack: Xcode Project Integrity → xcodebuild → Rules Compliance → Regression Guard → FCR 7-Dimension Score
  - Anti-Loop protocol (max 3 build attempts)

- **NEW: 11th Iron Law** — "POST-BUILD VERIFICATION IS MANDATORY"
  - Every skill workflow output MUST end with `✅ BUILD SUCCEEDED`
  - xcodebuild CLI verification required after every skill

### Skill Sets (6)

| Skill | Description | Prompt Files |
|-------|-------------|-------------|
| `ttb-skill-uikit/` | UIKit: screen, list, form, cell, customview, api, coordinator, viewmodel | 8 |
| `ttb-skill-swiftui/` | SwiftUI: TTBaseSUI + native screens, views, viewmodels | 6 |
| `ttb-skill-bugfix/` | Systematic bug fixing workflow | 1 |
| `ttb-skill-refactor/` | Clean architecture refactoring | 1 |
| `ttb-skill-audit/` | Performance, accessibility, localization audits | 3 |
| `ttb-skill-shared/` | Rules, phases, reference documentation | 10 |

### Root Documentation (6)

- `SKILL.md` — Root skill entry point
- `README.md` — Overview and quick reference
- `README-VI.md` — Vietnamese version
- `INSTALL.md` — Installation guide
- `VERSION.md` — This file
- `install.sh` — Installation script

---

**Total: 47 files**
