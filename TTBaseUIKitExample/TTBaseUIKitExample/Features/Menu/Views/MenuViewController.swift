//
//  MenuViewController.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 3/8/24.
//  Copyright © 2024 Truong Quang Tuan. All rights reserved.
//

import Foundation
import TTBaseUIKit

// MARK: - Custom Cells
class MenuHeaderCell: TTTextTableHeaderFooterViewCell {
    override var padding: (CGFloat, CGFloat, CGFloat, CGFloat) { return (0, 0, 0, XSize.P_CONS_DEF / 2) }
    override var bgColor: UIColor { return UIColor.getColorFromHex(netHex: 0xFBFBFB) }
    override var bgColorLabel: UIColor { return UIColor.clear }
    override var paddingLabel: (CGFloat, CGFloat, CGFloat, CGFloat) { return (XSize.P_CONS_DEF / 2, XSize.P_CONS_DEF, XSize.P_CONS_DEF / 2, XSize.P_CONS_DEF) }
}

class MenuItemCell: TTIconTextSubtextTableViewCell {
    override var sizeImages: (CGFloat, CGFloat) { return (XSize.H_ICON, XSize.H_ICON - XSize.P_CONS_DEF * 2.2) }
}

// MARK: - MenuViewController
class MenuViewController: BaseUITableViewController {
    
    weak var coordinator: MenuCoordinator?
    
    override var navType: TTBaseUIViewController<TTBaseUIView>.NAV_STYLE { return .STATUS_NAV }
    override var paddingHeader: (CGFloat, CGFloat, CGFloat, CGFloat, CGFloat) { return (0, 0, 0, 0, TTSize.W / 1.2) }
    override var isSetHiddenTabar: Bool { return false }
    override var isForceSetBottomConstrainsByNonSafeArea: Bool { return true }
    override var tableStyle: UITableView.Style { return .grouped }
    
    fileprivate let viewModel = MenuViewModel()
    fileprivate let headerView = DemoHeaderView()
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if #available(iOS 26.0, *) {
            self.tabBarController?.tabBar.backgroundColor = UIColor.clear
        } else {
            self.tabBarController?.tabBar.backgroundColor = UIColor.white
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.showWelcomeNotification()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        self.addHeaderView(with: headerView, isFixedAnchorTop: false)
        self.tableView.register(MenuItemCell.self)
        self.tableView.register(TTIconTextSubtextTableViewCell.self)
        self.tableView.register(TTEmptyTableHeaderViewCell.self)
        self.tableView.register(MenuHeaderCell.self)
        self.tableView.resetContentInset()
        self.tableView.contentInset.top = XSize.H_NAV
        self.tableView.contentInset.bottom = XSize.H_BOTTOM_SAFE_AREA_INSET + XSize.H_BUTTON
        self.tableView.dataSource = self
    }
    
    private func showWelcomeNotification() {
        guard let window = UIApplication.shared.keyWindow else { return }
        let noti = TTBaseNotificationViewConfig(with: window)
        noti.setText(with: "WELCOME ^^", subTitle: "TTBaseUIKit is a framework that helps you build iOS applications in the fastest and most efficient way")
        noti.type = .NOTIFICATION_VIEW
        noti.touchType = .SWIPE
        noti.notifiType = .SUCCESS
        noti.onShow()
    }
}

