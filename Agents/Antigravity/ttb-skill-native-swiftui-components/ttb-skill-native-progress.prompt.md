---
description: "Build native SwiftUI progress components: linear progress bar, circular progress, skeleton loader. 100% standard SwiftUI with TTBaseUIKit tokens."
---

# ttb-skill-native-progress — Native SwiftUI Progress Component Builder

Build reusable progress native SwiftUI components using TTBaseUIKit design tokens.

## When

User says: "native progress", "progress bar", "loading", "skeleton", "circular progress", "percentage"

## Progress Component Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  Components/Progress/{Name}Progress.swift
//  {AppName}
//

import SwiftUI
import TTBaseUIKit

// MARK: - {Name}LinearProgressBar
public struct {Name}LinearProgressBar: View {
    public let progress: Double
    public var trackColor: Color = TTView.viewDisableColor.toColor().opacity(0.3)
    public var progressColor: Color = TTView.buttonBgDef.toColor()
    public var height: CGFloat = 6
    public var showLabel: Bool = false
    public var labelPosition: LabelPosition = .trailing

    public enum LabelPosition { case leading, trailing }

    public init(
        progress: Double,
        trackColor: Color? = nil,
        progressColor: Color? = nil,
        height: CGFloat = 6,
        showLabel: Bool = false,
        labelPosition: LabelPosition = .trailing
    ) {
        self.progress = progress
        if let tc = trackColor { self.trackColor = tc }
        if let pc = progressColor { self.progressColor = pc }
        self.height = height
        self.showLabel = showLabel
        self.labelPosition = labelPosition
    }

    public var body: some View {
        if self.showLabel {
            HStack(spacing: TTSize.P_CONS_DEF) {
                if self.labelPosition == .leading {
                    self.percentageLabel
                }
                self.progressBar
                if self.labelPosition == .trailing {
                    self.percentageLabel
                }
            }
        } else {
            self.progressBar
        }
    }

    private var percentageLabel: some View {
        Text("\(Int(self.progress * 100))%")
            .font(.system(size: TTFont.SUB_TITLE_H, weight: .semibold))
            .foregroundColor(TTView.textDefColor.toColor())
            .frame(minWidth: 40, alignment: self.labelPosition == .leading ? .leading : .trailing)
    }

    private var progressBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: self.height / 2)
                    .fill(self.trackColor)
                    .frame(height: self.height)

                RoundedRectangle(cornerRadius: self.height / 2)
                    .fill(self.progressColor)
                    .frame(width: max(0, geometry.size.width * CGFloat(min(1, max(0, self.progress)))), height: self.height)
                    .animation(.easeInOut(duration: 0.3), value: self.progress)
            }
        }
        .frame(height: self.height)
        .accessibilityLabel("\(Int(self.progress * 100)) percent complete")
    }
}

// MARK: - {Name}CircularProgress
public struct {Name}CircularProgress: View {
    public let progress: Double
    public var size: CGFloat = 60
    public var lineWidth: CGFloat = 6
    public var trackColor: Color = TTView.viewDisableColor.toColor().opacity(0.3)
    public var progressColor: Color = TTView.buttonBgDef.toColor()
    public var showPercentage: Bool = true

    public init(
        progress: Double,
        size: CGFloat = 60,
        lineWidth: CGFloat = 6,
        trackColor: Color? = nil,
        progressColor: Color? = nil,
        showPercentage: Bool = true
    ) {
        self.progress = progress
        self.size = size
        self.lineWidth = lineWidth
        if let tc = trackColor { self.trackColor = tc }
        if let pc = progressColor { self.progressColor = pc }
        self.showPercentage = showPercentage
    }

    public var body: some View {
        ZStack {
            Circle()
                .stroke(self.trackColor, lineWidth: self.lineWidth)

            Circle()
                .trim(from: 0, to: CGFloat(min(1, max(0, self.progress))))
                .stroke(self.progressColor, style: StrokeStyle(lineWidth: self.lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.3), value: self.progress)

            if self.showPercentage {
                Text("\(Int(self.progress * 100))%")
                    .font(.system(size: TTFont.SUB_TITLE_H, weight: .semibold))
                    .foregroundColor(TTView.textDefColor.toColor())
            }
        }
        .frame(width: self.size, height: self.size)
        .accessibilityLabel("\(Int(self.progress * 100)) percent complete")
    }
}

// MARK: - {Name}SkeletonLoader
public struct {Name}SkeletonLoader: View {
    public enum Shape {
        case rectangle
        case circle
        case rounded(cornerRadius: CGFloat)

        var cornerRadius: CGFloat {
            switch self {
            case .rectangle: return 0
            case .circle: return .infinity
            case .rounded(let r): return r
            }
        }
    }

    public let width: CGFloat?
    public let height: CGFloat
    public var shape: Shape = .rounded(TTSize.CORNER_RADIUS)
    public var isShimmering: Bool = true

    public init(width: CGFloat? = nil, height: CGFloat, shape: Shape = .rounded(TTSize.CORNER_RADIUS), isShimmering: Bool = true) {
        self.width = width
        self.height = height
        self.shape = shape
        self.isShimmering = isShimmering
    }

    private var skeletonView: some View {
        Rectangle()
            .fill(TTView.viewBgSkeleton.toColor())
            .clipShape(RoundedRectangle(cornerRadius: self.shape.cornerRadius))
    }

    public var body: some View {
        Group {
            if self.isShimmering {
                self.skeletonView
                    .shimmering()
            } else {
                self.skeletonView
            }
        }
        .frame(width: self.width, height: self.height)
        .frame(maxWidth: self.width == nil ? .infinity : nil)
    }
}

// MARK: - Preview
struct {Name}Progress_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: TTSize.P_XL) {
            {Name}LinearProgressBar(progress: 0.65, showLabel: true)

            {Name}LinearProgressBar(progress: 0.3, progressColor: TTView.colorError.toColor(), height: 10)

            HStack(spacing: TTSize.P_L) {
                {Name}CircularProgress(progress: 0.75)
                {Name}CircularProgress(progress: 0.5, size: 48, lineWidth: 4, progressColor: TTView.colorWarning.toColor())
                {Name}CircularProgress(progress: 0.25, size: 40, lineWidth: 3)
            }

            VStack(alignment: .leading, spacing: TTSize.P_CONS_DEF) {
                {Name}SkeletonLoader(width: 200, height: 16)
                {Name}SkeletonLoader(width: 150, height: 12)
                {Name}SkeletonLoader(height: 60, shape: .rounded(TTSize.CORNER_PANEL))
            }
        }
        .padding(TTSize.P_L)
        .background(TTView.viewBgColor.toColor())
    }
}
```

## Rules

1. **100% native SwiftUI** — no TTBaseSUI* wrappers
2. **TTBaseUIKit tokens**: `TTView.*.toColor()`, `TTSize.*`, `TTFont.*`
3. **Linear progress**: GeometryReader for responsive width, rounded caps
4. **Circular progress**: `trim(from:to:)` with `.rotationEffect(.degrees(-90))`
5. **Skeleton**: use `.shimmering()` modifier from TTBaseUIKit
6. **Animation**: `.easeInOut(duration: 0.3)` on progress changes
7. **Clamp progress**: `min(1, max(0, progress))`
8. **Accessibility**: `.accessibilityLabel()` with percentage
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
