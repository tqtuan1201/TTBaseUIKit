# Phase 03: Functionality Audit + Fixes

> **Parent Plan:** [plan.md](./plan.md)
> **Dependencies:** Phase 01, Phase 02
> **Docs:** [docs/system-architecture](../../docs/)

## Overview

- **Date:** 2026-03-29
- **Created By:** TuanTruong
- **Description:** Comprehensive audit of all Network feature functions. Verify each feature works correctly, fix broken ones, and document edge cases.
- **Priority:** P1 — High
- **Implementation Status:** `[ ]` Pending
- **Review Status:** `[ ]` Not reviewed

## Key Insights

### Functionality Audit Results

| # | Feature | Status | Issue |
|---|---------|--------|-------|
| 1 | Request list rendering | ✅ Works | — |
| 2 | Request sorting (newest first) | ✅ Works | — |
| 3 | Text search filter | ✅ Works | — |
| 4 | Search scope (All/URL/Body/Headers) | ✅ Works | — |
| 5 | Status filter (All/2xx/4xx/5xx) | ⚠️ Partial | **Missing 3xx filter** — StatusFilter enum has `redirect` but filter bar only shows `[all, success, clientError, serverError]` |
| 6 | Method filter | ❌ Broken | `selectedMethodFilter` exists in VM but **no UI to set it** |
| 7 | Pin/Unpin requests | ✅ Works | — |
| 8 | Show only pinned | ✅ Works | — |
| 9 | Live/Pause toggle | ❌ Bug | `isLiveStreaming` is visual only — **no logic to actually pause** incoming data |
| 10 | Clear all | ✅ Works | But doesn't clear from `ConnectionManager`, can resync |
| 11 | Select request → detail | ✅ Works | — |
| 12 | Detail: Headers tab | ✅ Works | Response headers in wrong tab (shown in Response tab) |
| 13 | Detail: Preview tab | ✅ Works | — |
| 14 | Detail: Response tab | ✅ Works | — |
| 15 | Detail: Cookies tab | ❌ Empty | Always shows "No Cookies" — never parses Set-Cookie headers |
| 16 | Copy URL (context menu) | ✅ Works | — |
| 17 | Copy cURL (context menu) | ✅ Works | — |
| 18 | Copy Request Body | ✅ Works | — |
| 19 | Copy Response Body | ✅ Works | — |
| 20 | Share cURL button | ⚠️ Works | But only when entry selected — no visual feedback when no selection |
| 21 | Postman export | ✅ Works | — |
| 22 | Analytics: method chart | ✅ Works | — |
| 23 | Analytics: status chart | ✅ Works | — |
| 24 | Analytics: summary cards | ✅ Works | — |
| 25 | Analytics: slowest requests | ✅ Works | — |
| 26 | `syncFromConnectionManager` | ⚠️ Partial | Syncs when `totalAPILogs` changes, but doesn't handle device disconnect/reconnect well |
| 27 | Data refresh | ⚠️ Issue | No manual refresh button — only auto-sync on `totalAPILogs` change |

## Requirements

- [ ] Fix #5: Add 3xx (redirect) filter to the filter bar UI
- [ ] Fix #6: Add HTTP method filter UI (pill buttons or dropdown)
- [ ] Fix #9: Implement actual Live/Pause functionality
- [ ] Fix #15: Parse `Set-Cookie` response headers and display in Cookies tab
- [ ] Fix #20: Disable/gray out Share cURL when no entry selected
- [ ] Fix #26: Handle device disconnect gracefully — mark entries from disconnected devices
- [ ] Add #27: Manual refresh button

## Architecture

### Live/Pause Implementation
```swift
// In NetworkViewModel
var isLiveStreaming: Bool = true

func syncFromConnectionManager(_ connectionManager: ConnectionManager) {
    guard isLiveStreaming else { return } // ← Pause gate
    // ... existing sync logic
}
```

