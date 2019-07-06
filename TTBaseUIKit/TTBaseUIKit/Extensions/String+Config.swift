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

    ///
    /// This func return date
    ///
    public func toDate(withFormat format: CONSTANT.FORMAT_DATE) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.date(from: self)
    }
    
    ///
    /// This func return date with set timeZone
    ///
    public func toDate(withFormat format: CONSTANT.FORMAT_DATE, timeZone:TimeZone) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.timeZone = timeZone
        return dateFormatter.date(from: self)
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
    
    public func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    public mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
