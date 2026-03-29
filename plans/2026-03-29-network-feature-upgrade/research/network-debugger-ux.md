# Research: Network Debugger UI/UX Best Practices

**Date:** 2026-03-29
**Source:** Proxyman, Charles Proxy, Chrome DevTools, industry analysis

## Key Findings

### 1. Information Architecture
- **Tiered data presentation**: Show essential info first (status, method, URL), drill-down for details
- **Master-detail pattern**: Industry standard — resizable split-pane with instant detail updates
- **Tabular list layout**: Include Method, Status, Path; allow customizable column visibility

### 2. Filtering Best Practices
- **Persistent filter bar** above request list
- **Smart search**: Support operators (`status:404`, `method:POST`, `domain:api.example.com`)
- **Quick-access pills**: Clickable filters for common criteria
- **Instant filtering**: Never block UI during filter updates
- **Clear active filter indicators** + one-click "Clear All"

### 3. Multi-Device/Session Management (CRITICAL)
- **Contextual switching**: Clear dropdown/sidebar for device selection
- **Visual separation**: Color-coding or labeled cards per device
- **Dual views needed**:
  - **Global view**: All traffic chronologically across devices
  - **Isolated view**: Single-device traffic only
- **Session lifecycle indicators**: Active/Paused/Closed states

### 4. Visual Design
- **Color-coded statuses**: Green 2xx, Yellow 4xx, Red 5xx
- **Waterfall charts**: Essential for identifying slow resources
- **Performance**: Virtualized lists for 1000s of rows (LazyVStack)
- **Copy/Export**: cURL, HAR format, Postman collections

### 5. Proxyman-Level Features (Benchmarks)
- GraphQL/WebSocket/gRPC native support
- JavaScript scripting for rewrites
- Automated iOS/Android setup
- Search with regex support
- Response body preview with syntax highlighting
- Certificate pinning bypass

## Gaps in Current TTBDebugPlus Network Feature

| Area | Current State | Gap |
|------|--------------|-----|
| Device tracking | Data stored per device but NOT displayed | No way to see which device a request came from |
| Device filter | None | Can't filter by device |
| Request list | Basic columns work | No device indicator column |
| Filter bar | Text + status + method | No regex, no device filter, no domain filter |
| Detail pane | Headers/Preview/Response/Cookies | Cookies tab always empty, no timing breakdown |
| Stats view | Summary cards + charts | No per-device analytics |
| Export | cURL + Postman | No HAR export |
| Performance | LazyVStack ✓ | No virtualization issues noted |
| Live/Pause | UI shows badge but no actual toggle logic | isLiveStreaming always true |

## Recommendations

1. **Add device info to NetworkRequestEntry** — track sourceDeviceId + sourceDeviceName
2. **Add device column** in request list with color-coded device badge
3. **Add device filter picker** in filter bar (dropdown + "All Devices" option)
4. **Fix Live/Pause toggle** — currently cosmetic only
5. **HAR export** for broader tool compatibility
6. **Timing breakdown** in detail pane (DNS, connect, TLS, TTFB, transfer)
7. **Domain grouping** in analytics view
8. **Keyboard shortcuts** for power users
