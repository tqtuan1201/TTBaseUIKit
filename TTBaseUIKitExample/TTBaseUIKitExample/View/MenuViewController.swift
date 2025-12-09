//
//  BaseSwiftUISpacerDemo.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 3/8/24.
//  Copyright © 2024 Truong Quang Tuan. All rights reserved.
//

import Foundation
import TTBaseUIKit

struct MenuFuction {
    
    enum TYPE {
        case THEME
        case BASE_TABLE_VIEW_EMPTY
        case BASE_COLLECTIONVIEW
        case BASE_CUSTOM_FLOWLAYOUT_COLLECTIONVIEW
        case BASE_CALENDAR
        case BASE_TABLE_VIEW_CELL
        case BASE_VIEWCONTROLLER
        case BASE_TABLE_VIEW_CONTROLLER
        case BASE_COLLECTION_VIEW_CELL
        case BASE_AUTO_LAYOUT
        case BASE_ADVANCE_AUTO_LAYOUT
        case BASE_MESSAGE
        case BASE_POPUP
        case BASE_PRESENT_VC
        case BASE_PICKER
        case BASE_TEST
        case BASE_COMPONENTS
        
        case ANIMATION_SKELETON_UIKIT
        case ANIMATION_SKELETON_SWIFTUI
        
        case BASE_SWIFTUI_VIEW
        case BASE_SWIFTUI_BUTTON
        case BASE_SWIFTUI_TEXT
        case BASE_SWIFTUI_IMAGE
        case BASE_SWIFTUI_STACK
        case BASE_SWIFTUI_SPACER
        case BASE_SWIFTUI_SCROLL_STACK
        case BASE_SWIFTUI_DIVIDER
        
        case BASE_SWIFTUI_NEW_VERSION
        
        case BASE_FUNCS
        case DEBUG_UI
        case JAILBREAK_CHECKER
        
    }
    
    let type:TYPE
    let name:String
    let des:String
    let image:String = ""
    
    func getImage() -> String {
        switch self.type {
        case .THEME:
            return "gear"
        case .BASE_TABLE_VIEW_EMPTY:
            return "layout"
        case .BASE_COLLECTIONVIEW:
            return "layout"
        case .BASE_CUSTOM_FLOWLAYOUT_COLLECTIONVIEW:
            return "layout"
        case .BASE_TABLE_VIEW_CELL:
            return "row"
        case .BASE_COLLECTION_VIEW_CELL:
            return "row"
        case .BASE_MESSAGE:
            return "chat"
        case .BASE_POPUP:
            return "web-browser"
        case .BASE_PRESENT_VC:
            return "web-browser"
        case .BASE_PICKER:
            return "calendar"
        case .BASE_TEST:
            return "row"
        case .BASE_VIEWCONTROLLER:
            return "TTBaseUIKit"
        case .BASE_TABLE_VIEW_CONTROLLER:
            return "TTBaseUIKit"
        case .BASE_COMPONENTS:
            return "row"
        case .BASE_AUTO_LAYOUT:
            return "row"
        case .BASE_ADVANCE_AUTO_LAYOUT:
            return "row"
        case .BASE_CALENDAR:
            return "row"
        case .BASE_SWIFTUI_VIEW:
            return "row"
        case .BASE_SWIFTUI_BUTTON:
            return "row"
        case .BASE_SWIFTUI_TEXT:
            return "row"
        case .BASE_SWIFTUI_IMAGE:
            return "row"
        case .BASE_SWIFTUI_STACK:
            return "row"
        case .BASE_SWIFTUI_SPACER:
            return "row"
        case .BASE_FUNCS:
            return "row"
        case .BASE_SWIFTUI_SCROLL_STACK:
            return "row"
        case .BASE_SWIFTUI_DIVIDER:
            return "row"
            
        case .DEBUG_UI:
            return "debugging"
            
        case .JAILBREAK_CHECKER:
            return "mobile-device"
        default:
            return "row"
        }
    }
    
    static func getConfig() -> [MenuFuction] {
        var menus:[MenuFuction] = []
        menus.append(MenuFuction(type: .THEME, name: "Setup Basic Theme", des: "You can customize colors for buttons, labels, and more using ViewConfig, for buttons, labels, navigation using SizeConfig. for font sizes for titles, subtitles, and headers using FontConfig."))
        return menus
    }
    
