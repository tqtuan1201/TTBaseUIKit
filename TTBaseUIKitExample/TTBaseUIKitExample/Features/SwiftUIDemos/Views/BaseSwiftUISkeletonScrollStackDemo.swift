//
//  BaseSwiftUISkeletonScrollStackDemo.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 24/11/25.
//  Copyright © 2025 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
import TTBaseUIKit

// MARK: - BusItemListView
struct BusItemListView: View {
    var body: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: XSize.P_XS) {
            busHeader
            busBody
        }
        .pVertical(XSize.P_CONS_DEF)
        .pHorizontal(XSize.P_CONS_DEF * 2)
        .bg(byDef: .white)
        .corner()
        .baseShadow()
        .pBottom(XSize.P_CONS_DEF)
    }

    // MARK: - Subviews
    private var busHeader: some View {
        TTBaseSUIHStack(alignment: .top, spacing: XSize.P_CONS_DEF - 1) {
            TTBaseSUIImage(withname: "gear")
                .frame(width: 50, height: 50, alignment: .leading)
            TTBaseSUIVStack(alignment: .leading, spacing: XSize.P_XS) {
                TTBaseSUIHStack(alignment: .center, spacing: XSize.P_XS) {
                    TTBaseSUIText(withType: .TITLE, text: "Bus Name", align: .leading)
                    TTBaseSUIImage(withname: "chat")
                        .frame(width: 17, height: 17, alignment: .center)
                    TTBaseSUIText(withType: .TITLE, text: "5.0 (879)", align: .leading)
                }
                TTBaseSUIText(withType: .SUB_TITLE, text: "Full description", align: .leading)
            }
            TTBaseSUISpacer()
            TTBaseSUIText(withType: .TITLE, text: "Short Date", align: .trailing)
        }
    }

    private var busBody: some View {
        TTBaseSUIHStack(alignment: .center, spacing: XSize.P_CONS_DEF - 1) {
            TTBaseSUIVStack(alignment: .leading, spacing: XSize.P_XS) {
                departureRow
                periodRow
                priceRow
            }
        }
    }

    private var departureRow: some View {
        TTBaseSUIHStack(alignment: .center, spacing: XSize.P_XS) {
            TTBaseSUIImage(withname: "chat")
                .frame(width: 12, height: 12, alignment: .center)
            TTBaseSUIText(withType: .TITLE, text: "Departure Information", align: .leading)
            TTBaseSUISpacer()
            TTBaseSUIText(withType: .TITLE, text: "Price", align: .trailing, color: .red)
        }
    }

    private var periodRow: some View {
        TTBaseSUIHStack(alignment: .center, spacing: XSize.P_XS) {
            TTBaseSUIImage(withname: "chat")
                .frame(width: 12, height: 12, alignment: .center)
            TTBaseSUIText(withType: .SUB_TITLE, text: "Period time to display", align: .leading)
            TTBaseSUISpacer()
        }
    }

    private var priceRow: some View {
        TTBaseSUIHStack(alignment: .center, spacing: XSize.P_XS) {
            TTBaseSUIImage(withname: "chat")
                .frame(width: 12, height: 12, alignment: .center)
            TTBaseSUIText(withType: .TITLE, text: "Departure Information", align: .leading)
            TTBaseSUISpacer()
            TTBaseSUIText(withType: .TITLE, text: "Price", align: .trailing, color: .gray)
        }
    }
}

// MARK: - BaseSwiftUISkeletonScrollStackDemo
struct BaseSwiftUISkeletonScrollStackDemo: View {
    var body: some View {
        SUIBaseView(title: "Skeleton Animation SwiftUI".uppercased()) {
            TTBaseSUIVStack(alignment: .center, spacing: XSize.P_CONS_DEF) {
                TTBaseSUIScroll(alignment: .vertical) {
                    TTBaseSUIVStack(alignment: .center, spacing: XSize.P_CONS_DEF, bg: .white) {
                        ForEach(0..<8, id: \.self) { _ in
                            BusItemListView()
                                .skeleton()
                        }
                    }
                    .pHorizontal(XSize.P_CONS_DEF)
                }
                TTBaseSUIText(withBold: .TITLE, text: "BaseSwiftUISkeleton Preview", align: .center, color: XView.buttonBgDef.toColor())
                    .frame(height: XSize.H_BUTTON)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {}
    }
}

struct BaseSwiftUISkeletonScrollStackDemo_Previews: PreviewProvider {
    static var previews: some View {
        BaseSwiftUISkeletonScrollStackDemo()
    }
}
