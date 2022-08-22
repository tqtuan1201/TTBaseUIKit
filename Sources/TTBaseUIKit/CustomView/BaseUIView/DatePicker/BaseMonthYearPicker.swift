//
//  BaseDatePicker.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 5/21/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseMonthYearPicker: TTBasePopupViewController {
    
    open var previousYear:Int { get { return 40 } }
    
    fileprivate var months:[String] = (1...12).map{ i in String(i) }
    fileprivate var years:[String] = []
    
    public enum TYPE  {
        case MONTH(month:String?) // "DD"
        case YEAR(year:String?) // "2019"
        case MONTH_YEAR(String?,String?) //(01,2019)
    }
    
    fileprivate var locate:Locale = Locale(identifier: "vi_VN")
    fileprivate var type:TYPE = .MONTH_YEAR(nil,nil)
    fileprivate var selectedMonthYear:(String?, String?) = (nil, nil)
    public lazy var panel:TTBaseUIView = TTBaseUIView(withCornerRadius: TTBaseUIKitConfig.getSizeConfig().CORNER_RADIUS)
    public lazy var panelButtonView:TTBaseUIStackView = TTBaseUIStackView(axis: .horizontal, spacing: TTSize.P_CONS_DEF, alignment: .fill, distributionValue: .fillEqually)
    public lazy var cancelButton:TTBaseUIButton = TTBaseUIButton(textString: "Cancel", type: .DEFAULT, isSetSize: false)
    public lazy var okButton:TTBaseUIButton = TTBaseUIButton(textString: "Select", type: .WARRING, isSetSize: false)
    
    public lazy var font:UIFont = UIFont.systemFont(ofSize: 12)
    public lazy var textColor:UIColor = TTView.textDefColor
    public lazy var textSelectedColor:UIColor = TTView.textWarringColor
    public lazy var timePicker: UIPickerView = UIPickerView()
    public lazy var bgColor:UIColor = .white
    public lazy var HEIGHT_BUTTON:CGFloat = TTSize.H_BUTTON
    
    public var didDatePickerValueChanged:((_ date:Date) -> Void)?
    public var didTouchCancelButton:(() -> Void)?
    public var didTouchOKButton:((_ monthYear:(String?, String?)?) -> Void)?
    
    open override var navType: TTBaseUIViewController<DarkBaseUIView>.NAV_STYLE { get { return .NO_VIEW}}
    
    public init() {
        super.init(isAllowTouchPanel: false)
        self.setupViewCodable(with: [])
    }
    
    public init(with type:TYPE, locate:Locale,  isAllowTouchPanel:Bool, textColor:UIColor = UIColor.darkText) {
        super.init(isAllowTouchPanel: isAllowTouchPanel)
        self.locate = locate
        self.type = type
        self.textColor = textColor
        self.setupViewCodable(with: [])
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        DispatchQueue.main.async { [weak self] in self?.autoScrollToSelectedValue() }
    }
    
    fileprivate func autoScrollToSelectedValue() {
        let indexs = self.getIndexSelectedValue()
        switch self.type {
        case .MONTH(let month):
            self.selectedMonthYear.0 = month
            if let indexMonth = indexs.0 { DispatchQueue.main.async { self.timePicker.selectRow(indexMonth, inComponent: 0, animated: true)}}
        case .YEAR(let year):
            self.selectedMonthYear.1 = year
            if let indexYear = indexs.1 { DispatchQueue.main.async { self.timePicker.selectRow(indexYear, inComponent: 0, animated: true)}}
        case .MONTH_YEAR(let monthYear):
            self.selectedMonthYear.0 = monthYear.0
            self.selectedMonthYear.1 = monthYear.1
            if let indexMonth = indexs.0 { DispatchQueue.main.async { self.timePicker.selectRow(indexMonth, inComponent: 0, animated: true)}}
            if let indexYear = indexs.1 { DispatchQueue.main.async { self.timePicker.selectRow(indexYear, inComponent: 1, animated: true)}}
        }
    }
    
    fileprivate func getIndexSelectedValue() -> (Int?,Int?) {
        switch self.type {
        case .MONTH(let month):
            return (self.getIndexForMonth(withMonth: month), nil)
        case .YEAR(let year):
            return (self.getIndexForMonth(withMonth: year), nil)
        case .MONTH_YEAR(let monthYear):
            return (self.getIndexForMonth(withMonth: monthYear.0), self.getIndexForYear(withMonth: monthYear.1))
        }
    }
    
    fileprivate func getIndexForMonth(withMonth monthString:String?) -> Int? {
        for (index, month) in self.months.enumerated() { if month == monthString { return index} }
        return nil
    }
    fileprivate func getIndexForYear(withMonth yearString:String?) -> Int? {
        for (index, year) in self.years.enumerated() { if year == yearString { return index} }
        return nil
    }
    
}
//MARK:// For base funcs
extension TTBaseMonthYearPicker {
    
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
    
