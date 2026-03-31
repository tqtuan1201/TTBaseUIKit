<p align="center">
  <img src="https://tqtuan1201.github.io/images/TTBaseUIKit-Info-BG-1x.png" alt="TTBaseUIKit Banner" width="100%"/>
</p>

<h1 align="center">TTBaseUIKit</h1>

<p align="center">
  <strong>Build iOS Apps Faster — 100+ Production-Ready Base Views for UIKit & SwiftUI</strong>
</p>

<p align="center">
  <a href="https://github.com/tqtuan1201/TTBaseUIKit/releases"><img src="https://img.shields.io/badge/version-2.3.0-blue.svg" alt="Version"></a>
  <a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-5.0+-orange.svg" alt="Swift"></a>
  <a href="https://developer.apple.com/ios/"><img src="https://img.shields.io/badge/iOS-14%2B-green.svg" alt="iOS"></a>
  <a href="https://github.com/tqtuan1201/TTBaseUIKit/blob/master/LICENSE"><img src="https://img.shields.io/badge/license-MIT-lightgrey.svg" alt="License"></a>
  <a href="https://cocoapods.org/pods/TTBaseUIKit"><img src="https://img.shields.io/badge/CocoaPods-compatible-red.svg" alt="CocoaPods"></a>
  <a href="https://swift.org/package-manager"><img src="https://img.shields.io/badge/SPM-compatible-brightgreen.svg" alt="SPM"></a>
</p>

<p align="center">
  <a href="https://tqtuan1201.github.io/public/docs/ttbaseuikit/">📖 Documentation</a> •
  <a href="https://tqtuan1201.github.io/public/docs/ttbaseuikit/getting-started.html">🚀 Getting Started</a> •
  <a href="https://tqtuan1201.github.io/public/docs/ttbaseuikit/ttbdebugplus.html">🛠 TTBDebugPlus</a> •
  <a href="https://tqtuan1201.github.io/public/docs/ttbaseuikit/showcase.html">📱 Showcase</a> •
  <a href="https://tqtuan1201.github.io/public/docs/ttbaseuikit/blog.html">📝 Blog</a>
</p>

---

## Overview

TTBaseUIKit is an enterprise-grade iOS framework that eliminates boilerplate and accelerates development by providing **100+ production-ready base views** for both **UIKit** (programmatic) and **SwiftUI** (declarative). Ship production UI in hours, not days.

<p align="center">
  <img src="https://tqtuan1201.github.io/images/ttbaseuikit_compress_2.gif" width="80%" alt="TTBaseUIKit Demo" />
</p>

### Key Numbers

| Metric | Count |
|--------|-------|
| UIKit Components | 72+ |
| SwiftUI Views | 51+ |
| AI Agent Skills | 17 |
| Production Apps Shipped | 36+ |
| Users Reached | 5M+ |

## Features

### 🧱 UIKit Foundation
Production-ready programmatic views with **zero Storyboard/XIB** dependency:
- `TTBaseUIViewController`, `TTBaseUITableViewController`, `TTBaseUICollectionViewController`
- `TTBaseUIView`, `TTBaseUILabel`, `TTBaseUIButton`, `TTBaseUITextField`, `TTBaseUITextView`
- `TTBaseUIImageView`, `TTBaseUIStackView`, `TTBaseUIScrollView`
- `ViewCodable` protocol — structured lifecycle: `setupData → makeUI → makeConstraints → bindViewModel`
- Popup, Notification, Skeleton Loading, Segmented Control, PIN Input, and more
- Programmatic Auto Layout helpers — chainable, clean constraint syntax

### 🎨 SwiftUI Modernity (v2.3.0+)
Full SwiftUI support targeting iOS 14+:
- `BaseSUIView`, `BaseSUIText`, `BaseSUIButton`, `BaseSUIImage`
- `BaseSUIList`, `BaseSUIGroup`, `BaseSUITabView`, `BaseSUINavLink`
- `BaseSUISlider`, `BaseSUIToggle`, `BaseSUITextField`, `BaseSUIProgress`
- View modifiers: `ttFont()`, `ttShadow()`, `ttPadding()`
- Built-in Shimmer / Skeleton loading animations

