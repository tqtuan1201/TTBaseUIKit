//
//  TTBaseCheckNewVersion.swift
//  TTBaseUIKit
//
//  Created by TuanTruong on 26/11/25.
//

import Foundation
import UIKit
import StoreKit

public enum VersionError: Error {
    case invalidBundleInfo, invalidResponse
}

public class LookupResult: Decodable, Encodable {
    public var trackId: Int?
    public var trackViewUrl: String?
    public var results: [AppInfo]?
    public var resultCount: Int?
    
    public init() {}
}

public class AppInfo: Decodable, Encodable {
    public var version: String?
    public var trackViewUrl: String?
    public var releaseDate:String?
    public var releaseNotes:String?
    public var trackId: Int?
    
    public init() {}
}

public class TTBaseCheckNewVersion: NSObject {
    
    public static let shared = TTBaseCheckNewVersion()
    
    public func onCheckNewVersion(completion: @escaping(_ hasNewVersion:Bool,_ info:AppInfo?) -> Void) {
        DispatchQueue.global().async {
            self.checkVersion { (hasNewVersion, info) in completion(hasNewVersion, info)}
        }
    }
    
    public func onCheck() {
        self.onCheckNewVersion { hasNewVersion, info in
            DispatchQueue.main.async {
                if hasNewVersion && TTBaseUIKitSharedData.share.isShowedNewVersionPopup == false {
                    
                    var message:String = "TTBaseUIkit.NewVersion.SubTitle".localize(def: "This update brings enhanced performance and optimized stability. Update now to get the most out of the app.")
                    if let messageByApptore = info?.releaseNotes, !messageByApptore.isEmpty, TTBaseUIKitConfig.getParamConfig().isGetNewVersionMessageByAppStore {
                        message = messageByApptore
                    }
                    
                    let newVersionVC = TTBaseNewVersionPopupView.init(subTitle: message, isPresented: .constant(true), autoDismissAfter: 5.0) {
                        self.openAppStore()
                        TTBaseUIKitSharedData.share.isShowedNewVersionPopup = true
                    } laterHandle: {
                        TTBaseUIKitSharedData.share.isShowedNewVersionPopup = true
                    }.embeddedInHostingController(isHiddenTabbar: true)

                    newVersionVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.22)
                    UIApplication.topViewController()?.presentDef(vc: newVersionVC, type: .overFullScreen, transitionStyle: .crossDissolve, isAnimation: true)
                }
            }
        }
    }
    
    // Open App Store app directly
    public func openAppStore(appId: String) {
        let urlString = "itms-apps://itunes.apple.com/app/id\(appId)"
        if let url = URL(string: urlString) {
            DispatchQueue.main.async {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }

    // Present in-app App Store product page (StoreKit)
    public func presentStoreProduct(appId: String, from viewController: UIViewController? = nil) {
        DispatchQueue.main.async {
            let storeVC = SKStoreProductViewController()
            let params: [String: Any] = [SKStoreProductParameterITunesItemIdentifier: NSNumber(value: Int(appId) ?? 1191396802)]
            storeVC.loadProduct(withParameters: params) { success, error in
                DispatchQueue.main.async {
                    if success {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            (viewController ?? UIApplication.topViewController())?.presentDef(vc: storeVC, type: .overFullScreen, transitionStyle: .coverVertical)
                        }
                    } else {
                        // fallback: open App Store app
                        self.openAppStore(appId: String(appId))
                    }
                }
            }
        }
    }
    
    public func openAppStoreForBundle(_ bundleId: String = Bundle.main.bundleIdentifier  ?? "", preferredCountry: String = "us") {
        // iTunes Lookup API
        let encoded = bundleId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? bundleId
        let lookupURLString = "https://itunes.apple.com/lookup?bundleId=\(encoded)&country=\(preferredCountry)"
        guard let url = URL(string: lookupURLString) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                TTBaseFunc.shared.printLog(object: "Lookup error: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                TTBaseFunc.shared.printLog(object: "No data from lookup")
                return
            }
            do {
                let decoded = try JSONDecoder().decode(LookupResult.self, from: data)
                if let trackId = decoded.results?.first?.trackId {
                    DispatchQueue.main.async {
                        //self.openAppStore(appId: String(trackId))
                        self.presentStoreProduct(appId: String(trackId))
                    }
                } else {
                    // fallback: if trackViewUrl available, open it in browser
                    if let urlString = decoded.results?.first?.trackViewUrl, let webUrl = URL(string: urlString) {
                        DispatchQueue.main.async {
                            UIApplication.shared.open(webUrl, options: [:], completionHandler: nil)
                        }
                    } else {
                        TTBaseFunc.shared.printLog(object: "App not found on App Store for bundleId: \(bundleId)")
                    }
                }
            } catch {
                TTBaseFunc.shared.printLog(object: "cannot parse json data")
            }
        }
        task.resume()
    }
    
}

extension TTBaseCheckNewVersion {
    
    private func openAppStore() {
        if TTParam.appId.isEmpty {
            TTBaseCheckNewVersion.shared.openAppStoreForBundle()
        } else {
            //self.openAppStore(appId: TTParam.appId)
            self.presentStoreProduct(appId: TTParam.appId)
        }
    }
    
    private func checkVersion(completion: @escaping(_ hasNewVersion:Bool,_ info:AppInfo?) -> Void) {
        if let currentVersion = self.getBundle(key: "CFBundleShortVersionString")?.trimming() {
            self.getAppInfo { (info, error) in
                if let appStoreAppVersion = info?.version?.trimming() {
                    TTBaseFunc.shared.printLog(object: "::CheckUpdateFromAppStore currentVersion: \(currentVersion)")
                    TTBaseFunc.shared.printLog(object: "::CheckUpdateFromAppStore appStoreAppVersion: \(appStoreAppVersion)")
                    
                    if let _ = error {
                        completion(false, nil)
                    } else if currentVersion.compare(appStoreAppVersion, options: .numeric) == .orderedAscending {
                        
                        //get releaseDate
                        if let date = info?.releaseDate?.reFormatDateByRemoveTimeZ().toDate(withFormat: .YYYY_MM_DD_T_HH_MM_SS_Z, timeZone: TimeZone.current) {
                            if date.dateByAddingHours(TTBaseUIKitConfig.getParamConfig().delayTimeCheckNewVersion).compareByDate(date: Date()) == .orderedAscending {
                                completion(true, info)
                            }
                        // cannot get releaseDate
                        } else {
                            completion(true, info)
                        }
                    } else {completion(false, nil) }
                } else {
                    completion(false, nil)
                }
            }?.resume()
        } else {
            completion(false, nil)
        }
    }
    
    private func getAppInfo(completion: @escaping(AppInfo?, Error?) -> Void) -> URLSessionDataTask? {
        guard let identifier = Bundle.main.bundleIdentifier,
              let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
            DispatchQueue.main.async {
                completion(nil, VersionError.invalidBundleInfo)
            }
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw VersionError.invalidResponse }
                
                let result = try JSONDecoder().decode(LookupResult.self, from: data)
                guard let info = result.results?.first else { throw VersionError.invalidResponse }
                TTBaseFunc.shared.printLog(object: "::CheckUpdateFromAppStore data response: \(info)")
                completion(info, nil)
            } catch {
                TTBaseFunc.shared.printLog(object: "::CheckUpdateFromAppStore data error: \(error.localizedDescription)")
                completion(nil, error)
            }
        }
        return task
    }
    
    private func getBundle(key: String) -> String? {
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else { return nil }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: key) as? String else { return nil }
        return value
    }
}
