//
//  BaseSwiftUISpacerDemo.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 3/8/24.
//  Copyright © 2024 Truong Quang Tuan. All rights reserved.
//

import TTBaseUIKit
import SwiftUI

struct BaseSwiftUISpacerDemo: View {
    init() {
    }
    
    var body: some View {
        SUIBaseViewDemo(title: "Base Spacer Sample".uppercased()) {
            TTBaseSUIVStack(alignment: .center, spacing: 10) {
                TTBaseSUIVStack(alignment: .center, spacing: 10) {
                    Text("Top View").padding().background(Color.pink).cornerRadius(8.0)
                    TTBaseSUISpacer(withBg: .green.opacity(0.2), radius: 8.0) // Expands to fill available space
                }
                TTBaseSUIHStack(alignment: .center, spacing: 10) {
                    TTBaseSUISpacer(withBg: .green.opacity(0.2), radius: 8.0) // Expands to fill available space
                    Text("Center View").padding().background(Color.pink).cornerRadius(8.0)
                }
                TTBaseSUIHStack(alignment: .center, spacing: 10) {
                    Text("Bottom View").padding().background(Color.pink).cornerRadius(8.0)
                    TTBaseSUISpacer(withBg: .green.opacity(0.3), radius: 8.0) // Expands to fill available space
                    TTBaseSUISpacer(withBg: .blue.opacity(0.3), radius: 8.0, maxWidth: 20.0)
                    TTBaseSUISpacer(withBg: .red.opacity(0.3), radius: 8.0) // Expands to fill available space
                }
            }.padding(/*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        }
        .onAppear { }
    }
}

struct BaseSwiftUISpacerDemo_Previews: PreviewProvider {
    static var previews: some View {
        BaseSwiftUISpacerDemo()
    }
}