### 🛠 Built-in UI Debug Kit (v2.2.1+)
Activate with a single line — no additional dependencies:
- **Triple-tap Layout Inspector** — visualize constraints and view hierarchy
- **API Response Log Viewer** — inspect request/response data in-app
- **Screen Capture** — annotate screenshots and share with team
- **Developer Settings Panel** — toggle environments, feature flags

```swift
LogViewHelper.share.config(
    withDes: "Debug Panel",
    isStartAppToShow: false,
    passCode: ""
).onShow()
// Long-press any screen to open | Triple-tap to inspect layout
```

<p align="center">
  <img src="https://tqtuan1201.github.io/images/TTBaseUIKit-DebugKit.gif" width="80%" alt="UI Debug Kit" />
</p>

### 🖥 TTBDebugPlus — macOS Companion Debugger

A native macOS app for debugging iOS apps in real-time — live console, network inspector, remote screenshots, and more. Built with SwiftUI.

> Requires TTBaseUIKit **v2.3.0+**. The DebugBridge SDK is bundled automatically.

<p align="center">
  <img src="https://tqtuan1201.github.io/public/docs/ttbaseuikit/images/ttbdebugplus-annotation.png" width="80%" alt="TTBDebugPlus — macOS Debugger for iOS" />
</p>

| Feature | Highlights |
|---------|-----------|
| 📋 Live Console | Log level filtering, full-text search, JSON inspector, auto-scroll LIVE mode |
| 🌐 Network Inspector | JSON Tree Viewer, waterfall timing, cURL & Postman export, API analytics |
| 📱 Device Control | Remote screenshot, dark mode toggle, app lifecycle (launch/kill/reset) |
| 📊 Performance | CPU, memory, FPS charts, bandwidth monitoring, slow request detection |
| 💬 Feedback & Export | Bug reports with annotated screenshots, Postman Collection v2.1, session files |

**Architecture:** iOS ↔ Bonjour (mDNS) ↔ WebSocket ↔ macOS — zero config, auto-discovery.

**Quick Start:**

```swift
// AppDelegate.swift
#if DEBUG
TTDebugBridge.shared.start()       // Auto-discover macOS app via Bonjour
LogInterceptor.shared.install()    // Auto-forward console logs
#endif
```

<p align="center">
  <a href="https://tqtuan1201.github.io/public/docs/ttbaseuikit/apps/TTBDebugPlus-Installer.dmg"><img src="https://img.shields.io/badge/⬇_Download-macOS_(.dmg)-0A84FF?style=for-the-badge&logo=apple&logoColor=white" alt="Download"/></a>
</p>
<p align="center"><sub>5.8 MB • macOS 14+ • Universal (Apple Silicon + Intel)</sub></p>

