# Phase 01: JSON Syntax Viewer & Advanced Filtering

**Parent:** [plan.md](./plan.md)
**Date:** 2026-03-27
**Created By:** TuanTruong
**Priority:** 🔴 Critical
**Status:** ⬜ Pending

## Overview

Every major competitor (Proxyman, Pulse, Flipper) provides syntax-highlighted JSON viewing and deep search. TTBDebugPlus currently shows plain text for request/response bodies. This is the #1 gap.

## Key Insights

- Pulse Pro uses custom SwiftUI `Text` with `AttributedString` for syntax highlighting
- Proxyman uses WebView with Monaco editor (overkill for our use case)
- Best approach: pure SwiftUI `AttributedString` with recursive JSON parsing
- Deep search should search within request/response bodies, not just URLs

## Requirements

1. **JSONSyntaxView** — SwiftUI component that renders JSON with color-coded syntax
   - Keys: cyan/teal
   - Strings: green
   - Numbers: orange/amber
   - Booleans: purple
   - Null: gray
   - Brackets/braces: white/secondary
   - Proper indentation (configurable 2/4 spaces)
   - Collapsible nodes for nested objects/arrays
   - Line numbers (optional)
   - Copy button per node

2. **Advanced Filtering for Console**
   - Regex support toggle
   - Multi-level filter (error + warning at same time)
   - Subsystem filter chips
   - Time range filter

3. **Deep Search for Network**
   - Search in URL (existing)
   - Search in request body
   - Search in response body
   - Search in headers
   - Highlight matches in body view

4. **Pin/Bookmark System**
   - Star/pin important requests or logs
   - Filter to show only pinned items
   - Pinned items persist during session

## Architecture

```
DesignSystem/
  JSONSyntaxView.swift          [NEW] — Reusable syntax-highlighted JSON viewer
  
Components/
  FilterBarView.swift           [NEW] — Reusable advanced filter bar
  PinButton.swift               [NEW] — Star/pin toggle button

Views/Network/
  NetworkView.swift             [MODIFY] — Add deep search, pin column
  NetworkDetailView.swift       [MODIFY] — Use JSONSyntaxView for bodies

Views/Console/
  ConsoleView.swift             [MODIFY] — Add regex, multi-level, subsystem filter

ViewModels/
  ConsoleViewModel.swift        [MODIFY] — Add advanced filter logic
  NetworkViewModel.swift        [MODIFY] — Add deep search, pin logic
```

## Implementation Steps

1. Create `JSONSyntaxView` component
   - Parse JSON string → recursive model
   - Build `AttributedString` with colors
   - Add collapse/expand per node
   - Add copy-to-clipboard per node
   - Add line numbers option

2. Create `PinButton` component
   - Star icon toggle
   - Yellow when active
   - Add `isPinned` to `NetworkRequestEntry` and `ConsoleLogEntry`

3. Upgrade NetworkView filtering
   - Add search scope: URL / Body / Headers / All
   - Update `NetworkViewModel.filteredEntries` to search deep
   - Add pin filter toggle to filter bar
   - Show match highlights in NetworkDetailView

4. Upgrade ConsoleView filtering
   - Add regex toggle button
   - Change level filter to multi-select (chips)
   - Add subsystem filter as dropdown
   - Add time range picker

5. Integrate JSONSyntaxView into NetworkDetailView
   - Replace plain `Text()` for request/response body
   - Auto-detect JSON vs plain text
   - Add "Raw / Pretty / Hex" toggle

## Success Criteria

- [ ] JSON bodies render with syntax highlighting in Network detail
- [ ] Collapsible JSON nodes work
- [ ] Deep search finds matches in request/response bodies
- [ ] Pin/bookmark persists during session
- [ ] Console supports regex and multi-level filtering
- [ ] Build passes

## Risk Assessment

- **Low:** Pure SwiftUI implementation, no external deps
- **Medium:** Large JSON (>1MB) may cause render lag → mitigate with lazy rendering and truncation
