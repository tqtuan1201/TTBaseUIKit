//
//  BaseUINavigationView.swift
//  TTBaseUIKitExample
//
//  Created by Truong Quang Tuan on 6/7/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//
//

import Foundation
import TTBaseUIKit

@objc protocol BaseUINavigationViewDelegate {
    
    @objc optional func navDidTouchUpBackButton(withNavView nav:BaseUINavigationView)
    @objc optional func navDidTouchUpRightButton(withNavView nav:BaseUINavigationView)
    @objc optional func navDidTouchUpRightFilterButton(withNavView nav:BaseUINavigationView)
    @objc optional func navDidTouchUpTitle(withNavView nav:BaseUINavigationView)
    
}


extension TTBaseUINavigationView {
    func setHiddenNotification() {
        guard let lgNav = self as? BaseUINavigationView else { return }
        lgNav.setHiddenRightButton()
    }
}

class BaseUINavigationView: TTBaseUINavigationView {
    
    weak var delegate:BaseUINavigationViewDelegate?
    
    fileprivate let DEF_CONTRAINTS = TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF
    fileprivate let BUTTON_CONTRAINTS:CGFloat = 3
    
    enum NAV_BACK {
        case BACK_TO_ROOT
        case BACK_POP
        case DISSMISS
    }
    
    enum TYPE {
        case DEFAULT//Label-Label-Button
        case FILTER//Label-Label-Button-Button
        case DETAIL // Button-Label-(Button[Optional])
    }
    
    var type:TYPE = .DEFAULT
    
    
    fileprivate lazy var leftLabel:TTBaseUILabel  = {
        let lb = TTBaseUILabel(withType: .HEADER)
        lb.textAlignment = .left
        return lb
    }()
    
    fileprivate lazy var titleLabel:TTBaseUILabel  = {
        let lb = TTBaseUILabel()
        lb.textAlignment = .left
        return lb
    }()
    
    fileprivate lazy var rightButton:TTBaseUIButton = {
        let btn = TTBaseUIButton(type: .ICON)
        btn.backgroundColor = UIColor.clear
        btn.setIconImage(iconName: .bell, color: UIColor.white, padding: TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF / 2)
        return btn
    }()
    
    fileprivate lazy var filterButton:TTBaseUIButton = {
        let btn = TTBaseUIButton(type: .ICON)
        btn.backgroundColor = UIColor.clear
        btn.setIconImage(iconName: .filter, color: UIColor.white, padding: TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF / 2)
        return btn
    }()
    
    fileprivate lazy var backButton:TTBaseUIButton = {
        let btn = TTBaseUIButton(type: .ICON)
        btn.backgroundColor = UIColor.clear
        btn.setImage(UIImage(named:"back.png")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.contentEdgeInsets = UIEdgeInsets(top: XSize.P_CONS_DEF, left: XSize.P_CONS_DEF, bottom: XSize.P_CONS_DEF, right: XSize.P_CONS_DEF)
        btn.contentMode = UIView.ContentMode.scaleAspectFit
        btn.tintColor = UIColor.white
        return btn
    }()
    
    
    convenience init(withType type:TYPE) {
        self.init()
        self.type = type
        self.setupBaseUIView()
    }
    
    fileprivate func setupBaseUIView() {
        switch self.type {
        case .DEFAULT:
            self.setupViewCodable(with: [self.leftLabel, self.titleLabel, self.rightButton])
            break
        case .DETAIL:
            self.setupViewCodable(with: [self.backButton, self.titleLabel, self.rightButton])
            break
        case .FILTER:
            self.setupViewCodable(with: [self.leftLabel, self.titleLabel, self.filterButton, self.rightButton])
            self.filterButton.layer.zPosition = self.layer.zPosition + 10
            break
        }
        self.backButton.layer.zPosition = self.layer.zPosition + 10
        self.rightButton.layer.zPosition = self.layer.zPosition + 10
    }
    
    override func setTitle(title: String) {
        self.titleLabel.setText(text: title).done()
    }
}

// MARK: For Base Funcs
extension BaseUINavigationView {
    func setHiddenRightButton() {self.rightButton.isHidden = true }
    func setFilterIconRight() {
        
    }
}

extension BaseUINavigationView : TTViewCodable {
    
    
    func bindComponents() {
        self.backButton.onTouchHandler = { [weak self] button in guard let strongSelf = self else { return }
            strongSelf.delegate?.navDidTouchUpBackButton?(withNavView: strongSelf)
        }
        self.rightButton.onTouchHandler = { [weak self] button in guard let strongSelf = self else { return }
            strongSelf.delegate?.navDidTouchUpRightButton?(withNavView: strongSelf)
            UIApplication.topViewController()?.showNoticeView(body: "Right button")
        }
        self.filterButton.onTouchHandler = { [weak self] button in guard let strongSelf = self else { return }
            strongSelf.delegate?.navDidTouchUpRightFilterButton?(withNavView: strongSelf)
        }
    }
    func setupStyles() {
        
        self.backgroundColor = TTBaseUIKitConfig.getViewConfig().viewBgNavColor
        self.leftLabel.setText(text: "TTBaseUIKit").setTextColor(color: UIColor.white).setBold().backgroundColor = UIColor.clear
        self.titleLabel.setText(text: "DEMO").setTextColor(color: UIColor.white).backgroundColor = UIColor.clear
        self.rightButton.backgroundColor = UIColor.clear
        self.rightButton.setTextColor(color: UIColor.white).tintColor = UIColor.white
    }
    
