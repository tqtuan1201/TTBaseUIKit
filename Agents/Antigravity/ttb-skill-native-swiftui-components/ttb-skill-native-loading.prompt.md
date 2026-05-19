---
description: "Build native SwiftUI loading overlay and spinner components: loading spinner, loading overlay, shimmer effect. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-loading — Native SwiftUI Loading Component Builder

Build reusable loading native SwiftUI components using TTBaseUIKit design tokens.

## When

User says: "native loading", "spinner", "loading overlay", "shimmer", "activity indicator", "loading"

## Loading Component Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  Components/Loading/{Name}Loading.swift
//  {AppName}
//

import SwiftUI
import TTBaseUIKit

// MARK: - {Name}LoadingSpinner
public struct {Name}LoadingSpinner: View {
    public enum Size {
        case small    // 20pt
        case medium  // 32pt
        case large   // 48pt

        var dimension: CGFloat {
            switch self {
            case .small:   return 20
            case .medium:  return 32
            case .large:   return 48
            }
        }
    }

    public var size: Size = .medium
    public var color: Color = TTView.buttonBgDef.toColor()
    public var lineWidth: CGFloat = 3

    public init(size: Size = .medium, color: Color? = nil, lineWidth: CGFloat = 3) {
        self.size = size
        if let c = color { self.color = c }
        self.lineWidth = lineWidth
    }

    public var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(self.color, style: StrokeStyle(lineWidth: self.lineWidth, lineCap: .round))
            .frame(width: self.size.dimension, height: self.size.dimension)
            .rotationEffect(.degrees(self.rotationAngle))
            .animation(
                Animation.linear(duration: 1.0).repeatForever(autoreverses: false),
                value: self.rotationAngle
            )
            .onAppear { self.rotationAngle = 360 }
            .accessibilityLabel("Loading")
    }

    @State private var rotationAngle: Double = 0
}

// MARK: - {Name}LoadingOverlay
public struct {Name}LoadingOverlay: View {
    public let message: String?
    public var backgroundColor: Color = Color.black.opacity(0.4)

    public init(message: String? = nil, backgroundColor: Color? = nil) {
        self.message = message
        if let bg = backgroundColor { self.backgroundColor = bg }
    }

    public var body: some View {
        ZStack {
            self.backgroundColor
                .ignoresSafeArea()

            VStack(spacing: TTSize.P_CONS_DEF) {
                {Name}LoadingSpinner(size: .large)

                if let message = self.message {
                    Text(message)
                        .font(.system(size: TTFont.TITLE_H, weight: .medium))
                        .foregroundColor(.white)
                }
            }
            .padding(TTSize.P_L)
            .background(TTView.viewBgCellColor.toColor().opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: TTSize.CORNER_PANEL))
        }
        .accessibilityLabel(self.message ?? "Loading")
    }
}

// MARK: - {Name}InlineLoading
public struct {Name}InlineLoading: View {
    public let text: String

    public init(_ text: String) {
        self.text = text
    }

    public var body: some View {
        HStack(spacing: TTSize.P_CONS_DEF) {
            {Name}LoadingSpinner(size: .small)

            Text(self.text)
                .font(.system(size: TTFont.TITLE_H, weight: .medium))
                .foregroundColor(TTView.textDefColor.toColor())
        }
    }
}

// MARK: - {Name}ShimmerEffect
public struct {Name}ShimmerEffect: ViewModifier {
    public let isActive: Bool
    public var animation: Animation = Animation.linear(duration: 1.5).repeatForever(autoreverses: false)
    public var bandSize: CGFloat = 0.3

    public init(isActive: Bool = true, animation: Animation? = nil, bandSize: CGFloat = 0.3) {
        self.isActive = isActive
        if let a = animation { self.animation = a }
        self.bandSize = bandSize
    }

    public func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.clear,
                            Color.white.opacity(0.4),
                            Color.clear
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * self.bandSize)
                    .offset(x: self.isActive ? geometry.size.width : -geometry.size.width * self.bandSize)
                    .animation(self.isActive ? self.animation : nil, value: self.isActive)
                }
                .clipped()
            )
    }
}

public extension View {
    func shimmer(isActive: Bool = true) -> some View {
        modifier({Name}ShimmerEffect(isActive: isActive))
    }
}

// MARK: - Preview
struct {Name}Loading_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: TTSize.P_XL) {
            HStack(spacing: TTSize.P_L) {
                {Name}LoadingSpinner(size: .small)
                {Name}LoadingSpinner(size: .medium)
                {Name}LoadingSpinner(size: .large)
            }

            {Name}InlineLoading("Loading data...")

            VStack(spacing: TTSize.P_CONS_DEF) {
                RoundedRectangle(cornerRadius: TTSize.CORNER_RADIUS)
                    .fill(TTView.viewBgSkeleton.toColor())
                    .frame(height: 16)
                    .shimmer()

                RoundedRectangle(cornerRadius: TTSize.CORNER_RADIUS)
                    .fill(TTView.viewBgSkeleton.toColor())
                    .frame(height: 12)
                    .shimmer()

                RoundedRectangle(cornerRadius: TTSize.CORNER_RADIUS)
                    .fill(TTView.viewBgSkeleton.toColor())
                    .frame(height: 60)
                    .shimmer()
            }
            .padding(TTSize.P_L)
            .background(TTView.viewBgCellColor.toColor())
            .clipShape(RoundedRectangle(cornerRadius: TTSize.CORNER_PANEL))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(TTView.viewBgColor.toColor())
    }
}
```

## Rules

1. **100% native SwiftUI** — no TTBaseSUI* wrappers
2. **TTBaseUIKit tokens**: `TTView.*.toColor()`, `TTSize.*`, `TTFont.*`
3. **Spinner**: `Circle().trim()` + `rotationEffect` + `.onAppear` animation
4. **Overlay**: `ZStack` with semi-transparent background + `ignoresSafeArea()`
5. **Shimmer**: `LinearGradient` overlay with `GeometryReader` + animation
6. **Accessibility**: `.accessibilityLabel("Loading")` on all loaders
7. **Inline loading**: `HStack` with spinner + text
8. **PreviewProvider** at bottom
9. **MARKER COMMENT** at top

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
