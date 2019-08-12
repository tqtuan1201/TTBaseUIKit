//
//  Date+Config.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 5/21/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation

extension Date {
    
    public func compareByDate(date:Date) -> ComparisonResult {
        return Calendar.current.compare(self, to: date, toGranularity: .day)
    }
    
    public func sameDate(date:Date) -> Bool {
        let order = Calendar.current.compare(self, to: date, toGranularity: .day)
        switch order {
        case .orderedSame:
            return true
        default:
            return false
        }
    }
    
    public func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    public func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    public func monthName(with locate:Locale = Locale.init(identifier :  "vi_VN")) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locate
        dateFormatter.dateFormat = CONSTANT.FORMAT_DATE.MMMM.rawValue
        return dateFormatter.string(from: self).capitalizingFirstLetter()
    }
    
    public func getDateWithEvenTime(byPeriod interval:Int) -> Date {
        let calendar = Calendar.current
        let nextDiff = interval - (calendar.component(.minute, from: self) % interval)
        return calendar.date(byAdding: .minute, value: nextDiff, to: self) ?? Date()
    }
    
    public  func getDateWithEvenTimeWithSecondRounding(byPeriod interval:Int) -> Date {
        let calendar = Calendar.current
        let nextDiff = interval - (calendar.component(.minute, from: self) % interval)
        let dateAddInterVal = calendar.date(byAdding: .minute, value: nextDiff, to: self) ?? Date()
        return calendar.date(bySettingHour: dateAddInterVal.hour(), minute: dateAddInterVal.minute(), second: 0, of: dateAddInterVal) ?? Date()
    }
    
    public func getAllDateOfMonth(with currentDate:Date) -> ([Date],Int) {
        
        var days      = [Date]()
        var index:Int = -1
        
        let calendar = Calendar.current
        guard let range = calendar.range(of: .day, in: .month, for: self) else {return (days,0)}
        var day = self.firstDayOfMonth()
        for count in 0 ..< range.count
        {
            days.append(day)
            if Calendar.current.compare(day, to: currentDate, toGranularity: .day)  == ComparisonResult.orderedSame {
                index = count
            }
            day = day.dateByAddingDays(1)
        }
        return (days,index)
    }
    
    public func getNextMonth() -> Date {
        return (Calendar.current.date(byAdding: .month, value: 1, to: self.firstDayOfMonth()) ?? Date() )
    }
    
    public func getPreviousMonth() -> Date {
        return ( Calendar.current.date(byAdding: .month, value: -1, to: self.firstDayOfMonth()) ?? Date() )
    }
    
    public func dateString(withFormat format: CONSTANT.FORMAT_DATE) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: self)
    }
    
    public func firstDayOfMonth () -> Date {
        let calendar = Calendar.current
        var dateComponent = (calendar as NSCalendar).components([.year, .month, .day ], from: self)
        dateComponent.day = 1
        return calendar.date(from: dateComponent)!
    }
    
    public init(year : Int, month : Int, day : Int) {
        
        let calendar = Calendar.current
        var dateComponent = DateComponents()
        dateComponent.year = year
        dateComponent.month = month
        dateComponent.day = day
        self.init(timeInterval: 0, since: calendar.date(from: dateComponent)!)
    }
    
    public func dateByAddingMonths(_ months : Int ) -> Date {
        let calendar = Calendar.current
        var dateComponent = DateComponents()
        dateComponent.month = months
        return (calendar as NSCalendar).date(byAdding: dateComponent, to: self, options: NSCalendar.Options.matchNextTime)!
    }
    
    public func dateByAddingDays(_ days : Int ) -> Date {
        let calendar = Calendar.current
        var dateComponent = DateComponents()
        dateComponent.day = days
        return (calendar as NSCalendar).date(byAdding: dateComponent, to: self, options: NSCalendar.Options.matchNextTime)!
    }
    
    public func dateByAddingHours(_ hours : Int ) -> Date {
        let calendar = Calendar.current
        var dateComponent = DateComponents()
        dateComponent.hour = hours
        return (calendar as NSCalendar).date(byAdding: dateComponent, to: self, options: NSCalendar.Options.matchNextTime)!
    }
    
    public func dateByAddingMinutes(_ minutes : Int ) -> Date {
        let calendar = Calendar.current
        var dateComponent = DateComponents()
        dateComponent.minute = minutes
        return (calendar as NSCalendar).date(byAdding: dateComponent, to: self, options: NSCalendar.Options.matchNextTime)!
    }
    
    public func hour() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.hour, from: self)
        return dateComponent.hour!
    }
    
    public func second() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.second, from: self)
        return dateComponent.second!
    }
    
    public func minute() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.minute, from: self)
        return dateComponent.minute!
    }
    
    public func day() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.day, from: self)
        return dateComponent.day!
    }
    
    public func weekday() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.weekday, from: self)
        return dateComponent.weekday!
    }
    
    public func month() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.month, from: self)
        return dateComponent.month!
    }
    
    public func year() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.year, from: self)
        return dateComponent.year!
    }
    
    public func numberOfDaysInMonth() -> Int {
        let calendar = Calendar.current
        let days = (calendar as NSCalendar).range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: self)
        return days.length
    }
    
    public func dateByIgnoringTime() -> Date {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components([.year, .month, .day ], from: self)
        return calendar.date(from: dateComponent)!
    }
    
    public func monthNameFull(with locate:Locale = Locale(identifier: "vi_VN")) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locate
        dateFormatter.dateFormat = CONSTANT.FORMAT_DATE.MMMMYYYY.rawValue
        return dateFormatter.string(from: self)
    }
    
    public func isSunday() -> Bool
    {
        return (self.getWeekday() == 1)
    }
    
    public func isMonday() -> Bool
    {
        return (self.getWeekday() == 2)
    }
    
    public func isTuesday() -> Bool
    {
        return (self.getWeekday() == 3)
    }
    
    public func isWednesday() -> Bool
    {
        return (self.getWeekday() == 4)
    }
    
    public func isThursday() -> Bool
    {
        return (self.getWeekday() == 5)
    }
    
    public func isFriday() -> Bool
    {
        return (self.getWeekday() == 6)
    }
    
    public func isSaturday() -> Bool
    {
        return (self.getWeekday() == 7)
    }
    
    public func getWeekday() -> Int {
        let calendar = Calendar.current
        return (calendar as NSCalendar).components( .weekday, from: self).weekday!
    }
    
    public func isToday() -> Bool {
        return self.isDateSameDay(Date())
    }
    
    public func isDateSameDay(_ date: Date) -> Bool {
        
        return (self.day() == date.day()) && (self.month() == self.month() && (self.year() == date.year()))
        
    }
}

public func ==(lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) == ComparisonResult.orderedSame
}

public func <(lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) == ComparisonResult.orderedAscending
}

public func >(lhs: Date, rhs: Date) -> Bool {
    return rhs.compare(lhs) == ComparisonResult.orderedAscending
}


