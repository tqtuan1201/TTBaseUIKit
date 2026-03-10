//
//  BaseSUISlider.swift
//  TTBaseUIKit
//
//  Created by TTBaseUIKit on 9/3/26.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import SwiftUI

/// Wraps native `Slider` with TTBaseUIKit style defaults.
/// Provides tint, optional min/max labels, and step configuration.
///
/// Usage:
/// ```swift
/// // Basic
/// TTBaseSUISlider(value: $volume)
///
/// // With range and step
/// TTBaseSUISlider(value: $brightness, in: 0...100, step: 5)
///
/// // With labels
/// TTBaseSUISlider(value: $size, in: 10...50, minLabel: "Small", maxLabel: "Large")
///
/// // Full
/// TTBaseSUISlider(value: $opacity, in: 0...1, tintColor: XView.buttonBgDef.toColor(), type: .WITH_LABELS(min: "0%", max: "100%"))
/// ```
public struct TTBaseSUISlider: View {

    // MARK: - Type

    public enum TYPE {
        case DEFAULT                                  // slider only
        case WITH_LABELS(min: String, max: String)    // min/max text labels on sides
        case WITH_VALUE                               // slider + current value display above
    }

    // MARK: - Stored Properties

    @Binding public var value: Double

    public var range: ClosedRange<Double>  = 0...1
    public var step: Double                = 0
    public var type: TYPE                  = .DEFAULT
    public var isDisabled: Bool            = false

    public var tintColor: Color            = Color(TTBaseUIKitConfig.getViewConfig().buttonBgDef)
    public var labelColor: Color           = Color(TTBaseUIKitConfig.getViewConfig().textDefColor)
    public var valueFormat: String         = "%.1f"

    // MARK: - Inits

    /// Init 1: value binding only (range 0...1)
    public init(value: Binding<Double>) {
        self._value = value
    }

    /// Init 2: value + range
    public init(value: Binding<Double>, in range: ClosedRange<Double>) {
        self._value = value
        self.range  = range
    }

    /// Init 3: value + range + step
    public init(value: Binding<Double>, in range: ClosedRange<Double>, step: Double) {
        self._value = value
        self.range  = range
        self.step   = step
    }

    /// Init 4: value + range + type (min/max labels convenience)
    public init(value: Binding<Double>, in range: ClosedRange<Double> = 0...1, minLabel: String, maxLabel: String) {
        self._value = value
        self.range  = range
        self.type   = .WITH_LABELS(min: minLabel, max: maxLabel)
    }

    /// Init 5: full
    public init(
        value: Binding<Double>,
        in range: ClosedRange<Double> = 0...1,
        step: Double = 0,
        type: TYPE = .DEFAULT,
        tintColor: Color = Color(TTBaseUIKitConfig.getViewConfig().buttonBgDef),
        labelColor: Color = Color(TTBaseUIKitConfig.getViewConfig().textDefColor),
        isDisabled: Bool = false
    ) {
        self._value      = value
        self.range       = range
        self.step        = step
        self.type        = type
        self.tintColor   = tintColor
        self.labelColor  = labelColor
        self.isDisabled  = isDisabled
    }

    // MARK: - Body

    public var body: some View {
        switch self.type {
        case .WITH_LABELS(let minLabel, let maxLabel):
            TTBaseSUIHStack(alignment: .center, spacing: TTSize.P_CONS_DEF / 2) {
                TTBaseSUIText(withType: .SUB_TITLE, text: minLabel, align: .leading, color: self.labelColor)
                    .fixedByHorizontal()
                self.buildSlider()
                    .maxWidth()
                TTBaseSUIText(withType: .SUB_TITLE, text: maxLabel, align: .trailing, color: self.labelColor)
                    .fixedByHorizontal()
            }
            .disabled(self.isDisabled)
            .opacity(self.isDisabled ? 0.5 : 1.0)

        case .WITH_VALUE:
            TTBaseSUIVStack(alignment: .center, spacing: TTSize.P_CONS_DEF / 2) {
                TTBaseSUIText(
                    withBold: .SUB_TITLE,
                    text: String(format: self.valueFormat, self.value),
                    align: .center,
                    color: self.tintColor
                )
                self.buildSlider()
            }
            .disabled(self.isDisabled)
            .opacity(self.isDisabled ? 0.5 : 1.0)

        default: // .DEFAULT
            self.buildSlider()
                .disabled(self.isDisabled)
                .opacity(self.isDisabled ? 0.5 : 1.0)
        }
    }

    // MARK: - Slider Builder

    @ViewBuilder
    private func buildSlider() -> some View {
        if self.step > 0 {
            Slider(value: self.$value, in: self.range, step: self.step)
                .accentColor(self.tintColor)
        } else {
            Slider(value: self.$value, in: self.range)
                .accentColor(self.tintColor)
        }
    }
}

// MARK: - Preview

#Preview {
    TTBaseSUIVStack(alignment: .leading, spacing: TTSize.P_CONS_DEF * 2, bg: Color.clear) {
        TTBaseSUIView(withCornerRadius: TTSize.CORNER_PANEL, bg: .white) {
            TTBaseSUIVStack(alignment: .leading, spacing: TTSize.P_CONS_DEF) {
                TTBaseSUIText(withBold: .SUB_TITLE, text: ".DEFAULT", align: .leading, color: Color(TTView.textSubTitleColor))
                TTBaseSUISlider(value: .constant(0.4))

                TTBaseSUIText(withBold: .SUB_TITLE, text: ".WITH_LABELS", align: .leading, color: Color(TTView.textSubTitleColor))
                TTBaseSUISlider(value: .constant(30), in: 0...100, minLabel: "0", maxLabel: "100")

                TTBaseSUIText(withBold: .SUB_TITLE, text: ".WITH_VALUE", align: .leading, color: Color(TTView.textSubTitleColor))
                TTBaseSUISlider(
                    value: .constant(0.65),
                    in: 0...1,
                    type: .WITH_VALUE,
                    tintColor: Color(TTView.labelBgDef)
                )

                TTBaseSUIText(withBold: .SUB_TITLE, text: "Disabled", align: .leading, color: Color(TTView.textSubTitleColor))
                TTBaseSUISlider(value: .constant(0.5), isDisabled: true)
            }
            .pAll(TTSize.P_CONS_DEF)
        }
        .pHorizontal(TTSize.P_CONS_DEF)
    }
    .pAll(TTSize.P_CONS_DEF)
    .bg(byDef: TTView.viewBgColor.toColor())
    .corner()
    .padding()
}
