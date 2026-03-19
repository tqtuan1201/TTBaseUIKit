---
description: "Review native SwiftUI code for iOS 14+ API, accessibility, performance, design, and design token compliance"
---

# Review Native SwiftUI Code

Review SwiftUI code for correctness, iOS 14+ API usage, accessibility, performance, design, and TTBaseUIKit token compliance. Report only genuine problems. Based on swiftui-pro best practices adapted for iOS 14+.

> ⚠️ This reviews **native SwiftUI** code. For TTBaseSUI* compliance reviews, use `fix-swiftui-compliance` instead.

## Check 1 — iOS Version Compliance (🔴 Critical)

| ❌ Avoid (higher iOS required) | ✅ iOS 14+ Replacement |
|---|---|
| `foregroundStyle()` (iOS 15+) | `foregroundColor()` |
| `cornerRadius(N)` (deprecated) | `clipShape(RoundedRectangle(cornerRadius: N))` |
| `NavigationStack { }` (iOS 16+) | `SUIBaseView` (screens) or `NavigationView` (components) |
| `navigationDestination(for:)` (iOS 16+) | `NavigationLink(destination:)` |
| `.scrollIndicators(.hidden)` (iOS 16+) | `ScrollView(showsIndicators: false)` |
| `#Preview { }` (iOS 17+) | `PreviewProvider` protocol |
| `.topBarLeading/.topBarTrailing` (iOS 15+) | `.navigationBarLeading/.navigationBarTrailing` |
| `.task { }` (iOS 15+) | `.onAppear { Task { } }` |
| `animation(.x)` (no value) | `.animation(.x, value: y)` |
| `overlay { content }` (iOS 15+ closure) | `overlay(content)` (iOS 14 view param) |
| `@Observable` (iOS 17+) | `ObservableObject` + `@Published` |
| `containerRelativeFrame()` (iOS 17+) | `GeometryReader` or `.frame()` |

## Check 2 — Screen Navigation Wrapper (🔴 Critical)

- ❌ Screen using `NavigationView` directly → use `SUIBaseView`
- ❌ Screen using `NavigationStack` → use `SUIBaseView`
- ❌ `SUIBaseView` nested inside `NavigationView` → remove outer `NavigationView`

## Check 3 — Hardcoded Values → Tokens (🟡 Warning)

| Hardcoded | Token |
|---|---|
| `Color.blue` / `.systemBlue` | `XView.buttonBgDef.toColor()` |
| `Color.gray` | `XView.viewBgColor.toColor()` |
| `Color(hex: "...")` | `Color.fromHex(value: "...")` or `XView.*` |
| `8` (padding) | `XSize.P_CONS_DEF` |
| `16` (padding) | `XSize.P_CONS_DEF * 2` |
| `4` (corner radius) | `XSize.CORNER_RADIUS` |
| `.system(size: 14)` | `.system(size: XFont.TITLE_H)` |
| `.system(size: 16)` | `.system(size: XFont.HEADER_H)` |
| `.system(size: 12)` | `.system(size: XFont.SUB_TITLE_H)` |
| Hardcoded strings | `XText("key")` / `XTextU("key")` |
| `print()` | `XPrint()` |
| `UIScreen.main.bounds` | `GeometryReader` |

## Check 4 — Accessibility (🔴 Critical)

- ❌ Fixed font sizes without Dynamic Type support → `.font(.body)` or `@ScaledMetric`
- ❌ Icon-only buttons without text labels → add text label
- ❌ `onTapGesture` used as button substitute → use `Button` instead
- ❌ `onTapGesture` without `.accessibilityAddTraits(.isButton)`
- ❌ Images without VoiceOver labels → `Image(decorative:)` or `.accessibilityLabel()`
- ❌ Tap areas < 44×44
- ❌ Animations ignoring Reduce Motion → check `@Environment(\.accessibilityReduceMotion)`

## Check 5 — Performance (🟡 Warning)

- ❌ `AnyView` usage → `@ViewBuilder` / generics
- ❌ if/else view branching where ternary works
- ❌ Eager stacks with many children → `LazyVStack`/`LazyHStack`
- ❌ Heavy work in view init or body
- ❌ `() -> Content` → `@ViewBuilder let content: Content`
- ❌ Storing formatter instances → use `Text(value, format:)`
- ❌ Expensive inline transforms in `ForEach` → cache in `let`/`@State`

## Check 6 — Architecture / Composition (🟡 Warning)

- ❌ `body` > 40 lines → extract subviews to separate `View` structs
- ❌ Computed properties returning `some View` → separate `View` struct
- ❌ `@ViewBuilder` methods → separate `View` struct
- ❌ Inline button/action logic → extract methods
- ❌ `@State` not `private`
- ❌ `Binding(get:set:)` → `onChange()`
- ❌ Missing `PreviewProvider`
- ❌ Sub-views not in `CustomViews/` folder → move to `{Feature}/CustomViews/`

## Check 7 — Design (🟡 Warning)

- ❌ `UIScreen.main.bounds` for sizing → `GeometryReader`
- ❌ Fixed frames without flexibility → flexible frames for device adaptability
- ❌ No shared design constants → use XView/XSize/XFont tokens
- ❌ Custom icon+text HStack → use `Label("Text", systemImage: "icon")`

## Check 8 — Swift Quality (🟡 Warning)

- ❌ `DispatchQueue.main.async` → `@MainActor`
- ❌ `if let value = value {` → `if let value {`
- ❌ Force unwrap `!` → `if let`, `guard let`, nil-coalescing
- ❌ `CGFloat` (non-optional) → `Double`
- ❌ `Date()` → `Date.now`
- ❌ `contains()` for user-input → `localizedStandardContains()`

## Check 9 — Hygiene (🟢)

| Check | Status |
|---|---|
| `// [TTBaseUIKit-AI-Agents]:` marker comment present | ✅ / ❌ |
| Comments on non-obvious logic | ✅ / ❌ |
| No secrets/API keys in code | ✅ / ❌ |
| XText/XTextU keys in Localizable.strings | ✅ / ❌ |
| `PreviewProvider` present | ✅ / ❌ |

## Steps

1. Scan for deprecated/higher-iOS APIs
2. Check screen navigation wrapper (SUIBaseView for screens)
3. Check hardcoded values and token compliance
4. Check accessibility compliance
5. Check performance and composition patterns
6. Check design and Swift quality
7. Check hygiene
8. Report with before/after code fixes
9. Score: `⭐ Native SwiftUI Quality: X/10`

## Plan Output (MANDATORY)

After completing any work, generate a plan file for future context:

1. Create `plans/YYYY-MM-DD-{feature-name}/plan.md`
2. Include: date, goal, files table (NEW/MODIFY/DELETE), patterns & tokens used, context for future upgrades
3. Auto-add plan file to Xcode:
```bash
ruby .agent/skills/ttbase-swiftui/scripts/add_to_xcode_project.rb "{plan_file_path}"
```

> See `instructions/plan-generation.instructions.md` for full templates.

---

## 🚩 Code Generation Comment (MANDATORY)
All generated Swift code MUST include:
```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
```
