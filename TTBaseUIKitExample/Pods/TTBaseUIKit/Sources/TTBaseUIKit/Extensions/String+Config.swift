//
//  String+Config.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/15/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

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
    public func toDate(withStringFormat format:String, locate:Locale? = nil) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if let _locate = locate {dateFormatter.locale = _locate}
        return dateFormatter.date(from: self)
    }

    ///
    /// This func return date
    ///
    public func toDate(withFormat format: CONSTANT.FORMAT_DATE, locate:Locale? = nil) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        if let _locate = locate {dateFormatter.locale = _locate}
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
    
    //return
    public func reFormatDateByRemoveTimeZ() -> String {
        let newFormat:String =  self.subStringToIndex(".")
        TTBaseFunc.shared.printLog(object: "reFormatDateByRemoveTimeZ oldFormat: \(self)")
        TTBaseFunc.shared.printLog(object: "reFormatDateByRemoveTimeZ newFormat: \(newFormat)")
        return newFormat
    }
    
    public func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    public func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    public func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    public func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
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
    
    
    public func convertHtmlToAttributedStringWithCSS(font: UIFont? , csscolor: String , lineheight: Int, csstextalign: String) -> NSAttributedString? {
        guard let font = font else { return nil }
        let modifiedString = "<style>body{font-family: '\(font.fontName)'; font-size:\(font.pointSize)px; color: \(csscolor); line-height: \(lineheight)px; text-align: \(csstextalign); }</style>\(self)";
        guard let data = modifiedString.data(using: .utf8) else {
            return nil
        }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }
        catch {
            print(error)
            return nil
        }
    }
    
    public func htmlAttributedStringByAppleStyle(withFontSize size:CGFloat, color:UIColor, font:String = "-apple-system") -> NSAttributedString? {
        let htmlTemplate = """
        <!doctype html>
        <html>
          <head>
            <style>
              body {
                font-family: \(font);
                font-size: \(size)px;
                color: \(color.hexString ?? "");
              }
            </style>
          </head>
          <body>
            \(self)
          </body>
        </html>
        """
        
        guard let data = htmlTemplate.data(using: String.Encoding.utf16, allowLossyConversion: false) else {
            return nil
        }
        
        guard let attributedString = try? NSMutableAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        ) else {
            return nil
        }
        
        return attributedString
    }
    
    public func htmlAttributedString() -> NSAttributedString? {
        guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
        guard let html = try? NSMutableAttributedString(
            data: data,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil) else { return nil }
        return html
    }
    
    public func subStringToIndex(_ str: String) -> String{
        if let range = self.range(of: str) {
            let index: Int = self.distance(from: self.startIndex, to: range.lowerBound)
            return (self as NSString).substring(to: index)
        } else {
            return self
        }
        
    }
    
    public func subStringFromIndex(_ str: String) -> String{
        if let range = self.range(of: str) {
            let index: Int = self.distance(from: self.startIndex, to: range.lowerBound)
            return (self as NSString).substring(from: index + 1)
        } else {
            return self
        }
        
    }
    
    
    public func htmlAttributedString(withFontSize size:CGFloat = TTBaseUIKitConfig.getFontConfig().TITLE_H) -> NSAttributedString? {
         guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
         guard let html = try? NSMutableAttributedString(
             data: data,
             options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
             documentAttributes: nil) else { return nil }
         
         let fontAtt: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: size, weight: .regular), .foregroundColor : TTView.labelBgWar]
         if let _rang = NSRange.init(self) {
             html.addAttributes(fontAtt, range: _rang)
         }

         return html
     }
     
    
    public func removeDiacritics() -> String {
        return self.folding(options: .diacriticInsensitive, locale: .current)
    }
    
    public  func removeDiacriticsVN() -> String {
        let newString:String = self.folding(options: .diacriticInsensitive, locale: Locale.init(identifier: "vi"))
        return (newString as NSString).replacingOccurrences(of: "đ", with: "d")
        
    }
    
    public func splitString(byStartString start:String) -> String {
        if let endIndex = self.range(of: start)?.upperBound {
            return String(self[endIndex ..< self.endIndex])
        } else {
            return self
        }
    }

    public func splitString(byEndString end:String) -> String {
        if let endIndex = self.range(of: end)?.lowerBound {
            return String(self[..<endIndex])
        } else {
            return self
        }
    }
    
    public func removeWhitespace() -> String {
        return self.replace(" ", replacement: "")
    }
    
    public func replace(_ string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    public static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}

//MARK:// For validation string
extension String {

     public var isEmail: Bool {
         do {
             let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
             return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
         } catch {
             return false
         }
     }
     
     public var isStringText:Bool {
         // Only allow numbers. Look for anything not a number.
         
         let characterSet:CharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789 !,.?()-_^&$@+\n")
         
         let range = self.rangeOfCharacter(from: characterSet.inverted)
         return (range == nil)
     }

    public  var isTextOnly:Bool {
         // Only allow numbers. Look for anything not a number.
         
         let characterSet:CharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789 ")
         
         let range = self.rangeOfCharacter(from: characterSet.inverted)
         return (range == nil)
     }
     
    public  var isPhoneNumber: Bool {

         let charcter  = CharacterSet(charactersIn: "+0123456789").inverted
         let inputString = self.components(separatedBy: charcter).joined(separator: "")
         return  self == inputString
     }
     
     public var isName:Bool {
         let _nameTrim = self.trimmingCharacters(
             in: CharacterSet.whitespacesAndNewlines
         )
         if _nameTrim.range(of: " ") != nil {
             return true
         } else {
             return false
         }
         
     }
    
    public mutating func replace(_ data:String, dataReplace:String) -> String {
        self = (self as NSString).replacingOccurrences(of: data, with: dataReplace)
        return self
    }
    
    public func numberOfOccurrencesOf(string: String) -> Int {
        return self.components(separatedBy:string).count - 1
    }
    
}
