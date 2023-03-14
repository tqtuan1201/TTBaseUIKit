//
//  TextValidation.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 7/8/21.
//  Copyright © 2021 Truong Quang Tuan. All rights reserved.
//

import Foundation

public protocol  TextValidationProtocol  {
    var  regExFindMatchString:  String  {get}
    var  validationMessage:  String  {get}
}


extension TextValidationProtocol  {
    public var  regExMatchingString:  String  {
        get  {
            return  regExFindMatchString  +  "$"
        }
    }
    
    public func  validateString(str:  String)  ->  Bool  {
        if  let  _  =  str.range(of:  regExMatchingString, options:  .regularExpression){
            return  true
        }  else  {
            return  false
        }
    }
    
    public func  getMatchingString(str:  String)  ->  String?  {
        if  let  newMatch  =  str.range(of:  regExFindMatchString, options:  .regularExpression)  {
            return String(str[newMatch])
        }  else  {
            return  nil
        }
    }
}

public struct AlphaValidation: TextValidationProtocol {
    public static let shared = AlphaValidation()
    private init(){}
    public let regExFindMatchString = "^[a-zA-Z]{0,10}"
    public let validationMessage = NSLocalizedString("AlphaValidation.AlphaValidation", comment: "")
}

public struct AlphaNumericValidation: TextValidationProtocol {
    public static let shared = AlphaNumericValidation()
    private init(){}
    public let regExFindMatchString = "^[a-zA-Z0-9]{0,15}"
    public let validationMessage = NSLocalizedString("AlphaValidation.AlphaNumericValidation", comment: "")
}

public struct DisplayNameValidation: TextValidationProtocol {
    public static let shared = DisplayNameValidation()
    private init(){}
    public let regExFindMatchString = "^[\\s?[a-zA-Z0-9\\-_,.$\\s]]{0,15}"
    public let validationMessage = NSLocalizedString("AlphaValidation.DisplayNameValidation", comment: "")
}

public struct DateValidation: TextValidationProtocol {
    public static let shared = DateValidation()
    private init(){}
    public let regExFindMatchString = "[0-9]{2}/[0-9]{2}/[0-9]{4}"
    public let validationMessage = NSLocalizedString("AlphaValidation.DateValidation", comment: "")
}

public struct NumbericValidation: TextValidationProtocol {
    public static let shared = NumbericValidation()
    private init(){}
    public let regExFindMatchString = "[0-9]"
    public let validationMessage = NSLocalizedString("AlphaValidation.NumericValidation", comment: "")
}


public struct EmailValidation: TextValidationProtocol {
    public static let shared = EmailValidation()
    private init(){}
    public let regExFindMatchString = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
    public let validationMessage = NSLocalizedString("AlphaValidation.EmailValidation", comment: "")
}


//Example
//var  myString1  =  "abcxyz"
//var  myString2  =  "abc123"
//var  validation  =  AlphabeticValidation.sharedInstance
//validation.validateString(str:  myString1)
//validation.validateString(str:  myString2)
//validation.getMatchingString(str:  myString1)
//validation.getMatchingString(str:  myString2)
