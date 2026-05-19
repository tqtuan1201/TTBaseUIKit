---
name: "ttb-skill-init-prompt"
description: "Full 8-phase TTBaseUIKit project initialization workflow. Run AFTER SKILL.md activation."
version: "1.3.0"
---

# ttb-skill-init — Full Project Initialization Workflow

## Purpose

Initialize a complete TTBaseUIKit project foundation so all other skills (uikit, swiftui, bugfix, refactor, audit) can build without errors.

## When to Run

Run this prompt after activating `/ttb-init` command from `SKILL.md`.

---

## Phase 0: Pre-Init Assessment

### Clarifying Questions

Before creating any files, ask the user these questions:

**Q1: Dependency Manager**
> Which dependency manager do you use?
> - SPM (Swift Package Manager) — add to Package.swift
> - CocoaPods — add to Podfile

**Q2: Architecture**
> Which UI framework?
> - UIKit only — TTBaseUIKit UIKit components
> - SwiftUI only — TTBaseSUI components
> - Hybrid (UIKit + SwiftUI) — both, with NavigationLink between them

**Q3: Navigation Style**
> How does the app navigate between screens?
> - Tab Bar — 5-tab structure like TTBaseUIKitExample (Home, Demos, DebugBridge, UIDebug, Contact)
> - Single Navigation Stack — one navigation controller
> - Custom Coordinator — MVVM-C with no tab bar

**Q4: TTBDebugPlus**
> Include macOS debugger companion (TTBDebugPlus)?
> - YES — requires TTBaseDebugKit + TTDebugBridge + macOS DMG companion app
> - NO — skip debug integration

**Q5: Project Location**
> What is the absolute path to the project root?
> What is the Xcode scheme name?

---

## Phase 1: Project Folder Structure

Create the MVVM-C directory tree. Adapt based on architecture choice from Phase 0.

### Directory Tree (All Architectures)

```
{ProjectName}/
├── App/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift          (iOS only)
│   ├── BaseTabBarController.swift  (Tab Bar only)
│   └── BaseNavigationController.swift
├── Coordinators/
│   ├── AppCoordinator.swift
│   └── BaseCoordinator.swift
├── Core/
│   ├── Base/
│   │   ├── BaseViewController.swift
│   │   └── BaseViewModel.swift
│   ├── Extensions/
│   │   └── (extracted extensions)
│   └── Utilities/
│       └── Constants.swift
├── Resources/
│   ├── Localizable.strings
│   ├── Localizable-VI.strings
│   ├── Info.plist
│   └── Assets.xcassets/
│       └── (app icon, colors)
├── Features/                       (UIKit only or Hybrid)
│   └── (Feature modules)
│       └── {FeatureName}/
│           ├── Coordinators/
│           ├── ViewModels/
│           ├── Models/
│           ├── APIs/
│           ├── ViewControllers/
│           ├── Views/
│           └── CustomViews/
├── Screens/                        (SwiftUI only or Hybrid)
│   └── (Feature screens)
│       └── {FeatureName}/
│           ├── {Name}Screen.swift
│           ├── {Name}ViewModel.swift
│           ├── {Name}Model.swift
│           └── Components/
│               └── {Name}ItemView.swift
└── Services/                       (Shared)
    └── (APIs, Managers, Utilities)
```

### File: App/AppDelegate.swift

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  AppDelegate.swift
//  {AppName}
//
import UIKit

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

    // MARK: - UISceneSession Lifecycle (iOS)

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

### File: App/SceneDelegate.swift

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  SceneDelegate.swift
//  {AppName}
//
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var appCoordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        self.appCoordinator = AppCoordinator(window: window)
        self.appCoordinator?.start()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
