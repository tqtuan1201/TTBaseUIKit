# Phase 3: Bug Report Composer

> Parent: [plan.md](plan.md) | Depends on: Phase 1, Phase 2

**Date:** 2026-03-28
**Created By:** TuanTruong
**Status:** Draft
**Priority:** P0 — Core Feature
**Implementation Status:** Pending
**Review Status:** Pending

## Key Insights

This is the killer feature that differentiates TTBDebugPlus from simple screenshot tools. The report composer combines:
- Annotated screenshot(s)
- Auto-populated device metadata
- Structured issue description (title, severity, repro steps, expected/actual)
- Export as Markdown for pasting into Jira/Linear/GitHub Issues
- Clipboard-ready format

Inspired by Marker.io's "submit" flow and BugHerd's structured reports.

## Requirements

1. **Report form** — Title, description, severity, tag, repro steps
2. **Auto-populate device info** — Model, OS, screen, app version, SDK
3. **Attach screenshots** — Single or multiple, with annotations preserved
4. **Repro steps editor** — Numbered text fields with add/remove
5. **Expected vs Actual fields** — Side-by-side or stacked
6. **Export as Markdown** — Formatted report to clipboard
7. **Export as Image** — Combined image with annotations + metadata strip
8. **Report history** — View/edit/re-export previous reports

## Architecture

### BugReportComposerView

```
┌────────────────────────────────────────────────────┐
│ BUG REPORT                            [Cancel][✓]  │
├────────────────────────────────────────────────────┤
│                                                    │
│ Title: [_________________________________]         │
│                                                    │
│ Severity: (●Critical ○High ○Medium ○Low)          │
│ Tag:      [🐛Bug] [📱UI] [⚡Perf] [💥Crash]        │
│                                                    │
│ ───── Screenshots ─────                            │
│ ┌──────┐ ┌──────┐ [+ Add]                         │
│ │ img1 │ │ img2 │                                  │
│ └──────┘ └──────┘                                  │
│                                                    │
│ ───── Reproduction Steps ─────                     │
│ 1. [Open the settings screen              ]  [✕]  │
│ 2. [Tap on "Dark Mode" toggle             ]  [✕]  │
│ 3. [                                      ]  [✕]  │
│    [+ Add Step]                                    │
│                                                    │
│ ───── Expected Result ─────                        │
│ [The UI should switch to dark theme       ]        │
│                                                    │
│ ───── Actual Result ─────                          │
│ [The toggle animates but UI stays light   ]        │
│                                                    │
│ ───── Environment (auto-filled) ─────              │
│ • Device: iPhone 15 Pro                            │
│ • OS: iOS 17.4                                     │
│ • App: MyApp v2.1.0                                │
│ • Screen: 1179×2556pt                              │
│ • SDK: TTBase 4.2.0                                │
│                                                    │
│ ───── Additional Notes ─────                       │
│ [Free-text area for extra context.        ]        │
│                                                    │
├────────────────────────────────────────────────────┤
│ [📋 Copy Markdown] [💾 Save Report] [📤 Share]     │
└────────────────────────────────────────────────────┘
```

### Markdown Export Format

```markdown
## 🐛 [Title]

**Severity:** Critical | **Tag:** Bug, UI
**Device:** iPhone 15 Pro | **OS:** iOS 17.4
**App:** MyApp v2.1.0 | **SDK:** TTBase 4.2.0
**Screen:** 1179×2556pt | **Date:** 2026-03-28 15:30

### Reproduction Steps
1. Open the settings screen
2. Tap on "Dark Mode" toggle
3. Observe the behavior

### Expected Result
The UI should switch to dark theme

### Actual Result
The toggle animates but UI stays light

### Notes
Free-text area for extra context.

### Screenshots
[attached: 2 screenshots with annotations]
```

## Related Code Files

- `Views/Device/BugReportComposerView.swift` — NEW
- `ViewModels/BugReportViewModel.swift` — NEW
- `Models/BugReport.swift` — NEW model
- `ViewModels/ScreenCaptureViewModel.swift` — Add `createReport` trigger method

## Implementation Steps

### 1. Create BugReport model
```swift
struct BugReport: Identifiable, Codable {
    let id: UUID
    var title: String
    var severity: Severity
    var tags: Set<ReportTag>
    var reproSteps: [String]
    var expectedResult: String
    var actualResult: String
    var notes: String
    var screenshotIds: [UUID]
    var deviceInfo: DeviceInfoSnapshot
    var createdAt: Date
}
```

### 2. Create BugReportComposerView
- Present as sheet from DeviceView or gallery item context menu
- Pre-populate device info from ConnectionManager
- Allow attaching 1+ screenshots from gallery

### 3. Create BugReportViewModel
- Form state management
- Markdown generation
- Image export (screenshot + metadata strip rendered as single image)
- Report persistence (UserDefaults or JSON file)

### 4. Markdown export
- Copy formatted Markdown to clipboard
- Include device metadata section
- Screenshot references (note: actual images need separate attach)

### 5. Report history
- List of previous reports in a small section
- Click to view/edit
- Re-export capability

## Todo

- [ ] BugReport model
- [ ] BugReportComposerView (sheet)
- [ ] Form fields: title, severity, tag, repro steps
- [ ] Auto-populate device info
- [ ] Screenshot attachment (from gallery)
- [ ] Markdown export to clipboard
- [ ] Image export (annotated screenshot + metadata)
- [ ] Report history storage
- [ ] Report list view
- [ ] Entry point from gallery context menu

## Success Criteria

- User can create structured bug report in < 60 seconds
- Device info auto-populated — zero manual entry for environment
- Markdown export ready to paste into Jira/GitHub Issues
- Report includes annotated screenshot references
- Reports persist across sessions

## Risk Assessment

- **Low**: All SwiftUI forms, no protocol changes
- **Low**: Markdown generation is string interpolation
- **Medium**: Image export (rendering annotation + metadata as single image)
