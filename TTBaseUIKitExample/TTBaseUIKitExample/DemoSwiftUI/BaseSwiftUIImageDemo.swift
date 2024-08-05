//
//  BaseSwiftUIImageDemo.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 3/8/24.
//  Copyright © 2024 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
import TTBaseUIKit

struct BaseSwiftUIImageDemo: View {
    init() {
    }
    
    var body: some View {
        SUIBaseViewDemo(title: "Base TTBaseSUIImage Sample".uppercased()) {
            TTBaseSUIVStack(alignment: .center) {
                TTBaseSUIText(withBold: .TITLE, text: "TTBaseSUIImage", align: .center, color: XView.textDefColor.toColor())
                TTBaseSUIImage.init(withname: "TTBaseUIKitBg", contentMode: .fill)
                    .corner().sizeSquare(width: 200).padding(.top, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            }
        }
        .onAppear { }
    }
}

struct BaseSwiftUIImageDemo_Previews: PreviewProvider {
    static var previews: some View {
        BaseSwiftUIImageDemo()
    }
}
