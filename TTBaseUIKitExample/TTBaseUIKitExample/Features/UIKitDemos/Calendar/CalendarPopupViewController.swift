//
//  CalendarPopupViewController.swift
//  12BayV2
//
//  Created by Tuan Truong Quang on 8/1/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import TTBaseUIKit

protocol CalendarPopupViewControllerDelegate : class {
    func onDidSelectDate(with date:Date)
}

class CalendarPopupViewController: BasePopupViewController {
    
    weak var delegate: CalendarPopupViewControllerDelegate?
    
    var onDidSelectDate:((_ date:Date) -> ())?
    var onDidSelectPeriodDate:((_ from:Date,_ to:Date) -> ())?
    
    fileprivate let HEIGHT_CALENDAR:CGFloat = 400
    fileprivate let TYPE_HEIGHT:CGFloat = XSize.H_BUTTON + XSize.P_CONS_DEF * 2
    
    fileprivate let panelShadowView:BasePanelShadowView = BasePanelShadowView()
    fileprivate var calendarCollectionView:CalendarCollectionView = CalendarCollectionView()
    fileprivate let showPriceView:ShowPriceCalendarView = ShowPriceCalendarView()
    fileprivate let noteDateView:TTBaseUIView = TTBaseUIView(withCornerRadius: XSize.CORNER_RADIUS)
    fileprivate let stackView:TTBaseUIStackView = TTBaseUIStackView(axis: .vertical, spacing: XSize.P_CONS_DEF, alignment: .fill)
    fileprivate let selectPeriodButton:TTBaseUIButton = TTBaseUIButton(textString: "Choose", type: .DEFAULT, isSetSize: false)
    
    fileprivate var viewModel:CalendarPopupViewModel = CalendarPopupViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewCodable(with: [self.panelShadowView])
    }
    
    init(withPeriodTime fromDate:Date?, toDate:Date?) {
        super.init(isAllowTouchPanel: true)
        self.viewModel = CalendarPopupViewModel(from: fromDate, to: toDate, departure: nil, destination: nil)
        self.viewModel.isSetPeriodTime = true
        self.calendarCollectionView = CalendarCollectionView(with: fromDate, to: toDate, isSkipToValidationPeriodTime: true)
    }
    
    init(with fromDate:Date?, toDate:Date?,  departure:Airport?, destination:Airport?) {
        super.init(isAllowTouchPanel: true)
        self.viewModel = CalendarPopupViewModel(from: fromDate, to: toDate, departure: departure, destination: destination)
        self.calendarCollectionView = CalendarCollectionView(with: fromDate, to: toDate)
    }
    
    
    init(forTrain fromDate:Date?, toDate:Date?,  departure:Airport?, destination:Airport?) {
        super.init(isAllowTouchPanel: true)
        self.viewModel = CalendarPopupViewModel(from: fromDate, to: toDate, departure: departure, destination: destination)
        self.calendarCollectionView = CalendarCollectionView(with: fromDate, to: toDate)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK:// For update UI
extension CalendarPopupViewController {
    func bindViewModel() {
        self.viewModel.willRefreshData = { [weak self] vm in guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                if vm.isSetPeriodTime {
                    if vm.fromDate == nil || vm.toDate == nil {
                        strongSelf.selectPeriodButton.setNonEnable()
                    } else {
                        strongSelf.selectPeriodButton.setEnable()
                    }
                    strongSelf.calendarCollectionView.onUpdateData(withFrom: vm.fromDate, to: vm.toDate)
                }
                strongSelf.calendarCollectionView.onRefresh()
            }
        }
    }
}

extension CalendarPopupViewController : TTViewCodable {
    
