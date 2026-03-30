//
//  BaseSwiftUINavView.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 2/8/24.
//  Copyright © 2024 Truong Quang Tuan. All rights reserved.
//

import TTBaseUIKit
import SwiftUI


struct BaseSwiftUINavView: View {
    var items:[String] =  [
        "The only way to do great work is to love what you do. - Steve Jobs",
        "Believe you can and you're halfway there. - Theodore Roosevelt",
        "Success is not final, failure is not fatal: it is the courage to continue that counts. - Winston Churchill",
        "The future belongs to those who believe in the beauty of their dreams. - Eleanor Roosevelt",
        "Happiness is not something ready-made. It comes from your own actions. - Dalai Lama",
        "The best way to predict the future is to create it. - Peter Drucker",
        "Challenges are what make life interesting and overcoming them is what makes life meaningful. - Joshua J. Marine",
        "The only limit to our realization of tomorrow will be our doubts of today. - Franklin D. Roosevelt",
        "Believe in yourself and all that you are. Know that there is something inside you that is greater than any obstacle. - Christian D. Larson",
        "The future belongs to those who prepare for it today. - Malcolm X",
        "The only way to do great work is to love what you do. - Steve Jobs",
        "The future belongs to those who believe in the beauty of their dreams. - Eleanor Roosevelt",
        "The greatest glory in living lies not in never falling, but in rising every time we fall. - Nelson Mandela",
        "Believe you can and you're halfway there. - Theodore Roosevelt",
        "Happiness is not something ready-made. It comes from your own actions. - Dalai Lama",
        "Debugging is twice as hard as writing the code in the first place. Therefore, if you write the code as cleverly as possible, you are, by definition, not smart enough to debug it. - Brian Kernighan",
        "The best way to predict the future is to implement it. - David Heinemeier Hansson",
        "Simplicity is the soul of efficiency. - Austin Freeman",
        "Code is like humor. When you have to explain it, it's bad. - Cory House",
        "The only way to do great work is to love what you do. - Steve Jobs"
    ]
    
    init() {
    }
    
    var body: some View {
        SUIBaseViewDemo(title: "Base SwiftUI View Sample".uppercased()) {
            TTBaseSUIView(withCornerRadius: 0, bg: XView.viewBgColor.toColor()) {
                TTBaseSUIVStack(alignment: .center, spacing: XSize.P_CONS_DEF) {
                    TTBaseSUIText(withBold: .TITLE, text: "Base TTBaseSUIText", align: .center, color: XView.textDefColor.toColor())
                        .padding(.all, XSize.P_CONS_DEF).bg(byDef: .white).corner().padding(.all, XSize.P_CONS_DEF)
                    TTBaseSUIScroll {
                        TTBaseSUIVStack(alignment: .center, spacing: XSize.P_CONS_DEF, bg: .clear) {
                            ForEach(items, id: \.self) { item in
                                TTBaseSUIText.init(withBold: .TITLE, text: item, align: .leading, color: XView.textDefColor.toColor())
                                    .maxWidth(alignment: .center).padding(.all, XSize.P_CONS_DEF).bg(byDef: .white).corner().padding([.leading, .trailing], XSize.P_CONS_DEF)
                            }
                        }.padding([.top, .bottom], XSize.P_CONS_DEF)
                    }
                }
            }
        }
        .onAppear { }
    }
}

struct BusListView_Previews: PreviewProvider {
    static var previews: some View {
        BaseSwiftUINavView()
    }
}