```

### File: App/BaseTabBarController.swift (Tab Bar only)

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  BaseTabBarController.swift
//  {AppName}
//
import UIKit

class BaseTabBarController: TTBaseUITabBarController {

    // MARK: - Tab Data

    struct Tab {
        let title: String
        let icon: String
        let selectedIcon: String
        let coordinator: TTCoordinator
    }

    private var tabs: [Tab] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }

    // MARK: - Setup

    private func setupTabs() {
        // Tab 1: Home
        let homeCoordinator = HomeCoordinator()
        homeCoordinator.start()
        tabs.append(Tab(
            title: XText("App.Tab.Home"),
            icon: "house",
            selectedIcon: "house.fill",
            coordinator: homeCoordinator
        ))

        // Tab 2: Demos
        let demosCoordinator = DemosCoordinator()
        demosCoordinator.start()
        tabs.append(Tab(
            title: XText("App.Tab.Demos"),
            icon: "play.square",
            selectedIcon: "play.square.fill",
            coordinator: demosCoordinator
        ))

        // Tab 3: DebugBridge
        let debugCoordinator = DebugCoordinator()
        debugCoordinator.start()
        tabs.append(Tab(
            title: XText("App.Tab.Debug"),
            icon: "ant",
            selectedIcon: "ant.fill",
            coordinator: debugCoordinator
        ))

        // Tab 4: UIDebug
        let uiDebugCoordinator = UIDebugCoordinator()
        uiDebugCoordinator.start()
        tabs.append(Tab(
            title: XText("App.Tab.UIDebug"),
            icon: "eye",
            selectedIcon: "eye.fill",
            coordinator: uiDebugCoordinator
        ))

        // Tab 5: Contact
        let contactCoordinator = ContactCoordinator()
        contactCoordinator.start()
        tabs.append(Tab(
            title: XText("App.Tab.Contact"),
            icon: "person",
            selectedIcon: "person.fill",
            coordinator: contactCoordinator
        ))

        let viewControllers = tabs.map { tab -> UINavigationController in
            let nav = BaseNavigationController(rootViewController: tab.coordinator.currVC!)
            nav.tabBarItem = UITabBarItem(
                title: tab.title,
                image: UIImage(systemName: tab.icon),
                selectedImage: UIImage(systemName: tab.selectedIcon)
            )
            return nav
        }

        setViewControllers(viewControllers, animated: false)
    }

    private func setupAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = TTView.viewBgColor
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}
```

### File: App/BaseNavigationController.swift

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  BaseNavigationController.swift
//  {AppName}
//
import UIKit

class BaseNavigationController: TTBaseUINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }

    private func setupAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = TTView.viewBgColor
        appearance.titleTextAttributes = [
            .foregroundColor: TTView.textHeaderColor,
            .font: UIFont.systemFont(ofSize: TTFont.TITLE_H, weight: .semibold)
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: TTView.textHeaderColor,
            .font: UIFont.systemFont(ofSize: TTFont.HEADER_H, weight: .bold)
        ]

        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.tintColor = TTView.iconPrimaryColor
    }
}
```

### File: Coordinators/BaseCoordinator.swift

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  BaseCoordinator.swift
//  {AppName}
//
import UIKit

class BaseCoordinator: TTCoordinator {

    fileprivate(set) var currVC: UIViewController?
    weak var parentCoordinator: TTCoordinator?

    func start() {
        fatalError("Override in subclass")
    }

    func showScreen(_ vc: UIViewController, animated: Bool = true) {
        currVC = vc
        if let nav = currVC?.navigationController {
            nav.pushViewController(vc, animated: animated)
        } else if let tab = currVC?.tabBarController {
            // Handle tab switching if needed
        }
    }
}
```

### File: Coordinators/AppCoordinator.swift

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  AppCoordinator.swift
//  {AppName}
//
import UIKit

class AppCoordinator: BaseCoordinator {

    private var window: UIWindow?
    private var tabBarController: BaseTabBarController?

    init(window: UIWindow) {
        self.window = window
        super.init()
    }

    override func start() {
        DispatchQueue.main.async { [weak self] in
            self?.showApp()
        }
    }

