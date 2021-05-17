//
//  File.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/03/19.
//

import Foundation

// MARK: - Date -> Date
extension Date {
    func advanceTheTimeHH(_ HH: Int) -> Date {
        let calendar = Calendar.current
        let comps = DateComponents(hour: HH)
        let res = calendar.date(byAdding: comps, to: self)
        return res!
    }
}

// MARK: - Date -> String
extension Date {
    
    func dateToSimpleStringFormat() -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyyMMddHHmmss"
        // 20210317172421
        let nowString = f.string(from: self)
        return nowString
    }
    
    func dateToString() -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy/MM/dd HH:mm:ss"
        // 2021/3/17 17:24:21
        let nowString = f.string(from: self)
        return nowString
    }
    
    func dateToStringYMD() -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy/MM/dd"
        // 2021/3/17
        let result = f.string(from: self)
        return result
    }
    
    func dateToStringJa() -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy年 MM月 dd日"
        // 2021/3/17
        let result = f.string(from: self)
        return result
    }
    
    func nowDateToString() -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let now = Date()
        // 2021/3/17 17:24:21
        let nowString = f.string(from: now)
        return nowString
    }
}


// MARK: - String -> Date

extension String {
    func stringToDate() -> Date {
        let f = DateFormatter()
        f.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let date = f.date(from: self)
        return date!
    }
}


// MARK: - StringDate -> Expected StringDate Format

    func separateStringDate(time: String) -> Array<String> {
        let arr = time.components(separatedBy: " ")
        let YMD = arr[0].components(separatedBy: "/")
        let hms = arr[1].components(separatedBy: ":")
        let res = YMD + hms
        return res
    }

    func todaysDayOfTheWeek() -> String {
        let calendar = Calendar.current
        let date = Date()
        let weekkay = calendar.component(.weekday, from: date)
        let res = calendar.shortStandaloneWeekdaySymbols[weekkay]
        return res.lowercased() // mon, tue, wed, ...
    }

    // check to see if the store is closed
    func pastOrFutureInHour(_ closeTime: Int) -> Bool {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let diff = closeTime - hour
        if diff > 0 {
            return true
        }
        return false
    }

    // Output the time few minutes later.
    func mmssLaterFromNow(_ minute: Int) -> String {
        let calender = Calendar.current
        let comps = DateComponents(minute: minute)
        let f = DateFormatter()
        f.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let now = Date()
        let laterDate = calender.date(byAdding: comps, to: now)
        let res = laterDate!.dateToString()
        return res
    }

extension String {
    func convertToHHmm() -> String {
        let arr = separateStringDate(time: self)
        return arr[3] + ":" + arr[4]
    }
    
    func mmssTossInt() -> Int {
        let now = Date()
        let calender = Calendar.current
        var comps: DateComponents
        comps = calender.dateComponents([.second], from: now, to: self.stringToDate())
        let res = comps.second!
        return res
    }
    
    // return false if self is in the  past  than the current time
    // return true  if self is in the future than the current time
    // use before the calcHowManymmss function ↓
    func pastOrFuture() -> Bool {
        let calender = Calendar.current
        var comps: DateComponents
        let date = self.stringToDate()
        let now = Date()
        comps = calender.dateComponents([.second], from: now, to: date)
        if comps.second! > 0 {
            return true
        }
        return false
    }
    
    // use after the pastOrFuture() function ↑
    func calcTimeLimitmmss() -> String {
        let calender = Calendar.current
        var comps: DateComponents
        let date = self.stringToDate()
        let now = Date()
        comps = calender.dateComponents([.minute, .second], from: now, to: date)
        let res = String(comps.minute!) + "分" + String(comps.second!) + "秒"
        return res // is mm:ss
    }
    
}