    func setupConstraints() {
        
        switch self.type {
        case .DEFAULT:
            self.setContraintsForDefault()
            break
        case .DETAIL:
            self.setContraintsForDetail()
            break
        case .FILTER:
            self.setContraintsForFilter()
            break
        }
        
    }
    
    
    
}

//MARK:// For Constraints
extension BaseUINavigationView {
    
    fileprivate func setContraintsForDefault() {
        self.leftLabel.setHorizontalContentHuggingPriority().setTopAnchor(constant: DEF_CONTRAINTS).setLeadingAnchor(constant: DEF_CONTRAINTS).setBottomAnchor(constant: DEF_CONTRAINTS).done()
        
        self.rightButton.setTrailingAnchor(constant: 0).setTopAnchor(constant: BUTTON_CONTRAINTS).setBottomAnchor(constant: BUTTON_CONTRAINTS).widthAnchor.constraint(equalTo: self.rightButton.heightAnchor, multiplier: 1).isActive = true
        
        self.titleLabel.setHorizontalContentHuggingPriority().setTopAnchor(constant: DEF_CONTRAINTS).setBottomAnchor(constant: DEF_CONTRAINTS).setTrailingWithNextToView(view: self.rightButton, constant: DEF_CONTRAINTS).done()
    }
    
    fileprivate func setContraintsForDetail() {
        self.backButton.setLeadingAnchor(constant: BUTTON_CONTRAINTS).setTopAnchor(constant: BUTTON_CONTRAINTS).setBottomAnchor(constant: BUTTON_CONTRAINTS).widthAnchor.constraint(equalTo: self.rightButton.heightAnchor, multiplier: 1).isActive = true
        
        self.titleLabel.setLeadingWithNextToView(view: self.backButton, constant: DEF_CONTRAINTS).setTopAnchor(constant: DEF_CONTRAINTS).setBottomAnchor(constant: DEF_CONTRAINTS).setTrailingWithNextToView(view: self.rightButton, constant: DEF_CONTRAINTS).done()
        
        self.rightButton.setTrailingAnchor(constant: 0).setTopAnchor(constant: BUTTON_CONTRAINTS).setBottomAnchor(constant: BUTTON_CONTRAINTS).widthAnchor.constraint(equalTo: self.rightButton.heightAnchor, multiplier: 1).isActive = true
    }
    
    fileprivate func setContraintsForFilter() {
        
        self.leftLabel.setHorizontalContentHuggingPriority().setTopAnchor(constant: DEF_CONTRAINTS).setLeadingAnchor(constant: DEF_CONTRAINTS).setBottomAnchor(constant: DEF_CONTRAINTS).done()
        
        self.titleLabel.setHorizontalContentHuggingPriority().setTopAnchor(constant: DEF_CONTRAINTS).setBottomAnchor(constant: DEF_CONTRAINTS).setTrailingWithNextToView(view: self.filterButton, constant: DEF_CONTRAINTS).done()
        
        self.filterButton.setTopAnchor(constant: BUTTON_CONTRAINTS).setBottomAnchor(constant: BUTTON_CONTRAINTS).setTrailingWithNextToView(view: self.rightButton, constant: DEF_CONTRAINTS) .widthAnchor.constraint(equalTo: self.rightButton.heightAnchor, multiplier: 1).isActive = true
        self.rightButton.setTrailingAnchor(constant: 0).setTopAnchor(constant: BUTTON_CONTRAINTS).setBottomAnchor(constant: BUTTON_CONTRAINTS).widthAnchor.constraint(equalTo: self.rightButton.heightAnchor, multiplier: 1).isActive = true
    }
    
}





