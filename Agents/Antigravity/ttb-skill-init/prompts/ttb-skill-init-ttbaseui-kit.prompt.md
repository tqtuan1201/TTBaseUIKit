---
name: "ttb-skill-init-ttbaseui-kit"
description: "TTBaseUIKitConfig initialization + dependency setup (SPM/CocoaPods) for TTBaseUIKit projects."
version: "1.3.0"
---

# ttb-skill-init-ttbaseui-kit — TTBaseUIKit Dependency + Config Setup

## Purpose

Setup TTBaseUIKit dependency and initialize TTBaseUIKitConfig so all other skills work correctly.

## When to Run

Run via `/ttb-init-config` command after `/ttb-init` or standalone.

## Step 1: Add TTBaseUIKit Dependency

### Option A: Swift Package Manager (SPM)

Open `Package.swift` and add TTBaseUIKit to dependencies:

```swift
// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "{ProjectName}",
    platforms: [
        .iOS(.v14),
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "{ProjectName}",
            targets: ["{ProjectName}"]
        ),
    ],
    dependencies: [
        // TTBaseUIKit
        .package(url: "https://github.com/tuantt20/TTBaseUIKit.git", from: "2.1.0"),
    ],
    targets: [
        .target(
            name: "{ProjectName}",
            dependencies: [
                "TTBaseUIKit",  // ← Add this
            ],
            path: ".",
            exclude: ["Tests"]
        ),
    ]
)
```

Then resolve packages:
```bash
cd /path/to/project
xcodebuild -resolvePackageDependencies -project {ProjectName}.xcodeproj -scheme {SchemeName}
```

### Option B: CocoaPods

Open `Podfile` and add TTBaseUIKit:

```ruby
platform :ios, '14.0'
use_frameworks!

target '{ProjectName}' do
  # TTBaseUIKit
  pod 'TTBaseUIKit', '~> 2.1.0'

  # Other pods
  # pod 'SnapKit', '~> 5.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
    end
  end
end
```

Then install:
```bash
cd /path/to/project
pod install
```

**Note**: After running `pod install`, open the `.xcworkspace` file instead of `.xcodeproj`.

## Step 2: Initialize TTBaseUIKitConfig

