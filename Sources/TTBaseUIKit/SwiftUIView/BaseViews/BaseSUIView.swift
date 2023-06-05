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
        TTBaseSUIView(content: {
            VStack {
                Label("sdsd", image: "ds")
                Text("Here is")
                Text("TTBaseSUIView")
            }
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
