---
applyTo: "**/SUI*.swift,**/BaseSUI*.swift,**/*SwiftUI*.swift"
---

# SwiftUI View Rules — TTBaseUIKit (TTBaseSUI*)

> ⚠️ **Deployment Target: iOS 14+** — All SwiftUI code must use iOS 14-compatible APIs only.
> - `foregroundColor()` not `foregroundStyle()`, `PreviewProvider` not `#Preview`, `.onAppear { Task {} }` not `.task {}`
> - `NavigationView` not `NavigationStack`, `clipShape(RoundedRectangle())` not `clipShape(.rect())`

## Core Rule — Always Use TTBaseSUI Components
Never use native SwiftUI primitives when a TTBaseSUI equivalent exists.

| ❌ Native SwiftUI | ✅ TTBaseSUI |
|---|---|
| `Text("...")` | `TTBaseSUIText(withType: .TITLE, text: "...", align: .left)` |
| `Text("...").bold()` | `TTBaseSUIText(withBold: .HEADER, text: "...", align: .center, color: .white)` |
| `Button("...") { }` | `TTBaseSUIButton(type: .DEFAULT, title: "...")` |
| `Image("...")` | `TTBaseSUIImage(withname: "...", conner: XSize.CORNER_RADIUS)` |
| `VStack { }` | `TTBaseSUIVStack(alignment: .center, spacing: XSize.P_CONS_DEF) { }` |
| `HStack { }` | `TTBaseSUIHStack(alignment: .center, spacing: XSize.P_CONS_DEF) { }` |
| `ZStack { }` | `TTBaseSUIZStack(alignment: .center, bg: .clear) { }` |
| `Spacer()` | `TTBaseSUISpacer()` |
| `ScrollView { }` | `TTBaseSUIScroll { }` |
| `LazyVStack { }` | `TTBaseSUILazyVStack(alignment: .center, spacing: 10, bg: .clear) { }` |
| `Divider()` | `BaseHorizontalDivider()` or `TTBaseSUIVerticalDividerView(noConner: .LINE)` |

## Text Types
```swift
TTBaseSUIText(withType: .HEADER_SUPER, text: "...", align: .center)  // largest
TTBaseSUIText(withType: .HEADER, text: "...", align: .left)          // 16pt
TTBaseSUIText(withType: .TITLE, text: "...", align: .left)           // 14pt
TTBaseSUIText(withType: .SUB_TITLE, text: "...", align: .left)       // 12pt
TTBaseSUIText(withType: .SUB_SUB_TILE, text: "...", align: .left)    // smallest
// Bold variant:
TTBaseSUIText(withBold: .TITLE, text: "...", align: .leading, color: XView.textDefColor.toColor())
```

## Button Types
```swift
TTBaseSUIButton(type: .DEFAULT, title: "...")              // blue bg
TTBaseSUIButton(type: .WARRING, title: "...")               // red bg
TTBaseSUIButton(type: .DISABLE, title: "...")               // grayed out
TTBaseSUIButton(type: .NO_BG_COLOR, title: "...")           // transparent
TTBaseSUIButton(type: .BORDER, title: "...")                // border style
TTBaseSUIButton(type: .DEFAULT_COLOR(color: .systemBlue, textColor: .white), title: "...")
```

## Config Tokens — Never Hardcode
```swift
XView.textDefColor.toColor()        // text color → SwiftUI Color
XView.viewBgColor.toColor()         // background color
XView.buttonBgDef.toColor()         // button color
XView.lineDefColor.toColor()        // separator color
XSize.P_CONS_DEF                    // 8pt padding
XSize.CORNER_RADIUS                 // default corner
XSize.CORNER_BUTTON                 // button corner
XSize.getPadding()                  // computed padding
XFont.HEADER_H / .TITLE_H / .SUB_TITLE_H
```

## View Modifier Helpers — Always Use These
```swift
// Background & corner
view.bg(byDef: .white)              // background
view.corner()                        // default corner radius
view.corner(byDef: 12)              // custom corner

// Padding
view.pAll()                          // all edges (TTSize.P_S)
view.pHorizontal()                   // horizontal
view.pVertical(XSize.P_CONS_DEF)     // vertical
view.pTop() / .pBottom() / .pLeading() / .pTrailing()

// Layout
view.maxWidth()                      // frame(maxWidth: .infinity)
view.size(width: 100, height: 50)    // fixed size
view.sizeSquare(width: 40)           // square

// Shadow & border
view.baseShadow()                    // card shadow
view.baseBorder()                    // default border
view.setBorder(WithRadius: XSize.CORNER_RADIUS, color: XView.buttonBgDef.toColor())

// Skeleton
view.skeleton()                      // shimmer loading
view.skeleton(active: isLoading)     // conditional

// Interaction
view.onTapHandle { /* action */ }    // tap gesture
view.hidden(shouldHide)              // conditional hide
```

## Card Pattern
```swift
TTBaseSUIVStack(alignment: .leading, spacing: XSize.P_CONS_DEF) {
    TTBaseSUIText(withBold: .TITLE, text: "Title", align: .leading)
    TTBaseSUIText(withType: .SUB_TITLE, text: "Desc", align: .leading)
}
.pAll()
.bg(byDef: .white)
.corner()
.baseShadow()
```

## Composed View Pattern
```swift
struct MyComponentView: View {
    let title: String
    let subtitle: String

    var body: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: XSize.P_CONS_DEF / 2) {
            TTBaseSUIText(withBold: .TITLE, text: title, align: .leading,
                          color: XView.textDefColor.toColor())
            TTBaseSUIText(withType: .SUB_TITLE, text: subtitle, align: .leading)
        }
        .pAll()
        .bg(byDef: .white)
        .corner()
    }
}
```

## Localization
```swift
XText("App.Key")            // localized string
XTextU("App.Key")            // for nav titles
```
