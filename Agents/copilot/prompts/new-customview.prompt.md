---
description: "Scaffold a reusable TTBaseUIKit custom view component (simple or shadow card)"
---

# Create New Custom View

Scaffold a reusable custom view component following TTBaseUIKit patterns found in this project.

## Pattern Selection

Ask user which pattern to use, or auto-detect from requirements:

### Pattern A — Simple TTBaseUIView (most common)
For lightweight composites (icon+label, key-value row, button groups).
Uses `updateBaseUIView()` + `TTViewCodable` — **NO custom init needed**.

Reference: `ContactView`, `HotLineView`, `BadgeView`, `LineView`

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
import TTBaseUIKit

class {Name}View: TTBaseUIView {

    // MARK: - UI Components (always let at class level)
    let titleLabel = TTBaseUILabel(withType: .TITLE, text: "", align: .left)
    let subtitleLabel = TTBaseUILabel(withType: .SUB_TITLE, text: "", align: .left)

    // MARK: - Callbacks (optional, for touch events)
    var didTouchHandle: (() -> ())?

    // MARK: - Setup (called automatically by TTBaseUIKit)
    override func updateBaseUIView() {
        super.updateBaseUIView()
        self.setupViewCodable(with: [])
    }
}

// MARK: - TTViewCodable
extension {Name}View: TTViewCodable {

    func setupStyles() {
        self.setBgColor(.clear)
    }

    func setupCustomView() {
        self.addSubviews(views: [self.titleLabel, self.subtitleLabel])
    }

    func setupConstraints() {
        titleLabel.setVerticalContentHuggingPriority()
            .setLeadingAnchor(constant: XSize.P_CONS_DEF)
            .setTopAnchor(constant: XSize.P_CONS_DEF)
            .setTrailingAnchor(constant: XSize.P_CONS_DEF)

        subtitleLabel.setTopAnchorWithAboveView(nextToView: titleLabel, constant: XSize.P_CONS_DEF / 2)
            .setLeadingAnchor(constant: XSize.P_CONS_DEF)
            .setTrailingAnchor(constant: XSize.P_CONS_DEF)
            .setBottomAnchor(constant: XSize.P_CONS_DEF)
    }

    func bindComponents() {
        // Wire up touch handlers if needed
        // self.setTouchHandler().onTouchHandler = { [weak self] _ in
        //     self?.didTouchHandle?()
        // }
    }
}

// MARK: - Public API
extension {Name}View {
    func setData(title: String, subtitle: String) {
        titleLabel.setText(text: title)
        subtitleLabel.setText(text: subtitle)
    }
}
```

### Pattern B — Shadow Card (BaseShadowView / TTBaseShadowView)
For card-style components with built-in shadow panel.
Uses `updateBaseUIView()` + `TTViewCodable` — **NO custom init needed**.

Reference: `PaymentRowView`, `BaseShadowView`

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
import TTBaseUIKit

class {Name}CardView: BaseShadowView {

    // MARK: - UI Components
    let titleLabel = TTBaseUILabel(withType: .TITLE, text: "", align: .left)
    let rightIconImg = TTBaseUIImageFontView(
        withFontIconRegularSize: AwesomePro.Regular.chevronRight,
        colorIcon: UIColor.grb(red: 18, green: 18, blue: 18, alpha: 0.3),
        contendMode: .scaleToFill
    )

    // MARK: - Setup
    override func updateBaseUIView() {
        super.updateBaseUIView()
        self.setupViewCodable(with: [])
    }
}

// MARK: - TTViewCodable
extension {Name}CardView: TTViewCodable {

    func setupStyles() {
        self.newPanelView.setConerRadius(with: XSize.CORNER_RADIUS)
        self.setBgColor(.white)
    }

    func setupCustomView() {
        self.newPanelView.addSubview(self.titleLabel)
        self.newPanelView.addSubview(self.rightIconImg)
    }

    func setupConstraints() {
        titleLabel.setVerticalContentHuggingPriority()
            .setLeadingAnchor(constant: XSize.getPadding())
            .setTrailingWithNextToView(view: self.rightIconImg, constant: XSize.P_CONS_DEF)
            .setcenterYAnchor(constant: 0)

        rightIconImg.setWidthAnchor(constant: 16.0).setHeightAnchor(constant: 16.0)
            .setTrailingAnchor(constant: XSize.getPadding())
            .setcenterYAnchor(constant: 0)

        self.newPanelView.setHeightAnchor(constant: 60.0)
    }
}

// MARK: - Public API
extension {Name}CardView {
    func setData(icon: String, title: String) {
        self.titleLabel.setText(text: title)
    }
}
```

