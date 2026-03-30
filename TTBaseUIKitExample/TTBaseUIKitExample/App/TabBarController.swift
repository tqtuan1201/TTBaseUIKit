//
//  TabbarTestVC.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 3/2/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import TTBaseUIKit


class MyTabBarController: UITabBarController {
    
    let menu:MenuViewController = MenuViewController()
    let webVC:ContactVC = ContactVC()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create your view controllers
        let firstViewController = UINavigationController(rootViewController: self.menu)
        let secondViewController = UINavigationController(rootViewController: self.webVC)

        // Set the view controllers for the tab bar controller
        self.viewControllers = [firstViewController, secondViewController]
        
        // Set titles and icons for the tab bar items
        firstViewController.tabBarItem = UITabBarItem(title: "Menu", image: UIImage(systemName: "filemenu.and.selection"), tag: 0)
        secondViewController.tabBarItem = UITabBarItem(title: "Contact", image: UIImage.init(systemName: "person.crop.circle.fill"), tag: 1)
    }
}

import SwiftUI
struct HomeTableViewController_Previews: PreviewProvider {
    static var previews: some View {
        TTBaseUIViewControllerPreview {
            let vc = MyTabBarController()
            return vc
        }
    }
}
