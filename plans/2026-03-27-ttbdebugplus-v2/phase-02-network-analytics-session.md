# Phase 02: Network Analytics & Session Management

**Parent:** [plan.md](./plan.md)
**Date:** 2026-03-27
**Created By:** TuanTruong
**Priority:** 🟡 High
**Status:** ⬜ Pending

## Overview

Add Wormholy-style network statistics dashboard and Pulse-style session persistence. These are strong differentiators that make the tool significantly more useful for daily debugging.

## Key Insights

- Wormholy 2.0 shows: HTTP methods breakdown, status code distribution, error types, response size stats
- Pulse Pro stores sessions persistently, allowing review of previous debug sessions
- Network timeline waterfall (like Chrome DevTools) is a high-value visual

## Requirements

### 1. Network Statistics Dashboard
Replace the current basic "API ANALYTICS" card with a rich dashboard:
- **Method distribution** — pie/bar chart: GET/POST/PUT/DELETE/PATCH counts
- **Status code distribution** — grouped: 2xx/3xx/4xx/5xx with counts
- **Response time histogram** — distribution of response times
- **Top slowest requests** — ranked list of slowest API calls
- **Total data transferred** — sent vs received bytes
- **Error rate timeline** — errors over time

### 2. Network Request Timeline
- Chrome DevTools-style waterfall visualization
- Show request start/end relative to session start
- Color-coded bars by status code
- Hover to show details

### 3. Session Management
- Auto-save current session on app quit
- List of recent sessions in sidebar
- Export session as `.ttbdebug` JSON file
- Import session from file
- Session metadata: device name, date, duration, log count

## Architecture

```
Components/
  ChartViews.swift              [NEW] — Mini chart components (bar, pie, histogram)
  
Views/Network/
  NetworkStatsView.swift        [NEW] — Statistics dashboard
  NetworkTimelineView.swift     [NEW] — Request waterfall timeline

Services/
  SessionManager.swift          [NEW] — Save/load/export debug sessions
  
Models/
  DebugSession.swift            [NEW] — Session model with metadata

Views/Sidebar/
  SidebarView.swift             [MODIFY] — Add session history section
```

## Implementation Steps

1. Create `ChartViews` components
   - `MiniBarChart` — horizontal bars with labels
   - `MiniPieChart` — simple pie/donut chart
   - `HistogramView` — distribution bars

2. Create `NetworkStatsView`
   - Method distribution pie chart
   - Status code grouped bars
   - Response time histogram
   - Top 5 slowest + error list
   - Data transfer summary

3. Create `NetworkTimelineView`
   - Horizontal timeline with relative timestamps
   - Request bars colored by status
   - Scroll-to-zoom for time scale
   - Click to select request

4. Create `SessionManager` service
   - Codable `DebugSession` model
   - Save to `~/Library/Application Support/TTBDebugPlus/sessions/`
   - Auto-save on app quit (`.onDisappear`)
   - List recent sessions from disk
   - Export as `.ttbdebug` JSON

5. Integrate into sidebar
   - "Sessions" section under devices
   - Show recent sessions with metadata
   - Click to load historical session

## Success Criteria

- [ ] Network stats dashboard showing real-time analytics
- [ ] Timeline waterfall renders correctly
- [ ] Sessions save/restore correctly
- [ ] Export/import .ttbdebug files work
- [ ] Build passes

## Risk Assessment

- **Medium:** Charts in pure SwiftUI — may need Canvas for performance
- **Low:** Session persistence — straightforward Codable + FileManager
