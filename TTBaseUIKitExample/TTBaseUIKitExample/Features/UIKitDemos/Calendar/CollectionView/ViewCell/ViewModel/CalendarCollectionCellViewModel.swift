//
//  CalendarCollectionCellViewModel.swift
//  12BayV2
//
//  Created by Tuan Truong Quang on 8/1/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import TTBaseUIKit

struct CalendarCollectionCellViewModel {
    let date:Date
    let vm:CalendarViewModel
}


extension CalendarCollectionCellViewModel : CalendarCollectionViewCellRepresentable {
    
    var dayString: String {
        return String(self.date.day())
    }
    
    var luminarString: String {
        return TTVietNamLunar.convertSolar2LunarToDisplay(currentDate: self.date) ?? "N/A"
    }
    
    var isEnable: Bool {
        return (self.vm.isEnableDayForCalendar(with: self.date) && self.vm.isEnableDayForCurrentMonth(with: self.date))
    }
    
    var isShowCurrentDateCircle: Bool {
        return self.vm.isCurrentDate(with: self.date)
    }
    
    var isShowPeriodCircle: Bool {
        return ( self.vm.isFromDate(with: self.date) || self.vm.isPeriodDate(with: self.date))
    }
    
    var isAddLineView: Bool {
        return self.vm.isInPeriodTime(date: self.date)
    }
    
    var isShowFromRootView: Bool {
        return (self.vm.isFromDate(with: self.date) && self.vm.periodDate != nil)
    }
    
    var isShowToRootView: Bool {
        return (self.vm.isPeriodDate(with: self.date)  && self.vm.periodDate != nil)
    }
}
