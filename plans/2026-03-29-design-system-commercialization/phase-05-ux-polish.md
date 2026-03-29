# Phase 5: UI/UX Polish & Commercialization

> Parent: [plan.md](plan.md)
> Depends on: [Phase 4](phase-04-performance.md)

## Overview

**Date:** 2026-03-29
**Priority:** Medium-High
**Status:** ⬜ TODO
**Estimated Effort:** 8h

Polish UI/UX for commercial-grade quality: keyboard navigation across all views, empty states with onboarding cues, improved accessibility, drag-and-drop support, and window state persistence.

## Key Insights

- Proxyman-level polish: contextual actions, keyboard shortcuts, drag-and-drop
- Only NetworkView has keyboard navigation — all views should support it
- Empty states need actionable guidance (not just "no data")
- macOS developers expect keyboard-first workflows
- Accessibility is a commercial requirement (enterprise customers)

## Requirements

1. Keyboard navigation in Console, Device, DevTools views
2. Enhanced empty states with onboarding actions
3. Drag-and-drop for screenshots (to Finder/Slack)
4. Window state persistence (split positions, selected tab)
5. Consistent focus indicators across views
6. Accessibility labels on all interactive elements

## Implementation Steps

### 1. Global Keyboard Navigation
Add keyboard handlers to each main view:
- **ConsoleView**: ↑/↓ navigate logs, ⌘K clear, ⌘F focus search
- **DeviceView**: ←/→ navigate gallery, Space toggle preview, Delete remove
- **DevToolsView**: Tab switch between tools, ⌘⏎ execute query

### 2. Enhanced Empty States
Update `EmptyStateView` to support:
- Primary action button ("Connect a Device", "Send a Request")
- Secondary link ("View Integration Guide")
- Animated icon or subtle animation

### 3. Drag-and-Drop for Screenshots
```swift
// ScreenshotItem conformance to NSItemProvider
extension ScreenshotItem: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .png) { item in
            item.image.tiffRepresentation.flatMap {
                NSBitmapImageRep(data: $0)?.representation(using: .png, properties: [:])
            } ?? Data()
        }
    }
}
```

### 4. Window State Persistence
```swift
// Save/restore using @AppStorage
@AppStorage("selectedTab") var selectedTab: String = "console"
@AppStorage("sidebarWidth") var sidebarWidth: Double = 230
@AppStorage("detailPaneVisible") var detailPaneVisible: Bool = true
```

### 5. Focus Indicators
```swift
// Consistent focus ring across all interactive elements
struct TTFocusStyle: ViewModifier {
    @FocusState var isFocused: Bool
    
    func body(content: Content) -> some View {
        content
            .focusable()
            .focused($isFocused)
            .overlay(
                RoundedRectangle(cornerRadius: TTRadius.sm)
                    .stroke(Color.ttPrimary.opacity(isFocused ? 0.5 : 0), lineWidth: 2)
            )
    }
}
```

### 6. Accessibility Labels
- All buttons: descriptive `.accessibilityLabel()`  
- All status indicators: `.accessibilityValue()` with state
- Navigation: `.accessibilityElement(children: .contain)`
- Images: `.accessibilityLabel()` with description

### 7. Tooltip System
Add `.help()` modifiers to all toolbar buttons and interactive elements that don't have them.

## Todo List

- [ ] Keyboard navigation — ConsoleView
- [ ] Keyboard navigation — DeviceView
- [ ] Keyboard navigation — DevToolsView
- [ ] Enhanced EmptyStateView with action buttons
- [ ] Drag-and-drop for screenshots
- [ ] Window state persistence (@AppStorage)
- [ ] Focus indicators (TTFocusStyle)
- [ ] Accessibility labels across all views
- [ ] Tooltips on all toolbar buttons

## Success Criteria

- Every view responds to ↑/↓ keyboard navigation
- Empty states have actionable primary buttons
- Screenshots draggable to Finder
- Tab selection persists across app restarts
- VoiceOver reads all interactive elements correctly

## Risk Assessment

- **Low-Medium risk** — mostly additive changes
- Drag-and-drop requires testing with different macOS versions
- Focus management can conflict with existing key handlers
