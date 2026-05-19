---
name: "ttb-ref-ttbaseuikit"
description: "Quick reference for TTBaseUIKit UIKit components, TTViewCodable protocol, constraint helpers, and BaseViewModel."
version: "1.0.1"
---

# ttb-ref-ttbaseuikit — TTBaseUIKit API Reference

Quick reference for TTBaseUIKit UIKit components and helpers.

## Base Classes

```swift
// ViewController
open class TTBaseUIViewController<BaseView: TTBaseUIView>: UIViewController {
    var contentView: BaseView { get }  // Generic base view
    var navBar: TTBaseUINavigationView { get }
    var statusBar: TTBaseUIView { get }
    var navType: NAV_STYLE { get }  // .ONLY_STATUS, .STATUS_NAV, .NO_VIEW
}

// TableView
class TTBaseUITableView: UITableView
class TTBaseUITableViewCell: UITableViewCell

// CollectionView
class TTBaseUICollectionView: UICollectionView
class TTBaseUICollectionViewCell: UICollectionViewCell

// View
class TTBaseUIView: UIView
class TTBaseShadowPanelView: TTBaseUIView  // panel container with shadow
```

## TTViewCodable Protocol

```swift
public protocol TTViewCodable {
    func setupViewCodable(with views: [UIView]) // Orchestrator — calls all below in order
    func addToHierarchy(_ views: [UIView])       // Add subviews to hierarchy
    func setupCustomView()                       // Add more custom views
    func setupConstraints()                      // Set layout (end every chain with .done())
    func setupStyles()                          // Apply colors/fonts from tokens
    func setupData()                           // Initialize text/content
    func setupBaseAPI()                        // Call base API
    func bindComponents()                      // Wire handlers (onTouchHandler, etc.)
    func bindViewModel()                       // Connect to ViewModel callbacks
    func setupBaseDelegate()                   // Set delegates
    func setupDataByChangeLocalizable()        // Language change handler
    func setupAcessibilityIdentifiers()          // Automation test IDs
}
// setupViewCodable() is the orchestrator that calls all methods in the correct order.
```

## Constraint Helpers (Real)

```swift
// Basic anchors
view.setLeadingAnchor(constant: 8)
view.setTopAnchor(constant: 8)
view.setTrailingAnchor(constant: 8)
view.setBottomAnchor(constant: 8)
// Always end chain with .done()

// Full constraints
view.setFullContraints(constant: 0)
view.setFullContraints(view: parentView, constant: 0)
view.setFullContraints(view: parentView, lead:, trail:, top:, bottom:)

// Width/height
view.setWidthAnchor(constant: 100)
view.setHeightAnchor(constant: 50)

// Center
view.setcenterYAnchor(constant: 0)
view.setCenterXAnchor(constant: 0)
view.setFullCenterAnchor(view: parent, constant: 0)

// Relative anchors
view.setTopAnchorWithAboveView(nextToView: aboveView, constant: 8)
view.setBottomAnchorWithBelowView(view: belowView, constant: 8)
view.setTrailingWithNextToView(view: siblingView, constant: 8)
view.setLeadingWithNextToView(view: siblingView, constant: 8)

// Size
view.setSquareSize(with: 50)
```

## UI Components

```swift
// Label
TTBaseUILabel(withType: .HEADER, text: "", align: .left)
TTBaseUILabel(withType: .TITLE, text: "", align: .left)
TTBaseUILabel(withType: .SUB_TITLE, text: "", align: .left)
// TYPE enum: .HEADER_SUPER, .HEADER, .TITLE, .SUB_TITLE, .SUB_SUB_TILE, .NONE

// Button
TTBaseUIButton(textString: "", type: .DEFAULT, isSetHeight: true)
TTBaseUIButton(textString: "", type: .BORDER, isSetHeight: true)
TTBaseUIButton(textString: "", type: .WARRING, isSetHeight: true)
// TYPE enum: .NO_BG_COLOR, .DEFAULT, .ICON, .DISABLE, .BORDER, .WARRING, .DEFAULT_COLOR(color:textColor:)

// TextField
TTBaseUITextField(withPlaceholder: "", type: .ONLY_BOTTOM, isSetHeight: true)
TTBaseUITextField(withPlaceholder: "", type: .BORDER, isSetHeight: true)

// Image
TTBaseUIImageView()
TTBaseUIImageFontView(withFontIconLightSize: .user, ...)
TTBaseUIImageFontView(withFontIconRegularSize: .chevronRight, ...)

// Stack
TTBaseUIStackView()
TTBaseUIStackView(axis: .vertical, spacing: 8)

// Activity
// (Use UIActivityIndicatorView directly or via loading helpers)

// Cell
TTBaseUITableViewCell
TTBaseUICollectionViewCell
```

## ViewController Helpers

```swift
// Navigation
self.push(vc)                          // Push screen
self.pop()                             // Pop screen
self.close()                           // Pop or dismiss
self.presentDef(vc: vc, type: .overFullScreen)  // Present modal
self.onDismiss()                       // Dismiss modal
self.setTitleNav("Title")             // Set nav title
self.setTitleNav(XTextU("key"))       // Set nav title with localization

// Loading
self.showLoadingView(type: .VIEW_CENTER)
self.showLoadingView(type: .VIEW_TOP)
self.showLoadingView(type: .NAV_BUTTOM)
self.showLoadingView(type: .TAB_TOP)
self.removeLoading()

// Skeleton
self.onStartSkeletonCustomViewAnimation()
self.onStopSkeletonCustomViewAnimation()

// Alert
self.showAlert(message)
self.onShowNoticeView(title:body:style:)

// Keyboard
self.dismissKeyboard()
self.frameKeyBoard  // CGRect of keyboard

// Lifecycle
self.contentView   // Main content container
self.navBar       // Navigation bar reference
self.navType      // NAV_STYLE enum
```