    static func getUIKIT() -> [MenuFuction] {
        var menus:[MenuFuction] = []
        menus.append(MenuFuction(type: .BASE_COMPONENTS,name: "Base Components", des:"Base Cover Present Controller is to promote code reuse and maintainability by centralizing common functionality"))
        menus.append(MenuFuction(type: .BASE_CALENDAR,name: "Base Calendar", des:"A custom visual calendar"))
        menus.append(MenuFuction(type: .BASE_VIEWCONTROLLER,name: "Base View Controller", des: "Base View Controller is to promote code reuse and maintainability by centralizing common functionality"))
        menus.append(MenuFuction(type: .BASE_TABLE_VIEW_CONTROLLER,name: "Base Table Controller", des: "Base Table Controller is to promote code reuse and maintainability by centralizing common functionality"))
        menus.append(MenuFuction(type: .BASE_COLLECTIONVIEW,name: "Base Collection View Controller", des: "Base Collection View Controller is to promote code reuse and maintainability by centralizing common functionality"))
        menus.append(MenuFuction(type: .BASE_CUSTOM_FLOWLAYOUT_COLLECTIONVIEW,name: "Base Custom Collection View Controller", des: "Automatic cell height in a UICollectionView using a custom UICollectionViewFlowLayout"))
        menus.append(MenuFuction(type: .BASE_PRESENT_VC,name: "Base Cover Present Controller", des:"Base Cover Present Controller is to promote code reuse and maintainability by centralizing common functionality"))
        menus.append(MenuFuction(type: .BASE_AUTO_LAYOUT,name: "Base Auto Layout", des:"TTBaseUIKit to make easy Auto Layout. This framework provides some functions to setup and update constraints."))
        menus.append(MenuFuction(type: .BASE_ADVANCE_AUTO_LAYOUT,name: "Constraints Setup Sample", des:"TTBaseUIKit to make easy Auto Layout. This framework provides some functions to setup and update constraints."))
        
        menus.append(MenuFuction(type: .BASE_TABLE_VIEW_CELL,name: "Custom TableViewCell", des: "View all custom tableviewcell type"))
        menus.append(MenuFuction(type: .BASE_MESSAGE,name: "Messase Alter", des: "Same push notification by ios"))
        menus.append(MenuFuction(type: .BASE_POPUP,name: "POPUP_VIEW", des: "show popup alter view"))
        menus.append(MenuFuction(type: .BASE_PICKER,name: "DATE_PICKER", des: "Choose date time from popup"))
        menus.append(MenuFuction(type: .BASE_TABLE_VIEW_EMPTY,name: "EMPTY_TABLE", des: "Set background for uitableview when empty data"))
        
        menus.append(MenuFuction(type: .ANIMATION_SKELETON_UIKIT,name: "SKELETON UIKIT", des: "Play skeleton animation in UIKit world"))
        
        return menus
    }
    
    static func getSwiftUIKIT() -> [MenuFuction] {
        var menus:[MenuFuction] = []
        menus.append(MenuFuction(type: .BASE_SWIFTUI_VIEW, name: "Base SwiftUI View", des: "Let's look at some illustrations of custom SwiftUI views"))
        menus.append(MenuFuction(type: .BASE_SWIFTUI_BUTTON, name: "Base SwiftUI Button", des: "Let's look at some illustrations of custom SwiftUI views"))
        menus.append(MenuFuction(type: .BASE_SWIFTUI_TEXT, name: "Base SwiftUI Text", des: "Let's look at some illustrations of custom SwiftUI views"))
        menus.append(MenuFuction(type: .BASE_SWIFTUI_IMAGE, name: "Base SwiftUI Image", des: "Let's look at some illustrations of custom SwiftUI views"))
        menus.append(MenuFuction(type: .BASE_SWIFTUI_STACK, name: "Base SwiftUI Stack", des: "Let's look at some illustrations of custom SwiftUI views"))
        menus.append(MenuFuction(type: .BASE_SWIFTUI_SCROLL_STACK, name: "Base SwiftUI Scroll + Stack", des: "Let's look at some illustrations of custom SwiftUI views"))
        menus.append(MenuFuction(type: .BASE_SWIFTUI_SPACER, name: "Base SwiftUI Spacer", des: "Let's look at some illustrations of custom SwiftUI views"))
        menus.append(MenuFuction(type: .BASE_SWIFTUI_DIVIDER, name: "Base SwiftUI Divider", des: "Let's look at some illustrations of custom SwiftUI views"))
        
        menus.append(MenuFuction(type: .ANIMATION_SKELETON_SWIFTUI,name: "SKELETON SWIFTUI", des: "Play skeleton animation in SwiftUI world"))
        
        menus.append(MenuFuction(type: .BASE_SWIFTUI_NEW_VERSION, name: "Modern Update Alert", des: "Learn how to design a smooth, elegant SwiftUI alert for new app versions."))
        return menus
    }
    
    
    static func getUpdate() -> [MenuFuction] {
        var menus:[MenuFuction] = []
        menus.append(MenuFuction(type: .THEME, name: "Always updating", des: "You can rest assured when using this library, we will always strive to update and maintain it"))
        return menus
    }
    
