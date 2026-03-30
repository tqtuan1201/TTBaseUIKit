//
//  BaseSwiftUILineDemo.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 3/8/24.
//  Copyright © 2024 Truong Quang Tuan. All rights reserved.
//

import TTBaseUIKit
import SwiftUI

struct BaseSwiftUIDividerDemo: View {
    init() {
    }
    var body: some View {
        SUIBaseViewDemo(title: "Base Divider Sample".uppercased()) {
            TTBaseSUIHStack(alignment: .center, spacing: 10) {
                TTBaseSUIVerticalDividerView(noConner: .LINE).padding()
                TTBaseSUIVerticalDividerView(withConner: 10, type: .SPACE)
                TTBaseSUIVerticalDividerView.init(withConner: 10, type: .CUSTOME(color: .random, width: 10))
                TTBaseSUIVerticalDividerView(withConner: 10, type: .SPACE)
                TTBaseSUIVerticalDividerView.init(withConner: 10, type: .CUSTOME(color: .random, width: 20))
                TTBaseSUIVerticalDividerView(withConner: 10, type: .SPACE)
                TTBaseSUIVerticalDividerView.init(withConner: 10, type: .CUSTOME(color: .random, width: 30))
            }.frame(height: 200)
        }
        .onAppear { }
    }
}

struct BaseSwiftUIDividerDemo_Previews: PreviewProvider {
    static var previews: some View {
        BaseSwiftUIDividerDemo()
    }
}
