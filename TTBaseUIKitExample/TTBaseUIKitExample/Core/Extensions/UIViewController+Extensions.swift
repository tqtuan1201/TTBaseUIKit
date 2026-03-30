//
//  TTBaseUIKit+Extension.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/7/24.
//  Copyright © 2024 Truong Quang Tuan. All rights reserved.
//

import TTBaseUIKit
import UIKit

extension UIViewController {
    
    func onShare(withActivityItems items:[Any]) {
        
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError) in
        }
        DispatchQueue.main.async { UIApplication.topViewController()?.present(activityViewController, animated: true) }
    }
    
    func showNoticeView(title:String = "Notice", body:String, style:TTBaseNotificationViewConfig.NOTIFICATION_TYPE = .SUCCESS, time:Double = 3.0) {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.keyWindow else { return }
            let noti:TTBaseNotificationViewConfig = TTBaseNotificationViewConfig(with: window)
            noti.setText(with: title, subTitle: body)
            noti.durationType = .TIME(seconds: time)
            noti.type = .NOTIFICATION_VIEW
            noti.notifiType = style
            noti.onShow()
        }
    }
    
    

}