> 📖 [Full documentation & SDK integration guide →](https://tqtuan1201.github.io/public/docs/ttbaseuikit/ttbdebugplus.html)
> &nbsp;|&nbsp; 💻 [Source Code →](https://github.com/tqtuan1201/TTBDebugPlus)

### 🤖 AI Agent Ready
Pre-configured for modern AI coding assistants:
- **GitHub Copilot** — custom instructions & workspace prompts
- **Claude Code** — CLAUDE.md with project context
- **Xcode Agent Skills** — 17 custom agent skills
- **Google Gemini** — GEMINI.md configuration
- **OpenAI Codex** — codex.md setup

> 📖 [Explore AI Agent Skills →](https://tqtuan1201.github.io/public/docs/ttbaseuikit/ai-agents/index.html)

### 🎨 Configurable Design System
Control every aspect of your app's appearance globally:

```swift
let view = ViewConfig()
view.viewBgNavColor = .systemBlue
view.buttonBgDef    = .systemBlue
view.viewBgColor    = .white

let size = SizeConfig()
size.H_BUTTON = 44.0
size.H_SEG    = 50.0

let font = FontConfig()
font.HEADER_H       = 16
font.TITLE_H        = 14
font.SUB_TITLE_H    = 12

TTBaseUIKitConfig.withDefaultConfig(
    withFontConfig: font,
    frameSize: size,
    view: view
)?.start(withViewLog: true)
```

| Config | Purpose | Reference |
|--------|---------|-----------|
| [`ViewConfig`](https://github.com/tqtuan1201/TTBaseUIKit/blob/master/Sources/TTBaseUIKit/BaseConfig/ViewConfig.swift) | Colors for buttons, labels, backgrounds, navigation | Global theme |
| [`SizeConfig`](https://github.com/tqtuan1201/TTBaseUIKit/blob/master/Sources/TTBaseUIKit/BaseConfig/SizeConfig.swift) | Heights, corner radius, icon sizes, spacing | Layout system |
| [`FontConfig`](https://github.com/tqtuan1201/TTBaseUIKit/blob/master/Sources/TTBaseUIKit/BaseConfig/FontConfig.swift) | Typography scale: header, title, subtitle, body | Type system |

## Installation

### Swift Package Manager (Recommended)

**Via Xcode:**
1. File → Add Package Dependencies...
2. Enter URL: `https://github.com/tqtuan1201/TTBaseUIKit.git`
3. Select "Up to Next Major" from `2.3.0`

**Via `Package.swift`:**
```swift
dependencies: [
    .package(url: "https://github.com/tqtuan1201/TTBaseUIKit.git", from: "2.3.0")
]
```

### CocoaPods

```ruby
pod 'TTBaseUIKit'
```

### Carthage

```ruby
github "tqtuan1201/TTBaseUIKit"
```

### Manual

1. Clone or download the repository
2. Add `TTBaseUIKit.xcodeproj` to your project
3. Add `TTBaseUIKit.framework` as an embedded binary (General tab) and target dependency (Build Phases tab)

## Quick Start

```swift
import UIKit
import TTBaseUIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        // 1. Configure design system
        let view = ViewConfig()
        let size = SizeConfig()
        let font = FontConfig()
        
        TTBaseUIKitConfig.withDefaultConfig(
            withFontConfig: font,
            frameSize: size,
            view: view
        )?.start(withViewLog: true)

        // 2. (Optional) Enable debug bridge for TTBDebugPlus macOS
        #if DEBUG
        TTDebugBridge.shared.start()
        LogInterceptor.shared.install()
        #endif

        // 3. Set root view controller
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(
            rootViewController: HomeViewController()
        )
        window?.makeKeyAndVisible()
        
        return true
    }
}
```

## Usage Examples

### UIKit — Custom ViewController

```swift
import TTBaseUIKit

class HomeViewController: TTBaseUIViewController<TTBaseUIView> {

    let titleLabel = TTBaseUILabel()
    let actionButton = TTBaseUIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension HomeViewController: TTViewCodable {

    func setupStyles() {
        titleLabel.setText(text: "Welcome")
        actionButton.setText(text: "Get Started")
    }

    func setupCustomView() {
        view.addSubview(titleLabel)
        view.addSubview(actionButton)
    }

    func setupConstraints() {
        titleLabel.setTopAnchor(constant: 20)
        titleLabel.setCenterXAnchor(constant: 0)
        actionButton.setTopAnchor(titleLabel, constant: 16)
        actionButton.setCenterXAnchor(constant: 0)
    }
}
```

### SwiftUI — Declarative View

```swift
import TTBaseUIKit

struct HomeView: BaseSUIView {
    var body: some View {
        VStack(spacing: 16) {
            BaseSUIText("Welcome to TTBaseUIKit")
                .ttFont(type: .HEADER_H)
                .foregroundColor(.primary)

            BaseSUIButton(title: "Get Started") {
                // action
            }
            .ttButtonStyle(.filled)

            BaseSUIList(items: viewModel.items) { item in
                ItemRowView(item: item)
            }
        }
        .baseSUIPadding()
    }
}
```

### Auto Layout Helpers

```swift
// Chainable programmatic constraints
myView.setTopAnchor(constant: 16)
myView.setLeadingAnchor(constant: 20)
myView.setTrailingAnchor(constant: 20)
myView.setBottomAnchor(constant: 16)
myView.setCenterXAnchor(constant: 0)
myView.setcenterYAnchor(constant: 0)
```

### UI Components

```swift
// Notification banner
let noti = TTBaseNotificationViewConfig(with: window)
noti.setText(with: "Success!", subTitle: "Operation completed")
noti.notifiType = .SUCCESS
noti.onShow()

// Popup dialog
let popup = TTPopupViewController(
    title: "Confirm",
    subTitle: "Are you sure?",
    isAllowTouchPanel: true
)
present(popup, animated: true)

// Empty state for table view
tableView.setStaticBgNoData(
    title: "No Data",
    des: "Nothing to show yet"
) {
    print("Retry tapped")
}
```

## Project Structure

```
TTBaseUIKit/
├── Sources/TTBaseUIKit/
│   ├── BaseConfig/          # ViewConfig, SizeConfig, FontConfig
│   ├── Coordinators/        # Navigation coordination
│   ├── CustomView/          # 72+ UIKit base views
│   │   ├── BaseUIView/
│   │   ├── BaseUILabel/
│   │   ├── BaseUIButton/
│   │   ├── BaseUITextField/
│   │   ├── BaseUITableView/
│   │   ├── BaseUICollectionView/
│   │   ├── ViewCodable/
│   │   └── ...
│   ├── SwiftUIView/         # 51+ SwiftUI views
│   │   ├── BaseSUIView/
│   │   ├── BaseSUIText/
│   │   ├── BaseSUIButton/
│   │   └── ...
│   ├── Extensions/          # String, Date, JSON, Device utilities
│   └── Support/
│       ├── DebugBridge/     # TTBDebugPlus iOS SDK
│       └── Resources/      # Fonts, Images
├── TTBaseUIKitExample/      # Official sample project
├── TTBDebugPlus/            # macOS companion app (Xcode project)
├── Agents/                  # AI agent configurations
├── docs/                    # Documentation website
├── Package.swift
├── TTBaseUIKit.podspec
└── LICENSE
```

## Example Project

The [`TTBaseUIKitExample`](https://github.com/tqtuan1201/TTBaseUIKit/tree/master/TTBaseUIKitExample) project demonstrates:
- UIKit programmatic views (BaseUIViewController, TableView, CollectionView)
- SwiftUI declarative views (BaseSUIView, BaseSUIButton, BaseSUIText)
- Built-in UI Debug Kit (layout inspector, API log viewer)
- ViewCodable protocol lifecycle
- Theme configuration
- Auto Layout helpers

```bash
git clone https://github.com/tqtuan1201/TTBaseUIKit.git
open TTBaseUIKit.xcodeproj
# Select TTBaseUIKitExample target → Run (⌘R)
```

## Apps Built with TTBaseUIKit

<table>
<tr>
<td align="center" width="25%">
<strong>12Bay iOS</strong><br/>
<em>✈️ Travel • #20 App Store VN</em><br/>
<sub>UIKit + SwiftUI • MVVM/VIPER</sub>
</td>
<td align="center" width="25%">
<strong>Aihealth - Truedoc</strong><br/>
<em>🏥 Healthcare • Pre-Series A</em><br/>
<sub>UIKit • AI Diagnostics</sub>
</td>
<td align="center" width="25%">
<strong>TMS Mobile</strong><br/>
<em>🚛 Logistics</em><br/>
<sub>UIKit • Real-time GPS</sub>
</td>
<td align="center" width="25%">
<strong>WECARE 247</strong><br/>
<em>🫶 Care Management</em><br/>
<sub>UIKit + SwiftUI</sub>
</td>
</tr>
<tr>
<td align="center" width="25%">
<strong>12Bay macOS</strong><br/>
<em>🖥️ Mac Catalyst</em><br/>
<sub>Shared codebase with iOS</sub>
</td>
<td align="center" width="25%">
<strong>AiDoctor</strong><br/>
<em>⚕️ Telemedicine</em><br/>
<sub>UIKit • Video Consult</sub>
</td>
<td align="center" width="25%">
<strong>AiPharmacy</strong><br/>
<em>💊 Pharmacy</em><br/>
<sub>UIKit • Order Management</sub>
</td>
<td align="center" width="25%">
<strong>Contacts Plus</strong><br/>
<em>👤 Productivity</em><br/>
<sub>UIKit • App Store</sub>
</td>
</tr>
</table>

> **36+ production apps** shipped across Travel, Healthcare, Logistics, Education, and more.
> See full showcase → [Apps Showcase](https://tqtuan1201.github.io/public/docs/ttbaseuikit/showcase.html)

## Documentation

| Resource | Link |
|----------|------|
| 📖 Full Documentation | [tqtuan1201.github.io/public/docs/ttbaseuikit](https://tqtuan1201.github.io/public/docs/ttbaseuikit/) |
| 🚀 Getting Started | [Installation & Setup Guide](https://tqtuan1201.github.io/public/docs/ttbaseuikit/getting-started.html) |
| 🧱 UIKit Components | [72+ Component Docs](https://tqtuan1201.github.io/public/docs/ttbaseuikit/uikit/index.html) |
| 🎨 SwiftUI Views | [51+ View Docs](https://tqtuan1201.github.io/public/docs/ttbaseuikit/swiftui/index.html) |
| 🛠 TTBDebugPlus | [macOS Debugger & SDK Guide](https://tqtuan1201.github.io/public/docs/ttbaseuikit/ttbdebugplus.html) |
| 🤖 AI Agent Skills | [17 Agent Configurations](https://tqtuan1201.github.io/public/docs/ttbaseuikit/ai-agents/index.html) |
| 🎬 Project Demo | [TTBaseUIKitExample Demo](https://tqtuan1201.github.io/public/docs/ttbaseuikit/demo.html) |
| 📱 Apps Showcase | [36+ Production Apps](https://tqtuan1201.github.io/public/docs/ttbaseuikit/showcase.html) |
| 📝 Author's Blog | [Technical Articles](https://tqtuan1201.github.io/public/docs/ttbaseuikit/blog.html) |

## Requirements

| Requirement | Minimum |
|-------------|---------|
| iOS | 14.0+ |
| macOS (Catalyst) | 10.15+ |
| Swift | 5.0+ |
| Xcode | 13.0+ |
| TTBDebugPlus (macOS) | macOS 14+ |

## Contributing

Contributions are welcome! Feel free to:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

If you find TTBaseUIKit useful, please consider giving it a ⭐ — it helps others discover the project.

## Author

**Truong Quang Tuan** — Mobile Lead & Framework Author

- 🌐 Website: [tqtuan1201.github.io](https://tqtuan1201.github.io/)
- 📧 Email: [truongquangtuanit@gmail.com](mailto:truongquangtuanit@gmail.com)
- 👤 Portfolio: [tqtuan1201.github.io/portfolio](https://tqtuan1201.github.io/portfolio/)
- 👥 Meet the Team: [Our Team](https://tqtuan1201.github.io/posts/job/cv/ourteam/)

We build high-quality apps. [Get in touch](https://tqtuan1201.github.io/) if you need help with a project.

## License

TTBaseUIKit is available under the **MIT License**. See the [LICENSE](LICENSE) file for details.

```
MIT License — Copyright (c) 2019 Quang Tuan
```
