//
//  VietNamLunarManager.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 7/29/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation

open class TTVietNamLunar {
    
    static let PI:Double = Double.pi
    
    static func jdFromDate(dd:Int, mm:Int, yy:Int) -> Int {
        let a:Int = (14 - mm) / 12
        let y = yy+4800-a;
        let m = mm+12*a-3;
        var jd = dd + (153*m+2)/5 + 365*y + y/4 - y/100 + y/400 - 32045;
        if (jd < 2299161) {
            jd = dd + (153*m+2)/5 + 365*y + y/4 - 32083
        }
        return jd;
    }
    
    static func jdToDate(jd:Int) -> [Int] {
        var a:Int = 0, b:Int = 0, c:Int = 0
        if (jd > 2299160) { // After 5/10/1582, Gregorian calendar
            a = jd + 32044;
            b = (4*a+3)/146097;
            c = a - (b*146097)/4;
        } else {
            b = 0;
            c = jd + 32082;
        }
        let d:Int = (4*c+3)/1461;
        let e = c - (1461*d)/4;
        let m = (5*e+2)/153;
        let day = e - (153*m+2)/5 + 1;
        let month = m + 3 - 12*(m/10);
        let year = b*100 + d - 4800 + m/10;
        return [day, month, year]
    }
    
    static func NewMoonAA98(k:Int) -> Double {
        let T:Double  = Double.init(k)/1236.85 // Time in Julian centuries from 1900 January 0.5
        let T2 = T * T;
        let T3 = T2 * T;
        let dr = PI/180;
        var Jd1 = 2415020.75933 + 29.53058868 * Double.init(k)
        Jd1 = Jd1 + 0.0001178 * T2 - 0.000000155 * T3
        Jd1 = Jd1 + 0.00033*sin((166.56 + 132.87*T - 0.009173*T2)*dr) // Mean new moon
        var M = 359.2242 + 29.10535608*Double.init(k)
        M = M - 0.0000333*T2 - 0.00000347*T3 // Sun's mean anomaly
        
        var Mpr = 306.0253 + 385.81691806*Double.init(k)
        Mpr  = Mpr + 0.0107306*T2 + 0.00001236*T3 // Moon's mean anomaly
        
        var F = 21.2964 + 390.67050646*Double.init(k)
        F = F - 0.0016528*T2 - 0.00000239*T3 // Moon's argument of latitude
        var C1 = (0.1734 - 0.000393*T)*sin(M*dr)
        C1 = C1  + 0.0021*sin(2*dr*M)
        
        C1 = C1 - 0.4068*sin(Mpr*dr) + 0.0161*sin(dr*2*Mpr)
        C1 = C1 - 0.0004*sin(dr*3*Mpr)
        C1 = C1 + 0.0104*sin(dr*2*F) - 0.0051*sin(dr*(M+Mpr))
        C1 = C1 - 0.0074*sin(dr*(M-Mpr)) + 0.0004*sin(dr*(2*F+M))
        C1 = C1 - 0.0004*sin(dr*(2*F-M)) - 0.0006*sin(dr*(2*F+Mpr))
        C1 = C1 + 0.0010*sin(dr*(2*F-Mpr)) + 0.0005*sin(dr*(2*Mpr+M))
        var deltat:Double = 0
        if (T < -11) {
            deltat = 0.001 + 0.000839*T + 0.0002261*T2 - 0.00000845*T3 - 0.000000081*T*T3;
        } else {
            deltat = -0.000278 + 0.000265*T + 0.000262*T2;
        }
        let JdNew:Double = Jd1 + C1 - deltat;
        return JdNew;
    }
    
    static func NewMoon(k:Int) -> Double {
        return NewMoonAA98(k: k)
    }
    
    static func getNewMoonDay(k:Int, timeZone:Double) -> Int {
        let jd = NewMoon(k: k)
        return Int.init(jd + 0.5 + timeZone/24)
    }
    
    static func SunLongitude(jdn:Double) -> Double {
        return SunLongitudeAA98(jdn: jdn)
    }
    
    static func getSunLongitude(dayNumber:Int, timeZone:Double) -> Double {
        return SunLongitude(jdn: Double.init(dayNumber) - 0.5 - timeZone/24)
    }
    
    static func SunLongitudeAA98(jdn:Double) -> Double {
        let T = (jdn - 2451545.0 ) / 36525; // Time in Julian centuries from 2000-01-01 12:00:00 GMT
        let T2 = T*T;
        let dr = PI/180; // degree to radian
        let M = 357.52910 + 35999.05030*T - 0.0001559*T2 - 0.00000048*T*T2; // mean anomaly, degree
        let L0 = 280.46645 + 36000.76983*T + 0.0003032*T2; // mean longitude, degree
        var DL = (1.914600 - 0.004817*T - 0.000014*T2)*sin(dr*M)
        DL = DL + (0.019993 - 0.000101*T)*sin(dr*2*M) + 0.000290*sin(dr*3*M)
        var L = L0 + DL; // true longitude, degree
        L = L - Double.init(360*(Int.init(L/360))) // Normalize to (0, 360)
        return L
    }
    
