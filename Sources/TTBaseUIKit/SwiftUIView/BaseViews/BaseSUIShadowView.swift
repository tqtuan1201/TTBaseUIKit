//
//  File.swift
//  TTBaseUIKit
//
//  Created by TuanTruong on 7/7/25.
//

import Foundation
import SwiftUI

public struct TTBaseSUIShadowView<Content: View>: View {
    
    public var viewDefBgColor: Color = Color(TTBaseUIKitConfig.getViewConfig().viewDefColor)
    public var cornerRadius: CGFloat = TTSize.CORNER_RADIUS
    public var shadowColor: Color = TTView.viewPanelShadowColor
    public var shadowRadius: CGFloat = 4.0
    
    public let content: Content
    
    // MARK: Designated (and only) init — “all in one”
    public init(
        viewDefBgColor: Color = Color(TTBaseUIKitConfig.getViewConfig().viewDefColor),
        cornerRadius: CGFloat = TTSize.CORNER_RADIUS,
        shadowColor: Color = TTView.viewPanelShadowColor,
        shadowRadius: CGFloat = 4.0,
        @ViewBuilder content: () -> Content
    ) {
        self.viewDefBgColor = viewDefBgColor
        self.cornerRadius   = cornerRadius
        self.shadowColor    = shadowColor
        self.shadowRadius   = shadowRadius
        self.content        = content()
    }

    public var body: some View {
        self.content
            .pAll(TTSize.P_S)
            .background(
                RoundedRectangle(cornerRadius: self.cornerRadius, style: .continuous)
                    .fill(self.viewDefBgColor)
                    .shadow(color: self.shadowColor,
                            radius: 8, x: 0, y: self.shadowRadius)
            )
    }
}


struct TTBaseSUIShadowView_Previews: PreviewProvider {
    static var previews: some View {
        TTBaseSUIShadowView(content: {
            TTBaseSUIText(withType: .TITLE, text: "This is a shadow view", align: .center, color: TTView.textDefColor.toColor())
                .pAll(30.0)
        })
        .frame(maxWidth: .infinity)
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
