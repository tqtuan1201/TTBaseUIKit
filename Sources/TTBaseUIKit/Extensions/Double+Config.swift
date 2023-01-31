//
//  File.swift
//  
//
//  Created by Tuan Truong Quang on 1/31/23.
//

import Foundation

extension Double {
    ///Return format time by string
    ///
    ///10000.asString(style: .positional)  // 2:46:40
    ///
    ///10000.asString(style: .abbreviated) // 2h 46m 40s
    ///
    ///10000.asString(style: .short)       // 2 hr, 46 min, 40 sec
    ///
    ///10000.asString(style: .full)        // 2 hours, 46 minutes, 40 seconds
    ///
    ///10000.asString(style: .spellOut)    // two hours, forty-six minutes, forty seconds
    ///
    ///10000.asString(style: .brief)       // 2hr 46min 40sec
    public func asString(style: DateComponentsFormatter.UnitsStyle, locateString:String = "vi_VN") -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
        formatter.unitsStyle = style
        formatter.calendar?.locale = Locale(identifier: locateString)
        return formatter.string(from: self) ?? ""
    }
    
    public func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
            return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
     }
    
    public func secondsToHoursMinutesSeconds () -> String {
        let (hours, minutes, seconds) = self.secondsToHoursMinutesSeconds(seconds: Int(self))
        let hourDisplay:String = TTLanguageManager.shared.currentLanguage == .en ? "h" :"giờ"
        let minDisplay:String = TTLanguageManager.shared.currentLanguage == .en ? "min" :"phút"
        let secDisplay:String = TTLanguageManager.shared.currentLanguage == .en ? "sec" :"giây"
        var str = hours > 0 ? "\(hours) \(hourDisplay)" : ""
        str = minutes > 0 ? str + " \(minutes) \(minDisplay)" : str
        str = seconds > 0 ? str + " \(seconds) \(secDisplay)" : str
        return str
    }
}
