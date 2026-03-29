# Phase 03: Settings & Permissions

**Parent Plan:** [plan.md](plan.md)
**Dependencies:** Phase 01 (Xcode Project)
**Date:** 2026-03-29
**Created By:** TuanTruong
**Priority:** P1 — High
**Status:** ⬜ TODO
**Review:** ⬜ Pending

## Overview

Enhance the Settings window with permission status indicators, storage management UI, and new configuration options. Add a Permissions tab showing real-time status of required system permissions.

## Key Insights

- macOS has no direct API to check Local Network permission status
- Can infer from NWBrowser/NWListener success/failure
- File access via NSSavePanel/NSOpenPanel is automatically sandbox-allowed
- Notification permission can be checked via UNUserNotificationCenter
- Should show users where data is stored and how to manage it

## Requirements

1. Add "Permissions" tab to Settings
2. Show local network permission status (inferred)
3. Show notification permission status (if used)
4. Add "Storage" tab showing data locations and sizes
5. Add button to open storage folder in Finder
6. Add button to clear cached data
7. Show total storage usage breakdown

## Architecture

### Enhanced Settings Tabs

```
SettingsView (TabView)
├── General          — existing (theme, timestamps, indentation)
├── Connection       — existing (port, heartbeat)
├── Permissions      — [NEW] permission status indicators
├── Storage          — [ENHANCED] data locations, sizes, cleanup
├── Dev Tools        — existing (JSON settings)
└── Privacy          — existing (data masking)
```

### Permissions View

```swift
struct PermissionsView: View {
    // Inferred states
    var localNetworkStatus: PermissionStatus  // .granted / .unknown / .denied
    var notificationStatus: PermissionStatus
    
    // Show status + "Open System Settings" buttons
}
```

## Related Code Files

- `Views/Settings/SettingsView.swift` — current settings implementation
- `Services/Discovery/ConnectionManager.swift` — network permission inference
- `Services/SessionManager.swift` — session data management

## Implementation Steps

1. Create `Views/Settings/PermissionsView.swift`
   - Local Network permission row with status indicator
   - Button: "Open Network Settings" → System Settings > Privacy
   - Notification permission row (if applicable)
   - Brief explanation of each permission
2. Create `Views/Settings/StorageSettingsView.swift`
   - Storage breakdown: sessions, media, cache
   - Total disk usage calculation
   - "Reveal in Finder" button for each directory
   - "Clear Cache" button with confirmation
   - "Delete All Sessions" with warning dialog
3. Update `SettingsView.swift`
   - Add Permissions tab
   - Replace inline Data tab with StorageSettingsView
   - Increase frame size if needed
4. Add permission inference to `ConnectionManager`
   - Track whether Bonjour listener successfully started
   - Expose `networkPermissionGranted: Bool`

## Todo List

- [ ] Create `PermissionsView.swift`
- [ ] Create `StorageSettingsView.swift`
- [ ] Update `SettingsView.swift` with new tabs
- [ ] Add network permission inference to ConnectionManager
- [ ] Calculate storage sizes for sessions/media/cache
- [ ] Add "Reveal in Finder" functionality
- [ ] Add "Clear Cache" with confirmation
- [ ] Test permission UI on macOS 14

## Success Criteria

- [ ] Permissions tab shows local network status accurately
- [ ] Storage tab shows correct disk usage
- [ ] "Open System Settings" deeplinks work
- [ ] "Reveal in Finder" opens correct directories
- [ ] "Clear Cache" removes temporary files
- [ ] Settings window renders all tabs without overflow

## Risk Assessment

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Cannot detect Local Network permission | Medium | Low | Show "unknown" + instructions |
| Storage size calculation slow | Low | Low | Async with loading indicator |
