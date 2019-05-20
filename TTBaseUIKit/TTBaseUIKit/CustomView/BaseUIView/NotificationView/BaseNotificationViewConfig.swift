//
//  BaseNotificationViewConfig.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 5/17/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation

public class TTBaseNotificationViewConfig {
    
    static let HIGHT_NOTIFIVIEW:CGFloat = 80.0
    
    public enum TYPE {
        case MESSAGE_STRECHES_VIEW
        case NOTIFICATION_VIEW
    }
    
    public enum PRESENTATION_TYPE {
        case WINDOW
        case UIVIEWCONTROLER
    }
    
    public enum DURATION_TYPE {
        case AUTOMATIC
        case ALWAY_SHOW
        case TIME(seconds: TimeInterval)
    }
    
    public enum NOTIFICATION_TYPE {
        case SUCCESS
        case WARNING
        case ERROR
    }
    
    public enum VIEW_TYPE {
        case TEXT
        case ICON_TEXT
        case ICON_TEXT_BUTTON
    }
    
    public enum SIZE_FRAME {
        case FIXED
        case AUTOMATIC
    }
    
    public enum TOUCH_TYPE {
        case NONE
        case BUTTON
        case NOTIFI_VIEW
        case CONTENT_VIEW
    }
    
    public enum POSITION {
        case TOP
        case TOP_BELOW_NAV
        case CENTER
        case BOTTOM
        case BOTTOM_ABOVE_TAB
    }
    
    
    public var buttonColor:UIColor = UIColor.white
    
    public var type:TYPE = .NOTIFICATION_VIEW
    public var durationType:DURATION_TYPE = .AUTOMATIC
    public var notifiType:NOTIFICATION_TYPE = .SUCCESS
    public var contentViewType:VIEW_TYPE = .ICON_TEXT
    public var sizeFrame:SIZE_FRAME = .FIXED
    public var positionType:POSITION = .TOP
    public var touchType:TOUCH_TYPE = .NONE
    
    public var padding:(CGFloat,CGFloat,CGFloat,CGFloat) = (TTSize.P_CONS_DEF,TTSize.P_CONS_DEF,TTSize.P_CONS_DEF,TTSize.P_CONS_DEF)
    public var paddingTopAnimal:CGFloat = TTBaseUIKitConfig.getSizeConfig().H_STATUS + TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF
    
    public var timeToShow:TimeInterval = 4
    public var isHiddenStatusBar:Bool = false
    private var currentWindown:UIWindow? = UIApplication.shared.keyWindow
    private var currentVC:UIViewController?
    
    private var contentView:TTBaseUIView?
    private var currentNotifiView:TTBaseNotificationView = TTBaseNotificationView()
    public var presentationType:PRESENTATION_TYPE = .WINDOW
    
    public var titleString:String  = ""
    public var subString:String  = ""
    
    public init () { }
    public init (with windown:UIWindow) { self.currentWindown = windown ; self.presentationType = .WINDOW }
    public init (with viewController:UIViewController) { self.currentVC = viewController ; self.presentationType = .UIVIEWCONTROLER}
    
    
    public var onTouchNotifiViewHandler:(() -> Void)?
    public var onTouchContentViewHandler:(() -> Void)?
    public var onTouchButtonViewHandler:(() -> Void)?
    
    public func onShow() {
        
        switch self.presentationType {
        case .WINDOW:
            self.onShowWindown()
            break
        case .UIVIEWCONTROLER:
            self.onShowViewController()
            break
        }

        self.setTargets()
        
        self.setText()
        
        DispatchQueue.main.async { self.addAnimations() }
    }
    
    public var getCurrentNotifi:TTBaseNotificationView { get { return self.currentNotifiView } }
}

//MARK:// For Base func
extension TTBaseNotificationViewConfig {
    
    fileprivate func setText() {
        self.getCurrentNotifi.titleLabel.setText(text: self.titleString).done()
        self.getCurrentNotifi.subLabel.setText(text: self.subString).done()
    }
    
    public func setText(with title:String, subTitle:String) {
        self.titleString = title
        self.subString = subTitle
    }
}
//MARK:// For Touch handle
extension TTBaseNotificationViewConfig {
    
