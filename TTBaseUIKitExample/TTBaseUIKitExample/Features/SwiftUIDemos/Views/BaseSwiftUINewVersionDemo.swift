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
        SUIBaseView(title: "Check new version demo".uppercased()) {
            BaseNewVersionPopupContentView()
        }
        .onAppear {}
    }
}

#Preview {
    BaseSwiftUINewVersionDemo()
}