Add to `AppDelegate.swift` in the `didFinishLaunchingWithOptions` method:

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

    // MARK: - UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {}
}
```

## Step 3: TTBaseUIKitConfig Reference

### What TTBaseUIKitConfig Does

TTBaseUIKitConfig initializes the design system:
- Loads font configuration (TTFont)
- Loads size configuration (TTSize)
- Loads view/color configuration (TTView)
- Enables view logging (debug)

### Config Components

| Component | Class | Purpose |
|-----------|-------|---------|
| Font | `TTBaseUIKitFontConfig` | Header, title, subtitle, content font sizes |
| Size | `TTBaseUIKitFrameSize` | Button height, padding, corner radius |
| View | `TTBaseUIKitViewConfig` | Colors, backgrounds, icons |

### Config Accessors

After initialization, use these throughout the app:

```swift
XView    // = TTBaseUIKitConfig.getViewConfig   (colors)
XSize    // = TTBaseUIKitConfig.getSizeConfig   (spacing)
XFont    // = TTBaseUIKitConfig.getFontConfig   (fonts)
TTView   // = TTBaseUIKitConfig.getViewConfig
TTSize   // = TTBaseUIKitConfig.getSizeConfig
TTFont   // = TTBaseUIKitConfig.getFontConfig
```

## Step 4: Custom Configuration (Optional)

### Custom Font Config

```swift
func customFontConfig() -> TTBaseUIKitFontConfig {
    let config = TTBaseUIKitFontConfig()

    // Override fonts
    config.setHeaderFont(UIFont.systemFont(ofSize: 28, weight: .bold))
    config.setTitleFont(UIFont.systemFont(ofSize: 20, weight: .semibold))
    config.setContentFont(UIFont.systemFont(ofSize: 16, weight: .regular))
    config.setSubtitleFont(UIFont.systemFont(ofSize: 14, weight: .regular))

    return config
}
```

### Custom View Config

```swift
func customViewConfig() -> TTBaseUIKitViewConfig {
    let config = TTBaseUIKitViewConfig()

    // Override colors
    config.setTextDefColor(UIColor.label)
    config.setTextHeaderColor(UIColor.label)
    config.setTextSubTitleColor(UIColor.secondaryLabel)
    config.setViewBgColor(UIColor.systemBackground)
    config.setButtonBgDef(UIColor.systemBlue)

    // Override icons
    // config.setIconColor(UIColor.systemGray)

    return config
}
```

### Full Custom Config Setup

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  AppConfig.swift
//  {AppName}
//
import UIKit
import TTBaseUIKit

enum AppConfig {

    static func configure() {
        TTBaseUIKitConfig.withDefaultConfig(
            withFontConfig: fontConfig(),
            frameSize: TTBaseUIKitFrameSize(),
            view: viewConfig()
        )?.start(withViewLog: true)
    }

    private static func fontConfig() -> TTBaseUIKitFontConfig {
        let config = TTBaseUIKitFontConfig()
        config.setHeaderFont(UIFont.systemFont(ofSize: 24, weight: .bold))
        config.setTitleFont(UIFont.systemFont(ofSize: 18, weight: .semibold))
        config.setContentFont(UIFont.systemFont(ofSize: 16, weight: .regular))
        config.setSubtitleFont(UIFont.systemFont(ofSize: 14, weight: .regular))
        return config
    }

    private static func viewConfig() -> TTBaseUIKitViewConfig {
        let config = TTBaseUIKitViewConfig()

        // Text colors
        config.setTextDefColor(UIColor.label)
        config.setTextHeaderColor(UIColor.label)
        config.setTextSubTitleColor(UIColor.secondaryLabel)

        // Backgrounds
        config.setViewBgColor(UIColor.systemBackground)
        config.setViewBgSecondaryColor(UIColor.secondarySystemBackground)

        // Buttons
        config.setButtonBgDef(UIColor.systemBlue)
        config.setButtonTextDef(UIColor.white)

        return config
    }
}
```

## Step 5: Verify Import

After adding the dependency, verify in any Swift file:

```swift
import TTBaseUIKit

class MyVC: BaseViewController {
    func test() {
        // Should compile without errors
        let color = TTView.textDefColor
        let size = TTSize.P_CONS_DEF
        let font = TTFont.TITLE_H
    }
}
```

## Step 6: xcodebuild Verification

```bash
cd /path/to/project
xcodebuild -project {ProjectName}.xcodeproj \
  -scheme {SchemeName} \
  -destination 'platform=iOS Simulator,name=iPhone 11' \
  build 2>&1 | grep -E "(error:|warning: cannot find|warning: 'TTBaseUIKit'|BUILD SUCCEEDED|BUILD FAILED)"
```

### Common Errors

| Error | Cause | Fix |
|-------|-------|-----|
| `cannot find module 'TTBaseUIKit'` | SPM not resolved | Run `xcodebuild -resolvePackageDependencies` |
| `cannot find module 'TTBaseUIKit'` | Pod not installed | Run `pod install` |
| `Use of undeclared type 'TTBaseUIKitConfig'` | Import missing | Add `import TTBaseUIKit` |
| `Value of type 'TTBaseUIKitConfig?' has no member 'withDefaultConfig'` | Wrong API | Use `TTBaseUIKitConfig.withDefaultConfig(...)` |

### Success Output

```
CompileSwiftSources normal x86_64 Compiling
CompileSwiftSources normal x86_64 Compiling TTBaseUIKit
...
BUILD SUCCEEDED
```

## Verification Checklist

- [ ] `Package.swift` includes TTBaseUIKit dependency (SPM)
- [ ] OR `Podfile` includes TTBaseUIKit pod (CocoaPods)
- [ ] `AppDelegate.swift` calls `TTBaseUIKitConfig.withDefaultConfig(...).start()`
- [ ] `import TTBaseUIKit` present in AppDelegate
- [ ] TTBaseUIKit types accessible (TTView, TTSize, TTFont)
- [ ] xcodebuild BUILD SUCCEEDED

---

**Version**: 1.0.0 | **Date**: 2026-05-14