    static func getFuncUtil() -> [MenuFuction] {
        var menus:[MenuFuction] = []
        menus.append(MenuFuction(type: .BASE_FUNCS, name: "Useful functions", des: "TTBaseUIKit provides common handling functions for String, Date, Json, Device, Language, VietNamLunar , Validation, NetworkSpeedTest"))
        
        menus.append(MenuFuction(type: .DEBUG_UI, name: "Smart UI Debugging for iOS", des: "A powerful developer tool to inspect, trace, and debug UI components in both UIKit and SwiftUI — directly on-device or in the simulator."))
        
        menus.append(MenuFuction(type: .JAILBREAK_CHECKER, name: "JailbreakGuard – Secure Device Integrity Checker", des: "Prevent unauthorized access with fast and reliable jailbreak detection built for iOS apps"))
        
        return menus
    }
    
}

struct DataModel {
    enum TYPE :Int {
        case CONFIG = 0
        case UIKIT = 1
        case SWIFT_UI = 2
        case FUNC_UTIL = 3
        case MORE = 4
        
        func getDes() -> String {
            switch self {
            case .CONFIG:
                return "When you use this framework. You have the ability to control Color, FontSize, UI size. Config setting in AppDelegate"
            case .UIKIT:
                return "The UIKit component is supported from iOS 10 and above, corresponding to library versions < 2.0.1. Below are some basic examples"
            case .SWIFT_UI:
                return "The SwiftUI component is supported from iOS 14 and above, corresponding to library versions >= 2.0.1. Below are some basic examples"
            case .FUNC_UTIL:
                return "Useful functions"
            case .MORE:
                return "Always updating (https://tqtuan1201.github.io)"
            }
        }
        
        func getIcon() -> String {
            switch self {
            case .CONFIG:
                return "gear"
            case .UIKIT:
                return "menu-bar"
            case .SWIFT_UI:
                return "menu-bar"
            case .FUNC_UTIL:
                return "menu-bar"
            case .MORE:
                return "menu-bar"
            }
        }
    }
    
    
    let type:TYPE
    let items:[MenuFuction]
    
    static func createAll() ->  [DataModel] {
        var items:[DataModel] = []
        items.append(.init(type: .CONFIG, items: MenuFuction.getConfig()))
        items.append(.init(type: .UIKIT, items: MenuFuction.getUIKIT()))
        items.append(.init(type: .SWIFT_UI, items: MenuFuction.getSwiftUIKIT()))
        items.append(.init(type: .FUNC_UTIL, items: MenuFuction.getFuncUtil()))
        items.append(.init(type: .MORE, items: MenuFuction.getUpdate()))
        return items
    }
}

class BaseTextTableHeaderFooterViewCell : TTTextTableHeaderFooterViewCell {
    override var padding: (CGFloat, CGFloat, CGFloat, CGFloat) { return (0, 0, 0, XSize.P_CONS_DEF / 2)}
    override var bgColor: UIColor { return UIColor.getColorFromHex(netHex: 0xFBFBFB)}
    override var bgColorLabel: UIColor { return UIColor.clear}
    override var paddingLabel: (CGFloat, CGFloat, CGFloat, CGFloat) { return (XSize.P_CONS_DEF / 2, XSize.P_CONS_DEF, XSize.P_CONS_DEF / 2, XSize.P_CONS_DEF)}
}