// MARK: - UITableViewDataSource
extension MenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let textView: MenuHeaderCell = tableView.dequeueReusableHeaderFooterCell()
        textView.titleLabel.setMutilLine(numberOfLine: 0, textAlignment: .left, mode: .byCharWrapping).setBold().setTextColor(color: XView.labelBgDef)
        textView.panel.setCorner(withCornerRadius: 0)
        textView.titleLabel.setText(text: viewModel.sectionDescription(at: section))
        textView.panel.setTouchHandler().onTouchHandler = { [weak self] _ in
            self?.coordinator?.showWebView(title: "HI, I'M TUAN TRUONG", url: "https://tqtuan1201.github.io/posts/ttbaseuikit-ui-framework/")
        }
        return textView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let empty: TTEmptyTableHeaderViewCell = tableView.dequeueReusableHeaderFooterCell()
        return empty
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { 1.0 }
    func numberOfSections(in tableView: UITableView) -> Int { viewModel.numberOfSections() }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel.numberOfItems(in: section) }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.item(at: indexPath)
        let cell: MenuItemCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.titleLabel.setBold().setText(text: item.name.uppercased())
        cell.imageRight.setImage(with: item.getImage(), scale: .scaleAspectFit)
        cell.subLabel.setText(text: item.des)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.item(at: indexPath)
        let sectionType = viewModel.sectionType(at: indexPath.section)
        
        switch sectionType {
        case .CONFIG:
            coordinator?.showThemeInfo()
        case .UIKIT:
            handleUIKitSelection(item)
        case .SWIFT_UI:
            coordinator?.showSwiftUIDemo(type: item.type)
        case .FUNC_UTIL:
            handleUtilSelection(item)
        case .MORE:
            coordinator?.showMoreInfo()
        }
    }
    
    // MARK: - Selection Routing
    
    private func handleUIKitSelection(_ item: MenuFunction) {
        switch item.type {
        case .THEME: coordinator?.showThemeInfo()
        case .BASE_VIEWCONTROLLER: coordinator?.showDemoViewController()
        case .BASE_TABLE_VIEW_CONTROLLER: coordinator?.showBaseTableViewController()
        case .BASE_COLLECTIONVIEW: coordinator?.showBaseCollectionViewController()
        case .BASE_CUSTOM_FLOWLAYOUT_COLLECTIONVIEW: coordinator?.showCustomFlowLayoutCollectionViewController()
        case .BASE_COMPONENTS: coordinator?.showBaseComponentsViewController()
        case .BASE_AUTO_LAYOUT: coordinator?.showAutoLayoutDemo()
        case .BASE_ADVANCE_AUTO_LAYOUT: coordinator?.showAdvanceAutoLayoutDemo()
        case .BASE_CALENDAR:
            coordinator?.showCalendarPopup(fromDate: viewModel.fromDate, toDate: viewModel.toDate) { [weak self] from, to in
                self?.viewModel.fromDate = from
                self?.viewModel.toDate = to
            }
        case .BASE_TABLE_VIEW_EMPTY: coordinator?.showEmptyTableDemo()
        case .ANIMATION_SKELETON_UIKIT: coordinator?.showSkeletonUIKitDemo()
        case .BASE_PRESENT_VC: coordinator?.showCoverPresentDemo()
        case .BASE_TABLE_VIEW_CELL: coordinator?.showCellTypeDemo()
        case .BASE_MESSAGE:
            coordinator?.showMessageDemo { type in
                guard let window = UIApplication.shared.keyWindow else { return }
                let noti = TTBaseNotificationViewConfig(with: window)
                noti.setText(with: "WELCOME ^^", subTitle: "Just demo little ele")
                noti.type = .NOTIFICATION_VIEW
                noti.positionType = type
                noti.notifiType = .SUCCESS
                if type == .TOP { noti.contentViewType = .ICON_TEXT_BUTTON }
                else if type == .CENTER { noti.contentViewType = .ICON_TEXT }
                else { noti.contentViewType = .TEXT }
                noti.onShow()
                noti.getCurrentNotifi.buttonRight.setText(text: "Right Button")
            }
        case .BASE_POPUP: coordinator?.showPopupDemo()
        case .BASE_PICKER: coordinator?.showDatePickerDemo()
        default: break
        }
    }
    
    private func handleUtilSelection(_ item: MenuFunction) {
        switch item.type {
        case .BASE_FUNCS: coordinator?.showFuncsInfo()
        case .DEBUG_UI:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.coordinator?.showDebugUI()
            }
        case .JAILBREAK_CHECKER: coordinator?.showJailbreakChecker()
        default: break
        }
    }
}

// MARK: - UIViewController Extension
extension UIViewController {
    func showMessagePopup(mess: String, completeHandle: (() -> ())?) {
        self.showPopupConfirm(withText: "Message", subTitle: mess, leftButton: nil, rightButton: "OK", onTouchAgreeHandle: {
            completeHandle?()
        })
    }
}

// MARK: - SwiftUI Preview
import SwiftUI

struct MenuViewController_Previews: PreviewProvider {
    static var previews: some View {
        TTBaseUIViewControllerPreview {
            let vc = MenuViewController()
            return UINavigationController(rootViewController: vc)
        }.preferredColorScheme(.light)
    }
}