    fileprivate func setHiddenNotificationView() {
        UIView.animate(withDuration: 0.8) {
            self.currentNotifiView.removeFromSuperview()
            self.contentView?.alpha = 0; self.contentView?.removeFromSuperview()
        }
    }
    
    fileprivate func setTargets() {
        switch self.touchType {
        case .CONTENT_VIEW:
            
            self.contentView?.setTouchHandler().onTouchHandler = { _ in
                self.onTouchContentViewHandler?()
            }
            break
        case .NOTIFI_VIEW:
            self.currentNotifiView.setTouchHandler().onTouchHandler = { _ in
                self.onTouchNotifiViewHandler?()
            }
            break
        case .BUTTON:
            self.currentNotifiView.buttonRight.onTouchHandler = { _ in
                self.onTouchButtonViewHandler?()
            }
            break
        case .NONE:
            break
        }
    }
}
//MARK:// For Animations
extension TTBaseNotificationViewConfig{
    
    fileprivate func addAnimations() {
        switch self.durationType {
        case .ALWAY_SHOW:
            self.timeToShow = 0
            break
        case .AUTOMATIC:
            break
        case .TIME( let time):
            self.timeToShow = time
            break
        }
        
        switch self.positionType {
        case .TOP: self.setAnimalForTop(); break
        case .TOP_BELOW_NAV:
            if self.presentationType  == .WINDOW {
                self.setAnimailForCenterView()
            } else {
                self.setAnimalForBellowNav()
            }
            break
        case .CENTER: self.setAnimailForCenterView(); break
        case .BOTTOM_ABOVE_TAB: self.setAnimailForCenterView(); break
        case .BOTTOM: self.setAnimailForCenterView(); break
        }
        
    }
    
    fileprivate func setAnimailForCenterView() {
        self.currentNotifiView.alpha = 0
        UIView.animate(withDuration: 0.7, animations: {
            self.currentNotifiView.alpha = 1
        }) { (isComplete) in
            if self.timeToShow != 0 {
                UIView.animate(withDuration: 0.7, delay: self.timeToShow, options: UIView.AnimationOptions.transitionCurlUp, animations: {
                    self.currentNotifiView.alpha = 0
                }, completion: { (isComplete) in
                    self.setHiddenNotificationView()
                })
            }
        }
    }
    
    fileprivate func setAnimalForTop() {
        var transformHeight:CGFloat = (self.type == .NOTIFICATION_VIEW ) ? TTBaseNotificationViewConfig.HIGHT_NOTIFIVIEW + TTSize.H_STATUS : TTBaseNotificationViewConfig.HIGHT_NOTIFIVIEW
        transformHeight = transformHeight +  self.paddingTopAnimal
        self.contentView?.alpha = 0
        UIView.animate(withDuration: 0.6, animations: {
            if self.isHiddenStatusBar { if let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as? UIView { statusBar.isHidden = true } }
            self.currentNotifiView.transform = CGAffineTransform(translationX: 0, y:  transformHeight)
            self.contentView?.alpha = 1
        }) { (isComplete) in
            
            if self.timeToShow != 0 {
                UIView.animate(withDuration: 0.4, delay: self.timeToShow, options: UIView.AnimationOptions.transitionCurlUp, animations: {
                    self.currentNotifiView.transform = CGAffineTransform(translationX: 0, y:  -transformHeight)
                }, completion: { (isComplete) in
                    if self.isHiddenStatusBar { if let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as? UIView { statusBar.isHidden = false } }
                    self.setHiddenNotificationView()
                })
            }
        }
    }
    
