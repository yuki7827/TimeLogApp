//
//  DateUtil.swift
//  TimeLogApp
//
//  Created by 福島友稀 on 2020/04/16.
//  Copyright © 2020 Baminami. All rights reserved.
//

import UIKit

class DateUtil {
    /**
     startから本日までの日付を配列で返す
    */
    static func getDaysArrayToToday(start:String ,max:Int) -> [String] {

        var result:[String] = []
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
        formatter.dateFormat = "yyyy-MM-dd"

        // 今日
        let todayStr = formatter.string(from: Date())
        let startDate = formatter.date(from: start)!

        var components = DateComponents()
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)

        for i in 0 ..< max {

            components.setValue(i,for: Calendar.Component.day)
            let wk = calendar.date(byAdding: components, to: startDate)!
            let wkStr = formatter.string(from: wk)
            if wkStr > todayStr {
                break
            } else {
                result.append(wkStr)
            }
        }
        return result
    }

}
