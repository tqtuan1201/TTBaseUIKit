//
//  AppDelegate.swift
//  TTBaseUIKitExample
//
//  Created by Truong Quang Tuan on 4/6/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import UIKit
import TTBaseUIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // MARK: - Configure TTBaseUIKit Design System
        let view = ViewConfig()
        view.viewBgNavColor = UIColor.getColorFromHex(netHex: 0x4DA0DC)
        view.viewBgLoadingColor = UIColor.red
        view.buttonBgDef = UIColor.getColorFromHex(netHex: 0x4DA0DC)
        view.buttonBgWar = UIColor.getColorFromHex(netHex: 0xC41F53)
        view.buttonBgDis = UIColor.gray.withAlphaComponent(0.4)
        view.labelBgDef = UIColor.getColorFromHex(netHex: 0x4DA0DC)
        view.labelBgWar = UIColor.getColorFromHex(netHex: 0xC41F53)
        view.lineDefColor = UIColor.getColorFromHex(netHex: 0xEDEDED)
        view.lineActiveColor = UIColor.getColorFromHex(netHex: 0x1F47D6)
        view.iconRightTextFieldColor = XView.buttonBgWar
        view.viewBgCellColor = UIColor.white
        view.textWarringColor = UIColor.getColorFromHex(netHex: 0xEF4C23)

        let fontConfig = FontConfig()
        if Device.size() <= .screen5_8Inch {
            fontConfig.HEADER_SUPER_H = 24; fontConfig.HEADER_H = 18
            fontConfig.TITLE_H = 14; fontConfig.SUB_TITLE_H = 12; fontConfig.SUB_SUB_TITLE_H = 10
        } else {
            fontConfig.HEADER_SUPER_H = 24; fontConfig.HEADER_H = 18
            fontConfig.TITLE_H = 16; fontConfig.SUB_TITLE_H = 14; fontConfig.SUB_SUB_TITLE_H = 12
        }
      
        let sizeConfig = SizeConfig()
        sizeConfig.W_BUTTON = 147.0; sizeConfig.H_TEXTFIELD = 50.0
        sizeConfig.H_BUTTON = 50.0; sizeConfig.H_SEARCH_BAR = 46.0
        sizeConfig.CORNER_RADIUS = 8.0; sizeConfig.CORNER_BUTTON = 8.0; sizeConfig.H_SMALL_ICON = 26.0
        
        let styleConfig = StyleConfig()
        styleConfig.dismissKeyboardType = .TEXT
        
        let paramsConfig = ParamConfig()
        paramsConfig.forceUpdateNewVersion = false
        
        TTBaseUIKitConfig.withDefaultConfig(withFontConfig: fontConfig, frameSize: sizeConfig, view: view, style: styleConfig, params: paramsConfig)?.start(withViewLog: true)
        
        // MARK: - Start App via Coordinator
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.appCoordinator = AppCoordinator(window: self.window!)
        self.appCoordinator?.start()
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            // Optional: Custom configuration
            var config = TTDebugBridge.Config()
            config.heartbeatInterval = 3.0  // seconds
            config.maxBufferedMessages = 500
            TTDebugBridge.shared.config = config
            TTDebugBridge.shared.start()
            // Optional: Monitor connection state
            TTDebugBridge.shared.onStateChange = { state in
                print("[Debug] Bridge state: \(state.rawValue)")
                // States: idle → browsing → connecting → connected
            }
        }
        
        return true
    }
}
