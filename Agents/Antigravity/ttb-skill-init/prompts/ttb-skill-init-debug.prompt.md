---
name: "ttb-skill-init-debug"
description: "TTBDebugPlus + TTBaseDebugKit integration for TTBaseUIKit projects."
version: "1.3.0"
---

# ttb-skill-init-debug — TTBDebugPlus Integration

## Purpose

Setup TTBDebugPlus and TTBaseDebugKit for enhanced debugging capabilities in TTBaseUIKit projects.

## When to Run

Run via `/ttb-init-debug` command when user selected TTBDebugPlus in Phase 0.

## What is TTBDebugPlus?

TTBDebugPlus is a macOS companion app that provides:
- Real-time view hierarchy inspection
- Log streaming from iOS device to Mac
- Network request/response monitoring
- Performance profiling
- Crash debugging tools

## Prerequisites

1. macOS device with TTBDebugPlus installed
2. iOS device/simulator on same network as Mac
3. TTBaseUIKit installed in the project

## Step 1: Install TTBDebugPlus

Download `TTBDebugPlus-Installer.dmg` from the TTBaseUIKit releases page:

```bash
# Download from GitHub releases
open https://github.com/tuantt20/TTBaseUIKit/releases
```

Or copy from TTBaseUIKit repository:

```bash
# If DMG exists in TTBaseUIKit directory
cp /path/to/TTBaseUIKit/TTBDebugPlus-Installer.dmg ~/Downloads/
open ~/Downloads/TTBDebugPlus-Installer.dmg
```

## Step 2: Add TTBaseDebugKit to Project

### For SPM

Add to `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/tuantt20/TTBaseUIKit.git", from: "2.1.0"),
]
```

TTBaseDebugKit is part of the TTBaseUIKit package (under `Sources/TTBaseUIKit/Support/DebugBridge/`).

### For CocoaPods

TTBaseDebugKit is included with TTBaseUIKit pod. No additional pod needed.

## Step 3: Configure TTBaseDebugKit in AppDelegate

Update `AppDelegate.swift`:

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  AppDelegate.swift
//  {AppName}
//
import UIKit
import TTBaseUIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupTTBaseUIKit()
        setupDebugTools()
        return true
    }

    // MARK: - TTBaseUIKit Setup

    private func setupTTBaseUIKit() {
        TTBaseUIKitConfig.withDefaultConfig(
            withFontConfig: TTBaseUIKitFontConfig(),
            frameSize: TTBaseUIKitFrameSize(),
            view: TTBaseUIKitViewConfig()
        )?.start(withViewLog: true)
    }

    // MARK: - Debug Tools

    private func setupDebugTools() {
        #if DEBUG
        TTBaseDebugKit.setup()
        #endif
    }

    // ... rest of AppDelegate
}
```

## Step 4: Configure Debug Bridge (Optional)

Create `DebugBridgeConfig.swift` for advanced configuration:

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  DebugBridgeConfig.swift
//  {AppName}
//
import Foundation

enum DebugBridgeConfig {

    // MARK: - Connection

    static var serverHost: String {
        #if DEBUG
        return UserDefaults.standard.string(forKey: "debug_host") ?? "localhost"
        #else
        return "localhost"
        #endif
    }

    static var serverPort: Int {
        #if DEBUG
        return UserDefaults.standard.integer(forKey: "debug_port").nonZeroOr(8080)
        #else
        return 8080
        #endif
    }

    static var autoConnect: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    // MARK: - Features

    static var enableLogIntercept: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    static var enableNetworkLogging: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    // MARK: - Configure

    static func configure() {
        #if DEBUG
        TTDebugBridge.shared.configure(host: serverHost, port: serverPort)

        if enableLogIntercept {
            LogInterceptor.shared.start()
        }

        if autoConnect {
            TTDebugBridge.shared.connect()
        }
        #endif
    }
}

// MARK: - Int Extension

private extension Int {
    func nonZeroOr(_ defaultValue: Int) -> Int {
        return self != 0 ? self : defaultValue
    }
}
```

## Step 5: Create Debug Tab Screen

Create a debug/debug bridge screen accessible from the tab bar:

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  DebugBridgeViewController.swift
//  {AppName}
//
import UIKit
import TTBaseUIKit

class DebugBridgeViewController: BaseViewController {

    // MARK: - UI Components

    private let statusLabel = TTBaseUILabel(withType: .TITLE, text: "", align: .center)
    private let connectButton = TTBaseUIButton(textString: "Connect", type: .DEFAULT, isSetHeight: true)
    private let logsButton = TTBaseUIButton(textString: "View Logs", type: .BORDER, isSetHeight: true)
    private let networkButton = TTBaseUIButton(textString: "Network Monitor", type: .BORDER, isSetHeight: true)

