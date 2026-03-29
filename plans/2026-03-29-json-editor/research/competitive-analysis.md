# JSON Editor Competitive Research

**Date:** 2026-03-29

## 1. Top JSON Editor Online Tools

### JSON Editor Online (jsoneditoronline.org)
- Dual-pane: tree + code view, synchronized
- Table view for array-of-objects editing
- JSON Schema validation
- Advanced search/replace, sort, filter
- 512MB file support, drag & drop import/export
- Undo/redo, keyboard shortcuts

### DataFormatterPro
- Client-side only (privacy-first)
- Zod-powered schema validation
- Live tree view, one-click conversion to XML/CSV/YAML
- Diff with export to HTML reports

### JsonViewer.tools
- Real-time validation with error highlighting
- Instant formatting, ad-free, responsive

### JSONLint
- Quick syntax-check validator
- Precise error messages (line/column)

## 2. macOS Native JSON Tools

### OK JSON (okjson.app)
- AppKit + SwiftUI hybrid, top-rated native macOS tool
- Quick Look, Raycast integration, native shortcuts
- Fast, local-only, privacy-focused

### CodeEdit (open-source, SwiftUI)
- Full IDE using SwiftUI, syntax highlighting
- Community-driven, extensible

### JSONPreview (open-source library)
- SwiftUI component: format, collapse/expand, syntax highlight
- Lightweight, embeddable

## 3. JSON Query Languages

| Language | Focus | Standardization | Power |
|----------|-------|-----------------|-------|
| **JSONPath** | Navigation/Extraction | Low (many variants) | Basic |
| **JMESPath** | Querying/Filtering | High (strict spec) | Moderate |
| **JSONata** | Transformation/Reshaping | High | Advanced |
| **jq** | CLI processing | Standard | Advanced |

## 4. JSON Diff/Compare Features
- Semantic structural diff (not text-based)
- Normalize keys before comparing
- Side-by-side or inline view
- Highlight added/removed/changed nodes
- Navigate between diffs
- Ignore rules (timestamps, IDs)

## 5. Key Feature Matrix (Must-Have for Dev Tools)

| Feature | Priority | Notes |
|---------|----------|-------|
| **Edit JSON** (code editor) | P0 | Syntax highlighting, line numbers |
| **Format/Beautify** | P0 | Pretty-print with indentation options |
| **Minify/Compact** | P0 | One-click compress |
| **Validate** | P0 | Real-time error messages with line/col |
| **Tree View** | P0 | Collapsible hierarchy, type badges |
| **Search (in JSON)** | P0 | Highlight matches, jump between |
| **Copy / Paste** | P0 | Quick input/output |
| **JSONPath Query** | P1 | Filter/extract specific paths |
| **Convert** (JSON↔YAML/XML/CSV) | P1 | Format transformation |
| **Diff/Compare** | P1 | Side-by-side structural comparison |
| **File Open/Save** | P1 | Load from disk, save results |
| **Multiple Tabs** | P2 | Work on multiple JSONs |
| **History** | P2 | Recent edits, clipboard history |
| **JSON Schema Validation** | P2 | Validate against schema |

## Sources
- jsoneditoronline.org, dataformatterpro.com, jsonly.be
- okjson.app, github.com/CodeEditApp/CodeEdit
- github.com/RakuyoKit/JSONPreview
- jmespath.org, jsonata.org
