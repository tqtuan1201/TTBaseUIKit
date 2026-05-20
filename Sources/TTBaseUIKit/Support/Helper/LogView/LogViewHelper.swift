//
//  LogViewHelper.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 9/11/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit
#if canImport(SwiftUI)
import SwiftUI
#endif

open class LogViewHelper {

    fileprivate var viewModel: LogTrackingViewModel = LogTrackingViewModel()

    public static let share = LogViewHelper()

    private let concurrentQueue = DispatchQueue(label: "ConcurrentQueue", attributes: .concurrent, target: nil)

    private init() {}

    public var didTouchLogButtonHandle: (() -> Void)?
    public var didTouchDebugLayoutlHandle: (() -> Void)?
    public var didTouchCapturelHandle: (() -> Void)?
    public var didTouchSettinglHandle: (() -> Void)?

    public var didSendCurrentRequest: ((_ request: String) -> Void)?
    public var didSendCurrentResponse: ((_ response: String) -> Void)?

    public func config(withDes des: String, isStartAppToShow: Bool, passCode: String) -> LogViewHelper {
        self.viewModel.displayString = des
        self.viewModel.passCode = passCode
        self.viewModel.isStartAppToShow = isStartAppToShow
        return self
    }
}

// MARK: - For Base Funcs
extension LogViewHelper {

    public func getLogs() -> [LogViewModel] {
        var logs: [LogViewModel] = []
        self.concurrentQueue.sync {
            logs = self.viewModel.logs
        }
        return logs
    }

    public func add(withLog log: LogViewModel) {
        self.concurrentQueue.async(flags: .barrier) {
            self.viewModel.logs.append(log)
            if self.viewModel.logs.count > 70 {
                self.viewModel.logs.removeFirst(self.viewModel.logs.count - 70)
            }
        }
    }

    public func resetLogs() {
        self.concurrentQueue.sync(flags: .barrier) {
            self.viewModel.logs = []
        }
    }
}

// MARK: - For Base View
extension LogViewHelper {

