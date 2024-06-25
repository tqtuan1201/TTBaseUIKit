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
    
    func embeddedInHostingController(isHiddenTabbar:Bool = true) -> TTBaseHostingController<some View> {
        let provider = ViewControllerProvider()
        let hostingAccessingView = environmentObject(provider)
        let hostingController = TTBaseHostingController(shouldShowNavigationBar: false, isSetHiddenTabar: isHiddenTabbar, rootView: hostingAccessingView)
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
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        if self.isSetHiddenTabar { self.tabBarController?.tabBar.isHidden = true ; self.hidesBottomBarWhenPushed = true }
    }
    
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if self.isSetHiddenTabar { self.tabBarController?.tabBar.isHidden = false ; self.hidesBottomBarWhenPushed = false }
    }
    
    public init(shouldShowNavigationBar: Bool, isSetHiddenTabar:Bool = true, rootView: Content) {
        self.isSetHiddenTabar = isSetHiddenTabar
        super.init(rootView: AnyView(rootView.navigationBarHidden(!shouldShowNavigationBar)))
    }
    
    @objc required dynamic public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

