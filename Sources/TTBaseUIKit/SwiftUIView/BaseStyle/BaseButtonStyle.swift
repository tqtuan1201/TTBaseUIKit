//
//  SwiftUIView.swift
//  
//
//  Created by Tuan Truong Quang on 3/16/23.
//

import SwiftUI

/*
 case NO_BG_COLOR
 case DEFAULT
 case ICON
 case DISABLE
 case BORDER
 case WARRING
 */

public protocol TTBaseButtonStyle: ButtonStyle {
    
}

public struct NonAnimationButtonStyle: TTBaseButtonStyle {
    
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

//
/**
 DEFAULT Style
 - protocol TTBaseButtonStyle: ButtonStyle
 */
public struct DefaultButtonStyle: TTBaseButtonStyle {
    
    @State public var bgColor:Color = Color(TTBaseUIKitConfig.getViewConfig().buttonBgDef)
    
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: TTSize.H_BUTTON)
            .foregroundColor(configuration.isPressed ? Color.black.opacity(0.5) : Color.white)
            .background(configuration.isPressed ? self.bgColor.opacity(0.5) : self.bgColor)
    }
}

public struct DefaultColorButtonStyle: TTBaseButtonStyle {
    
    @State public var bgColor:Color = Color(TTBaseUIKitConfig.getViewConfig().buttonBgDef)
    @State public var textColor:Color = Color.black
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: TTSize.H_BUTTON)
            .foregroundColor(configuration.isPressed ? self.textColor.opacity(0.5) : self.textColor)
            .background(configuration.isPressed ? self.bgColor.opacity(0.5) : self.bgColor)
    }
}


//
/**
 WARRING Style
 - protocol TTBaseButtonStyle: ButtonStyle
 */
public struct WarningButtonStyle: TTBaseButtonStyle {
    
    @State public var bgColor:Color = Color(TTBaseUIKitConfig.getViewConfig().buttonBgWar)
    
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: TTSize.H_BUTTON)
            .foregroundColor(configuration.isPressed ? Color.black.opacity(0.5) : Color.white)
            .background(configuration.isPressed ? self.bgColor.opacity(0.5) : self.bgColor)
    }
}

//
/**
 Disable Style
 - protocol TTBaseButtonStyle: ButtonStyle
 */
public struct DisableButtonStyle: TTBaseButtonStyle {
    
    @State public var bgColor:Color = Color(TTBaseUIKitConfig.getViewConfig().buttonBgDis)
    
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: TTSize.H_BUTTON)
            .foregroundColor(configuration.isPressed ? Color.red.opacity(0.8) : Color.white)
            .background(self.bgColor)
            .disabled(true)
    }
}

//
/**
 No Bg Style
 - protocol TTBaseButtonStyle: ButtonStyle
 */
public struct TransparentButtonStyle: TTBaseButtonStyle {
    
    @State public var bgColor:Color = Color.clear
    
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity).frame(height: TTSize.H_BUTTON)
            .foregroundColor(configuration.isPressed ? Color(TTBaseUIKitConfig.getViewConfig().textDefColor).opacity(0.7) : Color(TTBaseUIKitConfig.getViewConfig().textDefColor))
            .background(self.bgColor)
    }
}

//
/**
 No Bg Style
 - protocol TTBaseButtonStyle: ButtonStyle
 */
public struct BorderButtonStyle: TTBaseButtonStyle {
    
    @State public var bgColor:Color = Color.white
    @State public var borderColor: Color = Color(TTView.buttonBorderColor)
    @State public var borderWidth: CGFloat = TTSize.H_BORDER
    
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity).frame(height: TTSize.H_BUTTON)
            .foregroundColor(configuration.isPressed ? Color(TTBaseUIKitConfig.getViewConfig().textDefColor).opacity(0.7) : Color(TTBaseUIKitConfig.getViewConfig().textDefColor))
            .background(configuration.isPressed ? self.bgColor.opacity(0.5) : self.bgColor)
            .overlay(
                RoundedRectangle(cornerRadius: TTSize.CORNER_BUTTON).stroke(borderColor, lineWidth: borderWidth)
            )
    }
}
