//
//  File.swift
//  
//
//  Created by TuanTruong on 18/10/2023.
//


import SwiftUI

public struct TTBaseSUIHorizontalDividerView: View {
    
    public enum TYPE {
        case LINE
        case SPACE
        case CUSTOME(color:Color, height:CGFloat)
    }
    
    public var conner:CGFloat = TTBaseUIKitConfig.getSizeConfig().CORNER_RADIUS
    public var currentType:TYPE = .SPACE
    
    public init(withConner conner:CGFloat = TTBaseUIKitConfig.getSizeConfig().CORNER_RADIUS, type:TTBaseSUIHorizontalDividerView.TYPE) {
        self.currentType = type
        self.conner = conner
    }
    
    public init(noConner type:TTBaseSUIHorizontalDividerView.TYPE) {
        self.currentType = type
        self.conner = 0
    }
    
    public var body: some View {
        switch self.currentType {
        case .LINE:
            return Color(TTBaseUIKitConfig.getViewConfig().lineDefColor)
                .frame(height: TTBaseUIKitConfig.getSizeConfig().H_LINEVIEW)
                .cornerRadius(self.conner)
        case .SPACE:
            return Color.clear
                .frame(height: TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF)
                .cornerRadius(self.conner)
        case .CUSTOME(let color, let height):
            return color.frame(height: height).cornerRadius(self.conner)
        }
    }
}

#if DEBUG
struct TTBaseHorizontalDividerView_Previews: PreviewProvider {
    static var previews: some View {
        TTBaseSUIView(withCornerRadius: 10, bg: .gray) {
            TTBaseSUIHorizontalDividerView(noConner: .LINE).padding()
        }
    }
}
#endif

