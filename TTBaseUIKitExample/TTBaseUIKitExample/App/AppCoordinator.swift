//
//  AppCoordinator.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import UIKit
import TTBaseUIKit

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
        
        // Contact Tab
        let contactNav = UINavigationController()
        let contactVC = ContactVC()
        contactNav.viewControllers = [contactVC]
        contactNav.tabBarItem = UITabBarItem(title: "Contact", image: UIImage(systemName: "person.crop.circle.fill"), tag: 1)
        
        tabBarController.viewControllers = [menuNav, contactNav]
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
