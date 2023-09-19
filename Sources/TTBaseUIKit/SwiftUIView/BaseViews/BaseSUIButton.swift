//
//  SwiftUIView.swift
//  
//
//  Created by Tuan Truong Quang on 3/16/23.
//

import SwiftUI

public struct TTBaseSUIButton<Content: View>: View {
    
    
    public var cornerRadius: CGFloat = TTBaseUIKitConfig.getSizeConfig().CORNER_BUTTON
    public var fontSize: CGFloat = TTBaseUIKitConfig.getFontConfig().TITLE_H
    public var fontDef: UIFont  = TTBaseUIKitConfig.getFontConfig().FONT
    
    public let type: TTBaseUIButton.TYPE
    
    public let action: () -> Void
    public let label: () -> Content
    
    public init(type: TTBaseUIButton.TYPE, @ViewBuilder label: @escaping () -> Content, action: @escaping () -> Void) {
        self.type = type
        self.action = action
        self.label = label
    }
    
    public init(type: TTBaseUIButton.TYPE, title: String) where Content == Text {
        self.init(type: type) {Text(title) } action: {
            TTBaseFunc.shared.printLog(object: "::BaseSUIButton Skip handle action on BaseSUIButton")
        }
    }
    
    public init(type: TTBaseUIButton.TYPE, title: String, action: @escaping () -> Void) where Content == Text {
        self.init(type: type, label: {Text(title)}, action: action)
    }
    
    public init(title: String,action: @escaping () -> Void) where Content == Text {
        self.init(type: .DEFAULT, label: { Text(title) }, action: action)
    }
    
    public init(@ViewBuilder label: @escaping () -> Content, action: @escaping () -> Void) {
        self.init(type: .DEFAULT, label: label, action: action)
    }
    
    public var body: some View {
        switch type {
        case .WARRING:
            SwiftUI.Button(action: self.action, label: self.label).buttonStyle(WarningButtonStyle()).font(.system(size: self.fontSize)).cornerRadius(self.cornerRadius)
        case .DISABLE:
            SwiftUI.Button(action: self.action, label: self.label).buttonStyle(DisableButtonStyle()).font(.system(size: self.fontSize)).cornerRadius(self.cornerRadius)
        case .NO_BG_COLOR:
            SwiftUI.Button(action: self.action, label: self.label).buttonStyle(TransparentButtonStyle()).font(.system(size: self.fontSize)).cornerRadius(self.cornerRadius)
        case .BORDER:
            SwiftUI.Button(action: self.action, label: self.label).buttonStyle(BorderButtonStyle()).font(.system(size: self.fontSize)).cornerRadius(self.cornerRadius)
        case .DEFAULT_COLOR(let color, let textColor):
            SwiftUI.Button(action: self.action, label: self.label).buttonStyle(DefaultColorButtonStyle(bgColor: Color(color), textColor: Color(textColor))).font(.system(size: self.fontSize)).cornerRadius(self.cornerRadius)
        default:
            SwiftUI.Button(action: self.action, label: self.label).buttonStyle(DefaultButtonStyle()).font(.system(size: self.fontSize)).cornerRadius(self.cornerRadius)
        }
    }
}

//MARK: Previews
struct BaseSUIButtonView: View {
    var body: some View {
        VStack {
            TTBaseSUIButton(type: .DEFAULT, title: "DEFAULT")
            TTBaseSUIButton(type: .DEFAULT_COLOR(color: .systemBlue, textColor: .red), title: "DEFAULT_COLOR")
            TTBaseSUIButton(type: .WARRING, title: "WARRING")
            TTBaseSUIButton(type: .DISABLE, title: "DISABLE")
            TTBaseSUIButton(type: .NO_BG_COLOR, title: "NO_BG_COLOR")
            TTBaseSUIButton(type: .BORDER, title: "BORDER")
        }
        .padding()
        .background(Color.white)
    }
}

struct BaseSUIButtonView_Previews: PreviewProvider {
    static var previews: some View {
        BaseSUIButtonView()
    }
}
