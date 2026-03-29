# Phase 04: Analytics + Export Enhancements

> **Parent Plan:** [plan.md](./plan.md)
> **Dependencies:** Phase 01, 02, 03
> **Docs:** [docs/system-architecture](../../docs/)

## Overview

- **Date:** 2026-03-29
- **Created By:** TuanTruong
- **Description:** Enhance the Analytics dashboard with per-device breakdowns, domain grouping, timeline view, and add HAR export for industry compatibility.
- **Priority:** P2 — Medium
- **Implementation Status:** `[ ]` Pending
- **Review Status:** `[ ]` Not reviewed

## Key Insights

1. Current analytics has 5 stat cards + 2 charts + slowest requests — solid foundation
2. Missing: per-device breakdown, domain grouping, request timeline, response time distribution
3. No HAR export — industry standard for network debug data sharing
4. Postman export works but could include device metadata

## Requirements

- [ ] Per-device request breakdown chart
- [ ] Domain grouping (top domains by request count)
- [ ] Response time distribution histogram
- [ ] Request timeline (requests over time)
- [ ] HAR 1.2 export
- [ ] Enhanced Postman export with device metadata

## Architecture

### HAR Export Format
```json
{
  "log": {
    "version": "1.2",
    "creator": { "name": "TTBDebugPlus", "version": "1.0" },
    "entries": [
      {
        "startedDateTime": "2026-03-29T...",
        "time": 150,
        "request": { "method": "POST", "url": "...", "headers": [...] },
        "response": { "status": 400, "headers": [...], "content": {...} }
      }
    ]
  }
}
```

## Related Code Files

| File | Change Type | Purpose |
|------|------------|---------|
| `Views/Network/NetworkStatsView.swift` | MODIFY | Add new charts + per-device section |
| `ViewModels/NetworkViewModel.swift` | MODIFY | Add computed properties for new analytics |
| `Views/Shared/JSONViewer.swift` | MODIFY | Add HAR generation to CURLGenerator |
| `Views/Network/NetworkView.swift` | MODIFY | Add HAR export button to bottom bar |

## Implementation Steps

### Step 1: Add per-device analytics properties to ViewModel
```swift
var deviceDistribution: [(deviceName: String, count: Int, color: Color)] {
    let grouped = Dictionary(grouping: entries, by: { $0.sourceDeviceName })
    return grouped.map { name, entries in
        (name, entries.count, Color.colorForDevice(entries.first?.sourceDeviceId ?? ""))
    }.sorted { $0.count > $1.count }
}

var domainDistribution: [(domain: String, count: Int)] {
    let grouped = Dictionary(grouping: entries) { entry -> String in
        URLComponents(string: entry.url)?.host ?? "unknown"
    }
    return grouped.map { ($0.key, $0.value.count) }
        .sorted { $0.count > $1.count }
        .prefix(10)
        .map { ($0.0, $0.1) }
}
```

### Step 2: Add new charts to NetworkStatsView
- **Requests by Device**: Horizontal bar chart with device colors
- **Top Domains**: Horizontal bar chart showing most-hit domains
- **Response Time Distribution**: Histogram (<100ms, 100-500ms, 500ms-1s, 1s-5s, >5s)
- **Request Timeline**: Line chart showing request count over time buckets

### Step 3: Implement HAR Export
Add to `CURLGenerator`:
```swift
static func generateHAR(from entries: [NetworkRequestEntry]) -> String {
    // Build HAR 1.2 compliant JSON
}
```

### Step 4: Add HAR Export Button
In bottom bar, alongside Postman:
```swift
Button(action: exportHAR) {
    HStack(spacing: 4) {
        Image(systemName: "doc.text")
        Text("HAR")
    }
}
.buttonStyle(.ttSecondaryCompact)
```

### Step 5: Enhance Postman Export
Add device name as folder grouping in Postman collection:
```json
{
  "item": [
    {
      "name": "iPhone 15 Pro",
      "item": [/* requests from this device */]
    }
  ]
}
```

## Todo List

- [ ] Add `deviceDistribution` computed property
- [ ] Add `domainDistribution` computed property
- [ ] Add response time distribution histogram data
- [ ] Add request timeline bucketed data
- [ ] Create per-device bar chart in NetworkStatsView
- [ ] Create domain distribution chart
- [ ] Create response time histogram
- [ ] Create request timeline chart
- [ ] Implement HAR 1.2 export in CURLGenerator
- [ ] Add HAR export button to bottom bar
- [ ] Enhance Postman export with device grouping

## Success Criteria

- [ ] Analytics shows per-device breakdown when multiple devices connected
- [ ] Domain distribution chart shows top 10 domains
- [ ] Response time histogram provides useful performance overview
- [ ] HAR export produces valid HAR 1.2 JSON
- [ ] HAR file can be imported into Chrome DevTools / Charles Proxy

## Risk Assessment

| Risk | Impact | Mitigation |
|------|--------|------------|
| HAR spec compliance | Medium | Use HAR 1.2 spec reference, test with Chrome import |
| Chart performance with 5000+ entries | Low | Pre-compute in ViewModel, throttle updates |

## Security Considerations

HAR files may contain auth tokens. Add a warning dialog before export.

## Next Steps

→ Implementation begins with Phase 01 after user approval.
