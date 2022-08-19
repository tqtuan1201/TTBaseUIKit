# TTBaseUIKit

A description of this package.
# Abstract

When I work with many projects. I always ask myself how to optimize the application, reusable code and how to develop the fastest and most efficient applications. So after two years of working with Swift language. I created the framework to build UI programmatically. With `TTBaseUIKit`, you can build apps in the fastest and most efficient way.  A few points to note when you apply this framework:

- How to set up the framework
- Basic config settings
- Usage example

# Introduction

I have been building framework for 5 years and for now, I still update new functions. This framework includes a lot of base UI components, e.g. `TTBaseUILabel`, `TTBaseUIButton`, `TTBaseUIView`, `TTBaseUIViewController`, `TTBaseUITableViewController`,... with many useful functions. With those base views, it gives you most of the functions for you to use. Here is the structure of the framework.

{{< figure src="/images/image-20220712172821292.png" alt="image" caption="TTBaseUIKit Framework" class="big" >}}

Some base UI components, you can see it on the left side:

{{< figure src="/images/image-20220713104243606.png" alt="image" caption="Base UI components" class="big" >}}

# How to set up the framework

The current release of `TTBaseUIKit` supports all versions of iOS and OS X since the introduction of Auto Layout on each platform, in Swift language with a single codebase.

Language Support: **Swift**, iOS minimum Deployment Target: **iOS 10.0**

## Using CocoaPods

