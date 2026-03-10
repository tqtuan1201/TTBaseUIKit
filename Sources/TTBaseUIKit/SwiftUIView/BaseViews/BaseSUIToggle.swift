//
//  BaseSUIToggle.swift
//  TTBaseUIKit
//
//  Created by TTBaseUIKit on 9/3/26.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import SwiftUI

/// Wraps native `Toggle` with TTBaseUIKit style defaults.
/// Supports three display types: DEFAULT (label + toggle), ICON (icon + label + toggle), LABEL_ONLY (text-only label).
///
/// Usage:
/// ```swift
/// TTBaseSUIToggle(label: "Enable notifications", isOn: $isEnabled)
///
/// TTBaseSUIToggle(label: "Dark mode", isOn: $isDark, type: .ICON(name: "moon.fill"))
///
/// TTBaseSUIToggle(label: "Agree to terms", isOn: $agreed, tintColor: XView.buttonBgDef.toColor())
/// ```
public struct TTBaseSUIToggle: View {

    // MARK: - Type

    public enum TYPE {
        case DEFAULT                          // label text + toggle
        case ICON(name: String)               // icon + label text + toggle
        case LABEL_ONLY                       // only label text (no separate icon column)
    }

    // MARK: - Stored Properties

    public var label: String
    @Binding public var isOn: Bool

    public var type: TYPE                    = .DEFAULT
    public var isDisabled: Bool              = false

    public var labelColor: Color             = Color(TTBaseUIKitConfig.getViewConfig().textDefColor)
    public var labelType: TTBaseUILabel.TYPE = .TITLE
    public var tintColor: Color              = Color(TTBaseUIKitConfig.getViewConfig().buttonBgDef)
    public var bgColor: Color               = TTBaseUIKitConfig.getViewConfig().viewStackDefBgColor
    public var cornerRadius: CGFloat        = TTBaseUIKitConfig.getSizeConfig().CORNER_RADIUS

    // MARK: - Inits

    /// Init 1: label + binding
    public init(label: String, isOn: Binding<Bool>) {
        self.label  = label
        self._isOn  = isOn
    }

    /// Init 2: label + binding + type
    public init(label: String, isOn: Binding<Bool>, type: TYPE) {
        self.label  = label
        self._isOn  = isOn
        self.type   = type
    }

    /// Init 3: label + binding + tintColor
    public init(label: String, isOn: Binding<Bool>, tintColor: Color) {
        self.label     = label
        self._isOn     = isOn
        self.tintColor = tintColor
    }

    /// Init 4: full — label + binding + type + tintColor + isDisabled
    public init(
        label: String,
        isOn: Binding<Bool>,
        type: TYPE = .DEFAULT,
        tintColor: Color = Color(TTBaseUIKitConfig.getViewConfig().buttonBgDef),
        labelColor: Color = Color(TTBaseUIKitConfig.getViewConfig().textDefColor),
        isDisabled: Bool = false
    ) {
        self.label       = label
        self._isOn       = isOn
        self.type        = type
        self.tintColor   = tintColor
        self.labelColor  = labelColor
        self.isDisabled  = isDisabled
    }

    // MARK: - Body

    public var body: some View {
        Toggle(isOn: self.$isOn) {
            self.buildLabel()
        }
        .toggleStyle(SwitchToggleStyle(tint: self.tintColor))
        .disabled(self.isDisabled)
        .opacity(self.isDisabled ? 0.5 : 1.0)
    }

    // MARK: - Label Builder

    @ViewBuilder
    private func buildLabel() -> some View {
        switch self.type {
        case .ICON(let name):
            TTBaseSUIHStack(alignment: .center, spacing: TTSize.P_CONS_DEF) {
                TTBaseSUIImage(withname: name, contentMode: .fit)
                    .setIcon(color: self.tintColor)
                    .sizeSquare(width: TTSize.H_SMALL_ICON)
                TTBaseSUIText(withType: self.labelType, text: self.label, align: .leading, color: self.labelColor)
                    .maxWidth(alignment: .leading)
            }
        default:
            TTBaseSUIText(withType: self.labelType, text: self.label, align: .leading, color: self.labelColor)
        }
    }
}

// MARK: - Preview

#Preview {
    TTBaseSUIVStack(alignment: .leading, spacing: TTSize.P_CONS_DEF, bg: Color.clear) {
        TTBaseSUIVStack(alignment: .leading, spacing: TTSize.P_CONS_DEF) {
            TTBaseSUIToggle(label: "Enable notifications", isOn: .constant(true))
            TTBaseSUIHorizontalDividerView(noConner: .LINE)
            TTBaseSUIToggle(label: "Dark mode", isOn: .constant(false), type: .ICON(name: "moon.fill"))
            TTBaseSUIHorizontalDividerView(noConner: .LINE)
            TTBaseSUIToggle(
                label: "Custom tint",
                isOn: .constant(true),
                tintColor: Color(TTView.labelBgWar)
            )
            TTBaseSUIHorizontalDividerView(noConner: .LINE)
            TTBaseSUIToggle(label: "Disabled toggle", isOn: .constant(false), isDisabled: true)
        }
        .pAll(TTSize.P_CONS_DEF)
        .pHorizontal(TTSize.P_CONS_DEF)
    }
    .pAll(TTSize.P_CONS_DEF * 2)
    .bg(byDef: TTView.viewBgColor.toColor())
    .corner()
    .padding()
}
