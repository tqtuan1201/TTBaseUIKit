# Phase 02: Dev Tools Tab & Settings Integration

> Parent: [plan.md](plan.md) | Dependencies: Phase 01

## Overview
- **Date:** 2026-03-29
- **Created By:** TuanTruong
- **Description:** Create new "Dev Tools" section in Settings menu and sidebar. Add JSON Editor as first tool in the Dev Tools category. Wire navigation from sidebar, tab bar, and settings.
- **Priority:** P0
- **Implementation Status:** ✅ DONE (2026-03-29)
- **Review Status:** ✅ Reviewed (2026-03-29)

## Key Insights
- Current `AppTab` enum has: console, network, device, performance, feedback, guide
- `SettingsView.swift` has 4 tabs: General, Connection, Data, Privacy — add "Dev Tools" as 5th tab
- `SidebarView.swift` sidebar sections: devices, logs, network, performance — no devtools yet
- Main menu `CommandMenu("Navigate")` — need to add Dev Tools shortcut
- TabBar filters via `AppTab.tabBarCases` — add devtools tab

## Requirements
1. Add `.devtools` case to `AppTab` enum with icon `wrench.and.screwdriver`
2. Add `devtools` to `SidebarSection` enum
3. Add "Dev Tools" tab to Settings with link/info about available tools
4. Create `DevToolsView.swift` as container for JSON Editor (and future tools)
5. Wire navigation: sidebar → devtools, tab bar → devtools, menu → devtools (⌘6)
6. Settings "Dev Tools" section with JSON editor preferences (default indentation, auto-format on paste)

## Architecture

### Modified Files
```
Models/AppState.swift              # Add .devtools to AppTab, SidebarSection
Components/TabBarView.swift        # Auto-updates via AppTab.tabBarCases
Views/Sidebar/SidebarView.swift    # Add devtools navigation
Views/Settings/SettingsView.swift  # Add Dev Tools tab
TTBDebugPlusApp.swift              # Add menu shortcut ⌘6
ContentView.swift                  # Route .devtools → DevToolsView

Views/DevTools/
└── DevToolsView.swift             # Container for dev tools (JSON Editor first)
```

### DevToolsView Design
```
┌─────────────────────────────────────────────┐
│  DEV TOOLS                                  │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐       │
│  │  JSON   │ │ Base64  │ │ URL     │       │ ← Tool selector tabs
│  │ Editor  │ │ En/Dec  │ │ En/Dec  │       │   (future tools greyed)
│  └─────────┘ └─────────┘ └─────────┘       │
│                                             │
│  ┌─────────────────────────────────────────┐│
│  │         JSONEditorView                  ││ ← Active tool content
│  │         (from Phase 01)                 ││
│  └─────────────────────────────────────────┘│
└─────────────────────────────────────────────┘
```

## Related Code Files
- [AppState.swift](../../TTBDebugPlus/TTBDebugPlus/Models/AppState.swift) — Tab/Section enums
- [ContentView.swift](../../TTBDebugPlus/TTBDebugPlus/ContentView.swift) — Main content routing
- [TabBarView.swift](../../TTBDebugPlus/TTBDebugPlus/Components/TabBarView.swift) — Tab bar
- [SidebarView.swift](../../TTBDebugPlus/TTBDebugPlus/Views/Sidebar/SidebarView.swift) — Sidebar nav
- [SettingsView.swift](../../TTBDebugPlus/TTBDebugPlus/Views/Settings/SettingsView.swift) — Settings tabs
- [TTBDebugPlusApp.swift](../../TTBDebugPlus/TTBDebugPlus/TTBDebugPlusApp.swift) — Menu commands

## Implementation Steps
1. **AppState.swift** — Add `.devtools` to `AppTab` with icon `wrench.and.screwdriver`, add `devtools` to `SidebarSection`
2. **ContentView.swift** — Add `case .devtools: DevToolsView()` routing
3. **SidebarView.swift** — Add devtools to `navigationSection`, wire badge
4. **TTBDebugPlusApp.swift** — Add `⌘6` shortcut for Dev Tools in Navigate menu
5. **SettingsView.swift** — Add "Dev Tools" tab with JSON editor preferences
6. **DevToolsView.swift** — Create container with tool selector, embed JSONEditorView

## Todo List
- [ ] Add `.devtools` to `AppTab` + `SidebarSection`
- [ ] Update ContentView routing
- [ ] Update SidebarView navigation
- [ ] Add menu shortcut (⌘6)
- [ ] Add Settings "Dev Tools" tab
- [ ] Create DevToolsView container
- [ ] Test navigation flow

## Success Criteria
- "Dev Tools" appears in sidebar, tab bar, and menu
- ⌘6 navigates to Dev Tools
- Settings has "Dev Tools" tab with indentation preference
- DevToolsView shows JSON Editor as default/active tool
- Future tool slots visible (Base64, URL) but marked "Coming Soon"

## Risk Assessment
- Low risk — primarily wiring existing patterns.
- Enum additions may require touch to multiple switch statements.

## Next Steps
- Phase 03: Advanced features (Query, Diff, Convert)
