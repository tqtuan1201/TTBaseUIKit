# Phase 2: UI/UX Layout & Visual Polish

**Parent:** [plan.md](./plan.md)
**Dependencies:** Phase 1 (device info card design feeds into this)
**Priority:** P1 — High impact UX improvements

---

## Overview

**Date:** 2026-03-28
**Created By:** TuanTruong
**Status:** Draft
**Implementation Status:** Not Started
**Review Status:** Pending

## Key Insights

- Every major view (Console, Network, Performance, Feedback, Device) has layout or empty-state issues
- Inconsistent spacing & padding across views
- Missing empty states make app feel broken when no data present
- Tab bar lacks icons → harder to scan on macOS
- StatusBar too cramped → metrics hard to read

## Requirements

### All Views
- [ ] Add empty state views where missing (Console, Network, Performance)
- [ ] Fix responsive layouts for narrow/wide window sizes

### Sidebar
- [ ] Clean up bottom actions alignment
- [ ] Dynamic version badge (use app bundle version)

### TabBarView
- [ ] Rename "TTBase_Debugger" → "TTBDebugPlus" (no underscore)
- [ ] Add icons to tab items
- [ ] Remove Guide tab from main tab bar (it's in sidebar)

### StatusBarView
- [ ] Increase height from 28pt → 32pt
- [ ] Hide memory/CPU metrics when no device connected (instead of "--")
- [ ] Better spacing between metric groups

### ConsoleView
- [ ] Add empty state when no logs ("No console logs yet")
- [ ] Show total count badge on "All" filter pill
- [ ] Improve column header responsive behavior

### NetworkView
- [ ] Add empty state when no requests
- [ ] Better spacing for filter bar pills (less crowded)
- [ ] Fix bottom bar button overlap on narrow windows (use `ScrollView` or collapse)

### PerformanceView
- [ ] Add empty/placeholder state when no data
- [ ] Graceful handling of nil FPS/disk values (show "N/A" card instead of hiding)
- [ ] Better spacing between analytics rows

### FeedbackView
- [ ] Increase form textarea maxHeight (100 → 200)
- [ ] Enlarge tag selector pill sizes for macOS
- [ ] Enlarge screenshot thumbnail size (60×80 → 80×110)

### DeviceView (UI only, functional fix in Phase 1)
- [ ] Make iPhone bezel frame responsive to real device aspect ratio
- [ ] Add tooltips to capture/record buttons
- [ ] Improve recording indicator (pulsing animation + time counter)

## Related Code Files

| File | Change Type |
|------|------------|
| `Components/TabBarView.swift` | Icons, rename, remove Guide tab |
| `Components/StatusBarView.swift` | Height, conditional metrics |
| `Components/EmptyStateView.swift` | No changes needed |
| `Views/Sidebar/SidebarView.swift` | Bottom actions cleanup, dynamic version |
| `Views/Console/ConsoleView.swift` | Empty state, filter count |
| `Views/Network/NetworkView.swift` | Empty state, filter spacing |
| `Views/Performance/PerformanceView.swift` | Empty state, N/A cards |
| `Views/Feedback/FeedbackView.swift` | Form sizing, thumbnail sizing |
| `Views/Device/DeviceView.swift` | Responsive bezel, tooltips, recording UX |
| `Models/AppState.swift` | Remove guide from AppTab.allCases iteration |

## Implementation Steps

### Step 1: TabBarView Improvements (15 min)
- Rename to "TTBDebugPlus"
- Add SF Symbol icons alongside tab text
- Filter out `.guide` from `ForEach(AppTab.allCases)` in tab bar

### Step 2: StatusBarView Improvements (10 min)
- Increase frame height to 32
- Conditionally show/hide CPU/memory when no device connected
- Add small dividers between metric groups

### Step 3: Empty States (20 min)
- ConsoleView: Add `EmptyStateView` when `viewModel.filteredEntries.isEmpty`
- NetworkView: Add `EmptyStateView` when no requests in `requestList`
- PerformanceView: Add empty state overlay when no metrics history

### Step 4: ConsoleView Filter Polish (10 min)
- Add count badge to "All" filter pill
- Make column headers flexible with `minWidth` instead of fixed

### Step 5: NetworkView Filter Spacing (10 min)
- Increase pill horizontal padding from 6→10
- Wrap bottom bar in `ScrollView(.horizontal)` for narrow windows

### Step 6: PerformanceView Polish (15 min)
- Show "N/A" metric cards when FPS/Disk are nil (never hide entirely)
- Add spacing padding between analytics rows
- Empty state for charts

### Step 7: FeedbackView Form Sizing (10 min)
- Textarea maxHeight: 100 → 200
- Tag pills: horizontal padding 10→14, vertical 5→8
- Screenshot thumbnails: 60×80 → 80×110

### Step 8: DeviceView UI Polish (20 min)
- Add `.help()` tooltips to capture/record buttons
- Animate recording indicator with pulsing effect + duration counter
- Make bezel dimensions reactive to screenshot aspect ratio

### Step 9: SidebarView Cleanup (10 min)
- Bottom actions: use single column layout with subtle hover background
- Dynamic version from Bundle

## Todo List

- [ ] TabBarView: rename, add icons, remove guide tab
- [ ] StatusBarView: height, conditional metrics
- [ ] ConsoleView: empty state, filter count
- [ ] NetworkView: empty state, filter spacing
- [ ] PerformanceView: empty state, N/A cards
- [ ] FeedbackView: form sizing
- [ ] DeviceView: tooltips, recording animation
- [ ] SidebarView: bottom actions, dynamic version

## Success Criteria

- No blank screens when no data — every view has an empty state
- Tab bar is scannable with icons
- Status bar is readable and not cramped
- Filters are easy to tap/click on macOS (large enough targets)
- All layouts work at min window size (1200×800) without clipping

## Risk Assessment

| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| Layout breaks at edge sizes | Low | Medium | Test at min/max window sizes |
| AppTab.allCases change breaks menus | Low | Low | Keep guide case, just filter in TabBarView |

## Next Steps
After Phase 2, proceed to Phase 3 (Design System Refinements).
