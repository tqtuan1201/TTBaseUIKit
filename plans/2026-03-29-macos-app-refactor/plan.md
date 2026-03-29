# Implementation Plan: TTBDebugPlus macOS App Refactor

**Date:** 2026-03-29
**Created By:** TuanTruong
**Status:** Draft
**Complexity:** High
**Estimated Effort:** 24–32 hours

## Summary

Refactor TTBDebugPlus from SPM executable to a proper macOS Xcode project (.xcodeproj). Add menu bar icon for quick access, implement proper entitlements/permissions, optimize storage management, and refactor large views for better maintainability and UI/UX.

## Problem Statement

TTBDebugPlus currently runs as an SPM executable — this means:
- No proper `.app` bundle (no Info.plist, no entitlements, no AppIcon)
- Bonjour networking lacks privacy declarations → unreliable on macOS 14+
- No menu bar presence → users must keep window visible
- Large monolithic view files (up to 1223 lines) → hard to maintain
- No sandbox-aware storage paths → fragile file management
- Settings lack permission management

## Research

- [Competitive Analysis](research/competitive-analysis.md)
- [Permissions, Storage & Menu Bar](research/permissions-storage-menubar.md)

## Phases

| # | Phase | Status | Effort |
|---|-------|--------|--------|
| 1 | [Xcode Project Migration](phase-01-xcode-project.md) | ✅ DONE (2026-03-29) | 6h |
| 2 | [Menu Bar Integration](phase-02-menu-bar.md) | ✅ DONE (2026-03-29) | 4h |
| 3 | [Settings & Permissions](phase-03-settings-permissions.md) | ✅ DONE (2026-03-29) | 4h |
| 4 | [Storage Manager](phase-04-storage-manager.md) | ✅ DONE (2026-03-29) | 3h |
| 5 | [UI/UX Optimization & View Refactor](phase-05-ui-refactor.md) | ⬜ DEFERRED | 8h |
| 6 | [Code Quality & Performance](phase-06-code-quality.md) | ✅ DONE (2026-03-29) | 5h |

## Architecture Overview (After Refactor)

```
TTBDebugPlus/
├── TTBDebugPlus.xcodeproj              # [NEW] Xcode project
├── TTBDebugPlus/
│   ├── Info.plist                       # [NEW] App metadata + privacy keys
│   ├── TTBDebugPlus.entitlements        # [NEW] Sandbox + network entitlements
│   ├── Assets.xcassets/                 # [ENHANCED] AppIcon + menu bar icon
│   ├── TTBDebugPlusApp.swift            # [MODIFIED] + MenuBarExtra scene
│   ├── ContentView.swift
│   ├── Components/
│   │   ├── MenuBar/                     # [NEW] Menu bar views
│   │   │   ├── MenuBarView.swift
│   │   │   └── MenuBarDeviceRow.swift
│   │   ├── EmptyStateView.swift
│   │   ├── StatusBarView.swift
│   │   └── TabBarView.swift
│   ├── DesignSystem/
│   ├── Models/
│   ├── Services/
│   │   ├── Storage/                     # [NEW] Sandbox-aware storage
│   │   │   └── StorageManager.swift
│   │   ├── Communication/
│   │   ├── Discovery/
│   │   ├── Export/
│   │   └── Protocol/
│   ├── ViewModels/
│   └── Views/
│       ├── Console/
│       ├── Network/
│       │   ├── NetworkView.swift         # [REFACTORED] Split from 1223 lines
│       │   ├── NetworkRequestList.swift   # [NEW] Extracted
│       │   ├── NetworkDetailPane.swift    # [NEW] Extracted
│       │   └── NetworkFilterBar.swift     # [NEW] Extracted
│       ├── Device/
│       │   ├── DeviceView.swift           # [REFACTORED] Split from 870 lines
│       │   ├── DeviceInfoPanel.swift      # [NEW] Extracted
│       │   ├── ScreenCapturePanel.swift   # [NEW] Extracted
│       │   └── ...
│       ├── Settings/
│       │   ├── SettingsView.swift         # [ENHANCED] Permission status
│       │   ├── PermissionsView.swift      # [NEW]
│       │   └── StorageSettingsView.swift  # [NEW]
│       └── ...
└── Package.swift                         # [KEEP] For backward compatibility
```
