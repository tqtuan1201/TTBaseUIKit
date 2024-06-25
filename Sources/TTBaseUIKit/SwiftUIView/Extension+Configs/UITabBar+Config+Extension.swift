//
//  File.swift
//  
//
//  Created by TuanTruong on 18/10/2023.
//

import Foundation
import SwiftUI
import UIKit

//MARK: For ViewModifier
public struct ShowTabBar: ViewModifier {
    public var animated = true
    public func body(content: Content) -> some View {
        return content.padding(.zero).onAppear {
            UITabBar.showTabBar(animated: animated)
        }
    }
}

public struct HiddenTabBar: ViewModifier {
    public var animated = true

    public func body(content: Content) -> some View {
        return content.padding(.zero).onAppear {
            UITabBar.hideTabBar(animated: animated)
        }
    }
}

//MARK: For Showing/Hiding Tab Bar
public extension View {
    
    func showTabBar(animated: Bool = true) -> some View {
        return self.modifier(ShowTabBar(animated: animated))
    }
    
    func hideTabBar(animated: Bool = true) -> some View {
        return self.modifier(HiddenTabBar(animated: animated))
    }

    func shouldHideTabBar(_ hidden: Bool, animated: Bool = true) -> AnyView {
        if hidden {
            return AnyView(hideTabBar(animated: animated))
        } else {
            return AnyView(showTabBar(animated: animated))
        }
    }
}

public extension UITabBar {

    // if tab View is used get tabBar 'isHidden' parameter value
    static func isHidden(_ completion: @escaping (Bool) -> Void)  {
        DispatchQueue.main.async {
            UIApplication.getKeyWindow()?.subviewsRecursive().forEach({ (v) in
                if let view = v as? UITabBar {
                    completion(view.isHidden)
                }
            })
        }
    }

    static func hideTabBar(animated: Bool = true) {
          DispatchQueue.main.async {
              UIApplication.getKeyWindow()?.subviewsRecursive().forEach({ (v) in
                  if let view = v as? UITabBar {
                      view.isHidden = animated
                  }
              })
          }
      }
 
    
    // if tab View is used toogle Tab Bar Visibility
    static func toogleTabBarVisibility(animated: Bool = true) {
        UITabBar.isHidden { isHidden in
            if isHidden {
                UITabBar.showTabBar(animated: animated)
            }
            else {
                UITabBar.hideTabBar(animated: animated)
            }
        }
    }

    // if tab View is used show Tab Bar
    static func showTabBar(animated: Bool = true) {
        DispatchQueue.main.async {
            UIApplication.getKeyWindow()?.subviewsRecursive().forEach({ (v) in
                if let view = v as? UITabBar {
                    view.setIsHidden(false, animated: animated)
                }
            })
        }
    }
    
    private static func updateFrame(_ view: UIView) {
        if let sv =  view.superview {
            let currentFrame = sv.frame
            sv.frame = currentFrame.insetBy(dx: 0, dy: 1)
            sv.frame = currentFrame
        }
    }

    // logic is implemented for hiding or showing the tab bar with animation
    private func setIsHidden(_ hidden: Bool, animated: Bool) {
        let isViewHidden = self.isHidden

        if animated {
            if self.isHidden && !hidden {
                self.isHidden = false
                Self.updateFrame(self)
                self.frame.origin.y = UIScreen.main.bounds.height + 200
            }

            if isViewHidden && !hidden {
                self.alpha = 0.0
            }

            UIView.animate(withDuration: 0.8, animations: {
                self.alpha = hidden ? 0.0 : 1.0
            })
            UIView.animate(withDuration: 0.6, animations: {

                if !isViewHidden && hidden {
                    self.frame.origin.y = UIScreen.main.bounds.height + 200
                }
                else if isViewHidden && !hidden {
                    self.frame.origin.y = UIScreen.main.bounds.height - self.frame.height
                }
            }) { _ in
                if hidden && !self.isHidden {
                    self.isHidden = true
                    Self.updateFrame(self)
                }
            }
        } else {
            if !isViewHidden && hidden {
                self.frame.origin.y = UIScreen.main.bounds.height + 200
            }
            else if isViewHidden && !hidden {
                self.frame.origin.y = UIScreen.main.bounds.height - self.frame.height
            }
            self.isHidden = hidden
            Self.updateFrame(self)
            self.alpha = 1
        }
    }
    
}
