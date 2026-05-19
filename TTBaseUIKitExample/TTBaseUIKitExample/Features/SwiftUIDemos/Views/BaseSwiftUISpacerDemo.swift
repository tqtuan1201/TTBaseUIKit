//
//  BaseSwiftUISpacerDemo.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 3/8/24.
//  Copyright © 2024 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
import TTBaseUIKit

struct BaseSwiftUISpacerDemo: View {
    init() {}

    var body: some View {
        SUIBaseView(title: "Base Spacer Sample".uppercased()) {
            TTBaseSUIVStack(alignment: .center, spacing: XSize.P_CONS_DEF) {
                TTBaseSUIVStack(alignment: .center, spacing: XSize.P_CONS_DEF) {
                    TTBaseSUIText(withType: .TITLE, text: "Top View", align: .center)
                        .pAll().bg(byDef: .pink).corner(byDef: XSize.P_S)
                    TTBaseSUISpacer(withBg: XView.viewBgColor.toColor().opacity(0.2), radius: XSize.P_S)
                }
                TTBaseSUIHStack(alignment: .center, spacing: XSize.P_CONS_DEF) {
                    TTBaseSUISpacer(withBg: XView.viewBgColor.toColor().opacity(0.2), radius: XSize.P_S)
                    TTBaseSUIText(withType: .TITLE, text: "Center View", align: .center)
                        .pAll().bg(byDef: .pink).corner(byDef: XSize.P_S)
                }
                TTBaseSUIHStack(alignment: .center, spacing: XSize.P_CONS_DEF) {
                    TTBaseSUIText(withType: .TITLE, text: "Bottom View", align: .center)
                        .pAll().bg(byDef: .pink).corner(byDef: XSize.P_S)
                    TTBaseSUISpacer(withBg: XView.viewBgColor.toColor().opacity(0.3), radius: XSize.P_S)
                    TTBaseSUISpacer(withBg: XView.viewBgColor.toColor().opacity(0.3), radius: XSize.P_S, maxWidth: XSize.P_CONS_DEF * 2)
                    TTBaseSUISpacer(withBg: XView.viewBgColor.toColor().opacity(0.3), radius: XSize.P_S)
                }
            }.pAll(XSize.P_CONS_DEF)
        }
        .onAppear {}
    }
}

struct BaseSwiftUISpacerDemo_Previews: PreviewProvider {
    static var previews: some View {
        BaseSwiftUISpacerDemo()
    }
}
