//
//  BaseSetupContraintsViewController.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 1/8/24.
//  Copyright © 2024 Truong Quang Tuan. All rights reserved.
//

import TTBaseUIKit

class BaseSetupContraintsViewController: BaseUIViewController {
    
    
    override var lgNavType: BaseUINavigationView.TYPE { return .DETAIL}
    override var navType: TTBaseUIViewController<DarkBaseUIView>.NAV_STYLE { return .STATUS_NAV}
    override var isSetHiddenTabar: Bool { return true }
    
    fileprivate var viewModel:BaseSetupContraintsViewModel = BaseSetupContraintsViewModel()
    
    let leftLabel:TTBaseUILabel = TTBaseUILabel(withType: .SUB_TITLE, text: "[Basic]", align: .center)
    let rightLabel:TTBaseUILabel = TTBaseUILabel(withType: .SUB_TITLE, text: "  How to use Auto Layout  ", align: .center)

    let bottomLabel:TTBaseInsetLabel = TTBaseInsetLabel.init(withInset: .init(top: 10, left: 10, bottom: 10, right: 10))
    
    let centerView:TTBaseShadowView = TTBaseShadowView()
    
    let bottomView:TTBaseShadowView = TTBaseShadowView()
    
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewCodable(with: [self.leftLabel, self.rightLabel, self.centerView, self.bottomView, self.bottomLabel])
    }

}


// MARK://TTViewCodable bindViewModel
extension BaseSetupContraintsViewController {
    
    func bindComponents() {
        
    }
    
    func bindViewModel() {
        
        self.viewModel.willShowLoading  = { [weak self] in guard let strongSelf = self else { return }
            DispatchQueue.main.async { strongSelf.showLoadingView(type: .TAB_TOP)}
        }
        
        self.viewModel.willRemoveLoading  = { [weak self] in guard let strongSelf = self else { return }
            DispatchQueue.main.async { strongSelf.removeLoading() }
        }
        
        self.viewModel.willShowMessage = { [weak self] mess in guard let strongSelf = self else { return }
            let stype:TTBaseNotificationViewConfig.NOTIFICATION_TYPE = mess.onCheckSuccess() ? .SUCCESS : .ERROR
            strongSelf.showNoticeView(body: mess.getDes(), style: stype)
        }
        
        self.viewModel.willRefreshData = { [weak self] vm in guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                
            }
        }
    }
}


// MARK://TTViewCodable Setup UIView
extension BaseSetupContraintsViewController : TTViewCodable {
    
    func setupData() {
        self.bottomLabel.setMutilLine(numberOfLine: 0, textAlignment: .center, mode: .byTruncatingTail)
        self.bottomLabel.setText(text: "TTBaseUIKit to make easy Auto Layout. This framework provides some functions to setup and update constraints")
    }
    func setupCustomView() {
        
    }
    
    func setupStyles() {
        self.leftLabel.setTextColor(color: UIColor.white).setBgColor(UIColor.random).setConerDef()
        self.rightLabel.setTextColor(color: UIColor.white).setBgColor(UIColor.random).setConerDef()
        self.bottomLabel.setTextColor(color: UIColor.white).setBgColor(UIColor.random).setConerDef()
        
        
        self.centerView.newPanelView.setBgColor(UIColor.random).setConerDef()
        
        self.bottomView.newPanelView.setBgColor(UIColor.random).setConerDef()
    }
    
    /*
     setLeadingAnchor : Set/Update value for current view or super view
     setTrailingAnchor(_ view:UIView? = nil, isUpdate:Bool = false, constant:CGFloat, isApplySafeArea:Bool = false, priority:UILayoutPriority? = nil)
     setTopAnchor(_ view:UIView? = nil, isUpdate:Bool = false, constant:CGFloat, priority:UILayoutPriority? = nil)
     setBottomAnchor(_ view:UIView? = nil, isUpdate:Bool = false, constant:CGFloat,isMarginsGuide:Bool = false, priority:UILayoutPriority? = nil)
     setCenterXAnchor(_ view:UIView? = nil, isUpdate:Bool = false, constant:CGFloat)
     setcenterYAnchor(_ view:UIView? = nil, isUpdate:Bool = false, constant:CGFloat)

     */
    func setupConstraints() {
        self.leftLabel.setHeightAnchor(constant: XSize.H_BUTTON)
            .setLeadingAnchor(constant: XSize.P_CONS_DEF * 2).setTrailingWithNextToView(view: self.rightLabel, constant: XSize.P_CONS_DEF * 2)
            .setTopAnchor(constant: XSize.getHeightNavWithStatus() + XSize.P_CONS_DEF * 2)
        

        self.rightLabel.setHorizontalContentHuggingPriority()
            .setHeightAnchor(constant: XSize.H_BUTTON)
            .setTrailingAnchor(constant: XSize.P_CONS_DEF * 2)
            .setTopAnchor(constant: XSize.getHeightNavWithStatus() + XSize.P_CONS_DEF * 2)
        
        
        self.centerView.setSquareSize(with: XSize.W / 3)
            .setFullCenterAnchor(constant: 0)
        
        
        self.bottomLabel.setVerticalContentHuggingPriority()
            .setLeadingAnchor(constant: XSize.H_BUTTON).setTrailingAnchor(constant: XSize.H_BUTTON)
            .setBottomAnchorWithBelowView(view: self.bottomView, constant: XSize.H_BUTTON)
        
        self.bottomView
            .setHeightAnchor(constant: XSize.H_BUTTON)
            .setLeadingAnchor(constant: XSize.H_BUTTON).setTrailingAnchor(constant: XSize.H_BUTTON)
            .setBottomAnchor(constant: XSize.P_CONS_DEF, isMarginsGuide:  true)
    }
}