class IconTextSubtextTableViewCell: TTIconTextSubtextTableViewCell {
    override var sizeImages: (CGFloat, CGFloat) { return (XSize.H_ICON, XSize.H_ICON - XSize.P_CONS_DEF * 2.2)}
}

class MenuViewController: BaseUITableViewController {
    
    override var navType: TTBaseUIViewController<TTBaseUIView>.NAV_STYLE { get { return .STATUS_NAV}}
    override var paddingHeader: (CGFloat, CGFloat, CGFloat, CGFloat, CGFloat) { return (0,0,0,0,TTSize.W/1.2)}
    fileprivate let data:[DataModel] = DataModel.createAll()
    fileprivate var fromDate:Date = Date()
    fileprivate var toDate:Date = Date().dateByAddingDays(2)
    fileprivate let headerView = DemoHeaderView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        guard let window = UIApplication.shared.keyWindow else { return }
        let noti:TTBaseNotificationViewConfig = TTBaseNotificationViewConfig(with: window)
        noti.setText(with: "WELCOME ^^", subTitle: "TTBaseUIKit is a framework that helps you build iOS applications in the fastest and most efficient way")
        noti.type = .NOTIFICATION_VIEW
        noti.touchType = .SWIPE
        noti.notifiType = .SUCCESS
        noti.onShow()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    private func setupUI(){
        
        self.addHeaderView(with: headerView,isFixedAnchorTop: false)
        
        self.tableView.register(IconTextSubtextTableViewCell.self)
        self.tableView.register(TTIconTextSubtextTableViewCell.self)
        self.tableView.register(TTEmptyTableHeaderViewCell.self)
        self.tableView.register(BaseTextTableHeaderFooterViewCell.self)
        
        self.tableView.dataSource = self
    }
}



extension MenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sData = self.data[section]
        let textView:BaseTextTableHeaderFooterViewCell = tableView.dequeueReusableHeaderFooterCell()
        textView.titleLabel.setMutilLine(numberOfLine: 0, textAlignment: .left, mode: .byCharWrapping).setBold().setTextColor(color: XView.labelBgDef)
        textView.panel.setCorner(withCornerRadius: 0)
        textView.titleLabel.setText(text: sData.type.getDes())
        textView.panel.setTouchHandler().onTouchHandler = { _ in
            let webVC:WebViewController = WebViewController.init(navTitle: "HI, I'M TUAN TRUONG", urlString: "https://tqtuan1201.github.io/posts/ttbaseuikit-ui-framework/")
            self.push(webVC)
        }
        return textView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let empty:TTEmptyTableHeaderViewCell = tableView.dequeueReusableHeaderFooterCell()
        return empty
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.data[section].items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sData = self.data[indexPath.section]
        let sItem = sData.items[indexPath.row]
        let cell:IconTextSubtextTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.titleLabel.setBold().setText(text: sItem.name.uppercased())
        cell.imageRight.setImage(with: sItem.getImage(), scale: .scaleAspectFit)
        cell.subLabel.setText(text: sItem.des)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let _item:MenuFuction = self.data[indexPath.section].items[indexPath.row]
        
        switch self.data[indexPath.section].type {
        case .CONFIG:
            self.onPushToUIKit(menu: _item)
            break
        case .UIKIT:
            self.onPushToUIKit(menu: _item)
            break
        case .SWIFT_UI:
            self.onPushToSwiftUIKit(menu: _item)
            break
        case .FUNC_UTIL:
            self.onPushToUtilFuncs(menu: _item)
            break
        case .MORE:
            let webVC:WebViewController = WebViewController.init(navTitle: "HI, I'M TUAN TRUONG", urlString: "https://tqtuan1201.github.io/tags/ttbaseuikit/")
            self.push(webVC)
            break
        }
    }
    
}


//MARK:// Util funcs
extension MenuViewController {
    