Add the pod `TTBaseUIKit` to your [Podfile](http://guides.cocoapods.org/using/the-podfile.html).

```typescript
pod 'TTBaseUIKit'
```

With `use_frameworks!` in your Podfile, `Swift`: import TTBaseUIKit

## Basic config settings

When you use this framework. You have the ability to control `Color`, `FontSize`, `UI size`. It helps you a lot when you apply **themes**, build apps on **different platforms** and they are easy to change. Config setting in `AppDelegate`

```swift
let view:ViewConfig = ViewConfig()
view.viewBgNavColor = UIColor.blue
view.viewBgColor = UIColor.white
view.buttonBgDef = UIColor.blue
view.buttonBgWar = UIColor.red
        
let size:SizeConfig = SizeConfig()
size.H_SEG = 50.0
size.H_BUTTON = 44.0

let font:FontConfig = FontConfig()
font.HEADER_H = 16
font.TITLE_H = 14
font.SUB_TITLE_H = 12
font.SUB_SUB_TITLE_H = 10

TTBaseUIKitConfig.withDefaultConfig(withFontConfig: font, frameSize: size, view: view)?.start(withViewLog: true)
        
self.window = UIWindow(frame: UIScreen.main.bounds)
self.window!.rootViewController = UINavigationController.init(rootViewController: YourViewController())
self.window!.makeKeyAndVisible()

```

- With `ViewConfig`, you can customize the most of colors for `Button`, `Label`, `Background colors`, ect. You can see all the config here: [ViewConfig](https://github.com/tqtuan1201/TTBaseUIKit/blob/master/TTBaseUIKit/TTBaseUIKit/BaseConfig/ViewConfig.swift)
- With `SizeConfig`, you can customize the most of size for `Button`, `Label`, `Navigation`, `Conner radius`, `Icon`, `Textfield`, ect. You can see all the config here: [SizeConfig](https://github.com/tqtuan1201/TTBaseUIKit/blob/master/TTBaseUIKit/TTBaseUIKit/BaseConfig/SizeConfig.swift)
- With `SizeConfig`, you can customize the most of font size for `Title`, `SubTitle`, `Header`, ect. You can see all the config here: [FontConfig](https://github.com/tqtuan1201/TTBaseUIKit/blob/master/TTBaseUIKit/TTBaseUIKit/BaseConfig/FontConfig.swift)

Apply config by:

{{< notice info >}}

TTBaseUIKitConfig.withDefaultConfig(withFontConfig: font, frameSize: size, view: view)?.start(withViewLog: true)

{{< /notice >}}

# Usage

`TTBaseUIKit` dramatically simplifies writing to build UI programmatically. Let's take a quick look at some examples, using `TTBaseUIKit` from Swift.

{{< figure src="https://github.com/tqtuan1201/TTBaseUIKit/raw/master/Images/1.gif" alt="image" caption="TTBaseUIKit Framework" class="medium" >}}

## Interface Customization

### Show Message

```swift
let noti:TTBaseNotificationViewConfig = TTBaseNotificationViewConfig(with: window)
noti.setText(with: "WELCOME ^^", subTitle: "Just demo little element ui with write by  programmatically swift")
noti.type = .NOTIFICATION_VIEW
noti.touchType = .SWIPE
noti.notifiType = .SUCCESS
noti.onShow()
```

{{< figure src="/images/image-20220713113301616.png" alt="image" caption="Show message" class="small" >}}

### Show Popup

```swift
let popupVC = TTPopupViewController(title: "SOMETHING LIKE THIS", subTitle: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has b", isAllowTouchPanel: true)
yourVC.present(popupVC, animated: true)
```

### Show empty for table view

```swift
yourVC.tableView.setStaticBgNoData(title: "NO DATA", des: "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making ") {
  print("Touch handle!!!!")
            }
```

## ViewCodable

 This is a `protocol` use to easily organize UI handling code. You can see all configs here: [ViewCodable](https://github.com/tqtuan1201/TTBaseUIKit/blob/master/TTBaseUIKit/TTBaseUIKit/CustomView/ViewCodable/ViewCodable.swift)

- ```swift
  func setupViewCodable(with views : [UIView])
  ```

  This function calls all other functions in the correct order. You can use it in an UIViewController viewDidLoad method or in a view initializer, for example.

- ```swift
  func setupStyles()
  ```

  This function should be used to apply styles to your customs views.

- ```swift
  func setupData()
  ```

  This function should be used to set data

- ```swift
  func setupConstraints()
  ```

  This function should be used to add constraints to your customs views

- ```swift
  func setupBaseDelegate()
  ```

  This function should be used to set delegate for views

## Base UIViews

### Custom View

```swift
import TTBaseUIKit

class YourCustomView : TTBaseUIView {
    override func updateBaseUIView() {
        super.updateBaseUIView()
    }
}

extension YourCustomView :TTViewCodable {
    
    func setupStyles() {
    }
    
    func setupCustomView() {
    }
    
    func setupConstraints() {
    }
    
}

```

### BaseUIViewController

```swift
import  TTBaseUIKit

class BaseUIViewController: TTBaseUIViewController<DarkBaseUIView> {
    
    var lgNavType:BaseUINavigationView.TYPE { get { return .DEFAULT}}
    var backType:BaseUINavigationView.NAV_BACK = .BACK_POP
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.updateForNav()
    }
    
    public override init() {
        super.init()
        self.navBar = BaseUINavigationView(withType: self.lgNavType)
        self.setDelegate()
    }
    
    public convenience init(backType:BaseUINavigationView.NAV_BACK) {
        self.init()
        self.backType = backType
    }
    
    public convenience init(withTitleNav title:String, backType:BaseUINavigationView.NAV_BACK = .BACK_POP) {
        self.init()
        self.backType = backType
        self.setTitleNav(title)
    }
    
    public convenience init(withNav nav:BaseUINavigationView, backType:BaseUINavigationView.NAV_BACK = .BACK_POP) {
        self.init()
        self.backType = backType
        self.navBar = nav
        self.setDelegate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: For private base funcs
extension BaseUIViewController {
    
    fileprivate func setDelegate() {
        if let lgNav = self.navBar as? BaseUINavigationView { lgNav.delegate = self }
    }
    
    fileprivate func updateForNav() {
        if let lgNav = self.navBar as? BaseUINavigationView {
            lgNav.setTitle(title: "TTBASEUIVIEW_KIT")
        }
    }
}

// MARK: For public base funcs
//--NAV
extension BaseUIViewController {
    
    func setTitleNav(_ text:String) {
        self.navBar.setTitle(title: text)
    }
    
    func setShowNav() {
        self.statusBar.isHidden = false
        self.navBar.isHidden = false
    }
    
    func setHiddenNav() {
        self.statusBar.isHidden = true
        self.navBar.isHidden = true
    }
    
}

extension BaseUIViewController :BaseUINavigationViewDelegate {
    func navDidTouchUpBackButton(withNavView nav: BaseUINavigationView) {
        if self.backType == .BACK_POP {
            self.navigationController?.popViewController(animated: true)
        } else if self.backType == .BACK_TO_ROOT {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    func navDidTouchUpRightButton(withNavView nav: BaseUINavigationView) {

    }
}

```

### BaseUITableViewController

```swift
import TTBaseUIKit

class BaseUITableViewController: TTBaseUITableViewController {
    
    override var navType: TTBaseUIViewController<TTBaseUIView>.NAV_STYLE { get { return .STATUS_NAV}}
    
    var lgNavType:BaseUINavigationView.TYPE { get { return .DEFAULT}}
    var backType:BaseUINavigationView.NAV_BACK = .BACK_POP
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async { [weak self] in guard let strongSelf = self else { return }
            guard let headerView = strongSelf.tableView.tableHeaderView else { return }
            headerView.layoutIfNeeded()
            let header = strongSelf.tableView.tableHeaderView
            strongSelf.tableView.tableHeaderView = header
        }
    }
    
    
    override func updateBaseUI() {
        super.updateBaseUI()
        self.navBar = BaseUINavigationView(withType: self.lgNavType)
        self.setDelegate()
    }
    
}


//For Base private funcs
extension BaseUITableViewController : BaseUINavigationViewDelegate{
    
    fileprivate func setDelegate() {
        if let lgNav = self.navBar as? BaseUINavigationView { lgNav.delegate = self }
    }
    
    func navDidTouchUpBackButton(withNavView nav: BaseUINavigationView) {
        self.navigationController?.popViewController(animated: true)
    }
}

```



## Auto Layout

`TTBaseUIKit` to make easy Auto Layout. This framework provides some functions to setup and update constraints.

- `setLeadingAnchor` : Set/Update value for **current view** or **super view**
- `setTrailingAnchor(_ view:UIView? = nil, isUpdate:Bool = false, constant:CGFloat, isApplySafeArea:Bool = false, priority:UILayoutPriority? = nil)`
- `setTopAnchor(_ view:UIView? = nil, isUpdate:Bool = false, constant:CGFloat, priority:UILayoutPriority? = nil)`
- `setBottomAnchor(_ view:UIView? = nil, isUpdate:Bool = false, constant:CGFloat,isMarginsGuide:Bool = false, priority:UILayoutPriority? = nil) `
- `setCenterXAnchor(_ view:UIView? = nil, isUpdate:Bool = false, constant:CGFloat)`
- `setcenterYAnchor(_ view:UIView? = nil, isUpdate:Bool = false, constant:CGFloat)`

## Useful functions

`TTBaseUIKit` provides common handling functions for `String`, `Date`, `Json`, `Device`, `Language`, `VietNamLunar `, `Validation`, `NetworkSpeedTest`

## Example Apps

For more examples and usage, please refer to example project  [`TTBaseUIKitExample`](https://github.com/tqtuan1201/TTBaseUIKit/tree/master/TTBaseUIKitExample)

# Installed Applications

During my work, I have updated and used this framework in many projects. All my project using `UI programmatically` instead of using `Storyboard`. Here are some screenshoots of the apps:

- 12Bay iOS App

  {{< figure src="/images/image-20220714103844009.png" alt="image" caption="12Bay iOS App" class="medium" >}}

- 12Bay MacOS app

  {{< figure src="/images/image-20220714104020426.png" alt="image" caption="12Bay MacOS app" class="medium" >}}

- Aihealth iOS app

{{< figure src="/images/image-20220714104542214.png" alt="image" caption="Aihealth iOS app" class="medium" >}}

You can see all my projects here: [Link](https://tqtuan1201.github.io/portfolio/)

# Advantages

- Reusable codes
- Speed up your project
- Easy to use

# Disadvantages

- Must **build app to see UI**, `SwiftUI ` solved that problem I was thinking about.

# Conclusion

`TTBaseUIKit` framework is a `UI programmatic` approach. You will create all UI elements and their constraints by coding them.

{{< notice info >}}
With `TTBaseUIKit`, you can build apps in the fastest and most efficient way.
{{< /notice >}}

In the future, I will update the framework to support `SwiftUI`. Thanks for reading this post. If you enjoyed it, please share it with others.
