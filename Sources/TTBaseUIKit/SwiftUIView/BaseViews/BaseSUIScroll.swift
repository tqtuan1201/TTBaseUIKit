//
//  SwiftUIView.swift
//  
//
//  Created by TuanTruong on 18/11/2023.
//

import SwiftUI

public struct TTBaseSUIScroll<Content: View>: View {
    
    public var viewDefBgColor: Color = TTBaseUIKitConfig.getViewConfig().viewScrollDefBgColor
    public var viewDefCornerRadius: CGFloat = 0.0
    public var align: Axis.Set = .vertical
    public var showIndicators: Bool = false
    
    public var content: () -> Content
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public init(alignment: Axis.Set, showIndicators:Bool = false, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.align = alignment
        self.showIndicators = showIndicators
    }
    
    public init(alignment: Axis.Set, bg:Color, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.align = alignment
        self.viewDefBgColor = bg
    }
    
    public init(alignment: Axis.Set, bg:Color, cornerRadius:CGFloat, showIndicators:Bool, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.align = alignment
        self.viewDefBgColor = bg
        self.viewDefCornerRadius = cornerRadius
        self.showIndicators = showIndicators
    }
    
    public var body: some View {
        
        if #available(iOS 16.0, *) {
            self.setupBase()
                .scrollIndicators(self.showIndicators ? .visible : .hidden, axes: self.align)
                .background(self.viewDefBgColor)
                .cornerRadius(self.viewDefCornerRadius)
        } else {
            self.setupBase()
                .background(self.viewDefBgColor)
                .cornerRadius(self.viewDefCornerRadius)
        }
    }
    
    public func setupBase() -> ScrollView<Content> {
        let current = ScrollView(self.align, content: self.content)
        return current
    }
    
}

#Preview {
    TTBaseSUIVStack(alignment: .center, spacing: 8.0, content: {
        TTBaseSUIScroll.init(alignment: .vertical, bg: .red, cornerRadius: 8.0, showIndicators: true) {
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 8.0, content: {
                VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                    ForEach(1...10, id: \.self) { count in
                        Text.init("Placeholder \(count)").frame(height: 140).maxWidth().bg(byDef: Color.random)
                    }
                })
            })
        }
        TTBaseSUIText(withBold: .TITLE, text: "TTBaseSUIScroll Preview", align: .center, color: .blue)
            .frame(height: 40)
    })
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding()
}

