//
//  File.swift
//  
//
//  Created by TuanTruong on 18/11/2023.
//

import Foundation
import SwiftUI

public extension View {

    func showNoticeView(title:String = "App.Error.Title".localize(withBundle: Bundle.main), body:String, style:TTBaseNotificationViewConfig.NOTIFICATION_TYPE = .SUCCESS, time:Double = 3.0) {
        DispatchQueue.main.async {
            guard let window = UIApplication.getKeyWindow() else { return }
            let noti:TTBaseNotificationViewConfig = TTBaseNotificationViewConfig(with: window)
            noti.setText(with: title, subTitle: body)
            noti.durationType = .TIME(seconds: time)
            noti.type = .NOTIFICATION_VIEW
            noti.notifiType = style
            noti.onShow()
        }
    }
    
}