    private func showApp() {
        // Using Tab Bar
        let tabBar = BaseTabBarController()
        self.tabBarController = tabBar

        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
    }
}
```

### File: Core/Base/BaseViewController.swift

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  BaseViewController.swift
//  {AppName}
//
import UIKit

class BaseViewController: TTBaseUIViewController<TTBaseUIView> {

    // MARK: - Properties

    var coordinator: BaseCoordinator? {
        return findParentCoordinator()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseUI()
    }

    // MARK: - Setup

    private func setupBaseUI() {
        view.backgroundColor = TTView.viewBgColor
        contentView.backgroundColor = TTView.viewBgColor
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: - Helpers

    private func findParentCoordinator() -> BaseCoordinator? {
        var responder: UIResponder? = self
        while let next = responder?.next {
            if let coord = next as? BaseCoordinator {
                return coord
            }
            responder = next
        }
        return nil
    }

    // MARK: - Loading

    func showLoading() {
        showLoadingView(type: .VIEW_CENTER)
    }

    func hideLoading() {
        removeLoading()
    }

    // MARK: - Alert

    func showError(_ message: String) {
        showAlert(message: message)
    }

    func showSuccess(_ message: String) {
        showAlert(message: message)
    }
}
```

### File: Core/Base/BaseViewModel.swift

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  BaseViewModel.swift
//  {AppName}
//
import Foundation

class BaseViewModel {

    // MARK: - Callbacks

    var onShowError: ((String) -> Void)?
    var onShowLoading: (() -> Void)?
    var onHideLoading: (() -> Void)?
    var onSuccess: (() -> Void)?
    var onUpdateUI: (() -> Void)?

    // MARK: - State

    private(set) var isFetching = false

    // MARK: - Lifecycle

    deinit {
        XPrint("Deinit: \(String(describing: type(of: self)))")
    }

    // MARK: - Fetch Guards

    func beginFetching() -> Bool {
        guard !isFetching else { return false }
        isFetching = true
        onShowLoading?()
        return true
    }

    func endFetching() {
        isFetching = false
        onHideLoading?()
    }
}
```

### File: Core/Utilities/Constants.swift

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  Constants.swift
//  {AppName}
//
import Foundation

enum Constants {

    enum App {
        static let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "App"
        static let bundleId = Bundle.main.bundleIdentifier ?? "com.app.bundle"
        static let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        static let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
    }

    enum API {
        static let baseURL = "https://api.example.com"
        static let timeout: TimeInterval = 30.0
    }

    enum Cache {
        static let maxAge: TimeInterval = 3600
        static let maxSize = 50 * 1024 * 1024
    }

    enum Animation {
        static let defaultDuration: TimeInterval = 0.3
        static let springDamping: CGFloat = 0.8
    }
}
```

---

## Phase 2: Dependency Setup

### For SPM — Update Package.swift

If `Package.swift` does not exist, create it:

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
        .package(url: "https://github.com/your-org/TTBaseUIKit.git", from: "2.1.0"),
    ],
    targets: [
        .target(
            name: "{ProjectName}",
            dependencies: ["TTBaseUIKit"],
            path: ".",
            exclude: ["Tests", "TTBaseUIKitExample"]
        ),
        .testTarget(
            name: "{ProjectName}Tests",
            dependencies: ["{ProjectName}"],
            path: "Tests"
        ),
    ]
)
```

If `Package.swift` exists, add TTBaseUIKit to the dependencies array:

```swift
// Find the dependencies array and add:
.package(url: "https://github.com/your-org/TTBaseUIKit.git", from: "2.1.0"),

// Find the target dependencies and add "TTBaseUIKit":
dependencies: ["TTBaseUIKit"],
```

### For CocoaPods — Update Podfile

If `Podfile` does not exist, create it:

```ruby
platform :ios, '14.0'
use_frameworks!

target '{ProjectName}' do
  pod 'TTBaseUIKit', '~> 2.1.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
    end
  end
