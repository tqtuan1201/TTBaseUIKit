//
//  BaseSetupContraintsViewController.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 1/8/24.
//  Copyright © 2024 Truong Quang Tuan. All rights reserved.
//

import TTBaseUIKit

class AdvanceSetupContraintsViewController: BaseUIViewController {
    
    
    override var lgNavType: BaseUINavigationView.TYPE { return .DETAIL}
    override var navType: TTBaseUIViewController<DarkBaseUIView>.NAV_STYLE { return .STATUS_NAV}
    override var isSetHiddenTabar: Bool { return true }
    
    fileprivate var viewModel:BaseSetupContraintsViewModel = BaseSetupContraintsViewModel()
    
    let headerLeftLabel:TTBaseUILabel = TTBaseUILabel(withType: .SUB_TITLE, text: "[Header Left]", align: .center)
    let headerRightTopLabel:TTBaseUILabel = TTBaseUILabel(withType: .SUB_TITLE, text: "[Header Label top 1]", align: .center)
    let headerRightBottomLabel:TTBaseUILabel = TTBaseUILabel(withType: .SUB_TITLE, text: "[Header Label top 2]", align: .center)
    let headerView:TTBaseShadowView = TTBaseShadowView()

    let bodyScrollStack:TTBaseScrollUIStackView = TTBaseScrollUIStackView.init(with: .init(axis: .vertical, spacing: XSize.P_CONS_DEF / 2, alignment: .fill, distributionValue: .fill))
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewCodable(with: [self.headerView, self.bodyScrollStack])
    }
}


// MARK://TTViewCodable bindViewModel
extension AdvanceSetupContraintsViewController {
    
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
extension AdvanceSetupContraintsViewController : TTViewCodable {
    
    func setupData() {
        //self.bottomLabel.setMutilLine(numberOfLine: 0, textAlignment: .center, mode: .byTruncatingTail)
        //self.bottomLabel.setText(text: "TTBaseUIKit to make easy Auto Layout. This framework provides some functions to setup and update constraints")
        self.setTitleNav("Constraints Setup Sample".uppercased())
        self.viewModel.items.forEach { i in
            let textLabel:TTBaseInsetLabel = TTBaseInsetLabel.init(withInset: .init(top: 10, left: 10, bottom: 10, right: 10))
            textLabel.setMutilLine(numberOfLine: 0, textAlignment: .center, mode: .byTruncatingTail)
            textLabel.setText(text: i)
            textLabel.setVerticalContentHuggingPriority()
            textLabel.setTextColor(color: UIColor.white).setBgColor(UIColor.black.withAlphaComponent(0.8)).setConerDef()
            
            let panelView:TTBaseUIView = TTBaseUIView()
            panelView.setBgColor(UIColor.clear)
            panelView.addSubview(textLabel)
            textLabel.setFullContraints(lead: XSize.P_CONS_DEF, trail: XSize.P_CONS_DEF, top: XSize.P_CONS_DEF / 2, bottom: XSize.P_CONS_DEF / 2)
            self.bodyScrollStack.baseStackView.addArrangedSubview(panelView)
            
            panelView.setTouchHandler().onTouchHandler = { _ in
                UIApplication.topViewController()?.showNoticeView(body: i)
            }
        }
    }
    func setupCustomView() {
        self.headerView.newPanelView.addSubview(self.headerLeftLabel)
        self.headerView.newPanelView.addSubview(self.headerRightTopLabel)
        self.headerView.newPanelView.addSubview(self.headerRightBottomLabel)
    }
    
    func setupStyles() {
        self.bodyScrollStack.contentInset.top = XSize.P_CONS_DEF * 2
        self.headerLeftLabel.setTextColor(color: UIColor.white).setBgColor(UIColor.random).setConerDef()
        self.headerRightTopLabel.setTextColor(color: UIColor.white).setBgColor(UIColor.random).setConerDef()
        self.headerRightBottomLabel.setTextColor(color: UIColor.white).setBgColor(UIColor.random).setConerDef()
        self.bodyScrollStack.backgroundColor = UIColor.white
        self.bodyScrollStack.setConerRadius(with: 12)
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
        self.headerView.setHeightAnchor(constant: XSize.H / 3.3).setTopAnchor(constant: XSize.getHeightNavWithStatus() + XSize.P_CONS_DEF)
            .setLeadingAnchor(constant: XSize.P_CONS_DEF).setTrailingAnchor(constant: XSize.P_CONS_DEF)
        
        
        self.headerLeftLabel.setTopAnchor(constant: XSize.P_CONS_DEF).setBottomAnchor(constant: XSize.P_CONS_DEF)
            .setLeadingAnchor(constant: XSize.P_CONS_DEF).setTrailingWithNextToView(view: self.headerRightTopLabel, constant: XSize.P_CONS_DEF)
            .widthAnchor.constraint(equalTo: self.headerRightTopLabel.widthAnchor, multiplier: 0.34).isActive = true
        
        self.headerRightTopLabel.setTopAnchor(constant: XSize.P_CONS_DEF)
            .setHeightAnchor(constant: XSize.H_BUTTON * 2)
            .setTrailingAnchor(constant: XSize.P_CONS_DEF)
        
        
        self.headerRightBottomLabel.setTopAnchorWithAboveView(nextToView: self.headerRightTopLabel, constant: XSize.P_CONS_DEF)
            .setLeadingWithNextToView(view: self.headerLeftLabel, constant: XSize.P_CONS_DEF)
            .setTrailingAnchor(constant: XSize.P_CONS_DEF).setBottomAnchor(constant: XSize.P_CONS_DEF)
        
        self.bodyScrollStack.setTopAnchorWithAboveView(nextToView: self.headerView, constant: XSize.P_CONS_DEF * 2)
            .setLeadingAnchor(constant: 0).setTrailingAnchor(constant: 0)
            .setBottomAnchor(constant: 0, isMarginsGuide: true)
            
    }
}
