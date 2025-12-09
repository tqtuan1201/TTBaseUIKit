//
//  File.swift
//  TTBaseUIKit
//
//  Created by TuanTruong on 5/9/25.
//

import Foundation
import SwiftUI

// MARK: - BaseShadow Modifier
public struct TTBaseSUIShadow: ViewModifier {
    private let color: Color
    private let radius: CGFloat
    private let x: CGFloat
    private let y: CGFloat

    public init(
        color: Color = .black.opacity(0.15), radius: CGFloat = 8, x: CGFloat = 0, y: CGFloat = 4
    ) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }

    public func body(content: Content) -> some View {
        content.shadow(color: color, radius: radius, x: x, y: y)
    }
}

// MARK: - View extension for easy reuse
public extension View {
    func baseShadow( corner:CGFloat = TTSize.CORNER_RADIUS, color: Color = .black.opacity(0.12), radius: CGFloat = 7, x: CGFloat = 0, y: CGFloat = 5
    ) -> some View {
        self.corner(byDef: TTSize.CORNER_PANEL)
        .modifier(
            TTBaseSUIShadow(color: color, radius: radius, x: x, y: y)
        )
    }
}

public extension View {
    func baseBorder( color: Color = TTView.lineDefColor.toColor(), width: CGFloat = TTSize.H_LINEVIEW, radius: CGFloat = TTSize.CORNER_RADIUS ) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: radius)
                .stroke(color, lineWidth: width)
        )
    }
}


// MARK: - Example usage
private struct ShadowDemoView: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("Default Shadow")
                .padding()
                .background(Color.white)
                .baseShadow()
            Text("Custom Shadow (Blue)")
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .baseShadow(color: .blue.opacity(0.3), radius: 12, x: 2, y: 6)
            
            // Usage
            Text("Base Border")
                .padding().background(Color.white)
                .baseBorder()

        }
        .padding()
        .background(Color.gray.opacity(0.1).ignoresSafeArea())
    }
}

#Preview {
    ShadowDemoView()
}


public struct RoundedTopCorners: Shape {
    
    public init(radius: CGFloat) {
        self.radius = radius
    }
    
    public var radius: CGFloat

    public func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + radius))
        path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.minY + radius), radius: radius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius), radius: radius, startAngle: .degrees(270), endAngle: .degrees(360), clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

public extension View {
    
    func setBorder(WithRadius cornerRadius:CGFloat = TTSize.CORNER_RADIUS, color:Color = TTView.buttonBgDef.toColor(), lineWidth:CGFloat = TTSize.H_LINEVIEW)  -> some View  {
        return self.overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(color, lineWidth: lineWidth)
        )
    }
}
