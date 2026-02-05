//
//  File.swift
//  
//
//  Created by TuanTruong on 18/10/2023.
//

import UIKit
import Foundation
import SwiftUI

public extension View {
    
    func embeddedInHostingController(isHiddenTabbar:Bool = true, statusBarStyle: UIStatusBarStyle = .darkContent) -> TTBaseHostingController<some View> {
        let provider = ViewControllerProvider()
        let hostingAccessingView = environmentObject(provider)
        let hostingController = TTBaseHostingController(shouldShowNavigationBar: false, isSetHiddenTabar: isHiddenTabbar, statusBarStyle: statusBarStyle, rootView: hostingAccessingView)
        provider.viewController = hostingController
        return hostingController
    }
    
}

public final class ViewControllerProvider: ObservableObject {
    fileprivate(set) weak var viewController: UIViewController?
}

public extension ViewControllerProvider  {
    func getCurrentVC() -> UIViewController? {
        return self.viewController
    }
}


open class TTBaseHostingController <Content>: UIHostingController<AnyView> where Content : View {
    
    fileprivate var isSetHiddenTabar:Bool = true
    
    var statusBarStyle: UIStatusBarStyle = .lightContent

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.statusBarStyle
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        self.setupTabbar()
    }
    
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        self.setupTabbar()
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabbar()
    }
    
    private func setupTabbar() {
        if self.isSetHiddenTabar {
            self.hidesBottomBarWhenPushed = true
            self.tabBarController?.tabBar.isHidden = true
        } else {
            self.hidesBottomBarWhenPushed = false
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    public init(shouldShowNavigationBar: Bool, isSetHiddenTabar:Bool = true, statusBarStyle:UIStatusBarStyle, rootView: Content) {
        self.isSetHiddenTabar = isSetHiddenTabar
        self.statusBarStyle = statusBarStyle
        super.init(rootView: AnyView(rootView.navigationBarHidden(!shouldShowNavigationBar)))
    }
    
    @objc required dynamic public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

