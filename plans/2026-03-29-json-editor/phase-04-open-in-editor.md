# Phase 04: Open in JSON Editor — Cross-feature Buttons

> Parent: [plan.md](plan.md) | Dependencies: Phase 01, Phase 02

## Overview
- **Date:** 2026-03-29
- **Created By:** TuanTruong
- **Description:** Add "Open in JSON Editor" buttons to every location in the app where JSON is currently displayed (read-only via JSONViewer). Users can jump to the JSON Editor with the payload pre-loaded for editing, querying, or deeper analysis.
- **Priority:** P1
- **Implementation Status:** ✅ DONE (2026-03-29)
- **Review Status:** ✅ Reviewed (2026-03-29)

## Key Insights
- `JSONViewer` is used in 4 spots across the app:
  1. **ConsoleView** (line 409) — Log entry payload
  2. **NetworkView** (line 949) — Request body (Headers tab, PAYLOAD section)
  3. **NetworkView** (line 962) — Response body (Preview tab)
  4. **NetworkView** (line 992) — Response body (Response tab)
- Need a way to pass JSON string from current context to JSON Editor and switch tabs
- `AppState` already manages tab navigation — can use published property to carry JSON payload

## Requirements
1. Add "Open in JSON Editor" button (icon: `arrow.up.forward.square`) to JSONViewer toolbar
2. Button navigates to Dev Tools tab with JSON pre-loaded in editor
3. Works from all 4 JSONViewer locations
4. Optionally show source context label (e.g., "From: POST /api/users — Response Body")

## Architecture

### Changes to AppState
```swift
// Add to AppState
@Published var jsonEditorPayload: JSONEditorPayload? = nil

struct JSONEditorPayload {
    let json: String
    let sourceLabel: String  // e.g., "Response Body — POST /api/users"
}
```

### Changes to JSONViewer
- Add "Open in Editor" button to `jsonToolbar`
- Accept optional `sourceLabel` parameter
- On tap: set `appState.jsonEditorPayload`, switch to `.devtools` tab

### Changes to JSONEditorViewModel
- `onAppear`: check `appState.jsonEditorPayload`, load if present, then clear

## Related Code Files
- [JSONViewer.swift](../../TTBDebugPlus/TTBDebugPlus/Views/Shared/JSONViewer.swift) — Add button (line ~180, toolbar area)
- [ConsoleView.swift](../../TTBDebugPlus/TTBDebugPlus/Views/Console/ConsoleView.swift) — Line 409 (payload JSONViewer)
- [NetworkView.swift](../../TTBDebugPlus/TTBDebugPlus/Views/Network/NetworkView.swift) — Lines 949, 962, 992
- [AppState.swift](../../TTBDebugPlus/TTBDebugPlus/Models/AppState.swift) — Add payload property

## Implementation Steps
1. **AppState.swift** — Add `jsonEditorPayload` published property + `JSONEditorPayload` struct
2. **JSONViewer.swift** — Add `onOpenInEditor: ((String) -> Void)?` optional callback + toolbar button
3. **ConsoleView.swift** — Pass `onOpenInEditor` closure from JSONViewer in entry detail
4. **NetworkView.swift** — Pass `onOpenInEditor` closure from all 3 JSONViewer instances
5. **JSONEditorViewModel.swift** — Auto-load from appState payload on appear
6. **DevToolsView.swift** — Wire payload detection

## Todo List
- [ ] Add `JSONEditorPayload` to AppState
- [ ] Add "Open in Editor" button to JSONViewer toolbar
- [ ] Wire ConsoleView JSONViewer with callback
- [ ] Wire NetworkView JSONViewers (3 instances) with callbacks
- [ ] Handle payload auto-load in JSONEditorViewModel
- [ ] Test flow: Console log → Open in Editor
- [ ] Test flow: Network request body → Open in Editor
- [ ] Test flow: Network response body → Open in Editor

## Success Criteria
- Every JSONViewer instance shows "Open in Editor" button in toolbar
- Clicking navigates to Dev Tools and loads JSON into editor
- Source label displayed (e.g., "From: Response Body — GET /api/config")
- Editor contents are editable after loading (not read-only)
- Does not interfere with existing JSONViewer functionality

## Risk Assessment
- Low risk — straightforward navigation + state passing.
- Need `@EnvironmentObject` access in JSONViewer (currently not used) — may need refactor to accept closure instead.

## Next Steps
- Final integration testing across all flows
