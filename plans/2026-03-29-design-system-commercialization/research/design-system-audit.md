# Research: TTBDebugPlus Design System Audit

**Date:** 2026-03-29
**Type:** Codebase Analysis

## Current State

### Design System Files (4 files, well-structured)
- `Colors.swift` (157 lines) — 45+ design tokens, hex color init, semantic helpers
- `Typography.swift` (86 lines) — TTFont enum, TTTextStyle modifier, 7 view modifiers
- `ButtonStyles.swift` (178 lines) — 6 button styles with hover
- `CardView.swift` (228 lines) — CardView, StatusBadge, HTTPMethodBadge, DeviceBadge, etc.

### Design Token Usage ✅ (Colors)
- **0** instances of `Color(hex:` in Views → colors properly use `Color.tt*` tokens
- **11** instances of raw `.foregroundColor(.white/.blue/.green/.yellow)` → need migration
- 336 total `Color.` references in Views, most using design tokens

### Design Token Violations ❌ (Fonts)
- **166** instances of `.font(.system(` in Views → NOT using `TTFont.*` tokens
- Worst offenders:
  - `NetworkView.swift`: 24 instances
  - `DeviceView.swift`: 24 instances
  - `AnnotationEditorView.swift`: 14 instances
  - `IntegrationGuideView.swift`: 11 instances
  - `RecordingExportView.swift`: 10 instances
  - `JSONDiffView.swift`: 10 instances

### File Size Issues (>200 lines guideline)
| File | Lines | Status |
|------|-------|--------|
| NetworkView.swift | 1,223 | ❌ Critical — needs split |
| AnnotationEditorView.swift | 922 | ❌ Critical — needs split |
| DeviceView.swift | 870 | ❌ Critical — needs split |
| JSONViewer.swift | 869 | ❌ Critical — needs split |
| ScreenCaptureViewModel.swift | 665 | ⚠️ Large ViewModel |
| IntegrationGuideView.swift | 591 | ⚠️ Large |
| NetworkViewModel.swift | 534 | ⚠️ Large |
| ConsoleView.swift | 494 | ⚠️ Moderate |
| BugReportComposerView.swift | 481 | ⚠️ Moderate |

### Missing Design System Components
1. **Spacing tokens** — no `TTSpacing` enum; hardcoded magic numbers everywhere
2. **Corner radius tokens** — ad-hoc `cornerRadius: 6/8/12` not standardized
3. **Shadow tokens** — inconsistent shadow definitions
4. **Animation tokens** — duration/easing not standardized
5. **Icon size tokens** — `.font(.system(size: 8/9/10/11))` scattered
6. **Opacity tokens** — random values like `0.1`, `0.12`, `0.15`, `0.3`, `0.5`

### Missing from Commercialization
1. No accessibility support (VoiceOver labels, keyboard nav limited to NetworkView)
2. No light mode support (`.preferredColorScheme(.dark)` forced)
3. No localization
4. No onboarding monetization gating

## Key Findings

1. Colors are well-tokenized ✅ — only 11 stragglers
2. Fonts are NOT tokenized ❌ — 166 violations
3. Spacing/sizing NOT tokenized ❌ — hundreds of magic numbers
4. 4 files over 800 lines → must split for maintainability
5. DateFormatter created inline (performance issue in rows/lists)
6. `filteredEntries` computed property re-sorts + re-filters on every access (O(n log n) per render)
