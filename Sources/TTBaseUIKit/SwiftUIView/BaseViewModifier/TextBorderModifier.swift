//
//  File.swift
//  
//
//  Created by Tuan Truong Quang on 3/17/23.
//

import SwiftUI

public struct BorderTextModifier: ViewModifier {
    public var borderColor: Color = Color(TTView.buttonBorderColor)
    public var borderWidth: CGFloat = TTSize.H_BORDER
    
    public func body(content: Content) -> some View {
        content
            .font(.system(size: TTFont.TITLE_H))
            .padding()
            .foregroundColor(Color(TTView.textDefColor))
            .overlay(
                RoundedRectangle(cornerRadius: TTSize.CORNER_BUTTON).stroke(self.borderColor, lineWidth: self.borderWidth)
            )
    }
}

public struct SuperHeaderTextModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .font(.system(size: TTFont.HEADER_SUPER_H))
            .foregroundColor(Color(TTView.textDefColor))
    }
}

public struct HeaderTextModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .font(.system(size: TTFont.HEADER_H))
            .foregroundColor(Color(TTView.textDefColor))
    }
}

public struct TitleTextModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .font(.system(size: TTFont.TITLE_H))
            .foregroundColor(Color(TTView.textDefColor))
    }
}

public struct SubTitleTextModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .font(.system(size: TTFont.SUB_TITLE_H))
            .foregroundColor(Color(TTView.textDefColor))
    }
}

public struct SubSubTitleTextModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .font(.system(size: TTFont.SUB_SUB_TITLE_H))
            .foregroundColor(Color(TTView.textDefColor))
    }
}

