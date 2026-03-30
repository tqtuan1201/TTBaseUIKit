//
//  BaseSwiftUISkeletonScrollStackDemo.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 24/11/25.
//  Copyright © 2025 Truong Quang Tuan. All rights reserved.
//

import Foundation
import TTBaseUIKit
import SwiftUI


struct BusItemListView: View {

    var body: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: 4.0) {
            //S1 - Header Bus Name
            TTBaseSUIHStack(alignment: .top, spacing: 9.0) {
                TTBaseSUIImage(withname: "gear")
                    .frame(width: 50, height: 50, alignment: .leading)
                    .padding(.leading, 0)
                TTBaseSUIVStack(alignment: .leading, spacing: 4.0) {
                    TTBaseSUIHStack(alignment: .center, spacing: 4.0) {
                        TTBaseSUIText(withType: .TITLE, text: "Bus Name", align: .leading)
                        TTBaseSUIImage(withname: "chat").frame(width: 17, height: 17, alignment: .center)
                        TTBaseSUIText(withType: .TITLE, text: "5.0 (879)", align: .leading)
                    }
                    TTBaseSUIText(withType: .SUB_TITLE, text: "Full description", align: .leading)
                }
                Spacer()
                TTBaseSUIText(withType: .TITLE, text: "Short Date", align: .trailing)
            }
            //S2 - BodyInfo
            TTBaseSUIHStack(alignment: .center, spacing: 9.0) {
                Divider()
                TTBaseSUIVStack(alignment: .leading, spacing: 4.0) {
                    TTBaseSUIHStack(alignment: .center, spacing: 9.0) {
                        TTBaseSUIImage(withname: "chat").frame(width: 12, height: 12, alignment: .center)
                        TTBaseSUIText(withType: .TITLE, text: "Departure Information", align: .leading)
                        Spacer()
                        TTBaseSUIText(withType: .TITLE, text: "Price", align: .trailing, color: .red)
                    }
                    TTBaseSUIHStack(alignment: .center, spacing: 9.0) {
                        TTBaseSUIImage(withname: "chat").frame(width: 12, height: 12, alignment: .center)
                        TTBaseSUIText(withType: .SUB_TITLE, text: "Period time to display", align: .leading)
                        Spacer()
                    }
                    TTBaseSUIHStack(alignment: .center, spacing: 9.0) {
                        TTBaseSUIImage(withname: "chat").frame(width: 12, height: 12, alignment: .center)
                        TTBaseSUIText(withType: .TITLE, text: "Departure Information", align: .leading)
                        Spacer()
                        TTBaseSUIText(withType: .TITLE, text: "Price", align: .trailing, color: .gray)
                    }
                }
            }.padding(.leading, 20)
        }
        .padding(.top, 10.0).padding(.bottom, 10.0)
        .bg(byDef: Color.white)
        .corner()
        .baseShadow()
        .padding(.bottom, 10.0)
    }
}

struct BaseSwiftUISkeletonScrollStackDemo: View {
    
    var body: some View {
        SUIBaseViewDemo(title: "Skeleton Animation SwiftUI".uppercased()) {
            TTBaseSUIVStack(alignment: .center, spacing: 8.0, content: {
                TTBaseSUIScroll(alignment: .vertical) {
                    TTBaseSUIVStack(alignment: .center, spacing: 10.0, bg: Color.white) {
                        BusItemListView()
                            .skeleton()
                        BusItemListView()
                            .skeleton()
                        BusItemListView()
                            .skeleton()
                        BusItemListView()
                            .skeleton()
                        BusItemListView()
                            .skeleton()
                        BusItemListView()
                            .skeleton()
                        BusItemListView()
                            .skeleton()
                        BusItemListView()
                            .skeleton()
                        
                    }
                    .padding([.leading, .trailing], 10.0)
                }
                TTBaseSUIText(withBold: .TITLE, text: "BaseSwiftUISkeleton Preview", align: .center, color: .blue)
                    .frame(height: 40)
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear { }
    }
}

struct BaseSwiftUISkeletonScrollStackDemo_Previews: PreviewProvider {
    static var previews: some View {
        BaseSwiftUISkeletonScrollStackDemo()
    }
}
