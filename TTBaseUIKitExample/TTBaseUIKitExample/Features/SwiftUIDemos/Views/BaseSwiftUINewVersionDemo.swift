//
//  BaseSwiftUINewVersionDemo.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 27/11/25.
//  Copyright © 2025 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
import TTBaseUIKit

struct BaseSwiftUINewVersionDemo: View {
    var body: some View {
        SUIBaseViewDemo(title: "Check new version demo".uppercased()) {
            BaseNewVersionPopupContentView()
        }
        .ignoresSafeArea()
        .onAppear { }
    }
}

#Preview {
    BaseSwiftUINewVersionDemo()
}
