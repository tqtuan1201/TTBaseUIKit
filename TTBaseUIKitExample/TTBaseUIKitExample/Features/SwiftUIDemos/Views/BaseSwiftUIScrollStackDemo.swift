//
//  BaseSwiftUIStackDemo.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 3/8/24.
//  Copyright © 2024 Truong Quang Tuan. All rights reserved.
//

import TTBaseUIKit
import SwiftUI

struct BaseSwiftUIScrollStackDemo: View {
    init() {
    }
    
    var body: some View {
        SUIBaseViewDemo(title: "Base Scroll + Stack Sample".uppercased()) {
            TTBaseSUIVStack(alignment: .center, spacing: 8.0, content: {
                TTBaseSUIScroll(alignment: .vertical) {
                    TTBaseSUILazyVStack(alignment: .center, spacing: 10, bg: .gray, radius: 10, pinnedViews: [.sectionHeaders]) {
                        Section(header:
                            Text("Section 1 Header")
                            .maxWidth().frame(height: 50.0).bg(byDef: .red)
                        ) {
                            ForEach(1...10, id: \.self) { count in
                                Text.init("Placeholder \(count)").frame(height: 140).maxWidth().bg(byDef: Color.random)
                            }
                        }
                    }
                }
                TTBaseSUIText(withBold: .TITLE, text: "TTBaseSUILazyVStack Preview", align: .center, color: .blue)
                    .frame(height: 40)
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
        .onAppear { }
    }
}

struct BaseSwiftUIScrollStackDemo_Previews: PreviewProvider {
    static var previews: some View {
        BaseSwiftUIScrollStackDemo()
    }
}
