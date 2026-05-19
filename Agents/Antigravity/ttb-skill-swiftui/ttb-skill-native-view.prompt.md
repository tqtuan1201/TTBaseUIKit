---
description: "Native SwiftUI reusable view using 100% standard SwiftUI with TTBaseUIKit tokens. STRICTLY FALLBACK ONLY — use /ttb-sui-view when TTBaseSUI components exist."
---

# ttb-skill-native-view — Native SwiftUI View Builder

> ⚠️ **FALLBACK ONLY**: Use `/ttb-sui-view` first. Only use this when TTBaseSUI lacks a component.
>
> Use this for: complex custom layouts, charts, custom animations, advanced gestures.

## When

User says: "native swiftui view", "custom layout", "complex view", "chart view"
AND TTBaseSUI has no equivalent for the required component.

## Tappable Card Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  CustomViews/{Name}CardView.swift
//  {AppName}
//  ⚠️ FALLBACK: Native SwiftUI — use TTBaseSUI when possible
//

import SwiftUI
import TTBaseUIKit

// MARK: - {Name}CardView
struct {Name}CardView: View {

    let title: String
    let subtitle: String
    var onTap: (() -> Void)?

    var body: some View {
        Button {
            onTap?()
        } label: {
            HStack(spacing: TTSize.P_CONS_DEF) {
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(TTView.iconColor.toColor())

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: TTFont.TITLE_H, weight: .bold))
                        .foregroundColor(TTView.textDefColor.toColor())
                    Text(subtitle)
                        .font(.system(size: TTFont.SUB_TITLE_H))
                        .foregroundColor(TTView.textSubTitleColor.toColor())
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: TTFont.SUB_TITLE_H))
                    .foregroundColor(TTView.textSubTitleColor.toColor())
            }
            .padding(TTSize.P_CONS_DEF)
            .background(TTView.viewBgCellColor.toColor())
            .clipShape(RoundedRectangle(cornerRadius: TTSize.CORNER_RADIUS))
            .shadow(color: .black.opacity(0.14), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
struct {Name}CardView_Previews: PreviewProvider {
    static var previews: some View {
        {Name}CardView(title: "Card Title", subtitle: "Description")
            .padding()
    }
}
```

## Static Display Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  CustomViews/{Name}InfoView.swift
//  {AppName}
//  ⚠️ FALLBACK: Native SwiftUI — use TTBaseSUI when possible
//

import SwiftUI
import TTBaseUIKit

// MARK: - {Name}InfoView
struct {Name}InfoView: View {

    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: TTSize.P_S) {
            Text(title)
                .font(.system(size: TTFont.TITLE_H, weight: .bold))
                .foregroundColor(TTView.textDefColor.toColor())
            Text(subtitle)
                .font(.system(size: TTFont.SUB_TITLE_H))
                .foregroundColor(TTView.textSubTitleColor.toColor())
        }
        .padding(TTSize.P_CONS_DEF)
        .background(TTView.viewBgCellColor.toColor())
        .clipShape(RoundedRectangle(cornerRadius: TTSize.CORNER_RADIUS))
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
.bg(byDef: TTView.viewBgCellColor.toColor())
.corner(byDef: TTSize.CORNER_PANEL)
.skeleton(active: isLoading)
.sizeSquare(width: 50)
.hidden(someCondition)
.maxWidth()

// Standard SwiftUI
.padding(TTSize.P_CONS_DEF)
.clipShape(RoundedRectangle(cornerRadius: TTSize.CORNER_RADIUS))
.foregroundColor(TTView.textDefColor.toColor())
.background(TTView.viewBgCellColor.toColor())
.shadow(color: .black.opacity(0.14), radius: 8, x: 0, y: 4)
```

## Rules

1. **SUIBaseView wrapper** — mọi screen phải bọc trong `SUIBaseView`
2. **100% standard SwiftUI** — no TTBaseSUI* wrappers
3. **TTBaseUIKit tokens**: `TTView.*.toColor()`, `TTSize.*`, `TTFont.*`
4. **Chainable extensions**: ưu tiên `.pAll()`, `.bg()`, `.corner()`
5. **iOS 14+ APIs ONLY**:
   - `foregroundColor()` NOT `.foregroundStyle()`
   - `.clipShape(RoundedRectangle(cornerRadius:))` NOT `.clipShape(.rect())`
   - `PreviewProvider` NOT `#Preview`
6. **Use `Button`** cho tappable — NEVER `onTapGesture` as substitute
7. **Minimum 44×44** tap area
8. **Accessibility**: `.accessibilityLabel()` on images
9. **Body < 40 lines** — extract subviews if longer
10. **@ViewBuilder / Group** instead of `AnyView`
11. **PreviewProvider** at bottom
12. **Document the gap** — note which TTBaseSUI component is missing

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
