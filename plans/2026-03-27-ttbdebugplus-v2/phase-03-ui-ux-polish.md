# Phase 03: UI/UX Polish & Standardization

**Parent:** [plan.md](./plan.md)
**Date:** 2026-03-27
**Created By:** TuanTruong
**Priority:** 🟡 High
**Status:** ⬜ Pending

## Overview

Standardize the UI/UX across all views to feel cohesive and professional. Inspired by Pulse Pro's clean, native macOS feel and Proxyman's polished interactions.

## Key Insights

- Pulse Pro: Table + text toggle, keyboard nav, resizable panels
- Proxyman: Split-view with draggable dividers, contextual menus
- Apple HIG: Use semantic colors, SF Symbols, proper spacing
- Current gaps: inconsistent spacing, missing keyboard shortcuts, no context menus

## Requirements

### 1. Keyboard Shortcuts (macOS Standard)
| Shortcut | Action |
|----------|--------|
| `⌘K` | Clear current tab's logs |
| `⌘F` | Focus search field |
| `⌘⇧F` | Toggle advanced filter panel |
| `↑/↓` | Navigate log/request entries |
| `⏎` | Open selected entry detail |
| `⌘C` | Copy selected entry |
| `⌘⇧E` | Export current session |
| `⌘D` | Pin/unpin selected entry |
| `Esc` | Close detail panel |

### 2. Context Menus (Right-Click)
- Network request → Copy URL / Copy cURL / Pin / Copy Request Body / Copy Response Body
- Console entry → Copy Message / Copy Full Entry / Pin / Copy Payload
- Device → Disconnect / Capture Screenshot / Clear Logs

### 3. Resizable Split Panels
- Network: list ↔ detail panel resizable divider
- Console: log list ↔ detail panel resizable divider
- Current fixed layout → `HSplitView` or custom `GeometryReader`

### 4. Empty States Upgrade
- Each tab: custom illustration + actionable CTA
- Console empty: "No log entries yet — Connect a device to start capturing"
- Network empty: "No API requests captured — Start your iOS app"
- Performance empty: "Waiting for metrics — Connect a device"

### 5. Status Bar Polish
- Show: connection status • device name • log counts • memory/CPU
- Animate status transitions (pulse for "connecting")
- Click device name → switch device dropdown

### 6. Toolbar Refinements
- Add search field to toolbar (⌘F focuses it)
- Add "Clear" button with ⌘K shortcut
- Show "Recording" indicator when live streaming

### 7. Visual Consistency Pass
- Standardize all padding: 16px horizontal, 12px vertical for content areas
- Standardize card corner radius: 12px
- Standardize font usage across all views (audit TTFont usage)
- Ensure all icons use SF Symbols v5
- Remove any remaining hardcoded colors → use semantic `Color.tt*` tokens
- Add hover effects to all interactive rows
- Add smooth transitions for panel show/hide

### 8. Accessibility
- VoiceOver labels for all interactive elements
- Minimum touch target size 44pt
- Sufficient contrast ratios (WCAG AA)

## Architecture

```
Components/
  TabBarView.swift              [MODIFY] — Add search, recording indicator
  StatusBarView.swift           [MODIFY] — Device switcher, animations
  EmptyStateView.swift          [MODIFY] — Per-tab customization

Views/Console/
  ConsoleView.swift             [MODIFY] — Resizable split, context menus, keyboard
  
Views/Network/
  NetworkView.swift             [MODIFY] — Resizable split, context menus, keyboard
  
Views/Device/
  DeviceView.swift              [MODIFY] — Context menus

All Views:
  [MODIFY] — Consistent padding, spacing, hover effects
```

## Implementation Steps

1. Implement keyboard shortcut system
   - `.keyboardShortcut()` modifiers on buttons
   - `@FocusedValue` for search field focus
   - Arrow key navigation via `.onKeyPress`

2. Add context menus
   - `.contextMenu {}` on request rows
   - `.contextMenu {}` on console entries
   - `.contextMenu {}` on device items

3. Implement resizable split panels
   - `HSplitView` for Network list ↔ detail
   - `HSplitView` for Console list ↔ detail
   - Remember panel sizes via `@AppStorage`

4. Polish empty states
   - Custom icons per tab
   - Actionable CTAs (Connect, Open Guide)

5. Polish status bar
   - Add device name tap → menu
   - Add connection pulse animation
   - Smooth transitions

6. Visual consistency audit
   - Walk through every view
   - Standardize spacing/padding
   - Add hover effects to rows
   - Ensure font consistency

7. Accessibility pass
   - Add `.accessibilityLabel()` to icons
   - Test with VoiceOver

## Success Criteria

- [ ] All keyboard shortcuts functional
- [ ] Context menus on all interactive elements
- [ ] Resizable panels in Network and Console
- [ ] Consistent padding/spacing across all views
- [ ] Empty states with custom illustrations
- [ ] Status bar shows live device info
- [ ] Build passes

## Risk Assessment

- **Low:** Pure SwiftUI — all native APIs
- **Medium:** `onKeyPress` requires macOS 14+ (already target)
- **Low:** Context menus well-supported in SwiftUI
