# Phase 4: Performance Optimization

> Parent: [plan.md](plan.md)
> Depends on: [Phase 3](phase-03-view-decomposition.md) (smaller files easier to optimize)

## Overview

**Date:** 2026-03-29
**Priority:** High
**Status:** ⬜ TODO
**Estimated Effort:** 8h

Fix critical performance bottlenecks: cached filtered results, DateFormatter reuse, incremental data sync, NSImage thumbnail generation, and animation optimization.

## Key Insights

- `filteredEntries` recalculates on every body access — O(n log n) per render
- New `DateFormatter()` created per row per render — thousands of allocations
- `syncFromConnectionManager` rebuilds entire array every sync cycle
- 50 full-res NSImages in memory for gallery
- Recording timer on main thread blocks UI

## Requirements

1. `filteredEntries` cached, invalidated only on relevant state changes
2. Static DateFormatter instances, shared across views
3. Incremental sync with diff-based updates
4. Thumbnail generation for gallery views
5. Background timer for recording

## Related Code Files

- `ViewModels/NetworkViewModel.swift` — filteredEntries, sync
- `ViewModels/ScreenCaptureViewModel.swift` — recording, gallery
- `Services/Discovery/ConnectionManager.swift` — data source

## Implementation Steps

### 1. Cache `filteredEntries` in NetworkViewModel
```swift
// Replace computed property with cached pattern:
private var _cachedFilteredEntries: [NetworkRequestEntry]?
private var _filterVersion: Int = 0

var filteredEntries: [NetworkRequestEntry] {
    if let cached = _cachedFilteredEntries { return cached }
    let result = computeFilteredEntries()
    _cachedFilteredEntries = result
    return result
}

// Invalidate on any filter change
private func invalidateFilterCache() {
    _cachedFilteredEntries = nil
}
```

### 2. Static DateFormatter
```swift
// In NetworkRequestEntry or a shared utility:
private static let timestampFormatter: DateFormatter = {
    let f = DateFormatter()
    f.dateFormat = "HH:mm:ss.SSS"
    return f
}()

private static let timeFormatter: DateFormatter = {
    let f = DateFormatter()
    f.dateFormat = "HH:mm:ss"
    return f
}()
```

### 3. Pre-parse URL components
```swift
struct NetworkRequestEntry {
    // Parse once on construction
    let urlPath: String
    let urlDomain: String
    let remoteAddress: String
    
    init(...) {
        let comps = URLComponents(string: url)
        self.urlPath = (comps?.path ?? url) + (comps?.query.map { "?\($0)" } ?? "")
        self.urlDomain = comps?.host ?? "unknown"
        self.remoteAddress = "\(comps?.host ?? "unknown"):\(comps?.port ?? 443)"
    }
}
```

### 4. Incremental sync
```swift
func syncFromConnectionManager(_ cm: ConnectionManager) {
    guard isLiveStreaming else { return }
    
    // Track what we've already processed
    let existingIds = Set(entries.map(\.id))
    var newEntries: [NetworkRequestEntry] = []
    
    for device in cm.connectedDevices {
        for payload in device.apiLogs where !existingIds.contains(payload.id) {
            newEntries.append(NetworkRequestEntry(from: payload, device: device))
        }
    }
    
    if !newEntries.isEmpty {
        entries.append(contentsOf: newEntries)
        invalidateFilterCache()
    }
    
    availableDevices = cm.connectedDevices.map { ($0.id, $0.displayName) }
}
```

### 5. Thumbnail generation for gallery
```swift
struct ScreenshotItem {
    let image: NSImage
    lazy var thumbnail: NSImage = generateThumbnail(maxWidth: 200)
    
    private func generateThumbnail(maxWidth: CGFloat) -> NSImage {
        let ratio = maxWidth / image.size.width
        let newSize = NSSize(width: maxWidth, height: image.size.height * ratio)
        let thumb = NSImage(size: newSize)
        thumb.lockFocus()
        image.draw(in: NSRect(origin: .zero, size: newSize))
        thumb.unlockFocus()
        return thumb
    }
}
```

### 6. Background recording timer
```swift
private var timerQueue = DispatchQueue(label: "recording.timer", qos: .utility)
private var recordingSource: DispatchSourceTimer?

func startRecording(...) {
    let source = DispatchSource.makeTimerSource(queue: timerQueue)
    source.schedule(deadline: .now(), repeating: interval)
    source.setEventHandler { [weak self] in
        DispatchQueue.main.async { self?.requestCapture(from: connectionManager) }
    }
    source.resume()
    recordingSource = source
}
```

### 7. Single-pass statistics computation
```swift
// Replace multiple Dictionary(grouping:) calls with single O(n) pass
func computeStats() -> NetworkStats {
    var methodCounts: [String: Int] = [:]
    var statusBuckets = [0, 0, 0, 0] // 2xx, 3xx, 4xx, 5xx
    var totalDuration: Double = 0
    var totalSize: Int = 0
    
    for entry in entries {
        methodCounts[entry.method, default: 0] += 1
        switch entry.statusCode {
        case 200..<300: statusBuckets[0] += 1
        case 300..<400: statusBuckets[1] += 1
        case 400..<500: statusBuckets[2] += 1
        case 500..<600: statusBuckets[3] += 1
        default: break
        }
        totalDuration += entry.durationMs
        totalSize += entry.sizeBytes
    }
    ...
}
```

## Todo List

- [ ] Cache `filteredEntries` with invalidation
- [ ] Static DateFormatter instances
- [ ] Pre-parse URL components in `NetworkRequestEntry.init`
- [ ] Incremental sync in `syncFromConnectionManager`
- [ ] Thumbnail generation for ScreenshotItem
- [ ] Background DispatchSourceTimer for recording
- [ ] Single-pass statistics computation
- [ ] Build verification

## Success Criteria

- `filteredEntries` computed only when data or filters change (not every body call)
- 0 inline `DateFormatter()` allocations in view rendering code
- Profile with Instruments — no CPU spikes during scrolling

## Risk Assessment

- **Medium risk** — caching bugs can cause stale UI
- Incremental sync must handle edge cases (device disconnect, log clearing)
- Thumbnail lazy initialization must be thread-safe
