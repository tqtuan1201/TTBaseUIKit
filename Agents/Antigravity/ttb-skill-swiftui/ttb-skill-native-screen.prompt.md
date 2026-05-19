---
description: "Native SwiftUI screen using 100% standard SwiftUI with TTBaseUIKit tokens. STRICTLY FALLBACK ONLY — use /ttb-sui-screen when TTBaseSUI components exist."
---

# ttb-skill-native-screen — Native SwiftUI Screen Builder

> ⚠️ **FALLBACK ONLY**: Use `/ttb-sui-screen` first. Only use this when TTBaseSUI lacks a component.
>
> Use this for: complex custom layouts, charts, custom animations, advanced gestures.

## When

User says: "native swiftui screen", "complex swiftui screen", "custom layout screen"
AND TTBaseSUI has no equivalent for the required component.

## Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  {Name}Screen.swift
//  {AppName}
//  ⚠️ FALLBACK: Native SwiftUI — use TTBaseSUI when possible
//

import SwiftUI
import TTBaseUIKit

// MARK: - {Name}Screen
struct {Name}Screen: View {

    @StateObject private var vm = {Name}ViewModel()

    var body: some View {
        SUIBaseView(
            backType: .SWIFTUI,
            title: XText("App.{Name}.Nav.Title"),
            type: .DEFAULT,
            isHiddenTabbar: true,
            backAction: {}
        ) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: TTSize.P_CONS_DEF) {
                    Text(XText("App.{Name}.Header"))
                        .font(.system(size: TTFont.HEADER_H, weight: .bold))
                        .foregroundColor(TTView.textDefColor.toColor())

                    Button {
                        vm.performAction()
                    } label: {
                        Text("ACTION")
                            .font(.system(size: TTFont.TITLE_H, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: TTSize.H_BUTTON)
                            .background(TTView.buttonBgDef.toColor())
                            .clipShape(RoundedRectangle(cornerRadius: TTSize.CORNER_BUTTON))
                    }
                }
                .padding(TTSize.P_CONS_DEF * 2)
            }
            .background(TTView.viewBgColor.toColor())
        }
        .onAppear { vm.fetchData() }
    }
}

// MARK: - Preview
struct {Name}Screen_Previews: PreviewProvider {
    static var previews: some View {
        {Name}Screen()
    }
}
```

## TTBaseUIKit Tokens for Native SwiftUI

```swift
// Colors
TTView.viewBgColor.toColor()
TTView.viewDefColor.toColor()
TTView.viewBgCellColor.toColor()
TTView.textDefColor.toColor()
TTView.textSubTitleColor.toColor()
TTView.textTitleColor.toColor()
TTView.buttonBgDef.toColor()
TTView.iconColor.toColor()
TTView.lineDefColor.toColor()

// Sizes
TTSize.P_CONS_DEF    // 8pt
TTSize.P_XS         // 4pt
TTSize.P_L          // 16pt
TTSize.H_BUTTON     // 40pt
TTSize.H_TEXTFIELD  // 35pt
TTSize.CORNER_RADIUS    // 4pt
TTSize.CORNER_PANEL     // 8pt
TTSize.CORNER_BUTTON     // 4pt

// Fonts
TTFont.HEADER_H         // ~16pt bold
TTFont.TITLE_H          // ~14pt
TTFont.SUB_TITLE_H      // ~12pt
TTFont.SUB_SUB_TITLE_H  // ~10pt
```

## Modifier Reference

```swift
// Chainable extensions (preferred)
.pAll(TTSize.P_CONS_DEF)
.pHorizontal(TTSize.P_CONS_DEF)
.pVertical(TTSize.P_CONS_DEF)
.pTop(TTSize.P_CONS_DEF)
.pBottom(TTSize.P_CONS_DEF)
.bg(byDef: TTView.viewBgColor.toColor())
.corner(byDef: TTSize.CORNER_PANEL)
.skeleton(active: isLoading)
.sizeSquare(width: 50)
.hidden(someCondition)
.maxWidth()

// Standard SwiftUI
.padding(TTSize.P_CONS_DEF)
.clipShape(RoundedRectangle(cornerRadius: TTSize.CORNER_BUTTON))
.foregroundColor(TTView.textDefColor.toColor())
.background(TTView.viewBgColor.toColor())
.shadow(color: .black.opacity(0.14), radius: 8, x: 0, y: 4)
```

## Rules

1. **SUIBaseView wrapper** — mọi screen phải bọc trong `SUIBaseView`
2. **100% standard SwiftUI** — native `Text`, `Button`, `VStack`, `ScrollView`
3. **TTBaseUIKit tokens** — `TTView.*.toColor()`, `TTSize.*`, `TTFont.*`
4. **Chainable extensions** — ưu tiên `.pAll()`, `.bg()`, `.corner()`
5. **iOS 14+ APIs ONLY**:
   - `foregroundColor()` NOT `.foregroundStyle()`
   - `.clipShape(RoundedRectangle(cornerRadius:))` NOT `.clipShape(.rect())`
   - `ScrollView(showsIndicators: false)` NOT `.scrollIndicators(.hidden)`
   - `PreviewProvider` NOT `#Preview`
   - `.onAppear { }` NOT `.task { }`
   - `ObservableObject` + `@Published` + `@StateObject` NOT `@Observable`
6. **Use `Button`** cho tappable — NEVER `onTapGesture` as button substitute
7. **Minimum 44×44** tap area
8. **Extract sub-views** nếu body > 40 lines
9. **@StateObject** cho owned ViewModel
10. **PreviewProvider** at bottom
11. **Document the gap** — note which TTBaseSUI component is missing

## Post-Implementation Verification (MANDATORY)

After all files are generated, **run Phase 6 verification**:

1. **Add files to Xcode project** — ensure each `.swift` is registered in `project.pbxproj`
2. **Run verification**:
   ```bash
   bash ttb-skill-shared/scripts/ttb-verify.sh
   ```
3. **Check compliance**:
   ```bash
   bash ttb-skill-shared/scripts/ttb-compliance-check.sh
   ```
4. **Skill is complete only when** `BUILD SUCCEEDED`

**Anti-Loop**: Max 3 build attempts. 3 failures — STOP, document errors.

For full FCR 7-Dimension scoring, see `ttb-skill-shared/phases/ttb-phase-verify.md`.
