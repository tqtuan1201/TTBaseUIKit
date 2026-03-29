# Research: macOS Dev Tool Competitive Analysis

**Date:** 2026-03-29
**Topic:** How top macOS dev tools structure their apps

## Key Competitors

### Proxyman
- Native Swift macOS app with Xcode project
- Menu bar icon + main window coexist
- App Sandbox with network entitlements
- SSL proxying, breakpoints, map local/remote
- Premium dark UI, Apple Silicon optimized
- Proper Info.plist for Bonjour, local network

### Pulse (by kean)
- Open-source framework + macOS companion app
- Uses `URLSession`-level logging (no proxy needed)
- Real-time log viewing via companion app
- Clean native macOS UI
- Source on GitHub — good reference implementation

### FLEX (Flipboard Explorer)
- In-app debugging overlay for iOS
- UI hierarchy inspector, network history, DB browser
- On-device — no macOS companion needed
- Inspiration for TTBDebugPlus's iOS SDK side

### Charles Proxy
- Legacy Java-based, cross-platform
- Being replaced by Proxyman in Apple ecosystem
- Good feature set but poor macOS integration

## Architecture Patterns Observed

1. **Xcode project (.xcodeproj)** is universal — all serious macOS apps use it
2. **MenuBarExtra** for quick-access status/actions alongside main window
3. **Entitlements-first** design — network, sandbox, file access declared upfront
4. **Modular file structure** — no view file > 400 lines in production apps
5. **MVVM + @Observable** is dominant pattern for SwiftUI macOS apps

## Key Takeaways for TTBDebugPlus

1. Must migrate from SPM executable to proper Xcode project
2. Menu bar presence is expected for always-running dev tools
3. Proper entitlements unlock reliable Bonjour/network behavior
4. Settings should include permission status indicators
5. Large views (1200+ lines) signal need for decomposition
