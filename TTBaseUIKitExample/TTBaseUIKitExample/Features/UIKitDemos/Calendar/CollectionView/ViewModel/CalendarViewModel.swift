//
//  CalendarViewModel.swift
//  12BayV2
//
//  Created by Tuan Truong Quang on 8/1/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation

class CalendarViewModel {
    
    var isSkipToValidationSelectPeriodTime:Bool = false
    
    var fromDate:Date?
    var periodDate:Date?
    
    let currentDateSave:Date
    var currentDate:Date = Date() {
        didSet {
            self.createDayByMonth()
        }
    }
    var limitYear:Int = 2
    
    var dayByMonth:([Date],Int) = ([],-1)
    
    var day:[Date] = [] {
        didSet {
            self.willRefreshData?(self)
        }
    }
    
    init() {
        let currentDate = Date()
        self.currentDate = currentDate
        self.currentDateSave = currentDate
    }
    
    init(with fromDate:Date?, toDate:Date?, isSkipValidation:Bool) {
        self.currentDate = Date()
        self.currentDateSave = self.currentDate
        self.fromDate = fromDate
        self.periodDate = toDate
        self.isSkipToValidationSelectPeriodTime = isSkipValidation
        self.isValidationPeriodTime()
        self.createDayByMonth()
    }
    
    var willRefreshData:( (_ vm:CalendarViewModel) -> () )?
    
}

// For Enable Next or preview month
extension CalendarViewModel {
    
    func isEnablePreMonth() -> Bool {
        let preMonth = self.currentDate.dateByAddingMonths(-1)
        if self.currentDateSave.compareByDate(date: preMonth) == .orderedDescending { return false }
        return true
    }
    
    func isEnableNextMonth() -> Bool {
        let limitDate:Date = self.currentDateSave.dateByAddingMonths(self.limitYear * 12)
        if self.currentDate.compareByDate(date: limitDate) != .orderedDescending { return true }
        return false
    }
}

// For Base config Calendar
extension CalendarViewModel {
    
    func isEnableDayForCalendar(with currentDate:Date) ->  Bool {
        return (currentDate.compareByDate(date: self.currentDateSave) != .orderedAscending)
    }
    
    func isEnableDayForCurrentMonth(with date:Date) -> Bool {
        return ( self.currentDate.month() == date.month())
    }
}

extension CalendarViewModel {
    
    func isValidationPeriodTime() {
        guard let fromDate = self.fromDate else { return }
        guard let toDate = self.periodDate else { return }
        
        if fromDate.compareByDate(date: toDate) == .orderedDescending {
            self.periodDate = fromDate.dateByAddingDays(2)
        }
    }
    
    func isValidationSelected(with newToDate:Date) -> Bool {
        
        if self.periodDate == nil { // For only TO date
            if self.currentDateSave.compareByDate(date: newToDate) == .orderedDescending { return false }
            return true
            
        } else { // For select period date FROM-TO
            if self.isSkipToValidationSelectPeriodTime {
                return true
            } else {
                guard let fromDate:Date = self.fromDate else { return true }
                if fromDate.compareByDate(date: newToDate) != .orderedDescending { return true}
                return false
            }
        }
    }
    
    func isCurrentDate(with date:Date) -> Bool {
        return self.currentDateSave.sameDate(date: date)
    }

    func isFromDate(with date:Date) -> Bool {
        guard let fromDate = self.fromDate else { return false }
        return fromDate.sameDate(date: date)
    }
    
    func isPeriodDate(with date:Date) -> Bool {
        guard let periodDate = self.periodDate else { return false }
        return periodDate.sameDate(date: date)
    }
    
    func isInPeriodTime( date:Date ) ->  Bool {
        guard let fromDate = self.fromDate else { return false }
        guard let periodDate = self.periodDate else { return false }
        return (date.compareByDate(date: fromDate) == .orderedDescending && date.compareByDate(date: periodDate) == .orderedAscending)
    }
    
    func isPreMonth(with currentDate:Date) -> Bool {
        return (self.currentDateSave.firstDayOfMonth().compareByDate(date: currentDate) == .orderedDescending)
    }
    
    func isCurrentMonth(with currentDate:Date) -> Bool {
        return (self.currentDateSave.month() == currentDate.month())
    }
    
    func getMonthToDisplay() -> String {
        return self.currentDate.monthNameFull().uppercased()
    }
    
    func goNextMonth() {
        let litmitMonth = self.currentDateSave.dateByAddingMonths(self.limitYear * 12)
        if self.currentDate.compareByDate(date: litmitMonth) == .orderedDescending { return}
        self.currentDate =  self.currentDate.dateByAddingMonths(1)
    }
    
    func goToPreviewMonthHasSelected(withDateSelect date:Date) {
        self.currentDate = date
    }
    
    func goPreMonth() {
        let preMonth = self.currentDate.dateByAddingMonths(-1)
        if self.currentDateSave.compareByDate(date: preMonth) == .orderedDescending { return}
        self.currentDate =  self.currentDate.dateByAddingMonths(-1)
    }
    
    fileprivate func createDayByMonth() {
        
        var addPreDay:Int = 0
        let firstDayOfMonth = self.currentDate.firstDayOfMonth()
        if firstDayOfMonth.isMonday() {
            addPreDay = 0
        } else if firstDayOfMonth.isTuesday() {
            addPreDay = 1
        } else if firstDayOfMonth.isWednesday() {
            addPreDay = 2
        } else if firstDayOfMonth.isThursday() {
            addPreDay = 3
        } else if firstDayOfMonth.isFriday() {
            addPreDay = 4
        } else if firstDayOfMonth.isSaturday() {
            addPreDay = 5
        } else if firstDayOfMonth.isSunday() {
            addPreDay = 6
        }
        
        var dayPreMonths:[Date] = []
        for i in 0 ..< addPreDay {
            dayPreMonths.append(firstDayOfMonth.dateByAddingDays(-i - 1))
        }
        
        self.dayByMonth = self.currentDate.getAllDateOfMonth(with: self.currentDate)
        self.day = dayPreMonths.reversed() + dayByMonth.0
        
        
    }
}

//MARK: Base funcs
extension CalendarViewModel {
    
    func isShowEmptyDataSource() -> Bool { return self.day.isEmpty }
    
    func getItemByIndexPath(index:IndexPath) -> Date? {
        let day =  self.day
        if day.indices.contains(index.row) { return day[index.row]}
        return nil
    }
    
    func numberOfItemsToDisplay(session:Int) -> Int {
        return self.day.count
    }
    
    func numberOfSections() -> Int {
        return 1
    }
}

