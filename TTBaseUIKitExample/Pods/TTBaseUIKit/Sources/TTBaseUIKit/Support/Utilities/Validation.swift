//
//  Validation.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 8/15/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation

public enum Alert {
    case success
    case failure
    case error
}

public enum Valid {
    case success
    case failure(Alert, AlertMessages)
}

public enum ValidationType {
    case email
    case stringWithFirstLetterCaps
    case phoneNo
    case alphabeticString
    case password
}

public enum RegEx: String {
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" // Email
    case password = "^.{6,15}$" // Password length 6-15
    case alphabeticStringWithSpace = "^[a-zA-Z ]*$" // e.g. hello sandeep
    case alphabeticStringFirstLetterCaps = "^[A-Z]+[a-zA-Z]*$" // SandsHell
    case phoneNo = "[0-9]{8,14}" // PhoneNo 8-14 Digits
    
    //Change RegEx according to your Requirement
}

public enum AlertMessages: String {
    
    case inValidEmail = "App.Validation.InvalidEmail"
    case invalidFirstLetterCaps = "App.Validation.FirstLetterShouldBeCapital"
    case inValidPhone = "App.Validation.InvalidPhone"
    case invalidAlphabeticString = "App.Validation.InvalidString"
    case inValidPSW = "App.Validation.InvalidPassword"
    
    case emptyPhone = "App.Validation.EmptyPhone"
    case emptyEmail = "App.Validation.EmptyEmail"
    case emptyFirstLetterCaps = "App.Validation.EmptyName"
    case emptyAlphabeticString = "App.Validation.EmptyString"
    case emptyPSW = "App.Validation.EmptyPassword"
    
    func localized() -> String {
        return self.rawValue
    }
}

open class TTValidation: NSObject {
    
    public static let shared = TTValidation()
    
    public func validate(values: (type: ValidationType, inputValue: String)...) -> Valid {
        for valueToBeChecked in values {
            switch valueToBeChecked.type {
            case .email:
                if let tempValue = isValidString((valueToBeChecked.inputValue, .email, .emptyEmail, .inValidEmail)) {
                    return tempValue
                }
            case .stringWithFirstLetterCaps:
                if let tempValue = isValidString((valueToBeChecked.inputValue, .alphabeticStringFirstLetterCaps, .emptyFirstLetterCaps, .invalidFirstLetterCaps)) {
                    return tempValue
                }
            case .phoneNo:
                if let tempValue = isValidString((valueToBeChecked.inputValue, .phoneNo, .emptyPhone, .inValidPhone)) {
                    return tempValue
                }
            case .alphabeticString:
                if let tempValue = isValidString((valueToBeChecked.inputValue, .alphabeticStringWithSpace, .emptyAlphabeticString, .invalidAlphabeticString)) {
                    return tempValue
                }
            case .password:
                if let tempValue = isValidString((valueToBeChecked.inputValue, .password, .emptyPSW, .inValidPSW)) {
                    return tempValue
                }
            }
        }
        return .success
    }
    
    public func isValidString(_ input: (text: String, regex: RegEx, emptyAlert: AlertMessages, invalidAlert: AlertMessages)) -> Valid? {
        if input.text.isEmpty {
            return .failure(.error, input.emptyAlert)
        } else if isValidRegEx(input.text, input.regex) != true {
            return .failure(.error, input.invalidAlert)
        }
        return nil
    }
    
    public func isValidRegEx(_ testStr: String, _ regex: RegEx) -> Bool {
        let stringTest = NSPredicate(format:"SELF MATCHES %@", regex.rawValue)
        let result = stringTest.evaluate(with: testStr)
        return result
        
    }
}
