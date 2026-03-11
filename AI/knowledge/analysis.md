# TTBaseUIKit AI-Native Analysis

## Scope
- Root: `TTBaseUIKit/Sources/TTBaseUIKit`
- UIKit and SwiftUI are both first-class. Tokens are centralized in BaseConfig and exposed via global accessors.

## Base UI Classes
- `TTBaseUIView` in `CustomView/BaseUIView/BaseUIView.swift`
- `TTBaseUILabel` in `CustomView/BaseUIView/BaseUILabel.swift`
- `TTBaseUIButton` in `CustomView/BaseUIView/BaseUIButton.swift`
- `TTBaseUIImageView` in `CustomView/BaseUIView/BaseUIImageView.swift`
- `TTBaseUITextField` in `CustomView/BaseUIView/BaseUITextField.swift`
- `TTBaseUITextView` in `CustomView/BaseUIView/BaseUITextView.swift`
- `TTBaseUITableView` in `CustomView/BaseUIView/BaseUITableView.swift`
- `TTBaseUICollectionView` in `CustomView/BaseUIView/BaseUICollectionView.swift`
- `TTBaseUIStackView` in `CustomView/BaseUIView/BaseUIStackView.swift`
- `TTBaseUINavigationView` in `CustomView/BaseUIView/BaseUINavigationView.swift`
- `TTBaseWKWebView` in `CustomView/BaseUIView/BaseWKWebView.swift`

## Base ViewControllers
- `TTBaseUIViewController<BaseView>` in `CustomView/BaseUIView/ViewController/BaseUIViewController.swift`
- `TTBaseUITableViewController` in `CustomView/BaseUIView/ViewController/BaseUITableViewController.swift`
- `TTBaseUICollectionViewController` in `CustomView/BaseUIView/ViewController/BaseUICollectionViewController.swift`
- `TTBaseScrollViewController` in `CustomView/BaseUIView/ViewController/BaseScrollViewController.swift`
- `TTBaseStackScrollViewController` in `CustomView/BaseUIView/ViewController/BaseStackScrollViewController.swift`
- `TTBaseUISearchViewController` in `CustomView/BaseUIView/ViewController/BaseUISearchViewController.swift`
- `TTBaseMessagePopupViewController` in `CustomView/BaseUIView/ViewController/BaseMessagePopupViewController.swift`

## Base SwiftUI Views
- `TTBaseSUIView` in `SwiftUIView/BaseViews/BaseSUIView.swift`
- `TTBaseSUIText` in `SwiftUIView/BaseViews/BaseSUIText.swift`
- `TTBaseSUIButton` in `SwiftUIView/BaseViews/BaseSUIButton.swift`
- `TTBaseSUIImage` in `SwiftUIView/BaseViews/BaseSUIImage.swift`
- `TTBaseSUIAsyncImage` in `SwiftUIView/BaseViews/BaseSUIAsyncImage.swift`
- `TTBaseSUIList` in `SwiftUIView/BaseViews/BaseSUIList.swift`
- `TTBaseSUIScroll` in `SwiftUIView/BaseViews/BaseSUIScroll.swift`
- `TTBaseSUIHStack`, `TTBaseSUIVStack`, `TTBaseSUIZStack` in `SwiftUIView/BaseViews`
- `TTBaseSUILazyVGrid`, `TTBaseSUILazyHGrid`, `TTBaseSUILazyVStack`, `TTBaseSUILazyHStack` in `SwiftUIView/BaseViews`

## Design System Tokens
- `TTBaseUIKitConfig` in `BaseConfig/Configuration.swift`
- `FontConfig` in `BaseConfig/FontConfig.swift`
- `SizeConfig` in `BaseConfig/SizeConfig.swift`
- `ViewConfig` in `BaseConfig/ViewConfig.swift`
- `StyleConfig` in `BaseConfig/StyleConfig.swift`
- `ParamConfig` in `BaseConfig/ParamConfig.swift`
- Token accessors in `Support/Utilities/GlobalFunctions.swift`

## Layout Helpers
- AutoLayout helper chain in `CustomView/Helpers/ContraintHelpers.swift`
- `UIView+Config` helpers in `Extensions/UIView+Config.swift`
- `View+Spacing` and `View+Config+Extension` in `SwiftUIView/Extension+Configs`

## UI Components
- UIKit components under `CustomView/BaseUIView` and `CustomView/Custom`
- SwiftUI components under `SwiftUIView/BaseViews`, `BaseStyle`, `BaseViewModifier`

## Reusable UI Patterns
- Panel and card-like containers: `TTBaseShadowPanelView`, `TTBaseStackPanelView`, `TTBasePanelButtonView`
- Icon + label composites: `TTLabelIconHorizontalView`, `TTIconLabelView`, `TTIconLabelTextFieldView`
- Form rows and validation: `TTLabelTextFieldView`, `TextViewWithPlaceHolderView`
- Notification and toast: `TTBaseNotificationView`, `TTBaseNotificationViewConfig`
- Popup and presentation: `TTBasePopupViewController`, `TTCoverVerticalPresentationController`
- Skeleton loading: `TTBaseSkeletonMarkView`, `UIView.getGradientSkeletonLayer()`
- Liquid Glass: `View+LiquidGlass+Extension.swift` and `UIView.applyLiquidGlassUIKit(...)`

## Dependency Structure
- `TTBaseUIKitConfig` provides shared tokens
- Tokens are accessed through `TTSize`, `TTView`, `TTFont`, `TTStyle`, `TTParam`
- UIKit and SwiftUI components depend on BaseConfig tokens
- UIKit layout uses constraint helpers and `TTViewCodable` lifecycle
- SwiftUI layout uses `TTBaseSUI*` views and `View+Config` modifiers

## Naming Conventions
- Prefix `TTBase*` for UIKit base components
- Prefix `TTBaseSUI*` for SwiftUI base components
- `*Config` for token containers
- `*TableViewCell`, `*CollectionViewCell` for reusable cells

## Lifecycle Patterns
- UIKit views and controllers override `updateBaseUIView()` or `updateBaseUI()`
- UIKit assembly uses `TTViewCodable.setupViewCodable(with:)`
- Controllers use `loadView` to install `BaseView`
- Standard controller phases: `setupUI`, `setupConstraints`, `setupTabbar`, keyboard observers
- SwiftUI relies on `TTBaseSUI*` and shared modifiers