    static func getLunarMonth11(yy:Int, timeZone:Double) -> Int{
        let off:Double = Double.init(jdFromDate(dd: 31, mm: 12, yy: yy)) - 2415021.076998695
        let k = Int.init(off / 29.530588853)
        var nm = getNewMoonDay(k: k, timeZone: timeZone);
        let sunLong = Int.init(getSunLongitude(dayNumber: nm, timeZone: timeZone)/30)
        if (sunLong >= 9) {
            nm = getNewMoonDay(k: k-1, timeZone: timeZone);
        }
        return nm
    }
    
    static func getLeapMonthOffset(a11:Int, timeZone:Double) -> Int {
        let k = Int.init(0.5 + (Double.init(a11) - 2415021.076998695) / 29.530588853)
        var last = 0 // Month 11 contains point of sun longutide 3*PI/2 (December solstice)
        var i = 1 // We start with the month following lunar month 11
        var arc = Int.init(getSunLongitude(dayNumber: getNewMoonDay(k: k+i, timeZone: timeZone), timeZone: timeZone)/30);
        repeat {
            last = arc;
            i = i + 1
            arc = Int.init(getSunLongitude(dayNumber: getNewMoonDay(k: k+i, timeZone: timeZone), timeZone: timeZone)/30);
        } while (arc != last && i < 14)
        return i-1;
    }

    
    
    
    /**
     *
     * @param dd
     * @param mm
     * @param yy
     * @param timeZone
     * @return array of [lunarDay, lunarMonth, lunarYear, leapOrNot]
     */
    
    public static func convertSolar2Lunar(currentDate:Date, timeZone:Double) -> [Int] {
        return TTVietNamLunar.convertSolar2Lunar(dd: currentDate.day(), mm: currentDate.month(), yy: currentDate.year(), timeZone: timeZone)
    }

    public static func convertSolar2Lunar(dd:Int, mm:Int, yy:Int, timeZone:Double) -> [Int] {
        var lunarDay:Int, lunarMonth:Int, lunarYear:Int, lunarLeap:Int
        let dayNumber = jdFromDate(dd: dd, mm: mm, yy: yy)
        let k = Int((Double.init(dayNumber) - 2415021.076998695) / 29.530588853)
        var monthStart = getNewMoonDay(k: k+1, timeZone: timeZone);
        if (monthStart > dayNumber) {
            monthStart = getNewMoonDay(k: k, timeZone: timeZone);
        }
        var a11 = getLunarMonth11(yy: yy, timeZone: timeZone)
        var b11 = a11
        if (a11 >= monthStart) {
            lunarYear = yy;
            a11 = getLunarMonth11(yy: yy-1, timeZone: timeZone);
        } else {
            lunarYear = yy+1;
            b11 = getLunarMonth11(yy: yy+1, timeZone: timeZone);
        }
        lunarDay = dayNumber-monthStart+1;
        let diff = Int.init((monthStart - a11)/29)
        lunarLeap = 0
        lunarMonth = diff+11
        if (b11 - a11 > 365) {
            let leapMonthDiff = getLeapMonthOffset(a11: a11, timeZone: timeZone);
            if (diff >= leapMonthDiff) {
                lunarMonth = diff + 10;
                if (diff == leapMonthDiff) {
                    lunarLeap = 1;
                }
            }
        }
        if (lunarMonth > 12) {
            lunarMonth = lunarMonth - 12;
        }
        if (lunarMonth >= 11 && diff < 4) {
            lunarYear -= 1;
        }
        return [ lunarDay, lunarMonth, lunarYear, lunarLeap]
    }
    
    
}


extension TTVietNamLunar {
    public static func convertSolar2LunarToDate(currentDate:Date, timeZone:Double = 7.0) -> Date? {
        let numArrs:[Int] = TTVietNamLunar.convertSolar2Lunar(currentDate: currentDate, timeZone: timeZone)
        if numArrs.isEmpty { return nil }
        let lunarString:String = "\(String(format: "%02.0f", Double.init(numArrs[0])))/\(String(format: "%02.0f", Double.init(numArrs[1])))/\(numArrs[2])"
        TTBaseFunc.shared.printLog(object: "CurrentDate: \(currentDate.dateString(withFormat: .DD_MM_YYYY)): -> Lunar: \(lunarString)")
        return lunarString.toDate(withFormat: .DD_MM_YYYY)
    }
}