end
```

If `Podfile` exists, add TTBaseUIKit to the target:

```ruby
pod 'TTBaseUIKit', '~> 2.1.0'
```

Then run:
```bash
pod install
```

---

## Phase 3: TTBaseUIKitConfig (Already done in AppDelegate)

The `AppDelegate.swift` created in Phase 1 already includes TTBaseUIKitConfig initialization. Verify:

```swift
private func setupTTBaseUIKit() {
    TTBaseUIKitConfig.withDefaultConfig(
        withFontConfig: TTBaseUIKitFontConfig(),
        frameSize: TTBaseUIKitFrameSize(),
        view: TTBaseUIKitViewConfig()
    )?.start(withViewLog: true)
}
```

### Custom Config (Optional)

If user wants custom colors/sizes, create `AppConfig.swift`:

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  AppConfig.swift
//  {AppName}
//
import UIKit

enum AppConfig {

    static func configure() {
        let config = TTBaseUIKitConfig.withDefaultConfig(
            withFontConfig: customFontConfig(),
            frameSize: TTBaseUIKitFrameSize(),
            view: customViewConfig()
        )
        config?.start(withViewLog: true)
    }

    private static func customFontConfig() -> TTBaseUIKitFontConfig {
        let config = TTBaseUIKitFontConfig()

        // Override header font
        config.setHeaderFont(UIFont.systemFont(ofSize: 24, weight: .bold))

        // Override title font
        config.setTitleFont(UIFont.systemFont(ofSize: 18, weight: .semibold))

        // Override content font
        config.setContentFont(UIFont.systemFont(ofSize: 16, weight: .regular))

        // Override subtitle font
        config.setSubtitleFont(UIFont.systemFont(ofSize: 14, weight: .regular))

        return config
    }

    private static func customViewConfig() -> TTBaseUIKitViewConfig {
        let config = TTBaseUIKitViewConfig()

        // Override colors
        config.setButtonBgDef(UIColor.systemBlue)
        config.setTextDefColor(UIColor.label)

        return config
    }
}
```

---

## Phase 4: Localization Setup

Create `Resources/Localizable.strings` (English):

```
/* Common */
"App.Common.Button.Confirm" = "Confirm";
"App.Common.Button.Cancel" = "Cancel";
"App.Common.Button.Save" = "Save";
"App.Common.Button.Delete" = "Delete";
"App.Common.Button.Edit" = "Edit";
"App.Common.Button.Retry" = "Retry";
"App.Common.Button.Close" = "Close";
"App.Common.Button.Submit" = "Submit";
"App.Common.Button.Next" = "Next";
"App.Common.Button.Back" = "Back";
"App.Common.Button.Done" = "Done";
"App.Common.Button.Skip" = "Skip";

/* Alerts */
"App.Common.Alert.Error" = "Error";
"App.Common.Alert.Success" = "Success";
"App.Common.Alert.Warning" = "Warning";
"App.Common.Alert.Info" = "Information";

/* States */
"App.Common.Loading" = "Loading...";
"App.Common.Empty" = "No data available";
"App.Common.Retry" = "Retry";
"App.Common.Search" = "Search";
"App.Common.NoResults" = "No results found";

/* Errors */
"App.Common.Error.Network" = "Network error. Please check your connection.";
"App.Common.Error.Server" = "Server error. Please try again later.";
"App.Common.Error.Unknown" = "An unexpected error occurred.";
"App.Common.Error.Timeout" = "Request timed out. Please try again.";

/* Tabs */
"App.Tab.Home" = "Home";
"App.Tab.Demos" = "Demos";
"App.Tab.Debug" = "Debug";
"App.Tab.UIDebug" = "UIDebug";
"App.Tab.Contact" = "Contact";
```

Create `Resources/Localizable-VI.strings` (Vietnamese):