    fileprivate func setAnimalForBellowNav() {
        let transformHeight:CGFloat = TTBaseNotificationViewConfig.HIGHT_NOTIFIVIEW + TTSize.H_STATUS + TTSize.H_NAV
        self.contentView?.alpha = 0
        UIView.animate(withDuration: 0.6, animations: {
            if self.isHiddenStatusBar { if let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as? UIView { statusBar.isHidden = true } }
            self.currentNotifiView.transform = CGAffineTransform(translationX: 0, y:  transformHeight)
            self.contentView?.alpha = 1
        }) { (isComplete) in
            
            if self.timeToShow != 0 {
                UIView.animate(withDuration: 0.4, delay: self.timeToShow, options: UIView.AnimationOptions.transitionCurlUp, animations: {
                    self.currentNotifiView.transform = CGAffineTransform(translationX: 0, y:  -transformHeight)
                }, completion: { (isComplete) in
                    if self.isHiddenStatusBar { if let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as? UIView { statusBar.isHidden = false } }
                    self.setHiddenNotificationView()
                })
            }
        }
    }
    
    
}

//MARK:// For UIViewController
extension TTBaseNotificationViewConfig {
    fileprivate func onShowViewController() {
        guard let vc = self.currentVC else { return }
        if vc.view.viewWithTag(CONSTANT.TAG_VIEW.NOTIFICATION_VIEW.rawValue) != nil { return }
        self.currentNotifiView = self.getNotificationView()
        
        if self.touchType == .CONTENT_VIEW {
            self.contentView = DarkBaseUIView()
            self.contentView?.backgroundColor = UIColor.darkGray.withAlphaComponent(0.4)
            self.contentView?.addSubview(self.currentNotifiView)
            self.currentNotifiView.setLeadingAnchor(constant: 0).setTrailingAnchor(constant: 0).setTopAnchor(constant: 0).done()
            
            //self.contentView?.layer.zPosition = self.currentNotifiView.layer.zPosition - 1
            
            vc.view.addSubview(self.contentView!)
            self.contentView?.setFullContraints(constant: 0)
        }
        
        if self.positionType == .TOP_BELOW_NAV {
            if let baseVC = self.currentVC as? TTBaseUIViewController {
                self.currentNotifiView.layer.zPosition = baseVC.navBar.layer.zPosition - 1
                vc.view.insertSubview(self.currentNotifiView, belowSubview: baseVC.navBar)
            } else {
                vc.view.addSubview(self.currentNotifiView)
            }
        } else {
            vc.view.addSubview(self.currentNotifiView)
        }
        
        switch self.positionType {
        case .TOP:
            self.currentNotifiView.setLeadingAnchor(constant: 0).setTrailingAnchor(constant: 0).setTopAnchor(constant:  -TTBaseNotificationViewConfig.HIGHT_NOTIFIVIEW - self.paddingTopAnimal).done()
            break
        case .TOP_BELOW_NAV:
            self.currentNotifiView.setLeadingAnchor(constant: 0).setTrailingAnchor(constant: 0).setTopAnchor(constant:  -TTBaseNotificationViewConfig.HIGHT_NOTIFIVIEW).done()
            break
        case .CENTER:
            self.currentNotifiView.setLeadingAnchor(constant: 0).setTrailingAnchor(constant: 0).setcenterYAnchor(constant: 0).done()
            break
        case .BOTTOM_ABOVE_TAB:
            let height:CGFloat = UIApplication.topViewController()?.tabBarController?.tabBar.bounds.size.height ?? 50
            self.currentNotifiView.setLeadingAnchor(constant: 0).setTrailingAnchor(constant: 0).setBottomAnchor(constant: height, isMarginsGuide: false).done()
            break
        case .BOTTOM:
            self.currentNotifiView.setLeadingAnchor(constant: 0).setTrailingAnchor(constant: 0).setBottomAnchor(constant: 0).done()
            break
        }
    }
}

