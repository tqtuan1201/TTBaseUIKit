---
description: "Build native SwiftUI star rating component, both display and interactive modes. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-rating — Native SwiftUI Rating Component Builder

Build reusable star rating native SwiftUI components using TTBaseUIKit design tokens.

## When

User say native rating" "star rating" "interactive rating" "review stars"

## Native SwiftUI Compliance Baseline

These rules override any older examples in this prompt:

1. **100% native SwiftUI primitives** inside generated `/native-*` components: use `Text`, `Button`, `VStack`, `HStack`, `Image`, native controls, shapes, and modifiers; do not use `TTBaseSUI*`, `SUIBaseView`, or `TTBaseNavigationLink` here.
2. **TTBaseUIKit project rules still apply**: follow the current project folder structure, file header marker, `MARK` sections, access control, Xcode project registration, and verification scripts.
3. **Displayed strings must use `XText("key")`**. Prefer API names like `titleKey`, `textKey`, `placeholderKey`, `accessibilityKey`, and `hintKey`. Convert raw sample strings to localization keys before emitting production code.
4. **Use `TTView`, `TTSize`, and `TTFont` tokens** for colors, spacing, radii, heights, and fonts. Do not hardcode design values unless needed for geometry math.
5. **Chainable modifiers are mandatory where available**: prefer `.pAll()`, `.pHorizontal()`, `.pVertical()`, `.bg()`, `.corner()`, `.baseShadow()`, `.baseBorder()`, `.size()`, `.sizeSquare()`, `.maxWidth()`, and `.maxHeight()` over raw `.padding`, `.background`, `.clipShape`, `.frame` chains when the extension covers the behavior.
6. **Use `Button` or native controls for all tappable UI**. Do not use `.onTapGesture` as a button substitute; `.onTapHandle` is only allowed for real non-control gestures.
7. **Minimum tap target is 44x44** for every interactive element.
8. **`@StateObject` for owned ViewModels, `@ObservedObject` for injected ViewModels**. Do not instantiate observable objects inside `body`.
9. **Use `[weak self]` in every escaping closure inside classes/ViewModels/coordinators/services**. SwiftUI `View` structs should call injected closures/private methods without strongly capturing reference objects.
10. **Keep `body` under 40 lines**. Extract private computed subviews, helper methods, or private `View` structs.
11. **iOS 14+ only**: no `.task`, `NavigationStack`, `#Preview`, `.foregroundStyle()`, `AsyncImage`, or other iOS 15+ APIs.
12. **Accessibility is mandatory**: use `.accessibilityLabel(XText(...))` and `.accessibilityHint(XText(...))` for interactive or non-obvious UI.

## Rating Component Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  Components/Rating/{Name}Rating.swift
//  {AppName}
//

import SwiftUI
import TTBaseUIKit

// MARK: - {Name}Rating
public struct {Name}Rating: View {
    public var rating: Double
    public var maxRating: Int = 5
    public var starSize: CGFloat = 20
    public var isInteractive: Bool = false
    public var onRatingChanged: ((Double) -> Void)?
    public var tintColor: Color = TTView.notificationBgWarning.toColor()

    public init(
        rating: Double,
        maxRating: Int = 5,
        starSize: CGFloat = 20,
        isInteractive: Bool = false,
        tintColor: Color? = nil,
        onRatingChanged: ((Double) -> Void)? = nil
    ) {
        self.rating = rating
        self.maxRating = maxRating
        self.starSize = starSize
        self.isInteractive = isInteractive
        if let tc = tintColor { self.tintColor = tc }
        self.onRatingChanged = onRatingChanged
    }

    public var body: some View {
        HStack(spacing: TTSize.P_XS) {
            ForEach(1...self.maxRating, id: \.self) { index in
                Button {
                    guard self.isInteractive else { return }
                    self.onRatingChanged?(Double(index))
                } label: {
                    starImage(for: index)
                        .font(.system(size: self.starSize))
                        .foregroundColor(self.tintColor)
                        .sizeSquare(width: max(self.starSize, 44))
                }
                .buttonStyle(.plain)
                .disabled(!self.isInteractive)
            }
        }
        .accessibilityLabel(String(format: XText("Accessibility.Rating.Value.Format"), Int(self.rating), self.maxRating))
    }

    private func starImage(for index: Int) -> Image {
        let fillAmount = self.rating - Double(index - 1)
        if fillAmount >= 1.0 {
            return Image(systemName: "star.fill")
        } else if fillAmount >= 0.5 {
            return Image(systemName: "star.leadinghalf.fill")
        } else {
            return Image(systemName: "star")
        }
    }
}

// MARK: - {Name}RatingBar
public struct {Name}RatingBar: View {
    public var rating: Double
    public var maxRating: Int = 5
    public var starSize: CGFloat = 16
    public var showLabel: Bool = true
    public var tintColor: Color = TTView.notificationBgWarning.toColor()

    public init(
        rating: Double,
        maxRating: Int = 5,
        starSize: CGFloat = 16,
        showLabel: Bool = true,
        tintColor: Color? = nil
    ) {
        self.rating = rating
        self.maxRating = maxRating
        self.starSize = starSize
        self.showLabel = showLabel
        if let tc = tintColor { self.tintColor = tc }
    }

