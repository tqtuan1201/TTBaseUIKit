---
description: "Build native SwiftUI bottom sheet and modal presentation components. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-bottom-sheet — Native SwiftUI Bottom Sheet Component Builder

Build reusable bottom sheet native SwiftUI components using TTBaseUIKit design tokens.

## When

User says: "native bottom sheet", "modal sheet", "slide up panel", "action sheet"

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
                    .onTapGesture { self.isPresented = false }
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
        .animation(.easeInOut(duration: 0.3), value: self.isPresented)
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
                        .padding(.top, TTSize.P_S)
                        .padding(.bottom, TTSize.P_CONS_DEF)
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
            .shadow(color: .black.opacity(0.15), radius: 16, x: 0, y: -4)
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

            Button("Show Bottom Sheet") {
                showSheet = true
            }
            .padding()

            Color.clear
                .{Name}BottomSheet(isPresented: $showSheet) {
                    VStack(spacing: TTSize.P_L) {
                        Text("Bottom Sheet Content")
                            .font(.system(size: TTFont.HEADER_H, weight: .bold))
                            .foregroundColor(TTView.textHeaderColor.toColor())

                        Text("This is a native SwiftUI bottom sheet built with TTBaseUIKit design tokens.")
                            .font(.system(size: TTFont.TITLE_H))
                            .foregroundColor(TTView.textDefColor.toColor())
                            .multilineTextAlignment(.center)
                    }
                    .padding(TTSize.P_L)
                }
        }
    }
}
```

## Rules

1. **100% native SwiftUI** — no TTBaseSUI* wrappers
2. **TTBaseUIKit tokens**: `TTView.*.toColor()`, `TTSize.*`, `TTFont.*`
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
