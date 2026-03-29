# Phase 02: Layout Bug Fixes + UI/UX Professional Upgrade

> **Parent Plan:** [plan.md](./plan.md)
> **Dependencies:** Phase 01 (device-aware data)
> **Docs:** [docs/system-architecture](../../docs/)

## Overview

- **Date:** 2026-03-29
- **Created By:** TuanTruong
- **Description:** Fix all layout bugs in the Network view and upgrade to a professional Proxyman-level UI/UX. Address visual polish, spacing, hover effects, keyboard navigation, and responsive layout.
- **Priority:** P0 — Critical
- **Implementation Status:** `[ ]` Pending
- **Review Status:** `[ ]` Not reviewed

## Key Insights

### Identified Layout Bugs (from screenshot + code analysis)

1. **Filter bar overflow**: At narrow widths, filter pills + search + status filter overflow horizontally — no wrapping or adaptive collapse
2. **Column alignment**: URL column truncation doesn't show tooltip of full URL on hover
3. **Detail pane minimum width**: Set to 400px but can cause content squeeze on 13" displays
4. **Waterfall bar** fixed at 100px — too small to be useful at scale
5. **Bottom bar buttons**: "Postman" and "Share cURL" float awkwardly with too much spacing
6. **Empty state**: Generic icon + text, no visual hierarchy
7. **Missing hover states** on request rows — no visual feedback that rows are clickable
8. **No alternating row colors** — hard to scan long lists
9. **View mode toggle** (Requests/Analytics) is plain text — no visual containment

### UX Issues

1. **No keyboard navigation** — can't arrow up/down through requests
2. **No URL tooltip** on hover for truncated URLs
3. **Search scope pills** too small, hard to click
4. **No "back to list" gesture** when detail pane is shown
5. **Detail pane** has no mini-summary header (status + method + URL)
6. **Cookies tab** always shows empty — should hide when no cookies

## Requirements

- [ ] Fix all 6 layout bugs listed above
- [ ] Add hover highlighting on request rows
- [ ] Add alternating row backgrounds (subtle)
- [ ] Add URL tooltip on hover
- [ ] Add request summary header at top of detail pane
- [ ] Add keyboard up/down navigation for requests
- [ ] Upgrade view mode toggle to segmented control style
- [ ] Improve filter bar responsiveness (adaptive collapse)
- [ ] Add micro-animations for list selection and detail transitions
- [ ] Professional polish: consistent spacing, refined typography

## Architecture

No architectural changes. All modifications are UI-layer only.

## Related Code Files

| File | Change Type | Purpose |
|------|------------|---------|
| `Views/Network/NetworkView.swift` | MODIFY | Fix layouts, add hover/keyboard, upgrade UI |
| `Views/Network/NetworkStatsView.swift` | MODIFY | Visual polish for analytics |
| `DesignSystem/Colors.swift` | MODIFY | Add alternating row color token |
| `DesignSystem/CardView.swift` | MODIFY | Add reusable tooltip modifier |

## Implementation Steps

### Step 1: Fix Filter Bar Overflow
- Wrap filters in a `ViewThatFits` or prioritize: search always visible, pills collapse to menu at narrow widths
- Move "N requests" count to bottom bar to free space

### Step 2: Add Row Hover States
```swift
@State private var hoveredId: String? = nil

.onHover { isHover in
    hoveredId = isHover ? request.id : nil
}
.background(
    hoveredId == request.id ? Color.ttSurface.opacity(0.4) : Color.clear
)
```

### Step 3: Add Alternating Row Backgrounds
```swift
.background(index % 2 == 0 ? Color.clear : Color.ttSurface.opacity(0.08))
```

### Step 4: Add URL Tooltip
```swift
.help(request.url) // Native macOS tooltip
```

### Step 5: Request Summary in Detail Pane Header
Add a compact summary bar:
```
[POST] 400 | /v1/auth/login | 1ms | 178 B
```
With colored status code and method badge.

### Step 6: Keyboard Navigation
```swift
.onKeyPress(.upArrow) { selectPrevious(); return .handled }
.onKeyPress(.downArrow) { selectNext(); return .handled }
```

### Step 7: Upgrade View Mode Toggle
Replace plain text buttons with a proper segmented control:
```swift
Picker("Mode", selection: $viewMode) {
    ForEach(NetworkViewMode.allCases, id: \.self) { mode in
        Text(mode.rawValue).tag(mode)
    }
}
.pickerStyle(.segmented)
```

### Step 8: Detail Pane Summary Header
Above the tab picker, add:
- Method badge + Status code + URL path (truncated with tooltip)
- Response time + Size
- Device badge (from Phase 01)

### Step 9: Hide Empty Cookies Tab
Only show cookies tab if response contains Set-Cookie header.

### Step 10: Micro-animations
- Fade-in for new requests (`.transition(.opacity)`)
- Smooth detail pane expand/collapse
- Subtle scale on row selection

## Todo List

- [ ] Fix filter bar overflow with `ViewThatFits` or adaptive layout
- [ ] Add hover highlighting on request rows
- [ ] Add alternating row backgrounds
- [ ] Add `.help()` tooltip on URL text
- [ ] Add request summary header in detail pane
- [ ] Implement keyboard up/down navigation
- [ ] Upgrade view mode to segmented control
- [ ] Add detail pane summary header (method + status + url + time + size)
- [ ] Conditionally hide empty Cookies tab
- [ ] Add fade-in transition for new requests
- [ ] Polish spacing, padding, typography consistency
- [ ] Test on 13" and 27" displays for responsive layout

## Success Criteria

- [ ] No visual overflow at minimum window width (900px)
- [ ] Rows have visible hover feedback
- [ ] URL tooltip appears on hover for truncated URLs
- [ ] Keyboard nav works for request selection
- [ ] Detail pane shows clear summary header
- [ ] All animations are smooth (60fps)
- [ ] Overall look matches Proxyman/Chrome DevTools quality level

## Risk Assessment

| Risk | Impact | Mitigation |
|------|--------|------------|
| `onKeyPress` requires macOS 14+ | Medium | Check deployment target, fallback to `.onCommand()` |
| Hover state performance with 1000+ rows | Low | Only track single `hoveredId`, no per-row state |
| Segmented picker style mismatch with dark theme | Low | Custom segmented control if needed |

## Next Steps

→ Phase 03: Functionality Audit + Fixes
