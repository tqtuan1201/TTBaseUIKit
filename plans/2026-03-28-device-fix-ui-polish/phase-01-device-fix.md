# Phase 1: Fix Device View Functionality

**Parent:** [plan.md](./plan.md)
**Dependencies:** None
**Priority:** P0 — Critical (broken features)

---

## Overview

**Date:** 2026-03-28
**Created By:** TuanTruong
**Status:** DONE
**Implementation Status:** Complete — all 3 phases implemented
**Review Status:** Pending

## Key Insights

1. **Screenshot pipeline broken** — `ConnectionManager.handleScreenshot` stores data but `ScreenCaptureViewModel` never receives it. No observation link between them.
2. **Unimplemented commands shown** — DeviceView UI shows App Lifecycle, Accessibility, Appearance toggles but iOS `_handleCommand` only handles `dark_mode_on/off`. All others silently dropped.
3. **No device info display** — Connected device model, OS version, storage, battery info not shown anywhere in DeviceView despite being available from `DeviceInfoPayload`.
4. **iOS Ekhoo_Device module** is `#if os(iOS)` only — no macOS issues, but missing newer device models (iPhone 16e in hasDynamicIsland).

## Requirements

### Must Fix
- [ ] Connect screenshot pipeline: `ConnectionManager` → `ScreenCaptureViewModel`
- [ ] Show connected device info card (model, OS, app version, screen size, SDK version)
- [ ] Remove or disable non-functional App Lifecycle buttons
- [ ] Remove or disable non-functional Accessibility chips
- [ ] Only show toggles for actually implemented commands (dark mode only)
- [ ] Add iPhone 16e to `hasDynamicIsland` in `Device.swift`

### Nice to Have
- [ ] Add placeholder labels for future commands ("Coming Soon" badge)

## Architecture

### Screenshot Pipeline Fix

Currently:
```
ConnectionManager.handleScreenshot → DeviceSession.latestScreenshot = ...
```
Not connected to `ScreenCaptureViewModel.handleScreenshotReceived()`

Fix: In `DeviceView`, observe `connectionManager.selectedDevice?.latestScreenshot` via `onChange` and forward to `captureVM`:

```swift
.onChange(of: connectionManager.selectedDevice?.latestScreenshot?.timestamp) { _, newVal in
    if let screenshot = connectionManager.selectedDevice?.latestScreenshot {
        captureVM.handleScreenshotReceived(screenshot)
    }
}
```

### Device Info Card

Add a `deviceInfoCard` computed property that reads from `connectionManager.selectedDevice?.deviceInfo`:
- Device Name
- OS Version
- App Name / App Version  
- Screen Resolution
- SDK Version
- Simulator flag
- Connection Duration

## Related Code Files

| File | Change |
|------|--------|
| `TTBDebugPlus/Views/Device/DeviceView.swift` | Fix screenshot pipeline, add device info card, remove broken controls |
| `TTBDebugPlus/Services/Communication/DeviceSession.swift` | No changes needed |
| `TTBDebugPlus/ViewModels/ScreenCaptureViewModel.swift` | No changes needed (method already exists) |
| `TTBDebugPlus/Services/Discovery/ConnectionManager.swift` | No changes needed |
| `Sources/TTBaseUIKit/Support/Ekhoo_Device/Device.swift` | Add iPhone 16e to hasDynamicIsland |

## Implementation Steps

### Step 1: Fix Screenshot Pipeline (15 min)
In `DeviceView.connectedDeviceContent`, add `.onChange` on `connectionManager.selectedDevice?.latestScreenshot` to call `captureVM.handleScreenshotReceived()`.

### Step 2: Add Device Info Card (30 min)
Create `deviceInfoCard` in DeviceView showing all device metadata from `DeviceInfoPayload`. Position it prominently above controls.

### Step 3: Clean Up Non-functional Controls (20 min)
- Remove `appLifecycleCard` entirely (commands not implemented on iOS)
- Replace `appearanceCard` with only dark mode toggle (only implemented command)
- Remove `accessibilityCard` entirely (no iOS handler)
- Label removed controls as "Coming Soon" in a collapsed section for future implementation

### Step 4: Fix Ekhoo_Device (5 min)
Add `.iPhone16e` to `hasDynamicIsland` switch in `Device.swift`

## Todo List

- [ ] Connect screenshot observation pipeline in DeviceView
- [ ] Create device info card UI
- [ ] Remove/disable appLifecycleCard
- [ ] Simplify appearanceCard to dark mode only
- [ ] Remove/disable accessibilityCard
- [ ] Add iPhone16e to hasDynamicIsland
- [ ] Test screenshot flow end-to-end

## Success Criteria

- Tapping "Capture" triggers screenshot from iOS → appears in macOS display
- Device info card shows real data from connected device
- No broken/non-functional UI controls visible
- All visible controls actually work when device connected

## Risk Assessment

| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| Screenshot timing issue | Medium | Medium | Add timeout + retry with user feedback |
| onChange not firing for @Observable | Low | High | Test with real device connection |

## Security Considerations
None — all local network communication.

## Next Steps
After Phase 1, proceed to Phase 2 (UI/UX Polish).
