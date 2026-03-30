//
//  CalendarPopupViewModel.swift
//  12BayV2
//
//  Created by Tuan Truong Quang on 8/5/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation

class CalendarPopupViewModel {
 
    fileprivate var isFetching:Bool = false
    
    var isSetPeriodTime:Bool = false
    var isSetedFromDate:Bool = false
    
    var isShowPrice:Bool = false {
        didSet {
            if self.priceByMonth == nil {
                self.onChangeShowPriceHandle()
            } else {
                self.willRefreshData?(self)
            }
        }
    }
    
    var priceByMonth:[Int:[PriceByPeriod]]? = nil {
        didSet { self.willRefreshData?(self) }
    }
    
    var fromDate:Date? {
        didSet {
            if self.isSetPeriodTime {
                self.willRefreshData?(self)
            }
        }
    }
    
    var toDate:Date? {
        didSet {
            if self.isSetPeriodTime {
                self.willRefreshData?(self)
            }
        }
    }
    
    var departure:Airport?
    var destination:Airport?
    
    var didReceiptPrice:((_ priceByMonth:[Int:[PriceByPeriod]])->())?
    var willRefreshData:( (_ vm:CalendarPopupViewModel) -> () )?
    
    
    init() {}
    
    init(from:Date?, to:Date?, departure:Airport?, destination:Airport?) {
        self.fromDate = from
        self.toDate = to
        self.departure = departure
        self.destination = destination
    }
    
}
//MARK:// For Base funcs

extension CalendarPopupViewModel {
    fileprivate func onChangeShowPriceHandle() {
        if self.isShowPrice {
            if self.priceByMonth == nil { self.onFetchData() }
        }
    }
    
    func onGetPriceByDate(with date:Date) -> PriceByPeriod? {
    return nil
    }
}

extension CalendarPopupViewModel {
    
    func onFetchData() {
    }
}

struct PriceByPeriod {
    
}

struct Airport {
    
}
