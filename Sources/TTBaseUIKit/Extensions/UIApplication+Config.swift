//
//  UIApplication+Config.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/11/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    public class func topViewController(controller: UIViewController? = UIApplication.getKeyWindow()?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    public class func getKeyWindow() -> UIWindow? {
        if #available(iOS 13, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                // Get the first window of the scene
                if let window = windowScene.windows.first {
                    // Use the window object
                    return window
                } else {
                    return UIApplication.shared.windows.first { $0.isKeyWindow }
                }
            } else {
                return UIApplication.shared.windows.first { $0.isKeyWindow }
            }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    public class func getStatusBarFrame() -> CGFloat {
        
        if #available(iOS 13.0, *) {
            let statusBarHeight = UIApplication.getKeyWindow()?.windowScene?.statusBarManager?.statusBarFrame.height
            return statusBarHeight ?? UIApplication.shared.statusBarFrame.height
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    public static var safeAreaInsets: UIEdgeInsets  {
        return UIApplication.getKeyWindow()?.safeAreaInsets ?? .zero
    }
}

