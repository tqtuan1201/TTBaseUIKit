//
//  DemoViewController.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/7/24.
//  Copyright © 2024 Truong Quang Tuan. All rights reserved.
//

import TTBaseUIKit

class DemoViewController: BaseUIViewController {
    
    
    override var lgNavType: BaseUINavigationView.TYPE { return .DETAIL}
    override var navType: TTBaseUIViewController<DarkBaseUIView>.NAV_STYLE { return .STATUS_NAV}
    override var isSetHiddenTabar: Bool { return true }
    
    fileprivate var viewModel:DemoViewModel = DemoViewModel()
    fileprivate let stackView:TTBaseScrollUIStackView = TTBaseScrollUIStackView(with: .init(axis: .vertical, spacing: XSize.P_CONS_DEF, alignment: .fill, distributionValue: .fill))
    fileprivate let headerView:TTBaseShadowView = TTBaseShadowView()
    fileprivate let messageLabel:TTBaseUILabel = TTBaseUILabel.init(withType: .HEADER, text: "Demo\nBaseUIViewController", align: .center)
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewCodable(with: [self.headerView, self.stackView])
    }
    
}


// MARK://TTViewCodable bindViewModel
extension DemoViewController {
    
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
extension DemoViewController : TTViewCodable {
    
    func setupData() {
        self.setTitleNav("BaseUIViewController".uppercased())
        let textAttr:NSMutableAttributedString = NSMutableAttributedString()
        textAttr.bold("Demo\n", textColor: .black, systemFontsize: XFont.TITLE_H)
        textAttr.normal("BaseUIViewController", textColor: .gray, systemFontsize: XFont.HEADER_H)
        self.messageLabel.setTextAttr(with: textAttr)
    }
    func setupCustomView() {
        self.headerView.addSubview(self.messageLabel)
        
        let body1View:TTBaseShadowView = TTBaseShadowView()
        let body2View:TTBaseShadowView = TTBaseShadowView()
        let body3View:TTBaseShadowView = TTBaseShadowView()
        
        body1View.setHeightAnchor(constant: XSize.H_BUTTON)
        body2View.setHeightAnchor(constant: XSize.H_BUTTON * 2)
        body3View.setHeightAnchor(constant: XSize.H_BUTTON * 4)
        
        self.stackView.baseStackView.addArrangedSubview(body1View)
        self.stackView.baseStackView.addArrangedSubview(body2View)
        self.stackView.baseStackView.addArrangedSubview(body3View)
    }
    
    func setupStyles() {
        self.messageLabel.setMutilLine(numberOfLine: 0, textAlignment: .center, mode: .byTruncatingTail)
    }
    
    func setupConstraints() {
        self.headerView.setLeadingAnchor(constant: XSize.P_CONS_DEF * 2).setTrailingAnchor(constant: XSize.P_CONS_DEF * 2)
            .setHeightAnchor(constant: XSize.H_BUTTON * 3)
            .setTopAnchor(constant: XSize.getHeightNavWithStatus() + XSize.P_CONS_DEF * 2)
        
        self.messageLabel.setFullContraints(constant: XSize.P_CONS_DEF)
        
        self.stackView.setTopAnchorWithAboveView(nextToView: self.headerView, constant: XSize.P_CONS_DEF * 2)
            .setLeadingAnchor(constant: XSize.P_CONS_DEF * 2).setTrailingAnchor(constant: XSize.P_CONS_DEF * 2)
            .setBottomAnchor(constant: XSize.P_CONS_DEF, isMarginsGuide: true)
    }
}
