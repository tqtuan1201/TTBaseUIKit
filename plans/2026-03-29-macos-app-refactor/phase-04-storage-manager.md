# Phase 04: Storage Manager

**Parent Plan:** [plan.md](plan.md)
**Dependencies:** Phase 01 (Xcode Project)
**Date:** 2026-03-29
**Created By:** TuanTruong
**Priority:** P1 — High
**Status:** ⬜ TODO
**Review:** ⬜ Pending

## Overview

Create a centralized `StorageManager` that handles all file operations using sandbox-aware paths. Replace hardcoded paths throughout the app with this manager.

## Key Insights

- Current code uses hardcoded `~/Library/Application Support/TTBDebugPlus/`
- With sandbox, actual path is `~/Library/Containers/<bundle-id>/Data/Library/Application Support/`
- Must use `FileManager.default.urls(for:in:)` for correct sandbox paths
- Screenshots, recordings, exports all need organized subdirectories
- Auto-cleanup based on retention settings (`autoCleanupDays`)

## Requirements

1. Create `StorageManager` service with sandbox-aware paths
2. Organize into subdirectories: sessions, media, exports, cache
3. Auto-create directories on first use
4. Provide size calculation for each category
5. Support cleanup by age and manual purge
6. Thread-safe file operations

## Architecture

### StorageManager API

```swift
@Observable
final class StorageManager {
    // Directories
    var sessionsDirectory: URL
    var mediaDirectory: URL  // screenshots, recordings
    var exportsDirectory: URL
    var cacheDirectory: URL
    
    // Operations
    func saveScreenshot(_ data: Data, deviceName: String) -> URL
    func saveRecording(_ data: Data, deviceName: String) -> URL
    func saveSession(_ session: SessionExport) -> URL
    func calculateStorageUsage() async -> StorageUsage
    func clearCache() throws
    func cleanupOldSessions(olderThan days: Int) throws
    func revealInFinder(_ url: URL)
}

struct StorageUsage {
    var sessionsSize: Int64
    var mediaSize: Int64
    var exportsSize: Int64
    var cacheSize: Int64
    var totalSize: Int64
}
```

## Related Code Files

- `Services/SessionManager.swift` — current session export/import
- `Services/Export/HARExporter.swift` — HAR file export
- `ViewModels/ScreenCaptureViewModel.swift` — screenshot saving
- `Views/Settings/SettingsView.swift` — storage info display

## Implementation Steps

1. Create `Services/Storage/StorageManager.swift`
   - Init with proper sandbox-aware base paths
   - Auto-create subdirectories
   - Save/load operations for each data type
   - Size calculation (async)
   - Cleanup methods
2. Create `Models/StorageUsage.swift` — storage usage model
3. Update `SessionManager.swift` to use StorageManager
4. Update `ScreenCaptureViewModel.swift` to use StorageManager
5. Update `HARExporter.swift` to use StorageManager
6. Inject StorageManager via Environment

## Todo List

- [ ] Create `StorageManager.swift`
- [ ] Create `StorageUsage.swift` model
- [ ] Wire StorageManager into app Environment
- [ ] Update SessionManager to use it
- [ ] Update ScreenCaptureViewModel to use it
- [ ] Update HARExporter to use it
- [ ] Test storage paths in sandboxed build
- [ ] Test cleanup and size calculation

## Success Criteria

- [ ] All file operations use sandbox-aware paths
- [ ] Directories auto-created on first app launch
- [ ] Storage size calculation returns accurate numbers
- [ ] Cleanup removes old sessions correctly
- [ ] No hardcoded paths remain in codebase