    func bindComponents() {
        self.calendarCollectionView.delegate = self
        self.showPriceView.didChangeSwitch = { [weak self] isOn in guard let strongSelf = self else { return }
            strongSelf.viewModel.isShowPrice = isOn
        }
        
        self.selectPeriodButton.onTouchHandler = {  [weak self] _ in guard let strongSelf = self else { return }
            guard let fromDate  = strongSelf.viewModel.fromDate else { return }
            guard let toDate  = strongSelf.viewModel.toDate else { return }
            strongSelf.onDidSelectPeriodDate?(fromDate, toDate)
            DispatchQueue.main.async { [weak self] in self?.dismiss(animated: true, completion: nil) }
        }
    }
    
    func setupBaseAPI() {
        self.viewModel.onFetchData()
    }
    
    func setupData() {

    }
    
    func setupStyles() {
        self.panelShadowView.newPanel.setBgColor(UIColor.white)
    }
    
    func setupCustomView() {
        self.panelShadowView.newPanel.addSubview(self.stackView)
        self.stackView.addArrangedSubview(self.calendarCollectionView)
        self.stackView.addArrangedSubview(self.selectPeriodButton)
        
    }
    
    func setupConstraints() {
        self.panelShadowView.setLeadingAnchor(constant: XSize.P_CONS_DEF).setTrailingAnchor(constant: XSize.P_CONS_DEF)
            .setcenterYAnchor(constant: 0)
        
        self.stackView.setFullContraints(constant: XSize.P_CONS_DEF)
        
        self.selectPeriodButton.setHeightAnchor(constant: XSize.H_BUTTON)
        self.showPriceView.setHeightAnchor(constant: self.TYPE_HEIGHT)
        self.noteDateView.setHeightAnchor(constant: XSize.H_BUTTON * 1.5)
        
    }
}

//MARK:// For Handle Show/Hidden Price
extension CalendarPopupViewController {
    fileprivate func onHandlePriceView() {
        
    }
}


//MARK:// For Handle Calendar
extension CalendarPopupViewController : CalendarCollectionViewDelegate {
    
    func onDidSelectedDate(with date: Date) {
        //Period Time select
        if self.viewModel.isSetPeriodTime {
            if self.viewModel.fromDate == nil || self.viewModel.toDate == nil {
                if !self.viewModel.isSetedFromDate {
                    self.viewModel.fromDate = date
                    self.viewModel.isSetedFromDate = true
                } else {
                    if let fromDate =  self.viewModel.fromDate {
                        let components = NSCalendar.current.dateComponents([.day], from: fromDate, to: date)
                        let dayPeiod:Int = components.day ?? 0
                        if dayPeiod > 15 { self.showNoticeView(body: "Time limit", style: .WARNING)}
                        if date.compareByDate(date: fromDate) == .orderedAscending || dayPeiod > 15  {
                            self.viewModel.isSetedFromDate = true
                            self.viewModel.fromDate = date
                            self.viewModel.toDate = nil
                        } else {
                            self.viewModel.toDate = date
                        }
                    } else {
                        self.viewModel.toDate = date
                    }
                }
            } else {
                self.viewModel.isSetedFromDate = true
                self.viewModel.fromDate = date
                self.viewModel.toDate = nil
            }
        } else { //Normal pick datetime
            self.onDidSelectDate?(date)
            DispatchQueue.main.async { [weak self] in self?.dismiss(animated: true, completion: nil) }
        }
    }
    
    func cellForItemAt(currentCell: CalendarCollectionViewCell, date: Date, indexPath: IndexPath) -> CalendarCollectionViewCell {
        if self.viewModel.isShowPrice {
            if let priceObject =  self.viewModel.onGetPriceByDate(with: date) {
                currentCell.luminarLable.setText(text: "0 $")
                currentCell.luminarLable.setTextColor(color: XView.labelBgDef.withAlphaComponent(0.6))
            }
        } else {
            currentCell.luminarLable.setTextColor(color: XView.textDefColor.withAlphaComponent(0.4))
            let luminarToDisplay:String? = TTVietNamLunar.convertSolar2LunarToDisplay(currentDate: date)
            currentCell.luminarLable.setText(text: luminarToDisplay ?? "N/A")
        }
        
        return currentCell
    }
    
    
}
