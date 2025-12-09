//
//  TTBaseSUILazyVGrid.swift
//  TTBaseUIKitSwiftPMExample
//
//  Created by TuanTruong on 5/9/25.
//  Copyright © 2025 Truong Quang Tuan. All rights reserved.
//

import Foundation
import SwiftUI

public struct TTBaseSUILazyVGrid<Content: View>: View {
    
    // MARK: - Configurable Properties
    public var columns: [GridItem]
    public var spacing: CGFloat = TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF
    public var viewDefBgColor: Color = TTBaseUIKitConfig.getViewConfig().viewStackDefBgColor
    public var viewDefCornerRadius: CGFloat = 0
    public var pinnedViews: PinnedScrollableViews = .init()
    
    public let content: () -> Content
    
    // MARK: - Initializers
    public init(columns: [GridItem],
                @ViewBuilder content: @escaping () -> Content) {
        self.columns = columns
        self.content = content
    }
    
    public init(columns: [GridItem],
                spacing: CGFloat,
                @ViewBuilder content: @escaping () -> Content) {
        self.columns = columns
        self.spacing = spacing
        self.content = content
    }
    
    public init(columns: [GridItem],
                spacing: CGFloat,
                bg: Color,
                @ViewBuilder content: @escaping () -> Content) {
        self.columns = columns
        self.spacing = spacing
        self.viewDefBgColor = bg
        self.content = content
    }
    
    public init(columns: [GridItem],
                spacing: CGFloat,
                bg: Color,
                radius: CGFloat,
                @ViewBuilder content: @escaping () -> Content) {
        self.columns = columns
        self.spacing = spacing
        self.viewDefBgColor = bg
        self.viewDefCornerRadius = radius
        self.content = content
    }
    
    public init(columns: [GridItem],
                spacing: CGFloat,
                bg: Color,
                radius: CGFloat,
                pinnedViews: PinnedScrollableViews,
                @ViewBuilder content: @escaping () -> Content) {
        self.columns = columns
        self.spacing = spacing
        self.viewDefBgColor = bg
        self.viewDefCornerRadius = radius
        self.pinnedViews = pinnedViews
        self.content = content
    }
    
    // MARK: - Setup base
    public func setupBase() -> LazyVGrid<Content> {
        LazyVGrid(columns: self.columns,
                  alignment: .center,
                  spacing: self.spacing,
                  pinnedViews: self.pinnedViews,
                  content: self.content)
    }
    
    // MARK: - Body
    public var body: some View {
        self.setupBase()
            .background(self.viewDefBgColor)
            .cornerRadius(self.viewDefCornerRadius)
    }
}

private struct DemoGrid: View {
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            TTBaseSUILazyVGrid(columns: columns,
                               spacing: 16,
                               bg: .white,
                               radius: 12) {
                ForEach(0..<10, id: \.self) { i in
                    Text("Item \(i)")
                        .frame(maxWidth: .infinity, minHeight: 80)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}

struct DemoTTBaseSUILazyVGrid_Previews: PreviewProvider {
    static var previews: some View {
        DemoGrid()
    }
}

