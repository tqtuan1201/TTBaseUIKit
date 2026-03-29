# Research: macOS App Permissions, Storage & Menu Bar

**Date:** 2026-03-29
**Topic:** Entitlements, sandbox, storage, and MenuBarExtra patterns

## Required Entitlements

### App Sandbox (`com.apple.security.app-sandbox`)
- **Required** for Mac App Store distribution
- Recommended even for direct distribution (security hardening)

### Network Access
- `com.apple.security.network.server` — incoming connections (Bonjour listener)
- `com.apple.security.network.client` — outgoing connections (if needed)

### File Access (optional)
- `com.apple.security.files.user-selected.read-write` — for export/import panels
- Already handled by NSSavePanel/NSOpenPanel (user-initiated = automatically allowed)

## Required Info.plist Keys

| Key | Value | Purpose |
|-----|-------|---------|
| `NSLocalNetworkUsageDescription` | "TTBDebugPlus discovers iOS devices on your local network for debugging." | Privacy prompt |
| `NSBonjourServices` | `["_ttbdebug._tcp"]` | Bonjour service declaration |
| `LSUIElement` | Optional `true` | Hide from Dock (menu-bar-only mode) |
| `CFBundleIconFile` | AppIcon | App icon |

## Storage Best Practices

### Sandbox-Aware Paths
```swift
// Application Support (persistent data, databases)
FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
  .appendingPathComponent("TTBDebugPlus")

// Caches (temporary data, can be purged)
FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
  .appendingPathComponent("TTBDebugPlus")

// Documents (user-visible exported files)
FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
```

### Storage Categories
| Data | Location | Retention |
|------|----------|-----------|
| Session logs | Application Support/Sessions/ | Configurable (30 days default) |
| Screenshots & recordings | Application Support/Media/ | User-managed |
| Exported HAR files | User-selected via NSSavePanel | Permanent |
| App preferences | UserDefaults (@AppStorage) | Permanent |
| Cache/temp | Caches directory | System-managed |

## MenuBarExtra Implementation

### Pattern: Main Window + Menu Bar
```swift
@main
struct TTBDebugPlusApp: App {
    var body: some Scene {
        WindowGroup { MainContentView() }
        
        MenuBarExtra("TTBDebugPlus", systemImage: "ladybug.fill") {
            // Quick status + actions
        }
        .menuBarExtraStyle(.window) // or .menu
        
        Settings { SettingsView() }
    }
}
```

### Menu Bar Content Recommendations
- Server status (running/stopped) with toggle
- Connected devices count
- Quick actions: Clear logs, Screenshot, Start/Stop recording
- Open main window button
- Recent sessions list
- Quit app

## Permission Status Checks

```swift
// Local Network permission — no direct API to check
// Must observe NWBrowser/NWListener behavior

// File system — sandbox handles via panels
// No explicit permission check needed

// Notifications (optional)
UNUserNotificationCenter.current().getNotificationSettings { settings in
    // settings.authorizationStatus
}
```

## Sources
- Apple Developer Documentation: App Sandbox
- Apple HIG: Menu Bar Extras
- WWDC 2022: "Bring your app to the menu bar"
