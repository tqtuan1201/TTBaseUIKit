# Phase 2: Pro Annotation Editor

> Parent: [plan.md](plan.md) | Depends on: Phase 1

**Date:** 2026-03-28
**Created By:** TuanTruong
**Status:** Draft
**Priority:** P0 — Core Feature
**Implementation Status:** Pending
**Review Status:** Pending

## Key Insights

Current AnnotationCanvasView has basic tools (freehand, arrow, rect, ellipse, text, eraser) in a cramped inline toolbar. Missing critical QA tools: step counter, blur, highlight, spotlight. The annotation happens inside a tiny 216×400pt area — unusable for detailed work.

Inspiration: CleanShot X annotation editor opens in a full dedicated window/sheet.

## Requirements

1. **Full-screen annotation mode** — Opens as sheet/overlay, not inline in tiny preview
2. **Step Counter tool** — Auto-incrementing numbered circles (1, 2, 3...)
3. **Blur/Pixelate tool** — Drag to define region, blur content underneath
4. **Highlight tool** — Semi-transparent marker for emphasis
5. **Spotlight tool** — Dims everything except selected region
6. **Improved toolbar** — Grouped tools with clear labels, keyboard shortcuts
7. **Zoom & pan** — Pinch/scroll zoom with pan for detail work
8. **Line width picker** — Visual slider with preview
9. **Color picker** — Preset palette + custom color via system picker

## Architecture

### New AnnotationEditorView (replaces inline mode)

```
┌────────────────────────────────────────────────────┐
│ Toolbar: [Draw][Arrow][Rect][Circle][Text][Step#]  │
│          [Blur][Highlight][Spotlight][Eraser]       │
│          [Color●] [Width━━] | [Undo][Redo][Clear]  │
│          [Zoom fit] [Zoom 100%]     [Cancel][Done]  │
├────────────────────────────────────────────────────┤
│                                                    │
│              Zoomable/Pannable Canvas               │
│                                                    │
│    ┌──────────────────────────────────────┐         │
│    │                                      │         │
│    │       Screenshot with Annotations    │         │
│    │                                      │         │
│    │       ① Click here                   │         │
│    │       ② Then here ────→              │         │
│    │       ③ ████ blurred area ████       │         │
│    │                                      │         │
│    └──────────────────────────────────────┘         │
│                                                    │
│ Status: "Step Counter — Click to place next step"  │
└────────────────────────────────────────────────────┘
```

### New Annotation Tools

```swift
enum AnnotationTool: String, CaseIterable {
    case freehand       // Existing: pencil drawing
    case arrow          // Existing: arrow with head
    case rectangle      // Existing: rect outline
    case ellipse        // Existing: ellipse outline
    case text           // Existing: text label
    case stepCounter    // NEW: numbered circle (auto-increment)
    case blur           // NEW: drag region to pixelate
    case highlight      // NEW: semi-transparent marker
    case spotlight      // NEW: dim everything except region
    case eraser         // Existing: remove annotations
}
```

## Related Code Files

- `Views/Device/AnnotationCanvasView.swift` — Major rewrite → `AnnotationEditorView.swift`
- `ViewModels/ScreenCaptureViewModel.swift` — Add new annotation types to AnnotationItem
- `Models/AnnotationItem.swift` — Extract to separate file, add step number, blur region

## Implementation Steps

### 1. Create AnnotationEditorView as full-sheet
- Present as `.sheet(isPresented:)` covering full window
- Accept base image + existing annotations
- Return modified annotations on Done

### 2. Add new tool types to AnnotationTool enum
- `stepCounter`: Places numbered circle at tap location
- `blur`: Define rect region, render pixelated content
- `highlight`: Semi-transparent yellow/colored stroke
- `spotlight`: Overlay dark mask with cutout at drag region

### 3. Enhanced toolbar
- Group tools into sections: Draw | Shape | Annotate | Edit
- Each tool shows icon + name on hover
- Color palette row: 8 preset colors + "Custom..." button
- Line width: mini slider or segmented (Thin/Medium/Thick)

### 4. Zoom & pan canvas
- Wrap canvas in `ScrollView` with `MagnificationGesture`
- Fit-to-window by default, support 100%, 200% zoom
- Toolbar buttons: "Fit", "1x", "2x"

### 5. Step counter rendering
- Numbered circles with configurable color and size
- Auto-increment counter state managed in AnnotationEditorView
- Rendered as filled circle + white number

### 6. Blur region rendering
- Capture rect region via drag
- In Canvas render phase: clip to region, apply pixelate effect
- Use CIFilter pixelate or manual downscale+upscale trick

### 7. Keyboard shortcuts
- ⌘Z: Undo, ⌘⇧Z: Redo
- 1-0: Select tools 
- Delete: Remove selected annotation
- Escape: Exit annotation mode

## Todo

- [ ] Create AnnotationEditorView as sheet
- [ ] Add stepCounter tool + rendering
- [ ] Add blur/pixelate tool + rendering
- [ ] Add highlight tool + rendering
- [ ] Add spotlight tool + rendering
- [ ] Enhanced toolbar with grouped tools
- [ ] Zoom & pan support
- [ ] Color picker with system picker integration
- [ ] Line width visual picker
- [ ] Keyboard shortcuts
- [ ] Step counter auto-increment logic

## Success Criteria

- Annotation opens full-screen with comfortable workspace
- Step counter creates numbered circles (1, 2, 3...)
- Blur tool effectively hides sensitive content
- All tools accessible via keyboard shortcuts
- Existing annotations preserved backward-compatible

## Risk Assessment

- **Medium**: Blur/pixelate using CIFilter in SwiftUI Canvas — may need fallback to NSImage rendering
- **Low**: Step counter and highlight are straightforward overlay draws
- **Low**: Spotlight is dark overlay with rect cutout
