//
//  BaseSUITextField.swift
//  TTBaseUIKit
//
//  Created by TTBaseUIKit on 9/3/26.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import SwiftUI

/// Wraps native `TextField` with TTBaseUIKit style defaults:
/// background, border, corner radius, font, and text color from config.
///
/// Usage:
/// ```swift
/// TTBaseSUITextField(placeholder: "Enter name", text: $name)
///
/// TTBaseSUITextField(placeholder: "Password", text: $password, isSecure: true)
///
/// TTBaseSUITextField(placeholder: "Search", text: $query, type: .SEARCH)
/// ```
public struct TTBaseSUITextField: View {

    // MARK: - Type

    public enum TYPE {
        case DEFAULT
        case SEARCH
        case BORDER
        case UNDERLINE
    }

    // MARK: - Stored Properties

    public var placeholder: String
    @Binding public var text: String

    public var type: TYPE                        = .DEFAULT
    public var isSecure: Bool                    = false
    public var isDisabled: Bool                  = false

    public var textColor: Color                  = Color(TTBaseUIKitConfig.getViewConfig().textDefColor)
    public var placeholderColor: Color           = Color(TTBaseUIKitConfig.getViewConfig().textDefColor).opacity(0.4)
    public var bgColor: Color                    = Color(TTBaseUIKitConfig.getViewConfig().viewDefColor)
    public var borderColor: Color                = Color(TTBaseUIKitConfig.getViewConfig().buttonBorderColor)
    public var cornerRadius: CGFloat             = TTBaseUIKitConfig.getSizeConfig().CORNER_RADIUS
    public var height: CGFloat                   = TTBaseUIKitConfig.getSizeConfig().H_TEXTFIELD
    public var fontSize: CGFloat                 = TTBaseUIKitConfig.getFontConfig().TITLE_H
    public var font: UIFont                      = TTBaseUIKitConfig.getFontConfig().FONT

    // MARK: - Inits

    /// Init 1: placeholder + binding
    public init(placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text       = text
    }

    /// Init 2: placeholder + binding + type
    public init(placeholder: String, text: Binding<String>, type: TYPE) {
        self.placeholder = placeholder
        self._text       = text
        self.type        = type
    }

    /// Init 3: placeholder + binding + isSecure
    public init(placeholder: String, text: Binding<String>, isSecure: Bool) {
        self.placeholder = placeholder
        self._text       = text
        self.isSecure    = isSecure
    }

    /// Init 4: full — placeholder + binding + type + isSecure + isDisabled
    public init(
        placeholder: String,
        text: Binding<String>,
        type: TYPE = .DEFAULT,
        isSecure: Bool = false,
        isDisabled: Bool = false
    ) {
        self.placeholder = placeholder
        self._text       = text
        self.type        = type
        self.isSecure    = isSecure
        self.isDisabled  = isDisabled
    }

    // MARK: - Body

    public var body: some View {
        switch self.type {
        case .BORDER:
            self.buildField()
                .pHorizontal(TTSize.P_CONS_DEF)
                .frame(height: self.height)
                .background(self.bgColor)
                .cornerRadius(self.cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: self.cornerRadius)
                        .stroke(self.borderColor, lineWidth: TTSize.H_LINEVIEW)
                )
                .disabled(self.isDisabled)
                .opacity(self.isDisabled ? 0.5 : 1.0)

        case .UNDERLINE:
            VStack(spacing: 0) {
                self.buildField()
                    .pHorizontal(TTSize.P_CONS_DEF / 2)
                    .frame(height: self.height)
                Color(TTBaseUIKitConfig.getViewConfig().lineDefColor)
                    .frame(height: TTSize.H_LINEVIEW)
            }
            .disabled(self.isDisabled)
            .opacity(self.isDisabled ? 0.5 : 1.0)

        case .SEARCH:
            TTBaseSUIHStack(alignment: .center, spacing: TTSize.P_CONS_DEF / 2) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(self.placeholderColor)
                    .frame(width: TTSize.H_SMALL_SMALL_ICON, height: TTSize.H_SMALL_SMALL_ICON)
                self.buildField()
            }
            .pHorizontal(TTSize.P_CONS_DEF)
            .frame(height: self.height)
            .background(self.bgColor)
            .cornerRadius(self.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: self.cornerRadius)
                    .stroke(self.borderColor, lineWidth: TTSize.H_LINEVIEW)
            )
            .disabled(self.isDisabled)
            .opacity(self.isDisabled ? 0.5 : 1.0)

        default: // .DEFAULT
            self.buildField()
                .pHorizontal(TTSize.P_CONS_DEF)
                .frame(height: self.height)
                .background(self.bgColor)
                .cornerRadius(self.cornerRadius)
                .disabled(self.isDisabled)
                .opacity(self.isDisabled ? 0.5 : 1.0)
        }
    }

    // MARK: - Build Helper

    @ViewBuilder
    private func buildField() -> some View {
        if self.isSecure {
            SecureField(self.placeholder, text: self.$text)
                .font(Font(self.font.withSize(self.fontSize)))
                .foregroundColor(self.textColor)
        } else {
            TextField(self.placeholder, text: self.$text)
                .font(Font(self.font.withSize(self.fontSize)))
                .foregroundColor(self.textColor)
        }
    }
}

// MARK: - Preview

#Preview {
    TTBaseSUIVStack(alignment: .leading, spacing: TTSize.P_CONS_DEF, bg: Color.clear) {
        TTBaseSUIText(withBold: .SUB_TITLE, text: ".DEFAULT", align: .leading, color: Color(TTView.textSubTitleColor))
        TTBaseSUITextField(placeholder: "Enter your name", text: .constant(""))
            .pHorizontal(TTSize.P_CONS_DEF)

        TTBaseSUIText(withBold: .SUB_TITLE, text: ".BORDER", align: .leading, color: Color(TTView.textSubTitleColor))
        TTBaseSUITextField(placeholder: "Email address", text: .constant("test@example.com"), type: .BORDER)
            .pHorizontal(TTSize.P_CONS_DEF)

        TTBaseSUIText(withBold: .SUB_TITLE, text: ".UNDERLINE", align: .leading, color: Color(TTView.textSubTitleColor))
        TTBaseSUITextField(placeholder: "Phone number", text: .constant(""), type: .UNDERLINE)
            .pHorizontal(TTSize.P_CONS_DEF)

        TTBaseSUIText(withBold: .SUB_TITLE, text: ".SEARCH", align: .leading, color: Color(TTView.textSubTitleColor))
        TTBaseSUITextField(placeholder: "Search...", text: .constant(""), type: .SEARCH)
            .pHorizontal(TTSize.P_CONS_DEF)

        TTBaseSUIText(withBold: .SUB_TITLE, text: ".DEFAULT secure", align: .leading, color: Color(TTView.textSubTitleColor))
        TTBaseSUITextField(placeholder: "Password", text: .constant(""), isSecure: true)
            .pHorizontal(TTSize.P_CONS_DEF)
    }
    .pAll(TTSize.P_CONS_DEF)
    .bg(byDef: TTView.viewBgColor.toColor())
    .corner()
    .padding()
}
