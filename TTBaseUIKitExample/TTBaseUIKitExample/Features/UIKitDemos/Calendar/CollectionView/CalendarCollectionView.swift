//
//  CalendarCollectionView.swift
//  12BayV2
//
//  Created by Tuan Truong Quang on 8/1/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import TTBaseUIKit



@objc protocol CalendarCollectionViewDelegate : AnyObject {
    @objc optional func onDidSelectedDate(with date:Date)
    @objc optional func cellForItemAt(currentCell:CalendarCollectionViewCell, date:Date, indexPath: IndexPath) -> CalendarCollectionViewCell
}

class CalendarCollectionView: TTBaseUIView {
    
    weak var delegate: CalendarCollectionViewDelegate?
    
    fileprivate let HEIGHT_DATEVIEW:CGFloat =  UIDevice.current.userInterfaceIdiom == .pad ? 55.0 : 45.0
    fileprivate let HEIGHT_CALENDAR:CGFloat = (UIDevice.current.userInterfaceIdiom == .pad ? 55.0 : 45.0) * 6
    
    fileprivate var viewModel:CalendarViewModel = CalendarViewModel()
    
    fileprivate let monthView:MonthView = MonthView()
    fileprivate let weekView:WeekView = WeekView()
    
    fileprivate let calendarCollectionView:TTBaseUICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        
        let cv = TTBaseUICollectionView(collectionViewLayout: layout, bgColor: UIColor.clear, isShowCroll: false, isSetContent: false)
        cv.register(CalendarCollectionViewCell.self)
        return cv
    }()
    
    var didSelectedDate:((_ date:Date) -> ())?
    var cellForDateAt:((_ cell:CalendarCollectionViewCell) -> CalendarCollectionViewCell)?

    required init() {
        super.init()
        self.setupViewCodable(with: [self.monthView, self.weekView, self.calendarCollectionView])
    }
    
    init(with from:Date?, to:Date?, isSkipToValidationPeriodTime:Bool = false) {
        super.init()
        
        self.viewModel = CalendarViewModel(with: from, toDate: to, isSkipValidation: isSkipToValidationPeriodTime)
        self.setupViewCodable(with: [self.monthView, self.weekView, self.calendarCollectionView])
        
        
        if let toDate:Date = self.viewModel.periodDate {
            if toDate.month() != Date().month() {
                self.viewModel.goToPreviewMonthHasSelected(withDateSelect: toDate)
            }
        } else {
            if self.viewModel.fromDate?.month() != Date().month() {
                let toToDate:Date = self.viewModel.periodDate ?? (self.viewModel.fromDate ?? Date())
                self.viewModel.goToPreviewMonthHasSelected(withDateSelect: toToDate)
            }
        }
    }
}

//MARK:// For base funcs
extension CalendarCollectionView {
    public func onRefresh() {
        self.calendarCollectionView.reloadAsyncData()
    }
    
    func onUpdateData(withFrom from:Date?, to:Date?) {
        self.viewModel.fromDate = from
        self.viewModel.periodDate = to
    }
    
}

//MARK:// Swipe left - right handle
extension CalendarCollectionView {
    @objc fileprivate func swipeMade(_ sender:UISwipeGestureRecognizer) {
        if sender.direction == .left {
            self.viewModel.goNextMonth()
        }
        if sender.direction == .right {
            self.viewModel.goPreMonth()
        }
    }
}

//MARK:// TTViewCodable
extension CalendarCollectionView : TTViewCodable {

    func setupData() {
        self.calendarCollectionView.delegate = self
        self.calendarCollectionView.dataSource = self
        
        let leftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeMade(_:)))
        let rightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeMade(_:)))
    
        leftRecognizer.direction = .left
        rightRecognizer.direction = .right
        
        self.calendarCollectionView.addGestureRecognizer(leftRecognizer)
        self.calendarCollectionView.addGestureRecognizer(rightRecognizer)
    }
    
    func setupStyles() {
        self.setBgColor(UIColor.white)
        self.calendarCollectionView.setBgColor(color: UIColor.clear)
    }
    
    func bindViewModel() {
        self.viewModel.willRefreshData = { [weak self] vm in guard let strongSelf = self else { return }
            strongSelf.calendarCollectionView.reloadAsyncData()
            DispatchQueue.main.async {
                //Update Header month text
                strongSelf.monthView.nameMonthLabel.setText(text: vm.getMonthToDisplay())
                //Update PRE/NEXT button
                if vm.isEnablePreMonth() { strongSelf.monthView.setBackEnable() } else {strongSelf.monthView.setBackNonEnable() }
                if vm.isEnableNextMonth() { strongSelf.monthView.setNextEnable() } else {strongSelf.monthView.setNextNonEnable() }
            }
        }
    }
    
    func bindComponents() {
        self.monthView.backIconView.setTouchHandler().onTouchHandler = { [weak self] _ in guard let strongSelf = self else { return }
            strongSelf.viewModel.goPreMonth()
        }
        
        self.monthView.nextIconView.setTouchHandler().onTouchHandler = { [weak self] _ in guard let strongSelf = self else { return }
            strongSelf.viewModel.goNextMonth()
        }
    }
    
    func setupConstraints() {
        
        self.monthView.setLeadingAnchor(constant: XSize.P_CONS_DEF * 2 ).setTopAnchor(constant: XSize.P_CONS_DEF).setTrailingAnchor(constant: XSize.P_CONS_DEF * 2).setHeightAnchor(constant: XSize.H_BUTTON)
        
        self.weekView.setLeadingAnchor(constant: 0 ).setTopAnchorWithAboveView(nextToView: self.monthView, constant: XSize.P_CONS_DEF).setTrailingAnchor(constant: 0).setHeightAnchor(constant: XSize.H_BUTTON)
        
        self.calendarCollectionView.setLeadingAnchor(constant: 0).setTopAnchorWithAboveView(nextToView: self.weekView, constant: 0)
            .setTrailingAnchor(constant: 0).setHeightAnchor(constant: self.HEIGHT_CALENDAR).setBottomAnchor(constant: XSize.P_CONS_DEF)
    }
}


extension CalendarCollectionView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 7, height: self.HEIGHT_DATEVIEW)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        if self.viewModel.numberOfItemsToDisplay(session: 1) > 35 {
//            DispatchQueue.main.async { self.calendarCollectionView.setHeightAnchor(true, constant: self.HEIGHT_DATEVIEW * 6) ; self.updateConstraints() }
//        } else {
//            DispatchQueue.main.async { self.calendarCollectionView.setHeightAnchor(true, constant: self.HEIGHT_DATEVIEW * 5); self.updateConstraints()}
//        }
        return self.viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsToDisplay(session: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CalendarCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        guard let day = self.viewModel.getItemByIndexPath(index: indexPath) else { return cell}
        
        let cellViewModel:CalendarCollectionViewCellRepresentable? = CalendarCollectionCellViewModel(date: day, vm: self.viewModel)
        if let cellViewModel = cellViewModel {cell.configure(withRepresentable: cellViewModel)}
        if let customCell = self.delegate?.cellForItemAt?(currentCell: cell, date: day, indexPath: indexPath) { return customCell }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let day = self.viewModel.getItemByIndexPath(index: indexPath) else { return }
        if self.viewModel.isValidationSelected(with: day) {
            DispatchQueue.main.async {
                self.isUserInteractionEnabled = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.isUserInteractionEnabled = true
                    self.didSelectedDate?(day); self.delegate?.onDidSelectedDate?(with: day)
                }
            }
        }
    }
    
}