    func onPushToUtilFuncs(menu:MenuFuction) {
        switch menu.type {
        case .BASE_FUNCS:
            self.showMessagePopup(mess: "TTBaseUIKit provides common handling functions for String, Date, Json, Device, Language, VietNamLunar , Validation, NetworkSpeedTest") { }
            break
            
        case .DEBUG_UI:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.showMessagePopup(mess: "Long touch to show Dev Mode View, Tap three times to activate UI debugging,\nSet a passcode if you need authentication") {
                    LogViewHelper.share.config(withDes: "TTBaseDebugKit provides developers with powerful in-app tools for inspecting UI, tracking logs, and simulating environments—making debugging faster, easier, and more efficient", isStartAppToShow: false, passCode: "").onShow()
                }
            }
            break
            
        case .JAILBREAK_CHECKER:
            let result = TTBaseJailbreakDetector.shared.detectJailbreak()
            print("MenuViewController JAILBREAK_CHECKER result: \(result)")
            self.showAlert("Jailbreak_checker result: \(result)")
            switch result {
            case .Jailbreak:
                print("==> Jailbreak")
            break
            case .MacCatalyst:
                print("==> MacCatalyst")
            break
            case .Simulator:
                print("==> Simulator")
            break
            case .Pass:
                print("==> Pass")
            break
            }
            break
        default: break
        }
    }
}

//MARK:// SwiftUI
extension MenuViewController {
    
    func onPushToSwiftUIKit(menu:MenuFuction) {
        switch menu.type {
        case .BASE_SWIFTUI_VIEW:
            let view = BaseSwiftUINavView()
            let hotVC = view.embeddedInHostingController()
            self.push(hotVC)
            break
        case .BASE_SWIFTUI_BUTTON:
            let view = BaseSwiftUIButtonDemo()
            let hotVC = view.embeddedInHostingController()
            self.push(hotVC)
            break
        case .BASE_SWIFTUI_TEXT:
            let view = BaseSwiftUITextDemo()
            let hotVC = view.embeddedInHostingController()
            self.push(hotVC)
            break
        case .BASE_SWIFTUI_IMAGE:
            let view = BaseSwiftUIImageDemo()
            let hotVC = view.embeddedInHostingController()
            self.push(hotVC)
            break
        case .BASE_SWIFTUI_STACK:
            let view = BaseSwiftUIStackDemo()
            let hotVC = view.embeddedInHostingController()
            self.push(hotVC)
            break
        case .BASE_SWIFTUI_SCROLL_STACK:
            let view = BaseSwiftUIScrollStackDemo()
            let hotVC = view.embeddedInHostingController()
            self.push(hotVC)
            break
        case .BASE_SWIFTUI_SPACER:
            let view = BaseSwiftUISpacerDemo()
            let hotVC = view.embeddedInHostingController()
            self.push(hotVC)
            break
        case .BASE_SWIFTUI_DIVIDER:
            let view = BaseSwiftUIDividerDemo()
            let hotVC = view.embeddedInHostingController()
            self.push(hotVC)
            break
        case .BASE_SWIFTUI_NEW_VERSION:
            let view = BaseSwiftUINewVersionDemo()
            let hotVC = view.embeddedInHostingController()
            self.push(hotVC)
            break
        case .ANIMATION_SKELETON_SWIFTUI:
            let view = BaseSwiftUISkeletonScrollStackDemo()
            let hotVC = view.embeddedInHostingController()
            self.navigationController?.pushViewController(hotVC, animated: true)
            break
        default: break
        }
    }
}

