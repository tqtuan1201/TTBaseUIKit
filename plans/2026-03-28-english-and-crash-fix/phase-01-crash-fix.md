# Phase 1 — Fix Connection Crash (TTDebugBridge)

**Parent:** [plan.md](./plan.md)
**Priority:** Critical
**Status:** Draft

## Root Cause Analysis

The crash occurs when an iOS app finds the macOS service and transitions to `Connecting` state. Investigation reveals **3 concurrency bugs** in `TTDebugBridge.swift`:

### Bug 1: `sendDeviceInfo()` accesses UIKit APIs from background queue

```
.ready → sendDeviceInfo() → UIDevice.current, UIScreen.main
```

The `stateUpdateHandler` fires on `queue` (a background DispatchQueue). Inside `.ready`, `sendDeviceInfo()` is called directly — which accesses `UIScreen.main` and `UIDevice.current`. On iOS 16+, **`UIScreen.main` must be called on `@MainActor`**. Accessing it from a background thread causes an immediate crash.

**Location:** `TTDebugBridge.swift` line 229-237 (`.ready` handler) → `sendDeviceInfo()` lines 367-393

### Bug 2: Race condition — multiple connections

`browseResultsChangedHandler` fires on every Bonjour result change. The guard:

```swift
guard self.connection == nil || self.state != .connected else { return }
```

This uses `||` which means: proceed if `connection == nil` OR if `state != .connected`. During the `.connecting` state (connection exists but not `.connected`), this guard passes and creates a second overlapping connection.

### Bug 3: No cancellation of previous connection attempt

When `connectTo` is called again while already connecting, the previous `NWConnection` is never cancelled — it just leaks and its `stateUpdateHandler` will still fire, setting `self.connection` to a stale reference.

## Implementation Steps

#### [MODIFY] [TTDebugBridge.swift](file:///Volumes/DataStore/S.JOB/J.PROJECT/P.BUILD_LIB/TTBaseUIKit/Sources/TTBaseUIKit/Support/DebugBridge/TTDebugBridge.swift)

- [ ] **Fix Bug 1**: Wrap `sendDeviceInfo()` body in `DispatchQueue.main.async`. Collect UIKit values (UIDevice, UIScreen) on main thread, then send from any thread.
- [ ] **Fix Bug 2**: Change browse guard to `guard self.connection == nil, self.state != .connected, self.state != .connecting else { return }` — prevent connecting when already connecting/connected.  
- [ ] **Fix Bug 3**: In `connectTo`, cancel any existing pending connection before creating a new one.
- [ ] **Thread safety**: Add `isConnecting` flag set atomically on the queue to prevent re-entrant connects.

## Specific Code Changes

### 1. Fix `sendDeviceInfo()` — main thread access

```swift
// BEFORE (crashes on iOS 16+ from background queue):
private func sendDeviceInfo() {
    let device = UIDevice.current
    let screen = UIScreen.main
    // ...
}

// AFTER:
private func sendDeviceInfo() {
    DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        let device = UIDevice.current
        let screen = UIScreen.main
        let bundle = Bundle.main
        
        let payload = DeviceInfoPayload(
            deviceId: self.deviceId,
            deviceName: device.name,
            osVersion: "\(device.systemName) \(device.systemVersion)",
            // ... rest of payload ...
        )
        
        self.sendMessage(type: .deviceInfo, payload: payload)
    }
}
```

### 2. Fix browse guard

```swift
// BEFORE (race condition):
guard let self = self, self.connection == nil || self.state != .connected else { return }

// AFTER (correct):
guard let self = self, 
      self.state != .connected,
      self.state != .connecting else { return }
```

### 3. Cancel stale connection in `connectTo`

```swift
private func connectTo(endpoint: NWEndpoint) {
    // Cancel any existing pending connection
    connection?.cancel()
    connection = nil
    
    updateState(.connecting)
    // ... rest unchanged
}
```

## Success Criteria

- [ ] iOS app connects to macOS app without crashing
- [ ] No duplicate connections created
- [ ] `UIScreen.main` accessed only on main thread
- [ ] Connection state transitions: idle → browsing → connecting → connected (no re-entrance)

## Risk Assessment

- **Low**: Changes are isolated to connection lifecycle
- **No breaking API changes**: Public API (`start()`, `stop()`, `sendAPILog()`) unchanged
