---
applyTo: "**/SUI*View.swift,**/SUI*Screen.swift"
---

# SwiftUI Screen Rules — SUIBaseView Pattern

## Screen Wrapper
All SwiftUI screens wrap content in `SUIBaseView` (project) or `SUIBaseViewDemo` (example):

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
import SwiftUI
import TTBaseUIKit

struct {Name}Screen: View {

    var body: some View {
        SUIBaseView(
            backType: .POP,
            title: XTextU("App.{Name}.Nav.Title"),
            isHiddenTabbar: true
        ) {
            TTBaseSUIView(withCornerRadius: 0, bg: XView.viewBgColor.toColor()) {
                TTBaseSUIScroll {
                    TTBaseSUIVStack(alignment: .center, spacing: XSize.P_CONS_DEF, bg: .clear) {
                        // Screen content using TTBaseSUI* components
                    }.padding(.all, XSize.P_CONS_DEF)
                }
            }
        }
        .onAppear { }
    }
}
```

## Back Types
```swift
.POP            // pop from nav stack (default)
.POP_TO_ROOT    // pop to root
.DISMISS        // dismiss modal
.DISMISS_ALL    // dismiss all modals
.CLOSE_FLOW     // pop to root + dismiss (end multi-step flow)
```

## Screen Types
```swift
// .DEFAULT  — back button + title + right button nav bar
// .INFO     — custom left/right nav bar without back button
SUIBaseView(type: .DEFAULT, title: "...") { content }
```

## ViewControllerProvider Bridge
Access UIKit navigation from SwiftUI via `@EnvironmentObject`:
```swift
@EnvironmentObject var hostingProvider: ViewControllerProvider

// Use to access current UIViewController for UIKit navigation
if let vc = hostingProvider.getCurrentVC() {
    vc.push(someUIKitVC)
    vc.presentDef(vc: someVC)
    vc.pop()
}
```

## Nav Bar Appearance
```swift
.onAppear {
    UINavigationBarAppearance().setColor(title: .white, background: XView.viewBgNavColor)
}
```

## Tab Bar Control
```swift
// Inside SUIBaseView — controlled via isHiddenTabbar parameter
// Or manually:
UITabBar.hideTabBar(animated: true)
UITabBar.showTabBar(animated: true)
```

## iOS 14+ API Compliance (MANDATORY)
```swift
// ✅ Use (iOS 14+)                    // ❌ Avoid (higher iOS)
.foregroundColor(.red)              // .foregroundStyle(.red) → iOS 15+
NavigationView { }                  // NavigationStack { } → iOS 16+
ScrollView(showsIndicators: false)  // .scrollIndicators(.hidden) → iOS 16+
PreviewProvider                     // #Preview { } → iOS 17+
.onAppear { Task { await ... } }   // .task { } → iOS 15+
.animation(.x, value: y)           // .animation(.x) → deprecated
```

## Rules
- **iOS 14+ APIs only** — never use APIs requiring iOS 15, 16, or 17
- `// [TTBaseUIKit-AI-Agents]:` marker comment at top of every new file
- Always wrap screens in `SUIBaseView` with localized title via `XTextU("Key")`
- Use `TTBaseSUIView(withCornerRadius:bg:)` as inner content container
- Use `TTBaseSUIScroll` + `TTBaseSUIVStack` for scrollable content
- Set `backType` appropriate to the navigation context
- Add `.onAppear { }` for lifecycle hooks (NOT `.task { }`)
- Never hardcode nav bar colors — use `XView.viewBgNavColor`
