//
//  BaseSwiftUIButtonDemo.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 2/8/24.
//  Copyright © 2024 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
import TTBaseUIKit

struct BaseSwiftUIButtonDemo: View {
    init() {
    }
    
    var body: some View {
        SUIBaseViewDemo(title: "Base TTBaseSUIButton Sample".uppercased()) {
            TTBaseSUIVStack(alignment: .center) {
                TTBaseSUIButton(type: .DEFAULT, title: "DEFAULT")
                TTBaseSUIButton(type: .DEFAULT_COLOR(color: .systemBlue, textColor: .white), title: "DEFAULT_COLOR")
                TTBaseSUIButton(type: .WARRING, title: "WARRING")
                TTBaseSUIButton(type: .DISABLE, title: "DISABLE")
                TTBaseSUIButton(type: .NO_BG_COLOR, title: "NO_BG_COLOR")
                TTBaseSUIButton(type: .BORDER, title: "BORDER")
            }.padding()
        }
        .onAppear { }
    }
}

struct BaseSwiftUIButtonDemo_Previews: PreviewProvider {
    static var previews: some View {
        BaseSwiftUIButtonDemo()
    }
}
