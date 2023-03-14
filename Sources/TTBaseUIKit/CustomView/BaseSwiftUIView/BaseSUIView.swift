//
//  TTBaseSUIView.swift
//  
//
//  Created by Tuan Truong Quang on 3/14/23.
//

import SwiftUI

public struct TTBaseSUIView<Content: View>: View {
    
    public var viewDefBgColor: Color = Color(TTBaseUIKitConfig.getViewConfig().viewDefColor)
    public var viewDefCornerRadius: CGFloat = TTBaseUIKitConfig.getSizeConfig().CORNER_RADIUS
    
    public let content: () -> Content
    
    public init(withCornerRadius radio:CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.viewDefCornerRadius = radio
        self.content = content
    }
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        content()
        .background(self.viewDefBgColor)
        .cornerRadius(self.viewDefCornerRadius)
    }
}

//MARK: PreviewProvider
/*
struct ContentView1212: View {
    var body: some View {
        TTBaseSUIView(withCornerRadius: 20) {
            VStack {
                Image(systemName: "star")
                Text("This is the content of MyCustomView")
            }
        }
    }
}

struct ViewBuilder_Previews: PreviewProvider {
    static var previews: some View {
        ContentView1212()
    }
}
*/
