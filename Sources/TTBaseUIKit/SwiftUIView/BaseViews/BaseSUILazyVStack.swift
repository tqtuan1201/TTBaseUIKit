//
//  SwiftUIView.swift
//  
//
//  Created by TuanTruong on 18/11/2023.
//

import SwiftUI

public struct TTBaseSUILazyVStack<Content: View>: View {
    
    public var spacing:CGFloat = TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF
    public var viewDefBgColor: Color = TTBaseUIKitConfig.getViewConfig().viewStackDefBgColor
    public var align: HorizontalAlignment = .leading
    public var viewDefCornerRadius: CGFloat = 0
    public var pinnedViews: PinnedScrollableViews = .init()
    
    public var content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public init(alignment: HorizontalAlignment = .center, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.align = alignment
    }

    public init(alignment: HorizontalAlignment = .center, spacing: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.align = alignment
        self.spacing = spacing
    }

    public init(alignment: HorizontalAlignment = .center, spacing: CGFloat, bg:Color, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.align = alignment
        self.spacing = spacing
        self.viewDefBgColor = bg
        
    }
    
    public init(alignment: HorizontalAlignment = .center, spacing: CGFloat, bg:Color, radius:CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.align = alignment
        self.spacing = spacing
        self.viewDefBgColor = bg
        self.viewDefCornerRadius = radius
    }
    
    public init(alignment: HorizontalAlignment = .center, spacing: CGFloat, bg:Color, radius:CGFloat, pinnedViews: PinnedScrollableViews, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.align = alignment
        self.spacing = spacing
        self.viewDefBgColor = bg
        self.viewDefCornerRadius = radius
        self.pinnedViews = pinnedViews
    }

    public func setupBase() -> LazyVStack<Content> {
        let current = LazyVStack(alignment: self.align, spacing: self.spacing, pinnedViews: self.pinnedViews, content: self.content)
        return current
    }
    
    
    public var body: some View {
        self.setupBase()
            .background(self.viewDefBgColor).cornerRadius(self.viewDefCornerRadius)
    }
    
}

#Preview {
    TTBaseSUIVStack(alignment: .center, spacing: 8.0, content: {
        TTBaseSUIScroll(alignment: .vertical) {
            TTBaseSUILazyVStack(alignment: .center, spacing: 10, bg: .gray, radius: 10, pinnedViews: [.sectionHeaders]) {
                Section(header: 
                    Text("Section 1 Header")
                    .maxWidth().frame(height: 50.0).bg(byDef: .red)
                ) {
                    ForEach(1...10, id: \.self) { count in
                        Text.init("Placeholder \(count)").frame(height: 140).maxWidth().bg(byDef: Color.random)
                    }
                }
            }
        }
        TTBaseSUIText(withBold: .TITLE, text: "TTBaseSUILazyVStack Preview", align: .center, color: .blue)
            .frame(height: 40)
    })
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding()
}
