//
//  SwiftUIView.swift
//  
//
//  Created by Tuan Truong Quang on 6/7/23.
//

import SwiftUI

public struct TTBaseSUIZStack<Content: View>: View {
    
    public var viewDefBgColor: Color = TTBaseUIKitConfig.getViewConfig().viewStackDefBgColor
    public var viewDefCornerRadius: CGFloat = TTBaseUIKitConfig.getSizeConfig().CORNER_RADIUS
    public var align: Alignment = .center
     
    public var content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public init(alignment: Alignment = .center, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.align = alignment
    }

    public init(alignment: Alignment = .center, bg:Color, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.align = alignment
        self.viewDefBgColor = bg
    }

    public var body: some View {
        ZStack(alignment: self.align, content: self.content)
        .background(self.viewDefBgColor)
        .cornerRadius(self.viewDefCornerRadius)
    }
}

struct BaseSUIZStack_Previews: PreviewProvider {
    static var previews: some View {
        TTBaseSUIView(bg: .gray) {
            TTBaseSUIZStack(alignment: .center, bg: .clear) {
                TTBaseSUIImage()
                    .scaledToFill()
                    .frame(width: 200, height:200, alignment: .center)
                TTBaseSUIText(withBold: .TITLE, text: "This is a TTBaseSUIZStack", align: .center, color: .white).background(Color.red)
            }.padding(.all)
        }
    }
}