//MARK:// UIKit
extension MenuViewController {

    
    func onPushToUIKit(menu:MenuFuction) {
        switch menu.type {
        case .THEME:
            self.showMessagePopup(mess: "In the AppDelegate class, find TTBaseUIKitConfig.withDefaultConfig where you will see a basic example of the setup") {
                let webVC:WebViewController = WebViewController.init(navTitle: "AppDelegate class", urlString: "https://raw.githubusercontent.com/tqtuan1201/TTBaseUIKit/master/TTBaseUIKitExample/TTBaseUIKitExample/AppDelegate.swift")
                self.push(webVC)
            }
            break
        case .BASE_VIEWCONTROLLER:
            let baseVC = DemoViewController(backType: .BACK_POP)
            self.navigationController?.pushViewController(baseVC, animated: true)
            break
        case .BASE_CALENDAR:
            let calendarView:CalendarPopupViewController = CalendarPopupViewController(withPeriodTime: self.fromDate, toDate: self.toDate)
            self.presentDef(vc: calendarView)
            calendarView.onDidSelectPeriodDate = { (from, to) in
                self.fromDate = from
                self.toDate = to
            }
            break
        case .BASE_TABLE_VIEW_CONTROLLER:
            let baseVC = BaseTableViewController()
            self.navigationController?.pushViewController(baseVC, animated: true)
            break
        case .BASE_TABLE_VIEW_EMPTY:
            let emptyVC = EmptyTableViewController()
            self.navigationController?.pushViewController(emptyVC, animated: true)
            break
        case .ANIMATION_SKELETON_UIKIT:
            let skeletonUIKitVC = SkeletonTableViewController()
            self.navigationController?.pushViewController(skeletonUIKitVC, animated: true)
            break
        case .BASE_COMPONENTS:
            let baseComponents = BaseComponentsViewController()
            self.navigationController?.pushViewController(baseComponents, animated: true)
            break
        case .BASE_COLLECTIONVIEW:
            let baseCollectionVC = BaseColllectionViewViewController()
            self.navigationController?.pushViewController(baseCollectionVC, animated: true)
            break
        case .BASE_CUSTOM_FLOWLAYOUT_COLLECTIONVIEW:
            let baseCollectionVC = BaseCustomFlowLayoutColllectionViewController()
            self.navigationController?.pushViewController(baseCollectionVC, animated: true)
            break
        case .BASE_AUTO_LAYOUT:
            let baseContrainsVC = BaseSetupContraintsViewController()
            self.navigationController?.pushViewController(baseContrainsVC, animated: true)
            break
        case .BASE_ADVANCE_AUTO_LAYOUT:
            let advanceVC = AdvanceSetupContraintsViewController()
            self.navigationController?.pushViewController(advanceVC, animated: true)
            break
        case .BASE_TABLE_VIEW_CELL:
            self.navigationController?.pushViewController(CellTypeTableViewController(), animated: true)
            break
        case .BASE_COLLECTION_VIEW_CELL:
            break
        case .BASE_MESSAGE:
            let messageView = ShowMessageViewController()
            messageView.didSelectType = { type in
                guard let window = UIApplication.shared.keyWindow else { return }
                let noti:TTBaseNotificationViewConfig = TTBaseNotificationViewConfig(with: window)
                noti.setText(with: "WELCOME ^^", subTitle: "Just demo little ele")
                noti.type = .NOTIFICATION_VIEW
                noti.positionType = type
                noti.notifiType = .SUCCESS
                if type == .TOP {
                    noti.contentViewType = .ICON_TEXT_BUTTON
                } else if type == .CENTER {
                    noti.contentViewType = .ICON_TEXT
                } else {
                    noti.contentViewType = .TEXT
                }
                noti.onShow()
                noti.getCurrentNotifi.buttonRight.setText(text: "Right Button")
            }
            self.present(messageView, animated: true)
            break
        case .BASE_POPUP:
            let popupVC = TTPopupViewController(title: "SOMETHING LIKE THIS", subTitle: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has b", isAllowTouchPanel: true)
            self.present(popupVC, animated: true)
            break
        case .BASE_PRESENT_VC:
            let vc = CoverPresentViewController()
            self.present(vc, animated: true)
            break
        case .BASE_PICKER:
            let vc = DatePickerViewController()
            self.present(vc, animated: true)
            break
        default:
            self.navigationController?.pushViewController(TestViewController(), animated: true)
            break
        }
    }
}


extension UIViewController {
    func showMessagePopup(mess:String, completeHandle:( () -> ())?) {
        self.showPopupConfirm(withText: "Message", subTitle: mess, leftButton: nil, rightButton: "OK") {
            completeHandle?()
        }
    }
}

import SwiftUI
struct MenuViewController_Previews: PreviewProvider {
    static var previews: some View {
        TTBaseUIViewControllerPreview {
            let vc = MenuViewController()
            return UINavigationController.init(rootViewController: vc)
        }
    }
}
