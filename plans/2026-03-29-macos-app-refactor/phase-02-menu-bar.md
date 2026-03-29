# Phase 02: Menu Bar Integration

**Parent Plan:** [plan.md](plan.md)
**Dependencies:** Phase 01 (Xcode Project)
**Date:** 2026-03-29
**Created By:** TuanTruong
**Priority:** P1 — High
**Status:** ⬜ TODO
**Review:** ⬜ Pending

## Overview

Add a `MenuBarExtra` scene to TTBDebugPlus so users can quickly access app status, perform common actions, and manage connections without keeping the main window visible.

## Key Insights

- `MenuBarExtra` is SwiftUI-native (macOS 13+), our target is 14+ → fully supported
- Use `.menuBarExtraStyle(.window)` for richer UI, `.menu` for simple dropdown
- Can coexist with `WindowGroup` and `Settings` scenes
- Shared state via `@Observable` ConnectionManager — already in place
- Optional `LSUIElement` mode for menu-bar-only (advanced preference)

## Requirements

1. Menu bar icon visible when app is running
2. Show server status (running/stopped) with toggle
3. Show connected devices count + list
4. Quick actions: Clear logs, Capture screenshot, Start/Stop server
5. "Open Main Window" button
6. "Quit" button (essential if hiding Dock icon)
7. Optional: notification when device connects

## Architecture

### Menu Bar View Hierarchy

```
MenuBarView
├── Server Status Section
│   ├── Status indicator (green/red dot)
│   ├── Port display
│   └── Start/Stop toggle
├── Connected Devices Section
│   ├── Device count badge
│   └── ForEach(devices) → MenuBarDeviceRow
├── Quick Actions Section
│   ├── Clear All Logs
│   ├── Capture Screenshot
│   └── Export Session
├── Divider
├── Open Main Window
├── Preferences...
└── Quit TTBDebugPlus
```

## Related Code Files

- `TTBDebugPlusApp.swift` — add MenuBarExtra scene here
- `Services/Discovery/ConnectionManager.swift` — shared state
- `Models/AppState.swift` — app-wide state
- `DesignSystem/Colors.swift` — design tokens

## Implementation Steps

1. Create `Components/MenuBar/MenuBarView.swift`
   - Server status with toggle button
   - Connected devices list with status indicators
   - Quick actions (clear, screenshot, export)
   - Open window + Quit buttons
2. Create `Components/MenuBar/MenuBarDeviceRow.swift`
   - Compact device info display
   - Online/offline indicator
3. Modify `TTBDebugPlusApp.swift`
   - Add `MenuBarExtra` scene alongside `WindowGroup`
   - Share `ConnectionManager` via environment
   - Add `openWindow` environment action for "Open Main Window"
4. Create menu bar icon asset in `Assets.xcassets`
   - 16px icon in 22px transparent square (menu bar standard)
   - Template image for proper light/dark mode rendering
5. Optional: Add `@AppStorage("hideDockIcon")` preference
   - Modify Info.plist dynamically or at next launch

## Todo List

- [ ] Create `MenuBarView.swift` with server status + quick actions
- [ ] Create `MenuBarDeviceRow.swift` for device list
- [ ] Create menu bar icon asset (template image)
- [ ] Add `MenuBarExtra` scene to `TTBDebugPlusApp`
- [ ] Wire `openWindow` to open/focus main window
- [ ] Add Quit button
- [ ] Test menu bar renders on macOS 14
- [ ] Test state syncs between menu bar and main window

## Success Criteria

- [ ] Menu bar icon appears when app launches
- [ ] Server status reflects real state
- [ ] Connected devices list updates in real-time
- [ ] "Open Main Window" opens/focuses the window
- [ ] "Quit" terminates the app
- [ ] Menu bar icon uses template rendering (adapts to light/dark system)

## Risk Assessment

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| State desync between menu and window | Medium | Medium | Single @Observable source |
| MenuBarExtra limitations | Low | Low | Fallback to NSStatusItem |
| Icon not rendering properly | Low | Low | Use template images |
