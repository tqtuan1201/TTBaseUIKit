//
//  ButtonStyles.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-27.
//  Button styles with macOS hover support
//

import SwiftUI

// MARK: - Primary Button Style
struct TTPrimaryButtonStyle: ButtonStyle {
    var isCompact: Bool = false
    @State private var isHovered = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(isCompact ? TTFont.labelMedium : TTFont.labelLarge)
            .foregroundColor(.white)
            .padding(.horizontal, isCompact ? 12 : 20)
            .padding(.vertical, isCompact ? 6 : 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.ttPrimary)
                    .opacity(configuration.isPressed ? 0.8 : (isHovered ? 0.9 : 1.0))
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
            .animation(.easeInOut(duration: 0.15), value: isHovered)
            .onHover { isHovered = $0 }
    }
}

// MARK: - Secondary Button Style
struct TTSecondaryButtonStyle: ButtonStyle {
    var isCompact: Bool = false
    @State private var isHovered = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(isCompact ? TTFont.labelMedium : TTFont.labelLarge)
            .foregroundColor(.ttTextPrimary)
            .padding(.horizontal, isCompact ? 12 : 20)
            .padding(.vertical, isCompact ? 6 : 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isHovered ? Color.ttSurfaceHover : Color.ttSurface)
                    .opacity(configuration.isPressed ? 0.7 : 1.0)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isHovered ? Color.ttPrimary.opacity(0.5) : Color.ttBorder, lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
            .animation(.easeInOut(duration: 0.15), value: isHovered)
            .onHover { isHovered = $0 }
    }
}

// MARK: - Outlined Button Style
struct TTOutlinedButtonStyle: ButtonStyle {
    var color: Color = .ttPrimary
    var isCompact: Bool = false
    @State private var isHovered = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(isCompact ? TTFont.labelMedium : TTFont.labelLarge)
            .foregroundColor(color)
            .padding(.horizontal, isCompact ? 12 : 20)
            .padding(.vertical, isCompact ? 6 : 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(color.opacity(configuration.isPressed ? 0.15 : (isHovered ? 0.08 : 0.0)))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(color, lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
            .animation(.easeInOut(duration: 0.15), value: isHovered)
            .onHover { isHovered = $0 }
    }
}

// MARK: - Inverted Button Style
struct TTInvertedButtonStyle: ButtonStyle {
    var isCompact: Bool = false
    @State private var isHovered = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(isCompact ? TTFont.labelMedium : TTFont.labelLarge)
            .foregroundColor(.ttBackground)
            .padding(.horizontal, isCompact ? 12 : 20)
            .padding(.vertical, isCompact ? 6 : 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.ttTextPrimary)
                    .opacity(configuration.isPressed ? 0.8 : (isHovered ? 0.9 : 1.0))
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
            .animation(.easeInOut(duration: 0.15), value: isHovered)
            .onHover { isHovered = $0 }
    }
}

// MARK: - Ghost Button (Toolbar style)
struct TTGhostButtonStyle: ButtonStyle {
    @State private var isHovered = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(TTFont.labelMedium)
            .foregroundColor(configuration.isPressed ? .ttTextPrimary : (isHovered ? .ttTextPrimary : .ttTextSecondary))
            .padding(6)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(configuration.isPressed ? Color.ttSurfaceHover : (isHovered ? Color.ttSurface : Color.clear))
            )
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
            .animation(.easeInOut(duration: 0.1), value: isHovered)
            .onHover { isHovered = $0 }
    }
}

// MARK: - Sidebar Item Button Style
struct TTSidebarItemStyle: ButtonStyle {
    var isSelected: Bool = false
    @State private var isHovered = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(TTFont.sidebarItem)
            .foregroundColor(isSelected ? .ttPrimary : .ttTextSecondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected
                        ? Color.ttPrimary.opacity(0.12)
                        : (configuration.isPressed
                            ? Color.ttSurfaceHover
                            : (isHovered ? Color.ttSurface.opacity(0.6) : Color.clear)))
            )
            .animation(.easeInOut(duration: 0.15), value: isSelected)
            .animation(.easeInOut(duration: 0.1), value: isHovered)
            .onHover { isHovered = $0 }
    }
}

// MARK: - Button Style Extensions
extension ButtonStyle where Self == TTPrimaryButtonStyle {
    static var ttPrimary: TTPrimaryButtonStyle { TTPrimaryButtonStyle() }
    static var ttPrimaryCompact: TTPrimaryButtonStyle { TTPrimaryButtonStyle(isCompact: true) }
}

extension ButtonStyle where Self == TTSecondaryButtonStyle {
    static var ttSecondary: TTSecondaryButtonStyle { TTSecondaryButtonStyle() }
    static var ttSecondaryCompact: TTSecondaryButtonStyle { TTSecondaryButtonStyle(isCompact: true) }
}

extension ButtonStyle where Self == TTOutlinedButtonStyle {
    static var ttOutlined: TTOutlinedButtonStyle { TTOutlinedButtonStyle() }
}

extension ButtonStyle where Self == TTInvertedButtonStyle {
    static var ttInverted: TTInvertedButtonStyle { TTInvertedButtonStyle() }
}

extension ButtonStyle where Self == TTGhostButtonStyle {
    static var ttGhost: TTGhostButtonStyle { TTGhostButtonStyle() }
}
