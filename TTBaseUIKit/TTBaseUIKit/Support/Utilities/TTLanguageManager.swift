//
//  LanguageManager.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/15/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation

public class TTLanguageManager {
    
    public enum Languages:String {
        case ar,en,nl,ko,ru,sv,fr,es,pt,it,de,da,fi,nb,tr,el,id,ms,th,hi,hu,pl,cs,sk,uk,hr,ca,ro,he
        case enAS = "en-AS"
        case ja = "ja-JP"
        case enGB = "en-GB"
        case enAU = "en-AU"
        case enCA = "en-CA"
        case enIN = "en-IN"
        case frCA = "fr-CA"
        case esMX = "es-MX"
        case ptBR = "pt-BR"
        case zhHans = "zh-Hans"
        case zhHant = "zh-Hant"
        case zhHK = "zh-HK"
        case vi = "vi-VN"
        case de_DE = "de-DE"
    }
    
    private init(){} ; public static let shared: TTLanguageManager = TTLanguageManager()
    
    /// Returns the default language that the app will run first time
    public var defaultLanguage: Languages {
        get { return TTBaseUIKitSetting.shared.defaultLanguage }
        set {
            // swizzle the awakeFromNib from nib and localize the text in the new awakeFromNib
            //UIView.localize()
            TTBaseUIKitSetting.shared.defaultLanguage = newValue
            if TTBaseUIKitSetting.shared.selectedLanguage == nil {
                self.setLanguage(language: newValue)
            }
        }
    }
    
    /// Returns the currnet language
    public var currentLanguage: Languages {
        get { return TTBaseUIKitSetting.shared.selectedLanguage ?? self.defaultLanguage}
        set { TTBaseUIKitSetting.shared.selectedLanguage = newValue }
    }
    
}

extension TTLanguageManager {
    
    ///
    /// Set the current language for the app
    ///
    /// - parameter language: The language that you need from the app to run with
    ///
    
    public func setLanguage(language: Languages) {
        
        // change app language
        UserDefaults.standard.set([language.rawValue], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        // set current language
        currentLanguage = language
    }

    ///
    /// Check select language
    ///
    
    public func isSelectedLanguage() -> Bool {
        return TTBaseUIKitSetting.shared.selectedLanguage != nil
    }
    
    
}