## Common Composite Patterns (reference existing views)

| Existing View | Components | Use When |
|--------------|-----------|---------|
| `ContactView` | two icon images | Contact actions (call/message) |
| `IconLabelView` | icon + label horizontal | Info row with icon |
| `LabelLeftRightView` | left label + right label | Key-value pair |
| `HotLineView` | icon + bold label | Clickable hotline row |
| `BadgeView` | circle badge with number | Notification badge |
| `LineView` | single line divider | Section separator |
| `ConfirmButtomView` | single full-width button | Bottom sticky action |
| `PaymentRowView` | icon + label + chevron | Navigable row card |

## Component Quick Reference
```swift
// Labels
TTBaseUILabel(withType: .HEADER, text: "", align: .left)    // 16pt bold
TTBaseUILabel(withType: .TITLE, text: "", align: .left)     // 14pt regular
TTBaseUILabel(withType: .SUB_TITLE, text: "", align: .left) // 12pt light

// Buttons
TTBaseUIButton(textString: "", type: .DEFAULT, isSetHeight: true)  // blue bg
TTBaseUIButton(textString: "", type: .WARRING, isSetSize: false)   // red bg

// Images
TTBaseUIImageView(imageName: "", contentMode: .scaleAspectFit)
TTBaseUIImageFontView(withFontIconLightSize: .check, sizeIcon: CGSize(width: 20, height: 20), colorIcon: XView.iconColor)

// Containers
TTBaseUIView()
TTBaseUIStackView(axis: .horizontal, spacing: XSize.P_CONS_DEF, alignment: .fill, distributionValue: .fillEqually)
BaseShadowPanelView()
```

## Rules
- Extend `TTBaseUIView` (or `BaseShadowView` for cards)
- **NO custom init** — use `override func updateBaseUIView()` + `setupViewCodable(with:)`
- UI components as `let` properties at class level
- Data binding via `setData(...)` / `configure(...)` public methods (separate extension)
- Callbacks as `var didTouchHandle: (() -> ())?` closures
- Use `XSize.P_CONS_DEF` / `XSize.getPadding()`, NEVER hardcode padding
- Use `XView.*` for colors, `XFont.*` for font sizes
- `setBgColor(.clear)` for transparent composites
- `.setVerticalContentHuggingPriority()` on labels that should hug content
- Place file in `CustomView/` folder

## Auto-Add to Xcode Project (MANDATORY)
After creating any new Swift file:
```bash
ruby .agent/skills/ttbase-swiftui/scripts/add_to_xcode_project.rb "{file_path}"
```

## Steps
1. Ask for view name, purpose, and components needed
2. Recommend pattern A or B based on complexity
3. Generate complete custom view file
4. Confirm file location: `CustomView/{Name}View.swift`
5. Auto-add to Xcode project

## Plan Output (MANDATORY)

After completing any work, generate a plan file for future context:

1. Create `plans/YYYY-MM-DD-{feature-name}/plan.md`
2. Include: date, goal, files table (NEW/MODIFY/DELETE), patterns & tokens used, context for future upgrades
3. Auto-add plan file to Xcode:
```bash
ruby .agent/skills/ttbase-swiftui/scripts/add_to_xcode_project.rb "{plan_file_path}"
```

> See `instructions/plan-generation.instructions.md` for full templates.