## Button Helpers

```swift
btn.setText(text: "")
btn.setTextColor(color: .white)
btn.setBgColor(color: TTView.buttonBgDef)
btn.onTouchHandler = { [weak self] _ in }
btn.onAddSkeletonMark()
btn.onRemoveSkeletonMark()
btn.onStartLoadingAnimation()
btn.onStopLoadingAnimation()
```

## Label Helpers

```swift
lbl.setText(text: "...")
lbl.setTextColor(color: TTView.textHeaderColor)
lbl.setVerticalContentHuggingPriority()
lbl.setMutilLine(numberOfLine: 0, ...)
lbl.setBold()
lbl.setItalic()
lbl.setAlign(align: .left)
lbl.setBgColor(.clear)
lbl.setFontSize(size: 14)
lbl.onAddSkeletonMark()
lbl.onRemoveSkeletonMark()
```

## TextField Helpers

```swift
field.setPlaceholder(XText("key"))
field.setTextFieldStyle(hasUnderline: true)
field.setKeyboardStyleByEmail()
field.setKeyboardStyleByNumber()
field.setKeyboardStyleByPhone()
field.onTextEditChangedHandler = { [weak self] _, text in }
field.onDetectPositionForValidation()
```

## Notification Helpers

```swift
let config = TTBaseNotificationViewConfig(with: window)
config.setText(with: "Title", subTitle: "Body")
config.notifiType = .SUCCESS  // .SUCCESS, .WARNING, .ERROR
config.onShow()
config.onHidden()

// Via extension
self.onShowNoticeView(title: "Title", body: "Body", style: .SUCCESS)
```

## Coordinator

```swift
class MyCoordinator: TTCoordinator {
    fileprivate var currVC: UIViewController?
    func start()
}
```

## ViewModel

```swift
class BaseViewModel {
    var onShowError: ((String) -> Void)?
    var onShowLoading: (() -> Void)?
    var onHideLoading: (() -> Void)?
    var onSuccess: (() -> Void)?
    var onUpdateUI: (() -> Void)?

    func beginFetching() -> Bool
    func endFetching()
}
```

## IMPORTANT: Non-Existent APIs

The following DO NOT exist in TTBaseUIKit — do NOT use them:

```swift
// ❌ Fake types that do NOT exist:
TTBaseUILabel(withType: .HEADER_H, ...)   // → .HEADER
TTBaseUILabel(withType: .CONTENT_H, ...)  // → .TITLE or custom
BaseUINavigationView.TYPE.DEFAULT         // → TTBaseUINavigationView has no TYPE enum
BaseShadowView                            // → TTBaseShadowPanelView or TTBaseUIView
TTBaseUIActivityIndicator                  // → Use UIActivityIndicatorView directly
TTBaseUIRefreshControl                    // → Use UIRefreshControl directly

// ❌ Fake methods that do NOT exist:
view.setBottomSafeAnchor(...)             // → view.setBottomAnchor(...)
view.setFullContraints(left:top:right:bottom:...)  // → use individual anchors
view.padding(.all, 8)                    // → Use .padding modifier in SwiftUI
lbl.setTextString(...)                   // → lbl.setText(...)
lbl.setNumberOfLines(...)               // → lbl.setMutilLine(...)
btn.setTextString(...)                  // → btn.setText(...)
btn.setTextColor(color: .white)         // → btn.setTextColor(color: .white) ✓ (exists)
field.setKeyboardStyleByEmail()         // verify exact method name in source
XPrint("...")                          // → TTBaseFunc.shared.printLog(...)

// ❌ Wrong property names:
navBaseStype                             // → navType
```

## Real TTViewCodable Order (called by setupViewCodable)

```swift
// Order in TTViewCodable default implementation:
1. addToHierarchy(views)          // Add subviews to hierarchy
2. setupCustomView()             // More custom views
3. setupConstraints()             // Layout (end each chain with .done())
4. setupStyles()                  // Colors/fonts from tokens
5. bindComponents()              // Handlers (onTouchHandler, etc.)
6. bindViewModel()               // VM callbacks
7. setupData()                   // Content (text, images)
8. setupDataByChangeLocalizable() // Language change
9. setupBaseDelegate()           // Delegates
10. setupBaseAPI()               // Base API
11. setupAcessibilityIdentifiers() // Test IDs
```

## TTBaseUIKit Extension Methods Reference

### UIView Extension (ContraintHelpers.swift)
```swift
// These methods are on UIView — available on ALL TTBaseUIKit views:
view.setFullContraints(view: parent, constant: 8)     // all sides
view.setFullContraints(view: parent, lead:, trail:, top:, bottom:)  // custom
view.setLeadingAnchor(constant: 8)
view.setTrailingAnchor(constant: 8)
view.setTopAnchor(constant: 8)
view.setBottomAnchor(constant: 8)
view.setTopAnchorWithAboveView(nextToView: aboveView, constant: 8)
view.setBottomAnchorWithBelowView(view: belowView, constant: 8)
view.setTrailingWithNextToView(view: sibling, constant: 8)
view.setLeadingWithNextToView(view: sibling, constant: 8)
view.setWidthAnchor(constant: 100)
view.setHeightAnchor(constant: 50)
view.setcenterYAnchor(constant: 0)
view.setCenterXAnchor(constant: 0)
view.setFullCenterAnchor(view: parent, constant: 0)
// Always end chain with .done()
```
