# Phase 2: Font & Color Token Migration

> Parent: [plan.md](plan.md)
> Depends on: [Phase 1](phase-01-design-tokens.md)

## Overview

**Date:** 2026-03-29
**Priority:** High
**Status:** ⬜ TODO
**Estimated Effort:** 10h

Replace all 166 hardcoded `.font(.system(` calls with `TTFont.*` tokens and 11 raw color references (`.white`, `.blue`, `.green`, `.yellow`) with `Color.tt*` tokens. Also migrate hardcoded spacing/radius/opacity to new tokens from Phase 1.

## Key Insights

- 166 `.font(.system(` violations across 23 files
- 11 raw color references in 7 files
- Most font sizes map directly to existing TTFont tokens
- Some icon `.font(.system(size: N))` → `TTIcon.*` tokens

## Requirements

1. Every `.font(.system(` replaced with `TTFont.*` or `TTIcon.*`
2. Every `.foregroundColor(.white/.blue/.green/.yellow)` replaced with `Color.tt*`
3. Replace hardcoded `cornerRadius` values with `TTRadius.*`
4. Replace common hardcoded padding values with `TTSpacing.*`
5. Zero visual regression — output must look identical

## Files to Modify (ordered by violation count)

| File | Font Violations | Color Violations |
|------|-----------------|------------------|
| NetworkView.swift | 24 | 1 (`.yellow`) |
| DeviceView.swift | 24 | 0 |
| AnnotationEditorView.swift | 14 | 1 (`.white`) |
| IntegrationGuideView.swift | 11 | 0 |
| RecordingExportView.swift | 10 | 1 (`.white`) |
| JSONDiffView.swift | 10 | 0 |
| JSONQueryView.swift | 7 | 0 |
| JSONViewer.swift | 6 | 0 |
| JSONConvertView.swift | 6 | 0 |
| ConsoleView.swift | 6 | 0 |
| JSONEditorView.swift | 5 | 0 |
| JSONEditorToolbar.swift | 5 | 0 |
| DevToolsView.swift | 4 | 0 |
| JSONEditorTreeView.swift | 4 | 0 |
| PerformanceView.swift | 4 | 0 |
| BugReportComposerView.swift | 4 | 0 |
| NetworkStatsView.swift | 3 | 1 (`.white`) |
| FeedbackView.swift | 3 | 1 (`.white`) |
| SidebarView.swift | 3 | 1 (`.white`) |
| GuideContainerView.swift | 2 | 0 |
| WelcomeSheet.swift | 2 | 2 (`.white`) |
| UsageGuideView.swift | 2 | 0 |
| PermissionsView.swift | 2 | 0 |
| SettingsView.swift | 0 | 2 (`.blue`, `.green`) |
| StorageSettingsView.swift | 0 | 0 |

## Implementation Steps

### Mapping Rules

#### Font Mapping
```
.font(.system(size: 7-8, weight: ...))    → .font(TTFont.badge) or .font(.system(size: TTIcon.xxxs))
.font(.system(size: 9))                    → .font(.system(size: TTIcon.xs))
.font(.system(size: 10, weight: .medium))  → .font(TTFont.labelSmall)
.font(.system(size: 10, weight: .bold))    → .font(TTFont.badge)
.font(.system(size: 11))                   → .font(TTFont.bodySmall) or .font(.system(size: TTIcon.md))
.font(.system(size: 12))                   → .font(TTFont.codeMedium) or .font(TTFont.timestamp)
.font(.system(size: 13))                   → .font(TTFont.bodyMedium)
.font(.system(size: 14-15))                → .font(TTFont.bodyLarge) or .font(TTFont.codeLarge)
.font(.system(size: 17))                   → .font(TTFont.heading3)
.font(.system(size: 20))                   → .font(TTFont.heading2)
.font(.system(size: 24))                   → .font(TTFont.heading1)
```

#### Color Mapping
```
.foregroundColor(.white)   → .foregroundColor(.ttTextPrimary) [on dark bg]
.foregroundColor(.blue)    → .foregroundColor(.ttPrimary)
.foregroundColor(.green)   → .foregroundColor(.ttSuccess)
.foregroundColor(.yellow)  → .foregroundColor(.ttWarning)
```

### Execution Order
1. Start with smallest files first (PermissionsView, GuideContainerView)
2. Then medium files (SettingsView, SidebarView, FeedbackView)
3. Then large files (NetworkView, DeviceView, AnnotationEditorView)
4. Compile after each file to catch errors early

## Todo List

- [ ] Migrate PermissionsView.swift (2 fonts)
- [ ] Migrate GuideContainerView.swift (2 fonts)
- [ ] Migrate SettingsView.swift (2 colors)
- [ ] Migrate WelcomeSheet.swift (2 fonts, 2 colors)
- [ ] Migrate UsageGuideView.swift (2 fonts)
- [ ] Migrate SidebarView.swift (3 fonts, 1 color)
- [ ] Migrate NetworkStatsView.swift (3 fonts, 1 color)
- [ ] Migrate FeedbackView.swift (3 fonts, 1 color)
- [ ] Migrate DevToolsView.swift (4 fonts)
- [ ] Migrate BugReportComposerView.swift (4 fonts)
- [ ] Migrate JSONEditorTreeView.swift (4 fonts)
- [ ] Migrate PerformanceView.swift (4 fonts)
- [ ] Migrate JSONEditorView.swift (5 fonts)
- [ ] Migrate JSONEditorToolbar.swift (5 fonts)
- [ ] Migrate ConsoleView.swift (6 fonts)
- [ ] Migrate JSONViewer.swift (6 fonts)
- [ ] Migrate JSONConvertView.swift (6 fonts)
- [ ] Migrate JSONQueryView.swift (7 fonts)
- [ ] Migrate JSONDiffView.swift (10 fonts)
- [ ] Migrate RecordingExportView.swift (10 fonts, 1 color)
- [ ] Migrate IntegrationGuideView.swift (11 fonts)
- [ ] Migrate AnnotationEditorView.swift (14 fonts, 1 color)
- [ ] Migrate DeviceView.swift (24 fonts)
- [ ] Migrate NetworkView.swift (24 fonts, 1 color)
- [ ] Final build verification

## Success Criteria

- `grep -rn "\.font(\.system(" Views/ | wc -l` returns **0**
- `grep -rn "\.foregroundColor(\.\(white\|blue\|green\|yellow\))" Views/ | wc -l` returns **0**
- App compiles and runs without visual regression
- All existing design tokens preserved (no visual change)

## Risk Assessment

- **Medium risk** — high file count, potential typos
- Mitigate by compiling after each file
- Some `.system(size:)` on icons may need new tokens in `TTIcon` — handled in Phase 1
