//
//  BaseSwiftUIStackDemo.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 3/8/24.
//  Copyright © 2024 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
import TTBaseUIKit

struct BaseSwiftUIStackDemo: View {
    init() {}

    var body: some View {
        SUIBaseView(title: "Base Stack Sample".uppercased()) {
            TTBaseSUIVStack(alignment: .center, spacing: XSize.P_CONS_DEF + 6) {
                vstackExample
                hstackExample
                zstackExample
            }
        }
        .onAppear {}
    }

    // MARK: - Subviews
    private var vstackExample: some View {
        TTBaseSUIView(bg: XView.viewBgCellColor.toColor()) {
            TTBaseSUIVStack(alignment: .center, spacing: XSize.P_CONS_DEF, bg: .red) {
                TTBaseSUIText(withType: .TITLE, text: "This", align: .leading, color: .white)
                TTBaseSUIText(withType: .TITLE, text: "is", align: .leading, color: .white)
                TTBaseSUIText(withType: .TITLE, text: "a", align: .leading, color: .white)
                TTBaseSUIText(withBold: .HEADER, text: "TTBaseSUIVStack", align: .center, color: .yellow)
                    .pAll()
            }.corner().pAll()
        }
    }

    private var hstackExample: some View {
        TTBaseSUIView(bg: XView.viewBgCellColor.toColor()) {
            TTBaseSUIHStack(alignment: .center, spacing: XSize.P_CONS_DEF, bg: .clear) {
                TTBaseSUIText(withType: .TITLE, text: "This", align: .leading, color: .white)
                TTBaseSUIText(withType: .TITLE, text: "is", align: .leading, color: .white)
                TTBaseSUIText(withType: .TITLE, text: "a", align: .leading, color: .white)
                TTBaseSUIText(withBold: .HEADER, text: "TTBaseSUIHStack", align: .center, color: .yellow)
            }.corner().pAll()
        }
    }

    private var zstackExample: some View {
        TTBaseSUIView(bg: XView.viewBgCellColor.toColor()) {
            TTBaseSUIZStack(alignment: .center, bg: .clear) {
                TTBaseSUIImage.init(withname: "bgView1", conner: XSize.CORNER_RADIUS)
                    .scaledToFill()
                    .frame(width: 250, height: 200, alignment: .center)
                TTBaseSUIText(withBold: .TITLE, text: "This is a TTBaseSUIZStack", align: .center, color: .white)
                    .padding(.all, XSize.P_XS)
                    .bg(byDef: .red)
                    .corner(byDef: XSize.P_XS)
            }.corner().pAll()
        }
    }
}

struct BaseSwiftUIStackDemo_Previews: PreviewProvider {
    static var previews: some View {
        BaseSwiftUIStackDemo()
    }
}
