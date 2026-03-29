# Phase 01: Core JSON Editor View & ViewModel

> Parent: [plan.md](plan.md) | Dependencies: Existing DesignSystem, JSONViewer.swift

## Overview
- **Date:** 2026-03-29
- **Created By:** TuanTruong
- **Description:** Build the main JSON Editor interface — full-featured code editor with syntax highlighting, tree viewer, validation, formatting, and core editing operations.
- **Priority:** P0 (Foundation)
- **Implementation Status:** ✅ DONE (2026-03-29)
- **Review Status:** ✅ Reviewed (2026-03-29)

## Key Insights
- Existing `JSONViewer.swift` (854 lines) has syntax highlighting + tree flattener — reuse `JSONHighlighter` and `JSONTreeFlattener`
- Existing design system has complete JSON color tokens (`ttJsonKey`, `ttJsonString`, etc.)
- macOS native `TextEditor` or `NSTextView` wrapper needed for editable code pane (existing viewer is read-only `Text`)
- Must support large payloads (async processing pattern already proven in JSONViewer)

## Requirements
1. **Editable Code Pane** — Full text editor with JSON syntax highlighting, line numbers, live error indicators
2. **Format/Beautify** — Pretty-print with configurable indentation (2/4 spaces)
3. **Minify/Compact** — One-click compress to single line
4. **Real-time Validation** — Show errors with line/column position, inline error markers
5. **Tree View** — Reuse existing collapsible tree from JSONViewer with edit-in-place capability
6. **Search in JSON** — ⌘F search with highlights, match count, next/prev navigation
7. **Toolbar** — Actions: Format, Minify, Validate, Copy, Paste, Clear, Undo/Redo, File Open/Save
8. **Statistics Bar** — Character count, line count, node count, file size, validation status

## Architecture

### File Structure
```
Views/DevTools/
├── JSONEditorView.swift          # Main container (split editor + tree)
├── JSONEditorCodeView.swift      # NSTextView wrapper with syntax highlighting
├── JSONEditorTreeView.swift      # Editable tree (extends existing tree logic)
├── JSONEditorToolbar.swift       # Top toolbar with actions
└── JSONEditorStatsBar.swift      # Bottom stats bar

ViewModels/
└── JSONEditorViewModel.swift     # Core state management

Models/
└── JSONEditorModels.swift        # State, error, config models
```

### ViewModel State
```swift
@Observable class JSONEditorViewModel {
    var rawJSON: String = ""
    var formattedJSON: String = ""
    var isValid: Bool = true
    var validationErrors: [JSONValidationError] = []
    var searchText: String = ""
    var searchMatches: Int = 0
    var currentMatchIndex: Int = 0
    var indentation: Int = 2
    var isDirty: Bool = false
    var editMode: JSONEditMode = .code  // .code, .tree, .split
    var history: [String] = []
    var historyIndex: Int = -1
    var nodeCount: Int = 0
    var lineCount: Int = 0
}
```

### JSONEditorCodeView (NSViewRepresentable)
- Wraps `NSTextView` with:
  - JSON syntax highlighting (reuse color tokens from `JSONHighlighter`)
  - Line number gutter (ruler view)
  - Error underlining
  - Bracket matching/auto-close
  - Ligature-disabled monospace font (TTFont.codeMedium equivalent)
  - onChange callback for live validation

## Related Code Files
- [JSONViewer.swift](../../TTBDebugPlus/TTBDebugPlus/Views/Shared/JSONViewer.swift) — Reuse `JSONHighlighter`, `JSONTreeFlattener`, `FlatTreeNode`
- [Colors.swift](../../TTBDebugPlus/TTBDebugPlus/DesignSystem/Colors.swift) — JSON syntax color tokens
- [Typography.swift](../../TTBDebugPlus/TTBDebugPlus/DesignSystem/Typography.swift) — Code fonts
- [CardView.swift](../../TTBDebugPlus/TTBDebugPlus/DesignSystem/CardView.swift) — Reusable card wrapper

## Implementation Steps
1. Create `JSONEditorModels.swift` — Define `JSONValidationError`, `JSONEditMode`, `JSONEditorTab` enums/structs
2. Create `JSONEditorViewModel.swift` — Core logic (validate, format, minify, undo/redo, search)
3. Create `JSONEditorCodeView.swift` — NSTextView wrapper with syntax highlighting + line numbers
4. Create `JSONEditorTreeView.swift` — Editable tree view extending existing `JSONTreeFlattener`
5. Create `JSONEditorToolbar.swift` — Action toolbar
6. Create `JSONEditorStatsBar.swift` — Bottom info bar
7. Create `JSONEditorView.swift` — Compose all subviews in split layout

## Todo List
- [ ] `JSONEditorModels.swift` — State models, enums
- [ ] `JSONEditorViewModel.swift` — Validation, formatting, search, undo/redo
- [ ] `JSONEditorCodeView.swift` — NSTextView wrapper
- [ ] `JSONEditorTreeView.swift` — Editable tree
- [ ] `JSONEditorToolbar.swift` — Toolbar actions
- [ ] `JSONEditorStatsBar.swift` — Stats bar
- [ ] `JSONEditorView.swift` — Main container
- [ ] Unit-level preview testing

## Success Criteria
- Can paste/type JSON and see real-time syntax highlighting
- Can format (beautify), minify JSON with one click
- Validation errors shown inline with line/column
- Tree view renders and collapses correctly
- Search highlights matches and navigates between them
- Undo/redo works (at least 50 steps)
- File open/save via macOS file picker

## Risk Assessment
- **NSTextView integration complexity** — Medium risk. Need careful TextKit management for syntax highlighting performance. Mitigated by async highlighting pattern from existing JSONViewer.
- **Large payload performance** — Low risk. Existing patterns handle 512KB+ payloads well.

## Security Considerations
- All processing local/client-side (no external API calls)
- File I/O through macOS sandbox-approved paths
