# Phase 3: View Decomposition

> Parent: [plan.md](plan.md)
> Depends on: [Phase 2](phase-02-token-migration.md) (token migration first for cleaner diffs)

## Overview

**Date:** 2026-03-29
**Priority:** High
**Status:** ⬜ TODO
**Estimated Effort:** 10h

Split 4 oversized view files (800+ lines) into focused, reusable components. Target: every file ≤ 200 lines.

## Key Insights

- SwiftUI compiler performance degrades significantly above ~500 lines
- Large files are hard to review, test, and maintain
- Extraction should follow logical UI boundaries (sections, panes, rows)
- Extract sub-views as separate structs, pass data via `let` constants to avoid unnecessary re-renders

## Requirements

1. No file > 300 lines after decomposition
2. All extracted views placed in appropriate subdirectories
3. Zero visual or behavioral regression
4. Data flow preserved — use `let` constants for extracted views, `@Binding` only when needed

## Architecture

### NetworkView.swift (1,223 → ~5 files)
```
Views/Network/
├── NetworkView.swift              # Main container (~150 lines)
├── NetworkFilterBar.swift         # Filter bar + controls (~120 lines)
├── NetworkRequestRow.swift        # Row view + WaterfallBar (~100 lines)
├── NetworkDetailPane.swift        # Detail pane container (~200 lines)
├── NetworkDetailContent.swift     # Headers/Preview/Response/Cookies tabs (~200 lines)
└── NetworkStatsView.swift         # [EXISTING] Already separate
```

### DeviceView.swift (870 → ~4 files)
```
Views/Device/
├── DeviceView.swift               # Main container (~150 lines)
├── DeviceScreenCapture.swift      # Screenshot preview + controls (~150 lines)
├── DeviceScreenGallery.swift      # Gallery grid/list (~150 lines)
├── DeviceRecordingPanel.swift     # Recording controls (~100 lines)
├── AnnotationEditorView.swift     # [EXISTING — also needs split]
├── BugReportComposerView.swift    # [EXISTING]
└── RecordingExportView.swift      # [EXISTING]
```

### AnnotationEditorView.swift (922 → ~4 files)
```
Views/Device/
├── AnnotationEditorView.swift     # Main editor (~150 lines)
├── AnnotationToolbar.swift        # Tool palette (~100 lines)
├── AnnotationCanvas.swift         # Drawing surface (~200 lines)
└── AnnotationColorPicker.swift    # Color/width controls (~80 lines)
```

### JSONViewer.swift (869 → ~3 files)
```
Views/Shared/
├── JSONViewer.swift               # Main container (~120 lines)
├── JSONSyntaxHighlighter.swift    # Syntax coloring logic (~200 lines)
├── JSONTreeNode.swift             # Tree view node (~150 lines)
└── JSONLineNumberView.swift       # Line number gutter (~80 lines)
```

## Implementation Steps

### Step 1: NetworkView Split
1. Extract `NetworkRequestRowView` + `WaterfallBar` → `NetworkRequestRow.swift`
2. Extract `networkFilterBar` + helpers → `NetworkFilterBar.swift`
3. Extract `NetworkDetailPaneView` → `NetworkDetailPane.swift`
4. Extract detail tab content views → `NetworkDetailContent.swift`
5. Clean up main `NetworkView.swift` as thin container

### Step 2: DeviceView Split
1. Extract screen capture preview section → `DeviceScreenCapture.swift`
2. Extract gallery grid/list → `DeviceScreenGallery.swift`
3. Extract recording controls → `DeviceRecordingPanel.swift`
4. Clean up main `DeviceView.swift`

### Step 3: AnnotationEditorView Split
1. Extract tool palette → `AnnotationToolbar.swift`
2. Extract drawing canvas → `AnnotationCanvas.swift`
3. Extract color/width picker → `AnnotationColorPicker.swift`
4. Clean up main editor

### Step 4: JSONViewer Split
1. Extract syntax highlighting logic → `JSONSyntaxHighlighter.swift`
2. Extract tree node views → `JSONTreeNode.swift`
3. Extract line number view → `JSONLineNumberView.swift`
4. Clean up main viewer

## Todo List

- [ ] Split NetworkView.swift
- [ ] Split DeviceView.swift
- [ ] Split AnnotationEditorView.swift
- [ ] Split JSONViewer.swift
- [ ] Verify all extracted files compile
- [ ] Verify no visual regression

## Success Criteria

- No `.swift` file in Views/ exceeds 300 lines
- `find Views/ -name "*.swift" -exec wc -l {} + | sort -rn` — largest file < 300
- App builds and runs identically to before

## Risk Assessment

- **Medium risk** — refactoring large views can introduce subtle layout bugs
- Mitigate: test each split independently, compile after each extraction
- Data flow must be carefully preserved (avoid accidentally converting `let` to `@State`)