### Cookie Parsing
```swift
var parsedCookies: [(name: String, value: String, attributes: [String: String])] {
    guard let setCookie = request.responseHeaders.first(where: {
        $0.key.lowercased() == "set-cookie"
    })?.value else { return [] }
    
    return parseCookieString(setCookie)
}
```

## Related Code Files

| File | Change Type | Purpose |
|------|------------|---------|
| `ViewModels/NetworkViewModel.swift` | MODIFY | Fix Live/Pause, add cookie parsing |
| `Views/Network/NetworkView.swift` | MODIFY | Add 3xx filter, method filter UI, cookie display, refresh |
| `Views/Network/NetworkStatsView.swift` | MODIFY | Minor — no functional bugs |

## Implementation Steps

### Step 1: Fix Status Filter — Add 3xx
In `networkFilterBar`, change the filter array:
```swift
ForEach(StatusFilter.allCases, id: \.self) { filter in // Use allCases instead of hardcoded list
```

### Step 2: Add Method Filter UI
Add a method filter dropdown/picker after status filters:
```swift
Menu {
    Button("All Methods") { viewModel.selectedMethodFilter = nil }
    Divider()
    ForEach(["GET", "POST", "PUT", "DELETE", "PATCH"], id: \.self) { method in
        Button(method) { viewModel.selectedMethodFilter = method }
    }
} label: {
    HStack(spacing: 4) {
        Text(viewModel.selectedMethodFilter ?? "Method")
            .font(TTFont.labelSmall)
        Image(systemName: "chevron.down")
            .font(.system(size: 8))
    }
}
```

### Step 3: Fix Live/Pause Toggle
- Make the LIVE badge clickable
- Add pause gate in `syncFromConnectionManager`
- When paused, show badge as "PAUSED" in yellow
- When resuming, do a full resync

### Step 4: Implement Cookies Tab
- Parse `Set-Cookie` response headers
- Display as a table: Name, Value, Domain, Path, Expires, HttpOnly, Secure
- Show cookie count in tab label

### Step 5: Clear All — Also Clear ConnectionManager
```swift
func clearAll() {
    entries.removeAll()
    selectedEntry = nil
    pinnedIds.removeAll()
    // Also clear source
    connectionManager.clearAllLogs()
}
```
Need to pass connectionManager reference or use closure.

### Step 6: Add Manual Refresh Button
Add a refresh icon button in the filter bar or bottom bar:
```swift
Button(action: { viewModel.syncFromConnectionManager(connectionManager) }) {
    Image(systemName: "arrow.clockwise")
}
```

### Step 7: Graceful Disconnect Handling
When a device disconnects mid-session:
- Keep its logs in the list (don't remove)
- Show a subtle "disconnected" indicator on its entries
- Allow clearing disconnected device logs separately

## Todo List

- [ ] Add 3xx redirect filter to filter bar (use `StatusFilter.allCases`)
- [ ] Add HTTP method filter dropdown/picker
- [ ] Implement Live/Pause gate in sync logic
- [ ] Make LIVE badge toggleable
- [ ] Parse Set-Cookie headers for Cookies tab
- [ ] Display cookies in table format
- [ ] Fix clear all to optionally clear ConnectionManager logs
- [ ] Add manual refresh button
- [ ] Handle device disconnect gracefully
- [ ] Add visual feedback when Share cURL has no selection

## Success Criteria

- [ ] All 27 audited features work correctly
- [ ] 3xx and method filters visible and functional
- [ ] Live/Pause actually stops/resumes data flow
- [ ] Cookies tab shows parsed cookie data when available
- [ ] Clear All properly resets both VM and ConnectionManager
- [ ] App doesn't crash on device disconnect during active view

## Risk Assessment

| Risk | Impact | Mitigation |
|------|--------|------------|
| Cookie parsing edge cases | Low | Use standard RFC 6265 parsing, handle malformed gracefully |
| Clear All syncing issues | Medium | Use generation counter to prevent stale syncs |
| Pause/resume race condition | Medium | Use atomic bool + dispatch to main |

## Next Steps

→ Phase 04: Analytics + Export Enhancements
