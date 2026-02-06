//
//  View+LiquidGlass+Extension.swift
//  TTBaseUIKit
//
//  Created by TuanTruong on 6/2/26.
//

import Foundation
import SwiftUI


public struct WhiteLiquidGlassBackground: View {
    public let cornerRadius: CGFloat
    
    public init(cornerRadius: CGFloat) {
        self.cornerRadius = cornerRadius
    }
    
    public var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        // Base blur
            .fill(.white).opacity(0.82)
        // White frosted tint
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Color.white.opacity(0.18))
            )
        // Light highlight stroke (top-left → bottom-right)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.6),
                                Color.white.opacity(0.25),
                                Color.white.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
    }
}

@available(iOS 15.0, *)
public struct BlackLiquidGlassBackground: View {
    public let cornerRadius: CGFloat
    
    public init(cornerRadius: CGFloat) {
        self.cornerRadius = cornerRadius
    }
    
    public var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(.ultraThinMaterial)
            .overlay(
                // Highlight viền trên (fake light refraction)
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.45),
                                Color.white.opacity(0.1),
                                Color.clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .overlay(
                // Tint rất nhẹ như Apple
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Color.white.opacity(0.04))
            )
    }
}


public extension View {
    
    @ViewBuilder func enableGlassEffectV2<Content>(isClear:Bool = false, cornerRadius:CGFloat? = nil, @ViewBuilder content: () -> Content, align:Alignment = .center) -> some View where Content : View {
#if compiler(>=6.2)
        if #available(iOS 26.0, *) {
            if let _cornerRadius = cornerRadius {
                self.glassEffect( isClear ? Glass.clear.interactive() : Glass.regular.interactive(), in: .rect(cornerRadius: _cornerRadius))
            } else {
                self.glassEffect( isClear ? Glass.clear.interactive() : Glass.regular.interactive(),in: .containerRelative)
            }
        } else {
            if #available(iOS 15.0, *) {
                self.background(alignment: align, content: content)
            } else {
                self.background( content() )
            }
        }
#else
        if #available(iOS 15.0, *) {
            self.background(alignment: align, content: content)
        } else {
            self.background( content() )
        }
#endif
    }
    
    //Old -> need to check end update !!!!!
    @ViewBuilder func enableGlassEffect<Content>(cornerRadius:CGFloat? = nil, @ViewBuilder content: () -> Content, align:Alignment = .center) -> some View where Content : View {
#if compiler(>=6.2)
        if #available(iOS 26.0, *) {
            if let _cornerRadius = cornerRadius {
                self.corner(byDef: _cornerRadius).glassEffect(Glass.clear, in: RoundedRectangle(cornerRadius:_cornerRadius))
            } else {
                self.glassEffect(Glass.clear)
            }
        } else {
            if #available(iOS 15.0, *) {
                self.background(alignment: align, content: content)
            } else {
                self.background( content() )
            }
        }
#else
        if #available(iOS 15.0, *) {
            self.background(alignment: align, content: content)
        } else {
            self.background( content() )
        }
#endif
    }
    
    
    
    
}
