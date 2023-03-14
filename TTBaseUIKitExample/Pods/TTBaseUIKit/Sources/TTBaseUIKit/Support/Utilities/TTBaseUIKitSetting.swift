//
//  TTBaseUIKitSetting.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/15/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation

protocol AppSettingsConfigurable {
    var defaultLanguage: TTLanguageManager.Languages { get set }
    var selectedLanguage:TTLanguageManager.Languages? { get set }
    var numberOpenApp:Int {get set}
}

public class TTBaseUIKitSetting {
    
    private init() {}; public static let shared: TTBaseUIKitSetting = TTBaseUIKitSetting()
    
    struct KEY {
        static let  DEFAULT_LANGUAGE:String = "DEFAULT_LANGUAGE"
        static let  SELECTED_LANGUAGE:String = "SELECTED_LANGUAGE"
        static let  NUMBER_OPEN_APP:String = "NUMBER_OPEN_APP"
        
        static let  DEV_ISSHOWMESSAGE:String = "DEV_ISSHOWMESSAGE"
    }
    
    
    public func updateDefaults(for key: String, value: Any) {
        // Save value into UserDefaults
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    public func value<T>(for key: String) -> T? {
        // Get value from UserDefaults
        UserDefaults.standard.synchronize()
        return UserDefaults.standard.value(forKey: key) as? T
    }
    
}

extension TTBaseUIKitSetting : AppSettingsConfigurable {
    
    var numberOpenApp: Int {
        get {
            return self.value(for: KEY.NUMBER_OPEN_APP) ?? 0
        }
        set {
            self.updateDefaults(for: KEY.NUMBER_OPEN_APP, value: newValue)
        }
    }
    
    var defaultLanguage: TTLanguageManager.Languages {
        get { return TTLanguageManager.Languages.init(rawValue: self.value(for: KEY.DEFAULT_LANGUAGE) ?? "en") ?? TTLanguageManager.Languages.en }
        set { self.updateDefaults(for: KEY.DEFAULT_LANGUAGE, value: newValue.rawValue)}
    }
    
    var selectedLanguage: TTLanguageManager.Languages? {
        get { return TTLanguageManager.Languages.init(rawValue: self.value(for: KEY.SELECTED_LANGUAGE) ?? "nil")}
        set { self.updateDefaults(for: KEY.SELECTED_LANGUAGE, value: (newValue ?? TTLanguageManager.Languages.en).rawValue)}
    }
}