    public var body: some View {
        HStack(spacing: TTSize.P_S) {
            {Name}Rating(rating: self.rating, maxRating: self.maxRating, starSize: self.starSize, tintColor: self.tintColor)

            if self.showLabel {
                Text(String(format: "%.1f", self.rating))
                    .font(.system(size: TTFont.SUB_TITLE_H, weight: .semibold))
                    .foregroundColor(TTView.textDefColor.toColor())
            }
        }
    }
}

// MARK: - {Name}InteractiveRating
public struct {Name}InteractiveRating: View {
    @Binding public var rating: Int
    public var maxRating: Int = 5
    public var starSize: CGFloat = 36
    public var tintColor: Color = TTView.notificationBgWarning.toColor()
    public var onRatingChanged: ((Int) -> Void)?

    public init(
        rating: Binding<Int>,
        maxRating: Int = 5,
        starSize: CGFloat = 36,
        tintColor: Color? = nil,
        onRatingChanged: ((Int) -> Void)? = nil
    ) {
        self._rating = rating
        self.maxRating = maxRating
        self.starSize = starSize
        if let tc = tintColor { self.tintColor = tc }
        self.onRatingChanged = onRatingChanged
    }

    public var body: some View {
        HStack(spacing: TTSize.P_CONS_DEF) {
            ForEach(1...self.maxRating, id: \.self) { index in
                Button {
                    self.rating = index
                    self.onRatingChanged?(index)
                } label: {
                    Image(systemName: index <= self.rating ? "star.fill" : "star")
                        .font(.system(size: self.starSize))
                        .foregroundColor(index <= self.rating ? self.tintColor : TTView.iconColor.toColor())
                        .sizeSquare(width: max(self.starSize, 44))
                }
                .buttonStyle(.plain)
            }
        }
        .accessibilityLabel(String(format: XText("Accessibility.Rating.Value.Format"), self.rating, self.maxRating))
    }
}

// MARK: - Preview
struct {Name}Rating_Previews: PreviewProvider {
    @State static var interactiveRating = 3

    static var previews: some View {
        VStack(spacing: TTSize.P_XL) {
            VStack(alignment: .leading, spacing: TTSize.P_CONS_DEF) {
                Text(XText("Preview.Rating.Display"))
                    .font(.system(size: TTFont.SUB_TITLE_H, weight: .semibold))
                    .foregroundColor(TTView.textSubTitleColor.toColor())

                {Name}Rating(rating: 3.2)
            }

            VStack(alignment: .leading, spacing: TTSize.P_CONS_DEF) {
                Text(XText("Preview.Rating.Bar"))
                    .font(.system(size: TTFont.SUB_TITLE_H, weight: .semibold))
                    .foregroundColor(TTView.textSubTitleColor.toColor())

                {Name}RatingBar(rating: 4.5)
                {Name}RatingBar(rating: 3.8, starSize: 12, showLabel: false)
            }

            VStack(alignment: .leading, spacing: TTSize.P_CONS_DEF) {
                Text(XText("Preview.Rating.Interactive"))
                    .font(.system(size: TTFont.SUB_TITLE_H, weight: .semibold))
                    .foregroundColor(TTView.textSubTitleColor.toColor())

                {Name}InteractiveRating(rating: $interactiveRating) { rating in
                    print("Selected: \(rating)")
                }

                Text(String(format: XText("Preview.Rating.Selected.Format"), interactiveRating))
                    .font(.system(size: TTFont.SUB_TITLE_H))
                    .foregroundColor(TTView.textSubTitleColor.toColor())
            }
        }
        .pAll(TTSize.P_L)
        .bg(byDef: TTView.viewBgColor.toColor())
    }
}
```

## Rules

1. **100% native SwiftUI primitives** — no `TTBaseSUI*`, `SUIBaseView`, or `TTBaseNavigationLink` wrappers in `/native-*` components
2. **TTBaseUIKit tokens + chainable modifiers**: `TTView.*.toColor()`, `TTSize.*`, `TTFont.*`, `.pAll()`, `.bg()`, `.corner()`, `.baseShadow()`, `.size()`
3. **Star types**: `star.fill` (full), `star.leadinghalf.fill` (half), `star` (empty)
4. **Half-star logic**: `fillAmount = rating - (index - 1)`, full >= 1.0, half >= 0.5
5. **Tint color**: `TTView.notificationBgWarning.toColor()` (yellow) — TTBaseUIKit warning color
6. **Interactive**: `@Binding` for controlled state, tap updates binding
7. **RatingBar**: rating display with numeric label
8. **Accessibility**: `.accessibilityLabel()` with numeric value
9. **PreviewProvider** at bottom
10. **MARKER COMMENT** at top

## Post-Implementation Verification

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
4. **Skill is complete only when** `✅ BUILD SUCCEEDED`

**Anti-Loop**: Max 3 build attempts. 3 failures → STOP, document errors.

For full FCR 7-Dimension scoring, see `ttb-skill-shared/phases/ttb-phase-verify.md`.