//MARK:// For Windown
extension TTBaseNotificationViewConfig {
    fileprivate func onShowWindown() {
        guard let window = self.currentWindown else { return }
        if window.viewWithTag(CONSTANT.TAG_VIEW.NOTIFICATION_VIEW.rawValue) != nil { return }
        
        self.currentNotifiView = self.getNotificationView()
        
        if self.touchType == .CONTENT_VIEW {
            self.contentView = DarkBaseUIView()
            self.contentView?.backgroundColor = UIColor.darkGray.withAlphaComponent(0.4)
            self.contentView?.addSubview(self.currentNotifiView)
            self.currentNotifiView.setLeadingAnchor(constant: 0).setTrailingAnchor(constant: 0).setTopAnchor(constant: 0).done()
            
            //self.contentView?.layer.zPosition = self.currentNotifiView.layer.zPosition - 1
            
            window.addSubview(self.contentView!)
            self.contentView?.setFullContraints(constant: 0)
        }
        
        window.addSubview(self.currentNotifiView)
        
        switch self.positionType {
        case .TOP:
            self.currentNotifiView.setLeadingAnchor(constant: 0).setTrailingAnchor(constant: 0).setTopAnchor(constant:  -TTBaseNotificationViewConfig.HIGHT_NOTIFIVIEW - self.paddingTopAnimal).done()
            break
        case .TOP_BELOW_NAV:
            self.currentNotifiView.setLeadingAnchor(constant: 0).setTrailingAnchor(constant: 0).setTopAnchor(constant:  TTSize.H_NAV + TTSize.H_STATUS).done()
            break
        case .CENTER:
            self.currentNotifiView.setLeadingAnchor(constant: 0).setTrailingAnchor(constant: 0).setcenterYAnchor(constant: 0).done()
            break
        case .BOTTOM_ABOVE_TAB:
            let height:CGFloat = UIApplication.topViewController()?.tabBarController?.tabBar.bounds.size.height ?? 50
            self.currentNotifiView.setLeadingAnchor(constant: 0).setTrailingAnchor(constant: 0).setBottomAnchor(constant: height, isMarginsGuide: false).done()
            break
        case .BOTTOM:
            self.currentNotifiView.setLeadingAnchor(constant: 0).setTrailingAnchor(constant: 0).setBottomAnchor(constant: 0).done()
            break
        }
    }
    
    fileprivate func getNotificationView() -> TTBaseNotificationView {
        
        var bgNotifiColor:UIColor = TTView.notificationBgSuccess
        var bgPanel:UIColor = UIColor.clear
        var iconName:AwesomePro.Light = .checkCircle
        
        if self.notifiType == .WARNING {
            bgNotifiColor = TTView.notificationBgWarning ; iconName = AwesomePro.Light.exclamationCircle
        } else if self.notifiType == .ERROR { bgNotifiColor = TTView.notificationBgError ; iconName = AwesomePro.Light.exclamationTriangle}
        let isAutoVerticalSize = self.sizeFrame == .AUTOMATIC ? true : false
        
        
        
        if self.type == .MESSAGE_STRECHES_VIEW && (self.positionType == .TOP || self.positionType == .TOP_BELOW_NAV) {
            if self.presentationType == .UIVIEWCONTROLER && self.positionType == .TOP_BELOW_NAV {
                self.padding = (0,0,0,0)
            } else {
                self.padding = (0,TTSize.H_STATUS,0,0); bgPanel = bgNotifiColor
            }
        } else if self.type == .MESSAGE_STRECHES_VIEW {
            self.padding = (0,0,0,0)
        }
        
        let notifiView = TTBaseNotificationView(withPadding: self.padding, bgColorNotifi: bgNotifiColor,bgPanelView: bgPanel, isAutoVerticalSize: isAutoVerticalSize)
        notifiView.iconView.setIConImage(with: iconName.rawValue,color: UIColor.white, scale: .scaleAspectFit).done()
        switch self.contentViewType {
        case .TEXT:
            notifiView.setHiddenIcon() ; notifiView.setHiddenButton()
            break
        case .ICON_TEXT:
            notifiView.setHiddenButton()
            break
        case .ICON_TEXT_BUTTON:
            break
        }
        
        switch self.notifiType {
        case .SUCCESS:
            notifiView.buttonRight.setBgColor(color: UIColor.white).setTextColor(color: UIColor.darkText).done()
            break
        case .WARNING:
            notifiView.buttonRight.setBgColor(color: UIColor.white).setTextColor(color: UIColor.darkText).done()
            break
        case .ERROR:
            notifiView.buttonRight.setBgColor(color: UIColor.white).setTextColor(color: UIColor.darkText).done()
            break
        }
        notifiView.layer.zPosition = CONSTANT.POSITION_VIEW.NOTIFICATION_VIEW.rawValue
        return notifiView
    }
}
