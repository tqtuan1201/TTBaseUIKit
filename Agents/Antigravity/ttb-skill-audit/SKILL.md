---
name: "ttb-skill-audit"
description: "Code audits for TTBaseUIKit apps: performance, accessibility, localization. FCR compliance scoring."
version: "2.0.0"
loadLevel: "on-demand"
---

# ttb-skill-audit

> Code audit skill set for TTBaseUIKit apps.
> Performance | Accessibility | Localization | FCR Compliance

## Skills in This Set

| Command | Description |
|---------|-------------|
| `/ttb-audit-performance` | Performance: rendering, memory, CPU, main thread |
| `/ttb-audit-accessibility` | VoiceOver, Dynamic Type, touch targets, color contrast |
| `/ttb-audit-localization` | Hardcoded strings, missing keys, naming violations |

## FCR 7-Dimension Compliance Score

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

## Shared Audit Checklist

### Component Compliance
| ❌ Issue | ✅ Fix |
|---------|------|
| Raw `UILabel()` | `TTBaseUILabel` |
| Raw `UIButton()` | `TTBaseUIButton` |
| Raw `Text("...")` | `TTBaseSUIText` or native `Text` with tokens |
| Raw `Button(...)` | `TTBaseSUIButton` or native `Button` |

### Config Token Compliance
| ❌ Hardcoded | ✅ Token |
|-------------|---------|
| `UIColor(hex: "#555")` | `TTView.textDefColor` |
| `Color.blue` | `TTView.buttonBgDef.toColor()` |
| `8` (padding) | `TTSize.P_CONS_DEF` |
| `16` (padding) | `TTSize.P_CONS_DEF * 2` |
| `UIFont.systemFont(ofSize: 14)` | `TTFont.TITLE_H` |

### Closure Safety
| ❌ Issue | ✅ Fix |
|---------|------|
| Missing `[weak self]` | `[weak self]` + `self?.` |
| Strong self in API callback | `[weak self]` + guard |
| `NotificationCenter` observer without weak | `{ [weak self] _ in self?.reload() }` |

### Lifecycle
| ❌ Issue | ✅ Fix |
|---------|------|
| Missing `deinit` | Add with `removeObserver` + `XPrint` |
| Missing `super.viewDidLoad()` | Call `super` first |
| Subviews on `self.view` | `self.contentView` |

## Files in This Skill Set

| File | Purpose |
|------|---------|
| `ttb-skill-audit-performance.prompt.md` | Performance audit |
| `ttb-skill-audit-accessibility.prompt.md` | Accessibility audit |
| `ttb-skill-audit-localization.prompt.md` | Localization audit |

## Post-Audit Verification (MANDATORY)

After audit fixes are applied, run Phase 6 from `ttb-phase-verify.md`:

**Step 1 — xcodebuild Build**
```bash
cd /path/to/TTBaseUIKitExample
xcodebuild -project TTBaseUIKitExample.xcodeproj \
  -scheme TTBaseUIKitExample \
  -destination 'platform=iOS Simulator,name=iPhone 11' \
  build 2>&1 | tail -50
```
| Result | Action |
|--------|--------|
| `BUILD SUCCEEDED` | ✅ Proceed |
| `BUILD FAILED` | Fix errors → re-run (max 3 attempts) |

**Step 2 — Output Verification Report**
Report layers 1-5 from `ttb-phase-verify.md`. Audit is complete only when `✅ BUILD SUCCEEDED`.

---

**Version**: 2.0.0 | **Date**: 2026-05-19
**Changelog**: v2.0.0 — Version bump. Added 11 Iron Laws. Added critical token warnings. Updated shared resources to v2.0.0. v1.4.0 — Updated ttb-rule-coding-standards.md and ttb-rule-anti-patterns.md with chainable extensions.