    private let stackView = TTBaseUIStackView(axis: .vertical, spacing: TTSize.P_CONS_DEF * 2)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
        setupStyles()
        setupConstraints()
        bindComponents()
        updateStatus()
    }

    // MARK: - TTViewCodable

    func setupData() {
        title = XTextU("App.Debug.Nav.Title")
    }

    func setupUI() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(statusLabel)
        stackView.addArrangedSubview(connectButton)
        stackView.addArrangedSubview(logsButton)
        stackView.addArrangedSubview(networkButton)
    }

    func setupStyles() {
        statusLabel.setTextColor(color: TTView.textDefColor)
        statusLabel.setVerticalContentHuggingPriority()
    }

    func setupConstraints() {
        stackView.setCenterContraints(constant: 0)
            .done()
        connectButton.setFullWidth()
            .done()
        logsButton.setFullWidth()
            .done()
        networkButton.setFullWidth()
            .done()
    }

    func bindComponents() {
        connectButton.onTouchHandler = { [weak self] _ in
            self?.toggleConnection()
        }

        logsButton.onTouchHandler = { [weak self] _ in
            self?.showLogs()
        }

        networkButton.onTouchHandler = { [weak self] _ in
            self?.showNetworkMonitor()
        }
    }

    // MARK: - Actions

    private func toggleConnection() {
        if TTDebugBridge.shared.isConnected {
            TTDebugBridge.shared.disconnect()
        } else {
            TTDebugBridge.shared.connect()
        }
        updateStatus()
    }

    private func updateStatus() {
        let connected = TTDebugBridge.shared.isConnected
        let status = connected ? XText("App.Debug.Status.Connected") : XText("App.Debug.Status.Disconnected")
        statusLabel.setText(text: status)
        statusLabel.setTextColor(color: connected ? TTView.colorSuccess : TTView.colorError)

        let buttonText = connected ? XText("App.Debug.Button.Disconnect") : XText("App.Debug.Button.Connect")
        connectButton.setTextString(buttonText)
    }

    private func showLogs() {
        let vc = LogTrackingTableViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    private func showNetworkMonitor() {
        let vc = LogTrackingWebViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
```

## Step 6: Add Localization Keys

Add to `Localizable.strings`:

```
/* Debug */
"App.Debug.Nav.Title" = "Debug";
"App.Debug.Status.Connected" = "Connected to TTBDebugPlus";
"App.Debug.Status.Disconnected" = "Not connected";
"App.Debug.Button.Connect" = "Connect";
"App.Debug.Button.Disconnect" = "Disconnect";
"App.Debug.Button.ViewLogs" = "View Logs";
"App.Debug.Button.NetworkMonitor" = "Network Monitor";
```

Add to `Localizable-VI.strings`:

```
/* Debug */
"App.Debug.Nav.Title" = "Debug";
"App.Debug.Status.Connected" = "Đã kết nối TTBDebugPlus";
"App.Debug.Status.Disconnected" = "Chưa kết nối";
"App.Debug.Button.Connect" = "Kết nối";
"App.Debug.Button.Disconnect" = "Ngắt kết nối";
"App.Debug.Button.ViewLogs" = "Xem Logs";
"App.Debug.Button.NetworkMonitor" = "Giám sát mạng";
```

## Step 7: Using TTBDebugPlus

### On macOS

1. Open TTBDebugPlus app
2. Wait for iOS device to appear in the device list
3. Click on device to connect
4. View logs in real-time
5. Inspect view hierarchy
6. Monitor network requests

### On iOS Device

1. Open the app
2. Go to Debug tab
3. Tap "Connect" to connect to TTBDebugPlus
4. Or let it auto-connect if configured

### LogInterceptor Integration

TTBaseUIKit automatically intercepts `XPrint` logs:

```swift
// Logs will appear in TTBDebugPlus automatically
XPrint("User logged in: \(userId)")
XPrint("API response: \(response)")
```

## TTBaseDebugKit APIs

### TTDebugBridge

```swift
TTDebugBridge.shared.configure(host: "localhost", port: 8080)
TTDebugBridge.shared.connect()
TTDebugBridge.shared.disconnect()
TTDebugBridge.shared.isConnected
```

### LogInterceptor

```swift
LogInterceptor.shared.start()
LogInterceptor.shared.stop()
```

### TTBaseDebugKit

```swift
TTBaseDebugKit.setup()  // Auto-configures with defaults
```

## Verification Checklist

- [ ] TTBDebugPlus installed on macOS
- [ ] AppDelegate calls `TTBaseDebugKit.setup()` in DEBUG mode
- [ ] `import TTBaseUIKit` present (includes DebugBridge)
- [ ] Debug tab screen created
- [ ] Localization keys added
- [ ] macOS app and iOS device on same network
- [ ] xcodebuild BUILD SUCCEEDED

## Troubleshooting

| Issue | Cause | Fix |
|-------|-------|-----|
| Device not showing in TTBDebugPlus | Different network | Ensure same WiFi |
| Connection refused | Wrong port | Check `serverPort` config |
| No logs appearing | LogInterceptor not started | Call `LogInterceptor.shared.start()` |
| App crashes on release | DEBUG-only code | Wrap in `#if DEBUG` |

---

**Version**: 1.0.0 | **Date**: 2026-05-14
