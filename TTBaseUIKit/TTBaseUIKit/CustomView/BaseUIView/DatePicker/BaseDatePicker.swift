//
//  BaseDatePicker.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 5/21/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseDatePicker: TTBasePopupViewController {
    
    public lazy var panel:TTBaseUIView = TTBaseUIView(withCornerRadius: TTBaseUIKitConfig.getSizeConfig().CORNER_RADIUS)
    public lazy var panelButtonView:TTBaseUIStackView = TTBaseUIStackView(axis: .horizontal, spacing: TTSize.P_CONS_DEF, alignment: .fill, distributionValue: .fillEqually)
    public lazy var cancelButton:TTBaseUIButton = TTBaseUIButton(textString: "Cancel", type: .DEFAULT, isSetSize: false)
    public lazy var okButton:TTBaseUIButton = TTBaseUIButton(textString: "Select", type: .WARRING, isSetSize: false)
    
    public lazy var textColor:UIColor = UIColor.darkText
    public lazy var timePicker: UIDatePicker = UIDatePicker()
    public lazy var selectedDate:Date = Date()
    public lazy var bgColor:UIColor = .white
    public lazy var mode:UIDatePicker.Mode = .date
    public lazy var HEIGHT_BUTTON:CGFloat = TTSize.H_BUTTON
    
    public var didDatePickerValueChanged:((_ date:Date) -> Void)?
    public var didTouchCancelButton:(() -> Void)?
    public var didTouchOKButton:((_ date:Date) -> Void)?
    
    open override var navType: TTBaseUIViewController<DarkBaseUIView>.NAV_STYLE { get { return .NO_VIEW}}
    
    public init() {
        super.init(isAllowTouchPanel: false)
        self.setupViewCodable(with: []) 
    }
    
    public init(with isAllowTouchPanel:Bool, selectedDate:Date, mode:UIDatePicker.Mode = .date, textColor:UIColor = UIColor.darkText) {
        super.init(isAllowTouchPanel: isAllowTouchPanel)
        self.selectedDate = selectedDate
        self.mode = mode
        self.textColor = textColor
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async { self.setupViewCodable(with: []) }
    }
    
    @objc fileprivate func datePickerValueChanged(_ sender: UIDatePicker){
        self.selectedDate = sender.date
        self.didDatePickerValueChanged?(sender.date)
    }
}
//MARK:// For base funcs
extension TTBaseDatePicker {
    
    public func setText(forLeftButton left:String, right:String) {
        self.cancelButton.setText(text: left).done()
        self.okButton.setText(text: right).done()
    }
    
    public func setHiddenButton() {
        self.cancelButton.isHidden = true
        self.okButton.isHidden = true
        self.panelButtonView.setHeightAnchor(constant: 1).done()
    }
    
    public func setHiddenCancelButton() {
        self.cancelButton.isHidden = true
    }
    
    public func setColor(withPanel panel:UIColor, text:UIColor, leftButton:UIColor,rightButton:UIColor) {
        self.bgColor = panel
        self.textColor = text
        self.cancelButton.setBgColor(color: leftButton).done()
        self.okButton.setBgColor(color: rightButton).done()
    }
}

extension TTBaseDatePicker: TTViewCodable {
    
    public func setupCustomView() {
        self.panelButtonView.addArrangedSubview(self.cancelButton)
        self.panelButtonView.addArrangedSubview(self.okButton)
        
        self.panel.addSubview(self.timePicker)
        self.panel.addSubview(self.panelButtonView)
        
        self.view.addSubview(self.panel)
    }
    
    public func setupStyles() {
        self.panel.backgroundColor = self.bgColor
        self.timePicker.backgroundColor = UIColor.clear
        self.timePicker.datePickerMode = self.mode
        self.timePicker.setValue(self.textColor, forKey: "textColor")
        
    }
    
    public func setupData() {
        // Set some of UIDatePicker properties
        self.timePicker.timeZone = NSTimeZone.local
        self.timePicker.backgroundColor = UIColor.white
        DispatchQueue.main.async { [weak self] in guard let strongSelf = self else { return }
            strongSelf.timePicker.setDate(strongSelf.selectedDate, animated: true)
        }
    }
    
    public func bindComponents() {
        self.timePicker.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: .valueChanged)
        
        self.cancelButton.onTouchHandler = { [weak self] button in guard let strongSelf = self else { return }
            strongSelf.didTouchCancelButton?()
            strongSelf.dismiss(animated: true, completion: nil)
        }
        
        self.okButton.onTouchHandler = { [weak self] button in guard let strongSelf = self else { return }
            strongSelf.didTouchOKButton?(strongSelf.selectedDate)
            strongSelf.dismiss(animated: true, completion: nil)
        }
        
    }
    
    public func setupConstraints() {
        self.timePicker.translatesAutoresizingMaskIntoConstraints = false
        if Device.isPad() {
            self.panel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
        } else {
            self.panel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85).isActive = true
        }
        
        self.panel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 1).isActive = true
        self.panel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 1).isActive = true
        
        self.timePicker.setLeadingAnchor(constant: P_CONS_DEF).setTopAnchor(constant: 0).setTrailingAnchor(constant: P_CONS_DEF).done()
        self.timePicker.heightAnchor.constraint(equalTo: self.timePicker.widthAnchor, multiplier: 1).isActive = true
        
        self.panelButtonView.setTopAnchorWithAboveView(nextToView: self.timePicker, constant: 0).setBottomAnchor(constant: P_CONS_DEF).done()
        self.panelButtonView.setLeadingAnchor(constant: P_CONS_DEF).setTrailingAnchor(constant: P_CONS_DEF).done()
        self.panelButtonView.setHeightAnchor(constant: HEIGHT_BUTTON).done()
    }
}