```
/* Common */
"App.Common.Button.Confirm" = "Xác nhận";
"App.Common.Button.Cancel" = "Hủy";
"App.Common.Button.Save" = "Lưu";
"App.Common.Button.Delete" = "Xóa";
"App.Common.Button.Edit" = "Sửa";
"App.Common.Button.Retry" = "Thử lại";
"App.Common.Button.Close" = "Đóng";
"App.Common.Button.Submit" = "Gửi";
"App.Common.Button.Next" = "Tiếp tục";
"App.Common.Button.Back" = "Quay lại";
"App.Common.Button.Done" = "Xong";
"App.Common.Button.Skip" = "Bỏ qua";

/* Alerts */
"App.Common.Alert.Error" = "Lỗi";
"App.Common.Alert.Success" = "Thành công";
"App.Common.Alert.Warning" = "Cảnh báo";
"App.Common.Alert.Info" = "Thông tin";

/* States */
"App.Common.Loading" = "Đang tải...";
"App.Common.Empty" = "Không có dữ liệu";
"App.Common.Retry" = "Thử lại";
"App.Common.Search" = "Tìm kiếm";
"App.Common.NoResults" = "Không tìm thấy kết quả";

/* Errors */
"App.Common.Error.Network" = "Lỗi mạng. Vui lòng kiểm tra kết nối.";
"App.Common.Error.Server" = "Lỗi máy chủ. Vui lòng thử lại sau.";
"App.Common.Error.Unknown" = "Đã xảy ra lỗi không mong muốn.";
"App.Common.Error.Timeout" = "Hết thời gian chờ. Vui lòng thử lại.";

/* Tabs */
"App.Tab.Home" = "Trang chủ";
"App.Tab.Demos" = "Demo";
"App.Tab.Debug" = "Debug";
"App.Tab.UIDebug" = "UIDebug";
"App.Tab.Contact" = "Liên hệ";
```

### Update Info.plist for Localization

Ensure Info.plist includes:

```xml
<key>CFBundleDevelopmentRegion</key>
<string>en</string>
<key>CFBundleLocalizations</key>
<array>
    <string>en</string>
    <string>vi</string>
</array>
```

---

## Phase 5: Navigation Architecture

This was partially set up in Phase 1 with BaseCoordinator and AppCoordinator. For each feature, create:

### Feature Coordinator Template

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  {Feature}Coordinator.swift
//  {AppName}
//
import UIKit

class {Feature}Coordinator: BaseCoordinator {

    override func start() {
        DispatchQueue.main.async {
            self.showHome()
        }
    }

    func showHome() {
        let vm = {Feature}ViewModel()
        let vc = {Feature}ViewController(viewModel: vm)
        vm.onNavigateToDetail = { [weak self] item in
            self?.showDetail(item: item)
        }
        self.currVC = vc

        if let nav = findNavigationController() {
            nav.setViewControllers([vc], animated: false)
        }
    }

    func showDetail(item: {Feature}Item) {
        let vm = {Feature}DetailViewModel(item: item)
        let vc = {Feature}DetailViewController(viewModel: vm)
        self.currVC = vc

        if let nav = findNavigationController() {
            nav.pushViewController(vc, animated: true)
        }
    }

    private func findNavigationController() -> UINavigationController? {
        return currVC?.navigationController
            ?? tabBarController?.selectedViewController as? UINavigationController
    }
}
```

---

## Phase 6: TTBDebugPlus Integration (Optional)

Only if user selected YES for TTBDebugPlus in Phase 0.

### Setup TTBaseDebugKit

In `AppDelegate.swift`, add after TTBaseUIKitConfig:

```swift
// TTBDebugPlus Setup
TTBaseDebugKit.setup()
```

### Debug Bridge (Optional - macOS companion)

Create `Core/Utilities/DebugBridgeConfig.swift`:

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  DebugBridgeConfig.swift
//  {AppName}
//
import Foundation

enum DebugBridgeConfig {
    static let serverHost = "localhost"
    static let serverPort = 8080
    static let autoConnect = true
    static let enableLogIntercept = true

    static func configure() {
        TTDebugBridge.shared.configure(
            host: serverHost,
            port: serverPort
        )

        if enableLogIntercept {
            LogInterceptor.shared.start()
        }

        if autoConnect {
            TTDebugBridge.shared.connect()
        }
    }
}
```

### TTBDebugPlus Info

To use TTBDebugPlus:

1. Download `TTBDebugPlus-Installer.dmg` from TTBaseUIKit releases
2. Install the macOS companion app
3. Run the companion app on macOS
4. Ensure iOS device/simulator and Mac are on the same network
5. The app will auto-detect and connect

---

## Phase 7: Resources

### Info.plist Additions

Ensure these keys exist in Info.plist:

```xml
<!-- Localization -->
<key>CFBundleDevelopmentRegion</key>
<string>en</string>
<key>CFBundleDisplayName</key>
<string>{AppName}</string>
<key>CFBundleLocalizations</key>
<array>
    <string>en</string>
    <string>vi</string>
</array>

<!-- App Transport Security (for debug) -->
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

### Assets.xcassets

Create `Assets.xcassets/AppIcon.appiconset/Contents.json`:

```json
{
  "images" : [
    {
      "idiom" : "universal",
      "platform" : "ios",
      "size" : "1024x1024"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
```

Create `Assets.xcassets/AccentColor.colorset/Contents.json`:

```json
{
  "colors" : [
    {
      "color" : {
        "color-space" : "srgb",
        "components" : {
          "alpha" : "1.000",
          "blue" : "1.000",
          "green" : "0.478",
          "red" : "0.000"
        }
      },
      "idiom" : "universal"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
```

---

## Phase 8: xcodebuild Verification

### Step 1: Register Files with Xcode

Use the ruby script if available:

```bash
ruby .agent/skills/ttbase-swiftui/scripts/add_to_xcode_project.rb "{file_path}"
```

Or manually add files via Xcode:
1. Open the project in Xcode
2. Right-click on the group/folder
3. Select "Add Files to..."
4. Select the created files
5. Ensure "Copy items if needed" is unchecked
6. Ensure "Create groups" is selected
7. Click Add

### Step 2: Run xcodebuild

```bash
cd /path/to/{ProjectName}

# Find available simulators
xcrun simctl list devices available | grep -E "iPhone" | head -5

# Run build
xcodebuild -project {ProjectName}.xcodeproj \
  -scheme {SchemeName} \
  -destination 'platform=iOS Simulator,name=iPhone 11' \
  build 2>&1 | tail -100
```

### Step 3: Verify Build Result

| Result | Action |
|--------|--------|
| `BUILD SUCCEEDED` | ✅ Phase 8 PASS → Project is READY |
| `BUILD FAILED` with errors | ❌ Fix errors → re-run Step 2 |
| Warnings only | ✅ Accept warnings → READY |

### Anti-Loop Protocol

| Attempt | Action |
|---------|--------|
| Attempt 1: FAIL | Fix errors → Attempt 2 |
| Attempt 2: FAIL | Fix errors → Attempt 3 |
| Attempt 3: FAIL | STOP → Document all errors + report to user |

---

## Post-Init Verification Checklist

After successful build, verify all items:

- [ ] `Package.swift` or `Podfile` includes TTBaseUIKit
- [ ] `AppDelegate.swift` calls `TTBaseUIKitConfig.withDefaultConfig(...).start()`
- [ ] `Localizable.strings` exists with `App.Common.*` keys
- [ ] `Localizable-VI.strings` exists with Vietnamese translations
- [ ] `BaseCoordinator.swift` and `AppCoordinator.swift` created
- [ ] `BaseViewController.swift` and `BaseViewModel.swift` created
- [ ] `BaseTabBarController.swift` created (if Tab Bar selected)
- [ ] All folders match MVVM-C structure
- [ ] `xcodebuild BUILD SUCCEEDED`

---

## Next Steps

Project is now **READY FOR BUILDING**. Proceed with:

| Next Task | Use |
|-----------|-----|
| Build UIKit screen | `/ttb-uikit-screen` |
| Build SwiftUI screen | `/ttb-sui-screen` |
| Build list view | `/ttb-uikit-list` or `/ttb-sui-list` |
| Build form | `/ttb-uikit-form` |
| Add API service | `/ttb-uikit-api` |
| Add navigation flow | `/ttb-uikit-coordinator` |

---

**Version**: 1.0.0 | **Date**: 2026-05-14
