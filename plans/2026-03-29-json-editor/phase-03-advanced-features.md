# Phase 03: Advanced Features — Query, Diff, Convert

> Parent: [plan.md](plan.md) | Dependencies: Phase 01, Phase 02

## Overview
- **Date:** 2026-03-29
- **Created By:** TuanTruong
- **Description:** Add advanced JSON Editor features: JSONPath querying, side-by-side diff/compare, and format conversion (JSON ↔ YAML/XML/CSV).
- **Priority:** P1
- **Implementation Status:** ✅ DONE (2026-03-29)
- **Review Status:** ✅ Reviewed (2026-03-29)

## Key Insights
- JSONPath is simplest to implement natively in Swift (regex-based path traversal)
- jq is overkill for embedded tool; JSONPath covers 90% of dev/QC needs
- Diff can reuse `JSONSerialization` to normalize + compare trees
- YAML/XML conversion can use Swift stdlib (`PropertyListSerialization` for some formats)
- CSV conversion only applicable to array-of-objects

## Requirements

### JSONPath Query
1. Input field for JSONPath expression (e.g., `$.data.users[0].name`)
2. Live results as user types
3. Result count and preview
4. Common path suggestions/autocomplete
5. Quick path copy from tree view (right-click → "Copy JSONPath")

### JSON Diff
1. Split-pane: Left (A) vs Right (B), each with own text editor
2. Structural diff: highlight added (green), removed (red), changed (yellow)
3. Navigate between diffs (▲ ▼ buttons)
4. Diff summary: X additions, Y removals, Z changes
5. Option to ignore key order
6. Load from clipboard, file, or current editor

### JSON Convert
1. JSON → Prettified JSON (already done in Phase 01)
2. JSON → YAML (manual serializer — key: value format)
3. JSON → XML (`<key>value</key>` format)
4. JSON → CSV (only for array-of-objects, first-level keys as columns)
5. Bidirectional: paste any format, detect and convert to JSON

## Architecture

### New Files
```
Views/DevTools/
├── JSONQueryView.swift      # JSONPath query panel (input + results)
├── JSONDiffView.swift       # Side-by-side diff view
└── JSONConvertView.swift    # Format converter

ViewModels/
├── JSONQueryEngine.swift    # JSONPath parser + evaluator
├── JSONDiffEngine.swift     # Structural diff algorithm
└── JSONConvertEngine.swift  # Format conversion logic
```

### JSONPath Implementation (Simplified)
Support subset: `$`, `.key`, `[n]`, `[*]`, `..key` (recursive descent)
- Parse path → array of segments
- Walk JSON tree evaluating each segment
- Return matched values

### Diff Algorithm
1. Parse both JSON strings to dictionaries
2. Sort keys, normalize arrays
3. Recursive comparison → produce `DiffNode` tree
4. `DiffNode`: `.unchanged`, `.added(value)`, `.removed(value)`, `.changed(old, new)`
5. Render with inline color-coded markers

## Related Code Files
- [JSONEditorViewModel.swift] — Will hold reference to current JSON for query/diff
- [JSONViewer.swift](../../TTBDebugPlus/TTBDebugPlus/Views/Shared/JSONViewer.swift) — Reuse highlighting

## Implementation Steps
1. Create `JSONQueryEngine.swift` — JSONPath parser + evaluator
2. Create `JSONQueryView.swift` — Query input + results display
3. Create `JSONDiffEngine.swift` — Structural diff algorithm
4. Create `JSONDiffView.swift` — Split diff with color-coded markers
5. Create `JSONConvertEngine.swift` — JSON ↔ YAML/XML/CSV converters
6. Create `JSONConvertView.swift` — Converter UI with format picker
7. Integrate into JSONEditorView as sub-tabs (Query, Diff, Convert)

## Todo List
- [ ] `JSONQueryEngine.swift` — JSONPath implementation
- [ ] `JSONQueryView.swift` — Query panel UI
- [ ] `JSONDiffEngine.swift` — Diff logic
- [ ] `JSONDiffView.swift` — Side-by-side diff UI
- [ ] `JSONConvertEngine.swift` — Conversion logic (YAML, XML, CSV)
- [ ] `JSONConvertView.swift` — Converter UI
- [ ] Wire into JSONEditorView toolbar/tabs
- [ ] Test with real API payloads

## Success Criteria
- JSONPath queries return correct results for `$`, `.`, `[]`, `[*]`, `..` patterns
- Diff shows structural additions/removals/changes with color coding
- JSON → YAML/XML/CSV produce valid output
- All conversions handle edge cases (nested objects, special chars, null)

## Risk Assessment
- **JSONPath completeness** — Medium risk. Full JSONPath spec is complex; subset covers 90% needs.
- **YAML serialization accuracy** — Low risk. Manual serializer for common cases; edge cases (multi-line strings) may need refinement.
- **Performance on large diffs** — Medium risk. Recursive diff on 10K+ node trees may be slow. Mitigate with async processing.

## Security Considerations
- No external API calls; all local processing
