# Research: Performance & UX Analysis

**Date:** 2026-03-29
**Type:** Performance Audit

## Performance Issues

### P1 — Critical

1. **`filteredEntries` computed property** (`NetworkViewModel`)
   - Re-filters + re-sorts entire array on every SwiftUI body access
   - Multiple chained `.filter()` calls + `.sort()` = O(n log n) per render
   - **Fix**: Cache filtered results, invalidate on state change

2. **DateFormatter allocation in row bodies**
   - `formattedTimestamp` creates new `DateFormatter()` per access
   - Called per row in `LazyVStack` = thousands of allocations  
   - **Fix**: Static cached formatter

3. **`syncFromConnectionManager`** creates new array every sync
   - Iterates all devices × all logs, creates new `NetworkRequestEntry` each time
   - No diffing — replaces entire `entries` array
   - **Fix**: Incremental updates, diff-based merge

### P2 — Important

4. **NSImage retention in `screenshotHistory`**
   - Stores up to 50 full `NSImage` objects in memory
   - No thumbnail generation → full-res images in gallery grid
   - **Fix**: Generate thumbnails for gallery, load full-res on demand

5. **Recording timer on main thread**
   - `Timer.scheduledTimer` fires on main thread
   - Screenshot requests + elapsed time updates block UI
   - **Fix**: Use `DispatchSourceTimer` on background queue

6. **`AnnotationEditorView` re-renders full canvas**
   - Drawing overlays re-render all annotations on every gesture update
   - **Fix**: Use `Canvas` view or layer-based rendering

### P3 — Nice to Have

7. **Inline URL parsing** in `urlPath`, `urlDomain`, `extractHost`
   - `URLComponents(string:)` called multiple times per entry per render
   - **Fix**: Pre-parse on entry creation

8. **Multiple `Dictionary(grouping:)` calls** in statistics computed properties
   - `methodDistribution`, `statusDistribution`, `deviceDistribution` etc.
   - All iterate full entries array independently
   - **Fix**: Single-pass stats computation

## UX Issues for Commercialization

### Must Fix
1. **No light mode** — Forces `.dark`, excludes users who prefer light
2. **No empty onboarding** — Cold-start shows blank screens with no guidance
3. **Keyboard navigation** — Only NetworkView has key handlers
4. **No undo/redo persistence** — Annotation undo stack lost on view switch
5. **Large views crash SwiftUI compiler** — 1200+ line views slow Xcode

### Should Fix
1. **No drag-and-drop** — Should support dragging screenshots to Finder/Slack
2. **No window state persistence** — Split view positions not saved
3. **No search in JSON Editor** — Find & replace missing
4. **Console auto-scroll** — No "follow tail" mode

### Nice to Have
1. **Theme customization** — Let users pick accent color
2. **Export preferences** — Remember last export format/location
3. **Notification sounds** — Audio cues for new device connection
