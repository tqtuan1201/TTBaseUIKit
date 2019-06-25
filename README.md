# TTBaseUIKit

Build your project with programmatically UI

[![Version](https://img.shields.io/cocoapods/v/SwiftMessages.svg?style=flat)](http://cocoadocs.org/docsets/SwiftMessages)
[![License](https://img.shields.io/cocoapods/l/SwiftMessages.svg?style=flat)](http://cocoadocs.org/docsets/SwiftMessages)
[![Platform](https://img.shields.io/cocoapods/p/SwiftMessages.svg?style=flat)](http://cocoadocs.org/docsets/SwiftMessages)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

<p align="center">
  <img src="./Images/TTBaseUIKit.png" />
</p>

### CocoaPods

Add the following line to your Podfile:

````ruby
pod 'TTBaseUIKit'
````

### Carthage

Add the following line to your Cartfile:

````ruby
github "tqtuan1201/TTBaseUIKit"
````

### Manual

1. Put SwiftMessages repo somewhere in your project directory.
1. In Xcode, add `TTBaseUIKit.xcodeproj` to your project.
1. On your app's target, add the SwiftMessages framework:
   1. as an embedded binary on the General tab.
   1. as a target dependency on the Build Phases tab.
## Usage example

A few motivating and useful examples of how your product can be used. Spice this up with code blocks and potentially more screenshots.

<p align="center">
  <img src="./Images/TTBaseUIKit.png" />
  <img src="./Images/TTBaseUIKit.png" />
  <img src="./Images/TTBaseUIKit.png" />
</p>

### Basics

Config setting in AppDelegate
````swift
        let view:ViewConfig = ViewConfig()
        view.viewBgNavColor = UIColor.getColorFromHex.init(netHex: 0xC41F53)
        
        let size:SizeConfig = SizeConfig()
        let font:FontConfig = FontConfig()
        
        TTBaseUIKitConfig.withDefaultConfig(withFontConfig: font, frameSize: size, view: view)?.start(withViewLog: true)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.rootViewController = UINavigationController.init(rootViewController: YourViewController())
        self.window!.makeKeyAndVisible()

````

Custom show message

````swift
        let noti:TTBaseNotificationViewConfig = TTBaseNotificationViewConfig(with: window)
        noti.setText(with: "WELCOME ^^", subTitle: "Just demo little element ui with write by  programmatically swift")
        noti.type = .NOTIFICATION_VIEW
        noti.touchType = .SWIPE
        noti.notifiType = .SUCCESS
        noti.onShow()
````

_For more examples and usage, please refer to the [Wiki][wiki]._

## Meta

Truong Quang Tuan – [@website](https://12bay.vn) – truongquangtuanit@gmail.com

Distributed under the XYZ license. See ``LICENSE`` for more information.

[https://github.com/tqtuan1201/TTBaseUIKit](https://github.com/tqtuan1201/)


## About my project
We build high quality apps! [Get in touch](http://www.12bay.vn) if you need help with a project.

## License

TTBaseUIKit is distributed under the MIT license. [See LICENSE](./LICENSE.md) for details.
