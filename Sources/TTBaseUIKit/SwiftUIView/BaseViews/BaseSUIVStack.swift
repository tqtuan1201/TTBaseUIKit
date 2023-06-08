//
//  SwiftUIView.swift
//
//
//  Created by Tuan Truong Quang on 6/5/23.
//

import SwiftUI

public struct TTBaseSUIVStack<Content: View>: View {
    
    public var spacing:CGFloat = TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF
    public var viewDefBgColor: Color = TTBaseUIKitConfig.getViewConfig().viewStackDefColor
    public var viewDefCornerRadius: CGFloat = TTBaseUIKitConfig.getSizeConfig().CORNER_RADIUS
    public var align: HorizontalAlignment = .leading
     
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

    public var body: some View {
        VStack(alignment: self.align, spacing: self.spacing, content: self.content)
        .background(self.viewDefBgColor)
        .cornerRadius(self.viewDefCornerRadius)
    }
}

struct BaseSUIVStack_Previews: PreviewProvider {
    static var previews: some View {
        TTBaseSUIView(bg: .gray) {
            TTBaseSUIVStack(alignment: .center, spacing: 10, bg: .white.opacity(0.1)) {
                TTBaseSUIText(withType: .TITLE, text: "This", align: .leading, color: .white)
                TTBaseSUIText(withType: .TITLE, text: "is", align: .leading, color: .white)
                TTBaseSUIText(withType: .TITLE, text: "a", align: .leading, color: .white)
                TTBaseSUIText(withBold: .HEADER, text: "TTBaseSUIHStack", align: .center, color: .yellow)
            }.padding(.all)
        }
    }
}
