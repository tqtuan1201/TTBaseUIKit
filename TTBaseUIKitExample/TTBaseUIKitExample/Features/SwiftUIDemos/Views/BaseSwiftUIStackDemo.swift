//
//  BaseSwiftUIStackDemo.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 3/8/24.
//  Copyright © 2024 Truong Quang Tuan. All rights reserved.
//

import TTBaseUIKit
import SwiftUI

struct BaseSwiftUIStackDemo: View {
    init() {
    }
    
    var body: some View {
        SUIBaseViewDemo(title: "Base Stack Sample".uppercased()) {
            TTBaseSUIVStack(alignment: .center, spacing: 14) {
                TTBaseSUIView(bg: .gray) {
                    TTBaseSUIVStack(alignment: .center, spacing: 10, bg: .red) {
                        TTBaseSUIText(withType: .TITLE, text: "This", align: .leading, color: .white)
                        TTBaseSUIText(withType: .TITLE, text: "is", align: .leading, color: .white)
                        TTBaseSUIText(withType: .TITLE, text: "a", align: .leading, color: .white)
                        TTBaseSUIText(withBold: .HEADER, text: "TTBaseSUIHStack", align: .center, color: .yellow).padding()
                    }.corner().padding()
                }
                
                TTBaseSUIView(bg: .gray) {
                    TTBaseSUIHStack(alignment: .center, spacing: 10, bg: .clear) {
                        TTBaseSUIText(withType: .TITLE, text: "This", align: .leading, color: .white)
                        TTBaseSUIText(withType: .TITLE, text: "is", align: .leading, color: .white)
                        TTBaseSUIText(withType: .TITLE, text: "a", align: .leading, color: .white)
                        TTBaseSUIText(withBold: .HEADER, text: "TTBaseSUIHStack", align: .center, color: .yellow)
                    }.corner().padding()
                }
                
                TTBaseSUIView(bg: .gray) {
                    TTBaseSUIZStack(alignment: .center, bg: .clear) {
                        TTBaseSUIImage.init(withname: "bgView1", conner: XSize.CORNER_RADIUS)
                            .scaledToFill()
                            .frame(width: 250, height:200, alignment: .center)
                        TTBaseSUIText(withBold: .TITLE, text: "This is a TTBaseSUIZStack", align: .center, color: .white)
                            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 4).background(Color.red).corner()
                    }.corner().padding()
                }
            }
        }
        .onAppear { }
    }
}

struct BaseSwiftUIStackDemo_Previews: PreviewProvider {
    static var previews: some View {
        BaseSwiftUIStackDemo()
    }
}
