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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let view:ViewConfig = ViewConfig()
        view.viewBgNavColor = UIColor.getColorFromHex.init(netHex: 0x4DA0DC)
        view.viewBgLoadingColor = UIColor.red
        
        view.buttonBgDef = UIColor.getColorFromHex.init(netHex: 0x4DA0DC)
        view.buttonBgWar = UIColor.getColorFromHex.init(netHex: 0xC41F53)
        view.buttonBgDis = UIColor.gray.withAlphaComponent(0.4)
        view.labelBgDef = UIColor.getColorFromHex.init(netHex: 0x4DA0DC)
        view.labelBgWar = UIColor.getColorFromHex.init(netHex: 0xC41F53)
        view.lineDefColor = UIColor.getColorFromHex(netHex: 0xEDEDED)
        view.lineActiveColor = UIColor.getColorFromHex(netHex: 0x1F47D6)
        view.iconRightTextFieldColor = XView.buttonBgWar
        view.viewBgCellColor = UIColor.white//UIColor.getColorFromHex.init(netHex: 0xD1D4D8)
        view.textWarringColor = UIColor.getColorFromHex.init(netHex: 0xEF4C23)

        let fontConfig:FontConfig = FontConfig()
        
        if Device.size() <= .screen5_8Inch {
            fontConfig.HEADER_SUPER_H = 24
            fontConfig.HEADER_H = 18
            fontConfig.TITLE_H = 14
            fontConfig.SUB_TITLE_H = 12
            fontConfig.SUB_SUB_TITLE_H = 10
        }
        else {
            fontConfig.HEADER_SUPER_H = 24
            fontConfig.HEADER_H = 18
            fontConfig.TITLE_H = 16
            fontConfig.SUB_TITLE_H = 14
            fontConfig.SUB_SUB_TITLE_H = 12
        }
      
        let sizeConfig:SizeConfig = SizeConfig()
        
        sizeConfig.W_BUTTON = 147.0
        sizeConfig.H_TEXTFIELD = 50.0
        sizeConfig.H_BUTTON = 50.0
        sizeConfig.H_SEARCH_BAR = 46.0
        sizeConfig.CORNER_RADIUS = 8.0
        sizeConfig.CORNER_BUTTON = 8.0
        sizeConfig.H_SMALL_ICON = 26.0
        //sizeConfig.H_BUTTON = Device.size() <= .screen4Inch ? 40 : 50.0
        
        let styleConfig:StyleConfig = StyleConfig()
        styleConfig.dismissKeyboardType = .TEXT
        
        TTBaseUIKitConfig.withDefaultConfig(withFontConfig: fontConfig, frameSize: sizeConfig, view: view, style: styleConfig)?.start(withViewLog: true)
        
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        //self.window!.rootViewController = UINavigationController.init(rootViewController: TestViewController())
        self.window!.rootViewController = UINavigationController.init(rootViewController: MenuViewController())
        
        self.window!.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
























































