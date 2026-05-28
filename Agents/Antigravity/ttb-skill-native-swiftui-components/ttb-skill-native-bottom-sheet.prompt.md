---
description: "Build native SwiftUI bottom sheet and modal presentation components. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-bottom-sheet — Native SwiftUI Bottom Sheet Component Builder

Build reusable bottom sheet native SwiftUI components using TTBaseUIKit design tokens.

## Mandatory Preflight Execution Gate

Before generating code or modifying files, run `ttb-skill-shared/fragments/ttb-preflight-execution-gate.frag.md`.

Required checks:

- Analyze intent, task type, scope, impacted files/modules, dependencies, architecture constraints, coding standards, and project-specific rules.
- Validate required inputs such as target module, screen/component name, file location, navigation flow, expected output, API contract, state management, routing, localization, naming, and reusable component requirements.
- Detect ambiguity, conflicting requirements, incomplete business logic, unclear UX/navigation, unclear module ownership, and unclear architecture direction.
- Score confidence from `0-100`: execute at `90-100`, execute with warning assumptions at `70-89`, and ask a survey below `70` using `ttb-skill-shared/templates/ttb-clarification-survey.md`.
- Support English, Vietnamese, mixed-language, diacritic-free Vietnamese, and light typo prompts.

## When

User says: "native bottom sheet", "modal sheet", "slide up panel", "action sheet"

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

## Bottom Sheet Component Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  Components/BottomSheet/{Name}BottomSheet.swift
//  {AppName}
//

import SwiftUI
import TTBaseUIKit

// MARK: - {Name}BottomSheetModifier
public struct {Name}BottomSheetModifier: ViewModifier {
    @Binding public var isPresented: Bool
    public var detents: [Detent] = [.medium, .large]
    public var dragIndicator: Bool = true

    public enum Detent {
        case small   // 0.25
        case medium  // 0.5
        case large   // 0.9

        var value: CGFloat {
            switch self {
            case .small:   return 0.25
            case .medium:  return 0.5
            case .large:   return 0.9
            }
        }
    }

    public init(
        isPresented: Binding<Bool>,
        detents: [Detent] = [.medium, .large],
        dragIndicator: Bool = true
    ) {
        self._isPresented = isPresented
        self.detents = detents
        self.dragIndicator = dragIndicator
    }

    public func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            // Dimming overlay
            if self.isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapHandle { self.isPresented = false }
            }

            // Sheet
            if self.isPresented {
                {Name}SheetContent(
                    detents: self.detents,
                    dragIndicator: self.dragIndicator,
                    onDismiss: { self.isPresented = false }
                ) {
                    content
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.3))
    }
}

public extension View {
    func {Name}BottomSheet(
        isPresented: Binding<Bool>,
        detents: [{Name}BottomSheetModifier.Detent] = [.medium, .large],
        dragIndicator: Bool = true
    ) -> some View {
        modifier(
            {Name}BottomSheetModifier(
                isPresented: isPresented,
                detents: detents,
                dragIndicator: dragIndicator
            )
        )
    }
}

// MARK: - {Name}SheetContent
private struct {Name}SheetContent<Content: View>: View {
    let detents: [{Name}BottomSheetModifier.Detent]
    let dragIndicator: Bool
    let onDismiss: () -> Void
    let content: () -> Content

    @State private var selectedDetent: {Name}BottomSheetModifier.Detent

    init(
        detents: [{Name}BottomSheetModifier.Detent],
        dragIndicator: Bool,
        onDismiss: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.detents = detents
        self.dragIndicator = dragIndicator
        self.onDismiss = onDismiss
        self.content = content
        self._selectedDetent = State(initialValue: detents.first ?? .medium)
    }

    var body: some View {
        GeometryReader { geometry in
            let height = geometry.size.height * (self.detents.first ?? {Name}BottomSheetModifier.Detent.medium).value

            VStack(spacing: 0) {
                // Drag indicator
                if self.dragIndicator {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(TTView.iconColor.toColor().opacity(0.4))
                        .frame(width: 36, height: 4)
                        .pTop(TTSize.P_S)
                        .pBottom(TTSize.P_CONS_DEF)
                }

                // Content
                ScrollView {
                    self.content()
                }
                .frame(height: geometry.size.height - (self.dragIndicator ? 40 : 16))
            }
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(
                TTView.viewBgCellColor.toColor()
                    .clipShape(
                        RoundedCorner(radius: TTSize.CORNER_PANEL, corners: [.topLeft, .topRight])
                    )
            )
            .baseShadow(corner: TTSize.CORNER_PANEL, color: .black.opacity(0.15), radius: 16, x: 0, y: -4)
        }
        .frame(maxWidth: .infinity)
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: - RoundedCorner Shape
public struct RoundedCorner: Shape {
    public var radius: CGFloat = .infinity
    public var corners: UIRectCorner = .allCorners

    public init(radius: CGFloat = .infinity, corners: UIRectCorner = .allCorners) {
        self.radius = radius
        self.corners = corners
    }

    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: self.corners,
            cornerRadii: CGSize(width: self.radius, height: self.radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Preview
struct {Name}BottomSheet_Previews: PreviewProvider {
    @State static var showSheet = false

    static var previews: some View {
        ZStack {
            Color.gray.opacity(0.3).ignoresSafeArea()

            Button(action: {
                showSheet = true
            }) {
                Text(XText("Preview.BottomSheet.Show"))
            }
            .pAll(TTSize.P_CONS_DEF)

            Color.clear
                .{Name}BottomSheet(isPresented: $showSheet) {
                    VStack(spacing: TTSize.P_L) {
                        Text(XText("Preview.BottomSheet.Title"))
                            .font(.system(size: TTFont.HEADER_H, weight: .bold))
                            .foregroundColor(TTView.textHeaderColor.toColor())

                        Text(XText("Preview.BottomSheet.Message"))
                            .font(.system(size: TTFont.TITLE_H))
                            .foregroundColor(TTView.textDefColor.toColor())
                            .multilineTextAlignment(.center)
                    }
                    .pAll(TTSize.P_L)
                }
        }
    }
}
```

## Rules

1. **100% native SwiftUI primitives** — no `TTBaseSUI*`, `SUIBaseView`, or `TTBaseNavigationLink` wrappers in `/native-*` components
2. **TTBaseUIKit tokens + chainable modifiers**: `TTView.*.toColor()`, `TTSize.*`, `TTFont.*`, `.pAll()`, `.bg()`, `.corner()`, `.baseShadow()`, `.size()`
3. **Sheet height**: 25%, 50%, or 90% of screen via GeometryReader
4. **Drag indicator**: 36x4pt rounded rect, 0.4 opacity
5. **Corner radius = TTSize.CORNER_PANEL (8pt)** on top corners only
6. **Shadow**: opacity 0.15, radius 16, y: -4 (upward)
7. **Transition**: `.move(edge: .bottom).combined(with: .opacity)`
8. **Animation**: `.easeInOut(duration: 0.3)` on presentation
9. **Dimming overlay**: 0.4 opacity black, tap to dismiss
10. **PreviewProvider** at bottom
11. **MARKER COMMENT** at top

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