    fileprivate func getDisplayMonth(with month:String) -> String {
        return ("04-\(month)-1991 00:00:00".toDate(withFormat: .DD_MM_YYYY_HH_MM_SS)?.monthName(with: self.locate) ?? month)
    }
}

extension TTBaseMonthYearPicker: TTViewCodable {
    
    
    public func setupData() {
        var years: [String] = []
        if years.count == 0 {
            var year = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: Date())
            for _ in 1...previousYear {
                years.append(String(year))
                year -= 1
            }
        }
        self.years = years
        
    }
    
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
        self.timePicker.delegate = self
        self.timePicker.dataSource = self
        self.timePicker.setValue(self.textColor, forKey: "textColor")
        
    }
    
    public func bindComponents() {
        
        self.cancelButton.onTouchHandler = { [weak self] button in guard let strongSelf = self else { return }
            strongSelf.didTouchCancelButton?()
            strongSelf.dismiss(animated: true, completion: nil)
        }
        
        self.okButton.onTouchHandler = { [weak self] button in guard let strongSelf = self else { return }
            TTBaseFunc.shared.printLog(object: "Month: \(strongSelf.selectedMonthYear.0 ?? "")")
            TTBaseFunc.shared.printLog(object: "Year: \(strongSelf.selectedMonthYear.1 ?? "")")
            strongSelf.didTouchOKButton?(strongSelf.selectedMonthYear)
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


extension TTBaseMonthYearPicker : UIPickerViewDelegate, UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch self.type {
        case .MONTH, .YEAR:
            return 1
        case .MONTH_YEAR:
            return 2
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch self.type {
        case .MONTH:
            return self.months.count
        case .YEAR:
            return self.years.count
        case .MONTH_YEAR:
            if component == 0 {
                return self.months.count
            } else {
                return self.years.count
            }
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        switch self.type {
        case .MONTH (let month):
            if component == 0 {
                if self.months.indices.contains(row) {
                    let monthString = self.months[row]
                    let monthDisplayString =  self.getDisplayMonth(with: monthString)
                    let color = (monthString == month) ? self.textSelectedColor : self.textColor
                    return NSAttributedString(string: monthDisplayString, attributes: [NSAttributedString.Key.font:self.font,NSAttributedString.Key.foregroundColor:color])
                }
            }
            return nil
        case .YEAR(let year):
            if component == 0 {
                if self.years.indices.contains(row) {
                    let yearString =  self.years[row]
                    let color = (yearString == year) ? self.textSelectedColor : self.textColor
                    return NSAttributedString(string: yearString, attributes: [NSAttributedString.Key.font:self.font,NSAttributedString.Key.foregroundColor:color])
                }
            }
            return nil
        case .MONTH_YEAR(let monthYear):
            if component == 0 {
                if self.months.indices.contains(row) {
                    let monthString = self.months[row]
                    let monthDisplayString =  self.getDisplayMonth(with: monthString)
                    let color = (monthString == monthYear.0) ? self.textSelectedColor : self.textColor
                    return NSAttributedString(string: monthDisplayString, attributes: [NSAttributedString.Key.font:self.font,NSAttributedString.Key.foregroundColor:color])
                }
            } else if component == 1 {
                if self.years.indices.contains(row) {
                    let yearString =  self.years[row]
                    let color = (yearString == monthYear.1) ? self.textSelectedColor : self.textColor
                    return NSAttributedString(string: yearString, attributes: [NSAttributedString.Key.font:self.font,NSAttributedString.Key.foregroundColor:color])
                }
            }
            return nil
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch self.type {
        case .MONTH:
            if self.months.indices.contains(row) { self.selectedMonthYear.0 = self.months[row]}
            break
        case .YEAR:
            if self.years.indices.contains(row) { self.selectedMonthYear.1 = self.years[row]}
            break
        case .MONTH_YEAR:
            if component == 0 {
                if self.months.indices.contains(row) { self.selectedMonthYear.0 = self.months[row]}
            } else {
                if self.years.indices.contains(row) { self.selectedMonthYear.1 = self.years[row]}
            }
            break
        }
    }
}
