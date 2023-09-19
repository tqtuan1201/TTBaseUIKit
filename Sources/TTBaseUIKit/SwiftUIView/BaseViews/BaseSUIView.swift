//
//  TTBaseSUIView.swift
//  
//  Created by Tuan Truong Quang on 3/14/23.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import SwiftUI

public struct TTBaseSUIView<Content: View>: View {
    
    public var viewDefBgColor: Color = Color(TTBaseUIKitConfig.getViewConfig().viewDefColor)
    public var viewDefCornerRadius: CGFloat = TTBaseUIKitConfig.getSizeConfig().CORNER_RADIUS
    
    public let content: (() -> Content)
    
    public init(withCornerRadius radio:CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.viewDefCornerRadius = radio
        self.content = content
    }
    
    public init(withCornerRadius radio:CGFloat = TTBaseUIKitConfig.getSizeConfig().CORNER_RADIUS,
                bg:Color = Color(TTBaseUIKitConfig.getViewConfig().viewDefColor),
                @ViewBuilder content: @escaping () -> Content) {
        self.viewDefCornerRadius = radio
        self.viewDefBgColor = bg
        self.content = content
    }
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        self.content()
        .background(self.viewDefBgColor)
        .cornerRadius(self.viewDefCornerRadius)
    }
}

//MARK: Previews
 fileprivate struct DemoBaseSUIView: View {
    var body: some View {
        TTBaseSUIView(withCornerRadius: 4, bg: .red, content: {
            VStack {
                TTBaseSUIText(withType: .TITLE, text: "Here is", align: .center, color: .white)
                TTBaseSUIText(withType: .HEADER, text: "TTBaseSUIView", align: .center, color: .white)
            }.padding()
        })
        .padding()
        .background(Color.gray)
    }
}

struct DemoBaseSUIView_Previews: PreviewProvider {
    static var previews: some View {
        DemoBaseSUIView()
    }
}
