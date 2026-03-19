---
applyTo: "**/CustomView/**/*.swift,**/BaseUIView/**/*.swift"
---

# UIKit Custom View Rules — TTBaseUIKit

## Base View Class
All custom composed views extend `TTBaseUIView`:
```swift
class MyCustomView: TTBaseUIView {

    let titleLbl = TTBaseUILabel(withType: .HEADER, text: "", align: .left)
    let subLbl   = TTBaseUILabel(withType: .SUB_TITLE, text: "", align: .left)

    // Required: override updateBaseUIView() for setup (called after init)
    override func updateBaseUIView() {
        super.updateBaseUIView()
        self.setupUI()
    }

    private func setupUI() {
        self.addSubviews(views: [titleLbl, subLbl])
        titleLbl.setLeadingAnchor(constant: TTSize.P_CONS_DEF)
                .setTopAnchor(constant: TTSize.P_CONS_DEF)
                .setTrailingAnchor(constant: TTSize.P_CONS_DEF)
                .done()
        subLbl.setLeadingAnchor(constant: TTSize.P_CONS_DEF)
              .setTopAnchorWithAboveView(nextToView: titleLbl, constant: 4)
              .setTrailingAnchor(constant: TTSize.P_CONS_DEF)
              .setBottomAnchor(constant: TTSize.P_CONS_DEF)
              .done()
    }
}
```

## Shadow Card View
Use `BaseShadowPanelView` for card-style containers with drop shadow:
```swift
let card = BaseShadowPanelView()
card.addSubviews(views: [iconView, titleLbl, descLbl, actionBtn])
// Layout children inside card with standard anchors
```

Never apply `layer.shadow*` properties manually. Always use `BaseShadowPanelView`.

## Ready-Made Composite Views
Use these from `CustomView/Custom/` before building from scratch:

```swift
// Label + TextField pair (form row)
let row = LabelTextFieldView(labelText: "Full Name", placeholder: "Enter name")
row.textField.onTextEditChangedHandler = { [weak self] _, v in self?.viewModel.name = v }

// Icon + Label (vertical)
let item = IconLabelView(icon: AwesomePro.Light.user, title: "Profile")

// Key=Value row (settings row)
let infoRow = LabelLeftRightView(leftText: "Phone", rightText: model.phone)

// Two-button panel
let twoBtn = TwoButtomView(leftText: "CANCEL", rightText: "CONFIRM")
twoBtn.leftButton.onTouchHandler  = { [weak self] _ in self?.onCancel() }
twoBtn.rightButton.onTouchHandler = { [weak self] _ in self?.onConfirm() }
```

## Corner Radius Helpers
```swift
view.setConerRadius(with: 12)            // explicit radius
view.setConerDef()                        // uses TTSize.CORNER_RADIUS (4pt)
view.roundCorners(corners: [.topLeft, .topRight], radius: 16)
view.roundCornersNew(corners: [.bottomLeft, .bottomRight], radius: 16)
```

## Border Helpers
```swift
view.setBorder(with: 1, color: TTView.lineDefColor, coner: 8)
view.addBorder(withRectEdge: .bottom, borderColor: TTView.lineDefColor, borderHeight: 1.5)
view.setDashedLine(strokeColor: TTView.lineDefColor, lineWidth: 1)
```

## Touch Handler
```swift
let view = TTBaseUIView()
view.setTouchHandler()
view.onTouchHandler = { [weak self] _ in self?.onViewTapped() }

// Swipe
view.setSwipeHandler(with: .left)
view.onTouchHandler = { [weak self] _ in self?.onSwipeLeft() }
```

## View Skeleton Shimmer (data loading states)
```swift
// On individual views (not full VC skeleton)
customView.onStartSkeletonCustomViewAnimation(withDef: 80, width: TTSize.W)
// ... data loaded
customView.onStopSkeletonCustomViewAnimation()
```

## FontAwesome Icons
```swift
let icon = TTBaseUIImageFontView(
    withFontIconLightSize: AwesomePro.Light.heartbeat,  // pick from AwesomePro.Light.*
    sizeIcon: CGSize(width: 24, height: 24),
    colorIcon: TTView.iconColor
)
icon.setActiveOnTouchHandle()
icon.onTouchHandler = { [weak self] _ in ... }
```

## Validation Error Visual
```swift
// Shake + red border on invalid field
field.onDetectPositionForValidation()
```
