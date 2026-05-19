//
//  BaseSwiftUIScrollStackDemo.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 3/8/24.
//  Copyright © 2024 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
import TTBaseUIKit

// MARK: - View
struct BaseSwiftUIScrollStackDemo: View {
    init() {}

    var body: some View {
        SUIBaseView(title: "Base Scroll + Stack Sample".uppercased()) {
            TTBaseSUIVStack(alignment: .center, spacing: XSize.P_CONS_DEF, content: {
                TTBaseSUIScroll(alignment: .vertical) {
                    TTBaseSUILazyVStack(alignment: .center, spacing: XSize.P_CONS_DEF, bg: XView.viewBgColor.toColor(), radius: XSize.CORNER_RADIUS, pinnedViews: [.sectionHeaders]) {
                        Section(header: sectionHeader) {
                            ForEach(1...10, id: \.self) { count in
                                placeholderItem(count: count)
                            }
                        }
                    }
                }
                TTBaseSUIText(withBold: .TITLE, text: "TTBaseSUILazyVStack Preview", align: .center, color: XView.buttonBgDef.toColor())
                    .frame(height: XSize.H_BUTTON)
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .pAll()
        }
        .onAppear {}
    }

    // MARK: - Subviews
    private var sectionHeader: some View {
        TTBaseSUIText(withType: .TITLE, text: "Section 1 Header", align: .center)
            .maxWidth()
            .frame(height: XSize.H_BUTTON)
            .bg(byDef: .red)
    }

    private func placeholderItem(count: Int) -> some View {
        TTBaseSUIText(withBold: .TITLE, text: "Placeholder \(count)", align: .center)
            .frame(height: 140)
            .maxWidth()
            .bg(byDef: XView.viewBgCellColor.toColor())
    }
}

struct BaseSwiftUIScrollStackDemo_Previews: PreviewProvider {
    static var previews: some View {
        BaseSwiftUIScrollStackDemo()
    }
}
