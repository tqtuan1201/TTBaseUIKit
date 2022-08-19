//
//  Configuration.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/6/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation

///
/// This Class to Default Lib:
///
public class TTBaseUIKitConfig {
    
    

    /// Default Font
    public var fontDefault:FontConfig = FontConfig()
    /// Default size
    public var sizeDefault:SizeConfig = SizeConfig()
    /// Default view
    public var viewDefault:ViewConfig = ViewConfig()
    /// Default style
    public var styleDefault:StyleConfig = StyleConfig()
    
    static var shared: TTBaseUIKitConfig?
    
    private init() {}
    
    convenience init(font:FontConfig, frameSize:SizeConfig, view:ViewConfig) {
        self.init()
        self.fontDefault = font
        self.sizeDefault = frameSize
        self.viewDefault = view
        
    }
    
    convenience init(font:FontConfig, frameSize:SizeConfig, view:ViewConfig, style:StyleConfig) {
        self.init()
        self.fontDefault = font
        self.sizeDefault = frameSize
        self.viewDefault = view
        self.styleDefault = style
        
    }
    
    public static func getViewConfig() -> ViewConfig {
        return (shared?.viewDefault ?? ViewConfig())
    }

    public static func getSizeConfig() -> SizeConfig {
        return (shared?.sizeDefault ?? SizeConfig())
    }
    
    public static func getFontConfig() -> FontConfig {
        return (shared?.fontDefault ?? FontConfig())
    }
    
    public static func getStyleConfig() -> StyleConfig {
        return (shared?.styleDefault ?? StyleConfig())
    }
}


// MARK: FOR BASE CONFIG FUNCS
extension TTBaseUIKitConfig {
    /// Methor for Config BaseView
    ///
    /// - Parameters:
    ///     - font: Base on FontConfig Class
    ///
    public func withDefaultConfig(withFontConfig font:FontConfig) -> TTBaseUIKitConfig? {
        return TTBaseUIKitConfig.withDefaultConfig(withFontConfig: font, frameSize: SizeConfig(), view: ViewConfig())
    }
    /// Methor for Config BaseView
    ///
    /// - Parameters:
    ///     - size: Base on SizeConfig Class
    ///
    public func withDefaultConfig(withFrameSizeConfig size:SizeConfig) -> TTBaseUIKitConfig? {
        return TTBaseUIKitConfig.withDefaultConfig(withFontConfig: FontConfig(), frameSize: size, view: ViewConfig())
    }
    /// Methor for Config BaseView
    ///
    /// - Parameters:
    ///     - view: Base on ViewConfig Class
    ///
    public func withDefaultConfig(withCusViewConfig view:ViewConfig) -> TTBaseUIKitConfig? {
        return TTBaseUIKitConfig.withDefaultConfig(withFontConfig: FontConfig(), frameSize: SizeConfig(), view: view)
    }
    
    /// Methor for Config BaseView
    ///
    /// - Parameters:
    ///     - font: Base on FontConfig Class
    ///     - size: Base on SizeConfig Class
    ///     - view: Base on ViewConfig Class
    ///
    public class func withDefaultConfig(withFontConfig font:FontConfig, frameSize:SizeConfig, view:ViewConfig) -> TTBaseUIKitConfig? {
        self.shared = TTBaseUIKitConfig.init(font: font, frameSize: frameSize, view: view)
        return self.shared
    }
    
    public class func withDefaultConfig(withFontConfig font:FontConfig, frameSize:SizeConfig, view:ViewConfig, style:StyleConfig) -> TTBaseUIKitConfig? {
        self.shared = TTBaseUIKitConfig.init(font: font, frameSize: frameSize, view: view, style: style)
        return self.shared
    }
    
    public class func config(withViewLog isShow:Bool) -> TTBaseUIKitConfig? {
        Config.isPrintLog = isShow
        self.shared =  TTBaseUIKitConfig.init()
        return self.shared
    }

    public func start() {
        TTBaseFunc.shared.printLog(object: "TTBaseUIKitConfig successfully !")
    }
    
    public func start(withViewLog isShow:Bool) {
        Config.isPrintLog = isShow
        TTBaseFunc.shared.printLog(object: "TTBaseUIKitConfig successfully ! [Config.isPrintLog \(isShow ? "True" : "False")]")
    }
}

// MARK: FOR BASE FUNCS

extension TTBaseUIKitConfig {
    
    /// Returns the magnitude of a vector in three dimensions
    /// from the given components.
    ///
}
