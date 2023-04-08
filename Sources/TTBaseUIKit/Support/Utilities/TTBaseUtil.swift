//
//  TTBaseUtilFuncs.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/18/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import SystemConfiguration
import UIKit

// MARK: For Public funcs
public class TTBaseUtil {
    private init() {}
    public static let shared = TTBaseUtil()
}

extension TTBaseUtil {
    
    /// Get no image default
    ///
    public class func getNoImageDef() -> UIImage? {
        return UIImage(fromTTBaseUIKit: Config.Value.noImageName)
    }
    
    /// Check connect network
    ///
    public class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }

    /// Convert Dictionary to jsonString
    ///
    public static func convertDictToJSonString(dict: Any) -> String? {
        do {
            let dataResponse = try JSONSerialization.data(withJSONObject: dict, options:[])
            return String(decoding: dataResponse, as: UTF8.self)
        } catch {
            return nil
        }
    }
    
    /// Convert Dictionary to data
    ///
    public static func convertDictToData(dict: Any) -> Data? {
        do {
            let data = try JSONSerialization.data(withJSONObject: dict, options:[])
            return data
        } catch {
            return nil
        }
    }

    /// Convert JSonString to  to dic [String:AnyObject]
    ///
    public static func convertJSonToDict(text: String) -> [String:AnyObject] {
        if let data = text.data(using: String.Encoding.utf8) {
            guard let result: [String:AnyObject] = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers, .allowFragments]) as? [String:AnyObject]  else { return [:]}
            return result
        }
        return [:]
    }
    
    /// Get App versions
    ///
    public static func getAppVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    
    public static func domainEmailList() -> [String] {
        let domains = [
            "facebook.com", "gmail.com", "googlemail.com",
            "google.com", "hotmail.com", "mail.com", "msn.com",
            "live.com", "yahoo.com"]
        return domains
    }
    
    
      /// Push to go setting app
      ///
      public func goSettingApp() {
          guard let urlApp = URL(string: UIApplication.openSettingsURLString) else { return }
          UIApplication.shared.open(urlApp, options: [:], completionHandler: nil)
      }
      
      
      /// to make phone call
      ///
      public func makeCall(WithPhoneNumber phone:String) {
          if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
              UIApplication.shared.open(url, options: [:], completionHandler: nil)
          }
      }
}

//MARK:// For show message for dev
extension TTBaseUtil {
    
    /// to show messageView for DEV
    ///
    public func onShowMessageByDEVMODE(des:String) {
        DispatchQueue.main.async {
            
            let messageString:String = "[DEV MODE] \n\(des)"
            
            if let window = UIApplication.getKeyWindow() {
                let messLabel:TTBaseInsetLabel = TTBaseInsetLabel(withType: .SUB_TITLE, text: messageString, align: .left)
                messLabel.layer.zPosition = 999999
                messLabel.setTextColor(color: .white)
                messLabel.setMutilLine(numberOfLine: 0, textAlignment: .left, mode: .byTruncatingHead)
                
                messLabel.setBgColor(UIColor.black.withAlphaComponent(0.9))
                messLabel.setConerDef()
                messLabel.isUserInteractionEnabled = true
                
                messLabel.setTouchHandler().onTouchHandler = { _ in
                    DispatchQueue.main.async {
                        messLabel.removeFromSuperview()
                    }
                }
                
                window.addSubview(messLabel)
                
                messLabel.setVerticalContentHuggingPriority()
                    .setTopAnchor(constant: TTSize.H_STATUS)
                    .setWidthAnchor(constant: TTSize.W - TTSize.P_CONS_DEF)
                    .setCenterXAnchor(constant: 0)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                    messLabel.removeFromSuperview()
                }
            }
        }
    }
}

//MARK:// For send bot message to telegram app
extension TTBaseUtil {
    
    /// to send message via bot telegram
    ///
    public func sendLogByBot(withGroupID id:String, token:String, message:String) {

        let json: [String: Any] = ["chat_id": "-\(id)", "text": message]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: json) else { return }
        guard let url = URL(string: "https://api.telegram.org/bot\(token)/sendMessage") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { TTBaseFunc.shared.printLog(object: error?.localizedDescription ?? "No data"); return }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] { TTBaseFunc.shared.printLog(object: "Tele response: \(responseJSON)") }
        }
        task.resume()
    }
}
