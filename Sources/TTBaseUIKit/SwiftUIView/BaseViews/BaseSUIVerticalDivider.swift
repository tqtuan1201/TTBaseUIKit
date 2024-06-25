//
//  SwiftUIView.swift
//  
//
//  Created by TuanTruong on 18/10/2023.
//

import SwiftUI

public struct TTBaseSUIVerticalDividerView: View {
    
    public enum TYPE {
        case LINE
        case SPACE
        case CUSTOME(color:Color, width:CGFloat)
    }
    
    public var conner:CGFloat = TTBaseUIKitConfig.getSizeConfig().CORNER_RADIUS
    public var currentType:TYPE = .SPACE
     
    public init(withConner conner:CGFloat = TTBaseUIKitConfig.getSizeConfig().CORNER_RADIUS, type:TTBaseSUIVerticalDividerView.TYPE) {
        self.currentType = type
        self.conner = conner
    }
    
    public init(noConner type:TTBaseSUIVerticalDividerView.TYPE) {
        self.currentType = type
        self.conner = 0
    }
    
    public var body: some View {
        switch self.currentType {
        case .LINE:
            return Color(TTBaseUIKitConfig.getViewConfig().lineDefColor)
                .frame(width: TTBaseUIKitConfig.getSizeConfig().H_LINEVIEW)
                .cornerRadius(self.conner)
        case .SPACE:
            return Color.clear
                .frame(width: TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF)
                .cornerRadius(self.conner)
        case .CUSTOME(let color, let width):
            return color.frame(width: width).cornerRadius(self.conner)
        }
    }
}
#if DEBUG
struct TTBaseVerticalDividerView_Previews: PreviewProvider {
    static var previews: some View {
        TTBaseSUIHStack(alignment: .center, spacing: 10) {
            TTBaseSUIVerticalDividerView(noConner: .LINE).padding()
            TTBaseSUIVerticalDividerView(withConner: 10, type: .SPACE)
        }.frame(height: 200)
    }
}
#endif
