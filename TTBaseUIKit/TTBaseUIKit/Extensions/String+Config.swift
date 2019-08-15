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
    
    public func components(withMaxLength length: Int) -> [String] {
        return stride(from: 0, to: self.count, by: length).map {
            let start = self.index(self.startIndex, offsetBy: $0)
            let end = self.index(start, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            return String(self[start..<end])
        }
    }
    
    public subscript(_ i: Int) -> String {
        let idx1 = index(startIndex, offsetBy: i)
        let idx2 = index(idx1, offsetBy: 1)
        return String(self[idx1..<idx2])
    }
    
    public subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[start ..< end])
    }
    
    public subscript (r: CountableClosedRange<Int>) -> String {
        let startIndex =  self.index(self.startIndex, offsetBy: r.lowerBound)
        let endIndex = self.index(startIndex, offsetBy: r.upperBound - r.lowerBound)
        return String(self[startIndex...endIndex])
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
