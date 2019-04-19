//
//  String+Config.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/15/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation

extension String {
    
    ///
    /// This func get string in Localizable.strings file
    /// ForExample: "App.Login" -> VI: DangNhap, EN:Login
    public func localize(withBundle bundle:Bundle) -> String {
        guard let bundle = bundle.path(forResource: TTLanguageManager.shared.currentLanguage.rawValue, ofType: "lproj") else {
            return NSLocalizedString(self, comment: "")
        }
        
        let langBundle = Bundle(path: bundle)
        return NSLocalizedString(self, tableName: nil, bundle: langBundle!, comment: "")
    }
    
    ///
    /// This func return base64Encode String
    ///
    public func base64Encoded() -> String? {
        return data(using: .utf8)?.base64EncodedString()
    }
    
    ///
    /// This func return base64Decode String
    ///
    public func base64Decoded() -> String? {
        guard let decodedData = NSData(base64Encoded:self , options: .ignoreUnknownCharacters) else { return nil }
        return String(data: decodedData as Data, encoding: .utf8)
    }
}

// MARK: For static func
extension String {
    
    ///
    /// This func get string value with check null value
    /// ForExample: abc? -> abc or ""
    ///
    /// - parameter stringOptional: string?
    ///
    public static func get(_ stringOptional:String?) -> String {
        return stringOptional ?? ""
    }
}
