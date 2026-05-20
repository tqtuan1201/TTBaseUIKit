//
//  AppCoordinator.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import UIKit
import SwiftUI
import TTBaseUIKit


class TabWebViewController : WebViewController {
    override var isSetHiddenTabar: Bool {  return false}
}

// MARK: - AppCoordinator
/// Root coordinator. Sets up the TabBarController and child coordinators.
class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        let tabBarController = UITabBarController()
        
        // Menu Tab
        let menuNav = UINavigationController()
        let menuCoordinator = MenuCoordinator(navigationController: menuNav)
        addChild(menuCoordinator)
        menuCoordinator.start()
        menuNav.tabBarItem = UITabBarItem(title: "Menu", image: UIImage(systemName: "filemenu.and.selection"), tag: 0)
        
        // Demo Features Tab (SwiftUI — manages its own NavigationView)
        let demoFeaturesVC = DemoFeaturesView().embeddedInHostingController(isHiddenTabbar: false)
        demoFeaturesVC.tabBarItem = UITabBarItem(title: "Demos", image: UIImage(systemName: "sparkles.rectangle.stack.fill"), tag: 1)
        
        // DebugBridge Tab (SwiftUI — demos TTDebugBridge API logging to TTBDebugPlus macOS)
        let debugBridgeVC = DebugBridgeDemoView().embeddedInHostingController(isHiddenTabbar: false)
        debugBridgeVC.tabBarItem = UITabBarItem(title: "DebugBridge", image: UIImage(systemName: "antenna.radiowaves.left.and.right"), tag: 2)
        
        // UI Debug Tab (SwiftUI — launch TTBaseDebugKit in-app debugging tools)
        let debugUIVC = DebugUIDemoView().embeddedInHostingController(isHiddenTabbar: false)
        debugUIVC.tabBarItem = UITabBarItem(title: "UI Debug", image: UIImage(systemName: "eye.trianglebadge.exclamationmark"), tag: 3)
        
        // Doc Tab
        let docNav = UINavigationController()
        let docVC = TabWebViewController(navTitle: "TTBaseUIKit Doc", urlString: "https://tqtuan1201.github.io/public/docs/ttbaseuikit/index.html")
        docNav.viewControllers = [docVC]
        docNav.tabBarItem = UITabBarItem(title: "Doc", image: UIImage(systemName: "filemenu.and.selection"), tag: 4)
        
        
        // Contact Tab
        let contactNav = UINavigationController()
        let contactVC = ContactVC()
        contactNav.viewControllers = [contactVC]
        contactNav.tabBarItem = UITabBarItem(title: "Contact", image: UIImage(systemName: "person.crop.circle.fill"), tag: 5)
        
        tabBarController.viewControllers = [menuNav, demoFeaturesVC, debugBridgeVC, debugUIVC, docNav]
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
