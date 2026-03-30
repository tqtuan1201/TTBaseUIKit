//
//  MenuCoordinator.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import UIKit
import SwiftUI
import TTBaseUIKit

// MARK: - MenuCoordinator
/// Handles all navigation from the Menu screen.
/// Extracts 200+ lines of navigation logic from MenuViewController.
class MenuCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let menuVC = MenuViewController()
        menuVC.coordinator = self
        navigationController.viewControllers = [menuVC]
    }
    
    // MARK: - UIKit Navigation
    
    func showThemeInfo() {
        showMessagePopup(mess: "In the AppDelegate class, find TTBaseUIKitConfig.withDefaultConfig where you will see a basic example of the setup") { [weak self] in
            self?.showWebView(title: "AppDelegate class", url: "https://raw.githubusercontent.com/tqtuan1201/TTBaseUIKit/master/TTBaseUIKitExample/TTBaseUIKitExample/AppDelegate.swift")
        }
    }
    
    func showDemoViewController() {
        let baseVC = DemoViewController(backType: .BACK_POP)
        navigationController.pushViewController(baseVC, animated: true)
    }
    
    func showBaseTableViewController() {
        let baseVC = BaseTableViewController()
        navigationController.pushViewController(baseVC, animated: true)
    }
    
    func showBaseCollectionViewController() {
        let baseCollectionVC = BaseColllectionViewViewController()
        navigationController.pushViewController(baseCollectionVC, animated: true)
    }
    
    func showCustomFlowLayoutCollectionViewController() {
        let baseCollectionVC = BaseCustomFlowLayoutColllectionViewController()
        navigationController.pushViewController(baseCollectionVC, animated: true)
    }
    
    func showBaseComponentsViewController() {
        let baseComponents = BaseComponentsViewController()
        navigationController.pushViewController(baseComponents, animated: true)
    }
    
    func showAutoLayoutDemo() {
        let baseContrainsVC = BaseSetupContraintsViewController()
        navigationController.pushViewController(baseContrainsVC, animated: true)
    }
    
    func showAdvanceAutoLayoutDemo() {
        let advanceVC = AdvanceSetupContraintsViewController()
        navigationController.pushViewController(advanceVC, animated: true)
    }
    
    func showCalendarPopup(fromDate: Date, toDate: Date, onSelect: @escaping (Date, Date) -> Void) {
        let calendarView = CalendarPopupViewController(withPeriodTime: fromDate, toDate: toDate)
        if let topVC = navigationController.topViewController {
            topVC.presentDef(vc: calendarView)
        }
        calendarView.onDidSelectPeriodDate = { (from, to) in
            onSelect(from, to)
        }
    }
    
    func showEmptyTableDemo() {
        let emptyVC = EmptyTableViewController()
        navigationController.pushViewController(emptyVC, animated: true)
    }
    
    func showSkeletonUIKitDemo() {
        let skeletonVC = SkeletonTableViewController()
        navigationController.pushViewController(skeletonVC, animated: true)
    }
    
    func showCoverPresentDemo() {
        let vc = CoverPresentViewController()
        navigationController.topViewController?.present(vc, animated: true)
    }
    
    func showDatePickerDemo() {
        let vc = DatePickerViewController()
        navigationController.topViewController?.present(vc, animated: true)
    }
    
    func showPopupDemo() {
        let popupVC = TTPopupViewController(title: "SOMETHING LIKE THIS", subTitle: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has b", isAllowTouchPanel: true)
        navigationController.topViewController?.present(popupVC, animated: true)
    }
    
    func showMessageDemo(didSelectType: @escaping (TTBaseNotificationViewConfig.POSITION) -> Void) {
        let messageView = ShowMessageViewController()
        messageView.didSelectType = didSelectType
        navigationController.topViewController?.present(messageView, animated: true)
    }
    
    func showCellTypeDemo() {
        navigationController.pushViewController(CellTypeTableViewController(), animated: true)
    }
    
    func showTestViewController() {
        // Removed: TestViewController was scratch code
    }
    
    // MARK: - Web Navigation
    
    func showWebView(title: String, url: String) {
        let webVC = WebViewController(navTitle: title, urlString: url)
        navigationController.pushViewController(webVC, animated: true)
    }
    
    // MARK: - SwiftUI Navigation
    
    func showSwiftUIDemo(type: MenuFunction.TYPE) {
        var hostVC: UIViewController?
        
        switch type {
        case .BASE_SWIFTUI_VIEW:
            hostVC = BaseSwiftUINavView().embeddedInHostingController()
        case .BASE_SWIFTUI_BUTTON:
            hostVC = BaseSwiftUIButtonDemo().embeddedInHostingController()
        case .BASE_SWIFTUI_TEXT:
            hostVC = BaseSwiftUITextDemo().embeddedInHostingController()
        case .BASE_SWIFTUI_IMAGE:
            hostVC = BaseSwiftUIImageDemo().embeddedInHostingController()
        case .BASE_SWIFTUI_STACK:
            hostVC = BaseSwiftUIStackDemo().embeddedInHostingController()
        case .BASE_SWIFTUI_SCROLL_STACK:
            hostVC = BaseSwiftUIScrollStackDemo().embeddedInHostingController()
        case .BASE_SWIFTUI_SPACER:
            hostVC = BaseSwiftUISpacerDemo().embeddedInHostingController()
        case .BASE_SWIFTUI_DIVIDER:
            hostVC = BaseSwiftUIDividerDemo().embeddedInHostingController()
        case .BASE_SWIFTUI_NEW_VERSION:
            hostVC = BaseSwiftUINewVersionDemo().embeddedInHostingController()
        case .ANIMATION_SKELETON_SWIFTUI:
            hostVC = BaseSwiftUISkeletonScrollStackDemo().embeddedInHostingController()
        case .PRODUCT_CATALOG:
            hostVC = ProductCatalogView().embeddedInHostingController()
        default: break
        }
        
        if let vc = hostVC {
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - Utility Navigation
    
    func showFuncsInfo() {
        showMessagePopup(mess: "TTBaseUIKit provides common handling functions for String, Date, Json, Device, Language, VietNamLunar , Validation, NetworkSpeedTest") { }
    }
    
    func showDebugUI() {
        showMessagePopup(mess: "Long touch to show Dev Mode View, Tap three times to activate UI debugging,\nSet a passcode if you need authentication") {
            LogViewHelper.share.config(withDes: "TTBaseDebugKit provides developers with powerful in-app tools for inspecting UI, tracking logs, and simulating environments—making debugging faster, easier, and more efficient", isStartAppToShow: false, passCode: "").onShow()
        }
    }
    
    func showJailbreakChecker() {
        let result = TTBaseJailbreakDetector.shared.detectJailbreak()
        print("MenuCoordinator JAILBREAK_CHECKER result: \(result)")
        navigationController.topViewController?.showAlert("Jailbreak_checker result: \(result)")
    }
    
    func showMoreInfo() {
        showWebView(title: "HI, I'M TUAN TRUONG", url: "https://tqtuan1201.github.io/tags/ttbaseuikit/")
    }
    
    // MARK: - Private Helpers
    
    fileprivate func showMessagePopup(mess: String, completeHandle: @escaping () -> Void) {
        navigationController.topViewController?.showPopupConfirm(
            withText: "Message",
            subTitle: mess,
            leftButton: nil,
            rightButton: "OK",
            onTouchAgreeHandle: { completeHandle() }
        )
    }
}