    public func onShow(isAutoEnableRunTTBaseDebugUIKit isEnableDebugUI: Bool = false) {
        DispatchQueue.main.async {
            if let windown = UIApplication.getKeyWindow() {
                let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.addAccountLongPressGesture(_:)))
                windown.addGestureRecognizer(longPressRecognizer)

                if isEnableDebugUI {
                    let tripleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleWindowDoubleTap))
                    tripleTap.numberOfTapsRequired = 8
                    windown.addGestureRecognizer(tripleTap)
                }
            }
        }
    }

    public func onStartAndPresentVC() {
        self.onShow()
        self.onPresentVC()
    }

    @objc fileprivate func handleWindowDoubleTap() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if let topVC = UIApplication.topViewController() {
                topVC.view.onStartRunTTBaseDebugKit()
            }
        }
    }

    @objc fileprivate func addAccountLongPressGesture(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            self.onPresentVC()
        }
    }

    fileprivate func onPresentVC() {
        if self.viewModel.isShow { return }

        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.viewModel.isShow = true

            if strongSelf.viewModel.isSkipCheckPass {
                strongSelf.showDebugMenu()
            } else {
                strongSelf.showPasscodeInput()
            }
        }
    }

    private func showPasscodeInput() {
        let ac = UIAlertController(
            title: "[DEV MODE] CHANGE SETTING APP\nInput passcode",
            message: nil,
            preferredStyle: .alert
        )
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, unowned ac] _ in
            guard let answer = ac.textFields?[0] else { return }
            if answer.text?.uppercased() == self?.viewModel.passCode.uppercased() {
                self?.viewModel.isSkipCheckPass = true
                self?.showDebugMenu()
            } else {
                UIApplication.topViewController()?.onShowNoticeView(
                    body: "The passcode is incorrect. Please reach out to the developer for assistance",
                    style: .WARNING
                )
                self?.viewModel.isShow = false
            }
        }
        ac.addAction(submitAction)
        UIApplication.topViewController()?.present(ac, animated: true)
    }

    private func showDebugMenu() {
        let ac = UIAlertController(
            title: "TTBaseDebugKit",
            message: viewModel.displayString,
            preferredStyle: .actionSheet
        )

        // Show Log API Response
        ac.addAction(UIAlertAction(title: "SHOW LOG API RESPONSE", style: .default) { [weak self] _ in
            self?.openLogList()
        })

        // Debug UI/Layout
        ac.addAction(UIAlertAction(title: "DEBUG UI/LAYOUT", style: .default) { [weak self] _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if let topVC = UIApplication.topViewController() {
                    topVC.view.onStartRunTTBaseDebugKit()
                }
            }
            self?.didTouchDebugLayoutlHandle?()
            self?.viewModel.isShow = false
        })

        // Debug Bridge
        ac.addAction(UIAlertAction(title: "DEBUG BRIDGE", style: .default) { [weak self] _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                #if canImport(SwiftUI)
                if #available(iOS 14.0, *) {
                    if let topVC = UIApplication.topViewController() {
                        let bridgeVC = DebugBridgeViewController()
                        let nav = UINavigationController(rootViewController: bridgeVC)
                        nav.modalPresentationStyle = .fullScreen
                        topVC.presentDef(vc: nav, type: .overFullScreen, transitionStyle: .coverVertical)
                    }
                }
                #endif
            }
            self?.viewModel.isShow = false
        })

        // Capture Screen
        ac.addAction(UIAlertAction(title: "CAPTURE THE SCREEN", style: .default) { [weak self] _ in
            DispatchQueue.main.async {
                if let topVC = UIApplication.topViewController() {
                    topVC.presentDrawAndShare(image: topVC.captureScreenshot())
                }
            }
            self?.didTouchDebugLayoutlHandle?()
            self?.viewModel.isShow = false
        })

        // Setting Dev
        ac.addAction(UIAlertAction(title: "SETTING DEV", style: .default) { [weak self] _ in
            self?.didTouchSettinglHandle?()
            self?.viewModel.isShow = false
        })

        // Cancel
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            self?.viewModel.isShow = false
        })

        if let popover = ac.popoverPresentationController {
            popover.sourceView = UIApplication.topViewController()?.view
            popover.sourceRect = CGRect(
                x: UIScreen.main.bounds.midX,
                y: UIScreen.main.bounds.midY,
                width: 0,
                height: 0
            )
            popover.permittedArrowDirections = []
        }

        UIApplication.topViewController()?.present(ac, animated: true)
    }

    private func openLogList() {
        didTouchLogButtonHandle?()
        viewModel.isShow = false

        DispatchQueue.main.async { [weak self] in
            #if canImport(SwiftUI)
            if #available(iOS 14.0, *) {
                let logListVC = TTBaseHostingController(
                    shouldShowNavigationBar: true,
                    isSetHiddenTabar: true,
                    statusBarStyle: .lightContent,
                    rootView: LogListScreen().preferredColorScheme(.dark)
                )
                UIApplication.topViewController()?.presentDef(vc: logListVC, type: .overFullScreen)
            } else {
                // Fallback for iOS < 14
                self?.openLogListFallback()
            }
            #else
            self?.openLogListFallback()
            #endif
        }
    }

    private func openLogListFallback() {
        // Minimal fallback - show logs in an alert
        let logs = getLogs()
        if logs.isEmpty {
            UIApplication.topViewController()?.onShowNoticeView(
                body: "No API logs available",
                style: .WARNING
            )
            return
        }

        let summary = logs.prefix(5).map { log in
            "[\(log.httpMethod.displayName)] \(log.endpoint.isEmpty ? log.urlRequest : log.endpoint)"
        }.joined(separator: "\n")

        let ac = UIAlertController(
            title: "API Logs (\(logs.count) total)",
            message: summary,
            preferredStyle: .alert
        )
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        UIApplication.topViewController()?.present(ac, animated: true)
    }

    public func seedFakeLogs() {
        let now = Date()
        let fakeLogs: [LogViewModel] = [
            makeFakeLog(
                name: "AuthService.login",
                request: """
                {
                  "username": "tester@ttbase.dev",
                  "password": "********",
                  "rememberMe": true
                }
                """,
                response: """
                200
                {
                  "accessToken": "fake_access_token",
                  "refreshToken": "fake_refresh_token",
                  "expiresIn": 3600
                }
                """,
                urlRequest: "POST https://api.ttbase.dev/v1/auth/login",
                time: now.addingTimeInterval(-240)
            ),
            makeFakeLog(
                name: "ProfileService.detail",
                request: """
                {
                  "includePermissions": true,
                  "includeFeatureFlags": true
                }
                """,
                response: """
                200
                {
                  "id": "user_001",
                  "displayName": "TTBase Tester",
                  "role": "developer"
                }
                """,
                urlRequest: "GET https://api.ttbase.dev/v1/me",
                time: now.addingTimeInterval(-180)
            ),
            makeFakeLog(
                name: "PaymentService.createOrder",
                request: """
                {
                  "amount": 129000,
                  "currency": "VND",
                  "items": [
                    {
                      "sku": "TTB-PRO",
                      "quantity": 1
                    }
                  ]
                }
                """,
                response: """
                422
                {
                  "code": "INVALID_COUPON",
                  "message": "Coupon code has expired"
                }
                """,
                urlRequest: "POST https://api.ttbase.dev/v1/orders",
                time: now.addingTimeInterval(-90)
            ),
            makeFakeLog(
                name: "NotificationService.list",
                request: """
                {
                  "page": 1,
                  "limit": 20
                }
                """,
                response: """
                500
                {
                  "code": "INTERNAL_ERROR",
                  "message": "Unexpected upstream timeout"
                }
                """,
                urlRequest: "GET https://api.ttbase.dev/v1/notifications?page=1&limit=20",
                time: now.addingTimeInterval(-30)
            )
        ]

        concurrentQueue.sync(flags: .barrier) {
            viewModel.logs = fakeLogs
        }
    }

    private func makeFakeLog(
        name: String,
        request: String,
        response: String,
        urlRequest: String,
        time: Date
    ) -> LogViewModel {
        let log = LogViewModel(
            withName: name,
            request: request,
            response: response,
            urlRequest: urlRequest
        )
        log.time = time
        return log
    }
}
