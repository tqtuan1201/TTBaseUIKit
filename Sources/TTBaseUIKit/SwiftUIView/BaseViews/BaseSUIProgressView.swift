//
//  BaseSUIProgressView.swift
//  TTBaseUIKit
//
//  Created by TTBaseUIKit on 9/3/26.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import SwiftUI

/// Wraps native `ProgressView` with TTBaseUIKit style defaults.
/// Supports indeterminate spinner, linear determinate bar, and a custom circular ring variant.
///
/// Usage:
/// ```swift
/// // Indeterminate spinner
/// TTBaseSUIProgressView()
///
/// // Linear progress bar (0.0 → 1.0)
/// TTBaseSUIProgressView(value: 0.6)
///
/// // Linear with label
/// TTBaseSUIProgressView(value: 0.6, label: "Uploading…")
///
/// // Circular ring
/// TTBaseSUIProgressView(value: 0.75, type: .CIRCULAR)
/// ```
public struct TTBaseSUIProgressView: View {

    // MARK: - Type

    public enum TYPE {
        case INDETERMINATE          // spinner — no value needed
        case LINEAR                 // native ProgressView linear bar
        case CIRCULAR               // custom ring drawn with SwiftUI shapes
    }

    // MARK: - Stored Properties

    public var value: Double?                = nil      // nil → indeterminate
    public var total: Double                 = 1.0
    public var type: TYPE                    = .INDETERMINATE

    public var label: String?                = nil
    public var tintColor: Color              = Color(TTBaseUIKitConfig.getViewConfig().buttonBgDef)
    public var trackColor: Color             = Color(TTBaseUIKitConfig.getViewConfig().viewDisableColor).opacity(0.3)
    public var labelColor: Color             = Color(TTBaseUIKitConfig.getViewConfig().textDefColor)
    public var lineWidth: CGFloat            = 6.0
    public var circularSize: CGFloat         = TTBaseUIKitConfig.getSizeConfig().H_ICON

    // MARK: - Inits

    /// Init 1: indeterminate spinner
    public init() {
        self.type = .INDETERMINATE
    }

    /// Init 2: linear with value
    public init(value: Double) {
        self.value = value
        self.type  = .LINEAR
    }

    /// Init 3: linear with value + label
    public init(value: Double, label: String) {
        self.value = value
        self.label = label
        self.type  = .LINEAR
    }

    /// Init 4: explicit type + value
    public init(value: Double?, type: TYPE) {
        self.value = value
        self.type  = type
    }

    /// Init 5: full
    public init(
        value: Double? = nil,
        total: Double = 1.0,
        type: TYPE = .INDETERMINATE,
        label: String? = nil,
        tintColor: Color = Color(TTBaseUIKitConfig.getViewConfig().buttonBgDef),
        trackColor: Color = Color(TTBaseUIKitConfig.getViewConfig().viewDisableColor).opacity(0.3),
        labelColor: Color = Color(TTBaseUIKitConfig.getViewConfig().textDefColor),
        lineWidth: CGFloat = 6.0,
        circularSize: CGFloat = TTBaseUIKitConfig.getSizeConfig().H_ICON
    ) {
        self.value        = value
        self.total        = total
        self.type         = type
        self.label        = label
        self.tintColor    = tintColor
        self.trackColor   = trackColor
        self.labelColor   = labelColor
        self.lineWidth    = lineWidth
        self.circularSize = circularSize
    }

    // MARK: - Body

    public var body: some View {
        switch self.type {
        case .INDETERMINATE:
            self.buildIndeterminate()

        case .LINEAR:
            self.buildLinear()

        case .CIRCULAR:
            self.buildCircular()
        }
    }

    // MARK: - Builders

    @ViewBuilder
    private func buildIndeterminate() -> some View {
        if let labelText = self.label {
            TTBaseSUIVStack(alignment: .center, spacing: TTSize.P_CONS_DEF) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: self.tintColor))
                TTBaseSUIText(withType: .SUB_TITLE, text: labelText, align: .center, color: self.labelColor)
            }
        } else {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: self.tintColor))
        }
    }

    @ViewBuilder
    private func buildLinear() -> some View {
        let progressValue = self.value ?? 0.0
        TTBaseSUIVStack(alignment: .leading, spacing: TTSize.P_CONS_DEF / 2) {
            if let labelText = self.label {
                TTBaseSUIHStack(alignment: .center, spacing: TTSize.P_CONS_DEF / 2) {
                    TTBaseSUIText(withType: .SUB_TITLE, text: labelText, align: .leading, color: self.labelColor)
                        .maxWidth(alignment: .leading)
                    TTBaseSUIText(
                        withBold: .SUB_TITLE,
                        text: "\(Int((progressValue / self.total) * 100))%",
                        align: .trailing,
                        color: self.tintColor
                    )
                    .fixedByHorizontal()
                }
            }
            ProgressView(value: progressValue, total: self.total)
                .progressViewStyle(LinearProgressViewStyle(tint: self.tintColor))
                .accentColor(self.tintColor)
        }
    }

    @ViewBuilder
    private func buildCircular() -> some View {
        let progress = (self.value ?? 0.0) / self.total
        ZStack {
            // Track
            Circle()
                .stroke(self.trackColor, lineWidth: self.lineWidth)
                .frame(width: self.circularSize, height: self.circularSize)
            // Progress arc
            Circle()
                .trim(from: 0, to: CGFloat(progress))
                .stroke(self.tintColor, style: StrokeStyle(lineWidth: self.lineWidth, lineCap: .round))
                .frame(width: self.circularSize, height: self.circularSize)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.4), value: progress)
            // Center label
            if let labelText = self.label {
                TTBaseSUIText(withBold: .SUB_TITLE, text: labelText, align: .center, color: self.tintColor)
            } else {
                TTBaseSUIText(
                    withBold: .SUB_TITLE,
                    text: "\(Int(progress * 100))%",
                    align: .center,
                    color: self.tintColor
                )
            }
        }
    }
}

// MARK: - Preview

#Preview {
    TTBaseSUIVStack(alignment: .leading, spacing: TTSize.P_CONS_DEF * 2, bg: Color.clear) {
        TTBaseSUIView(withCornerRadius: TTSize.CORNER_PANEL, bg: .white) {
            TTBaseSUIVStack(alignment: .leading, spacing: TTSize.P_CONS_DEF * 1.5) {
                TTBaseSUIText(withBold: .SUB_TITLE, text: ".INDETERMINATE", align: .leading, color: Color(TTView.textSubTitleColor))
                TTBaseSUIProgressView()

                TTBaseSUIText(withBold: .SUB_TITLE, text: ".LINEAR", align: .leading, color: Color(TTView.textSubTitleColor))
                TTBaseSUIProgressView(value: 0.65)

                TTBaseSUIText(withBold: .SUB_TITLE, text: ".LINEAR with label", align: .leading, color: Color(TTView.textSubTitleColor))
                TTBaseSUIProgressView(value: 0.4, label: "Uploading…")

                TTBaseSUIText(withBold: .SUB_TITLE, text: ".CIRCULAR", align: .center, color: Color(TTView.textSubTitleColor))
                    .maxWidth()
                TTBaseSUIProgressView(value: 0.75, type: .CIRCULAR)
                    .maxWidth()
            }
            .pAll(TTSize.P_CONS_DEF)
        }
        .pHorizontal(TTSize.P_CONS_DEF)
    }
    .pAll(TTSize.P_CONS_DEF * 2)
    .bg(byDef: TTView.viewBgColor.toColor())
    .corner()
    .padding()
}
