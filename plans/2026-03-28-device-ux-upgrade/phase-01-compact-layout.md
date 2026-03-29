# Phase 1: Compact Layout & Capture Controls

> Parent: [plan.md](plan.md)

**Date:** 2026-03-28
**Created By:** TuanTruong
**Status:** Draft
**Priority:** P0 — Foundation
**Implementation Status:** Pending
**Review Status:** Pending

## Key Insights

The current DeviceView has an oversized iPhone bezel (240×480pt hardcoded) that wastes screen real estate. The split-pane HSplitView layout is functional but the left panel is too wide for just displaying a screenshot. The gallery panel in the right is good but disconnected from the workflow.

## Requirements

1. Remove decorative iPhone bezel — show screenshot at natural aspect ratio
2. Constrain preview height (max 400pt, auto-scale)
3. Compact capture controls toolbar (inline, not separate card)
4. Recording controls with visual timer + frame count
5. Thumbnail strip at bottom of preview (horizontal scroll)
6. Device info collapsed by default (disclosure group)
7. Gallery panel as right sidebar with multi-select preserved

## Architecture

### New DeviceView Layout (single column, no HSplitView)

```
┌──────────────────────────────────────────────────────┐
│ Header: Device name + status + toolbar buttons       │
├──────────────┬───────────────────────────────────────┤
│              │                                       │
│  Preview     │   Gallery Grid                        │
│  (compact)   │   (multi-select, sort, delete)        │
│  max 400pt   │                                       │
│              │                                       │
│  ┌────────┐  │   ┌──┐ ┌──┐ ┌──┐ ┌──┐               │
│  │captured│  │   │  │ │  │ │  │ │  │               │
│  │ image  │  │   └──┘ └──┘ └──┘ └──┘               │
│  └────────┘  │   ┌──┐ ┌──┐ ┌──┐ ┌──┐               │
│              │   │  │ │  │ │  │ │  │               │
│  [📷][⏺][💾]  │   └──┘ └──┘ └──┘ └──┘               │
│              │                                       │
│  ▶ Device    │   Footer: X screenshots | Export All  │
│    Info      │                                       │
├──────────────┴───────────────────────────────────────┤
│ Appearance toggle | More controls                    │
└──────────────────────────────────────────────────────┘
```

## Related Code Files

- `Views/Device/DeviceView.swift` — Complete rewrite
- `ViewModels/ScreenCaptureViewModel.swift` — Simplify gallery state
- `Views/Device/AnnotationCanvasView.swift` — Untouched in this phase

## Implementation Steps

### 1. Redesign DeviceView layout
- Replace HSplitView with NavigationSplitView or GeometryReader-based responsive layout
- Keep header compact (single line)
- Preview: remove bezel, natural aspect ratio, max-height 400pt
- Capture toolbar: inline icon buttons (Camera, Record, Annotate, Save, Share)

### 2. Compact capture controls
- Toolbar style: icon buttons with tooltips (not labeled buttons in cards)
- Recording: red dot + timer inline in toolbar
- Interval selector: small popover from record button

### 3. Thumbnail strip
- Horizontal ScrollView below preview
- 50×80pt thumbnails with selection ring
- Click to view, right-click for context menu

### 4. Collapsible device info
- DisclosureGroup "Device Info" — collapsed by default
- Same infoRow layout but inside disclosure

### 5. Gallery panel (right side)
- Keep existing grid/list toggle, sort, multi-select
- Add "Open in Annotator" action
- Add "Create Bug Report" action per screenshot

## Todo

- [ ] Remove iPhone bezel from preview
- [ ] Constrain preview max-height
- [ ] Inline capture toolbar (icons-only with tooltips)
- [ ] Thumbnail strip below preview
- [ ] DisclosureGroup for device info
- [ ] Responsive layout (GeometryReader or HSplitView)
- [ ] Recording timer in toolbar
- [ ] Interval popover from record button

## Success Criteria

- Preview area is ≤ 400pt tall regardless of screenshot size
- Capture controls fit in a single toolbar row
- Device info is hidden until user expands it
- Gallery shows grid of screenshots with bulk actions
- Recording shows visual timer + frame count

## Risk Assessment

- **Low**: Layout changes only, no protocol changes needed
- **Low**: All existing ScreenCaptureViewModel APIs preserved
