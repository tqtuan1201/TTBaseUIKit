# Phase 05: UI/UX Optimization & View Refactor

**Parent Plan:** [plan.md](plan.md)
**Dependencies:** Phase 01–04
**Date:** 2026-03-29
**Created By:** TuanTruong
**Priority:** P2 — Medium
**Status:** ⬜ TODO
**Review:** ⬜ Pending

## Overview

Decompose large monolithic views into focused sub-components. Optimize UI/UX with better animations, accessibility, and responsiveness. Target: no view file exceeds ~350 lines.

## Key Insights

- NetworkView.swift: 1223 lines — needs 3-4 sub-views
- AnnotationEditorView.swift: 922 lines — needs 2-3 sub-views
- DeviceView.swift: 870 lines — needs 3 sub-views
- JSONViewer.swift: 869 lines — needs 2 sub-views
- ScreenCaptureViewModel.swift: 665 lines — needs refactoring
- ConsoleView.swift: 494 lines — borderline, can be improved

## Requirements

1. Split large views into focused sub-components (< 350 lines each)
2. Extract reusable components into Components/
3. Improve animation and micro-interactions
4. Add accessibility labels to interactive elements
5. Improve responsive layout for window resizing
6. Optimize list performance with LazyVStack where not already used

## Architecture

### NetworkView Split Plan

```
NetworkView.swift (1223 → ~200 lines — container)
├── NetworkFilterBar.swift    (~150 lines — search, method filter, status filter)
├── NetworkRequestList.swift  (~250 lines — LazyVStack of request rows)  
├── NetworkRequestRow.swift   (~100 lines — single request row)
├── NetworkDetailPane.swift   (~300 lines — headers, body, timing tabs)
└── NetworkStatsView.swift    (exists, keep as-is)
```

### DeviceView Split Plan

```
DeviceView.swift (870 → ~200 lines — container)
├── DeviceInfoPanel.swift     (~200 lines — device info cards)
├── ScreenCapturePanel.swift  (~200 lines — screenshot preview + controls)
├── RecordingPanel.swift      (~150 lines — recording controls + export)
└── DeviceActionsBar.swift    (~100 lines — action buttons)
```

### AnnotationEditorView Split Plan

```
AnnotationEditorView.swift (922 → ~250 lines — canvas + tool routing)
├── AnnotationToolbar.swift   (~150 lines — tool selection bar)
├── AnnotationCanvas.swift    (~300 lines — drawing layer)
└── AnnotationPropertiesPanel.swift (~100 lines — color, stroke)
```

### JSONViewer Split Plan

```
JSONViewer.swift (869 → ~200 lines — container)
├── JSONSyntaxHighlightView.swift (~300 lines — syntax highlighting)
├── JSONTreeNodeView.swift    (~200 lines — tree node rendering)
└── JSONViewerToolbar.swift   (~100 lines — copy, expand/collapse)
```

## Related Code Files

- All files in `Views/Network/`, `Views/Device/`, `Views/Shared/`
- `Components/` — shared components
- `DesignSystem/` — design tokens and reusable styles

## Implementation Steps

1. **NetworkView refactor**
   - Extract `NetworkFilterBar` — search + method + status filters
   - Extract `NetworkRequestList` — scrollable list with LazyVStack
   - Extract `NetworkRequestRow` — single row component
   - Extract `NetworkDetailPane` — tabbed detail view
   - Keep NetworkView as thin container
2. **DeviceView refactor**
   - Extract `DeviceInfoPanel` — device info cards
   - Extract `ScreenCapturePanel` — screenshot preview
   - Extract `RecordingPanel` — recording controls
   - Keep DeviceView as layout container
3. **AnnotationEditorView refactor**
   - Extract `AnnotationToolbar` — tool buttons
   - Extract `AnnotationCanvas` — drawing layer (keep gesture handling here)
   - Extract `AnnotationPropertiesPanel` — color/stroke settings
4. **JSONViewer refactor**
   - Extract `JSONSyntaxHighlightView` — code rendering
   - Extract `JSONTreeNodeView` — recursive tree node
5. **UI/UX Polish**
   - Add `.transition()` modifiers for panel show/hide
   - Add `.animation(.spring)` for filter changes
   - Add `accessibilityLabel` to all interactive elements
   - Use `LazyVStack` in all list-heavy views
   - Test window resize from min (1200×800) to full screen

## Todo List

- [ ] Split NetworkView into 4 sub-views
- [ ] Split DeviceView into 3 sub-views
- [ ] Split AnnotationEditorView into 3 sub-views
- [ ] Split JSONViewer into 2-3 sub-views
- [ ] Add transitions and micro-animations
- [ ] Add accessibility labels
- [ ] Optimize list performance with LazyVStack
- [ ] Test responsive layout at various window sizes

## Success Criteria

- [ ] No view file exceeds 350 lines
- [ ] All extracted views render correctly
- [ ] No behavioral regressions
- [ ] Animations feel smooth (60fps)
- [ ] VoiceOver reads interactive elements correctly
- [ ] Window resizing works cleanly

## Risk Assessment

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| State passing broken after split | Medium | High | Use @Binding + @Environment |
| Layout regressions | Medium | Medium | Test each split in isolation |
| Performance regression from extra views | Low | Low | Profile with Instruments |
