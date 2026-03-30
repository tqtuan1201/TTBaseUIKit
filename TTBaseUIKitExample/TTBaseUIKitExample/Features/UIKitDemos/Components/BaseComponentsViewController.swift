//
//  BaseComponentsViewController.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 31/7/24.
//  Copyright © 2024 Truong Quang Tuan. All rights reserved.
//

import TTBaseUIKit

class BaseComponentsViewController: BaseUIViewController {
    
    
    override var lgNavType: BaseUINavigationView.TYPE { return .DETAIL}
    override var navType: TTBaseUIViewController<DarkBaseUIView>.NAV_STYLE { return .STATUS_NAV}
    override var isSetHiddenTabar: Bool { return true }
    
    fileprivate let stackView:TTBaseScrollUIStackView = TTBaseScrollUIStackView(with: .init(axis: .vertical, spacing: XSize.P_CONS_DEF * 2, alignment: .fill, distributionValue: .fill))
    fileprivate var viewModel:BaseComponentsViewModel = BaseComponentsViewModel()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewCodable(with: [self.stackView])
    }
    
}


// MARK://TTViewCodable bindViewModel
extension BaseComponentsViewController {
    
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
extension BaseComponentsViewController : TTViewCodable {
    
    func setupData() {
        self.setTitleNav("Base Components ViewController".uppercased())
    }
    func setupCustomView() {
        
        //TTBaseUIView
        let baseView:TTBaseUIView = TTBaseUIView()
        baseView.setConerDef()
        baseView.setHeightAnchor(constant: XSize.H_BUTTON)
        
        self.stackView.baseStackView.addArrangedSubview(DemoCustomView.init(title: "TTBaseUIView", view: baseView))
        
        //TTBaseShadowView
        let baseShadowView:TTBaseShadowView = TTBaseShadowView()
        baseShadowView.setHeightAnchor(constant: XSize.H_BUTTON)
        
        self.stackView.baseStackView.addArrangedSubview(DemoCustomView.init(title: "TTBaseShadowView", view: baseShadowView))

        //TTBaseUILabel
        let baseLabel:TTBaseUILabel = TTBaseUILabel.init(withType: .TITLE, text: "A component for displaying static text", align: .center)
        baseLabel.setHeightAnchor(constant: XSize.H_BUTTON)
        self.stackView.baseStackView.addArrangedSubview(DemoCustomView.init(title: "TTBaseUILabel", view: baseLabel))
        
        //TTLableSubLabelView
        let baseLabelSubLabel:TTLableSubLabelView = TTLableSubLabelView.init()
        baseLabelSubLabel.setHeightAnchor(constant: XSize.H_BUTTON)
        self.stackView.baseStackView.addArrangedSubview(DemoCustomView.init(title: "TTLableSubLabelView", view: baseLabelSubLabel))
        
        //TTBaseUIButton
        let button:TTBaseUIButton = TTBaseUIButton.init(textString: "TTBaseUIButton", type: .DEFAULT, isSetSize: false, isSetHeight: false)
        button.setHeightAnchor(constant: XSize.H_BUTTON)
        
        self.stackView.baseStackView.addArrangedSubview(DemoCustomView.init(title: "TTBaseUIButton", view: button))

        //TTBaseTwoButtonDiffWidthView
        let twoButtonSameWidth:TTTwoButtomView = TTTwoButtomView.init(withTitle: "Left Button", right: "Right Button")
        self.stackView.baseStackView.addArrangedSubview(DemoCustomView.init(title: "TTTwoButtomView", view: twoButtonSameWidth))
        
        //TTBaseTwoButtonDiffWidthView
        let twoButton:TTBaseTwoButtonDiffWidthView = TTBaseTwoButtonDiffWidthView.init(withText: "Back", right: "Right Button")
        self.stackView.baseStackView.addArrangedSubview(DemoCustomView.init(title: "TTBaseTwoButtonDiffWidthView", view: twoButton))
        
        
        //TTBaseUITextField
        let textField:TTBaseUITextField = TTBaseUITextField.init(withPlaceholder: "TTBaseUITextField", textPadding: .init(top: 8, left: 8, bottom: 8, right: 8))
        textField.setHeightAnchor(constant: XSize.H_TEXTFIELD)
        
        self.stackView.baseStackView.addArrangedSubview(DemoCustomView.init(title: "TTBaseUITextField", view: textField))
        
        
        //TTIconLabelTextFieldView
        let iconTexfiField:TTIconLabelTextFieldView = TTIconLabelTextFieldView.init(withIcon: .user, coner: 4.0, paddingContentImage: XSize.P_CONS_DEF * 2)
        self.stackView.baseStackView.addArrangedSubview(DemoCustomView.init(title: "TTIconLabelTextFieldView", view: iconTexfiField))
        
        //TTIconLabelTextFieldHorizontalView
        let iconTexfiFieldHor:TTIconLabelTextFieldHorizontalView = TTIconLabelTextFieldHorizontalView.init(type: .ICON_LABEL_TEXTFIELD, textFieldType: .DEFAULT, corner: 8.0)
        self.stackView.baseStackView.addArrangedSubview(DemoCustomView.init(title: "TTIconLabelTextFieldHorizontalView", view: iconTexfiFieldHor))
        
        //TTLabelLeftRightView
        let leftRightLabel:TTLabelLeftRightView = TTLabelLeftRightView.init(withType: .TITLE, coner: 8.0, isHuggingRight: true)
        leftRightLabel.setText(withTextLeft: "Left Label", right: "Right Label")
        self.stackView.baseStackView.addArrangedSubview(DemoCustomView.init(title: "TTLabelLeftRightView", view: leftRightLabel))
        
        //TTBaseUITextView
        let textview:TTBaseUITextView = TTBaseUITextView.init(with: .DEFAULT, isSetHiddenKeyboardAccessoryView: true)
        textview.setHeightAnchor(constant: XSize.H_TEXTFIELD)
        textview.setText(text: "TTBaseUITextView")
        self.stackView.baseStackView.addArrangedSubview(DemoCustomView.init(title: "TTBaseUITextView", view: textview))
        
        //BaseUINavigationView
        let navView:BaseUINavigationView = BaseUINavigationView.init(withType: .DEFAULT)
        navView.setConerDef()
        navView.setHeightAnchor(constant: XSize.H_NAV)        
        self.stackView.baseStackView.addArrangedSubview(DemoCustomView.init(title: "BaseUINavigationView", view: navView))
        
        //TTBaseUIImageView
        let imgView:TTBaseUIImageView = TTBaseUIImageView.init(imageName: "bg.view", contentMode: .scaleAspectFill)
        imgView.setConerDef()
        imgView.setHeightAnchor(constant: XSize.H_BUTTON * 2.4)
        
        self.stackView.baseStackView.addArrangedSubview(DemoCustomView.init(title: "TTBaseUIImageView", view: imgView))
        
        //TTBaseNewSegmentedControl
        let segView:TTBaseNewSegmentedControl = TTBaseNewSegmentedControl.init(items: ["Seg Item 1","Seg Item 2"])
        segView.setConerDef()
        segView.setHeightAnchor(constant: XSize.H_SEG)
        
        self.stackView.baseStackView.addArrangedSubview(DemoCustomView.init(title: "TTBaseNewSegmentedControl", view: segView))
        
        //TTBaseSearchView
        let searchView:TTBaseSearchView = TTBaseSearchView.init(withIconColor: .gray, searchPlaceholder: "Search Placeholder")
        searchView.setConerDef()
        
        self.stackView.baseStackView.addArrangedSubview(DemoCustomView.init(title: "TTBaseSearchView", view: searchView))
        
        //More
        let moreLabel:TTBaseUILabel = TTBaseUILabel.init(withType: .TITLE, text: "View more", align: .center)
        moreLabel.setHeightAnchor(constant: XSize.H_BUTTON)
        moreLabel.setBold().setTextColor(color: XView.labelBgDef)
        moreLabel.setTouchHandler().onTouchHandler = { _ in
            self.runOnMainThread {
                self.showMessagePopup(mess: "Views all base components") {
                    let webVC:WebViewController = WebViewController.init(navTitle: "/CustomView/BaseUIView/", urlString: "https://github.com/tqtuan1201/TTBaseUIKit/tree/master/Sources/TTBaseUIKit/CustomView/BaseUIView")
                    self.push(webVC)
                }
            }
        }
        self.stackView.baseStackView.addArrangedSubview(moreLabel)
        
    }
    
    func setupStyles() {
        self.view.backgroundColor = UIColor.white
    }
    
    func setupConstraints() {
        self.stackView.setTopAnchor(constant: XSize.getHeightNavWithStatus() + XSize.P_CONS_DEF * 2)
            .setLeadingAnchor(constant: XSize.P_CONS_DEF * 2).setTrailingAnchor(constant: XSize.P_CONS_DEF * 2)
            .setBottomAnchor(constant: XSize.P_CONS_DEF, isMarginsGuide: true)
    }
}
