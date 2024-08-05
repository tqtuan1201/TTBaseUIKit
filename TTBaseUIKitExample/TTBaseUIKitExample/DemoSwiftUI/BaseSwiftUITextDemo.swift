//
//  BaseSwiftUITextDemo.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 2/8/24.
//  Copyright © 2024 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
import TTBaseUIKit

struct BaseSwiftUITextDemo: View {
    init() {
    }
    
    var body: some View {
        SUIBaseViewDemo(title: "Base TTBaseSUIButton Sample".uppercased()) {
            TTBaseSUIVStack(alignment: .center) {
                TTBaseSUIText(withType: .HEADER_SUPER, text: "[HEADER_SUPER] The most important thing is to enjoy your life - to be happy - it's all that matters.", align: .center)
                    .padding().bg(byDef: .gray).corner()
                TTBaseSUIText(withType: .HEADER, text: "[HEADER] The most important thing is to enjoy your life - to be happy - it's all that matters.")
                    .font(.system(size: 30))
                    .padding().bg(byDef: .black).corner()
                TTBaseSUIText(withType: .TITLE, text: "[TITLE] The most important thing is to enjoy your life - to be happy - it's all that matters.")
                    .padding().bg(byDef: .pink).corner()
                TTBaseSUIText(withType: .SUB_TITLE, text: "[SUB_TITLE] The most important thing is to enjoy your life - to be happy - it's all that matters.")
                    .padding().bg(byDef: .yellow).corner()
                TTBaseSUIText(withType: .SUB_SUB_TILE, text: "[SUB_SUB_TILE] The most important thing is to enjoy your life - to be happy - it's all that matters.")
                    .lineLimit(3)
                    .padding().bg(byDef: .gray).corner()
            }.padding()
        }
        .onAppear { }
    }
}

struct BaseSwiftUITextDemo_Previews: PreviewProvider {
    static var previews: some View {
        BaseSwiftUITextDemo()
    }
}
