# Phase 01: Device-Aware Data + Filter System

> **Parent Plan:** [plan.md](./plan.md)
> **Dependencies:** None
> **Docs:** [docs/system-architecture](../../docs/)

## Overview

- **Date:** 2026-03-29
- **Created By:** TuanTruong
- **Description:** Add device source tracking to every network request entry. Users must know which device generated each request and be able to filter by device.
- **Priority:** P0 — Critical (user requirement)
- **Implementation Status:** `[ ]` Pending
- **Review Status:** `[ ]` Not reviewed

## Key Insights

1. `NetworkRequestEntry` currently has NO device info — `syncFromConnectionManager()` flattens all logs, losing device provenance
2. `ConnectionManager` stores logs per-device in `DeviceSession.apiLogs` — data IS available, just not propagated
3. Selected device filter exists at ConnectionManager level (`selectedDeviceId`) but NetworkView doesn't expose independent device filtering
4. Need both a "source" indicator per row AND a filter picker

## Requirements

- [ ] Each `NetworkRequestEntry` must carry `sourceDeviceId` and `sourceDeviceName`
- [ ] Request list rows must show a device indicator badge
- [ ] Filter bar must include a device picker (dropdown: "All Devices" + each connected device)
- [ ] Analytics view must show per-device breakdown
- [ ] Device badge must be color-coded (consistent color per device)

## Architecture

### Data Flow Change

```
DeviceSession.apiLogs
    ↓ syncFromConnectionManager()
NetworkRequestEntry (+ sourceDeviceId, sourceDeviceName, deviceColor)
    ↓ filteredEntries computed property
    ↓ device filter applied
UI (device badge in row + filter picker)
```

### Device Color Assignment

Assign a stable color per device using hash of deviceId:
```swift
static let deviceColors: [Color] = [
    .cyan, .orange, .purple, .pink, .mint, .indigo, .teal, .brown
]

static func colorForDevice(_ id: String) -> Color {
    let hash = abs(id.hashValue)
    return deviceColors[hash % deviceColors.count]
}
```

## Related Code Files

| File | Change Type | Purpose |
|------|------------|---------|
| `ViewModels/NetworkViewModel.swift` | MODIFY | Add device fields to entry, add device filter state, update sync |
| `Views/Network/NetworkView.swift` | MODIFY | Add device badge to rows, add device filter picker |
| `Views/Network/NetworkStatsView.swift` | MODIFY | Add per-device analytics section |
| `DesignSystem/CardView.swift` | MODIFY | Add DeviceBadge component |

## Implementation Steps

### Step 1: Update `NetworkRequestEntry` model
```swift
struct NetworkRequestEntry: Identifiable {
    // ... existing fields ...
    let sourceDeviceId: String
    let sourceDeviceName: String
}
```

### Step 2: Update `syncFromConnectionManager()`
Change from flattening all devices to preserving device info:
```swift
func syncFromConnectionManager(_ connectionManager: ConnectionManager) {
    var allEntries: [NetworkRequestEntry] = []
    
    for device in connectionManager.connectedDevices {
        for payload in device.apiLogs {
            allEntries.append(NetworkRequestEntry(
                // ... existing mapping ...
                sourceDeviceId: device.id,
                sourceDeviceName: device.displayName
            ))
        }
    }
    
    entries = allEntries
}
```

### Step 3: Add device filter state to `NetworkViewModel`
```swift
var selectedDeviceFilter: String? = nil  // nil = all devices
var availableDevices: [(id: String, name: String)] // populated during sync
```

### Step 4: Apply device filter in `filteredEntries`
```swift
if let deviceId = selectedDeviceFilter {
    result = result.filter { $0.sourceDeviceId == deviceId }
}
```

### Step 5: Add `DeviceBadge` component
Compact colored dot + short name badge for the request list rows.

### Step 6: Add device filter picker to filter bar
Dropdown menu showing all devices with colored dots, "All Devices" at top.

### Step 7: Add device column to request list
Between STATUS and METHOD columns, show device badge.

### Step 8: Update analytics for per-device breakdown
Add a "Requests by Device" chart and per-device stats cards.

## Todo List

- [ ] Add `sourceDeviceId`, `sourceDeviceName` to `NetworkRequestEntry`
- [ ] Update `syncFromConnectionManager()` to preserve device info for ALL devices
- [ ] Add `selectedDeviceFilter`, `availableDevices` to `NetworkViewModel`
- [ ] Add device filter to `filteredEntries` computed property
- [ ] Create `DeviceBadge` component in `CardView.swift`
- [ ] Add `Color.colorForDevice()` helper
- [ ] Add device filter picker to `networkFilterBar`
- [ ] Add device column to `requestColumnHeaders` and `NetworkRequestRowView`
- [ ] Add per-device analytics to `NetworkStatsView`
- [ ] Fix `generateCURL()` — add deviceInfo context in entry conversion

## Success Criteria

- [ ] Each request row shows which device it came from
- [ ] Device filter works correctly — filters list + updates analytics
- [ ] Multiple devices can be connected simultaneously with distinct visual identity
- [ ] "All Devices" aggregated view works properly
- [ ] Device colors are consistent across the app

## Risk Assessment

| Risk | Impact | Mitigation |
|------|--------|------------|
| Performance with many devices | Medium | Limit to 8 device colors, lazy rendering |
| Breaking existing data flow | High | Keep backward compat — default to "Unknown" if no device |

## Security Considerations

None — device info is local-only, no external transmission.

## Next Steps

→ Phase 02: Layout Bug Fixes + UI/UX Pro Upgrade
