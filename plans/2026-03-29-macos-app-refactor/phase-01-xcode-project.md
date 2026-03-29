# Phase 01: Xcode Project Migration

**Parent Plan:** [plan.md](plan.md)
**Date:** 2026-03-29
**Created By:** TuanTruong
**Priority:** P0 — Critical (blocks all other phases)
**Status:** ⬜ TODO
**Review:** ⬜ Pending

## Overview

Migrate TTBDebugPlus from SPM executable to a proper Xcode project (.xcodeproj) with macOS app target. This unlocks Info.plist, entitlements, AppIcon, code signing, and proper `.app` bundle generation.

## Key Insights

- SPM `.executableTarget` cannot produce a proper `.app` bundle
- Xcode project is required for: signing, notarization, Info.plist, entitlements
- Keep Package.swift for backward compat but main build via `.xcodeproj`
- All existing Swift files remain in same directory structure
- No code changes needed — just project configuration

## Requirements

1. Create `.xcodeproj` with macOS app target (SwiftUI lifecycle)
2. Target macOS 14.0+
3. Add Info.plist with required privacy + Bonjour keys
4. Add entitlements file with sandbox + network permissions
5. Create AppIcon asset set
6. Ensure all existing source files are included in target
7. App builds and runs identically to current SPM build

## Architecture

### Info.plist Keys Required

```xml
<key>NSLocalNetworkUsageDescription</key>
<string>TTBDebugPlus discovers iOS devices on your local network for real-time debugging.</string>
<key>NSBonjourServices</key>
<array>
    <string>_ttbdebug._tcp</string>
</array>
<key>CFBundleIdentifier</key>
<string>com.tuantruong.TTBDebugPlus</string>
<key>CFBundleDisplayName</key>
<string>TTBDebugPlus</string>
<key>CFBundleShortVersionString</key>
<string>1.0.0</string>
```

### Entitlements Required

```xml
<key>com.apple.security.app-sandbox</key>
<true/>
<key>com.apple.security.network.server</key>
<true/>
<key>com.apple.security.network.client</key>
<true/>
<key>com.apple.security.files.user-selected.read-write</key>
<true/>
```

## Related Code Files

- `TTBDebugPlus/Package.swift` — current SPM config
- `TTBDebugPlus/TTBDebugPlus/TTBDebugPlusApp.swift` — app entry point
- `TTBDebugPlus/TTBDebugPlus/Resources/Assets.xcassets/` — existing (empty) assets

## Implementation Steps

1. Create new Xcode project (macOS App, SwiftUI lifecycle) named "TTBDebugPlus"
   - Or use `xcodegen` or manual `.xcodeproj` creation
2. Configure target: macOS 14.0+, Swift 5.9+
3. Add all existing source files from `TTBDebugPlus/TTBDebugPlus/` to project
4. Create `Info.plist` with privacy + Bonjour keys
5. Create `TTBDebugPlus.entitlements` with sandbox + network
6. Generate AppIcon (ladybug icon matching branding) in Assets.xcassets
7. Configure build settings: signing team, bundle ID
8. Build + run — verify all features work

## Todo List

- [ ] Create `.xcodeproj` with macOS app target
- [ ] Add Info.plist with `NSLocalNetworkUsageDescription`, `NSBonjourServices`
- [ ] Add entitlements file
- [ ] Create AppIcon asset set
- [ ] Add all source files to project target
- [ ] Verify build succeeds
- [ ] Verify Bonjour discovery works with proper Info.plist
- [ ] Verify app launches and all tabs function

## Success Criteria

- [ ] Project builds from Xcode without errors
- [ ] `.app` bundle is generated in build output
- [ ] Info.plist correctly embedded in bundle
- [ ] Bonjour server starts and advertises service
- [ ] All 7 tabs render correctly
- [ ] Settings window opens from menu

## Risk Assessment

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Source file references broken | Medium | High | Verify each group in Xcode |
| Signing issues | Low | Medium | Use "Sign to run locally" |
| Missing resources | Low | Medium | Check Assets.xcassets inclusion |

## Security Considerations

- Sandbox enabled by default — restricts file system access
- Network entitlements scoped to server + client only
- User-selected file access for export/import panels
