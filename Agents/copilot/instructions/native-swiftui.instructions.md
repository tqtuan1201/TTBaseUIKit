---
applyTo: "**/NativeUI/**/*.swift,**/CustomViews/**/*.swift"
---

# Native SwiftUI Rules — Standard SwiftUI + Design Tokens (iOS 14+)

These rules apply to **native SwiftUI** files that use standard SwiftUI components with TTBaseUIKit design tokens. These files do NOT use TTBaseSUI* wrapper components. Rules adapted from swiftui-pro best practices for iOS 14+ target.

## Screen Navigation
- Use `SUIBaseView` for screen-level navigation wrapper (NOT `NavigationView` directly)
- View components do NOT use `SUIBaseView` or `NavigationView`

## Design Tokens — Never Hardcode
```swift
// Colors (convert UIColor → Color)
XView.textDefColor.toColor()        // default text
XView.textHeaderColor.toColor()     // header text
XView.textSubTitleColor.toColor()   // subtitle
XView.buttonBgDef.toColor()         // brand button bg
XView.viewBgColor.toColor()         // screen background
XView.lineDefColor.toColor()        // separators
XView.iconColor.toColor()           // icons
Color.fromHex(value: "#FF5733")     // hex to Color

// Sizes
XSize.P_CONS_DEF       // 8pt padding
XSize.CORNER_RADIUS    // default corner
XSize.CORNER_BUTTON    // button corner
XSize.H_BUTTON         // button height
XSize.W / XSize.H      // screen dims

// Fonts
XFont.HEADER_H         // 16pt
XFont.TITLE_H          // 14pt
XFont.SUB_TITLE_H      // 12pt
```

## SwiftUI API — iOS 14+ Compatible (mandatory)
```swift
// ✅ Use (iOS 14+)                    // ❌ Avoid (higher iOS)
.foregroundColor(.red)              // .foregroundStyle(.red) → iOS 15+
.clipShape(RoundedRectangle(cornerRadius: 8)) // .clipShape(.rect()) → iOS 16+
SUIBaseView { }                     // NavigationStack { } → iOS 16+
NavigationLink(destination:)        // navigationDestination(for:) → iOS 16+
ScrollView(showsIndicators: false)  // .scrollIndicators(.hidden) → iOS 16+
PreviewProvider                     // #Preview { } → iOS 17+
.navigationBarLeading               // .topBarLeading → iOS 15+
.navigationBarTrailing              // .topBarTrailing → iOS 15+
.onAppear { Task { await ... } }   // .task { } → iOS 15+
.animation(.x, value: y)           // .animation(.x) → deprecated
overlay(content)                    // overlay { content } → iOS 15+
ObservableObject + @Published       // @Observable → iOS 17+
onChange(of:) { newValue in }       // onChange (0-param) → iOS 17+
GeometryReader                      // containerRelativeFrame → iOS 17+
```

## View Composition (swiftui-pro)
- Extract subviews → separate `View` structs in own files, NOT computed properties
- `body` < 40 lines — extract longer bodies into subviews
- Button actions → separate methods
- Logic out of `body` / `onAppear`
- Each type (struct, class, enum) in own file
- `PreviewProvider` at bottom of every file
- **Extracted sub-views → `CustomViews/` folder within feature directory**
- Screen-specific sub-views → `{Feature}/CustomViews/`, shared → `SharedViews/`

## Data Flow
- `@State` must be `private`
- Avoid `Binding(get:set:)` — use `onChange()` instead
- `.onAppear { Task { await ... } }` for async work (`.task {}` requires iOS 15+)
- `@StateObject` for owned data, `@ObservedObject` for injected
- Structs conform to `Identifiable`

## Accessibility (swiftui-pro)
- Dynamic Type: `.font(.body)` or `@ScaledMetric`
- Use `Button` for tappable elements — NOT `onTapGesture` as substitute
- Tap area ≥ 44×44
- Respect Reduce Motion: `@Environment(\.accessibilityReduceMotion)`
- Images need VoiceOver: `Image(decorative:)` or `.accessibilityLabel()`
- Buttons with icons must include text labels

## Performance (swiftui-pro)
- Ternary > if/else for modifier toggling
- No `AnyView` — `@ViewBuilder`, `Group`, or generics
- `@ViewBuilder let content: Content` not `() -> Content`
- `LazyVStack`/`LazyHStack` for large data
- Minimal view init, no heavy work in `body`
- Avoid storing formatter instances — use `Text(value, format:)`
- Avoid expensive inline transforms in `ForEach`

## Design (swiftui-pro)
- Never `UIScreen.main.bounds` — use `GeometryReader`
- Prefer flexible frames over fixed sizes
- Use XView/XSize/XFont shared constants
- Use `Label("Text", systemImage: "icon")` for icon+text

## Swift Quality (swiftui-pro)
- `async/await` over GCD
- `if let value {` shorthand
- `Double` over `CGFloat`
- `Date.now` over `Date()`
- No force unwraps
- `localizedStandardContains()` for user-input filtering

## Hygiene
- `// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀` at top of every new file
- Comments on non-obvious logic
- No secrets/API keys
- `PreviewProvider` present on every view

## Localization
```swift
XText("App.Key")     // localized string
XTextU("App.Key")    // uppercase (nav titles)
XPrint("debug")      // debug print
```
