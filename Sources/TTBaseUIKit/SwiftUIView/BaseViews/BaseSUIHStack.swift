//
//  SwiftUIView.swift
//  
//
//  Created by Tuan Truong Quang on 6/5/23.
//

import SwiftUI
/*
struct CustomText<Content: View>: View {
private let content: String
private let transform: (Text) -> Content

init(_ content: String, transform: @escaping (Text) -> Content) {
self.content = content
self.transform = transform
}

var body: some View {
// Apply whatever modifiers from environment, etc.
let current = Text(content)
/* ... */

return transform(current)
}
}
*/

public struct TTBaseSUIHStack<Content: View>: View {
    
    public var spacing:CGFloat = TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF
    public var viewDefBgColor: Color = TTBaseUIKitConfig.getViewConfig().viewStackDefColor
    public var align: VerticalAlignment = .center
     
    public var content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public init(alignment: VerticalAlignment = .center, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.align = alignment
    }

    public init(alignment: VerticalAlignment = .center, spacing: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.align = alignment
        self.spacing = spacing
    }

    public init(alignment: VerticalAlignment = .center, spacing: CGFloat, bg:Color, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.align = alignment
        self.spacing = spacing
        self.viewDefBgColor = bg
    }

    public var body: some View {
        HStack(alignment: self.align, spacing: self.spacing, content: self.content)
        .background(self.viewDefBgColor)
    }
}

extension TTBaseSUIHStack {
    public func setCorner(radius:CGFloat) ->  some View {
        return self.body.cornerRadius(radius)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        TTBaseSUIView(bg: .gray) {
            TTBaseSUIHStack(alignment: .center, spacing: 10, bg: .clear) {
                TTBaseSUIText(withType: .TITLE, text: "This", align: .leading, color: .white)
                TTBaseSUIText(withType: .TITLE, text: "is", align: .leading, color: .white)
                TTBaseSUIText(withType: .TITLE, text: "a", align: .leading, color: .white)
                TTBaseSUIText(withBold: .HEADER, text: "TTBaseSUIHStack", align: .center, color: .yellow)
            }.padding(.all)
        }
    }
}
